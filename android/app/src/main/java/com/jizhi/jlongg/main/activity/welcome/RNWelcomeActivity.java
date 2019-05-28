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

import com.facebook.react.ReactActivity;
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
public class RNWelcomeActivity extends ReactActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_loading);


    }

//
//    /**
//     * 跳转页面
//     */
//    public void startActivity() {
//        Intent intent = new Intent();
//        //URL scheme的取得
//        Intent intent_scheme = getIntent();
//        String action = intent_scheme.getAction();
//        if (Intent.ACTION_VIEW.equals(action)) {
//            Uri url = intent_scheme.getData();
//            if (UclientApplication.isLogin(RNWelcomeActivity.this) && url != null && url.toString().contains(Constance.SCHEME)) {
//                intent.putExtra(Constance.COMPLETE_SCHEME, url.toString());
//                LUtils.e("--url scheme通过intent传值welcome--" + url.toString() + "");
//            }
//        }
//        int last_ver_code = (int) SPUtils.get(getApplicationContext(), "last_ver_code", 0, Constance.JLONGG);
//        if (AppUtils.getVersionCode(getApplicationContext()) != last_ver_code) {
//            SPUtils.put(getApplicationContext(), "last_ver_code", AppUtils.getVersionCode(getApplicationContext()), Constance.JLONGG); // 存放Token信息
//            intent.setClass(this, FirstInActivity.class);
//        } else {
//            if (UclientApplication.isLogin(RNWelcomeActivity.this)) { //已登录直接进入首页
//                intent.setClass(RNWelcomeActivity.this, AppMainActivity.class);
//                if (currentRole != null) {
//                    intent.putExtra(Constance.PID, getIntent().getIntExtra(Constance.PID, 0));
//                    intent.putExtra(Constance.JOIN_STATUS, getIntent().getStringExtra(Constance.JOIN_STATUS));
//                    intent.putExtra(Constance.ROLE, currentRole);
//                    intent.putExtra("msg_type", msg_type); //消息类别
//                }
//            } else {
//                intent.setClass(RNWelcomeActivity.this, LoginActivity.class);
//            }
//        }
//        startActivity(intent);
//        finish();
//    }


}