package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 功能:修改记账对象名称
 * 时间:2018年5月2日14:30:03
 * 作者:xuj
 */
public class DiaLogUpdateAccountName extends Dialog implements View.OnClickListener {
    /**
     * 编辑姓名回调
     */
    private IsSupplementary.SupplementNameListener listener;
    /**
     * 姓名输入框
     */
    private EditText edittext;

    private BaseActivity context;

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
    public DiaLogUpdateAccountName(BaseActivity context, IsSupplementary.SupplementNameListener listener) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        this.context = context;
        createLayout();
        commendAttribute(false);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_update_account_name);
        edittext = (EditText) findViewById(R.id.edittext);
        TextView title = (TextView) findViewById(R.id.title);
        String roler = UclientApplication.getRoler(context.getApplicationContext());
        title.setText(roler.equals(Constance.ROLETYPE_FM) ? "更改工人姓名" : "更改班组长姓名");
        edittext.setHint(roler.equals(Constance.ROLETYPE_FM) ? "请输入工人的姓名" : "请输入班组长的姓名");
        findViewById(R.id.closeIcon).setOnClickListener(this);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //保存按钮
                String message = edittext.getText().toString().trim();
                if (TextUtils.isEmpty(message)) {
                    CommonMethod.makeNoticeShort(context, context.getString(R.string.inputOtherSideName), CommonMethod.ERROR);
                    return;
                }
                if (listener != null) {
                    listener.clickSupplementName(message);
                }
                break;
        }
        dismiss();
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        edittext.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                context.showSoftKeyboard(edittext);
            }
        }, 300);
    }

}
