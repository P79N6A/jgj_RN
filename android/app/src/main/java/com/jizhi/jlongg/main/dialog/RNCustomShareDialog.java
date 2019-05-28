package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Picture;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.PopupWindow;

import com.google.gson.Gson;
import com.hcs.uclient.utils.BitmapUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.CustomFaceToFaceActivity;
import com.jizhi.jlongg.main.activity.ForwardMessageActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.adpter.ShareMenuAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.ImageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.tencent.smtt.sdk.WebView;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMWeb;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class RNCustomShareDialog extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
    private Activity activity;

    /* 分享到APP */
    private final int SHARE_TO_APP = 1;
    /* 分享到朋友圈 */
    private final int SHARE_TO_WORK_CIRCLE = 2;
    /* QQ */
    private final int SHARE_TO_QQ_FRIEND = 3;
    /* 微信 */
    private final int SHARE_TO_WEIXIN_FRIEND_CIRCLE = 4;
    /* QQ空间 */
    private final int SHARE_TO_QZONE = 5;
    /* 微信朋友圈 */
    private final int SHARE_TO_WEIXIN_FRIEND = 6;
    /* 面对面建群 */
    private final int SHARE_TO_FACE_TO_FACE = 7;
    /* 分享实体对象 */
    private Share shareBean;

    /* 是否隐藏保存图片,如果为false就只分享图片 */
    private boolean isHintSaveAlbim;
    /* popview */
    private View popView;
    /*1是否截取屏幕上班部分*/
    private int isCaptureTop;
   private ShartStartListener shartStartListener;
    public void setIsCaptureTop(int isCaptureTop) {
        this.isCaptureTop = isCaptureTop;
    }

    public RNCustomShareDialog(Activity activity, boolean isHintSaveAlbim, Share shareBean) {
        super(activity);
        this.activity = activity;
        this.isHintSaveAlbim = isHintSaveAlbim;
        this.shareBean = shareBean;
        setPopView();
        initView();
    }

    public RNCustomShareDialog(Activity activity, boolean isHintSaveAlbim, Share shareBean,ShartStartListener shartStartListener) {
        super(activity);
        this.activity = activity;
        this.isHintSaveAlbim = isHintSaveAlbim;
        this.shareBean = shareBean;
        this.shartStartListener=shartStartListener;
        setPopView();
        initView();
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.share_layout, null);
        setContentView(popView);
        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        setAnimationStyle(R.style.ActionSheetDialogAnimation);
        setOutsideTouchable(true);
        setFocusable(true);
        setBackgroundDrawable(new BitmapDrawable());
        setOnDismissListener(this);
        LUtils.e("-shareBean--" + new Gson().toJson(shareBean));
    }


    private ArrayList<ChatManagerItem> getData() {
        Resources res = activity.getResources();
        ArrayList<ChatManagerItem> chatManagerItems = new ArrayList<>();
        if (shareBean.getTopdisplay() == 0) {
            ChatManagerItem item1 = new ChatManagerItem("发送给\n吉工家好友", SHARE_TO_APP, res.getDrawable(R.drawable.share_to_app));
            ChatManagerItem item2 = new ChatManagerItem("分享到\n工友圈", SHARE_TO_WORK_CIRCLE, res.getDrawable(R.drawable.share_to_work_circle));
            chatManagerItems.add(item1);
            chatManagerItems.add(item2);
        }
        ChatManagerItem item3 = new ChatManagerItem("分享给\n微信好友", SHARE_TO_WEIXIN_FRIEND_CIRCLE, res.getDrawable(R.drawable.umeng_socialize_wechat));
        ChatManagerItem item4 = new ChatManagerItem("分享到\n微信朋友圈", SHARE_TO_WEIXIN_FRIEND, res.getDrawable(R.drawable.umeng_socialize_wxcircle));
        ChatManagerItem item5 = new ChatManagerItem("分享给\nQQ好友", SHARE_TO_QQ_FRIEND, res.getDrawable(R.drawable.umeng_socialize_qq_on));
        ChatManagerItem item6 = new ChatManagerItem("分享到\nQQ空间", SHARE_TO_QZONE, res.getDrawable(R.drawable.umeng_socialize_qzone_on));

        chatManagerItems.add(item3);
        chatManagerItems.add(item4);
        chatManagerItems.add(item5);
        chatManagerItems.add(item6);
        if (!TextUtils.isEmpty(shareBean.getUrl()) && shareBean.getTopdisplay() == 0) {
            chatManagerItems.add(new ChatManagerItem("面对面分享", SHARE_TO_FACE_TO_FACE, res.getDrawable(R.drawable.icon_share_facetoface)));
        }
        return chatManagerItems;
    }

    private void initView() {
        popView.findViewById(R.id.tv_savephoto_to_album).setVisibility(isHintSaveAlbim ? View.GONE : View.VISIBLE);
        popView.findViewById(R.id.tv_savephoto_to_album).setOnClickListener(this);
        popView.findViewById(R.id.tv_calcel).setOnClickListener(this);
        popView.findViewById(R.id.rootView).setOnClickListener(this);
        GridView gridView = popView.findViewById(R.id.gridView);
        final ArrayList<ChatManagerItem> list = getData();
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                switch (list.get(position).getMenuType()) {
                    case SHARE_TO_APP:
                        if (!isHintSaveAlbim) {   //上传图片
                            Bitmap screenShotBitmap = takeScreenShot(activity);
                            if (screenShotBitmap != null) {
                                //导航栏的高度
                                int navigationHeight = (int) (activity.getResources().getDimension(R.dimen.head_height));
                                Bitmap newBitMap = Bitmap.createBitmap(screenShotBitmap, 0, navigationHeight, screenShotBitmap.getWidth(), screenShotBitmap.getHeight() - navigationHeight);
                                if (newBitMap != null) {
                                    shareBean.setShareFile(ImageUtil.getFile(newBitMap));
                                    ForwardMessageActivity.actionStart(activity, MessageType.MSG_PIC_STRING, shareBean);
                                }
                            }
                        } else { //链接
                            ForwardMessageActivity.actionStart(activity, MessageType.MSG_LINK_STRING, shareBean);
                        }
                        dismiss();
                        break;
                    case SHARE_TO_WORK_CIRCLE:
                        if (!isHintSaveAlbim) {
                            //上传图片
                            Bitmap screenShotBitmap = takeScreenShot(activity);
                            if (screenShotBitmap != null) {
                                //导航栏的高度
                                int navigationHeight = 0;
                                Bitmap newBitMap = Bitmap.createBitmap(screenShotBitmap, 0, navigationHeight, screenShotBitmap.getWidth(), screenShotBitmap.getHeight() - navigationHeight);
                                if (newBitMap != null) {
                                    File file = ImageUtil.getFile(newBitMap);
                                    List<String> a = new ArrayList<>();
                                    a.add(file.getAbsolutePath());
                                    fileUpData(a);
                                }
                            }

                        } else {
                            String title = Uri.encode(!TextUtils.isEmpty(shareBean.getTitle()) ? shareBean.getTitle() : "");
                            String imgUrl = Uri.encode(!TextUtils.isEmpty(shareBean.getImgUrl()) ? shareBean.getImgUrl() : "");
                            String url = Uri.encode(!TextUtils.isEmpty(shareBean.getUrl()) ? shareBean.getUrl() : "");
                            X5WebViewActivity.actionStart(activity, NetWorkRequest.DYNAMIC_COMMENT + "?title=" + title + "&imgUrl=" + imgUrl + "&url=" + url);
                        }
                        dismiss();
                        break;
                    case SHARE_TO_WEIXIN_FRIEND:
                        if (!isHintSaveAlbim) {
                            sharePicture(SHARE_MEDIA.WEIXIN);
                            return;
                        }
                        shareFactory(SHARE_TO_WEIXIN_FRIEND);
                        break;
                    case SHARE_TO_WEIXIN_FRIEND_CIRCLE:
                        if (!isHintSaveAlbim) {
                            sharePicture(SHARE_MEDIA.WEIXIN_CIRCLE);
                            return;
                        }
                        shareFactory(SHARE_TO_WEIXIN_FRIEND_CIRCLE);
                        break;
                    case SHARE_TO_QQ_FRIEND:
                        if (!isHintSaveAlbim) {
                            sharePicture(SHARE_MEDIA.QQ);
                            return;
                        }
                        shareFactory(SHARE_TO_QQ_FRIEND);
                        break;
                    case SHARE_TO_QZONE:
                        if (!isHintSaveAlbim) {
                            sharePicture(SHARE_MEDIA.QZONE);
                            return;
                        }
                        shareFactory(SHARE_TO_QZONE);
                        break;
                    case SHARE_TO_FACE_TO_FACE:
                        CustomFaceToFaceActivity.actionStartActivity(activity, shareBean.getUrl());
                        dismiss();
                        break;
                }
            }
        });
        gridView.setAdapter(new ShareMenuAdapter(activity, list));
    }

    RequestParams params;

    /**
     * 发送图片消息
     */
    protected void fileUpData(final List<String> path) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(activity);
                if (null != path && path.size() > 0) {
                    ImageUtil.compressImageSetParams(params, path, activity);
                }
                params.addBodyParameter("os", "A");
                Message message = Message.obtain();
                message.obj = path;
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        }).start();
    }

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
                                    X5WebViewActivity.actionStart(activity, NetWorkRequest.DYNAMIC_COMMENT + "?title=&url=&imgUrl=" + Uri.encode(valuesPath.get(0)));

                                }
                            }
                        }
                    } else {
                        String errno = bean.getErrno();
                        String errmsg = bean.getErrmsg();
                        DataUtil.showErrOrMsg(activity, errno, errmsg);
                        CommonMethod.makeNoticeShort(activity, "网络连接失败", CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, "网络连接失败", CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
            }
        });
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.tv_savephoto_to_album: //保存图片到相册
//                if (null != webView) {
//                    //分享截取网页全图
//                    Bitmap bitmap = takeScreenShotClip(activity);
//                    saveImage(bitmap);
//                    if (null != captureFuncion) {
//                        captureFuncion.onCallBack("");
//                    }
//                } else {
//                    Bitmap bitmap = takeScreenShotClip(activity);
//                    saveImage(bitmap);
//                }
                break;
        }
        dismiss();
    }


    public void shareFactory(int shareType) {
        UMImage shareImage = new UMImage(activity, !TextUtils.isEmpty(shareBean.getImgUrl()) ? shareBean.getImgUrl() : NetWorkRequest.NETURL + "media/default_imgs/logo.jpg");
        shareImage.compressFormat = Bitmap.CompressFormat.PNG;
        UMWeb web = new UMWeb(shareBean.getUrl());
        web.setTitle(shareBean.getTitle());//标题
        web.setThumb(shareImage);  //缩略图
        web.setDescription(shareBean.getDescribe());
        switch (shareType) {
            case SHARE_TO_QQ_FRIEND:
                if (isHintSaveAlbim) {
                    new ShareAction(activity)
                            .withMedia(web)
                            .setPlatform(SHARE_MEDIA.QQ)
                            .setCallback(umShareListener)
                            .share();
                } else {
                    sharePicture(SHARE_MEDIA.QQ);
                }
                break;
            case SHARE_TO_QZONE:
                if (isHintSaveAlbim) {

                    new ShareAction(activity)
                            .setPlatform(SHARE_MEDIA.QZONE)
                            .withMedia(web)
                            .setCallback(umShareListener)
                            .share();
                } else {
                    sharePicture(SHARE_MEDIA.QZONE);
                }
                break;
            case SHARE_TO_WEIXIN_FRIEND_CIRCLE:
                if (isHintSaveAlbim) {
                    if (!TextUtils.isEmpty(shareBean.getAppId()) && !TextUtils.isEmpty(shareBean.getPath())) {
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                shareMINApp();
                            }
                        }).start();
                    } else {
                        new ShareAction(activity)
                                .withMedia(web)
                                .setPlatform(SHARE_MEDIA.WEIXIN)
                                .setCallback(umShareListener)
                                .share();
                    }
                } else {
                    sharePicture(SHARE_MEDIA.WEIXIN);
                }
                break;
            case SHARE_TO_WEIXIN_FRIEND:
                if (isHintSaveAlbim) {
                    web.setTitle(shareBean.getTitle() + "," + shareBean.getDescribe());
                    web.setDescription("");
                    new ShareAction(activity)
                            .setPlatform(SHARE_MEDIA.WEIXIN_CIRCLE)
                            .withMedia(web)
                            .setCallback(umShareListener)
                            .share();
                } else {
                    sharePicture(SHARE_MEDIA.WEIXIN_CIRCLE);
                }
                break;
        }

        dismiss();
    }

    /**
     * 分享截图
     */
    public void sharePicture(SHARE_MEDIA share_media) {
        Bitmap bitmap = takeScreenShot(activity);
        UMImage umImage = new UMImage(activity, bitmap);
        if (share_media.equals(SHARE_MEDIA.WEIXIN)) {
            Bitmap newBitMap = Bitmap.createBitmap(bitmap, 0, bitmap.getHeight() / 4, bitmap.getWidth(), bitmap.getWidth() / 5 * 4);
            UMImage umImage1 = new UMImage(activity, newBitMap);
            umImage.setThumb(umImage1);
        }
        new ShareAction(activity)
                .setPlatform(share_media)
                .withMedia(umImage)
                .setCallback(umShareListener)
                .share();
        dismiss();
    }

    /**
     * 分享微信小程序
     */
    public void shareMINApp() {
        ///兼容低版本的网页链接
        final UMMin umMin = new UMMin(shareBean.getUrl());
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
                UMImage shareImage = new UMImage(activity, bitmap2Bytes(BitmapFactory.decodeResource(activity.getResources(), R.drawable.account_wx_mini), IMAGE_SIZE));
                umMin.setThumb(shareImage);
            } else if (!TextUtils.isEmpty(shareBean.getTypeImg()) && shareBean.getTypeImg().equals("jobIndex")) {
                UMImage shareImage = new UMImage(activity, bitmap2Bytes(BitmapFactory.decodeResource(activity.getResources(), R.drawable.account_wx_mini_hhr), IMAGE_SIZE));

                umMin.setThumb(shareImage);
            } else if (!TextUtils.isEmpty(shareBean.getTypeImg()) && shareBean.getTypeImg().equals("invite")) {
                //3周年抽奖，红包活动分享到微信
                UMImage shareImage = new UMImage(activity, bitmap2Bytes(BitmapFactory.decodeResource(activity.getResources(), R.drawable.bg_share_invite), IMAGE_SIZE));
                umMin.setThumb(shareImage);
            } else {
                int width = ScreenUtils.getScreenWidth(activity);
                int height = width / 5 * 4;
                Bitmap bitmap;
//                if (isCaptureTop == 1) {
//                    //分享小程序截取webvie上半部分图片
//                    bitmap = takeScreenShot(activity, height);
//
//                } else {
                bitmap = takeScreenShot(activity);
//                }
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

    /**
     * 进行截取屏幕
     *
     * @param pActivity
     * @return
     */
    public Bitmap takeScreenShot(Activity pActivity, int height) {
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
        int stautsHeight = frame.top + (((int) activity.getResources().getDimension(R.dimen.head_height)));
        int width = pActivity.getWindowManager().getDefaultDisplay().getWidth();
        // 根据坐标点和需要的宽和高创建bitmap
        bitmap = Bitmap.createBitmap(bitmap, 0, stautsHeight, width, height - stautsHeight);
        LUtils.e("-------takeScreenShot--------" + bitmap);
        return bitmap;
    }


    public final int IMAGE_SIZE = 32768;//微信分享图片大小限制

    /**
     * 压缩bitmap
     *
     * @param bitmap
     * @param maxkb
     * @return
     */
    public byte[] bitmap2Bytes(Bitmap bitmap, int maxkb) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);
        int options = 100;
        while (output.toByteArray().length > maxkb && options != 10) {
            output.reset(); //清空output
            bitmap.compress(Bitmap.CompressFormat.JPEG, options, output);//这里压缩options%，把压缩后的数据存放到output中
            options -= 10;
        }
        return output.toByteArray();
    }


    /**
     * 保存图片到相册
     *
     * @param bm
     */
    public void saveImage(Bitmap bm) {
        if (null != bm) {
            boolean issave = Utils.saveBitmap(activity, bm);
            if (issave) {
                CommonMethod.makeNoticeLong(activity, "已保存到手机相册", CommonMethod.SUCCESS);
            } else {
                CommonMethod.makeNoticeLong(activity, "保存失败", CommonMethod.SUCCESS);
            }
        } else {
            CommonMethod.makeNoticeLong(activity, "保存失败!", CommonMethod.SUCCESS);

        }
    }

    private UMShareListener umShareListener = new UMShareListener() {
        /**
         * @descrption 分享开始的回调
         * @param platform 平台类型
         */
        @Override
        public void onStart(SHARE_MEDIA platform) {
            LUtils.e("============分享开始的回调===============");
            if(null!=shartStartListener){
                shartStartListener.shareStart();
            }
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
            LUtils.e("============分享失败的回调===============" + t.toString());
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

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(activity, 1.0F);
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
        int stautsHeight = frame.top + (((int) activity.getResources().getDimension(R.dimen.head_height)));
        int width = pActivity.getWindowManager().getDefaultDisplay().getWidth();
        int height = pActivity.getWindowManager().getDefaultDisplay().getHeight();
        // 根据坐标点和需要的宽和高创建bitmap
        bitmap = Bitmap.createBitmap(bitmap, 0, stautsHeight, width, height - stautsHeight);
        LUtils.e("-------takeScreenShot--------" + bitmap);
        return bitmap;
    }

    /**
     * 保存图片到sdcard中
     *
     * @param pBitmap
     */
    private boolean savePic(Bitmap pBitmap, String strName) {
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(strName);
            if (null != fos) {
                pBitmap.compress(Bitmap.CompressFormat.PNG, 90, fos);
                fos.flush();
                fos.close();
                return true;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 截图
     *
     * @param pActivity
     * @return 截图并且保存sdcard成功返回true，否则返回false
     */
    public Bitmap takeScreenShotClip(Activity pActivity) {
        String directoryPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).getAbsolutePath();
        File file = new File(directoryPath);
        if (!file.exists()) {
            file.mkdir();
        }
        Bitmap bitmap = takeScreenShot(pActivity);
        savePic(bitmap, file.getAbsolutePath() + File.separator + System.currentTimeMillis() + ".png");
        return bitmap;
    }

    public interface ShartStartListener{
        public void shareStart();
    }
}
