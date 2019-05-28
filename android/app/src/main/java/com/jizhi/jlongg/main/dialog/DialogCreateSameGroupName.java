package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:底部两个按钮确认弹出框
 * 时间:2018年6月12日13:36:03
 * 作者:xuj
 */
public class DialogCreateSameGroupName extends Dialog implements View.OnClickListener {
    /**
     * 左边、右边按钮点击事件回调
     */
    private LeftRightBtnListener listener;
    /**
     * 项目名称输入框
     */
    private EditText projectEdit;


    public DialogCreateSameGroupName(BaseActivity baseActivity, String projectName, LeftRightBtnListener listener) {
        super(baseActivity, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(projectName, baseActivity);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String projectName, final BaseActivity baseActivity) {
        setContentView(R.layout.dialog_create_same_group_name);
        projectEdit = findViewById(R.id.project_edit);
        projectEdit.setText(projectName);
        findViewById(R.id.leftBtn).setOnClickListener(this);
        findViewById(R.id.rightBtn).setOnClickListener(this);
        projectEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                baseActivity.showSoftKeyboard(projectEdit);
            }
        }, 300);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.leftBtn: //取消
                if (listener != null) {
                    dismiss();
                    listener.clickLeftBtnCallBack();
                }
                break;
            case R.id.rightBtn:
                String proName = projectEdit.getText().toString();
                if (TextUtils.isEmpty(proName)) {
                    CommonMethod.makeNoticeLong(getContext().getApplicationContext(), projectEdit.getHint().toString(), CommonMethod.ERROR);
                    return;
                }
                if (proName.length() > 20) {
                    CommonMethod.makeNoticeLong(getContext().getApplicationContext(), "项目名称太长，请重新输入", CommonMethod.ERROR);
                    return;
                }
                if (listener != null) {
                    listener.clickRightBtnCallBack(projectEdit.getText().toString().trim());
                    dismiss();
                }
                break;
        }
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

        public void clickRightBtnCallBack(String proName);
    }

}
