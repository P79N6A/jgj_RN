package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:底部两个按钮确认弹出框
 * 时间:2018年6月12日13:36:03
 * 作者:xuj
 */
public class BatchSetSalaryDialog extends Dialog implements View.OnClickListener {
    /**
     * 左边、右边按钮点击事件回调
     */
    private LeftRightBtnListener listener;


    private EditText moneyEdit;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(int selecteCount, final BaseActivity activity) {
        setContentView(R.layout.batch_set_salary_dialog);
        TextView titleText = (TextView) findViewById(R.id.titleText);
        titleText.setText(Html.fromHtml("<font color='#000000'>本次共选中 </font><font color='#eb4e4e'>" + selecteCount + "</font><font color='#000000'>笔 点工</font>"));
        moneyEdit = (EditText) findViewById(R.id.money_edit);
        findViewById(R.id.leftBtn).setOnClickListener(this);
        findViewById(R.id.rightBtn).setOnClickListener(this);

        moneyEdit.setHint(UclientApplication.isForemanRoler(activity) ? "请输入与工人协商的金额" : "请输入与班组长协商的金额");
        Utils.setEditTextDecimalNumberLength(moneyEdit, 6, 2);
        moneyEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(moneyEdit);
            }
        }, 300);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.leftBtn: //确认
                if (listener != null) {
                    listener.clickLeftBtnCallBack();
                    dismiss();
                }
                break;
            case R.id.rightBtn:
                if (listener != null) {
                    String salary = moneyEdit.getText().toString();
                    if (TextUtils.isEmpty(salary)) {
                        CommonMethod.makeNoticeLong(getContext(), "请设置工资金额", CommonMethod.ERROR);
                        return;
                    }
                    if (salary.endsWith(".")) {
                        salary = salary.replace(".", "");
                    }
                    listener.clickRightBtnCallBack(salary);
                    dismiss();
                }
                break;
        }
    }


    public BatchSetSalaryDialog(BaseActivity context, int selecteCount, LeftRightBtnListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(selecteCount, context);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface LeftRightBtnListener {
        public void clickLeftBtnCallBack();

        public void clickRightBtnCallBack(String money);
    }

}
