package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.InputFilter;
import android.text.InputType;
import android.text.Selection;
import android.text.Spannable;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.screenshot.ScreenShotListenManager;
import com.jizhi.jlongg.screenshot.ScreenShotManager;
import com.jizhi.jlongg.service.WebSocketHeartRateService;
import com.jizhi.jongg.widget.MyRattingBar;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.readystatesoftware.systembartint.SystemBarTintManager;
import com.umeng.analytics.MobclickAgent;
import com.umeng.message.PushAgent;
import com.umeng.message.UmengNotifyClickActivity;

import org.android.agoo.common.AgooConstants;

import java.io.File;
import java.util.Timer;
import java.util.TimerTask;

import io.reactivex.disposables.Disposable;

/**
 * 功能:父Activity
 * 时间:2016-4-19 16:29
 * 作者:xuj UmengNotifyClickActivity
 */
public class BaseActivity extends FragmentActivity  {


    /**
     * 加载对话框
     */
    public CustomProgress customProgress;
    /**
     * LocalBroadcastManager是Android Support包提供了一个工具，是用来在同一个应用内的不同组件间发送Broadcast的。
     * 使用LocalBroadcastManager有如下好处：发送的广播只会在自己App内传播，不会泄露给其他App，确保隐私数据不会泄露
     * 其他App也无法向你的App发送该广播，不用担心其他App会来搞破坏比系统全局广播更加高效
     */
    public LocalBroadcastManager broadcastManager;
    public static String mobile_phone;
    public static final String FINISHACTIVITY = "com.activity.finish.all";
    private boolean isRestartWebSocketService = true;
    protected Disposable disposable;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        broadcastManager = LocalBroadcastManager.getInstance(this);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
        }
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.black);
        //友盟推送统计设备信息
        PushAgent.getInstance(this).onAppStart();
        getMobile_phone();
    }

    class Umengpush extends UmengNotifyClickActivity {
        @Override
        public void onMessage(Intent intent) {
            super.onMessage(intent);  //此方法必须调用，否则无法统计打开数
            String body = intent.getStringExtra(AgooConstants.MESSAGE_BODY);
            LUtils.e("----------------" + body);
        }
    }

    public EditText getEditText(int id) {
        return (EditText) findViewById(id);
    }

    public TextView getTextView(int id) {
        return (TextView) findViewById(id);
    }

    public Button getButton(int id) {
        return (Button) findViewById(id);
    }

    public ImageView getImageView(int id) {
        return (ImageView) findViewById(id);
    }

    public MyRattingBar getRatingBar(int id) {
        return (MyRattingBar) findViewById(id);
    }

    BroadcastReceiver receiverFinish = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            BaseActivity.this.setResult(Constance.MAIN_GAGE_ONE, getIntent());
            finish();
        }
    };

    /**
     * 注册了此广播的所有activity
     */
    public void registerFinishActivity() {
        if (null != receiverFinish) {
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(FINISHACTIVITY);
            registerReceiver(receiverFinish, intentFilter);
        }
    }

    /**
     * 关闭注册了此广播的所有activity
     */
    public void unregisterFinishActivity() {
        if (receiverFinish != null) {
            unregisterReceiver(receiverFinish);
        }
    }

    public void getMobile_phone() {
        mobile_phone = (String) SPUtils.get(getApplicationContext(), Constance.TELEPHONE.toString(), "", Constance.JLONGG);
    }

    /**
     * 显示listView 底部加载对话框
     *
     * @return
     */
    public View loadMoreDataView() {
        View foot_view = getLayoutInflater().inflate(R.layout.foot_loading_dialog, null); // 加载对话框
        foot_view.setVisibility(View.GONE);
        return foot_view;
    }


    public void setTextTitleAndRight(int title, int righttitle) {
        SetTitleName.setTitle(findViewById(R.id.title), getString(title));
        SetTitleName.setTitle(findViewById(R.id.right_title), getString(righttitle));
    }

    public void setTextTitle(int title) {
        SetTitleName.setTitle(findViewById(R.id.title), getString(title));

    }


    @TargetApi(19)
    public void setTranslucentStatus(boolean on) {
        Window win = getWindow();
        WindowManager.LayoutParams winParams = win.getAttributes();
        final int bits = WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;
        if (on) {
            winParams.flags |= bits;
        } else {
            winParams.flags &= ~bits;
        }
        win.setAttributes(winParams);
    }

    public void onFinish(View view) {
        finish();
    }

    /**
     * 打印网络连接错误信息
     */
    public void printNetLog(String msg, Activity activity) {
        StringBuffer sb = new StringBuffer();
        sb.append(getString(R.string.conn_fail));
        CommonMethod.makeNoticeShort(activity, sb.toString(), CommonMethod.ERROR);
    }

    public abstract class RequestCallBackExpand<T> extends RequestCallBack<String> {

        public RequestCallBackExpand() {
            createCustomDialog();
        }


        @Override
        public void onStart() {
            super.onStart();
        }

        /**
         * xutils 连接失败 调用的 方法
         */
        @Override
        public void onFailure(HttpException exception, String errormsg) {
            printNetLog(errormsg, BaseActivity.this);
            closeDialog();
        }

    }

    public void closeDialog() {
        if (null != customProgress && customProgress.isShowing()) {
            customProgress.closeDialog();
            customProgress = null;
        }
    }


    public void createCustomDialog() {
        if (customProgress != null) {
        } else {
            customProgress = new CustomProgress(BaseActivity.this);
            customProgress.show(BaseActivity.this, null, false);
        }
    }

    /**
     * 1  MobclickAgent.onResume()  和MobclickAgent.onPause()  方法是用来统计应用时长的(也就是Session时长,当然还包括一些其他功能)
     * 2  MobclickAgent.onPageStart() 和MobclickAgent.onPageEnd() 方法是用来统计页面跳转的
     */
    @Override
    protected void onResume() {
        super.onResume();
        if (UclientApplication.isLogin(getApplicationContext()) && isRestartWebSocketService) {
            startSocketHeartService();
        }
        MobclickAgent.onPageStart("jigongjiaact");
        MobclickAgent.onResume(this);
        checkScreenShotPermission();
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd("jigongjiaact"); // 保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPause(this);
        stopScreenShotListener();
    }

    /**
     * 停止截屏监听
     */
    public void stopScreenShotListener() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                //进入到这里代表已经获取权限
                ScreenShotListenManager.newInstance(getApplicationContext()).stopListen();
            }
        } else {
            ScreenShotListenManager.newInstance(getApplicationContext()).stopListen();
        }
    }


    /**
     * 开启截屏监听
     */
    public void checkScreenShotPermission() {
        //大于6.0版本的手机需要确认是否有读取本地文件的权限,这个权限的获取只会在手机第一次进入首页的时候进行权限获取，如果没有权限将无法读取截屏的图片
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                //进入到这里表示已经获取了权限
                startScreenShotListener();
            }
        } else { //6.0版本以下的手机
            startScreenShotListener();
        }
    }


    public void startScreenShotListener() {
        ScreenShotListenManager screenShotListenManager = ScreenShotListenManager.newInstance(getApplicationContext());
        screenShotListenManager.setListener(new ScreenShotListenManager.OnScreenShotListener() {
            @Override
            public void onShot(String imagePath) {
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !Settings.canDrawOverlays(BaseActivity.this)) { //大于8.0版本的手机需要获取弹窗置顶的权限
//                    Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
//                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                    startActivityForResult(intent, 1);
//                    return;
//                }
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                LUtils.e("获取截屏图片文件路径:" + imagePath);
                if (new File(imagePath).exists()) {
                    ScreenShotManager.createScreenShotViewAndStartTimer(BaseActivity.this, imagePath);
                }
            }
        });
        screenShotListenManager.startListen();
    }


    /**
     * 开启WebSocket心跳服务
     */
    public void startSocketHeartService() {
        Intent intent = new Intent(this, WebSocketHeartRateService.class);
        startService(intent);
    }


    /**
     * 隐藏键盘
     */
    protected void hideSoftKeyboard() {
        if (getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
    }


    /**
     * 弹出键盘
     */
    public void showSoftKeyboard(EditText telEdit) {
        if (getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                inputMethodManager.showSoftInput(telEdit, 0);
            }
        }
    }


    /**
     * EditText 光标至于 最后一位
     */
    public void cursorEnd(final EditText editext) {
        CharSequence text = editext.getText();
        if (text instanceof Spannable) {
            Spannable spanText = (Spannable) text;
            Selection.setSelection(spanText, text.length());
        }
        Timer timer = new Timer();
        //对于刚跳到一个新的界面就要弹出软键盘的情况上述代码可能由于界面为加载完全而无法弹出软键盘。此时应该适当的延迟弹出软键盘如998毫秒（保证界面的数据加载完成）。实例代码如下：
        timer.schedule(new TimerTask() {
            public void run() {
                showSoftKeyboard(editext);
            }
        }, 400);
    }

    /**
     * 广播接收器 主要是Socket使用
     */
    public BroadcastReceiver receiver;

    public BroadcastReceiver getReceiver() {
        return receiver;
    }

    public void setReceiver(BroadcastReceiver receiver) {
        this.receiver = receiver;
    }

    /**
     * 取消广播绑定
     */
    public void unRegisterReceiver() {
        if (receiver != null) {
            broadcastManager.unregisterReceiver(receiver);
        }
    }

    public void registerLocal(BroadcastReceiver receiver, IntentFilter filter) {
        broadcastManager.registerReceiver(receiver, filter);
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        unRegisterReceiver();
        if (disposable != null && !disposable.isDisposed()) {
            disposable.dispose();
        }
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param length        小数点前面位数
     * @param decimal_place 小数点后面位数
     */
    public void setEditTextDecimalNumberLength(EditText editText, int length, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(length, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }
    }

    public void setRestartWebSocketService(boolean restartWebSocketService) {
        isRestartWebSocketService = restartWebSocketService;
    }
}
