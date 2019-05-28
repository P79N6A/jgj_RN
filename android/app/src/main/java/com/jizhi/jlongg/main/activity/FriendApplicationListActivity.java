package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.TextUtils;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.NewFriendValidateAdapter;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.FriendValidate;
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
 * 好友申请列表
 *
 * @author Xuj
 * @time 2017年2月16日15:07:47
 * @Version 1.0
 */
public class FriendApplicationListActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {

    /**
     * 新朋友验证列表适配器
     */
    private NewFriendValidateAdapter adapter;
    /**
     * 长按当前点击的下标
     */
    private int contextMenuClickPostion;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, FriendApplicationListActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


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
                getFriendApplicationList();
            }
        });
    }

    private void initView() {
        setTextTitle(R.string.new_friend);

        Drawable mClearDrawable = getResources().getDrawable(R.drawable.chat_add_small_icon);
        mClearDrawable.setBounds(0, 0, DensityUtils.dp2px(getApplicationContext(), 18), DensityUtils.dp2px(getApplicationContext(), 18)); //设置清除的图片
        TextView rightTitle = getTextView(R.id.right_title);
        rightTitle.setText(R.string.add_friend);
        rightTitle.setOnClickListener(this);
        rightTitle.setCompoundDrawables(mClearDrawable, null, null, null);

        getTextView(R.id.defaultDesc).setText("暂无新朋友申请");

        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
    }

    private void setAdapter(final List<FriendValidate> list) {
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            pageListView.setEmptyView(findViewById(R.id.defaultLayout));
            pageListView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                    //在上下文菜单选项中添加选项内容
                    //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                    menu.add(0, Menu.FIRST, 0, "删除");
                }
            });
            pageListView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
                @Override
                public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                    contextMenuClickPostion = position;
                    return false;
                }
            });
            adapter = new NewFriendValidateAdapter(getApplicationContext(), list);
            pageListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    FriendValidate friendValidate = adapter.getItem(position);
                    // 1：未加入,2:已加入，3：已过期
                    if (friendValidate.getStatus() == 1) {
                        ChatUserInfoActivity.actionStart(FriendApplicationListActivity.this, friendValidate.getUid(), friendValidate.getMsg_text());
                    } else {
                        ChatUserInfoActivity.actionStart(FriendApplicationListActivity.this, friendValidate.getUid());
                    }
                }
            });
            pageListView.setListViewAdapter(adapter);
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                adapter.addMoreList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }


    //给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //删除好友申请
                removeFriend(adapter.getList().get(contextMenuClickPostion).getUid());
                break;
        }
        return super.onOptionsItemSelected(item);
    }


    /**
     * 获取申请好友列表
     */
    private void getFriendApplicationList() {
        String httpUrl = NetWorkRequest.ADD_FRIEND_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        CommonHttpRequest.commonRequest(this, httpUrl, FriendValidate.class, true, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<FriendValidate> list = (ArrayList<FriendValidate>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 删除好友请求
     *
     * @param uid
     */
    private void removeFriend(String uid) {
        String httpUrl = NetWorkRequest.DEL_ADD_FRIENDS_APPLY;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                adapter.getList().remove(contextMenuClickPostion);
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //跳转到新朋友界面
                Intent intent = new Intent(getApplicationContext(), AddFriendMainctivity.class);
                startActivityForResult(intent, Constance.REQUEST);
                break;
        }
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getFriendApplicationList();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getFriendApplicationList();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) { //点击单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == Constance.SUCCESS) { //添加好友成功后的回调
            String uid = data.getStringExtra(Constance.UID);
            if (!TextUtils.isEmpty(uid)) {
                for (FriendValidate friendValidate : adapter.getList()) {
                    if (uid.equals(friendValidate.getUid())) {
                        friendValidate.setStatus(2);
                        adapter.notifyDataSetChanged();
                        break;
                    }
                }
            }
        } else if (resultCode == 0X114) { //添加好友信息過期
            String uid = data.getStringExtra(Constance.UID);
            if (!TextUtils.isEmpty(uid)) {
                for (FriendValidate friendValidate : adapter.getList()) {
                    if (uid.equals(friendValidate.getUid())) {
                        friendValidate.setStatus(3);
                        adapter.notifyDataSetChanged();
                        break;
                    }
                }
            }
        } else if (resultCode == RESULT_OK) {
            getFriendApplicationList();
        }
    }
}