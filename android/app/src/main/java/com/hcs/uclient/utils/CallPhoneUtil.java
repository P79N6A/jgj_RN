package com.hcs.uclient.utils;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;

import java.util.List;

/**
 * 功能:
 * 作者：Administrator
 * 时间: 2016-4-18 17:02
 */
public class CallPhoneUtil {

    public static void callPhone(final Activity activity, final String phone) {
        Acp.getInstance(activity).request(new AcpOptions.Builder()
                        .setPermissions(Manifest.permission.CALL_PHONE)
                        .build(),
                new AcpListener() {
                    @Override
                    public void onGranted() {
                        call(activity, phone);
                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                        CommonMethod.makeNoticeShort(activity, activity.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                    }
                });


    }


    public static void call(Activity activity, String phone) {
        if (!TextUtils.isEmpty(phone)) {
            try {
                Intent phoneIntent = new Intent("android.intent.action.CALL", Uri.parse("tel:" + phone));
                activity.startActivity(new Intent("android.intent.action.CALL", Uri.parse("tel:" + phone)));
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            CommonMethod.makeNoticeShort(activity, "电话号码不存在!", CommonMethod.ERROR);
        }
    }

    public static void callPhone(final Context activity, final String phone) {
        Acp.getInstance(activity).request(new AcpOptions.Builder()
                        .setPermissions(Manifest.permission.CALL_PHONE)
                        .build(),
                new AcpListener() {
                    @Override
                    public void onGranted() {
                        if (!TextUtils.isEmpty(phone)) {
                            Intent intent=new Intent(new Intent("android.intent.action.CALL", Uri.parse("tel:" + phone)));
                            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            activity.startActivity(intent);
                        } else {
                            CommonMethod.makeNoticeShort(activity, "电话号码不存在!", CommonMethod.ERROR);
                        }


                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                        CommonMethod.makeNoticeShort(activity, activity.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                    }
                });


    }
}
