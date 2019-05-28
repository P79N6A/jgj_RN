package com.jizhi.jlongg.main.fragment.checkplan;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.activity.checkplan.CheckListActivity;
import com.jizhi.jlongg.main.activity.checkplan.NewOrUpdateCheckContentActivity;
import com.jizhi.jlongg.main.activity.checkplan.NewOrUpdateCheckListActivity;
import com.jizhi.jlongg.main.activity.checkplan.SeeCheckContentActivity;
import com.jizhi.jlongg.main.activity.checkplan.SeeCheckListActivity;
import com.jizhi.jlongg.main.adpter.check.CheckListContentAdapter;
import com.jizhi.jlongg.main.bean.BaseCheckInfo;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.PageListView;
import com.lidroid.xutils.exception.HttpException;

import java.util.List;

/**
 * CName:检查项、检查内容
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class CheckListContentFragment extends Fragment implements View.OnClickListener, PullRefreshCallBack {

    /**
     * 0、表示检查项 1、表示检查内容
     */
    private int currentNavigationId;
    /**
     * 长按事件点击的下标
     */
    private int longClickPostion;
    /**
     * 上下文删除TAG
     */
    private final int CONTEXT_DELETE_TAG = Menu.FIRST;
    /**
     * 列表适配器
     */
    private CheckListContentAdapter adapter;
    /**
     * 新建按钮布局
     */
    private View bottomLayout;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 组是否已关闭
     */
    private boolean isClosed;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.check_list_content, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
        autoRefresh();
    }


    private void initView() {
        CheckListActivity checkListActivity = (CheckListActivity) getActivity();
        View fragmentView = getView();
        Bundle bundle = getArguments();
        pageListView = (PageListView) getView().findViewById(R.id.listView);

        currentNavigationId = bundle.getInt(Constance.NAVIGATION_ID, checkListActivity.CHECK_LIST);
        bottomLayout = fragmentView.findViewById(R.id.bottom_layout);
        bottomLayout.setVisibility(View.GONE);

        mSwipeLayout = (SwipeRefreshLayout) getView().findViewById(R.id.swipeLayout);
        pageListView.addHeaderView(Utils.getHeadBackgroundView(getActivity()), null, false);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(checkListActivity.loadMoreDataView()); //设置上拉刷新组件
        TextView defaultNewPlan = (TextView) fragmentView.findViewById(R.id.createBtn);
        TextView defaultDesc = (TextView) fragmentView.findViewById(R.id.defaultDesc);
        Button button = (Button) getView().findViewById(R.id.red_btn);
        button.setText(currentNavigationId == checkListActivity.CHECK_LIST ? R.string.create_check_list : R.string.create_check_content);
        button.setOnClickListener(this);
        defaultNewPlan.setText(currentNavigationId == checkListActivity.CHECK_LIST ? R.string.create_check_list : R.string.create_check_content);
        defaultDesc.setText(currentNavigationId == checkListActivity.CHECK_LIST ? R.string.no_check_list_tips : R.string.no_check_content);
        defaultNewPlan.setOnClickListener(this); //默认页新建按钮
        fragmentView.findViewById(R.id.viewHelp).setOnClickListener(this); //帮助

        isClosed = getActivity().getIntent().getBooleanExtra(Constance.IS_CLOSED, false);
        getView().findViewById(R.id.createBtn).setVisibility(isClosed ? View.GONE : View.VISIBLE);
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
                loadListData();
            }
        });
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) { //上拉加载回调
        loadListData();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) { //下拉加载回调
        loadListData();
    }


    /**
     * 加载列表数据数据
     */
    private void loadListData() {
        CheckListActivity checkListActivity = (CheckListActivity) getActivity();
        Intent intent = checkListActivity.getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID); //项目组id
        String type = currentNavigationId == checkListActivity.CHECK_LIST ? checkListActivity.CHECK_LIST_STRING : checkListActivity.CHECK_CONTENT_STRING; //检查项pro,检查内容content
        CheckListHttpUtils.getInspecProList(checkListActivity, groupId, WebSocketConstance.TEAM, pageListView.getPageNum(), type, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                BaseCheckInfo checkPlen = (BaseCheckInfo) object;
                if (checkPlen != null) {
                    List<BaseCheckInfo> list = checkPlen.getList();
                    //如果不是第一页的数据 需要将数据排重  因为列表数据具有删除的权限 所以可能会出现数据相同的问题
                    if (pageListView.getPageNum() != 1 && adapter != null && adapter.getCount() > 0) {
                        for (BaseCheckInfo checkInfo : adapter.getList()) {
                            int size = list.size();
                            for (int i = 0; i < size; i++) {
                                if (checkInfo.getId() == list.get(i).getId()) {
                                    list.remove(i);
                                    break;
                                }
                            }
                        }
                    }
                    setAdapter(list);
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                pageListView.loadOnFailure();
            }
        });
    }


    private void setAdapter(List<BaseCheckInfo> list) {
        final PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new CheckListContentAdapter(getActivity(), list);
            pageListView.setEmptyView(getView().findViewById(R.id.defaultLayout));
            pageListView.setListViewAdapter(adapter);
            pageListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    position -= pageListView.getHeaderViewsCount();
                    if (position <= -1)
                        position = 0;
                    BaseCheckInfo baseCheckInfo = adapter.getList().get(position);
                    CheckListActivity checkListActivity = (CheckListActivity) getActivity();
                    String groupId = checkListActivity.getIntent().getStringExtra(Constance.GROUP_ID);
                    if (currentNavigationId == checkListActivity.CHECK_LIST) { //新建检查项
                        SeeCheckListActivity.actionStart(checkListActivity, groupId, baseCheckInfo.getId(), isClosed ? true : false);
                    } else { //查看检查内容
                        SeeCheckContentActivity.actionStart(checkListActivity, groupId, baseCheckInfo.getId(), isClosed);
                    }
                }
            });
            pageListView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
                @Override
                public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                    position -= pageListView.getHeaderViewsCount();
                    if (position <= -1)
                        position = 0;
                    longClickPostion = position;
                    return false;
                }
            });
            pageListView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                    if (adapter.getItem(longClickPostion).getIs_operate() == 0) {
                        return;
                    }
                    //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                    menu.add(0, CONTEXT_DELETE_TAG, 0, "删除");
                }
            });
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateListView(list);//替换数据
            } else {
                adapter.addMoreList(list); //添加数据
            }
        }
        if (pageNum == 1) {
            bottomLayout.setVisibility(!isClosed && (list != null && list.size() > 0) ? View.VISIBLE : View.GONE);
        }
        pageListView.loadDataFinish(list);
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.viewHelp: //查看帮助
                if (currentNavigationId == CheckListActivity.CHECK_LIST) { //检查项标识
                    HelpCenterUtil.actionStartHelpActivity(getActivity(), 182);
                } else {
                    HelpCenterUtil.actionStartHelpActivity(getActivity(), 182);
                }
                break;
            case R.id.createBtn: //无数据时新建计划按钮
            case R.id.red_btn:
                String groupId = getActivity().getIntent().getStringExtra(Constance.GROUP_ID);
                if (currentNavigationId == CheckListActivity.CHECK_LIST) { //新建检查项
                    NewOrUpdateCheckListActivity.actionStart(getActivity(), groupId, -1, NewOrUpdateCheckContentActivity.CREATE_CHECK);
                } else { //新建检查内容
                    NewOrUpdateCheckContentActivity.actionStart(getActivity(), groupId, -1, NewOrUpdateCheckContentActivity.CREATE_CHECK);
                }
                break;

        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT
                || resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST
                ) { //修改了检查内容、获检查项 重新加载数据
            autoRefresh();
        }
    }

    /**
     * 在Viewpager中的Fragment使用ContextMenu发生的问题
     * 在我的具体项目环境中，Viewpager中存在3个Fragment（0/1/2），并继承自一个父类BaseFragment。在父类中完成了上下文菜单的绝大部分工作，即上文提到的创建/注册/响应点击；子类中仅重写onCreateContextMenu方法，用于区分修改菜单显示；那么问题来了：
     * 当点击Fragment0的上下文菜单的某项时，Fragment1和2的点击响应事件也同时执行了；
     * 当分别点击Fragment1和2的上下文菜单时，也仍然按照Fragment0-1-2的顺序将响应事件依次执行一遍；
     * 解决方法
     * 问题的症结在于Viewpager改变了其中的Fragment显式的生命周期和关联关系，在前文《关于Activity中的Viewpager中的Fragment的生命周期》我也提到过这一问题，并尝试采用setUserVisibleHint方法解决了问题；在本文中同样，可以采用getUserVisibleHint()方法判断当前Fragment是否真实可见，如可见则响应，不可见则截止并向下分发，直到有可见页面响应为止。
     * 在3个Fragment子类中，均需重写
     * [java] view plain copy
     * public boolean onContextItemSelected(MenuItem item) {
     * if (getUserVisibleHint()) {
     * return super.onContextItemSelected(item);
     * }
     * return false;
     * }
     * return true 代表截断
     * return false 代表继续分发
     */

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        if (getUserVisibleHint()) {
            BaseCheckInfo baseCheckInfo = adapter.getItem(longClickPostion);
            switch (item.getItemId()) {
                case CONTEXT_DELETE_TAG:
                    CheckListActivity checkListActivity = (CheckListActivity) getActivity();
                    if (currentNavigationId == checkListActivity.CHECK_LIST) { //删除检查项
                        CheckListHttpUtils.deleteCheckList(checkListActivity, baseCheckInfo.getId(), new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object checkPlan) {
                                adapter.getList().remove(longClickPostion);
                                adapter.notifyDataSetChanged();
                                if (adapter.getCount() == 0) {
                                    bottomLayout.setVisibility(View.GONE);
                                }
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {

                            }
                        });
                    } else { //删除检查内容
                        CheckListHttpUtils.deleteCheckContent(checkListActivity, baseCheckInfo.getId(), new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object checkPlan) {
                                adapter.getList().remove(longClickPostion);
                                adapter.notifyDataSetChanged();
                                if (adapter.getCount() == 0) {
                                    bottomLayout.setVisibility(View.GONE);
                                }
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {

                            }
                        });
                    }
                    break;
            }
            return super.onContextItemSelected(item);
        }
        return false;
    }


}
