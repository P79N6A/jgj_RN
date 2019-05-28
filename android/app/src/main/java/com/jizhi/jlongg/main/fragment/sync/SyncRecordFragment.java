package com.jizhi.jlongg.main.fragment.sync;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.SelecteSyncTypeActivity;
import com.jizhi.jlongg.main.adpter.SyncRecordAccountAdapter;
import com.jizhi.jlongg.main.bean.SyncInfo;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PageExpandableListView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:同步记工
 * User: xuj
 * Date: 2018年12月14日10:21:45
 */
public class SyncRecordFragment extends Fragment implements View.OnClickListener {

    /**
     * 待确认记工 适配器
     */
    private SyncRecordAccountAdapter adapter;
    /**
     * 分页列表
     */
    private PageExpandableListView listView;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.sync_record_account_fragment, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
        getRecordData();
    }

    private void initView() {
        listView = (PageExpandableListView) getView().findViewById(R.id.expandableListView);
        ((TextView) getView().findViewById(R.id.defaultDesc)).setText(R.string.sync_account_default_tips);
    }

    private void setAdapter(final List<SyncInfo> list) {
        if (adapter == null) {
            adapter = new SyncRecordAccountAdapter(getActivity(), list, new SyncRecordAccountAdapter.CancelSynListener() {
                @Override
                public void cancelSync(final String syncId) {
                    DialogOnlyTitle closeSynchDialog = new DialogOnlyTitle(getActivity(), new DiaLogTitleListener() {
                        @Override
                        public void clickAccess(int position) {
                            cancelSyncInfo(syncId);
                        }
                    }, -1, "确定要取消该项目的同步吗？");
                    closeSynchDialog.show();
                }
            });
            listView.setEmptyView(getView().findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(list);
        }
        if (adapter.getList() != null && adapter.getGroupCount() > 0) { //由于是二级菜单 默认展开第一个
            int listSize = adapter.getList().size();
            for (int i = 0; i < listSize; i++) {
                listView.expandGroup(i);
            }
        }
    }

    /**
     * 获取记工列表数据
     */
    public void getRecordData() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("pg", listView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        String httpUrl = NetWorkRequest.SYNCED_TARGET_LIST;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, SyncInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<SyncInfo> list = (ArrayList<SyncInfo>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

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
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, SyncInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                getRecordData();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title://新增同步
                SelecteSyncTypeActivity.actionStart(getActivity());
                break;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SYNC_SUCCESS) { //同步成功后的回调
            getRecordData();
        }
    }

}
