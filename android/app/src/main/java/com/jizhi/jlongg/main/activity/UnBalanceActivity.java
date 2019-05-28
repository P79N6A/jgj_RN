package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.UnBalanceAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.UnBalance;
import com.jizhi.jlongg.main.bean.WorkBaseInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PageListView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;


/**
 * 功能:未结工资列表
 * 时间:2018年1月8日15:52:23
 * 作者:xuj
 */
public class UnBalanceActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {


    /**
     * 未结工资金额
     */
    private TextView unBalanceTotal;
    /**
     * 未结工资的笔数
     */
    private TextView unBalanceCount;
    /**
     * 查看未结工资的笔数
     */
    private Button searchUnBalanceCount;
    /**
     * 未结工资布局
     */
    private View unBalanceLayout;
    /**
     * 列表适配器
     */
    private UnBalanceAdapter adapter;
    /**
     * 未结工资文字的一些提醒
     */
    private TextView batchBalanceTips;
    /**
     * item标题
     */
    private View itemTitleLayout;
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
        Intent intent = new Intent(context, UnBalanceActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pagelistview);
        //未完善姓名,需要弹出完善姓名框
        IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                //完善姓名成功
                Utils.sendBroadCastToUpdateInfo(UnBalanceActivity.this);
                initView();
                autoRefresh();
            }
        });
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

    /**
     * 设置未结工资笔数，和未结工资金额
     *
     * @param count
     */
    private void setUnBalanceCountAndAmounts(int count, String amounts) {
        if (pageListView.getPageNum() == 1) {
            if (count > 0) {
                unBalanceLayout.setVisibility(View.VISIBLE);
                String role = UclientApplication.getRoler(getApplicationContext());
                if (role.equals(Constance.ROLETYPE_WORKER)) { //工头
                    String html = "<font color='#666666'>你还有</font><font color='#eb4e4e'> " + count +
                            "笔 </font><font color='#666666'>点工的工资模板中未设置金额</font>";
                    unBalanceCount.setText(Html.fromHtml(html));
                } else {
                    String html = "<font color='#666666'>你的工人还有</font><font color='#eb4e4e'> " + count +
                            "笔 </font><font color='#666666'>点工的工资模板中未设置金额</font>";
                    unBalanceCount.setText(Html.fromHtml(html));
                }
            } else {
                unBalanceLayout.setVisibility(View.GONE);
            }
            unBalanceTotal.setText(amounts);
        }
    }


    private void initView() {
        String role = UclientApplication.getRoler(getApplicationContext());
        setTextTitle(R.string.un_balance_money);
        final ListView listView = (ListView) findViewById(R.id.listView);
        View unBalanceHeadView = getLayoutInflater().inflate(R.layout.un_balance_head, null); // 加载对话框
        TextView roleText = (TextView) unBalanceHeadView.findViewById(R.id.roleText);
        TextView batchBalanceTips = (TextView) unBalanceHeadView.findViewById(R.id.batchBalanceTips);
        itemTitleLayout = unBalanceHeadView.findViewById(R.id.itemTitleLayout);
        unBalanceTotal = (TextView) unBalanceHeadView.findViewById(R.id.unBalanceTotal);
        unBalanceLayout = unBalanceHeadView.findViewById(R.id.unBalanceLayout);
        unBalanceCount = (TextView) unBalanceHeadView.findViewById(R.id.unBalanceCount);
        searchUnBalanceCount = (Button) unBalanceHeadView.findViewById(R.id.searchUnBalanceCount);
        roleText.setText(role.equals(Constance.ROLETYPE_FM) ? "工人(点击工人名字，可查看工人记工统计详情)" : "班组长(点击班组长名字，可查看班组长记工统计详情)");
        batchBalanceTips.setText(role.equals(Constance.ROLETYPE_FM) ? R.string.un_balance_worker_tips : R.string.un_balance_foreman_tips);
        searchUnBalanceCount.setOnClickListener(this);
        listView.addHeaderView(unBalanceHeadView, null, false);
        listView.setAdapter(null);
        this.batchBalanceTips = batchBalanceTips;

        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.searchUnBalanceCount: //查看未金额记工笔数
                NoMoneyLittleWorkActivity.actionStart(this);
                break;
        }
    }


    /**
     * 查询未结工资
     */
    public void loadListData() {
        String httpUrl = NetWorkRequest.UN_PAY_SALARY_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        CommonHttpRequest.commonRequest(this, httpUrl, UnBalance.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                UnBalance unBalance = (UnBalance) object;
                setUnBalanceCountAndAmounts(unBalance.getUn_salary_tpl(), unBalance.getTotal_amount());
                setAdapter(unBalance.getList());
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }


    public void setAdapter(List<WorkBaseInfo> list) {
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        batchBalanceTips.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        itemTitleLayout.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        if (adapter == null) {
            adapter = new UnBalanceAdapter(this, list);
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.ACCOUNT_UPDATE || resultCode == Constance.DISPOSEATTEND_RESULTCODE) {
            autoRefresh();
        }
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        loadListData();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        loadListData();
    }


}
