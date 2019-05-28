package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;

import com.jizhi.jlongg.main.listview.RefreshListView;


public class HandleDataListViewMsg extends RefreshListView {

    DataChangedListener dataChangedListener;

    public HandleDataListViewMsg(Context context) {
        super(context);
    }

    public HandleDataListViewMsg(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public HandleDataListViewMsg(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void handleDataChanged() {
        super.handleDataChanged();
        if (null != dataChangedListener) {
            dataChangedListener.onSuccess();
        }

    }

    public void setDataChangedListener(DataChangedListener dataChangedListener) {
        this.dataChangedListener = dataChangedListener;
    }

    public interface DataChangedListener {
        void onSuccess();
    }
}