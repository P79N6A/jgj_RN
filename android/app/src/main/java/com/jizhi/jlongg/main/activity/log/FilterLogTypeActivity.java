package com.jizhi.jlongg.main.activity.log;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.SelectFilterLogTypelAdapter;
import com.jizhi.jlongg.main.bean.LogGroupBean;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 功能:日志类型选择界面
 * 作者：胡常生
 * 时间: 2017年8月1日 16:10:12
 */
public class FilterLogTypeActivity extends BaseActivity {
    private FilterLogTypeActivity mActivity;
    private SelectFilterLogTypelAdapter adapter;
    private ListView listView;
    private static final String SELECTSTE = "selectStr";
    private List<LogGroupBean> list;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_level);
        initView();
        adapter = new SelectFilterLogTypelAdapter(mActivity, list);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent();
                LogGroupBean bean = list.get(position);
                bean.setChecked(true);
                intent.putExtra(MsgLogFilterActivity.VALUE, bean);
                setResult(MsgLogFilterActivity.FILTER_STATE, intent);
                finish();
            }
        });

    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, LogGroupBean levelBean, List<LogGroupBean> list) {
        Intent intent = new Intent(context, FilterLogTypeActivity.class);
        intent.putExtra(MsgLogFilterActivity.VALUE, levelBean);
        Bundle bundle = new Bundle();
        bundle.putSerializable("list", (Serializable) list);
        intent.putExtras(bundle);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化view
     */
    private void initView() {
        mActivity = FilterLogTypeActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        list = new ArrayList<>();
        SetTitleName.setTitle(findViewById(R.id.title), "选择日志类型");
//        LogGroupBean levelSelect = (LogGroupBean) getIntent().getSerializableExtra(MsgLogFilterActivity.VALUE);
        LogGroupBean levelSelect = (LogGroupBean) getIntent().getSerializableExtra(Constance.BEAN_STRING);
        list = (List<LogGroupBean>) getIntent().getSerializableExtra("list");
        for (int i = 0; i < list.size(); i++) {
            if (null != levelSelect && levelSelect.getCat_id().equals(list.get(i).getCat_id())) {
                list.get(i).setChecked(true);
            } else {
                list.get(i).setChecked(false);
            }
        }

    }
}
