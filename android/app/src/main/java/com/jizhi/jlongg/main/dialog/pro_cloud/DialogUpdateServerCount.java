package com.jizhi.jlongg.main.dialog.pro_cloud;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.EditText;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 功能:修改服务人数
 * 时间:2017年7月17日14:43:52
 * 作者:xuj
 */
public class DialogUpdateServerCount extends Dialog implements View.OnClickListener {


    private BaseActivity activity;
    /**
     * 确定回调
     */
    private SelectServcePersonCountListener listener;
    /**
     * 服务人数输入框
     */
    private EditText serverMemberCountEdit;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogUpdateServerCount(BaseActivity activity, SelectServcePersonCountListener listener, String selecteCount) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        this.listener = listener;
        createLayout(activity, selecteCount);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity, String selecteCount) {
        setContentView(R.layout.dialog_update_servce_count);
        serverMemberCountEdit = (EditText) findViewById(R.id.serverMemberCountEdit);
        serverMemberCountEdit.setText(selecteCount);
        findViewById(R.id.redBtn).setOnClickListener(this);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确定
                if (listener != null) {
                    listener.getSelecteCount(serverMemberCountEdit.getText().toString());
                }
                break;
        }
        dismiss();
    }

    public interface SelectServcePersonCountListener {
        public void getSelecteCount(String serverCount);
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        serverMemberCountEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(serverMemberCountEdit);
            }
        }, 500);
    }

}
