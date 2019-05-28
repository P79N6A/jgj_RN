package com.jizhi.jlongg.main.dialog;

import android.app.ActionBar;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.listener.EditorSyncPersonListener;

/**
 * 同步账单 更多
 *
 * @author huchangsheng
 * @date 2016年4月18日 15:45:12
 */
public class PopSyschMore extends PopupWindow implements View.OnClickListener {

    private Context context;
    private EditorSyncPersonListener listener;

    public PopSyschMore(Context context, EditorSyncPersonListener listener) {
        super(context);
        this.context = context;
        this.listener = listener;
        init();
    }

    private void init() {
        View view = LayoutInflater.from(context).inflate(R.layout.layout_synch_more, null);
        setContentView(view);
        setWidth(ActionBar.LayoutParams.MATCH_PARENT);
        setHeight(ActionBar.LayoutParams.MATCH_PARENT);
        setFocusable(true);
        ColorDrawable dw = new ColorDrawable(0x00);
        setBackgroundDrawable(dw);
        initData(view);
    }


    private void initData(View view) {
        view.findViewById(R.id.right_title).setOnClickListener(this);
        view.findViewById(R.id.tv_edit).setOnClickListener(this);
        view.findViewById(R.id.pop_main).setOnClickListener(this);
        view.findViewById(R.id.rea_red).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_edit:
                listener.SynchMoreEditClick();
                dismiss();
                break;

            case R.id.right_title:
                listener.SynchMoreDeleteClick();
                dismiss();
                break;
            case R.id.rea_red:
                break;
            case R.id.pop_main:
                dismiss();
                break;

        }
    }
}
