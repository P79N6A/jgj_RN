package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.Html;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.listener.CallBackConfirm;
import com.jizhi.jlongg.main.util.AccountUtil;

/**
 * 功能:未设置记账对象薪资模板
 * 时间:2017年10月18日15:57:19
 * 作者:xuj
 */
public class DialogUnSetAccountSalary extends Dialog implements View.OnClickListener {

    /**
     * 点击去设置按钮后的回调
     */
    private CallBackConfirm listener;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String realName, String accountType) {
        setContentView(R.layout.dialog_no_set_account_salary);
        TextView setSalaryBtn = (TextView) findViewById(R.id.setSalaryBtn); //设置薪资模板
        TextView tvContent = (TextView) findViewById(R.id.tv_content);

        if (accountType.equals(AccountUtil.HOUR_WORKER)) { //点工 模板
            tvContent.setText(Html.fromHtml("<font color='#333333'>你需要对</font><font color='#d7252c'>[" + realName + "]</font><font  color='#333333'>设置点工工资标准后，才能开始记工。</font>"));
        } else if (accountType.equals(AccountUtil.CONSTRACTOR_CHECK)) { //包工模板
            tvContent.setText(Html.fromHtml("<font color='#333333'>你需要对</font><font color='#d7252c'>[" + realName + "]</font><font  color='#333333'>设置包工记工天模板后，才能开始记工。</font>"));
        }
        setSalaryBtn.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.setSalaryBtn: //马上去设置薪资模板
                if (listener != null) {
                    listener.callBack();
                }
                break;
        }
        dismiss();
    }


    public DialogUnSetAccountSalary(BaseActivity context, String realName, String accountType, CallBackConfirm listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(realName, accountType);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
