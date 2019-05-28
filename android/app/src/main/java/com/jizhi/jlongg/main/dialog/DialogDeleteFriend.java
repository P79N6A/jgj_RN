package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.UserInfoClickListener;


/**
 * 功能:删除好友提示框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogDeleteFriend extends Dialog implements View.OnClickListener {
    private UserInfoClickListener userInfoClickListener;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String text) {
        setContentView(R.layout.dialog_blacklist);
        updateContent(text);
    }

    public void updateContent(String text) {
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        ((TextView) findViewById(R.id.tv_content)).setText(text);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                if (null != userInfoClickListener) {
                    userInfoClickListener.delFriend();
                }
                break;
        }
        dismiss();
    }


    public DialogDeleteFriend(Activity activity, String uid, String text, UserInfoClickListener userInfoClickListener) {
        super(activity, R.style.network_dialog_style);
        this.userInfoClickListener = userInfoClickListener;
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        createLayout(text);
    }
}
