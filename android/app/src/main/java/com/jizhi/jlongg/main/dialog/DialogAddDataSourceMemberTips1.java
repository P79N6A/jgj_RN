package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;


/**
 * 功能:添加来源人弹窗
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogAddDataSourceMemberTips1 extends Dialog implements View.OnClickListener {


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_bottom_red);
        TextView close = (TextView) findViewById(R.id.closeIcon);
        close.setText("我知道了");
        close.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }


    public DialogAddDataSourceMemberTips1(BaseActivity context) {
        super(context, R.style.network_dialog_style);
        createLayout();
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
