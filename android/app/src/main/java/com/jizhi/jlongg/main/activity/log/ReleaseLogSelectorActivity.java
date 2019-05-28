package com.jizhi.jlongg.main.activity.log;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
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
public class ReleaseLogSelectorActivity extends BaseActivity {
    private ReleaseLogSelectorActivity mActivity;
    /* 添加工人、工头列表适配器 */
    private SelectProjectLevelAdapter adapter;
    private ListView listView;
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
                for (int i = 0; i < list.size(); i++) {
                    if (i == position) {
                        list.get(position).setChecked(true);
                        intent.putExtra("text", list.get(position).getName());
                        intent.putExtra("id", list.get(position).getId()+"");
                    } else {
                        list.get(i).setChecked(false);
                    }
                }
                LUtils.e("--11--"+new Gson().toJson(list));
                intent.putExtra("position", getIntent().getIntExtra("position", -1));
                Bundle bundle = new Bundle();
                bundle.putSerializable("list", (Serializable) list);
                intent.putExtras(bundle);
                setResult(Constance.REQUEST, intent);
                finish();
            }
        });

    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, String title, List<ProjectLevel> list, int position) {
        Intent intent = new Intent(context, ReleaseLogSelectorActivity.class);
        intent.putExtra("title", title);
        intent.putExtra("position", position);
        Bundle bundle = new Bundle();
        bundle.putSerializable("list", (Serializable) list);
        intent.putExtras(bundle);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化view
     */
    private void initView() {
        mActivity = ReleaseLogSelectorActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        list = new ArrayList<>();
        SetTitleName.setTitle(findViewById(R.id.title), getIntent().getStringExtra("title"));
        list = (List<ProjectLevel>) getIntent().getSerializableExtra("list");
    }
}
