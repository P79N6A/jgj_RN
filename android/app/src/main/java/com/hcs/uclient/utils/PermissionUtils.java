package com.hcs.uclient.utils;

import android.content.Context;
import android.content.pm.PackageManager;

/**
 * CName:
 * User: hcs
 * Date: 2016-08-11
 * Time: 14:42
 */
public class PermissionUtils {
    public static final String permissionCallPhone = "android.permission.CALL_PHONE";

    /**
     * @param context
     * @param permissionName
     * @return true被禁止 false可以使用
     */
    public static boolean checkPermissionisOpen(Context context, String permissionName) {
        PackageManager pm = context.getPackageManager();
        boolean permission = PackageManager.PERMISSION_GRANTED ==
                pm.checkPermission("android.permission.CALL_PHONE", context.getPackageName());
        return permission;
    }

}
