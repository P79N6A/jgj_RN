package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.activity.welcome.RegisterPerfectDataActivity;

/**
 * 功能:完善资料Dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogSupplementInfo extends Dialog {


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context, String showTitle) {
        setContentView(R.layout.supplement_reminder);
        TextView title = (TextView) findViewById(R.id.reminder);
        title.setText(showTitle);
        TextView supple = (TextView) findViewById(R.id.supple);
        supple.setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, RegisterPerfectDataActivity.class);
                intent.putExtra("isreg", false);
                context.startActivityForResult(intent, Constance.REQUEST_LOGIN);
                dismiss();
            }
        });
    }


    public DiaLogSupplementInfo(Activity context, String showTitle) {
        super(context, R.style.Custom_Progress);
        createLayout(context, showTitle);
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
