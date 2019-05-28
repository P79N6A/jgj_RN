package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CallPhoneAdapter;
import com.jizhi.jlongg.main.bean.PersonInfo;

/**
 * 功能:合并项目Dialog
 * 时间:2016年9月9日 17:11:46
 * 作者:xuj
 */
public class DialogMergeProject extends Dialog implements View.OnClickListener {

    public DialogMergeProject(Activity context, PersonInfo[] listPhone, CallPhoneListener listener) {
        super(context, R.style.Custom_Progress);
        createLayout(context, listPhone, listener);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context, final PersonInfo[] listPhone, final CallPhoneListener listener) {
        setContentView(R.layout.dialog_callphone);
        ListView listView = (ListView) findViewById(R.id.listView);
        CallPhoneAdapter CallPhoneAdapter = new CallPhoneAdapter(context, listPhone);
        listView.setAdapter(CallPhoneAdapter);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //关闭
                dismiss();
                break;
        }
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface CallPhoneListener {
        public void callBack();
    }
}
