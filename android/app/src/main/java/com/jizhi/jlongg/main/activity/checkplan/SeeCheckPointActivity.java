package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.check.ShowCheckContentOrChechPointAdapter;
import com.jizhi.jlongg.main.bean.CheckPoint;
import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;
import java.util.List;

/**
 * CName:查看检查点详情
 * User: xuj
 * Date: 2017年11月22日
 * Time: 14:58:16
 */
public class SeeCheckPointActivity extends BaseActivity {

    /**
     * 启动当前Activity
     *
     * @param context
     * @param checkPoints     项目检查点数据
     * @param navigationTitle 导航栏标题
     */
    public static void actionStart(Activity context, List<CheckPoint> checkPoints, String navigationTitle) {
        Intent intent = new Intent(context, SeeCheckPointActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) checkPoints);
        intent.putExtra(Constance.TITLE, navigationTitle);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initView();
    }

    private void initView() {
        Intent intent = getIntent();
        String navigationTitle = intent.getStringExtra(Constance.TITLE);
        List<CheckPoint> list = (List<CheckPoint>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        getTextView(R.id.title).setText(navigationTitle);
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(new ShowCheckContentOrChechPointAdapter(this, list, false));
    }


}
