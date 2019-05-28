package com.jizhi.jlongg.main.activity.welcome;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.View;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.view.annotation.event.OnClick;

/**
 * huchangsheng：Administrator on 2016/3/9 11:42
 */
public class ChooseRoleActivity extends BaseActivity implements View.OnClickListener {

    private String url;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param isLoginFirst true 表示还没登陆 false表示已登陆只是来切换一下角色
     */
    public static void actionStart(Activity context, boolean isLoginFirst) {
        Intent intent = new Intent(context, ChooseRoleActivity.class);
        intent.putExtra(Constance.BEAN_BOOLEAN, isLoginFirst);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param isLoginFirst true 表示还没登陆 false表示已登陆只是来切换一下角色
     * @param scheme       不用升级App未登录情况下需要传递scheme
     */
    public static void actionStart(Activity context, boolean isLoginFirst, String scheme) {
        Intent intent = new Intent(context, ChooseRoleActivity.class);
        intent.putExtra(Constance.BEAN_BOOLEAN, isLoginFirst);
        intent.putExtra(Constance.COMPLETE_SCHEME, scheme);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRestartWebSocketService(false);
        setContentView(R.layout.layout_welcome_chooserole);
//        setContentView(R.layout.activity_choose);
        ViewUtils.inject(this);
        //true 表示是第一次运行App 选择角色
        boolean isLoginFirst = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        url = getIntent().getStringExtra(Constance.COMPLETE_SCHEME);
        findViewById(R.id.closeima).setVisibility(isLoginFirst ? View.GONE : View.VISIBLE);
        findViewById(R.id.rea_worker).setOnClickListener(this);
        findViewById(R.id.rea_forman).setOnClickListener(this);

        if (!getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
            findViewById(R.id.role_worker).setVisibility(UclientApplication.getRoler(ChooseRoleActivity.this).equals(Constance.ROLETYPE_WORKER) ? View.VISIBLE : View.GONE);
            findViewById(R.id.role_forman).setVisibility(UclientApplication.getRoler(ChooseRoleActivity.this).equals(Constance.ROLETYPE_FM) ? View.VISIBLE : View.GONE);
        } else {
            findViewById(R.id.role_worker).setVisibility(View.GONE);
            findViewById(R.id.role_forman).setVisibility(View.GONE);
        }


    }

    @Override
    public void onClick(View views) {
        switch (views.getId()) {
            case R.id.rea_worker: //工人
                DataUtil.UpdateLoginver(ChooseRoleActivity.this);
                setServeRole(Constance.ROLETYPE_WORKER);
                break;
            case R.id.rea_forman: //班组长
                DataUtil.UpdateLoginver(ChooseRoleActivity.this);
                setServeRole(Constance.ROLETYPE_FM);
                break;
        }

    }

    @OnClick(R.id.closeima)
    public void closeima(View view) {
        finish();
    }

    //角色切换上传服务器
    private void setServeRole(final String role) {//2点击工头；1点击工友
        String currnRole = UclientApplication.getRoler(this);//本地角色
        final boolean isLoginFirst = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        if (role.equals(currnRole) && !isLoginFirst) {//没改变角色,并且不是第一次登陆角色
//            CommonMethod.makeNoticeShort(ChooseRoleActivity.this, role.equals(Constance.ROLETYPE_FM) ? "你已切换到班组长/工头身份" : "你已切换到工人身份", CommonMethod.SUCCESS);
            CommonMethod.makeNoticeShort(ChooseRoleActivity.this, "切换身份成功!", CommonMethod.SUCCESS);
            LocalBroadcastManager.getInstance(this).sendBroadcast(new Intent(Constance.SWITCH_ROLER_BROADCAST)); //我们这里发送一条广播通知一下
            setResult(Constance.SWITCH_ROLER);
            finish();
            overridePendingTransition(R.anim.slide_alpha2, R.anim.slide_alpha);
            return;
        }
        CommonHttpRequest.changeRoler(this, isLoginFirst, role, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                findViewById(R.id.role_worker).setVisibility(role.equals(Constance.ROLETYPE_WORKER) ? View.VISIBLE : View.GONE);
                findViewById(R.id.role_forman).setVisibility(role.equals(Constance.ROLETYPE_FM) ? View.VISIBLE : View.GONE);
                if (isLoginFirst) { //true 表示是在登陆时选择角色
                    Intent intent = new Intent(ChooseRoleActivity.this, AppMainActivity.class);
                    if (!TextUtils.isEmpty(url)) {
                        intent.putExtra(Constance.COMPLETE_SCHEME, url);
                    }
                    startActivity(intent);
                    finish();
                    overridePendingTransition(R.anim.slide_alpha2, R.anim.slide_alpha);
                    LUtils.e("---------111------");
                } else {
                    LUtils.e("---------2222------");

                    Utils.sendBroadCastToUpdateInfo(ChooseRoleActivity.this);
                    setResult(Constance.SWITCH_ROLER);
                    finish();
                    overridePendingTransition(R.anim.slide_alpha2, R.anim.slide_alpha);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}
