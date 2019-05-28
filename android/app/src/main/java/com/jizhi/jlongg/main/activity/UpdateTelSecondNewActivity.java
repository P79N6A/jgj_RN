package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.RegisterTimerButton;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.main.util.shadow.ShadowUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 修改手机号码第二步
 *
 * @author Xuj
 * @time 2017年3月24日16:17:28
 * @Version 1.0
 */
public class UpdateTelSecondNewActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 电话号码输入框
     */
    private EditText telEdit;
    /**
     * 验证码
     */
    private EditText codeEdit;
    /**
     * 下一步、获取验证码按钮
     */
    private Button nextBtn, getCodeBtn;
    /**
     * 验证码布局
     */
    private LinearLayout codeLayout;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.update_telphone_second_new);
        initView();
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String oldTelphone) {
        Intent intent = new Intent(context, UpdateTelSecondNewActivity.class);
        intent.putExtra(Constance.TELEPHONE, oldTelphone);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    private void initView() {
        setTextTitle(R.string.update_telphone);
        telEdit = (EditText) findViewById(R.id.telEdit);
        codeEdit = (EditText) findViewById(R.id.codeEdit);
        codeLayout = (LinearLayout) findViewById(R.id.codeLayout);
        nextBtn = getButton(R.id.nextBtn);
        getCodeBtn = getButton(R.id.getCodeBtn);
        ShadowUtil.setShadowAndUserOriginalBackground(this, nextBtn, Color.parseColor("#fb4e4e")); //登录按钮设置阴影
        //但有时，我们确实是想让EditText自动获得焦点并弹出软键盘，在设置了EditText自动获得焦点后，
        // 软件盘不会弹出。注意：此时是由于刚跳到一个新的界面，界面未加载完全而无法弹出软键盘。
        // 此时应该适当的延迟弹出软键盘，如500毫秒（保证界面的数据加载完成，如果500毫秒仍未弹出，
        // 则延长至500毫秒）。可以在EditText后面加上一段代码，实例代码如下：
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
        codeEdit.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                Utils.setBackGround(codeLayout, getResources().getDrawable(hasFocus ? R.drawable.login_pwd_red_background : R.drawable.login_pwd_background));
            }
        });
        setLoginBtnUnEnable();
        new Timer().schedule(new TimerTask() {
            public void run() {
                showSoftKeyboard(telEdit);
            }
        }, 300);

        String telphone = UclientApplication.getTelephone(getApplicationContext()); //获取当前登录对象的电话号码
        if (TextUtils.isEmpty(telphone) || telphone.length() != 11) { //如果为空或者不等于11位则不让进入当前页面
            CommonMethod.makeNoticeShort(getApplicationContext(), "获取电话号码出错", CommonMethod.ERROR);
            finish();
            return;
        }
        TextView telephoneText = getTextView(R.id.telephone_text);
        telephoneText.setText("当前手机号：" + telphone);
    }

    /**
     * 设置按钮不可点时的颜色
     */
    private void setLoginBtnUnEnable() {
        nextBtn.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.white_50_alpha));
        nextBtn.setClickable(false);
    }

    /**
     * 设置按钮可点时的颜色
     */
    private void setLoginBtnEnable() {
        nextBtn.setTextColor(ContextCompat.getColor(getApplicationContext(), android.R.color.white));
        nextBtn.setClickable(true);
    }


    @Override
    public void onClick(View v) {
        //确定下一步
        switch (v.getId()) {
            case R.id.nextBtn: //下一步按钮
                String newTelphone = telEdit.getText().toString().trim();
                if (StrUtil.isNull(newTelphone)) { //手机号码不能为空
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_mobile), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(newTelphone)) {  //验证是否是手机号码的格式
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                updateNewTel(codeEdit.getText().toString().trim(), newTelphone);
                break;
            case R.id.getCodeBtn: //获取验证码
                if (StrUtil.isFastDoubleClick()) {
                    return;
                }
                String tel = telEdit.getText().toString().trim();
                if (StrUtil.isNull(tel)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_mobile), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(tel)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                getCode(tel);
                break;
        }
    }

    /**
     * 获取验证码
     *
     * @param tel 电话
     */
    public void getCode(String tel) {
        getCodeBtn.setClickable(false); //设置获取验证码按钮不可点击
        GetCodeUtil.getCode(this, tel, Constance.UPDATE_TELPHONE_CODE, new GetCodeUtil.NetRequestListener() {
            @Override
            public void onFailure() {
                getCodeBtn.setClickable(true);
            }

            @Override
            public void onSuccess() {
                new RegisterTimerButton(60000, 1000, getCodeBtn, getResources()).start();
                codeEdit.requestFocus();
                new Timer().schedule(new TimerTask() {
                    public void run() {
                        showSoftKeyboard(codeEdit);
                    }
                }, 200);
            }
        });
    }


    /**
     * 修改新的手机号码数据
     *
     * @param vcode 验证码
     */
    public void updateNewTel(String vcode, String newTelphone) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("vcode", vcode);
        params.addBodyParameter("telph", getIntent().getStringExtra(Constance.TELEPHONE)); //原手机号码
        params.addBodyParameter("ntelph", newTelphone); //新的手机号码
        CommonHttpRequest.commonRequest(this, NetWorkRequest.MODIFY_TELPHONE, BaseNetBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "电话号码已修改成功", CommonMethod.SUCCESS);
                DataUtil.UpdateLoginver(UpdateTelSecondNewActivity.this);
                SPUtils.put(getApplicationContext(), Constance.TELEPHONE, telEdit.getText().toString().trim(), Constance.JLONGG); //重新存放本地的号码
                setResult(Constance.UPDATE_TEL_SUCCESS);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}