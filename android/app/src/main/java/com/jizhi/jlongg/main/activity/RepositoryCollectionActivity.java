package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.RepositoryAdapter;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.squareup.otto.Subscribe;

import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;


/**
 * 知识库收藏
 *
 * @author Xuj
 * @time 2017年4月17日17:57:02
 * @Version 1.0
 */
public class RepositoryCollectionActivity extends BaseActivity {

    /**
     * 适配器
     */
    private RepositoryAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.repository_detail);
        initView();
        BusProvider.getInstance().register(this);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RepositoryCollectionActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    private void initView() {
        setTextTitle(R.string.collection_list);
        findViewById(R.id.editLine).setVisibility(View.GONE);
        findViewById(R.id.input_layout).setVisibility(View.GONE);
        final ListView listView = (ListView) findViewById(R.id.listView);
        RepositoryUtil.loadCollectionRepositoryData(this, new RepositoryUtil.LoadRepositoryListener() { //加载知识库数据
            @Override
            public void loadRepositorySuccess(List<Repository> list) {
                if (list != null && list.size() > 0) {
                    adapter = new RepositoryAdapter(RepositoryCollectionActivity.this, list);
                    adapter.setCollectionActivity(true);
                    listView.setAdapter(adapter);
                    findViewById(R.id.defaultLayout).setVisibility(View.GONE);
                } else {
                    findViewById(R.id.defaultLayout).setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void loadRepositoryError() {

            }
        });
    }


    //给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
//        参数为用户选择的菜单选项对象
//        根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //收藏、取消收藏
                RepositoryUtil.collectionOrCancel(adapter.getList().get(adapter.getLongClickPostion()), this,
                        new RepositoryUtil.CollectionListener() {
                            @Override
                            public void collection() { //收藏成功的回调
                                adapter.getList().remove(adapter.getLongClickPostion());
                                adapter.notifyDataSetChanged();
                                if (adapter.getList().size() == 0) {
                                    findViewById(R.id.defaultLayout).setVisibility(View.VISIBLE);
                                }
                            }
                        });
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RepositoryUtil.READ_DOC_RETURN) { //读取文件回调   主要是设置收藏、取消收藏状态的变化
            int isCancelCollection = data.getIntExtra("param1", 0);
            if (isCancelCollection == 0) { //取消收藏了
                adapter.getList().remove(adapter.getClickPosition());
                adapter.notifyDataSetChanged();
                if (adapter.getList().size() == 0) {
                    findViewById(R.id.defaultLayout).setVisibility(View.VISIBLE);
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        setResult(RepositoryUtil.SEARCH_OVER);
        super.onBackPressed();
    }

    @Override
    public void onFinish(View view) {
        setResult(RepositoryUtil.SEARCH_OVER);
        super.onFinish(view);
    }

    //文件下载状态
    @Subscribe
    public void downLoadingStateCallBack(Repository downLoadingRepository) {
        if (downLoadingRepository != null && adapter != null && adapter.getList() != null && adapter.getList().size() > 0) {
            List<Repository> list = adapter.getList();
            int size = list.size();
            for (int i = 0; i < size; i++) {
                if (list.get(i).getId().equals(downLoadingRepository.getId())) {
                    list.set(i, downLoadingRepository);
                    adapter.notifyDataSetChanged();
                    return;
                }
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        BusProvider.getInstance().unregister(this);
    }
}