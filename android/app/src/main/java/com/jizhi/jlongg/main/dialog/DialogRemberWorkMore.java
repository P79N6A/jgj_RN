package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.listener.RemberInfoMoreListener;
import com.jizhi.jlongg.main.util.CommonMethod;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class DialogRemberWorkMore extends PopupWindowExpand implements View.OnClickListener {
    private Activity activity;
    private RemberInfoMoreListener remberInfoMoreListener;
    //1小时 2 工
    private int current_work_show_flag;
    private int size;

    public DialogRemberWorkMore(Activity activity, int size, int current_work_show_flag, RemberInfoMoreListener remberInfoMoreListener) {
        super(activity);
        this.activity = activity;
        this.current_work_show_flag = current_work_show_flag;
        this.size = size;
        this.remberInfoMoreListener = remberInfoMoreListener;
        setPopView();
        updateContent();
    }

    public int getCurrent_work_show_flag() {
        return current_work_show_flag;
    }

    public void setCurrent_work_show_flag(int current_work_show_flag) {
        this.current_work_show_flag = current_work_show_flag;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_rember_worker_more, null);
        setContentView(popView);
        setPopParameter();
    }

    public void updateContent() {
        popView.findViewById(R.id.tv_show_type).setOnClickListener(this);
        popView.findViewById(R.id.tv_down).setOnClickListener(this);
        popView.findViewById(R.id.tv_del).setOnClickListener(this);
        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);

        if (current_work_show_flag == 1) {
            ((TextView) popView.findViewById(R.id.tv_show_type)).setText("按“工天”显示");
        } else {
            ((TextView) popView.findViewById(R.id.tv_show_type)).setText("按“小时”显示");
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_show_type: //
                //1小时 2 工
                if (current_work_show_flag == 1) {
                    remberInfoMoreListener.changeShowType(true);
                } else {
                    remberInfoMoreListener.changeShowType(false);
                }
                break;
            case R.id.tv_del: //删除
                if (size == 0) {
                    CommonMethod.makeNoticeLong(activity, "没有可删除的数据", CommonMethod.SUCCESS);
                    return;
                }

                remberInfoMoreListener.delReberInfo();
                break;
            case R.id.tv_down: //下载
                if (size == 0) {
                    CommonMethod.makeNoticeShort(activity, "没有可下载的数据", CommonMethod.SUCCESS);
                    return;
                }
                remberInfoMoreListener.downFile();
                break;
        }
        dismiss();
    }
}