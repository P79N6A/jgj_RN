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
 * 功能:没有更多项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class LogAddModeHintDialog extends Dialog implements View.OnClickListener {
    /**
     * 上下文
     */
    private Activity context;
    private String errfield;

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
    public LogAddModeHintDialog(Activity context) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        createLayout();
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_bottom_red);
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(Html.fromHtml("请在电脑浏览器上登录吉工宝<br/>" +
                    "www.jgongb.com,进入<font color='#d7252c'>[工作<br/>日志]</font>模块进行设置"));
        TextView close = (TextView) findViewById(R.id.redBtn);
        close.setText("我知道了");
        close.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //关闭
                dismiss();
                break;
        }
    }

}
