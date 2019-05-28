package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * 功能:实名认证弹框
 * 时间:2018年12月17日15:34:36
 * 作者:xuj
 */
public class DialogAuthType extends Dialog implements View.OnClickListener {

    private Activity activity;
    /**
     * 实名认证类型
     */
    private int authType;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_auth_type);
        TextView title1 = findViewById(R.id.title1);
        TextView title2 = findViewById(R.id.title2);

        TextView content2 = findViewById(R.id.content2);
        String roler = (authType + "").equals(Constance.ROLETYPE_FM) ? "班组长" : "工人";

        title1.setText("该用户已通过" + roler + "认证");
        title2.setText("通过" + roler + "认证的好处");
        content2.setText("优先匹配" + ((authType + "").equals(Constance.ROLETYPE_FM) ? "项目" : "工作"));

        findViewById(R.id.left_btn).setOnClickListener(this);
        findViewById(R.id.right_btn).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.right_btn: //确认
                X5WebViewActivity.actionStart(activity, NetWorkRequest.WEBURLS + "my/attest?role=" + authType);
                break;
        }
    }


    public DialogAuthType(Activity activity, int authType) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        this.authType = authType;
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        createLayout();
    }

}
