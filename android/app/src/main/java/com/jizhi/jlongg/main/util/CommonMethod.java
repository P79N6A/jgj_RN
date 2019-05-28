package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.jizhi.jlongg.R;

public class CommonMethod {

    private static Toast toast;
    private static View successLayout;// 成功请求提示框

    private static View errorLayout; //请求失败提示框

    private static TextView successTitle, errotitle;


    public static final boolean SUCCESS = true;

    public static final boolean ERROR = false;


    /**
     * 创建Toast
     *
     * @param context
     * @param isLong    是否是长显示
     * @param isSuccess 是否是成功Dialog
     */
    private static void createToast(Context context, boolean isLong, boolean isSuccess) {
        toast = new Toast(context);
        if (isSuccess) {
            if (successLayout == null) {
                LayoutInflater inflater = LayoutInflater.from(context);
                successLayout = inflater.inflate(R.layout.toast_success_layout, null);
                successTitle = (TextView) successLayout.findViewById(R.id.toast_custom_tv);
            }
            toast.setView(successLayout);
        } else {
            if (errorLayout == null) {
                LayoutInflater inflater = LayoutInflater.from(context);
                errorLayout = inflater.inflate(R.layout.toast_error_layout, null);
                errotitle = (TextView) errorLayout.findViewById(R.id.toast_custom_tv);
            }
            toast.setView(errorLayout);
        }
        toast.setGravity(Gravity.CENTER, 0, 0);
        if (isLong) {
            toast.setDuration(Toast.LENGTH_LONG);
        } else {
            toast.setDuration(Toast.LENGTH_SHORT);
        }
    }

    /**
     * toast 长显示
     *
     * @param context
     * @param err       错误提示
     * @param isSuccess 是否是成功提示
     */
    public static synchronized void makeNoticeLong(Context context, String err, boolean isSuccess) {
        try {
            if (toast != null) {
                toast.cancel();
            }
            createToast(context, false, isSuccess);
            if (isSuccess) {
                successTitle.setText(err);
            } else {
                errotitle.setText(err);
            }
            toast.show();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * toast 短显示
     *
     * @param context
     * @param err       错误提示
     * @param isSuccess 是否是成功提示
     */
    public static synchronized void makeNoticeShort(Context context, String err, boolean isSuccess) {
        try {
            if (TextUtils.isEmpty(err)) {
                err = "";
            }
            if (toast != null) {
                toast.cancel();
            }
            createToast(context, false, isSuccess);
            if (isSuccess) {
                successTitle.setText(err);
            } else {
                errotitle.setText(err);
            }
            toast.show();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


}
