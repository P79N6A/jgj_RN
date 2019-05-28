package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;


/**
 * 功能:完善资料Dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogRepositoryNotEnoughtCount extends Dialog {


    //点击确定按钮
    private DiaLogTitleListener listener;

    public DialogRepositoryNotEnoughtCount(Activity context, DiaLogTitleListener listener) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        createLayout(context);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context) {
        setContentView(R.layout.repository_not_enought_count);
        TextView btnAsscess = (TextView) findViewById(R.id.btn_asscess);
        findViewById(R.id.redBtn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismiss();
            }
        });
        btnAsscess.setOnClickListener(new View.OnClickListener() { //确定分享按钮
            @Override
            public void onClick(View v) {
                dismiss();
                if (listener != null) {
                    listener.clickAccess(-1);
                }
            }
        });
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

}
