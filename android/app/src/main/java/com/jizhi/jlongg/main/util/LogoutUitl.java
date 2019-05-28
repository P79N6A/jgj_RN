package com.jizhi.jlongg.main.util;

import android.app.ProgressDialog;

public class LogoutUitl {

    private static ProgressDialog dialog;

    public static void closeDialog() {
        if (null != dialog) {
            dialog.dismiss();
        }
    }


}
