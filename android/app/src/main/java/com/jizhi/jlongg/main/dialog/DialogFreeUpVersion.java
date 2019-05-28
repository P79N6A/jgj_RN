package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * 功能:文本弹出框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogFreeUpVersion extends Dialog implements View.OnClickListener {


    private DiaLogTitleListener listener;

    private Activity activity;


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_free_up_version);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        findViewById(R.id.versionIntroduceLayout).setOnClickListener(this);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }


    public DialogFreeUpVersion(BaseActivity activity, DiaLogTitleListener listener) {
        super(activity, R.style.Custom_Progress);
        this.listener = listener;
        this.activity = activity;
        createLayout();
        commendAttribute(true);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认升级版本
                if (listener != null) {
                    listener.clickAccess(-1);
                }
                break;
            case R.id.versionIntroduceLayout: //跳转到产品服务
                X5WebViewActivity.actionStart(activity, NetWorkRequest.WEBURLS + "serveshop");
                break;
        }
        dismiss();
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
