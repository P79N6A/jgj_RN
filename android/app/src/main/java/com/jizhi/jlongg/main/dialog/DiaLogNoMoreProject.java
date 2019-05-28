package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

/**
 * 功能:没有更多项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogNoMoreProject extends Dialog implements View.OnClickListener {
    /**
     * 是否是同步项目
     */
    private boolean isSynProject;
    /**
     * 上下文
     */
    private Activity context;

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
    public DiaLogNoMoreProject(BaseActivity context, String desc, boolean isCancelDialog) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        isSynProject = !isCancelDialog;
        createLayout(desc);
        commendAttribute(isCancelDialog);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String desc) {
        setContentView(R.layout.dialog_bottom_red);
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
        TextView close = (TextView) findViewById(R.id.redBtn);
        close.setText(R.string.iam_sure);
        close.setOnClickListener(this);
        findViewById(R.id.closeIcon).setOnClickListener(this);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //关闭
                if (isSynProject) {
                    dismiss();
                    DiaLogRedProgress dialog = new DiaLogRedProgress(context, null);
                    dialog.show();
                    return;
                }
                break;
        }
        dismiss();
    }

}
