package com.jizhi.jlongg.main.fragment.sync;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.activity.AddSyncPersonActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.SyncActivity;
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
 * CName:同步给我的记工
 * User: xuj
 * Date: 2018年12月14日10:21:45
 */
public class SyncToMeRecordFragment extends Fragment implements View.OnClickListener, PullRefreshCallBack {

    /**
     * 列表适配器
     */
    private SyncRecordToMeAdapter adapter;
    /**
     * 页面ListView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    protected SwipeRefreshLayout mSwipeLayout;
    /**
     * 邀请他人向我同步布局
     */
    private View bottomLayout;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.sync_record_account_to_me_fragment, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
        autoRefresh();
    }

    private void initView() {
        ((TextView) getView().findViewById(R.id.defaultDesc)).setText("当前还没有人向你同步记账数据\n你可以联系其他班组长，要求他向你同步");
        Button defaultBtn = getView().findViewById(R.id.defaultBtn);
        Button redBtn = getView().findViewById(R.id.red_btn);
        defaultBtn.setVisibility(View.VISIBLE);
        defaultBtn.setText("邀请他人向我同步");
        bottomLayout = getView().findViewById(R.id.bottom_layout);
        redBtn.setText("邀请他人向我同步");
        redBtn.setOnClickListener(this);
        defaultBtn.setOnClickListener(this);

        mSwipeLayout = (SwipeRefreshLayout) getView().findViewById(R.id.swipeLayout);
        pageListView = (PageListView) getView().findViewById(R.id.listView);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(((BaseActivity) getActivity()).loadMoreDataView()); //设置上拉刷新组件
        pageListView.setPullRefreshCallBack(this); //设置上拉、下拉刷新回调
    }

    /**
     * 获取同步给我的列表数据
     */
    public void getSyncToMeData() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        String httpUrl = NetWorkRequest.SYNCED_TO_ME;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, SyncDetailInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
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
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("name", name); //名称
        params.addBodyParameter("telph", telph); //电话
        String httpUrl = NetWorkRequest.ASK_USER_TO_SYNC;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, BaseNetBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeLong(getActivity().getApplicationContext(), "发送成功！", CommonMethod.SUCCESS);
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
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("sync_id", syncId);
        String httpUrl = NetWorkRequest.CLOSESYNCH;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, BaseNetNewBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
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
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (pageNum == 1) {
            bottomLayout.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        }
        if (adapter == null) {
            adapter = new SyncRecordToMeAdapter(getActivity(), list, new SyncRecordAccountAdapter.CancelSynListener() {
                @Override
                public void cancelSync(final String syncId) {
                    DialogOnlyTitle closeSynchDialog = new DialogOnlyTitle(getActivity(), new DiaLogTitleListener() {
                        @Override
                        public void clickAccess(int position) {
                            cancelSyncInfo(syncId);
                        }
                    }, -1, "是否取消该数据的同步？");
                    closeSynchDialog.show();
                }
            });
            pageListView.setEmptyView(getView().findViewById(R.id.defaultLayout)); //设置无数据时展示的页面
            pageListView.setListViewAdapter(adapter); //设置适配器
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                adapter.addList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }


    private boolean isEditor() {
        return ((SyncActivity) getActivity()).isEditor;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn:
            case R.id.defaultBtn: //邀请他人向我的同步按钮
                AddSyncPersonActivity.actionStart(getActivity(), 2);
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
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 1) { //添加同步对象成功
            if (data != null) {
                PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                askUserToSync(personBean.getReal_name(), personBean.getTelephone());
            }
        }
    }

    /**
     * 设置编辑状态
     *
     * @param isEditor
     */
    public void setEditor(boolean isEditor) {
        if (adapter != null && adapter.getCount() > 0) {
            adapter.setEditor(isEditor);
            adapter.notifyDataSetChanged();
        }
    }
}
