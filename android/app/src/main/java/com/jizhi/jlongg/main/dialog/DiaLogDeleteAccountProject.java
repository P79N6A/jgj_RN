package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.Html;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;

/**
 * 功能:删除记账项目Dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogDeleteAccountProject extends Dialog implements View.OnClickListener {

    /**
     * 删除项目回调接口
     */
    private RemoveAccountProject listener;

    /**
     * 项目名称
     */
    private TextView projectName;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public void update(String name) {
        projectName.setText(name);
    }


    /**
     * 记账添加工人、工头
     */
    public DiaLogDeleteAccountProject(Activity context, RemoveAccountProject listener, String projectName) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        deleteProject(projectName);
        commendAttribute(true);
    }


    /**
     * 删除项目
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void deleteProject(String name) {
        setContentView(R.layout.delete_account_project);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        projectName = (TextView) findViewById(R.id.projectName);
        projectName.setText(Html.fromHtml("<font color='#333333'>" + name + "</font><font color='#666666'>&nbsp;&nbsp;&nbsp;项目吗?</font>"));
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn:
                dismiss();
                break;
            case R.id.btn_asscess:  //确认
                dismiss();
                listener.remove();
                break;
        }
    }

    public interface RemoveAccountProject {
        public void remove();
    }
}
