package com.jizhi.jlongg.main.popwindow;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;

import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 功能: 记账包工 功能引导页
 * 作者：Xuj
 * 时间: 2016/3/11 15:47
 */
public class RecordAccountGuideWindow extends Dialog implements View.OnClickListener {

    private Context context;

    public RecordAccountGuideWindow(Activity context) {
        super(context, R.style.kdialog);
        this.context = context;
        initPopup();
    }


    private void initPopup() {
        setContentView(R.layout.account_guide);
        getWindow().setWindowAnimations(R.style.GuideAnimation);
        findViewById(R.id.closeBtn).setOnClickListener(this);
        findViewById(R.id.rootLayout).setOnClickListener(this);
        setOnDismissListener(new OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                SPUtils.put(context, "IS_SHOW_ACCOUNT_GUIDE", true, Constance.JLONGG);
            }
        });
    }


    @Override
    public void onClick(View v) {
        dismiss();
    }

}
