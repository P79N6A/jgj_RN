package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.Html;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

/**
 * 功能:选择项目地址
 * 时间:2017年6月6日11:19:10
 * 作者:xuj
 */
public class DialogSelecteAddress extends Dialog implements View.OnClickListener {


    /**
     * 确定按钮回调
     */
    private TipsClickListener listener;
    /**
     * 项目名称
     */
    private TextView proNameText;
    /**
     * 项目地址
     */
    private TextView addressText;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_selected_address);

        proNameText = (TextView) findViewById(R.id.proName);
        addressText = (TextView) findViewById(R.id.address);

        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btnConfirm = (TextView) findViewById(R.id.btn_asscess);
        close.setOnClickListener(this);
        btnConfirm.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                if (listener != null) {
                    listener.clickConfirm(0);
                    break;
                }
        }
        dismiss();
    }

    public DialogSelecteAddress(BaseActivity context, TipsClickListener listener) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        createLayout();
        commendAttribute(true);
    }


    public void setData(String proName, String address) {
        proNameText.setText(Html.fromHtml("<font color='#999999'>" +
                "请确认&nbsp;</font><font color='#333333'>" + proName
                + "&nbsp;</font><font color='#999999'>的项目地址:</font>"));
        addressText.setText(address);
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface TipsClickListener {
        /**
         * 点击确定
         */
        public void clickConfirm(int position);
    }
}
