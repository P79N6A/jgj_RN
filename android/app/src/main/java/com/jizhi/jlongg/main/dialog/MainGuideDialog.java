package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.view.View;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.ImageUtils;
import com.jizhi.jlongg.R;

/**
 * 功能: 首页 引导页
 * 作者：Xuj
 * 时间: 2016/3/11 15:47
 */
public class MainGuideDialog extends Dialog implements View.OnClickListener {


    public MainGuideDialog(Activity context, int topMargin) {
        super(context, R.style.kdialog);
        setContentView(R.layout.account_flow_guide);
        getWindow().setWindowAnimations(R.style.alpha_animation);
        View background = findViewById(R.id.background);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) background.getLayoutParams();
        params.topMargin = topMargin - ImageUtils.getImageWidthHeight(context, R.drawable.guide_background)[1] - ImageUtils.getImageWidthHeight(context, R.drawable.jiantou)[1];
        background.setLayoutParams(params);
        findViewById(R.id.btn).setOnClickListener(this);
        findViewById(R.id.rootView).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        dismiss();
    }
}
