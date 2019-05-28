//package com.jizhi.jlongg.main.activity;
//
//import android.content.Context;
//import android.content.Intent;
//import android.graphics.Bitmap;
//import android.os.Bundle;
//import android.view.KeyEvent;
//import android.view.View;
//import android.webkit.CookieManager;
//import android.webkit.CookieSyncManager;
//import android.widget.ImageView;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import com.google.gson.Gson;
//import com.hcs.uclient.utils.SPUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.db.BaseInfoService;
//import com.jizhi.jlongg.main.bean.status.UpHeadState;
//import com.jizhi.jlongg.main.util.CameraPop;
//import com.jizhi.jlongg.main.util.CommonMethod;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.DataUtil;
//import com.jizhi.jlongg.main.util.MyFragmentJSObject;
//import com.jizhi.jlongg.main.util.MyWebViewClient;
//import com.jizhi.jlongg.main.util.RequestParamsToken;
//import com.jizhi.jlongg.main.util.SingsHttpUtils;
//import com.jizhi.jlongg.main.util.UtilFile;
//import com.jizhi.jlongg.main.util.WebUitils;
//import com.jizhi.jlongg.network.NetWorkRequest;
//import com.jizhi.jongg.widget.LJWebView;
//import com.lidroid.xutils.HttpUtils;
//import com.lidroid.xutils.ViewUtils;
//import com.lidroid.xutils.http.RequestParams;
//import com.lidroid.xutils.http.ResponseInfo;
//import com.lidroid.xutils.http.client.HttpRequest;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.List;
//
//import me.nereo.multi_image_selector.MultiImageSelectorActivity;
//
///**
// * 功能: 我的资料页面
// * 作者：huchangsheng
// * 时间: 2016-3-15 11:51
// */
//public class PersonDetailActivity extends BaseActivity implements MyWebViewClient.LoadEndingListener, MyFragmentJSObject.ReaTitleListener {
//    public LJWebView webView;
//    /**
//     * 0X11
//     * Object对象，用来跟JS网页绑定
//     */
//    private MyFragmentJSObject jsobject;
//    private BaseInfoService baseInfoService;
//    private RelativeLayout rea_webfail;
//    private PersonDetailActivity mActivity;
//    private TextView tv_title;
//    private RelativeLayout layout_title;
//    private String headPath;
//    private MyWebViewClient myWebViewClient;
//    private boolean isUpHead;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.layout_persondetail);
//        ViewUtils.inject(this);//Xutil必须调用的一句话
//        initView();
//        String url = getIntent().getStringExtra("url");
//        if (url != null && !url.equals("")) {
//            WebUitils uitils = new WebUitils(webView);
//            uitils.initWebView();
//            synCookies(mActivity, url);
//            webView.loadUrl(url);
//            myWebViewClient = new MyWebViewClient(url, mActivity, rea_webfail, this);
//            webView.setWebViewClient(myWebViewClient);
//            myWebViewClient.setTv_title(tv_title);
//            webView.getmWebView().addJavascriptInterface(jsobject, "jsPhone");
//        } else {
//            mActivity.finish();
//        }
//    }
//
//
//    public void synCookies(Context context, String url) {
//        CookieSyncManager.createInstance(context);
//        CookieManager cookieManager = CookieManager.getInstance();
//        cookieManager.setAcceptCookie(true);
//        cookieManager.removeSessionCookie();// 移除
//        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
//        cookieManager.setCookie(url, "Authorization=" + stoken);
//        CookieSyncManager.getInstance().sync();
//    }
//
//    private void initView() {
//        mActivity = PersonDetailActivity.this;
//        webView = (LJWebView) findViewById(R.id.webview);
//        baseInfoService = BaseInfoService.getInstance(getApplicationContext());
//        layout_title = (RelativeLayout) findViewById(R.id.inc);
//        layout_title.setVisibility(View.GONE);
//        rea_webfail = (RelativeLayout) findViewById(R.id.rea_webfail);
//        tv_title = (TextView) findViewById(R.id.title);
//        tv_title.setText("");
//        webView.setTv_title(tv_title);
//        webView.setLayout_title(layout_title);
//        ImageView btn_refresh = (ImageView) findViewById(R.id.btn_refresh);
//        jsobject = new MyFragmentJSObject(mActivity, webView.getmWebView(), baseInfoService, this);
//        jsobject.clearState();
//        btn_refresh.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                webView.getmWebView().reload();
//            }
//        });
//
//    }
//
//    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        baseInfoService.closeDB();
//    }
//
//
//    public void recycledBitmap(Bitmap bitmap) {
//        if (bitmap != null && !bitmap.isRecycled()) {
//            bitmap.isRecycled();
//            bitmap = null;
//            System.gc();
//        }
//    }
//
//    /**
//     * 裁剪相片
//     */
//    public void doCropPhoto(String path) {
//        File directorFile = new File(UtilFile.JGJIMAGEPATH + File.separator + "Head");
//        if (!directorFile.exists()) {
//            directorFile.mkdirs();
//        }
//        String newPath = directorFile.getAbsolutePath() + "/tempHead" + path.substring(path.lastIndexOf("."));
//        UtilFile.copyFile(path, newPath);
//        try {
//            headPath = newPath;
//            // 启动gallery去剪辑这个照片
//            Intent intent = UtilFile.getCropImageIntent(new File(headPath));
//            startActivityForResult(intent, CameraPop.IMAGE_CROP);
//        } catch (Exception e) {
//            Toast.makeText(mActivity, "获取照片错误", Toast.LENGTH_LONG).show();
//        }
//    }
//
//
//    @Override
//    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if (requestCode == CameraPop.REQUEST_IMAGE) { //选择照片回调
//            if (resultCode == RESULT_OK) {
//                List<String> strings = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//                doCropPhoto(strings.get(0));
//            }
//        } else if (requestCode == CameraPop.IMAGE_CROP && resultCode == RESULT_OK) { //裁剪相册回调
//            try {
//                Object[] object = UtilFile.saveBitmapToFile(headPath);
//                String str = (String) object[0];
//                Bitmap headBitmap = (Bitmap) object[1];
//                if (headBitmap != null) {
//                    recycledBitmap(headBitmap);
//                    UpHead(str);
//                }
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        }
//    }
//
//    /**
//     * 修改头像
//     */
//    public void UpHead(final String path) {
//        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
//        params.addBodyParameter("head_pic", new File(path));
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFYHEADPIC,
//                params, new RequestCallBackExpand<Object>() {
//
//                    @Override
//                    public void onSuccess(ResponseInfo<String> responseInfo) {
//                        try {
//                            Gson gson = new Gson();
//                            UpHeadState bean = gson.fromJson(responseInfo.result, UpHeadState.class);
//                            if (bean.getState() != 0) {
//                                if (null != bean.getValues() && null != bean.getValues().getImgpath()) {
//                                    isUpHead = true;
//                                    headPath = bean.getValues().getImgpath();
//                                    webView.loadUrl("javascript:getNewHeadPicture('" + headPath + "')");
//                                } else {
//                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), "上传失败");
//                                }
//                            } else {
//                                DataUtil.showErrOrMsg(mActivity,
//                                        bean.getErrno(), bean.getErrmsg());
//                            }
//                        } catch (Exception e) {
//                            CommonMethod.makeNoticeShort(mActivity,
//                                    getString(R.string.service_err), CommonMethod.ERROR);
//                        }
//                        closeDialog();
//                    }
//                }
//
//        );
//
//    }
//
//    @Override
//    public void loadEnding(String url) {
//        jsobject.clearState();
//    }
//
//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if (event.getAction() == KeyEvent.ACTION_DOWN) {
//            //表示按返回键
//            if (keyCode == KeyEvent.KEYCODE_BACK && webView.getmWebView().canGoBack()) {
//                layout_title.setVisibility(View.GONE);
//                webView.getmWebView().goBack();
//            } else {
//                if (isUpHead) {
//                    setResult(Constance.INFOMATION, getIntent());
//                }
//                mActivity.finish();
//            }
//        }
//        return false;
//    }
//
//    public void onFinish(View view) {
//        if (webView.getmWebView().canGoBack()) { //工友 资讯 是否能回退上一个页面
//            layout_title.setVisibility(View.GONE);
//            webView.getmWebView().goBack(); //回退WebView
//        } else {
//            if (isUpHead) {
//                setResult(Constance.INFOMATION, getIntent());
//            }
//            mActivity.finish();
//        }
//    }
//
//    @Override
//    public void reaTitle() {
//        mActivity.runOnUiThread(new Runnable() {
//            @Override
//            public void run() {
//                layout_title.setVisibility(View.VISIBLE);
//            }
//        });
//    }
//}
