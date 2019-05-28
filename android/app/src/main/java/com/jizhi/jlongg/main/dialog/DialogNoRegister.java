package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

/**
 * 功能:班组管理、未注册弹框
 * 时间:2016年9月2日 14:51:37
 * 作者:xuj
 */
public class DialogNoRegister extends Dialog implements View.OnClickListener {


    @Override
    public void onClick(View v) {
        dismiss();
    }

    public DialogNoRegister(BaseActivity context) {
        super(context, R.style.Custom_Progress);
        setContentView(R.layout.dialog_bottom_red);
        findViewById(R.id.redBtn).setOnClickListener(this);
        setCenterTextParameter(context);
        commendAttribute(true);
    }

    private void setCenterTextParameter(Context context) {
        TextView closeBtn = (TextView) findViewById(R.id.redBtn);
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) tv_content.getLayoutParams();
        int margin = DensityUtils.dp2px(context, 15);
        params.leftMargin = margin;
        params.rightMargin = margin;
        tv_content.setLayoutParams(params);
        tv_content.setTextSize(15);
        tv_content.setGravity(Gravity.LEFT);
        String content = String.format(context.getString(R.string.no_register_notice), "项目管理");
        tv_content.setText(content);
        closeBtn.setText("我知道了");
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
