package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.PayRollAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.PayRollPageOne;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.NestRadioGroup;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 功能: 工资清单首页数据
 * 作者：Xuj
 * 时间: 2017年4月20日14:49:23
 */
public class PayrollActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener, View.OnClickListener {


    /**
     * 按班组长
     */
    private RadioButton accordingRolerRadio;
    /**
     * 按项目
     */
    private RadioButton accordingPro;
    /**
     * 当前选中的状态   person 按个人  project:按项目  默认选择为个人
     */
    private String selecteState;
    /**
     * person 按个人
     */
    private String ACCORDING_FOREMAN = "person";
    /**
     * project:按项目
     */
    private String ACCORDING_PROJECT = "project";
    /**
     * 下拉刷新控件
     */
    private SwipeRefreshLayout mSwipeLayout;
    /**
     * 数据列表
     */
    private ListView listView;
    /**
     * 工资清单列表适配器
     */
    private PayRollAdapter adpater;
    /**
     * 分页编码
     */
    private int pageNum;
    /**
     * 是否还有更多数据
     */
    private boolean isMoreData = true;
    /**
     * 监听ListView 滑动的最后一项
     */
    private int lastItem;
    /**
     * listView 加载更多
     */
    private View footView;
    /**
     * 下载账单
     */
    private TextView downLoadBill;
    /**
     * 当前查询的角色    person 按个人  project:按项目
     */
    private TextView roleText;


    private boolean isLoadMoreData;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, PayrollActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.payroll);
        initView();
//        //未完善姓名
//        IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
//            @Override
//            public void onSuccess() {
//                autoRefresh();
//            }
//        });
    }

    /**
     * 切换状态 个人和项目状态
     */
    private void changeState() {
        downLoadBill.setVisibility(View.GONE); //隐藏下载账单
        if (selecteState.equals(ACCORDING_FOREMAN)) {
            roleText.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_WORKER) ? R.string.item_foreman_title : R.string.workers);
            accordingRolerRadio.setChecked(true);
            accordingRolerRadio.setTextColor(ContextCompat.getColor(this, R.color.white));
            accordingPro.setTextColor(ContextCompat.getColor(this, R.color.app_color));
        } else {
            roleText.setText(R.string.item_proname_title);
            accordingPro.setChecked(true);
            accordingRolerRadio.setTextColor(ContextCompat.getColor(this, R.color.app_color));
            accordingPro.setTextColor(ContextCompat.getColor(this, R.color.white));
        }
    }


    private void initView() {
        setTextTitleAndRight(R.string.payroll_list, R.string.downloadbill);

        accordingRolerRadio = (RadioButton) findViewById(R.id.accordingRoler);
        accordingPro = (RadioButton) findViewById(R.id.accordingPro);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipeLayout);
        roleText = getTextView(R.id.roleText);
        downLoadBill = getTextView(R.id.downLoadBill);
        listView = (ListView) findViewById(R.id.listView);
        listView.setEmptyView(findViewById(R.id.defaultLayout));
        getTextView(R.id.defaultDesc).setText("暂无记录");
        accordingRolerRadio.setText(UclientApplication.getRoler(this).equals(Constance.ROLETYPE_WORKER) ? R.string.selected_foreman : R.string.selected_worker);
        footView = loadMoreDataView();// listView 底部加载对话框
        footView.setVisibility(View.VISIBLE);
        mSwipeLayout.setOnRefreshListener(this); // 设置下拉刷新回调
        new SetColor(mSwipeLayout); // 设置下拉刷新滚动颜色
        listView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                if (adpater.getList().size() >= Constance.PAGE_SIZE30 && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE &&
                        isMoreData && lastItem == adpater.getList().size() - 1 && !isLoadMoreData) {
                    pageNum += 1;
                    isLoadMoreData = true;
                    if (listView.getFooterViewsCount() < 1) {
                        listView.addFooterView(footView);
                    }
                    getData();
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                lastItem = firstVisibleItem + visibleItemCount - 1;
            }
        });// listView 滚动事件监听
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                PayRollPageOne bean = adpater.getList().get(position);
                PayRollYearMonthListActivity.actionStart(PayrollActivity.this, bean.getTarget_id() + "", selecteState, bean.getName());
            }
        });
        NestRadioGroup radioBtnGroup = (NestRadioGroup) findViewById(R.id.radioBtnGroup);
        radioBtnGroup.setOnCheckedChangeListener(new NestRadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(NestRadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.accordingRoler: //按班组长
                        if (selecteState.equals(ACCORDING_FOREMAN)) { //按班组长
                            return;
                        }
                        selecteState = ACCORDING_FOREMAN;
                        changeState();
                        autoRefresh();
                        break;
                    case R.id.accordingPro: //按项目
                        if (selecteState.equals(ACCORDING_PROJECT)) { //按项目
                            return;
                        }
                        selecteState = ACCORDING_PROJECT;
                        changeState();
                        autoRefresh();
                        break;
                }
            }
        });
        selecteState = ACCORDING_FOREMAN;
        changeState();
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                if (adpater != null) { //为了保证数据不出错 先清空数据
                    adpater.updateList(null);
                }
                mSwipeLayout.setRefreshing(true);
                onRefresh();
            }
        });
    }


    @Override
    public void onRefresh() {
        pageNum = 1;
        getData();
    }

    /**
     * 列表参数
     *
     * @return
     */
    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(Constance.PAGE, String.valueOf(pageNum)); //页码
        params.addBodyParameter(Constance.PAGESIZE, String.valueOf(Constance.PAGE_SIZE30)); //页码
        params.addBodyParameter("class_type", selecteState); //person 按个人  project:按项目
        return params;
    }


    /**
     * 查询工资清单 列表数据
     */
    public void getData() {
        String URL = NetWorkRequest.PRYROLLLIST;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params(), new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                boolean isFail = false;
                try {
                    CommonListJson<PayRollPageOne> base = CommonListJson.fromJson(responseInfo.result, PayRollPageOne.class);
                    if (base.getState() != 0) {
                        List<PayRollPageOne> list = base.getValues();
                        if (list != null && list.size() > 0) {
                            isMoreData = list.size() <= Constance.PAGE_SIZE30; //是否还有更多的缓存数据
                        } else {
                            isMoreData = false;
                        }
                        setAdapter(list);
                    } else {
                        DataUtil.showErrOrMsg(PayrollActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(PayrollActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                    isFail = true;
                } finally {
                    cancelRefreshState(true);
                    if (isFail) {
                        pageNum -= 1;
                    }
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                printNetLog(errormsg, PayrollActivity.this);
                cancelRefreshState(false);
                closeDialog();
            }
        });
    }

    /**
     * 设置列表数据
     *
     * @param list
     */
    private void setAdapter(List<PayRollPageOne> list) {
        if (adpater == null) {
            adpater = new PayRollAdapter(getApplicationContext(), list);
            listView.setAdapter(adpater);
        } else {
            if (pageNum == 1) { //下拉刷新
                adpater.updateList(list); //替换数据
            } else {
                adpater.addMoreList(list); //添加数据
            }
        }
        downLoadBill.setVisibility(adpater.getList() != null && adpater.getCount() > 0 ? View.VISIBLE : View.GONE);
    }

    /**
     * 设置刷新状态
     *
     * @param loadDataIsSuccess 加载数据是否成功  true 表示成功   false表示失败
     */
    public void cancelRefreshState(boolean loadDataIsSuccess) {
        if (pageNum == 1) {
            mSwipeLayout.setRefreshing(false);//关闭下拉刷新
        } else {
            int count = listView.getFooterViewsCount();
            if (count > 0) {
                listView.removeFooterView(footView);
            }
        }
        if (!loadDataIsSuccess) {
            pageNum -= 1;
        }
        isLoadMoreData = false;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.downLoadBill: //下载账单
                if (adpater != null && adpater.getList() != null && adpater.getList().size() > 0) {
                    Intent intent = new Intent(this, X5WebViewActivity.class);
                    StringBuilder sb = new StringBuilder();
                    String role = UclientApplication.getRoler(this);
                    sb.append("role=" + role + "&");
                    sb.append("uid=" + UclientApplication.getUid(PayrollActivity.this) + "&");
                    sb.append("class_type=" + (selecteState.equals(ACCORDING_FOREMAN) ? "person" : "project"));
                    intent.putExtra("url", NetWorkRequest.BILL + "?" + sb.toString());
                    startActivity(intent);
                }
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST) {
            getData();
        }
    }
}
