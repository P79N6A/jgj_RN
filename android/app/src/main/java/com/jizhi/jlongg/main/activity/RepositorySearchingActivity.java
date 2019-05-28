package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.RepositoryAdapter;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.squareup.otto.Subscribe;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import noman.weekcalendar.eventbus.BusProvider;


/**
 * 知识库搜索
 *
 * @author Xuj
 * @time 2017年4月18日10:01:38
 * @Version 1.0
 */
public class RepositorySearchingActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 键盘输入时候动态变化的文字
     */
    private TextView searchText;
    /**
     * 未搜索到内容时应该展示的内容
     */
    private TextView noDataTxt;
    /**
     * 适配器
     */
    private RepositoryAdapter adapter;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 文本搜索框
     */
    private EditText searchEdit;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.repository_searching);
        initView();
        BusProvider.getInstance().register(this);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RepositorySearchingActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    private void initView() {

        searchText = (TextView) findViewById(R.id.searchText);
        listView = (ListView) findViewById(R.id.listView);
        noDataTxt = (TextView) findViewById(R.id.noDataTxt);
        searchEdit = (ClearEditText) findViewById(R.id.filterEdit);
        searchEdit.setImeOptions(EditorInfo.IME_ACTION_SEARCH); //设置键盘为搜索按钮
        searchEdit.setFocusable(true);
        searchEdit.setFocusableInTouchMode(true);
        // 根据输入框输入值的改变来过滤搜索
        searchEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String inputValue = s.toString();
                if (TextUtils.isEmpty(inputValue)) { //当前搜索框未输入内容
                    listView.setVisibility(View.GONE);
                    noDataTxt.setVisibility(View.GONE);
                    searchText.setVisibility(View.GONE);
                } else { //已输入内容.
                    if (searchText.getVisibility() == View.GONE) {
                        searchText.setVisibility(View.VISIBLE);
                    }
                    if (noDataTxt.getVisibility() == View.VISIBLE) {
                        noDataTxt.setVisibility(View.GONE);
                    }
                    if (listView.getVisibility() == View.VISIBLE) {
                        listView.setVisibility(View.GONE);
                    }
                    searchText.setText(Html.fromHtml("<font color='#666666'>搜索到</font><font color='#d7252c'>\"" + inputValue + "\"</font>"));
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        searchEdit.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {//按下手机键盘的搜索按钮的时候去 执行搜索的操作
                    final String searchingContent = searchEdit.getText().toString().trim();
                    hanlderSearchResult(searchingContent);
                }
                return false;
            }
        });
        //但有时，我们确实是想让EditText自动获得焦点并弹出软键盘，在设置了EditText自动获得焦点后，
        // 软件盘不会弹出。注意：此时是由于刚跳到一个新的界面，界面未加载完全而无法弹出软键盘。
        // 此时应该适当的延迟弹出软键盘，如500毫秒（保证界面的数据加载完成，如果500毫秒仍未弹出，
        // 则延长至500毫秒）。可以在EditText后面加上一段代码，实例代码如下：
        new Timer().schedule(new TimerTask() {
            public void run() {
                showSoftKeyboard(searchEdit);
            }
        }, 500);
    }

    private void hanlderSearchResult(final String searchingContent) {
        if (!TextUtils.isEmpty(searchingContent)) {
            RepositoryUtil.searchingRepositoryFile(null, searchingContent,
                    RepositorySearchingActivity.this, new RepositoryUtil.LoadRepositoryListener() {
                        @Override
                        public void loadRepositorySuccess(List<Repository> list) {
                            handlerData(list, searchingContent);
                        }

                        @Override
                        public void loadRepositoryError() {

                        }
                    });
        } else {
            CommonMethod.makeNoticeShort(RepositorySearchingActivity.this, "请输入搜索内容", CommonMethod.ERROR);
        }
    }


    /**
     * 处理搜索数据
     *
     * @param list             内容数据
     * @param searchingContent 搜索内容
     */
    private void handlerData(List<Repository> list, String searchingContent) {
        if (list != null && list.size() > 0) { //如果搜索内容不为空则加载
            if (adapter == null) {
                adapter = new RepositoryAdapter(this, list);
                adapter.setFilterValue(searchingContent);
                adapter.setShowLongClickDialog(false);
                listView.setAdapter(adapter);
            } else {
                adapter.setFilterValue(searchingContent);
                adapter.updateList(list);
            }
            noDataTxt.setVisibility(View.GONE);
            listView.setVisibility(View.VISIBLE);
        } else {
            noDataTxt.setVisibility(View.VISIBLE);
            listView.setVisibility(View.GONE);
        }
        searchText.setVisibility(View.GONE);
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String id) {
        Intent intent = new Intent(context, RepositorySearchingActivity.class);
        intent.putExtra("param1", id);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.cancelTxt: //取消按钮
                setResult(RepositoryUtil.SEARCH_OVER);
                finish();
                break;
            case R.id.searchText: //搜索内容
                final String searchingContent = searchEdit.getText().toString().trim();
                hanlderSearchResult(searchingContent);
        }
    }


    @Override
    public void onBackPressed() {
        setResult(RepositoryUtil.SEARCH_OVER);
        super.onBackPressed();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RepositoryUtil.READ_DOC_RETURN) { //读取文件回调   主要是设置收藏、取消收藏状态的变化
            adapter.getList().get(adapter.getClickPosition()).setIs_collection(data.getIntExtra("param1", 0));
            adapter.notifyDataSetChanged();
        }
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