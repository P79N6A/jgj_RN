package com.jizhi.jlongg.main.dialog.pro_cloud;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.EditText;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 功能:项目云盘-->新建文件夹
 * 时间:2017年7月17日14:44:05
 * 作者:xuj
 */
public class DialogCreateFolder extends Dialog implements View.OnClickListener {

    /**
     * 新建文件夹编辑框
     */
    private EditText newFolderEdit;
    /**
     * 点击确定回调
     */
    private CreateFolderGetNameListener listener;

    private BaseActivity activity;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogCreateFolder(BaseActivity activity) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.create_folder_dialog);
        newFolderEdit = (EditText) findViewById(R.id.newFolderEdit);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //取消
                dismiss();
                break;
            case R.id.btn_asscess: //确定
                if (listener != null) {
                    listener.getName(newFolderEdit.getText().toString());
                }
                break;
        }
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        newFolderEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(newFolderEdit);
            }
        }, 200);
    }

    public CreateFolderGetNameListener getListener() {
        return listener;
    }

    public void setListener(CreateFolderGetNameListener listener) {
        this.listener = listener;
    }

    /**
     * 创建文件夹回调
     */
    public interface CreateFolderGetNameListener {
        public void getName(String folderName); //文件夹名称
    }


}
