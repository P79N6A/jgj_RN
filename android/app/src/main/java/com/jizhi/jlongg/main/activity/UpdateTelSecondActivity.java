package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.google.gson.Gson;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.RegisterTimerButton;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 修改手机号码第二步
 *
 * @author Xuj
 * @time 2017年3月24日16:17:28
 * @Version 1.0
 */
public class UpdateTelSecondActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 电话号码输入框
     */
    private EditText telEdit;
    /**
     * 下一步、获取验证码按钮
     */
    private Button nextBtn, getCodeBtn;
    /**
     * 验证码第1、2、3、4个文本
     */
    private EditText firstNumber, secondNumber, threeNumber, fourNumber;
    /**
     * 验证码倒计时
     */
    private RegisterTimerButton timer;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.update_telphone_second);
        initView();
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String oldTelphone, String token) {
        Intent intent = new Intent(context, UpdateTelSecondActivity.class);
        intent.putExtra(Constance.TELEPHONE, oldTelphone);
        intent.putExtra("token", token);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    private void initView() {
        telEdit = (EditText) findViewById(R.id.telEdit);
        telEdit.setHint("请输入新手机号");
        setTextTitle(R.string.update_telphone);
        nextBtn = getButton(R.id.nextBtn);
        firstNumber = (EditText) findViewById(R.id.firstNumber);
        secondNumber = (EditText) findViewById(R.id.secondNumber);
        threeNumber = (EditText) findViewById(R.id.threeNumber);
        fourNumber = (EditText) findViewById(R.id.fourNumber);
        getCodeBtn = getButton(R.id.getCodeBtn);
        btnUnClick();
        timer = new RegisterTimerButton(60000, 1000, getCodeBtn, getResources());

        firstNumber.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String keyboard = s.toString();
                if (!TextUtils.isEmpty(keyboard)) {
                    secondNumber.setFocusable(true);
                    secondNumber.requestFocus();
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        secondNumber.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String keyboard = s.toString();
                if (!TextUtils.isEmpty(keyboard)) {
                    threeNumber.setFocusable(true);
                    threeNumber.requestFocus();
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        threeNumber.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String keyboard = s.toString();
                if (!TextUtils.isEmpty(keyboard)) {
                    fourNumber.setFocusable(true);
                    fourNumber.requestFocus();
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        fourNumber.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String keyboard = s.toString();
                if (TextUtils.isEmpty(keyboard)) {
                    btnUnClick();
                } else {
                    btnCanClick();
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        new Timer().schedule(new TimerTask() {
            public void run() {
                showSoftKeyboard(telEdit);
            }
        }, 300);
    }


    /**
     * 设置下一步按钮不可点击 并且置灰
     */
    private void btnUnClick() {
        nextBtn.setClickable(false);
        Utils.setBackGround(nextBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    /**
     * 设置下一步按钮可点击 并且置红
     */
    private void btnCanClick() {
        nextBtn.setClickable(true);
        Utils.setBackGround(nextBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
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
                String first = firstNumber.getText().toString().trim();
                String second = secondNumber.getText().toString().trim();
                String three = threeNumber.getText().toString().trim();
                String four = fourNumber.getText().toString().trim();
                if (TextUtils.isEmpty(first) || TextUtils.isEmpty(second) || TextUtils.isEmpty(three) || TextUtils.isEmpty(four)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.please_input_code_first), CommonMethod.ERROR);
                    return;
                }
                String token = getIntent().getStringExtra("token");
                if (TextUtils.isEmpty(token)) {
                    updateNewTel(first + second + three + four, newTelphone);
                } else {
                    findPwdUpdateTelphone(first + second + three + four, token, newTelphone);
                }
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
                if (timer != null) {
                    timer.start();
                }
            }
        });
    }

    /**
     * 找回密码-->修改电话号码
     *
     * @param vcode 验证码
     */
    public void findPwdUpdateTelphone(String vcode, String token, String newTelphone) {
        String httpUrl = NetWorkRequest.FIND_ACCOUNT_CHANGE_TELPHONE;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("vcode", vcode);
        params.addBodyParameter("token", getIntent().getStringExtra("token")); //v2/signup/findaccount返回的token
        params.addBodyParameter("telephone", newTelphone); //新的手机号码
        CommonHttpRequest.commonRequest(this, httpUrl, Object.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "电话号码已修改成功", CommonMethod.SUCCESS);
                setResult(1);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

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
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFY_TELPHONE, params, new RequestCallBackExpand<String>() {
            @SuppressWarnings("deprecation")
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                closeDialog();
                Gson gson = new Gson();
                try {
                    BaseNetBean base = gson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() == 0) {
                        CommonMethod.makeNoticeShort(getApplicationContext(), base.getErrmsg(), CommonMethod.ERROR);
                    } else {
                        CommonMethod.makeNoticeShort(getApplicationContext(), "电话号码已修改成功", CommonMethod.SUCCESS);
                        DataUtil.UpdateLoginver(UpdateTelSecondActivity.this);
                        SPUtils.put(getApplicationContext(), Constance.TELEPHONE, telEdit.getText().toString().trim(), Constance.JLONGG); //重新存放本地的号码
                        setResult(Constance.UPDATE_TEL_SUCCESS);
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                }
            }
        });
    }
}