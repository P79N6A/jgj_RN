package com.jizhi.jlongg.main.dialog.pay;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;


/**
 * 功能:确认订单时，减少服务人数和云盘空间时增加权限区别和提示语句
 * 时间:2017年8月7日10:10:12
 * 作者:xuj
 */
public class DialogWarningDialog extends Dialog implements View.OnClickListener {


    /**
     * 回调
     */
    private DiaLogTitleListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogWarningDialog(BaseActivity activity, DiaLogTitleListener listener, boolean moneyIsZero) {
        super(activity, R.style.network_dialog_style);
        this.listener = listener;
        createLayout(activity, moneyIsZero);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity, boolean moneyIsZero) {
        setContentView(R.layout.dialog_warning);
        TextView confirm = (TextView) findViewById(R.id.confirm);
        confirm.setOnClickListener(this);
        confirm.setText(moneyIsZero ? "确认订单" : "继续支付"); //当订单金额为0时 显示 确认订单  不为0时 显示 继续支付
        findViewById(R.id.cancel).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
        if (listener == null) {
            return;
        }
        switch (v.getId()) {
            case R.id.confirm: //继续支付
                listener.clickAccess(-1);
                break;
        }
    }


}
