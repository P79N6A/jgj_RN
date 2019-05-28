package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import com.jizhi.jlongg.R;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class DialogNoteBookMore extends PopupWindowExpand implements View.OnClickListener {
    private Activity activity;
    private UpdateLogInterFace updateLogInterFace;


    public DialogNoteBookMore(Activity activity, UpdateLogInterFace updateLogInterFace) {
        super(activity);
        this.activity = activity;
        this.updateLogInterFace = updateLogInterFace;
        setPopView();
        updateContent();

    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_log_more, null);
        setContentView(popView);
        setPopParameter();
    }

    public void updateContent() {
        popView.findViewById(R.id.tv_edit).setVisibility(View.GONE);
        popView.findViewById(R.id.view_1).setVisibility(View.GONE);
        popView.findViewById(R.id.tv_del).setOnClickListener(this);
        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_edit: //编辑
                if (null != updateLogInterFace) {
                    updateLogInterFace.updateInfo();
                }

                break;
            case R.id.tv_del: //删除
                if (null != updateLogInterFace) {
                    updateLogInterFace.deleteInfo();
                }
//                if (closeDialog == null) {
//                    closeDialog = new DialogTips((BaseActivity) activity, this, desc, DialogTips.CLOSE_TEAM);
//                }
//                closeDialog.show();
                break;
        }
        dismiss();
    }


    public interface UpdateLogInterFace {
        void updateInfo();

        void deleteInfo();
    }
}
