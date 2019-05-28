package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Base64;
import android.view.KeyEvent;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.github.lzyzsd.jsbridge.CallBackFunction;
import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MyWebViewClient;
import com.jizhi.jlongg.main.util.UtilFile;
import com.lidroid.xutils.ViewUtils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;


/**
 * 功能: 我的资料页面使用jsbrage
 * 作者：huchangsheng
 * 时间: 2016-3-15 11:51
 */
public class UserInfoBrageActivity extends BaseActivity implements MyWebViewClient.LoadEndingListener {
    private UserInfoBrageActivity mActivity;
    private BridgeWebView webView;
    private String headPath;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_jsbrage);
        ViewUtils.inject(this);
        webView = (BridgeWebView) findViewById(R.id.webView);
        mActivity = UserInfoBrageActivity.this;
        final String title = getIntent().getStringExtra("title");
        if (!TextUtils.isEmpty(title)) {
            ((TextView) findViewById(R.id.title)).setText(title);
        } else {
            findViewById(R.id.rea_top).setVisibility(View.GONE);
        }


        String url = getIntent().getStringExtra("url");
        if (url != null && !url.equals("")) {
            webView.clearCache(true);
            webView.clearHistory();
            Utils.synCookies(mActivity, url);
            webView.loadUrl(url);
        } else {
            mActivity.finish();
        }
        webView.callHandler("getMobileInformation", AppUtils.getMobileInfo(mActivity), new CallBackFunction() {
            @Override
            public void onCallBack(String data) {

            }
        });


    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
//        File destDir = new File(UtilFile.JGJIMAGEPATH);// 文件目录
//        if (destDir.exists()) {// 判断目录是否存在，不存在创建
//            UtilFile.RecursionDeleteFile(destDir);
//        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE) { //选择照片回调
            if (resultCode == RESULT_OK) {
                List<String> strings = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
                doCropPhoto(strings.get(0));
            }
        } else if (requestCode == CameraPop.IMAGE_CROP && resultCode == RESULT_OK) { //裁剪相册回调
            try {
                Object[] object = UtilFile.saveBitmapToFile(headPath);
                String str = (String) object[0];
                Bitmap headBitmap = (Bitmap) object[1];
                if (headBitmap != null) {
                    upPic(str, headBitmap);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.SUCCESS) { //新建班组成功回调
            setResult(Constance.SUCCESS);
            finish();
        }

    }

    private boolean isChangeHead = false;

    private void upPic(String img_path, Bitmap Bitmap) {
        File file = new File(img_path);
        int dot = file.getName().lastIndexOf('.');
        if ((dot > -1) && (dot < (file.getName().length() - 1))) {
            String endStr = file.getName().substring(dot + 1);
            if (null != Bitmap) {
                sureChangeHeader("data:image/" + endStr + ";base64," + Bitmap2StrByBase64(Bitmap));
                isChangeHead = true;
            } else {
                CommonMethod.makeNoticeLong(mActivity, "图片加载失败", CommonMethod.ERROR);
            }
        } else {
            CommonMethod.makeNoticeLong(mActivity, "图片加载失败", CommonMethod.ERROR);
        }

    }

    public void sureChangeHeader(String base64) {
        LUtils.e("---base64--：" + new Gson().toJson(new HeadPic(base64)));
        webView.callHandler("sureChangeHeader", new Gson().toJson(new HeadPic(base64)), new CallBackFunction() {
            @Override
            public void onCallBack(String data) {
                Toast.makeText(mActivity, "成功", Toast.LENGTH_SHORT).show();
            }
        });
    }

    public class HeadPic {
        private String headpic;

        public HeadPic(String headpic) {
            this.headpic = headpic;
        }

        public String getHeadpic() {
            return headpic;
        }

        public void setHeadpic(String headpic) {
            this.headpic = headpic;
        }
    }

    public String Bitmap2StrByBase64(Bitmap bit) {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        bit.compress(Bitmap.CompressFormat.JPEG, 40, bos);// 参数100表示不压缩
        byte[] bytes = bos.toByteArray();
        return Base64.encodeToString(bytes, Base64.DEFAULT);
    }
//    /**
//     * 修改头像
//     */
//    public void UpHead(final String path) {
//        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
//        params.addBodyParameter("head_pic", new File(path));
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFYHEADPIC,
//                params, new RequestCallBackExpand<Object>() {
//                    @Override
//                    public void onSuccess(ResponseInfo<String> responseInfo) {
//                        try {
//                            Gson gson = new Gson();
//                            UpHeadState bean = gson.fromJson(responseInfo.result, UpHeadState.class);
//                            if (bean.getState() != 0) {
//                                if (null != bean.getValues() && null != bean.getValues().getImgpath()) {
//                                    isRefreshHead = true;
//                                    headPath = bean.getValues().getImgpath();
//                                    webView.loadUrl("javascript:getNewHeadPicture('" + headPath + "')");
//                                } else {
//                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), "上传失败");
//                                }
//                            } else {
//                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
//                            }
//                        } catch (Exception e) {
//                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
//                        }
//                        closeDialog();
//                    }
//                }
//        );
//    }


    /**
     * 裁剪相片
     */
    public void doCropPhoto(String path) {
        File directorFile = new File(UtilFile.JGJIMAGEPATH + File.separator + "Head");
        if (!directorFile.exists()) {
            directorFile.mkdirs();
        }
        String cropPath = directorFile.getAbsolutePath() + File.separator + "tempHead" + path.substring(path.lastIndexOf(".")); //裁剪图片新生成的图片路径
        File cropFile = new File(cropPath);
        if (cropFile.exists()) {
            cropFile.delete();
        }
        try {
            headPath = cropPath;
            // 启动gallery去剪辑这个照片
            Intent intent = UtilFile.getCropImageIntent(new File(path), new File(cropPath));
            startActivityForResult(intent, CameraPop.IMAGE_CROP);
        } catch (Exception e) {
            Toast.makeText(mActivity, "获取照片错误", Toast.LENGTH_LONG).show();
        }
    }


    @Override
    public void loadEnding(String url) {
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && webView.canGoBack()) {
            webView.goBack();
            return true;

        }
//        if (isChangeHead) {
        setResult(Constance.INFOMATION, getIntent());
//            return true;
//        }
        return super.onKeyDown(keyCode, event);
    }
}
