//package com.jizhi.jlongg.main.dialog;
//
//import android.annotation.TargetApi;
//import android.app.Activity;
//import android.app.Dialog;
//import android.content.Context;
//import android.graphics.Bitmap;
//import android.graphics.BitmapFactory;
//import android.graphics.Canvas;
//import android.graphics.Matrix;
//import android.graphics.Picture;
//import android.graphics.PixelFormat;
//import android.graphics.Rect;
//import android.graphics.drawable.BitmapDrawable;
//import android.os.Build;
//import android.os.Environment;
//import android.text.TextUtils;
//import android.view.Gravity;
//import android.view.LayoutInflater;
//import android.view.MotionEvent;
//import android.view.View;
//import android.view.ViewGroup;
//import android.view.WindowManager;
//import android.widget.PopupWindow;
//import android.widget.TextView;
//
//import com.google.gson.Gson;
//import com.hcs.uclient.utils.BitmapUtils;
//import com.hcs.uclient.utils.LUtils;
//import com.hcs.uclient.utils.ScreenUtils;
//import com.hcs.uclient.utils.Utils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.activity.CustomFaceToFaceActivity;
//import com.jizhi.jlongg.main.bean.Share;
//import com.jizhi.jlongg.main.util.BackGroundUtil;
//import com.jizhi.jlongg.main.util.CommonMethod;
//import com.jizhi.jlongg.network.NetWorkRequest;
//import com.jizhi.jlongg.x5webview.jsbridge.BridgeX5WebView;
//import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
//import com.tencent.smtt.sdk.WebView;
//import com.umeng.socialize.ShareAction;
//import com.umeng.socialize.UMShareListener;
//import com.umeng.socialize.bean.SHARE_MEDIA;
//import com.umeng.socialize.media.UMImage;
//import com.umeng.socialize.media.UMMin;
//import com.umeng.socialize.media.UMWeb;
//
//import java.io.ByteArrayOutputStream;
//import java.io.File;
//import java.io.FileNotFoundException;
//import java.io.FileOutputStream;
//import java.io.IOException;
//
//public class ShareDialog extends Dialog implements View.OnClickListener {
//
//
//    private Context activity;
//    private String path;
//
//    public ShareDialog(Context activity, String path) {
//        super(activity);
//        this.activity = activity;
//        this.path = path;
//        createLayout();
//        initView();
//
//    }
//
////    /**
////     * 显示弹出框
////     *
////     * @param context
////     */
////    public static void showPopupWindow(final Context context) {
////        // 获取WindowManager
////        final WindowManager mWindowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
////
////
////        final WindowManager.LayoutParams params = new WindowManager.LayoutParams();
////        // 类型
////        params.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
////        // 设置flag
////        params.flags = WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
////        // 如果设置了WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE，弹出的View收不到Back键的事件
////        // 不设置这个弹出框的透明遮罩显示为黑色
////        params.format = PixelFormat.TRANSLUCENT;
////        // FLAG_NOT_TOUCH_MODAL不阻塞事件传递到后面的窗口
////        // 设置 FLAG_NOT_FOCUSABLE 悬浮窗口较小时，后面的应用图标由不可长按变为可长按
////        // 不设置这个flag的话，home页的划屏会有问题
////        params.width = WindowManager.LayoutParams.WRAP_CONTENT;
////        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
////        params.gravity = Gravity.CENTER;
////        TextView textView = new TextView(context);
////        textView.setText("sfgsfdsfbsadfbasdfg");
////        textView.setTextSize(100);
////
////        final View mView = LayoutInflater.from(context).inflate(R.layout.dialog_share_new, null);
////
////
//////        tv_itemdialog_ok.setText("重新登录");
//////        tv_itemdialog_close.setText("退出登录");
//////        tv_itemdialog_title.setText("该账户在其他设备登录,若不是您在操作,请及时修改密码以防泄露信息");
//////        tv_itemdialog_ok.setOnClickListener(new View.OnClickListener() {
//////            @Override
//////            public void onClick(View v) {
//////                // 隐藏弹窗
//////                mWindowManager.removeView(mView);
//////            }
//////        });
//////
//////        tv_itemdialog_close.setOnClickListener(new View.OnClickListener() {
//////            @Override
//////            public void onClick(View v) {
//////                mWindowManager.removeView(mView);
//////            }
//////        });
////
////        mWindowManager.addView(mView, params);
////    }
//
//    public void createLayout() {
//        setContentView(R.layout.dialog_share_new);
//    }
//
//    private void initView() {
//        findViewById(R.id.tv_savephoto_to_album).setVisibility(View.GONE);
//        findViewById(R.id.qzone).setOnClickListener(this);
//        findViewById(R.id.qq).setOnClickListener(this);
//        findViewById(R.id.weixinFriendCircle).setOnClickListener(this);
//        findViewById(R.id.weixinFriend).setOnClickListener(this);
//        findViewById(R.id.lin_facetoface).setOnClickListener(this);
//        findViewById(R.id.tv_savephoto_to_album).setOnClickListener(this);
//        findViewById(R.id.tv_calcel).setOnClickListener(this);
//        findViewById(R.id.rea_pop_top).setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//                return true;
//            }
//        });
//        findViewById(R.id.rea_pop_layout).setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//                dismiss();
//                return false;
//            }
//        });
//        findViewById(R.id.lin_facetoface).setVisibility(View.GONE);
//    }
//
//
//    @Override
//    public void onClick(View view) {
//        switch (view.getId()) {
//            case R.id.qzone: //QQ空间
//                sharePicture(SHARE_MEDIA.QZONE);
//                break;
//            case R.id.qq: //QQ好友
//                sharePicture(SHARE_MEDIA.QQ);
//                break;
//            case R.id.weixinFriend: //微信
//                sharePicture(SHARE_MEDIA.WEIXIN);
//                break;
//            case R.id.weixinFriendCircle: //微信朋友圈
//                sharePicture(SHARE_MEDIA.WEIXIN_CIRCLE);
//                break;
//            case R.id.tv_savephoto_to_album: //保存图片到相册
//                break;
//            case R.id.tv_calcel: //取消
//                dismiss();
//                break;
//            case R.id.lin_facetoface: //取消
//                break;
//        }
//        dismiss();
//    }
//
//
//    /**
//     * 分享截图
//     */
//    public void sharePicture(SHARE_MEDIA share_media) {
//        UMImage umImage = new UMImage(activity, path);
////        if (share_media.equals(SHARE_MEDIA.WEIXIN)) {
////            UMImage umImage1 = new UMImage(activity, path);
////            umImage.setThumb(umImage1);
////
////        }
//        new ShareAction((Activity) activity)
//                .setPlatform(share_media)
//                .withMedia(umImage)
//                .share();
//        dismiss();
//    }
//
//    /**
//     * 压缩bitmap
//     *
//     * @param bitmap
//     * @param maxkb
//     * @return
//     */
//    public byte[] bitmap2Bytes(Bitmap bitmap, int maxkb) {
//        ByteArrayOutputStream output = new ByteArrayOutputStream();
//        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);
//        int options = 100;
//        while (output.toByteArray().length > maxkb && options != 10) {
//            output.reset(); //清空output
//            bitmap.compress(Bitmap.CompressFormat.JPEG, options, output);//这里压缩options%，把压缩后的数据存放到output中
//            options -= 10;
//        }
//        return output.toByteArray();
//    }
//
//
//}
