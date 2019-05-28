package com.jizhi.jlongg.main.activity.welcome;

import android.Manifest;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Window;
import android.view.WindowManager;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ReadAddressBook;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AddressBook;
import com.jizhi.jlongg.main.bean.RecordWorkPoints;
import com.jizhi.jlongg.main.fragment.CalendarMainFragment;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.umeng.analytics.MobclickAgent;
import com.umeng.message.UmengNotifyClickActivity;

import java.util.Calendar;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-17 下午2:41:57
 */
public class WelcomeActivity extends UmengNotifyClickActivity {
    private String token;
    private String currentRole;
    private int pid;
    private String JOIN_STATUS;
    private String msg_type;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            if ((getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT) != 0) { //解决android 按home键 app需要重新打开
                //app处于前台，保存scheme信息
                Intent intent_scheme = getIntent();
                String action = intent_scheme.getAction();
                if (Intent.ACTION_VIEW.equals(action)) {
                    Uri url = intent_scheme.getData();
                    if (UclientApplication.isLogin(WelcomeActivity.this) && url != null && url.toString().contains(Constance.SCHEME)) {
                        LUtils.e("--url app在前台存活，传值--" + url.toString() + "");
                        Intent intent = new Intent(Constance.URL_JUMP_ACTION);
                        intent.putExtra(Constance.COMPLETE_SCHEME, url.toString());
                        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                    }
                }

                finish();
                return;
            }
        } catch (Exception e) {
            e.getMessage();
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
        }
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_loading);
        prestrainData();
        try {
            Utils.closeAndroidPDialog();
        } catch (Exception e) {

        }
        pushMsg();
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                isUpdateAddress();
            }
        }, 3000);
    }

    /**
     * 预加载数据
     */
    public void prestrainData() {
        //必须登录了才加载数据
        if (UclientApplication.isLogin(getApplicationContext())) {
            //拉取离线消息
            MessageUtils.getOffMessageList(getApplicationContext(), false);
            if (UclientApplication.isHasRealName(getApplicationContext())) {
                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                Calendar calendar = Calendar.getInstance();
                int monthInt = calendar.get(Calendar.MONTH) + 1;
                String month = monthInt >= 10 ? monthInt + "" : "0" + monthInt; //讲2016-01月格式拼接为 1601
                params.addBodyParameter("date", calendar.get(Calendar.YEAR) + month);// 项目id
                String httpUrl = NetWorkRequest.WORKER_MONTH_TOTAL;
                CommonHttpRequest.commonRequest(getApplicationContext(), httpUrl, RecordWorkPoints.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        CalendarMainFragment.prestrainData = (RecordWorkPoints) object;
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                    }
                });
            }
        }
    }


    public void pushMsg() {
        Intent intent = getIntent();
        currentRole = intent.getDataString();
        if (intent != null) {
            currentRole = intent.getStringExtra(Constance.ROLE);
            if (!TextUtils.isEmpty(currentRole)) {
                pid = intent.getIntExtra(Constance.PID, 0);
                JOIN_STATUS = intent.getStringExtra(Constance.JOIN_STATUS);
                msg_type = intent.getStringExtra("msg_type");
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    /**
     * 跳转页面
     */
    public void startActivity() {
        Intent intent = new Intent();
        //URL scheme的取得
        Intent intent_scheme = getIntent();
        String action = intent_scheme.getAction();
        if (Intent.ACTION_VIEW.equals(action)) {
            Uri url = intent_scheme.getData();
            if (UclientApplication.isLogin(WelcomeActivity.this) && url != null && url.toString().contains(Constance.SCHEME)) {
                intent.putExtra(Constance.COMPLETE_SCHEME, url.toString());
                LUtils.e("--url scheme通过intent传值welcome--" + url.toString() + "");
            }
        }
        int last_ver_code = (int) SPUtils.get(getApplicationContext(), "last_ver_code", 0, Constance.JLONGG);
        if (AppUtils.getVersionCode(getApplicationContext()) != last_ver_code) {
            SPUtils.put(getApplicationContext(), "last_ver_code", AppUtils.getVersionCode(getApplicationContext()), Constance.JLONGG); // 存放Token信息
            intent.setClass(this, FirstInActivity.class);
        } else {
            if (UclientApplication.isLogin(WelcomeActivity.this)) { //已登录直接进入首页
                intent.setClass(WelcomeActivity.this, AppMainActivity.class);
                if (currentRole != null) {
                    intent.putExtra(Constance.PID, pid);
                    intent.putExtra(Constance.JOIN_STATUS, JOIN_STATUS);
                    intent.putExtra(Constance.ROLE, currentRole);
                    intent.putExtra("msg_type", msg_type); //消息类别
                }
            } else {
                intent.setClass(WelcomeActivity.this, LoginActivity.class);
            }
        }
        startActivity(intent);
        finish();
    }

    /**
     * 判断是否上传通讯录
     */
    private void isUpdateAddress() {
        token = (String) SPUtils.get(WelcomeActivity.this, "TOKEN", "", Constance.JLONGG);
        // 没有登录无需操作通讯录
        if (!TextUtils.isEmpty(token)) {
            if (TimesUtils.isBigNowTime(getApplicationContext())) {
                Acp.getInstance(WelcomeActivity.this).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_CONTACTS).build(), new AcpListener() {
                    @Override
                    public void onGranted() {
                        uploadAddress();
                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                        startActivity();
                    }
                });
            } else {
                startActivity();
            }
        } else {
            startActivity();
        }
    }

    private void uploadAddress() {
        List<AddressBook> addressBooks = ReadAddressBook.getAddrBook(WelcomeActivity.this);
        if (null == addressBooks || addressBooks.size() == 0) {
            startActivity();
        } else {
            Gson gson = new Gson();
            String array = gson.toJson(addressBooks);
            upAddrBook(array, token);
        }
    }

    /**
     * 上传通讯录信息
     *
     * @param array
     * @param stoken
     */
    public void upAddrBook(String array, String stoken) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.setHeader("Authorization", stoken);
        params.addBodyParameter("contacts", array);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ADDRESSBOOK, params, new RequestCallBack<String>() {
            @Override
            public void onFailure(HttpException arg0, String arg1) {
                startActivity();
            }

            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                TimesUtils.getNowTimeMillAdd1Month(getApplicationContext());
                startActivity();
            }
        });
    }

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


}