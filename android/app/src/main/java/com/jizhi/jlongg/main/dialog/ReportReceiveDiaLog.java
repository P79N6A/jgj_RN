package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;

/**
 * 功能:谁会收到这个报告Dialog
 * 时间:2016年9月5日 11:13:57
 * 作者:xuj
 */
public class ReportReceiveDiaLog extends Dialog implements View.OnClickListener {
    private String hint;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context) {
        setContentView(R.layout.dialog_report_recive);
        TextView content = (TextView) findViewById(R.id.content);
        TextView title = (TextView) findViewById(R.id.title);

        title.setText(context.getString(R.string.report_receive_title));
        if (hint.equals("通知内容")) {
            content.setText("仅有班组内成员会收到此通知");
        } else {
            content.setText(context.getString(R.string.report_receive_content));
        }
        findViewById(R.id.btn_confirm).setOnClickListener(this);

    }

    public ReportReceiveDiaLog(Activity context, String hint) {
        super(context, R.style.Custom_Progress);
        this.hint = hint;
        createLayout(context);
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
        dismiss();
    }
}
