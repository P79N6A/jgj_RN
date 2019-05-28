package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.Constance;


/**
 * 功能:添加来源人弹窗
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogAddDataSourceMemberTips extends Dialog implements View.OnClickListener {


    private AddMemberListener listener;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String content) {
        setContentView(R.layout.dialog_close_team);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btn_asscess = (TextView) findViewById(R.id.btn_asscess);
        TextView tvContent = (TextView) findViewById(R.id.tv_content);
        tvContent.setText(content);
        close.setOnClickListener(this);
        btn_asscess.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                if (listener != null) {
                    listener.add(Constance.ADD_SOURCE_DATA_MEMBER);
                }
                break;
        }
        dismiss();
    }


    public DialogAddDataSourceMemberTips(BaseActivity context, AddMemberListener listener, String content) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(content);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
