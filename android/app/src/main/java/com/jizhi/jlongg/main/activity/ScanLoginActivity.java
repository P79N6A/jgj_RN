package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;


/**
 * 扫码登录
 *
 * @author Xuj
 * @time 2017年7月13日10:50:43
 * @Version 1.0
 */
public class ScanLoginActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String qrcode_token) {
        Intent intent = new Intent(context, ScanLoginActivity.class);
        intent.putExtra("qrcode_token", qrcode_token);
        context.startActivityForResult(intent, Constance.REQUEST);
        context.overridePendingTransition(R.anim.scan_login_open, R.anim.scan_login_close);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.scan_login);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.closeBtn: //关闭
                finishExecuteAnimActivity();
                break;
            case R.id.cancelLoginBtn: //取消登录
                finishExecuteAnimActivity();
                break;
            case R.id.loginBtn: //登录
                login();
                break;
        }
    }

    /**
     * 关闭本页面执行的动画
     */
    public void finishExecuteAnimActivity() {
        finish();
        overridePendingTransition(0, R.anim.scan_login_close);
    }


    /**
     * 登录验证
     */
    public void login() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("qrcode_token", getIntent().getStringExtra("qrcode_token"));// 	二维码token
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SCAN_LOGIN,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                finishExecuteAnimActivity();
                            } else {
                                DataUtil.showErrOrMsg(ScanLoginActivity.this, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }


    @Override
    public void onBackPressed() {
        finishExecuteAnimActivity();
    }
}