package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.UnSubscribeListener;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.RegisterTimerButton;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 功能:取消注册弹框
 * 时间:2018年1月5日10:17:55
 * 作者:xuj
 */
public class DialogUnSubscribe extends Dialog implements View.OnClickListener {
    /**
     * 注册
     */
    private UnSubscribeListener listener;
    /**
     * 电话号码
     */
    private String myPhone;
    /**
     * 获取验证码按钮
     */
    private Button getCodeBtn;
    /**
     * 验证码输入框
     */
    private EditText codeEdit;

    private BaseActivity activity;

    public DialogUnSubscribe(BaseActivity activity, UnSubscribeListener listener) {
        super(activity, R.style.Custom_Progress);
        createLayout(activity);
        this.activity = activity;
        this.listener = listener;
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(Activity activity) {
        setContentView(R.layout.dialog_unsubscribe);
        TextView telphone = (TextView) findViewById(R.id.telphone);
        getCodeBtn = (Button) findViewById(R.id.getCodeBtn);
        codeEdit = (EditText) findViewById(R.id.codeEdit);
        myPhone = UclientApplication.getTelephone(activity.getApplicationContext());
        telphone.setText(String.format(activity.getString(R.string.unsubscribe_tips11), myPhone));


        findViewById(R.id.redBtn).setOnClickListener(this);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        findViewById(R.id.getCodeBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认申请
                String code = codeEdit.getText().toString();
                if (TextUtils.isEmpty(code)) {
                    CommonMethod.makeNoticeShort(activity, "请输入验证码", CommonMethod.ERROR);
                    return;
                }
                if (listener != null) {
                    listener.applyUnSubscribe(code);
                }
                dismiss();
                break;
            case R.id.getCodeBtn: //获取验证码
                GetCodeUtil.getCode(activity, myPhone, Constance.UN_SUBSCRIBE, new GetCodeUtil.NetRequestListener() {
                    @Override
                    public void onFailure() {
                        getCodeBtn.setClickable(true);
                    }

                    @Override
                    public void onSuccess() {
                        //开启验证码倒计时  每次倒计时的时间为1分钟
                        new RegisterTimerButton(60000, 1000, getCodeBtn, activity.getResources()).start();
                        openKeyBoard();
                    }
                });
                break;
            case R.id.redBtn:
                dismiss();
                break;
        }
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        codeEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(codeEdit);
            }
        }, 500);
    }
}
