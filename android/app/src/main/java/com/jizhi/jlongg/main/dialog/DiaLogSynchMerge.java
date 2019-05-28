package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SynchMergeAdapter;
import com.jizhi.jlongg.main.bean.SynchMerge;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;

import java.util.List;

/**
 * 功能:同步项目合并
 * 时间:2016年10月8日 18:45:02
 * 作者:xuj
 */
public class DiaLogSynchMerge extends Dialog implements View.OnClickListener {

    /* 列表适配器 */
    private SynchMergeAdapter adapter;
    /* 回调接口 */
    private CallBackSingleWheelListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public DiaLogSynchMerge(Activity context, List<SynchMerge> list, CallBackSingleWheelListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        createLayout(context, list);
        setClick();
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(Activity context, List<SynchMerge> list) {
        setContentView(R.layout.dialog_synch_merge);
        ListView listView = (ListView) findViewById(R.id.listView);
        adapter = new SynchMergeAdapter(context, list);
        listView.setAdapter(adapter);
    }

    private void setClick() {
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess://确认
                if (listener != null) {
                    listener.onSelected(null, 0);
                }
                break;
            case R.id.redBtn: //取消
                break;
        }
        dismiss();
    }


}
