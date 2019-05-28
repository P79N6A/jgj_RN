package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.view.View;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;


/**
 * 功能:开启通知权限弹框
 * 时间:2019年4月1日15:17:15
 * 作者:xuj
 */
public class DiaLogOpenNoticePermission extends Dialog implements View.OnClickListener {


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(true);
    }

    public DiaLogOpenNoticePermission(Context context) {
        super(context, R.style.Custom_Progress);
        createLayout();
        commendAttribute(false);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_open_notice_permission);
        findViewById(R.id.open).setOnClickListener(this);
        findViewById(R.id.close_icon).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.close_icon: //关闭按钮
                dismiss();
                break;
            case R.id.open://开启权限按钮
                dismiss();
               try{
                   Intent localIntent = new Intent();
                   localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                   if (Build.VERSION.SDK_INT >= 26) {
                       // android 8.0引导
                       localIntent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
                       localIntent.putExtra("android.provider.extra.APP_PACKAGE", getContext().getPackageName());
                   } else if (Build.VERSION.SDK_INT >= 21) {
                       // android 5.0-7.0
                       localIntent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
                       localIntent.putExtra("app_package", getContext().getPackageName());
                       localIntent.putExtra("app_uid", getContext().getApplicationInfo().uid);
                   } else {
                       // 其他
                       localIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
                       localIntent.setData(Uri.fromParts("package", getContext().getPackageName(), null));
                   }

                   LUtils.e("packName:" + getContext());
                   getContext().startActivity(localIntent);
               }catch (Exception e){
                   e.printStackTrace();
                   Intent intent = new Intent();

                   //下面这种方案是直接跳转到当前应用的设置界面。
                   //https://blog.csdn.net/ysy950803/article/details/71910806
                   intent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
                   Uri uri = Uri.fromParts("package", getContext().getPackageName(), null);
                   intent.setData(uri);
                   getContext().startActivity(intent);
               }
                break;
        }
    }
}
