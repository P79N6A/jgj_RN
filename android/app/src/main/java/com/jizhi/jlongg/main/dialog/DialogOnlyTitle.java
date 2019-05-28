package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;


/**
 * 功能:文本弹出框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogOnlyTitle extends Dialog implements View.OnClickListener {


    private DiaLogTitleListener listener;

    private int position;
    private TextView tvContent;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String content) {
        setContentView(R.layout.dialog_close_team);
        TextView close = findViewById(R.id.redBtn);
        TextView btn_asscess =  findViewById(R.id.btn_asscess);
         tvContent = findViewById(R.id.tv_content);
        tvContent.setText(content);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }

    public TextView getTvContent() {
        return tvContent;
    }

    public void setTvContent(TextView tvContent) {
        this.tvContent = tvContent;
    }

    public void setContentLeft(){
        ((TextView) findViewById(R.id.tv_content)).setGravity(Gravity.LEFT);
    }
    public void updateContent(String desc, int position) {
        this.position = position;
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
    }

    public void setConfirmBtnName(String name) {
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        btn_asscess.setText(name);
    }

    public void setDissmissBtnName(String name) {
        TextView btnDissmiss = (TextView) findViewById(R.id.redBtn);
        btnDissmiss.setText(name);
    }

    public void setDissmissBtnNameAndColor(String name, int color) {
        TextView btnDissmiss = (TextView) findViewById(R.id.redBtn);
        btnDissmiss.setTextColor(color);
        btnDissmiss.setText(name);
    }

    public void hideConfirmBtnName() {
        TextView btnAsscess = (TextView) findViewById(R.id.btn_asscess);
        btnAsscess.setVisibility(View.GONE);
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


    public DialogOnlyTitle(Context context, DiaLogTitleListener listener, int position, String content) {
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
