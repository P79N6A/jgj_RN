package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.CreateTeamGroupActivity;

/**
 * 功能:没有更多项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogHintCreateTeam extends Dialog implements View.OnClickListener {
    /**
     * 上下文
     */
    private Activity context;
    /**
     * 项目名称
     */
    private String group_name;
    /**
     * 项目pid
     */
    private int pid;
    private CloseDialogListener closeDialogListener;

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
    public DiaLogHintCreateTeam(Activity context, String desc, String group_name, int pid,CloseDialogListener closeDialogListener) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        this.group_name = group_name;
        this.pid = pid;
        this.closeDialogListener=closeDialogListener;
        createLayout(desc);
        commendAttribute(true);
        LUtils.e("-----------新建班组pid--------"+pid);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String desc) {
        setContentView(R.layout.dialog_hint_create_group);
        ((TextView) findViewById(R.id.tv_content)).setText(desc);
        ((TextView) findViewById(R.id.tv_content)).setGravity(Gravity.LEFT);
        findViewById(R.id.closeIcon).setOnClickListener(this);
        findViewById(R.id.btn_cancel).setOnClickListener(this);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        ((TextView) findViewById(R.id.btn_asscess)).setText("新建班组");
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.closeIcon: //关闭
            case R.id.btn_cancel: //取消
                closeDialogListener.closeDialogClick();
                dismiss();
                break;
            case R.id.btn_asscess: //确定,继续记账
                closeDialogListener.closeDialogClick();
                CreateTeamGroupActivity.actionStart(context, group_name,String.valueOf(pid));
                dismiss();
                break;
        }
    }
    public interface CloseDialogListener {
        void closeDialogClick();

    }
}
