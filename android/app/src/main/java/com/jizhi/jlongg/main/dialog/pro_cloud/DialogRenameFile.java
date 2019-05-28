package com.jizhi.jlongg.main.dialog.pro_cloud;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;

import java.util.Timer;
import java.util.TimerTask;


/**
 * 功能:项目云盘-->重命名文件夹
 * 时间:2017年7月17日14:43:52
 * 作者:xuj
 */
public class DialogRenameFile extends Dialog implements View.OnClickListener {
    /**
     * 重命名文件编辑框
     */
    private EditText renameEdit;
    /**
     * 文件类型
     */
    private TextView fileTypeText;
    /**
     * 点击确定回调
     */
    private RenameFileListener listener;


    private BaseActivity activity;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogRenameFile(BaseActivity activity) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.rename_file_dialog);
        fileTypeText = (TextView) findViewById(R.id.fileType);
        renameEdit = (EditText) findViewById(R.id.renameEdit);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }


    public void setFileType(Cloud cloud, RenameFileListener listener) {
        this.listener = listener;
        String fileType = cloud.getType().equals(CloudUtil.FOLDER_TAG) ? cloud.getType() : cloud.getFile_type();
        fileTypeText.setText("." + fileType); //文件类型
        int indexOf = cloud.getFile_name().lastIndexOf(".");
        if (indexOf <= 0) {
            renameEdit.setText(cloud.getFile_name()); //文件名称
        } else {
            renameEdit.setText(cloud.getFile_name().substring(0, indexOf)); //文件名称
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //取消
                dismiss();
                break;
            case R.id.btn_asscess: //确定
                if (listener != null) {
                    if (TextUtils.isEmpty(renameEdit.getText().toString())) {
                        CommonMethod.makeNoticeShort(activity, "必须填写名称", CommonMethod.ERROR);
                        return;
                    }
                    listener.getUpdateName(renameEdit.getText().toString());
                    dismiss();
                }
                break;
        }
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        renameEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(renameEdit);
            }
        }, 200);
    }


    public interface RenameFileListener {
        public void getUpdateName(String fileName);
    }
}
