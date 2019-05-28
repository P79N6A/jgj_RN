package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;

/**
 * 功能:底部两个按钮确认弹出框
 * 时间:2018年6月12日13:36:03
 * 作者:xuj
 */
public class DialogLeftRightBtnConfirm extends Dialog implements View.OnClickListener {
    /**
     * 左边、右边按钮点击事件回调
     */
    private LeftRightBtnListener listener;
    private Context context;
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String title, String content) {
        setContentView(R.layout.dialog_left_right_btn_confirm);
        TextView titleText = (TextView) findViewById(R.id.titleText);
        if (!TextUtils.isEmpty(title)) {
            titleText.setVisibility(View.VISIBLE);
            titleText.setText(title);
        } else {
            titleText.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(content)) {
            TextView contentText = (TextView) findViewById(R.id.contentText);
            contentText.setText(content);
        }
        findViewById(R.id.leftBtn).setOnClickListener(this);
        findViewById(R.id.rightBtn).setOnClickListener(this);
    }

    public void setHtmlContent(String content) {
        TextView tvContent = (TextView) findViewById(R.id.contentText);
        tvContent.setText(Html.fromHtml(content));
    }

    public void setLeftBtnText(String text) {
        TextView leftBtn = (TextView) findViewById(R.id.leftBtn);
        leftBtn.setText(text);
    }

    public void setRightBtnText(String text) {
        TextView rightBtn = (TextView) findViewById(R.id.rightBtn);
        rightBtn.setText(text);
    }
    public void setGravityLeft() {
        TextView viewById = (TextView) findViewById(R.id.contentText);
        LinearLayout.LayoutParams params=new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        params.topMargin=dp2px(12);
        viewById.setLayoutParams(params);
    }

    protected int dp2px(float dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }
    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.leftBtn: //确认
                if (listener != null) {
                    listener.clickLeftBtnCallBack();
                }
                break;
            case R.id.rightBtn:
                if (listener != null) {
                    listener.clickRightBtnCallBack();
                }
                break;
        }
    }


    public DialogLeftRightBtnConfirm(Context context, String title, String content, LeftRightBtnListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        this.context=context;
        createLayout(title, content);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface LeftRightBtnListener {
        public void clickLeftBtnCallBack();

        public void clickRightBtnCallBack();
    }

}
