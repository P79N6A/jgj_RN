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
 * 功能:项目云盘-->云盘空间不足
 * 如果上传文件过程中，上传的文件大小 > 剩余空间大小，关闭上传面板，同时弹出提示面板：
 * 待上传文件大小已超过云盘剩余空间，如需继续上传，请扩容。
 * 时间:2017年7月17日14:43:52
 * 作者:xuj
 */
public class DialogNotEnoughCloudSpace extends Dialog implements View.OnClickListener {
    /**
     * 立即扩容云盘回调
     */
    private DiaLogTitleListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogNotEnoughCloudSpace(BaseActivity activity, DiaLogTitleListener listener) {
        super(activity, R.style.network_dialog_style);
        this.listener = listener;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.cloud_not_enough_space);
        TextView dismissBtn = (TextView) findViewById(R.id.dismissBtn);
        TextView nowReNewText = (TextView) findViewById(R.id.nowReNewText);
        dismissBtn.setOnClickListener(this);
        nowReNewText.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        dismiss();
        if (listener == null) {
            return;
        }
        switch (v.getId()) {
            case R.id.nowReNewText: //确认扩容
                listener.clickAccess(-1);
                break;
        }
    }


}
