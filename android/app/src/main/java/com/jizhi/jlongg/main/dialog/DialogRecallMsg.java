package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;


/**
 * 功能:关闭同步项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogRecallMsg extends Dialog implements View.OnClickListener {


    private DiaLogTitleListener listener;

    private int position;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String content) {
        setContentView(R.layout.dialog_msg_recall);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        TextView tvContent = (TextView) findViewById(R.id.tv_content);
        tvContent.setText(content);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }

    public void updateContent(String desc, int position) {
        this.position = position;
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                if (listener != null) {
                    listener.clickAccess(position);
                }
                break;
        }
        dismiss();
    }


    public DialogRecallMsg(BaseActivity context, DiaLogTitleListener listener, int position, String content) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        this.position = position;
        createLayout(content);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
