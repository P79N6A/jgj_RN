package com.jizhi.jlongg.main.listener;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.widget.PopupWindow;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.dialog.RNCustomShareDialog;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.Timer;
import java.util.TimerTask;

public class RNImpl extends BaseActivity implements ShareListener {
    private Activity mActivity;

    private RNImpl(Activity activity) {
        this.mActivity = activity;
//        registerReceiver();
    }


    /**
     * 功能：获取 ImageSelectorimpl 对象的实例
     *
     * @param activity
     * @return
     */
    public static RNImpl of(Activity activity) {
        return new RNImpl(activity);
    }

    public void updateActivity(Activity activity) {
        this.mActivity = activity;
    }

    public BroadcastReceiver receiver;

//    /**
//     * 注册广播
//     */
//    private void registerReceiver() {
//        IntentFilter filter = new IntentFilter(); //消息接收广播器
//        filter.addAction(WebSocketConstance.SHARE_SUCCESS);
//        LocalBroadcastManager.getInstance(this).registerReceiver(receiver, filter);
//    }

//
//    class MessageBroadcast extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            try {
//                String action = intent.getAction();
//                switch (action) {
//                    case WebSocketConstance.SHARE_SUCCESS:
//                        LUtils.e("关闭了122222222222");
//
////                        getMainCalendarFragment().handlerBroadcastData(action, intent);
//                        break;
//                }
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//    }*/

//    @Override
//    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
//        LUtils.e(requestCode + ",,,,,,,,,,,,," + resultCode);
//
//    }

    @Override
    public void onNewIntent(Intent intent) {

    }

    @Override
    public void showShareMenu(String data, final Callback callback) {
        Gson gson = new Gson();
        final Share share = gson.fromJson(data, Share.class);
        if (null != share.getWxMini()) {
            share.setAppId(!TextUtils.isEmpty(share.getWxMini().getAppId()) ? share.getWxMini().getAppId() : "");
            share.setPath(!TextUtils.isEmpty(share.getWxMini().getPath()) ? share.getWxMini().getPath() : "");
            share.setTypeImg(!TextUtils.isEmpty(share.getWxMini().getTypeImg()) ? share.getWxMini().getTypeImg() : "");
        }

        mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                showShareDialog(share, share.getType(), true, callback);

            }
        });
    }

    public void showShareDialog(Share share, int shareType, boolean isHintSaveAlbim, final Callback callback) {//所有权限申请完成
        LUtils.e("显示分享弹窗");

        if (null == share) {
            return;
        }
        switch (shareType) {
            case 0:
                RNCustomShareDialog dialog = new RNCustomShareDialog(mActivity, isHintSaveAlbim, share, new RNCustomShareDialog.ShartStartListener() {
                    @Override
                    public void shareStart() {
                        LUtils.e("---------shareStart----------回调给RN分享成功------");
                        BackGroundUtil.backgroundAlpha(mActivity, 1f);
                        new Timer().schedule(new TimerTask() {
                            @Override
                            public void run() {
                                callback.invoke("success");
                            }
                        }, 3000);
                    }
                });
                //显示窗口
                dialog.showAtLocation(mActivity.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
                BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
                dialog.setIsCaptureTop(1);
                dialog.setOnDismissListener(new PopupWindow.OnDismissListener() {
                    @Override
                    public void onDismiss() {
                        BackGroundUtil.backgroundAlpha(mActivity, 1f);

                    }
                });
                break;
            case 1:
            case 2:
            case 3:
//                ShareUtils shareUtils = new ShareUtils();
//                shareUtils.shareFactory(activity, shareType + "", share);
//                if (null != shareSuccess) {
//                    shareUtils.setShareSuccess(shareSuccess);
//                }
                break;
        }
    }
}
