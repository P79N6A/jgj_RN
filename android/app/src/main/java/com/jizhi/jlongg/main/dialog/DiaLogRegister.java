package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.view.View;
import android.widget.Button;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 功能:注册dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogRegister extends Dialog {
    /**
     * 添加记账对象接口回调
     */
    private IsCloseRegisterDialogListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    /**
     * 记账添加工人、工头
     */
    public DiaLogRegister(Activity context, IsCloseRegisterDialogListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(context);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.selectl_login_register);
        Button login = (Button) findViewById(R.id.login);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(activity, LoginActivity.class);
                activity.startActivityForResult(intent, Constance.REQUEST_LOGIN);
                dismiss();
            }
        });
        setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                listener.callBack();
            }
        });
    }

    /**
     * 是否关闭了注册对话框
     */
    public interface IsCloseRegisterDialogListener {
        public void callBack();
    }
}
