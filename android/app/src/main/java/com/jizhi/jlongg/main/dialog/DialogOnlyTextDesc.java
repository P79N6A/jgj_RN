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
 * 功能:只包含标题弹出框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogOnlyTextDesc extends Dialog implements View.OnClickListener {
    /* 关闭监听器 */
    private CloseListener listener;
    /* 下标 */
    private int position;

    private Activity context;


    public void updateSynName(String name, int position) {
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        this.position = position;
        tv_content.setText(String.format(context.getString(R.string.synchclose), name));
    }

    public void updateContent(String desc, int position) {
        this.position = position;
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final String desc) {
        setContentView(R.layout.dialog_only_short_title);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                if (listener != null) {
                    listener.callBack(position);
                }
                break;
        }
        dismiss();
    }


    public DialogOnlyTextDesc(BaseActivity context, CloseListener listener, int position, String desc) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        this.position = position;
        this.context = context;
        createLayout(desc);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface CloseListener {
        void callBack(int position);
    }

}
