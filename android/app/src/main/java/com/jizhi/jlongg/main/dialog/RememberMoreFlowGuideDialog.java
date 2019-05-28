package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.view.View;

import com.jizhi.jlongg.R;

/**
 * 记工流水更多蒙层
 */
public class RememberMoreFlowGuideDialog extends Dialog implements View.OnClickListener {



    public RememberMoreFlowGuideDialog(Activity activity) {
        super(activity, R.style.kdialog);
        setContentView(R.layout.account_flow_guide_remember_more);
        getWindow().setWindowAnimations(R.style.alpha_animation);
        findViewById(R.id.btn).setOnClickListener(this);
        findViewById(R.id.rootView).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {

        dismiss();
    }
}
