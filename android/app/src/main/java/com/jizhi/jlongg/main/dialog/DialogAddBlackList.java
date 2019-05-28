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
 * 功能:加入黑名单提示框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogAddBlackList extends Dialog implements View.OnClickListener {
    //1:加入黑名单  2:删除并且退出群聊
    private int type;
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
                if (type == 1) {
                    if (null != userInfoClickListener) {
                        userInfoClickListener.addOrRemoveBalck();
                    }
                }
//                else if (type == 2) {
//                    removeChats();
//                }
                break;
        }
        dismiss();
    }


    public DialogAddBlackList(Activity activity, String uid, String text, int type) {
        super(activity, R.style.network_dialog_style);
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        this.type = type;
        createLayout(text);
    }

    public DialogAddBlackList(Activity activity, String uid, String text, int type, UserInfoClickListener userInfoClickListener) {
        super(activity, R.style.network_dialog_style);
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        this.type = type;
        this.userInfoClickListener = userInfoClickListener;
        createLayout(text);
    }


}
