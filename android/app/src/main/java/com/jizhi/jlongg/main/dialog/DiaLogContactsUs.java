package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import com.hcs.uclient.utils.CallPhoneUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;


/**
 * 功能:修改手机号码 联系客服 弹出框
 * 时间:2017年4月6日14:39:53
 * 作者:xuj
 */
public class DiaLogContactsUs extends Dialog implements View.OnClickListener {


    /* 上下文 */
    private Activity activity;

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
    public DiaLogContactsUs(BaseActivity context) {
        super(context, R.style.network_dialog_style);
        this.activity = context;
        createLayout();
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_contacts_us);
        findViewById(R.id.closeIcon).setOnClickListener(this);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //拨打电话
                CallPhoneUtil.callPhone(activity, "4008623818");
                break;
            case R.id.closeIcon:
                break;
        }
        dismiss();
    }

}
