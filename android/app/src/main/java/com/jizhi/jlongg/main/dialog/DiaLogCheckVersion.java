package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;

/**
 * 功能:检查版本Dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogCheckVersion extends Dialog implements View.OnClickListener {


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final String downloadpath, String versionName, final Activity context, String updateContent) {
        setContentView(R.layout.dialog_new_version);
        TextView updateDesc = (TextView) findViewById(R.id.updateDesc);
//        updateDesc.setText("1.无需登录密码，直接通过手机验证码登录，更方便\n2.可以删除记工对象的信息,轻松管理记工对象\n3.记工可以记0.5小时" +
//                "\n4.吉工家上的文章可以分享到微信好友、朋友圈、QQ或者微博上\n5.吉工家上所有“工头”的称呼会统一修改成“班组长”");
        updateDesc.setText(updateContent);
        findViewById(R.id.updateNow).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                Utils.setDownloadPermission(context, downloadpath);
            }
        });
        findViewById(R.id.closeBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.closeBtn: //关闭
                dismiss();
                break;
        }
    }


    /**
     * 记账添加工人、工头
     */
    public DiaLogCheckVersion(Activity context, String downloadPath, String versionName, String updateContent) {
        super(context, R.style.Custom_Progress);
        createLayout(downloadPath, versionName, context, updateContent);
        commendAttribute(false);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

}
