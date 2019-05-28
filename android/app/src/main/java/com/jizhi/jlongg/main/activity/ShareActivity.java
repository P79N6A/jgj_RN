package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;

import com.google.zxing.client.android.scanner.Intents;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.ImageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class ShareActivity extends BaseActivity implements View.OnClickListener {

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_share_new);
        findViewById(R.id.tv_savephoto_to_album).setVisibility(View.GONE);
        findViewById(R.id.face_to_face_send).setVisibility(View.INVISIBLE);
        findViewById(R.id.rea_pop_layout).setOnClickListener(this);
        findViewById(R.id.send_to_wechat_friend_circle).setOnClickListener(this);
        findViewById(R.id.send_to_wechat_friend).setOnClickListener(this);
        findViewById(R.id.send_to_qzone).setOnClickListener(this);
        findViewById(R.id.send_to_qq).setOnClickListener(this);
        findViewById(R.id.rea_pop_top).setOnClickListener(this);
        findViewById(R.id.tv_calcel).setOnClickListener(this);
        findViewById(R.id.share_to_worker_circle).setOnClickListener(this);
        findViewById(R.id.send_message_to_app).setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.send_message_to_app: //发送给吉工家好友
                String fileUrl = getIntent().getStringExtra(Constance.BEAN_STRING);
                if (!TextUtils.isEmpty(fileUrl)) {
                    Share shareBean = new Share();
                    shareBean.setShareFile(new File(fileUrl));
                    ForwardMessageActivity.actionStart(this, MessageType.MSG_PIC_STRING, shareBean);
                }
                finish();
                break;
            case R.id.share_to_worker_circle: //发送消息到工友圈
                //上传图片
                fileUrl = getIntent().getStringExtra(Constance.BEAN_STRING);
                if (!TextUtils.isEmpty(fileUrl)) {
                    List<String> a = new ArrayList<>();
                    a.add(fileUrl);
                    fileUpData(a);
                }
                break;
            case R.id.send_to_qzone: //QQ空间
                sharePicture(SHARE_MEDIA.QZONE);
                break;
            case R.id.send_to_qq: //QQ好友
                sharePicture(SHARE_MEDIA.QQ);
                break;
            case R.id.send_to_wechat_friend: //微信
                sharePicture(SHARE_MEDIA.WEIXIN);
                break;
            case R.id.send_to_wechat_friend_circle: //微信朋友圈
                sharePicture(SHARE_MEDIA.WEIXIN_CIRCLE);
                break;
            case R.id.rea_pop_top:
                break;
            case R.id.rea_pop_layout: //保存图片到相册
            case R.id.tv_calcel: //取消
                finish();
                break;

        }

    }

    /**
     * 发送图片消息
     */
    protected void fileUpData(final List<String> path) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(ShareActivity.this);
                if (null != path && path.size() > 0) {
                    ImageUtil.compressImageSetParams(params, path, ShareActivity.this);
                }
                params.addBodyParameter("os", "A");
                Message message = Message.obtain();
                message.obj = path;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        }).start();
    }

    RequestParams params;
    protected Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    List<String> path = (List<String>) msg.obj;
                    uploadPic(params, path);
                    break;
            }

        }
    };

    private void uploadPic(RequestParams params, final List<String> path) {
        HttpUtils http = SingsHttpUtils.getHttp();
        params.getBodyParameters();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD, params, new RequestCallBack() {
            @Override
            public void onLoading(long total, long current, boolean isUploading) {
                super.onLoading(total, current, isUploading);
            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonListJson<String> bean = CommonListJson.fromJson(responseInfo.result.toString(), String.class);
                    if (bean.getState() != 0) {
                        List<String> valuesPath = bean.getValues();
                        if (null != valuesPath && valuesPath.size() > 0) {
                            for (int i = 0; i < valuesPath.size(); i++) {
                                if (null != path && path.size() == valuesPath.size()) {
                                    X5WebViewActivity.actionStart(ShareActivity.this, NetWorkRequest.DYNAMIC_COMMENT + "?title=&url=&imgUrl=" + Uri.encode(valuesPath.get(0)));
                                    finish();
                                }
                            }
                        }
                    } else {
                        String errno = bean.getErrno();
                        String errmsg = bean.getErrmsg();
                        DataUtil.showErrOrMsg(ShareActivity.this, errno, errmsg);
                        CommonMethod.makeNoticeShort(ShareActivity.this, "网络连接失败", CommonMethod.ERROR);
                        closeDialog();
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(ShareActivity.this, "网络连接失败", CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                closeDialog();
            }
        });
    }

    /**
     * 进行截取屏幕
     *
     * @param pActivity
     * @return
     */
    public Bitmap takeScreenShot(Activity pActivity) {
        Bitmap bitmap = null;
        View view = pActivity.getWindow().getDecorView();
//        View view = this.screentLayout;
        // 设置是否可以进行绘图缓存
        view.setDrawingCacheEnabled(true);
        // 如果绘图缓存无法，强制构建绘图缓存
        view.buildDrawingCache();
        // 返回这个缓存视图
        bitmap = view.getDrawingCache();
        // 获取状态栏高度
        Rect frame = new Rect();
        // 测量屏幕宽和高
        view.getWindowVisibleDisplayFrame(frame);
        int stautsHeight = frame.top + (((int) getResources().getDimension(R.dimen.head_height)));
        int width = pActivity.getWindowManager().getDefaultDisplay().getWidth();
        int height = pActivity.getWindowManager().getDefaultDisplay().getHeight();
        // 根据坐标点和需要的宽和高创建bitmap
        bitmap = Bitmap.createBitmap(bitmap, 0, stautsHeight, width, height - stautsHeight);
        LUtils.e("-------takeScreenShot--------" + bitmap);
        return bitmap;
    }

    /**
     * 分享截图
     */
    public void sharePicture(SHARE_MEDIA share_media) {
        LUtils.e(share_media + ",,,,,,,,,,,");
        String url = getIntent().getStringExtra(Constance.BEAN_STRING);
        if (!TextUtils.isEmpty(url)) {
            UMImage umImage = new UMImage(ShareActivity.this, new File(url));
            if (share_media.equals(SHARE_MEDIA.WEIXIN)) {
                UMImage umImage1 = new UMImage(ShareActivity.this, new File(url));
                umImage.setThumb(umImage1);

            }
            new ShareAction(ShareActivity.this)
                    .setPlatform(share_media)
                    .withMedia(umImage)
                    .setCallback(umShareListener)
                    .share();
        }
    }

    private UMShareListener umShareListener = new UMShareListener() {
        /**
         * @descrption 分享开始的回调
         * @param platform 平台类型
         */
        @Override
        public void onStart(SHARE_MEDIA platform) {
//            if (null == customProgress) {
//                customProgress = new CustomProgress(activity);
//            }
//            customProgress.show(activity, "请稍后", false);
            finish();
            LUtils.e("============分享开始的回调===============");
        }

        /**
         * @descrption 分享成功的回调
         * @param platform 平台类型
         */
        @Override
        public void onResult(SHARE_MEDIA platform) {
//            if (null != customProgress) {
//                customProgress.dismiss();
//            }
            LUtils.e("============分享成功的回调===============");
//            finish();
        }


        /**
         * @descrption 分享失败的回调
         * @param platform 平台类型
         * @param t 错误原因
         */
        @Override
        public void onError(SHARE_MEDIA platform, Throwable t) {
//            if (null != customProgress) {
//                customProgress.dismiss();
//            }
            LUtils.e("============分享失败的回调===============" + t.toString());
//            finish();

        }

        /**
         * @descrption 分享取消的回调
         * @param platform 平台类型
         */
        @Override
        public void onCancel(SHARE_MEDIA platform) {
//            if (null != customProgress) {
//                customProgress.dismiss();
//            }
            LUtils.e("============分享取消的回调==============");
//            finish();

        }
    };
}
