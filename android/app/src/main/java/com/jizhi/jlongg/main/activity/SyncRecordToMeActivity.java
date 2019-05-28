package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.SyncRecordAccountAdapter;
import com.jizhi.jlongg.main.adpter.SyncRecordToMeAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.SyncDetailInfo;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PageListView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:同步给我的记工
 * 作者：xuj
 * 时间: 2018年5月7日10:06:37
 */
public class SyncRecordToMeActivity extends BaseActivity implements PullRefreshCallBack, View.OnClickListener {
    /**
     * 列表适配器
     */
    private SyncRecordToMeAdapter adapter;
    /**
     * 是否正在编辑
     */
    private boolean isEditor;
    /**
     * 编辑按钮
     */
    private TextView editorText;
    /**
     * 页面ListView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    protected SwipeRefreshLayout mSwipeLayout;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, SyncRecordToMeActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sync_record_to_me);
        initView();
        autoRefresh();
    }

    private void initView() {
        setTextTitleAndRight(R.string.sync_to_me, R.string.editor);
        editorText = getTextView(R.id.right_title);
        getTextView(R.id.defaultDesc).setText("当前还没有人向你同步记账数据\n你可以联系其他班组长，要求他向你同步");
        Button button = getButton(R.id.defaultBtn);
        button.setVisibility(View.VISIBLE);
        button.setText("邀请他人向我同步");

        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        pageListView.setPullRefreshCallBack(this); //设置上拉、下拉刷新回调
        editorText.setVisibility(View.GONE);
    }

    /**
     * 获取同步给我的列表数据
     */
    public void getSyncToMeData() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码

        LUtils.e("http:" + NetWorkRequest.SYNCED_TO_ME);
        String httpUrl = NetWorkRequest.SYNCED_TO_ME;
        CommonHttpRequest.commonRequest(this, httpUrl, SyncDetailInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<SyncDetailInfo> list = (ArrayList<SyncDetailInfo>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    /**
     * 要求某人同步
     *
     * @param name
     * @param telph
     */
    private void askUserToSync(String name, String telph) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("name", name); //名称
        params.addBodyParameter("telph", telph); //电话
        String httpUrl = NetWorkRequest.ASK_USER_TO_SYNC;
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "发送成功！", CommonMethod.SUCCESS);
                autoRefresh();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    /**
     * 取消同步
     *
     * @param syncId 同步id
     */
    public void cancelSyncInfo(String syncId) {
        if (TextUtils.isEmpty(syncId)) {
            return;
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("sync_id", syncId);
        String httpUrl = NetWorkRequest.CLOSESYNCH;
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                autoRefresh();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    private void setAdapter(List<SyncDetailInfo> list) {
        editorText.setVisibility(pageListView.getPageNum() == 1 && list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new SyncRecordToMeAdapter(this, list, new SyncRecordAccountAdapter.CancelSynListener() {
                @Override
                public void cancelSync(final String syncId) {
                    DialogOnlyTitle closeSynchDialog = new DialogOnlyTitle(SyncRecordToMeActivity.this, new DiaLogTitleListener() {
                        @Override
                        public void clickAccess(int position) {
                            cancelSyncInfo(syncId);
                        }
                    }, -1, "是否取消该数据的同步？");
                    closeSynchDialog.show();
                }
            });
            pageListView.setEmptyView(findViewById(R.id.defaultLayout)); //设置无数据时展示的页面
            pageListView.setListViewAdapter(adapter); //设置适配器
            pageListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    if (isEditor) {
                        return;
                    }
                    SyncDetailInfo syncDetailInfo = adapter.getItem(position);
                    StatisticalWorkSecondActivity.actionStart(SyncRecordToMeActivity.this,
                            null, null, syncDetailInfo.getPid() + "", syncDetailInfo.getPro_name(),
                            null, null, null, StatisticalWorkSecondActivity.TYPE_FROM_PROJECT, syncDetailInfo.getPid() + "",
                            "project", false, true, syncDetailInfo.getUid(), true, false);
                }
            });
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                adapter.addList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.defaultBtn: //邀请他人向我的同步按钮
                AddSyncPersonActivity.actionStart(this, 2);
                break;
            case R.id.right_title: //编辑、取消按钮
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                isEditor = !isEditor;
                editorText.setText(isEditor ? R.string.cancel : R.string.editor);
                adapter.setEditor(isEditor);
                adapter.notifyDataSetChanged();
                break;
        }
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getSyncToMeData();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getSyncToMeData();
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                pageListView.setPageNum(1);
                mSwipeLayout.setRefreshing(true);
                getSyncToMeData();
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 1) { //添加同步对象成功
            if (data != null) {
                PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                askUserToSync(personBean.getReal_name(), personBean.getTelephone());
            }
        }
    }
}
