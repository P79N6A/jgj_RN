package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.Button;

import com.jizhi.jlongg.R;

/**
 * 功能:红色进度条  请求成功
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogRedProgressSuccesss extends Dialog {

    private OnLoadCompleteListener listener;


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)

    public void createLayout(final Activity context) {
        setContentView(R.layout.dialog_sysch_succeed);
        Button btn_confirm = (Button) findViewById(R.id.btn_confirm);
        btn_confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                if (listener != null) {
                    listener.complete();
                }
//                context.setResult(Constance.SYNC_SUCCESS, context.getIntent());
//                context.finish();
            }
        });
    }

    public DiaLogRedProgressSuccesss(Activity context, OnLoadCompleteListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(context);
        commendAttribute(false);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface OnLoadCompleteListener {
        void complete();
    }
}
