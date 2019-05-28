package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.support.v4.content.FileProvider;

import com.jizhi.jlongg.R;

import java.io.File;

/**
 * Created by Administrator on 2017/4/11 0011.
 */

public class ShareUtil {

    public static void shareFile(File file, Activity activity) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(file));
        intent.setType("*/*");
        try {
            activity.startActivity(Intent.createChooser(intent, "文件分享"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void openExcelFile(File file, Activity activity) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(activity, activity.getPackageName() + ".fileProvider", file), "application/vnd.ms-excel");
            } else {
                intent.setDataAndType(Uri.fromFile(file), "application/vnd.ms-excel");
            }
            activity.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.can_not_open_excel), CommonMethod.ERROR);
        }
    }
}
