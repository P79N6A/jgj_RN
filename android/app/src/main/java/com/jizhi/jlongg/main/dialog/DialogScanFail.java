package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.jizhi.jlongg.R;


/**
 * 功能:扫描失败弹出框
 * 时间:2017年10月9日16:06:34
 * 作者:xuj
 */
public class DialogScanFail extends Dialog {

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_scan_fail);
        Window window = getWindow();
        window.getDecorView().setPadding(0, 0, 0, 0);
        window.setGravity(Gravity.CENTER);
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.width = WindowManager.LayoutParams.MATCH_PARENT;
        lp.height = WindowManager.LayoutParams.MATCH_PARENT;
        window.setAttributes(lp);
        findViewById(R.id.rootView).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismiss();
            }
        });
    }


    public DialogScanFail(Activity activity) {
        super(activity, R.style.network_dialog_style);
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        createLayout();
    }

}
