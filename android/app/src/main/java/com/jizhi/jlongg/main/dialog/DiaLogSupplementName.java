package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.IsSupplementary;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:完善资料Dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogSupplementName extends Dialog implements View.OnClickListener {

    /**
     * 姓名输入框
     */
    private EditText nickname;
    /**
     * 补充姓名成功后的回调
     */
    private IsSupplementary.SupplementNameListener listener;
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * 是否关闭当前的Activity
     */
    private boolean isFinishActivity;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.layout_write_name);
        nickname = (EditText) findViewById(R.id.nickname);
        findViewById(R.id.dismissBtn).setOnClickListener(this);
        findViewById(R.id.confirmBtn).setOnClickListener(this);
        openKeyBoard();
    }


    public DiaLogSupplementName(Activity activity, boolean isFinishActivity) {
        super(activity, R.style.Custom_Progress);
        createLayout();
        this.isFinishActivity = isFinishActivity;
        this.activity = activity;
        commendAttribute(false);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.confirmBtn:
                String realName = nickname.getText().toString();
                if (TextUtils.isEmpty(realName)) {
                    CommonMethod.makeNoticeShort(activity, "请输入姓名", CommonMethod.ERROR);
                    return;
                }
                if (listener != null) {
                    listener.clickSupplementName(realName);
                }
                break;
            case R.id.dismissBtn:
                if (isFinishActivity) {
                    activity.finish();
                }
                dismiss();
                break;
        }

    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        nickname.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                Utils.showSoftKeyboard(activity, nickname);
            }
        }, 300);
    }

    public IsSupplementary.SupplementNameListener getListener() {
        return listener;
    }

    public void setListener(IsSupplementary.SupplementNameListener listener) {
        this.listener = listener;
    }
}
