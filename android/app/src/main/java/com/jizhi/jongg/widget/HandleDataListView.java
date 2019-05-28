package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;


public class HandleDataListView extends ListView {

    DataChangedListener dataChangedListener;

    public HandleDataListView(Context context) {
        super(context);
    }

    public HandleDataListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public HandleDataListView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void handleDataChanged() {
        super.handleDataChanged();
        if (dataChangedListener != null) {
            dataChangedListener.onSuccess();
        }
    }

    public void setDataChangedListener(DataChangedListener dataChangedListener) {
        this.dataChangedListener = dataChangedListener;
    }

    public interface DataChangedListener {
        public void onSuccess();
    }
}