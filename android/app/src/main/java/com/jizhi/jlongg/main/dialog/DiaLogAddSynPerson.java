package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.listener.AddSynchPersonListener;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

/**
 * 功能:添加同步对象
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogAddSynPerson extends Dialog implements View.OnClickListener {
    /**
     * 添加记账对象接口回调
     */
    private AddSynchPersonListener listener;
    /***
     * 名称
     */
    private EditText nickName;
    /**
     * 电话号码
     */
    private EditText telph;
    /**
     * 备注
     */
    private EditText remark;
    /**
     * 上下文
     */
    private BaseActivity context;

    /* 输入11位电话号码时调用接口的回调 */
    private DiaLogAddAccountPerson.InputTelphoneGetRealNameListener getRealNameListener;

    public void setUserName(String userName) {
        nickName.setText(userName);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    /**
     * 记账添加工人、工头
     */
    public DiaLogAddSynPerson(BaseActivity context, AddSynchPersonListener listener) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        this.listener = listener;
        createLayout();
        commendAttribute(false);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.add_syn_person);
        telph = (EditText) findViewById(R.id.telph);
        nickName = (EditText) findViewById(R.id.nickname);
        remark = (EditText) findViewById(R.id.remark);
        Button btn_asscess = (Button) findViewById(R.id.btn_asscess);
        ImageView close = (ImageView) findViewById(R.id.redBtn);
        btn_asscess.setOnClickListener(this);
        close.setOnClickListener(this);

        telph.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == 0) {
                    nickName.setText("");
                } else if (s.length() == 11) {
                    if (listener != null) {
                        getRealNameListener.accordingTelgetRealName(telph.getText().toString());
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }


    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.btn_asscess://确认
                if (access()) {
                    String name = nickName.getText().toString().trim();
                    String telphone = telph.getText().toString().trim();
                    listener.add(name, telphone, remark.getText().toString(), -1);
                }
                break;
        }
    }

    /**
     * 验证名字和电话号码输入框格式
     */
    public boolean access() {
        boolean access = false;
        String telphValue = telph.getText().toString().trim();
        String nickNamevalue = nickName.getText().toString().trim();
        if (TextUtils.isEmpty(nickNamevalue)) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.inputOtherSideName), CommonMethod.ERROR);
            return access;
        }
        String ruler = "(([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10}))";
        if (!Pattern.matches(ruler, nickNamevalue)) {
            if (nickNamevalue.length() < 2 || nickNamevalue.length() > 8) {
                CommonMethod.makeNoticeShort(context, "姓名只能为二至八个字!", CommonMethod.ERROR);
                return access;
            }

            CommonMethod.makeNoticeShort(context, "姓名只能是中文!", CommonMethod.ERROR);
            return access;
        }
        if (TextUtils.isEmpty(telphValue)) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.input_sure_mobile), CommonMethod.ERROR);
            return access;
        }
        if (!StrUtil.isMobileNum(telphValue)) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.input_sure_mobile), CommonMethod.ERROR);
            return access;
        }
        if (telphValue.equals(UclientApplication.getLoginTelephone(context))) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.add_fail), CommonMethod.ERROR);
            return access;
        }
        access = true;
        return access;
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        telph.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                context.showSoftKeyboard(telph);
            }
        }, 200);
    }

    public DiaLogAddAccountPerson.InputTelphoneGetRealNameListener getGetRealNameListener() {
        return getRealNameListener;
    }

    public void setGetRealNameListener(DiaLogAddAccountPerson.InputTelphoneGetRealNameListener getRealNameListener) {
        this.getRealNameListener = getRealNameListener;
    }
}
