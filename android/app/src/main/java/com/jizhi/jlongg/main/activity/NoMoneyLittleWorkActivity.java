package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.AccountAllEditActivty;
import com.jizhi.jlongg.account.AccountEditActivity;
import com.jizhi.jlongg.account.AccountWagesEditActivty;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.NoMoneyLittlerWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.dialog.BatchSetSalaryDialog;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
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

import static com.jizhi.jlongg.main.util.Constance.ACCOUNT_UPDATE;

/**
 * 功能:无金额点工
 * 作者：xuj
 * 时间:2018年1月8日17:05:40
 */
public class NoMoneyLittleWorkActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {

    /**
     * 无金额点工列表适配器
     */
    private NoMoneyLittlerWorkAdapter adapter;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 批量设置工资金额
     */
    private View multipartSetSalary;
    /**
     * 批量设置工资金额按钮
     */
    private Button multipartSetSalaryBtn;
    /**
     * 选择全部的按钮
     */
    private ImageView selecteAllIcon;
    /**
     * 全选本页文本
     */
    private TextView selecteAllText;
    /**
     * 已选数量
     */
    private int selecteCount;
    /**
     * true表示正在批量设置金额
     */
    private boolean isBatchSetSalary;
    /**
     * 导航栏右边标题
     */
    private TextView rightTitle;


    public static void actionStart(Activity activity) {
        Intent intent = new Intent(activity, NoMoneyLittleWorkActivity.class);
        activity.startActivityForResult(intent, Constance.REQUESTCODE_ALLWORKCOMPANT);
    }

    public static void actionStart(Activity activity, String uid) {
        Intent intent = new Intent(activity, NoMoneyLittleWorkActivity.class);
        intent.putExtra(Constance.UID, uid);
        activity.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.no_money_listview);
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
                loadListData();
            }
        });
    }


    private void initView() {
        setTextTitleAndRight(R.string.no_money_little_work, R.string.more);
        rightTitle = getTextView(R.id.right_title);
        selecteAllText = findViewById(R.id.selecte_all_text);
        selecteAllIcon = findViewById(R.id.selecte_all_icon);
        multipartSetSalaryBtn = findViewById(R.id.multipart_set_salary_btn);
        multipartSetSalary = findViewById(R.id.multipart_set_salary);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullRefreshCallBack(this);
        pageListView.setPullDownToRefreshView(mSwipeLayout); //设置下拉刷新组件
        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        View tips = getLayoutInflater().inflate(R.layout.no_money_little_work_head, null);
        pageListView.addHeaderView(tips, null, false);
    }

    /**
     * 查询无金额点工列表数据
     */
    public void loadListData() {
        String httpUrl = NetWorkRequest.NO_MONEY_LITTLE_WORK;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        String uid = getIntent().getStringExtra(Constance.UID);
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        params.addBodyParameter("pg", pageListView.getPageNum() + ""); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        CommonHttpRequest.commonRequest(this, httpUrl, PayRollList.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<PayRollList> list = (List<PayRollList>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    /**
     * 批量设置工资金额
     */
    public void batchSetSalary() {
        new BatchSetSalaryDialog(this, selecteCount, new BatchSetSalaryDialog.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {

            }

            @Override
            public void clickRightBtnCallBack(String money) {
                String httpUrl = NetWorkRequest.BATCH_SALARY_TPL;
                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                params.addBodyParameter("record_id", getBatchRecordIds()); //记账record_id,以逗号隔开
                params.addBodyParameter("salary", money); //工资模板
                CommonHttpRequest.commonRequest(NoMoneyLittleWorkActivity.this, httpUrl, BaseNetNewBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        CommonMethod.makeNoticeLong(getApplicationContext(), "工资金额设置成功！", CommonMethod.SUCCESS);
                        changeBatchStatus();
                        loadListData();
                        setResult(Constance.ACCOUNT_UPDATE);
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                    }
                });
            }
        }).show();
    }


    public void setAdapter(final List<PayRollList> list) {
        final PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new NoMoneyLittlerWorkAdapter(this, list);
            pageListView.setEmptyView(findViewById(R.id.defaultLayout));
            pageListView.setListViewAdapter(adapter);
            pageListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    if (isBatchSetSalary) {
                        PayRollList payRollList = adapter.getItem(position - pageListView.getHeaderViewsCount());
                        payRollList.setIs_selected(!payRollList.is_selected);
                        selecteCount = payRollList.is_selected ? selecteCount + 1 : selecteCount - 1;
                        boolean isSelectAll = selecteCount == adapter.getCount();
                        multipartSetSalaryBtn.setText(selecteCount == 0 ? "批量设置工资金额" : "批量设置工资金额(" + selecteCount + ")");
                        selecteAllIcon.setImageResource(isSelectAll ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                        selecteAllText.setText(isSelectAll ? "取消全选" : "全选本页");
                        adapter.notifyDataSetChanged();
                    } else {
                        handlerListItemClick(adapter.getItem(position - pageListView.getHeaderViewsCount()));
                    }
                }
            });
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                if (isBatchSetSalary && list != null && list.size() > 0) {
                    selecteAllText.setText("全选本页");
                    selecteAllIcon.setImageResource(R.drawable.checkbox_normal);
                }
                adapter.addMoreList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }


    /**
     * 处理ListView 子项点击事件
     *
     * @param bean
     */
    private void handlerListItemClick(final WorkDetail bean) {
        //获取记账类型  1表示点工  2.表示包工  3.表示借支  4.表示结算
        final String accountType = bean.getAccounts_type();
        if (TextUtils.isEmpty(accountType)) { //记账类型为空
            return;
        }
        if (accountType.equals(AccountUtil.SALARY_BALANCE)) {//结算
            AccountWagesEditActivty.actionStart(NoMoneyLittleWorkActivity.this, null, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()), false);
        } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {  //包工
            AccountAllEditActivty.actionStart(NoMoneyLittleWorkActivity.this, null, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()), false);
        } else {   //点工借支
            AccountEditActivity.actionStart(NoMoneyLittleWorkActivity.this, null, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()), false);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.ACCOUNT_UPDATE || resultCode == Constance.ACCOUNT_DELETE) {
            //只要回到当前页面就刷新数据
            setResult(ACCOUNT_UPDATE);
            loadListData();
        } else if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            adapter.notifyDataSetChanged();
        }
    }

    public List<SingleSelected> getCloseItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(false, true).setSelecteNumber("1"));
        list.add(new SingleSelected("批量设置工资金额", false, true, "2"));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.multipart_set_salary_btn: //批量设置工资金额
                if (selecteCount == 0) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请选择要设置工资金额的点工账", CommonMethod.ERROR);
                    return;
                }
                batchSetSalary();
                break;
            case R.id.selecte_all_layout://全选本页
                if (adapter != null && adapter.getCount() > 0) {
                    setSelectStatus(selecteCount == adapter.getCount() ? false : true);
                }
                break;
            case R.id.right_title: //右上角菜单：点工按“工天”显示 / 点工按“小时”显示
                if (isBatchSetSalary) {
                    changeBatchStatus();
                } else {
                    SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getCloseItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                        @Override
                        public void getSingleSelcted(SingleSelected bean) {
                            switch (bean.getSelecteNumber()) {
                                case "1": //切换记工显示方式
                                    AccountShowTypeActivity.actionStart(NoMoneyLittleWorkActivity.this);
                                    break;
                                case "2"://批量设置工资金额
                                    if (adapter != null && adapter.getCount() > 0) {
                                        setSelectStatus(false);
                                        changeBatchStatus();
                                    } else {
                                        CommonMethod.makeNoticeLong(getApplicationContext(), "没有点工可设置工资金额", CommonMethod.ERROR);
                                    }
                                    break;
                            }
                        }
                    });
                    popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                    popWindow.setAlpha(true);
                }
                break;
        }
    }

    /**
     * 设置选中状态
     *
     * @param isSelectAll true表示全选
     */
    private void setSelectStatus(boolean isSelectAll) {
        for (PayRollList payRollList : adapter.getList()) {
            payRollList.setIs_selected(isSelectAll);
        }
        selecteCount = isSelectAll ? adapter.getCount() : 0;
        multipartSetSalaryBtn.setText(isSelectAll ? "批量设置工资金额(" + selecteCount + ")" : "批量设置工资金额");
        selecteAllText.setText(isSelectAll ? "取消全选" : "全选本页");
        selecteAllIcon.setImageResource(isSelectAll ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        adapter.notifyDataSetChanged();
    }


    private void changeBatchStatus() {
        if (adapter != null) {
            isBatchSetSalary = !isBatchSetSalary;
            adapter.setEditor(isBatchSetSalary);
            adapter.notifyDataSetChanged();
            rightTitle.setText(isBatchSetSalary ? R.string.cancel : R.string.more);
            multipartSetSalary.setVisibility(isBatchSetSalary ? View.VISIBLE : View.GONE);
        }
    }


    /**
     * 获取批量设置的record_id
     *
     * @return
     */
    public String getBatchRecordIds() {
        if (adapter != null && adapter.getCount() > 0) {
            StringBuilder builder = new StringBuilder();
            int count = 0;
            for (PayRollList payRollList : adapter.getList()) {
                if (payRollList.is_selected) {
                    builder.append(count == 0 ? payRollList.getRecord_id() : "," + payRollList.getRecord_id());
                    count++;
                }
            }
            return builder.toString();
        }
        return null;
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
