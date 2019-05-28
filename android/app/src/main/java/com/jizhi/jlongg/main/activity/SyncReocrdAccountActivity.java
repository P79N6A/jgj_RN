package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;

import com.jizhi.jlongg.R;
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
 * 功能:同步记工
 * 时间:2018年4月19日10:46:44
 * 作者:xuj
 */
public class SyncReocrdAccountActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 待确认记工 适配器
     */
    private SyncRecordAccountAdapter adapter;
    /**
     * 分页列表
     */
    private PageExpandableListView listView;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, SyncReocrdAccountActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sync_record_account_main);
        initView();
        getRecordData();
    }

    private void initView() {
        setTextTitleAndRight(R.string.sync_account, R.string.add_sync);
        listView = (PageExpandableListView) findViewById(R.id.expandableListView);
        getTextView(R.id.defaultDesc).setText(R.string.sync_account_default_tips);
        Drawable mClearDrawable = getResources().getDrawable(R.drawable.chat_add_small_icon);
        mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
        getTextView(R.id.right_title).setCompoundDrawables(mClearDrawable, null, null, null);
    }

    private void setAdapter(final List<SyncInfo> list) {
        if (adapter == null) {
            adapter = new SyncRecordAccountAdapter(SyncReocrdAccountActivity.this, list, new SyncRecordAccountAdapter.CancelSynListener() {
                @Override
                public void cancelSync(final String syncId) {
                    DialogOnlyTitle closeSynchDialog = new DialogOnlyTitle(SyncReocrdAccountActivity.this, new DiaLogTitleListener() {
                        @Override
                        public void clickAccess(int position) {
                            cancelSyncInfo(syncId);
                        }
                    }, -1, "确定要取消该项目的同步吗？");
                    closeSynchDialog.show();
                }
            });
            listView.setEmptyView(findViewById(R.id.defaultLayout));
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
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pg", listView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        String httpUrl = NetWorkRequest.SYNCED_TARGET_LIST;
        CommonHttpRequest.commonRequest(this, httpUrl, SyncInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
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
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("sync_id", syncId);
        String httpUrl = NetWorkRequest.CLOSESYNCH;
        CommonHttpRequest.commonRequest(this, httpUrl, SyncInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
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
                SelecteSyncTypeActivity.actionStart(this);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SYNC_SUCCESS) { //同步成功后的回调
            getRecordData();
        }
    }
}
