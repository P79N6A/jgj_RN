package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.TurnOutForWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountDateList;
import com.jizhi.jlongg.main.bean.AccountSwitchConfirm;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.TurnOutForWork;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
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
 * 功能:出勤公式
 * 时间:2016/3/11 11:42
 * 作者:xuj
 */
public class TurnOutForWorkActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {
    /**
     * listView
     */
    private PageExpandableListView pageListView;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 出勤公式列表适配器
     */
    private TurnOutForWorkAdapter adapter;
    /**
     * 未确认记工数量
     */
    private TextView accountConfirmBtn;
    /**
     * 未确认记工布局
     */
    private View accountConfirmLayout;
    /**
     * 是否已加载记账开关状态
     */
    private boolean isLoadRecordConfirmStatus;
    /**
     * 1 表示关闭 ；0:表示开启
     */
    private int recordConfirmStatus;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId  项目组id(主要是做查询数据作用,必须传)
     * @param isClosed 是否关闭(班组是否已关闭 true表示关闭 ,false表示打开)
     * @param pid      项目id(主要是查看记工未确认笔数使用到这个参数如果不使用可以传0)
     */
    public static void actionStart(Activity context, String groupId, boolean isClosed, String pid) {
        Intent intent = new Intent(context, TurnOutForWorkActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        intent.putExtra(Constance.PID, pid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.turn_out_for_work);
        initView();
        autoRefresh();
    }


    private void initView() {
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        if (TextUtils.isEmpty(groupId)) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "获取项目信息出错", CommonMethod.ERROR);
            finish();
            return;
        }
        if (intent.getBooleanExtra(Constance.IS_CLOSED, false)) { //项目已关闭了
            findViewById(R.id.closedIcon).setVisibility(View.VISIBLE);  //显示项目已关闭图标
        }
        setTextTitle(R.string.turn_out_for_work);
        TextView rightTitle = getTextView(R.id.right_title);
        rightTitle.setText(R.string.more);
        findViewById(R.id.title).setOnClickListener(this);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        accountConfirmBtn = getTextView(R.id.accountConfirmBtn);
        accountConfirmLayout = findViewById(R.id.accountConfirmLayout);

        PageExpandableListView pageListView = (PageExpandableListView) findViewById(R.id.listView);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        this.pageListView = pageListView;
    }

    private final String ITEM_1 = "1";
    private final String ITEM_2 = "2";

    public List<SingleSelected> getCloseItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(false, true).setSelecteNumber(ITEM_1));
        list.add(new SingleSelected("下载最近30天考勤表", getString(R.string.hint_wps), false, true, ITEM_2, Color.parseColor("#000000"), 18));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //右上角菜单：点工按“工天”显示 / 点工按“小时”显示
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getCloseItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case ITEM_1: //切换记工显示方式
                                AccountShowTypeActivity.actionStart(TurnOutForWorkActivity.this);
                                break;
                            case ITEM_2: //下载最近三十天出勤记录
                                if (adapter == null || adapter.getGroupCount() == 0) {
                                    String tips = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "没有可下载的数据" : "没有自己的出勤记录";
                                    CommonMethod.makeNoticeShort(getApplicationContext(), tips, CommonMethod.ERROR);
                                    return;
                                }
                                downLoad();
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.title:
                HelpCenterUtil.actionStartHelpActivity(TurnOutForWorkActivity.this, 199);
                break;
            case R.id.confirmBtn: //去确认按钮
                if (UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM)) {
                    final boolean isForeman = UclientApplication.isForemanRoler(getApplicationContext());
                    DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(this, null, null, new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {

                        }

                        @Override
                        public void clickRightBtnCallBack() {
                            CommonHttpRequest.changeRoler(TurnOutForWorkActivity.this, false, isForeman ? Constance.ROLETYPE_WORKER : Constance.ROLETYPE_WORKER, new CommonHttpRequest.CommonRequestCallBack() {
                                @Override
                                public void onSuccess(Object object) {
//                                    finish();
                                }

                                @Override
                                public void onFailure(HttpException exception, String errormsg) {

                                }
                            });
                        }
                    });
                    dialogLeftRightBtnConfirm.setRightBtnText(getString(isForeman ? R.string.change_roler_worker : R.string.change_roler_foreman));
                    dialogLeftRightBtnConfirm.setLeftBtnText(getString(R.string.no_change_role));
                    dialogLeftRightBtnConfirm.setHtmlContent(Utils.getHtmlColor666666("你当前是")
                            + Utils.getHtmlColor000000("&nbsp;【班组长】") + Utils.getHtmlColor666666("<br/>如要确认记账，请切换成") + Utils.getHtmlColor000000("&nbsp;【工人】&nbsp;")
                            + Utils.getHtmlColor666666("身份。"));
                    dialogLeftRightBtnConfirm.show();
                    return;
                }
                RecordWorkConfirmActivity.actionStart(TurnOutForWorkActivity.this, null, null, null, null,
                        getIntent().getStringExtra(Constance.PID), getIntent().getStringExtra(Constance.GROUP_ID));
                break;
        }
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
                loadRecordConfirmStatus();
            }
        });
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) { //上拉加载回调
        loadRecordConfirmStatus();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) { //下拉加载回调
        loadRecordConfirmStatus();
    }

    /**
     * 获取记账对账开关状态
     */
    public void loadRecordConfirmStatus() {
        if (!isLoadRecordConfirmStatus) {
            AccountUtil.getRecordConfirmStatus(this, new CommonHttpRequest.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object object) {
                    isLoadRecordConfirmStatus = true;
                    AccountSwitchConfirm accountSwitchConfirm = (AccountSwitchConfirm) object;
                    recordConfirmStatus = accountSwitchConfirm.getStatus();
                    loadListData();
                }

                @Override
                public void onFailure(HttpException exception, String errormsg) {

                }
            });
        } else {
            loadListData();
        }
    }


    public void loadListData() {
        String httpUrl = NetWorkRequest.GROUPWORKDAYLIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID)); //项目组id
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        CommonHttpRequest.commonRequest(this, httpUrl, TurnOutForWork.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    TurnOutForWork turnOutForWork = (TurnOutForWork) object;
                    //如用户【关闭】了”我要对账“ 不显示这一句“你在该班组有 X笔 记工还没有确认[去确认]”
                    if (turnOutForWork.getNum() > 0 && recordConfirmStatus == 0) {
                        accountConfirmLayout.setVisibility(View.VISIBLE);
                        String html = "<font color='#000000'>你在该班组有</font><font color='#f18215'>&nbsp;" +
                                turnOutForWork.getNum() + "&nbsp;</font>" +
                                "<font color='#000000'>笔记工还没有确认</font>";
                        accountConfirmBtn.setText(Html.fromHtml(html));
                    } else {
                        accountConfirmLayout.setVisibility(View.GONE);
                    }
                    setAdapter(turnOutForWork.getList());
                    expandAll();
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                    pageListView.loadOnFailure();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    /**
     * 下载出勤公式记录
     */
    public void downLoad() {
        String httpUrl = NetWorkRequest.DOWNLOAD_WORKDAY_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("is_down", "1"); //下载标识
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID)); //项目组id
        CommonHttpRequest.commonRequest(this, httpUrl, Repository.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Repository repository = (Repository) object;
                //文件名称、文件下载路径、文件类型都不能为空
                if (!TextUtils.isEmpty(repository.getFile_name()) && !TextUtils.isEmpty(repository.getFile_type()) && !TextUtils.isEmpty(repository.getFile_path())) {
                    DownLoadExcelActivity.actionStart(TurnOutForWorkActivity.this, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 由于用的是二级菜单  直接展开所有的选项
     */
    private void expandAll() {
        int size = adapter.getList().size();
        for (int i = 0; i < size; i++) {
            pageListView.expandGroup(i);
        }
    }


    private void setAdapter(List<AccountDateList> list) {
        PageExpandableListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new TurnOutForWorkAdapter(this, list);
            pageListView.setEmptyView(findViewById(R.id.defaultLayout));
            pageListView.setListViewAdapter(adapter);
            pageListView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
                @Override
                public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                    return true;
                }
            });
            pageListView.setAdapter(adapter);
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateListView(list);//替换数据
            } else {
                adapter.addMoreList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getGroupCount() != 0) {
            adapter.notifyDataSetChanged();
        } else if (resultCode == Constance.REFRESH) { //待确认记工里面修改或者删除了记账信息这里需要刷新页面
            autoRefresh();
        } else if (resultCode == Constance.SWITCH_ROLER) { //切换角色
            setResult(resultCode);
            finish();
        }
    }
}
