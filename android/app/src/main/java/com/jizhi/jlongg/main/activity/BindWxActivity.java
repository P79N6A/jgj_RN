package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.LoginTimer;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 绑定微信页面
 *
 * @author Xuj
 * @time 2018年3月14日10:00:59
 * @Version 1.0
 */
public class BindWxActivity extends BaseActivity implements OnClickListener {
    /**
     * 手机号
     */
    private EditText telEdit;
    /**
     * 验证码
     */
    private EditText codeEdit;
    /**
     * 获取验证码按钮
     */
    private TextView getCodeBtn;
    /**
     * 登录文本
     */
    private Button bindBtn;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param wechatid 微信唯一id
     */
    public static void actionStart(Activity context, String wechatid) {
        Intent intent = new Intent(context, BindWxActivity.class);
        intent.putExtra("wechatid", wechatid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bind_wx);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.bind_tel_number);
        telEdit = getEditText(R.id.telEdit);
        codeEdit = getEditText(R.id.codeEdit);
        getCodeBtn = getTextView(R.id.getCodeBtn);
        bindBtn = getButton(R.id.bindBtn);
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void afterTextChanged(Editable editable) {
                if (!TextUtils.isEmpty(telEdit.getText().toString()) && !TextUtils.isEmpty(codeEdit.getText().toString())) {
                    setLoginBtnEnable();
                } else {
                    setLoginBtnUnEnable();
                }
            }
        };
        telEdit.addTextChangedListener(textWatcher);
        codeEdit.addTextChangedListener(textWatcher);
        setLoginBtnUnEnable();
    }

    /**
     * 设置按钮不可点时的颜色
     */
    private void setLoginBtnUnEnable() {
        Utils.setBackGround(bindBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
        bindBtn.setClickable(false);
    }

    /**
     * 设置按钮可点时的颜色
     */
    private void setLoginBtnEnable() {
        Utils.setBackGround(bindBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
        bindBtn.setClickable(true);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.getCodeBtn: //获取验证码
                if (StrUtil.isFastDoubleClick()) {
                    return;
                }
                String value = telEdit.getText().toString().trim();
                if (StrUtil.isNull(value)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_mobile), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(value)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                getCodeBtn.setClickable(false);
                GetCodeUtil.getCode(this, value, Constance.LOGIN_APP_CODE, new GetCodeUtil.NetRequestListener() {
                    @Override
                    public void onFailure() {
                        getCodeBtn.setClickable(true);
                    }

                    @Override
                    public void onSuccess() {
                        new LoginTimer(60000, 1000, getCodeBtn, getResources()).start();
                        codeEdit.requestFocus();
                        new Timer().schedule(new TimerTask() {
                            public void run() {
                                showSoftKeyboard(codeEdit);
                            }
                        }, 200);
                    }
                });
                break;
            case R.id.bindBtn: //绑定微信按钮
                String phone = telEdit.getText().toString().trim(); // 手机号
                if (TextUtils.isEmpty(phone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.mobile_is_no_empty), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(phone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                String password_value = codeEdit.getText().toString(); // 验证码
                if (TextUtils.isEmpty(password_value)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_message_code), CommonMethod.ERROR);
                    return;
                }
                login();
                break;
        }
    }


    /**
     * 登录验证
     */
    public void login() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("os", "A");//平台系统 W电脑端、A安卓端、I苹果端、M平板
        params.addBodyParameter("telph", telEdit.getText().toString().trim());// 用户名
        params.addBodyParameter("vcode", codeEdit.getText().toString().trim());// 验证码
        params.addBodyParameter("wechatid", getIntent().getStringExtra("wechatid"));//微信唯一id
        params.addBodyParameter("role", UclientApplication.getRoler(getApplicationContext()));// 角色
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LOGIN, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        //放置一些基本信息 如头像、姓名、是否已经完善姓名等资料
                        DataUtil.putUserLoginInfo(BindWxActivity.this, base.getValues());
                        setResult(Constance.LOGIN_SUCCESS);
                        finish();
                    } else {
                        CommonMethod.makeNoticeShort(BindWxActivity.this, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(BindWxActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

}