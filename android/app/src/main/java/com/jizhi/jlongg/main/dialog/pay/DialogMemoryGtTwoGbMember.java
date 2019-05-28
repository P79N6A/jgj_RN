package com.jizhi.jlongg.main.dialog.pay;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * 功能:项目组成员数大于5人
 * 时间:2017年8月7日10:10:12
 * 作者:xuj
 */
public class DialogMemoryGtTwoGbMember extends Dialog implements View.OnClickListener {


    private Activity activity;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogMemoryGtTwoGbMember(Activity activity) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.dialog_gt_five_member);
        TextView tipsContent = (TextView) findViewById(R.id.content);
        tipsContent.setText("免费版的云盘空间不能超过2G，如需使用免费版云盘，请从云盘中将文件删除到≤2G。");
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }
}
