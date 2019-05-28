package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SelectProjectLevelAdapter;
import com.jizhi.jlongg.main.bean.ProjectLevel;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 功能: 发质量，安全选择隐患级别
 * 作者：胡常生
 * 时间: 2017年5月26日 16:10:12
 */
public class ReleaseProjectLevelActivity extends BaseActivity {
    private ReleaseProjectLevelActivity mActivity;
    /* 添加工人、工头列表适配器 */
    private SelectProjectLevelAdapter adapter;
    private ListView listView;
    private int type;
    private static final String SELECTSTE = "selectStr";
    private List<ProjectLevel> list;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_level);
        initView();
        adapter = new SelectProjectLevelAdapter(mActivity, list);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent();
                ProjectLevel bean = list.get(position);
                bean.setChecked(true);
                intent.putExtra(ReleaseQualityAndSafeActivity.VALUE, bean);
                setResult(type, intent);
                finish();
            }
        });

    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, int type, ProjectLevel levelBean, List<ProjectLevel> list) {
        Intent intent = new Intent(context, ReleaseProjectLevelActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, type);
        intent.putExtra(SELECTSTE, levelBean);
        Bundle bundle = new Bundle();
        bundle.putSerializable("list", (Serializable) list);
        intent.putExtras(bundle);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStarts(Activity context, int type, ProjectLevel levelBean, List<ProjectLevel> list, String title) {
        Intent intent = new Intent(context, ReleaseProjectLevelActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, type);
        intent.putExtra(SELECTSTE, levelBean);
        intent.putExtra("title", title);
        Bundle bundle = new Bundle();
        bundle.putSerializable("list", (Serializable) list);
        intent.putExtras(bundle);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化view
     */
    private void initView() {
        mActivity = ReleaseProjectLevelActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        list = new ArrayList<>();

        String title = getIntent().getStringExtra("title");

        if (!TextUtils.isEmpty(title)) {
            type = getIntent().getIntExtra(Constance.BEAN_CONSTANCE, 0);
            SetTitleName.setTitle(findViewById(R.id.title), title);
        } else {
            type = getIntent().getIntExtra(Constance.BEAN_CONSTANCE, 0);
            if (type == ReleaseQualityAndSafeActivity.PROJECT_LEVEL || type == MsgQualityAndSafeFilterActivity.FILTER_LEVEL) {
                SetTitleName.setTitle(findViewById(R.id.title), "隐患级别");
            } else if (type == MsgQualityAndSafeFilterActivity.FILTER_STATE) {
                SetTitleName.setTitle(findViewById(R.id.title), "问题状态");
            } else if (type == MsgQualityAndSafeFilterActivity.FILTER_CHANGE) {
                SetTitleName.setTitle(findViewById(R.id.title), "整改状态");
            }
        }

        ProjectLevel levelSelect = (ProjectLevel) getIntent().getSerializableExtra(SELECTSTE);
        list = (List<ProjectLevel>) getIntent().getSerializableExtra("list");
        for (int i = 0; i < list.size(); i++) {
            if (null != levelSelect && levelSelect.getName().equals(list.get(i).getName())) {
                list.get(i).setChecked(true);
            } else {
                list.get(i).setChecked(false);
            }
        }

    }
}
