package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:修改项目名称
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogUpdateProjectName extends Dialog implements View.OnClickListener {
    /**
     * 项目名称输入框
     */
    private EditText proNameEdittext;
    /**
     * 项目保存回调
     */
    private UpProjectNameListener listener;
    /**
     * 上下文
     */
    private BaseActivity activity;


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String proName) {
        setContentView(R.layout.dialog_update_project);
        proNameEdittext = (EditText) findViewById(R.id.edittext);
        if (!TextUtils.isEmpty(proName)) {
            proNameEdittext.setText(proName);
            proNameEdittext.setSelection(proNameEdittext.getText().length());
        }
        Button updateBtn = (Button) findViewById(R.id.btn_asscess);
        findViewById(R.id.img_close).setOnClickListener(this);
        updateBtn.setOnClickListener(this);
    }

    public DiaLogUpdateProjectName(BaseActivity activity, UpProjectNameListener listener, String proName) {
        super(activity, R.style.Custom_Progress);
        this.listener = listener;
        this.activity = activity;
        createLayout(proName);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        proNameEdittext.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(proNameEdittext);
            }
        }, 300);
    }

    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.btn_asscess: //修改项目名称
                String name = proNameEdittext.getText().toString().trim();
                if (TextUtils.isEmpty(name)) {
                    CommonMethod.makeNoticeShort(activity, "请输入项目名称", CommonMethod.ERROR);
                    return;
                }
                listener.UpProjectName(name);
                break;
        }
    }

    public interface UpProjectNameListener {
        public void UpProjectName(String name);
    }

}
