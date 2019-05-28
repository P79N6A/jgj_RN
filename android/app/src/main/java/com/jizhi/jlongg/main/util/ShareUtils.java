package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.graphics.Bitmap;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.hcs.uclient.utils.BitmapUtils;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMWeb;

/**
 * 分享
 */

public class ShareUtils {
    /* QQ */
    private static final String QQ = "qq";
    /* 微信 */
    private static final String WEIXIN = "weixin";
    /* QQ空间 */
    private static final String QZONE = "qzone";
    /* 微信朋友圈 */
    private static final String WEIXINFRIEND = "weixinfriend";
    /* 分享实体对象 */
    private Share shareBean;
    private Activity activity;
    private CustomShareDialog.ShareSuccess shareSuccess;


    public void setShareSuccess(CustomShareDialog.ShareSuccess shareSuccess) {
        this.shareSuccess = shareSuccess;
    }

    public void shareFactory(Activity activity, String shareType, Share shareBean) {
        this.shareBean = shareBean;
        this.activity = activity;
        //  朋友圈 1；微信 2；QQ 3
        if (shareType.equals("1")) {
            shareType = WEIXINFRIEND;
        } else if (shareType.equals("2")) {
            shareType = WEIXIN;
        } else if (shareType.equals("3")) {
            shareType = QQ;
        }
        shareFactory(shareType);
        if (null != shareSuccess) {
            shareSuccess.shareClickSuccess();
        }
    }

    public void shareFactory(String shareType) {
        UMImage shareImage = new UMImage(activity, !TextUtils.isEmpty(shareBean.getImgUrl()) ? shareBean.getImgUrl() : NetWorkRequest.NETURL + "media/default_imgs/logo.jpg");
        shareImage.compressFormat = Bitmap.CompressFormat.PNG;
        UMWeb web = new UMWeb(shareBean.getUrl());
        web.setTitle(shareBean.getTitle());//标题
        web.setThumb(shareImage);  //缩略图
        web.setDescription(shareBean.getDescribe());
        switch (shareType) {
            case QQ:
                new ShareAction(activity)
                        .withMedia(web)
                        .setPlatform(SHARE_MEDIA.QQ)
                        .setCallback(umShareListener)
                        .share();

                break;
            case QZONE:
                new ShareAction(activity)
                        .setPlatform(SHARE_MEDIA.QZONE)
                        .withMedia(web)
                        .setCallback(umShareListener)
                        .share();
                break;
            case WEIXIN:
                if (!TextUtils.isEmpty(shareBean.getAppId()) && !TextUtils.isEmpty(shareBean.getPath())) {
                    shareMINApp();
                    return;
                }
                new ShareAction(activity)
                        .withMedia(web)
                        .setPlatform(SHARE_MEDIA.WEIXIN)
                        .setCallback(umShareListener)
                        .share();
                LUtils.e(new Gson().toJson(web) + "------------" + SHARE_MEDIA.WEIXIN.toString());
                break;
            case WEIXINFRIEND:
                new ShareAction(activity)
                        .setPlatform(SHARE_MEDIA.WEIXIN_CIRCLE)
                        .withMedia(web)
                        .setCallback(umShareListener)
                        .share();
                LUtils.e(new Gson().toJson(web) + "------------" + SHARE_MEDIA.WEIXIN.toString());
                break;
        }
    }

    /**
     * 分享微信小程序
     */
    /**
     * 分享微信小程序
     */
    public void shareMINApp() {
        ///兼容低版本的网页链接
        UMMin umMin = new UMMin(shareBean.getUrl());
        // 小程序消息title
        umMin.setTitle(shareBean.getTitle());
        // 小程序消息描述
        umMin.setDescription(shareBean.getDescribe());
        //小程序页面路径
        umMin.setPath(shareBean.getPath());
        // 小程序原始id,在微信平台查询
        umMin.setUserName(shareBean.getAppId());
        // 小程序消息封面图片
        try {
            if (shareBean.getWxMiniDrawable() == 2) {
                UMImage shareImage = new UMImage(activity, R.drawable.account_wx_mini);
                umMin.setThumb(shareImage);
            } else {
                int width = ScreenUtils.getScreenWidth(activity);
                int height = width / 5 * 4;
                Bitmap bitmap = ScreenShot.takeScreenShotClip(activity, 0, ScreenUtils.getStatusHeight(activity) + DensityUtils.dp2px(activity, 50), width, height);
                umMin.setThumb(new UMImage(activity, BitmapUtils.imageZoom(bitmap)));
            }
        } catch (Exception e) {
            UMImage shareImage = new UMImage(activity, R.drawable.miniapp);
            umMin.setThumb(shareImage);
        }

        new ShareAction(activity)
                .withMedia(umMin)
                .setPlatform(SHARE_MEDIA.WEIXIN)
                .setCallback(umShareListener).share();
        LUtils.e(new Gson().toJson(umMin));
    }

    private UMShareListener umShareListener = new UMShareListener() {
        /**
         * @descrption 分享开始的回调
         * @param platform 平台类型
         */
        @Override
        public void onStart(SHARE_MEDIA platform) {
            LUtils.e("============分享开始的回调===============");
        }

        /**
         * @descrption 分享成功的回调
         * @param platform 平台类型
         */
        @Override
        public void onResult(SHARE_MEDIA platform) {
            LUtils.e("============分享成功的回调===============");
        }


        /**
         * @descrption 分享失败的回调
         * @param platform 平台类型
         * @param t 错误原因
         */
        @Override
        public void onError(SHARE_MEDIA platform, Throwable t) {
            LUtils.e("============分享失败的回调===============");
        }

        /**
         * @descrption 分享取消的回调
         * @param platform 平台类型
         */
        @Override
        public void onCancel(SHARE_MEDIA platform) {
            LUtils.e("============分享取消的回调==============");
        }
    };
}
