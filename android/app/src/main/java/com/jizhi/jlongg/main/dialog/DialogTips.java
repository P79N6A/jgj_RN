package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;

/**
 * 功能:添加来源人弹窗
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogTips extends Dialog implements View.OnClickListener {

    //删除通讯录联系人
    public static final int REMOVE_CONTACT_MEMBER = 2;

    public static final int CLEAR_CACHE = 3;

    //点击类型
    private int clickType;
    //点击确定按钮
    private DiaLogTitleListener listener;
    //下标
    private int position;
    //关闭项目组
    public static final int CLOSE_TEAM = 3;
    private String right_title;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String content) {
        setContentView(R.layout.dialog_blacklist);
        TextView close = findViewById(R.id.redBtn);
        TextView btn_asscess = findViewById(R.id.btn_asscess);
        TextView tvContent = findViewById(R.id.tv_content);
        switch (clickType) {
            case REMOVE_CONTACT_MEMBER:
                break;
        }
        if (!TextUtils.isEmpty(right_title)) {
            btn_asscess.setText(right_title);
        }
        tvContent.setGravity(Gravity.CENTER);
        tvContent.setText(content);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                if (listener != null) {
                    listener.clickAccess(position);
                    break;
                }
        }
        dismiss();
    }

    public DialogTips(Context context, DiaLogTitleListener listener, String content, String right_title, int clickType) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        this.clickType = clickType;
        this.right_title = right_title;
        createLayout(content);
        commendAttribute(true);
    }

    public DialogTips(Context context, DiaLogTitleListener listener, String content, int clickType) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        this.clickType = clickType;
        createLayout(content);
        commendAttribute(true);
    }

    public DialogTips(Context context, DiaLogTitleListener listener, String content, int clickType, String right_text) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        this.clickType = clickType;
        createLayout(content);
        commendAttribute(true);
        if (!TextUtils.isEmpty(right_text)) {
            setRightText(right_text);
        }
    }

    public void setRightText(String text) {
        TextView btn_asscess = findViewById(R.id.btn_asscess);
        btn_asscess.setText(text);

    }

    public void setHtmlText(String content) {
        TextView tvContent = (TextView) findViewById(R.id.tv_content);
        tvContent.setText(Html.fromHtml(content));
    }

    public void updateContent(String desc, int position) {
        this.position = position;
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
    }


    public void setContentCenterGravity() {
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setGravity(Gravity.CENTER);
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public interface TipsClickListener {
        /**
         * 点击确定
         */
        public void clickConfirm(int position);
    }
}
