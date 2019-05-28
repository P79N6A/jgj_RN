package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.CommonMethod;


/**
 * 功能:知识库文件下载弹出框
 * 时间:2017年5月26日14:46:06
 * 作者:xuj
 */
public class DialogRepository extends Dialog implements View.OnClickListener {
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
    private FileDownLoadingListener listener;

    private BaseActivity context;


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.cancel:
            case R.id.closeBtn: //取消下载
                if (listener != null) {
                    CommonMethod.makeNoticeShort(context, "读取已取消", CommonMethod.ERROR);
                    listener.cancel();
                }
                break;
        }
        dismiss();
    }

    public DialogRepository(BaseActivity context, String repositoryName) {
        super(context, R.style.network_dialog_style);
        setContentView(R.layout.repository_downding_dialog);
        this.context = context;
        progressWidth = DensityUtils.dp2px(context, 230);
        progress = findViewById(R.id.progress);
        TextView downLoadingText = (TextView) findViewById(R.id.downLoadingText);

        TextView repositoryNameText = (TextView) findViewById(R.id.fileName);
        repositoryNameText.setText("《" + repositoryName + "》");
        findViewById(R.id.closeBtn).setOnClickListener(this);
        findViewById(R.id.cancel).setOnClickListener(this);
        commendAttribute(false);
        downLoadingText.setText("正在读取");
    }

    public FileDownLoadingListener getListener() {
        return listener;
    }

    public void setListener(FileDownLoadingListener listener) {
        this.listener = listener;
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface FileDownLoadingListener {
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
