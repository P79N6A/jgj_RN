package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.view.View;

import com.jizhi.jlongg.R;

/**
 * 记工筛选更多蒙层
 */
public class RememberFlowGuideDialog extends Dialog implements View.OnClickListener {
    private Activity activity;

    public RememberFlowGuideDialog(Activity context, int topMargin) {
        super(context, R.style.kdialog);
        this.activity = context;
        setContentView(R.layout.account_flow_guide_remember);
        getWindow().setWindowAnimations(R.style.alpha_animation);
//        View background = findViewById(R.id.background);
//        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) background.getLayoutParams();
//        params.topMargin = topMargin - ImageUtils.getImageWidthHeight(context, R.drawable.guide_background)[1] - ImageUtils.getImageWidthHeight(context, R.drawable.jiantou)[1];
//        background.setLayoutParams(params);
        findViewById(R.id.btn).setOnClickListener(this);
        findViewById(R.id.rootView).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        new RememberMoreFlowGuideDialog(activity).show();
        dismiss();
    }
}
