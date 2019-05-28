package com.jizhi.jlongg.main.dialog.pro_cloud;

import android.app.Dialog;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;


/**
 * 功能:打开文件
 * 时间:2017年8月3日11:03:40
 * 作者:xuj
 */
public class DialogOpenFile extends Dialog implements View.OnClickListener {
    /**
     * 进度条宽度
     */
    private int progressWidth;
    /**
     * 下载进度条
     */
    private View progress;
    /**
     * 文件下载回调
     */
    private FileCancelDownLoadListener listener;


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.cancel:
            case R.id.closeBtn: //取消下载
                if (listener != null) {
                    listener.cancel();
                }
                break;
        }
        dismiss();
    }

    public DialogOpenFile(BaseActivity context, String fileName) {
        super(context, R.style.network_dialog_style);
        setContentView(R.layout.repository_downding_dialog);
        progressWidth = DensityUtils.dp2px(context, 230);
        progress = findViewById(R.id.progress);
        TextView repositoryNameText = (TextView) findViewById(R.id.fileName);
        repositoryNameText.setText("《" + fileName + "》");
        findViewById(R.id.closeBtn).setOnClickListener(this);
        findViewById(R.id.cancel).setOnClickListener(this);
        commendAttribute(false);
    }

    public FileCancelDownLoadListener getListener() {
        return listener;
    }

    public void setListener(FileCancelDownLoadListener listener) {
        this.listener = listener;
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface FileCancelDownLoadListener {
        public void cancel();
    }

    /**
     * 已下载的百分比
     *
     * @param downLoadingWeight
     */
    public void updateDownLoading(float downLoadingWeight) {
        ViewGroup.LayoutParams params = progress.getLayoutParams();
        params.width = (int) (progressWidth * downLoadingWeight);
        progress.setLayoutParams(params);
    }

}
