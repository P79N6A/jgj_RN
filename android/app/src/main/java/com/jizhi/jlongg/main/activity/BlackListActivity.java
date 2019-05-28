package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.DeleteUserListener;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.CommonEditorPersonAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
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
 * CName:黑名单
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class BlackListActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {

    /**
     * 黑名单列表适配器
     */
    private CommonEditorPersonAdapter adapter;
    /**
     * true表示正在编辑
     */
    private boolean isEditor;
    /**
     * 编辑按钮
     */
    private TextView editorText;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pagelistview);
        initView();
        autoRefresh();
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
                getBlackListData();
            }
        });
    }


    /**
     * 初始化View
     */
    private void initView() {
        setTextTitleAndRight(R.string.blacklist, R.string.editor);
        getTextView(R.id.defaultDesc).setText("如果在聊天过程中遇到恶意骚扰\n你可以将TA拉黑");
        editorText = getTextView(R.id.right_title);
        editorText.setVisibility(View.GONE);
        final ListView listView = (ListView) findViewById(R.id.listView);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { //listView 点击事件
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (!isEditor) {//黑名单处于编辑状态才可点击
                    String uid = adapter.getList().get(position).getUid();
                    Intent intent = new Intent(getApplicationContext(), ChatUserInfoActivity.class);
                    intent.putExtra(Constance.UID, uid);
                    startActivityForResult(intent, Constance.REQUEST);
                }
            }
        });
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        editorText.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //编辑
                setEditorState();
                break;
        }
    }


    private void setAdapter(List<GroupMemberInfo> list) {
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            pageListView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new CommonEditorPersonAdapter(this, list, new DeleteUserListener() {
                @Override
                public void remove(int position) { //移除黑名单
                    removeBlackListUser(adapter.getList().get(position).getUid(), position);
                }
            });
            pageListView.setListViewAdapter(adapter);
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateListView(list);//替换数据
            } else {
                adapter.addMoreList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
        editorText.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
    }


    /**
     * 获取黑名单列表
     */
    private void getBlackListData() {
        String httpUrl = NetWorkRequest.BLACK_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        CommonHttpRequest.commonRequest(this, httpUrl, GroupMemberInfo.class, true, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> groupMemberInfos = (ArrayList<GroupMemberInfo>) object;
                if (groupMemberInfos != null && groupMemberInfos.size() > 0) {
                    Utils.setPinYinAndSort(groupMemberInfos);
                }
                setAdapter(groupMemberInfos);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 移除黑名单
     *
     * @param uid      被移除人的uid
     * @param position 点击的下标
     */
    private void removeBlackListUser(String uid, final int position) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(Constance.UID, uid);
        //用户状态 true表示移除黑名单,false表示加入黑名单
        final boolean removeBlackList = true;
        MessageUtil.removeBlackList(this, uid, removeBlackList, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "移除成功", CommonMethod.SUCCESS);
                adapter.getList().remove(position);
                adapter.notifyDataSetChanged();
                if (adapter.getList().size() == 0) {
                    editorText.setVisibility(View.GONE); //隐藏编辑按钮
                    editorText.setText("编辑");
                    isEditor = false;
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT);
            finish();
        } else {
            getBlackListData();
        }
    }

    private void setEditorState() {
        if (adapter != null && adapter.getCount() > 0) {
            List<GroupMemberInfo> list = adapter.getList();
            for (GroupMemberInfo bean : list) {
                bean.setShowAnim(false);
            }
            isEditor = !isEditor;
            editorText.setText(isEditor ? "完成" : "编辑");
            adapter.setEditor(isEditor);
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (isEditor) {
                setEditorState();
                return false;
            }
        }
        return super.onKeyDown(keyCode, event);
    }


    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getBlackListData();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getBlackListData();
    }
}
