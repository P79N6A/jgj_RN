package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.widget.SwipeRefreshLayout;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.growingio.android.sdk.collection.GrowingIO;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.AccountAllEditActivty;
import com.jizhi.jlongg.account.AccountDetailActivity;
import com.jizhi.jlongg.account.AccountEditActivity;
import com.jizhi.jlongg.account.AccountWagesEditActivty;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.adpter.RemberWoreInfosAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountWorkRember;
import com.jizhi.jlongg.main.bean.AccountWorkRemberTop;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.bean.status.CommonNewJson;
import com.jizhi.jlongg.main.dialog.DiaLogBottomRed;
import com.jizhi.jlongg.main.dialog.DialogModifySalaryMode;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.dialog.DialogRemberWorkMore;
import com.jizhi.jlongg.main.dialog.RememberFlowGuideDialog;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RightSideslipLay;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:记工流水
 * 时间:2017/10/09 10:46
 * 作者:huchangsheng
 */
public class RememberWorkerInfosActivity extends BaseActivity implements RemberWoreInfosAdapter.RememberCheckBoxChangeListener, YearAndMonthClickListener, View.OnClickListener, SwipeRefreshLayout.OnRefreshListener, AbsListView.OnScrollListener {
    private RememberWorkerInfosActivity mActivity;

    /**
     * 列表适配器
     */
    private RemberWoreInfosAdapter remberWoreInfodapter;
    /* 取消*/
    @ViewInject(R.id.right_title)
    private TextView tv_cancel;
    /* 列表数据*/
    private List<AccountWorkRember> workday, hourWorkDay;
    /*是否删除数据 */
    private boolean isSelecteAll;
    /*年、月、日*/
    private String year, month, date;
    /* 是否删除了数据*/
    private boolean isDel;
    /*角色*/
    private String role;
    private ListView listView;
    /*日期*/
    private TextView tv_date;
    /* 筛选*/
    @ViewInject(R.id.rb_filter)
    private RadioButton rb_filter;
    /*顶部右侧文字*/
    private TextView right_title;
    /*顶部右侧按钮*/
    private TextView img_right;
    /*筛选的人id,以及筛选的项目id*/
    private String uid, pid;
    //    //顶部数据
    private AccountWorkRemberTop accountWorkRemberTop;
    //滑动抽屉
    private DrawerLayout drawer;
    //抽屉布局
    private RightSideslipLay menuHeaderView;
    private LinearLayout navigationView;
    //是否有备注
    private String is_note, filter_account_type, is_agency;
    private boolean isFilterDate;
    private AgencyGroupUser agencyGroupUser;
    /* 下拉刷新*/
    private SwipeRefreshLayout mSwipeLayout;
    private int pg = 0;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    /* 加载更多 */
    private View loadMoreView, headerView;
    private View layout_default;
    //选择状态  1.删除 2.批量修改模版
    private int selectStatus;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String year, String month) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String year, String month, String role) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.BEAN_STRING, role);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String year, String month, AgencyGroupUser agencyGroupUser) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.BEAN_CONSTANCE, agencyGroupUser);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * @param context
     * @param year     年
     * @param month    月份
     * @param proId    项目id
     * @param proName  项目名称
     * @param isFilter true表示从代班流水
     */
    public static void actionStart(Activity context, AgencyGroupUser agencyGroupUser, String year, String month, String date, String proId, String proName, boolean isFilter) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, agencyGroupUser);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.DATE, date);
        intent.putExtra(Constance.PRO_ID, proId);
        intent.putExtra(Constance.PRONAME, proName);
        intent.putExtra(Constance.BEAN_BOOLEAN, isFilter);
        context.startActivityForResult(intent, Constance.REQUEST);

    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param year        年
     * @param month       月
     * @param userId      编号
     * @param accountName 名字
     */
    public static void actionStart(Activity context, String year, String month, String userId, String accountName, boolean isStatistical) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.ID, userId);
        intent.putExtra(Constance.NICKNAME, accountName);
        intent.putExtra(Constance.BEAN_BOOLEAN, isStatistical);
        context.startActivityForResult(intent, Constance.REQUEST);
        LUtils.e(year + ",,," + month + ",,," + userId + ",," + accountName);
    }

    /**
     * @param context
     * @param year        年
     * @param month       月份
     * @param userId      记账人id
     * @param accountName 记账人名称
     * @param proId       项目id
     * @param proName     项目名称
     * @param isFilter    true表示从记工统计
     */
    public static void actionStart(Activity context, String year, String month, String userId, String accountName, String proId, String proName, boolean isFilter) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.ID, userId);
        intent.putExtra(Constance.NICKNAME, accountName);
        intent.putExtra(Constance.PRO_ID, proId);
        intent.putExtra(Constance.PRONAME, proName);
        intent.putExtra(Constance.BEAN_BOOLEAN1, isFilter);
        context.startActivityForResult(intent, Constance.REQUEST);
        LUtils.e(userId + ",,,," + accountName + ",,," + proId + ",,," + ",,," + proName);
    }

    /**
     * @param context
     * @param year            年
     * @param month           月份
     * @param userId          记账人id
     * @param accountName     记账人名称
     * @param proId           项目id
     * @param proName         项目名称
     * @param hideFilter      是否隐藏查看记工统计
     * @param hideRightLayout 是否隐藏筛选
     * @param unCickItem      item 是否禁止点击
     * @param is_sync         true 表示从同步给我的记工的数据 v3.4.2
     */
    public static void actionStart(Activity context, String year, String month, String userId, String accountName, String proId, String proName, String role, String accountIds,
                                   boolean hideFilter, boolean hideRightLayout, boolean unCickItem, boolean is_sync) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.ID, userId);
        intent.putExtra(Constance.NICKNAME, accountName);
        intent.putExtra(Constance.PRO_ID, proId);
        intent.putExtra(Constance.PRONAME, proName);
        intent.putExtra(Constance.BEAN_STRING, role);
        intent.putExtra("accountIds", accountIds);
        intent.putExtra(Constance.BEAN_BOOLEAN1, hideFilter);
        intent.putExtra("hideRightLayout", hideRightLayout);
        intent.putExtra("unClickItem", unCickItem);
        intent.putExtra("is_sync", is_sync);
        context.startActivityForResult(intent, Constance.REQUEST);
        LUtils.e(hideFilter + ",,,," + hideRightLayout + ",,," + unCickItem + ",,," + ",,," + accountIds);
        LUtils.e(year + ",,,," + month + ",,," + userId + ",,," + ",,," + accountName + "，，，，，" + proId + ",,," + proName);
    }


    /**
     * @param context
     * @param year        年
     * @param month       月份
     * @param userId      记账人id
     * @param accountName 记账人名称
     * @param proId       项目id
     * @param proName     项目名称
     * @param isFilter    true表示从记工统计
     */
    public static void actionStart(Activity context, String year, String month, String userId, String accountName, String proId, String proName, boolean isFilter, String accountIds) {
        Intent intent = new Intent(context, RememberWorkerInfosActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.ID, userId);
        intent.putExtra(Constance.NICKNAME, accountName);
        intent.putExtra(Constance.PRO_ID, proId);
        intent.putExtra(Constance.PRONAME, proName);
        intent.putExtra(Constance.BEAN_BOOLEAN1, isFilter);
        intent.putExtra("accountIds", accountIds);
        context.startActivityForResult(intent, Constance.REQUEST);
        LUtils.e(userId + ",,,," + accountName + ",,," + proId + ",,," + ",,," + proName);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_remeber_worker_info);
        ViewUtils.inject(this);
        getData();
        initView();
        autoRefresh();
        if (!TextUtils.isEmpty(year)) {
            //未完善姓名
            IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
                @Override
                public void onSuccess() {
                    //完善姓名成功
                    Utils.sendBroadCastToUpdateInfo(mActivity);
                    loadAccountFlowGuide();
                }
            });
        } else {
            finish();
        }
    }

    /**
     * 加载记工流水动画
     */
    private void loadAccountFlowGuide() {
        String key = "show_flow_guide_remember_info" + AppUtils.getVersionName(getApplicationContext());
        // 是否显示记工流水动画
        boolean isShow = (boolean) SPUtils.get(getApplicationContext(), key, false, Constance.JLONGG);
        if (!isShow) {
            mSwipeLayout.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕 设置背景图片的高度和宽度
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                    if (mSwipeLayout.getHeight() == 0) {
                        return;
                    }
                    final int[] location = new int[2];
                    findViewById(R.id.rb_filter).getLocationOnScreen(location);
                    int marginTop = location[1] - DensityUtils.getStatusHeight(getApplicationContext());
                    RememberFlowGuideDialog dialog = new RememberFlowGuideDialog(mActivity, marginTop);
                    dialog.show();
                    if (Build.VERSION.SDK_INT < 16) {
                        mSwipeLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        mSwipeLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
            SPUtils.put(getApplicationContext(), key, true, Constance.JLONGG); // 存放Token信息
        }
    }

    public void getData() {
        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                if (!TextUtils.isEmpty(key) && key.equals("year")) {
                    year = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("month")) {
                    month = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("role")) {
                    role = bun.getString(key);
                }
            }
        }
        filter_account_type = getIntent().getStringExtra("accountIds");
        if (TextUtils.isEmpty(role) && TextUtils.isEmpty(getIntent().getStringExtra(Constance.BEAN_STRING))) {
            role = UclientApplication.getRoler(RememberWorkerInfosActivity.this);
            year = getIntent().getStringExtra("year");
            month = getIntent().getStringExtra("month");
            date = getIntent().getStringExtra(Constance.DATE);
            agencyGroupUser = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (null != agencyGroupUser) {
                role = Constance.ROLETYPE_FM;
            }
            LUtils.e("--------roleAAAA--------" + role);
        } else {
            role = getIntent().getStringExtra(Constance.BEAN_STRING);
            year = getIntent().getStringExtra("year");
            month = getIntent().getStringExtra("month");
            date = getIntent().getStringExtra(Constance.DATE);
            agencyGroupUser = (AgencyGroupUser) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        }
    }

    private void initView() {
        mActivity = RememberWorkerInfosActivity.this;
        setTextTitle(R.string.remberworkinfotitle);
        tv_date = findViewById(R.id.tv_date);
        tv_date.setOnClickListener(this);
        listView = findViewById(R.id.listView);
        right_title = findViewById(R.id.right_title);
        right_title.setVisibility(View.GONE);
        listView.setOnScrollListener(this);
        loadMoreView = loadMoreDataView();
        headerView = getLayoutInflater().inflate(R.layout.layout_head_remember_workinfo_new, null);
        ((TextView) headerView.findViewById(R.id.tv_top)).setText("本月暂无记工数据");
        layout_default = headerView.findViewById(R.id.layout_nodata);
        findViewById(R.id.rea_select_all_mode).setOnClickListener(this);
        findViewById(R.id.btn_set_mode).setOnClickListener(this);
        //如果是记工统计跳转过来的
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN1, false)) {
            headerView.findViewById(R.id.rb_statistics).setVisibility(View.GONE);
        }


        img_right = findViewById(R.id.img_right);
        mSwipeLayout = findViewById(R.id.swipe_layout);
        mSwipeLayout.setOnRefreshListener(this);
        mSwipeLayout.setEnabled(false);
        // listView 底部加载对话框
        new SetColor(mSwipeLayout);
        headerView.findViewById(R.id.rb_statistics).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                StatisticalWorkFirstActivity.actionStart(mActivity, year + "-" + month + "-01",
                        year + "-" + month + "-" + DatePickerUtil.getLastDay(Integer.parseInt(year), Integer.parseInt(month)));
            }
        });
        setDateText();
        tv_cancel.setText("取消");
        setGoneArrow();
        tv_cancel.setVisibility(View.GONE);
        initPidAndUid();
        //抽屉部分
        drawer = findViewById(R.id.main);
        drawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED, Gravity.RIGHT);
//        setDraerLayoutWidth();
        navigationView = findViewById(R.id.nav_view);
        menuHeaderView = new RightSideslipLay(mActivity, uid, pid, role, filter_account_type, (null != agencyGroupUser ? agencyGroupUser.getGroup_id() : ""), year, month, new RightSideslipLay.FilterSelectInterFace() {
            @Override
            public void FilterSelectClick(String type, String uids, String pids) {
                isFilterDate = true;
                //筛选数据
                if (uids != null) {
                    uid = uids;
                }
                if (pids != null) {
                    pid = pids.equals("0") ? "" : pids;
                }
            }

            @Override
            public void FilterClick(String filter_account_types, String is_notes, String is_agencys, String years, String months) {
                //确定
                isFilterDate = true;
                is_note = is_notes;
                is_agency = is_agencys;
                year = years;
                month = months;
                filter_account_type = filter_account_types;
                drawer.closeDrawers();

            }

            @Override
            public void FilterChange() {
                isFilterDate = true;
            }

            @Override
            public void FilterReset() {
                isFilterDate = true;
                //重置数据
                resetFilter();
            }

            @Override
            public void FilterDate() {
                isFilterDate = true;
            }

            @Override
            public void colose() {
                drawer.closeDrawers();
            }
        });
        navigationView.addView(menuHeaderView);
        drawer.addDrawerListener(mSimpleDrawerListener);
        //记工统计跳转过来人筛选
        if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.NICKNAME))) {
            menuHeaderView.setUserName(getIntent().getStringExtra(Constance.NICKNAME));

        }
        //记工统计跳转过来项目筛选
        if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.PRONAME))) {
            menuHeaderView.setProName(getIntent().getStringExtra(Constance.PRONAME));
        }

        //是否隐藏筛选
        if (getIntent().getBooleanExtra("hideRightLayout", false)) {
            findViewById(R.id.rb_filter).setVisibility(View.GONE);
            //禁止手势滑动
            drawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
        }
    }

    /**
     * 重置筛选条件
     */
    public void resetFilter() {
        initPidAndUid();
        is_note = "";
        is_agency = "";
        filter_account_type = "";
        uid = "";
        if (!getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
            pid = "";
        }
        getData();
        setDateText();
        if (null != menuHeaderView) {
            menuHeaderView.setDate(year, month);
        }
    }

    /**
     * 初始化id
     */
    public void initPidAndUid() {

        //如果是记工统计跳转过来的
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN1, false)) {
            //记工统计跳转过来人筛选
            if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.NICKNAME))) {
                uid = getIntent().getStringExtra(Constance.ID);

            }
            //记工统计跳转过来项目筛选
            if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.PRONAME))) {
                pid = getIntent().getStringExtra(Constance.PRO_ID);
            }
        } else if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
            //如果是记工记工变更
            //记工统计跳转过来项目筛选
            if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.PRONAME))) {
                pid = getIntent().getStringExtra(Constance.PRO_ID);
            }
        } else {
            uid = "";
        }
    }

    private DrawerLayout.SimpleDrawerListener mSimpleDrawerListener = new DrawerLayout.SimpleDrawerListener() {
        @Override
        public void onDrawerOpened(View drawerView) {
            //档DrawerLayout打开时，让整体DrawerLayout布局可以响应点击事件
            drawerView.setClickable(true);
            isFilterDate = false;
        }

        @Override
        public void onDrawerClosed(View drawerView) {
            super.onDrawerClosed(drawerView);
            GoneBottom();
            filter_account_type = menuHeaderView.getAccount_type();
//            if(!menuHeaderView.getYear().equals(year)||!menuHeaderView.getMonth().equals(month)){
//                isFilterDate=true;
//            }
            year = menuHeaderView.getYear();
            month = menuHeaderView.getMonth();
            setDateText();
            setGoneArrow();
            if (isFilterDate) {
                if (null != workday) {
                    workday.clear();
                }
                autoRefresh();
            } else {
                if (TextUtils.isEmpty(menuHeaderView.getAccount_type()) && TextUtils.isEmpty(uid) && TextUtils.isEmpty(pid) && TextUtils.isEmpty(is_note) && TextUtils.isEmpty(is_agency) && TextUtils.isEmpty(filter_account_type)) {
                    rb_filter.setChecked(false);
                } else {
                    rb_filter.setChecked(true);
                }
            }

        }
    };

    @Override
    protected void onDestroy() {
        super.onDestroy();
        drawer.removeDrawerListener(mSimpleDrawerListener);
    }

    /**
     * 设置标题
     */
    public void setDateText() {

        tv_date.setText(year + "年" + month + "月");
    }


    private WheelViewSelectYearAndMonth selecteYearMonthPopWindow;


    /**
     * 右上角文字
     */
    @OnClick(R.id.right_title)
    public void right_title(View view) {
        GoneBottom();
        rb_filter.setVisibility(View.VISIBLE);
        if (workday.size() != remberWoreInfodapter.getWorkday().size()) {
            remberWoreInfodapter.setWorkday(workday);
            if (listView.getFooterViewsCount() == 1 && remberWoreInfodapter.getWorkday().size() == 0) {
                layout_default.setVisibility(View.VISIBLE);
                if (rb_filter.isChecked()) {
                    ((TextView) headerView.findViewById(R.id.tv_top)).setText("本页暂无记工数据");
                } else {
                    ((TextView) headerView.findViewById(R.id.tv_top)).setText("本月暂无记工数据");
                }
            } else {
                layout_default.setVisibility(View.GONE);
            }
        } else {

        }
        setHeadValue(accountWorkRemberTop);
    }

    /**
     * 隐藏底部按钮还原初始化状态
     */
    public void GoneBottom() {
        isHaveMoreData = true;
        rb_filter.setVisibility(View.VISIBLE);
        tv_cancel.setVisibility(View.GONE);
        findViewById(R.id.rea_mode_bottom).setVisibility(View.GONE);
        ((TextView) findViewById(R.id.tv_select_mode)).setText("全选本页");
        ((TextView) findViewById(R.id.btn_set_mode)).setText(getString(R.string.set_hour_mode));
        ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_normal);
        img_right.setVisibility(View.VISIBLE);
        if (remberWoreInfodapter.getWorkday() != null) {
            LUtils.e("-------GoneBottom----111-----");
            int size = remberWoreInfodapter.getWorkday().size();
            for (int i = 0; i < size; i++) {
                remberWoreInfodapter.getWorkday().get(i).setShowCb(false);
                remberWoreInfodapter.getWorkday().get(i).setSelected(false);
                remberWoreInfodapter.getWorkday().get(i).setShowAnim(false);
            }
        }
        if (null != workday && workday.size() > 0) {

            for (int i = 0; i < workday.size(); i++) {
                LUtils.e("-------GoneBottom----222-----");
                workday.get(i).setShowCb(false);
                workday.get(i).setSelected(false);
                workday.get(i).setShowAnim(false);
            }
        }
        if (null != remberWoreInfodapter) {
            remberWoreInfodapter.notifyDataSetChanged();
        }
    }


    DialogRemberWorkMore dialogRemberWorkMore;

    public void openMenu() {
        drawer.openDrawer(GravityCompat.END);
    }

    /**
     * 右上角三个点
     */
    @OnClick(R.id.img_right)
    public void img_right(View view) {
        selectStatus = 0;
        SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getFileterValue(), new SingleSelectedPopWindow.SingleSelectedListener() {
            @Override
            public void getSingleSelcted(SingleSelected bean) {
                switch (bean.getSelecteNumber()) {
                    case "1": //切换记工显示方式
                        AccountShowTypeActivity.actionStart(mActivity);
                        break;
                    case "2": //下载
                        if (null == remberWoreInfodapter.getWorkday() || remberWoreInfodapter.getWorkday().size() == 0) {
                            CommonMethod.makeNoticeShort(mActivity, "没有可下载的内容", CommonMethod.ERROR);
                            return;
                        }
                        getDownUrl();
                        break;
                    case "3": //批量删除
                        if (null == remberWoreInfodapter.getWorkday() || remberWoreInfodapter.getWorkday().size() == 0) {
                            CommonMethod.makeNoticeShort(mActivity, "没有可删除的数据", CommonMethod.ERROR);
                            return;
                        }
                        selectStatus = 1;
                        initCancelState();
                        break;
                    case "5": //批量修改点工工资标准
                        selectStatus = 2;
                        rb_filter.setVisibility(View.GONE);
                        isFulsh = true;
                        isHaveMoreData = true;
                        pg = 1;
                        initCancelState();
                        getHourData();
                        break;
                    case "4": //取消
                        break;
                }
            }
        });
        popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    public List<SingleSelected> getFileterValue() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(false, true).setSelecteNumber("1"));
        list.add(new SingleSelected("下载记工考勤表", getString(R.string.hint_wps), false, false, "2", Color.parseColor("#000000"), 18));
        list.add(new SingleSelected("批量修改点工工资标准", "", false, false, "5", Color.parseColor("#000000"), 18));
        list.add(new SingleSelected("批量删除", false, true, "3", Color.parseColor("#000000"), 18));
        list.add(new SingleSelected("取消", false, false, "4", Color.parseColor("#999999"), 18));
        return list;
    }

    /**
     * 筛选
     */
    @OnClick(R.id.rb_filter)
    public void rb_filter(View view) {
        openMenu();
    }

    /**
     * 马上记一笔
     */
    @OnClick(R.id.btn_next)
    public void btn_next(View view) {
        Intent intent = new Intent(mActivity, NewAccountActivity.class);
        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(this));
        Calendar c = Calendar.getInstance();
        int date = c.get(Calendar.DATE);
        String dates = date < 10 ? "0" + date : date + "";
        intent.putExtra("date", year + "" + month + "" + dates);
        startActivityForResult(intent, Constance.CONST_REQUESTCODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.ACCOUNT_UPDATE) {
            isDel = true;
            autoRefresh();
            return;
        }
        if (requestCode == 32 && resultCode == 33) {//
            autoRefresh();
        } else if (requestCode == Constance.CONST_REQUESTCODE && resultCode == Constance.DISPOSEATTEND_RESULTCODE) {
            autoRefresh();
        } else if (requestCode == 53 && resultCode == 52) {
            autoRefresh();
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.ACCOUNT_RESULTCODE) {
            autoRefresh();
        } else if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE) {
            if (null != remberWoreInfodapter) {
                remberWoreInfodapter.notifyDataSetChanged();
            }
            setHeadValue(accountWorkRemberTop);
        }
    }


    /**
     * 全选
     */
    public void selectAll() {
        tv_cancel.setVisibility(View.VISIBLE);
        int length = 0;
        for (int i = 0; i < remberWoreInfodapter.getWorkday().size(); i++) {
            if (isSelecteAll) {
                //已经全选了就把全选的取消了
                remberWoreInfodapter.getWorkday().get(i).setSelected(false);
            } else {
                //没有全选的话就全选上
                remberWoreInfodapter.getWorkday().get(i).setSelected(true);
                length += 1;
            }
        }
        if (length == 0) {
            ((TextView) findViewById(R.id.tv_select_mode)).setText("全选本页");
            ((TextView) findViewById(R.id.btn_set_mode)).setText(getRightBottomText());
            ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_normal);

            isSelecteAll = false;
        } else {
            ((TextView) findViewById(R.id.btn_set_mode)).setText(getRightBottomText() + "(" + length + ")")
            ;
            if (!isSelecteAll) {
                ((TextView) findViewById(R.id.tv_select_mode)).setText("取消全选");
                ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_pressed);
                isSelecteAll = true;
            } else {
                ((TextView) findViewById(R.id.tv_select_mode)).setText("全选本页");
                ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_normal);

                isSelecteAll = false;
            }
        }
        remberWoreInfodapter.notifyDataSetChanged();


    }

    /**
     * 底部删除按钮文字
     *
     * @return
     */
    public String getRightBottomText() {
        return selectStatus == 1 ? "批量删除" : "批量修改点工工资标准";
    }

    String deleteId, accountType;

    @Override
    public void itemLongClicListener(final int position) {
        deleteId = workday.get(position).getId() + "";
        accountType = workday.get(position).getAccounts_type() + "";


    }

    //    给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case 1: //修改界面
                if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
                    role = Constance.ROLETYPE_FM;
                }
                if (accountType.equals(AccountUtil.SALARY_BALANCE)) {
                    //结算
                    AccountWagesEditActivty.actionStart(mActivity, null, accountType, Integer.parseInt(deleteId), role, false, agencyGroupUser);
                } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {
                    //包工
                    AccountAllEditActivty.actionStart(mActivity, null, accountType, Integer.parseInt(deleteId), role, false, agencyGroupUser);
                } else {
                    //包工点工借支
                    AccountEditActivity.actionStart(mActivity, null, accountType, Integer.parseInt(deleteId), role, false, agencyGroupUser);
                }
                break;
            case 2: //删除记账

                DialogOnlyTitle dialogOnlyTitle = new DialogOnlyTitle(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        if (!TextUtils.isEmpty(deleteId)) {
                            delsetmount(deleteId);
                        }
                    }
                }, -1, getString(R.string.delete_account_tips));
                dialogOnlyTitle.setConfirmBtnName(getString(R.string.confirm_delete));
                dialogOnlyTitle.show();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    /**
     * 设置右上角按钮的状态
     */
    public void initCancelState() {
        if (workday != null) {
            tv_cancel.setVisibility(View.VISIBLE);
            img_right.setVisibility(View.GONE);
            for (int i = 0; i < remberWoreInfodapter.getWorkday().size(); i++) {
                remberWoreInfodapter.getWorkday().get(i).setShowCb(true);
                remberWoreInfodapter.getWorkday().get(i).setSelected(false);
                remberWoreInfodapter.getWorkday().get(i).setShowAnim(false);
            }
            findViewById(R.id.rea_mode_bottom).setVisibility(View.VISIBLE);
            ((TextView) findViewById(R.id.tv_select_mode)).setText(getString(R.string.select_all_page));
            ((TextView) findViewById(R.id.btn_set_mode)).setText(getRightBottomText());
            ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_normal);
        }
        if (remberWoreInfodapter != null) {
            remberWoreInfodapter.notifyDataSetChanged();
        }
    }

    private RequestParams getParams() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        if (!TextUtils.isEmpty(date)) {
            params.addBodyParameter("date", year + "-" + month + "-" + date);
            params.addBodyParameter("is_change_date", "1");
        } else {
            params.addBodyParameter("date", year + "-" + month);
        }
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        if (!TextUtils.isEmpty(pid)) {
            params.addBodyParameter("pid", pid);
        }
        if (null != menuHeaderView && !TextUtils.isEmpty(menuHeaderView.getIsRemark())) {
            params.addBodyParameter("is_note", menuHeaderView.getIsRemark());
        }
        if (null != menuHeaderView && !TextUtils.isEmpty(menuHeaderView.getIsAgency())) {
            params.addBodyParameter("is_agency", menuHeaderView.getIsAgency());
        }
        if (!TextUtils.isEmpty(filter_account_type)) {
            params.addBodyParameter("accounts_type", filter_account_type);
        }
        if (null != agencyGroupUser) {
            params.addBodyParameter("group_id", agencyGroupUser.getGroup_id());
        }
        if (getIntent().getBooleanExtra("is_sync", false)) {
            params.addBodyParameter("is_sync", "1");

        }
        LUtils.e(uid + ",,," + pid + ",," + is_note + ",,," + filter_account_type);
        return params;
    }

    /**
     * 获取记功流水首页数据
     */
    public void getData(final String date) {
        RequestParams params = getParams();
        params.addBodyParameter("pagesize", String.valueOf(Constance.PAGE_SIZE));
        params.addBodyParameter("pg", String.valueOf(pg));
        if (TextUtils.isEmpty(menuHeaderView.getAccount_type()) && TextUtils.isEmpty(uid) && TextUtils.isEmpty(pid) && TextUtils.isEmpty(menuHeaderView.getIsRemark()) && TextUtils.isEmpty(menuHeaderView.getIsAgency())) {
            rb_filter.setChecked(false);
        } else {
            rb_filter.setChecked(true);
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_WORK_RECORD_FLOW, params,
                new RequestCallBack<String>() {
                    @SuppressWarnings("deprecation")
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonNewJson baseJson = CommonNewJson.fromJson(responseInfo.result, AccountWorkRemberTop.class);
                            String msg = baseJson.getMsg();
                            if (!TextUtils.isEmpty(msg) && msg.equals(Constance.SUCCES_S)) {
                                isSelecteAll = false;
                                if (pg == 1) {
                                    accountWorkRemberTop = (AccountWorkRemberTop) baseJson.getResult();
                                    setHeadValue(accountWorkRemberTop);
                                }
                                setVaues(((AccountWorkRemberTop) baseJson.getResult()).getList());
                            } else {
                                DataUtil.showErrOrMsg(mActivity, baseJson.getCode() + "", baseJson.getMsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                        }
                    }

                    @Override
                    public void onFailure(HttpException error, String msg) {
                        printNetLog(msg, mActivity);
                        closeDialog();
                        tv_cancel.setVisibility(View.GONE);
//                            defaultLayout.setVisibility(View.VISIBLE);
                    }
                });
    }


    /**
     * 获取下载地址
     */
    public void getDownUrl() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        if (!TextUtils.isEmpty(date)) {
            params.addBodyParameter("date", year + "-" + month + "-" + date);
            params.addBodyParameter("is_change_date", "1");
        } else {
            params.addBodyParameter("date", year + "-" + month);
        }
        params.addBodyParameter("is_down", "1");
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        if (!TextUtils.isEmpty(pid)) {
            params.addBodyParameter("pid", pid);
        }
        if (!TextUtils.isEmpty(filter_account_type)) {
            params.addBodyParameter("accounts_type", filter_account_type);
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_WORK_RECORD_FLOW, params,
                new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        CommonNewJson<Repository> base = CommonNewJson.fromJson(responseInfo.result, Repository.class);
                        if (!TextUtils.isEmpty(base.getMsg()) && base.getMsg().equals(Constance.SUCCES_S)) {
                            Repository repository = base.getResult();
                            //文件名称、文件下载路径、文件类型都不能为空
                            if (!TextUtils.isEmpty(repository.getFile_name()) && !TextUtils.isEmpty(repository.getFile_type()) && !TextUtils.isEmpty(repository.getFile_path())) {
//                                AccountUtils.downLoadAccount(mActivity, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                                DownLoadExcelActivity.actionStart(mActivity, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                            }
                        } else {
                            DataUtil.showErrOrMsg(mActivity, base.getCode() + "", base.getMsg());
                        }
                        closeDialog();
                    }

                    @Override
                    public void onFailure(HttpException error, String msg) {
                        mSwipeLayout.setRefreshing(false);
                        printNetLog(msg, mActivity);
                        closeDialog();
                    }
                });
    }

    public void setVaues(List<AccountWorkRember> accountWorkRember) {
        if (null == workday) {
            workday = new ArrayList<>();
        }
        if (isFulsh) {
            workday = accountWorkRember;
            remberWoreInfodapter = new RemberWoreInfosAdapter(mActivity, workday, role, this);
            if (listView.getHeaderViewsCount() == 0) {
                listView.addHeaderView(headerView);
            }
            if (listView.getFooterViewsCount() == 0) {
                listView.addFooterView(loadMoreView);
            }
            remberWoreInfodapter.setUnClickItem(getIntent().getBooleanExtra("unClickItem", false));
            listView.setAdapter(remberWoreInfodapter);
            loadMoreView.setVisibility(View.GONE);
            listView.setSelection(0);
            mSwipeLayout.setRefreshing(false);
        } else {
            isHaveMoreData = accountWorkRember.size() >= 1 ? true : false;
            loadMoreView.setVisibility(View.GONE);
            int seletionPositon = accountWorkRember.size() > 0 ? (remberWoreInfodapter.getWorkday().size() + 1) : remberWoreInfodapter.getWorkday().size();
            try {
                if (workday.size() > 0 && workday.get(0).isShowCb()) {
                    for (int i = 0; i < accountWorkRember.size(); i++) {
                        accountWorkRember.get(i).setShowCb(true);
                    }
                }
            } catch (Exception e) {
            }

            workday.addAll(accountWorkRember);
            remberWoreInfodapter.notifyDataSetChanged();
            listView.setSelection(seletionPositon);
            if (findViewById(R.id.rea_mode_bottom).getVisibility() == View.VISIBLE) {
                getSelectLength(0);
                LUtils.e("---------计算长度-------");
            } else {
                LUtils.e("------不---计算长度-------");

            }
        }
        if (listView.getFooterViewsCount() == 1 && remberWoreInfodapter.getWorkday().size() == 0) {
            layout_default.setVisibility(View.VISIBLE);
            if (rb_filter.isChecked()) {
                ((TextView) headerView.findViewById(R.id.tv_top)).setText("本页暂无记工数据");
            } else {
                ((TextView) headerView.findViewById(R.id.tv_top)).setText("本月暂无记工数据");
            }
        } else {
            layout_default.setVisibility(View.GONE);
        }
//        Utils.setListViewHeightBasedOnChildren(listView);
    }

    public void setHeadValue(AccountWorkRemberTop accountWorkRemberTop) {
        if (null == accountWorkRemberTop) {
            LUtils.e("----setHeadValue--------22----------");
            return;
        }
        //点工金额
        ((TextView) headerView.findViewById(R.id.tv_hour_money)).setText(accountWorkRemberTop.getWork_type().getAmounts());
        //工人只有承包
        if (role.equals(Constance.ROLETYPE_FM)) {
            headerView.findViewById(R.id.rea_sub).setVisibility(View.VISIBLE);
            ((TextView) headerView.findViewById(R.id.tv_account_type)).setText("包工(分包):");
            //包工承包
            ((TextView) headerView.findViewById(R.id.tv_all_work_money)).setText(accountWorkRemberTop.getContract_type_one().getAmounts());
            //分包金额
            ((TextView) headerView.findViewById(R.id.tv_subcontract_work_money)).setText(accountWorkRemberTop.getContract_type_two().getAmounts());
        } else {
            headerView.findViewById(R.id.rea_sub).setVisibility(View.GONE);
            ((TextView) headerView.findViewById(R.id.tv_account_type)).setText("包工(承包):");
            //包工分包
            ((TextView) headerView.findViewById(R.id.tv_subcontract_work_money)).setText(accountWorkRemberTop.getContract_type_one().getAmounts());
        }

        if (null != accountWorkRemberTop.getContract_type_two()) {

        }
        //借支金额
        ((TextView) headerView.findViewById(R.id.tv_borrowing_money)).setText(accountWorkRemberTop.getExpend_type().getAmounts());
        //结算金额
        ((TextView) headerView.findViewById(R.id.tv_wage_money)).setText(accountWorkRemberTop.getBalance_type().getAmounts());

        //借支笔数
        ((TextView) headerView.findViewById(R.id.tv_borrowing_count)).setText(Html.fromHtml("借支：<font color='#83c76e'>" + (int) accountWorkRemberTop.getExpend_type().getTotal() + "</font>笔"));
        //结算笔数
        ((TextView) headerView.findViewById(R.id.tv_wage_count)).setText(Html.fromHtml("结算：<font color='#83c76e'>" + (int) accountWorkRemberTop.getBalance_type().getTotal() + "</font>笔"));

        String hourWorkManhourString = "上班：" + AccountUtil.getAccountShowTypeString(mActivity, false, true, true, (accountWorkRemberTop.getWork_type().getManhour() + accountWorkRemberTop.getAttendance_type().getManhour()),
                RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getWorking_hours(), accountWorkRemberTop.getAttendance_type().getWorking_hours())));
        String hourWorkOverTimeString = "加班：" + AccountUtil.getAccountShowTypeString(mActivity, false, true, false, (accountWorkRemberTop.getWork_type().getOvertime() + accountWorkRemberTop.getAttendance_type().getOvertime()),
                RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getOvertime_hours(), accountWorkRemberTop.getAttendance_type().getOvertime_hours())));

        //上班时间
        String hourWorkManhourValue = null;
        //加班时间
        String hourWorkOverTimeValue = null;
        switch (AccountUtil.getDefaultAccountUnit(mActivity)) {
            case AccountUtil.WORK_AS_UNIT: //以工为单位
                //点工
                hourWorkManhourValue = RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getWorking_hours(), accountWorkRemberTop.getAttendance_type().getWorking_hours()));
                hourWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getOvertime_hours(), accountWorkRemberTop.getAttendance_type().getOvertime_hours()));
                break;
            case AccountUtil.MANHOUR_AS_UNIT_OVERTIME_AS_HOUR: //上班为小时，加班显示为空
                //点工
                hourWorkManhourValue = RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getWorking_hours(), accountWorkRemberTop.getAttendance_type().getWorking_hours()));
                hourWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getOvertime()+"" ,accountWorkRemberTop.getAttendance_type().getOvertime()+""));
                break;
            case AccountUtil.WORK_OF_HOUR:
                //点工
                hourWorkManhourValue = RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getManhour()+"" , accountWorkRemberTop.getAttendance_type().getManhour()+""));
                hourWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(getHour(accountWorkRemberTop.getWork_type().getOvertime()+"", accountWorkRemberTop.getAttendance_type().getOvertime()+""));
                break;
        }
        //点工
        ((TextView) headerView.findViewById(R.id.tv_hour_main_hour)).setText(setMoneyViewAttritube(hourWorkManhourString, hourWorkManhourValue, Color.parseColor("#eb4e4e"))); //设置点工上班时长
        ((TextView) headerView.findViewById(R.id.tv_hour_work_hour)).setText(setMoneyViewAttritube(hourWorkOverTimeString, hourWorkOverTimeValue, Color.parseColor("#eb4e4e"))); //设置上班时长
        LUtils.e("----setHeadValue--------33----------");

    }

    /**
     * @param working_hour1
     */
    public float getHour(String working_hour1, String working_hour2) {
        float hour1 = TextUtils.isEmpty(working_hour1) ? 0 : Float.parseFloat(working_hour1);
        float hour2 = TextUtils.isEmpty(working_hour2) ? 0 : Float.parseFloat(working_hour2);
        if (TextUtils.isEmpty(working_hour1)) {
            hour1 = 0;
        }
        if (TextUtils.isEmpty(working_hour2)) {
            hour2 = 0;
        }
        if (hour1 == 0 && hour2 == 0) {
            return 0;
        }
        return Float.parseFloat(Utils.m2(hour1 + hour2));
    }

    private SpannableStringBuilder setMoneyViewAttritube(String completeString, String changeString, int textColor) {
        LUtils.e(completeString+"------------setMoneyViewAttritube--------"+changeString);
        Pattern p = Pattern.compile(changeString);
        SpannableStringBuilder builder = new SpannableStringBuilder(completeString);
        Matcher telMatch = p.matcher(completeString);
        while (telMatch.find()) {
            ForegroundColorSpan redSpan = new ForegroundColorSpan(textColor);
//            builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
            builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            builder.setSpan(new AbsoluteSizeSpan(DensityUtils.sp2px(getApplicationContext(), 14)), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        return builder;
    }

    @Override
    public void getSelectLength(int lengths) {
        int size = remberWoreInfodapter.getWorkday().size();
        int selectSize = 0;
        for (int i = 0; i < remberWoreInfodapter.getWorkday().size(); i++) {
            if (remberWoreInfodapter.getWorkday().get(i).isSelected()) {
                selectSize += 1;
            }
        }
        if (selectSize > 0) {
            ((TextView) findViewById(R.id.btn_set_mode)).setText(getRightBottomText() + "(" + selectSize + ")");
            if (size != selectSize) {
                ((TextView) findViewById(R.id.tv_select_mode)).setText(getString(R.string.select_all_page));
                isSelecteAll = false;
                ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_normal);
            } else {
                ((TextView) findViewById(R.id.tv_select_mode)).setText("取消全选");
                ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_pressed);
                isSelecteAll = true;
            }
        } else {
            ((TextView) findViewById(R.id.tv_select_mode)).setText("全选本页");
            ((TextView) findViewById(R.id.btn_set_mode)).setText(getRightBottomText());
            ((ImageView) findViewById(R.id.img_box)).setImageResource(R.drawable.checkbox_normal);


            isSelecteAll = false;
        }
    }

    @Override
    public void itemClicListener(int position) {
        if (getIntent().getBooleanExtra("unClickItem", false)) {
            //禁止点击
            return;
        }
        final AccountWorkRember workInfo = workday.get(position);
        AccountDetailActivity.actionStart(mActivity, workInfo.getAccounts_type() + "", workInfo.getId(), role, agencyGroupUser);
        GrowingIO gio = GrowingIO.getInstance();
        gio.track("remember_item_click");
    }


    @Override
    public void YearAndMonthClick(String year, String month) {
        this.year = year;
        this.month = month;
        tv_date.setText(year + "年" + Integer.parseInt(month) + "月");
        setGoneArrow();
        GoneBottom();
        menuHeaderView.setDate(year, month);
        autoRefresh();
    }


    /**
     * 删除
     */

    public void delsetmount(String deleteIds) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", deleteIds);
        if (agencyGroupUser != null) {
            params.addBodyParameter("group_id", agencyGroupUser.getGroup_id() + "");
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELSETSMOUNT, params,
                new RequestCallBackExpand<String>() {
                    @SuppressWarnings("deprecation")
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<BaseNetBean> bean = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (bean.getState() == 0) {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            } else {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                                isDel = true;
                                deleteId = "";
                                autoRefresh();
                                GoneBottom();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                        }
                        closeDialog();
                    }
                });
    }


    @Override
    public void onBackPressed() {
        if (isDel) {
            setResult(Constance.DISPOSEATTEND_RESULTCODE, getIntent());
        }
        super.onBackPressed();
    }

    public void onFinish(View view) {
        if (isDel) {
            setResult(Constance.DISPOSEATTEND_RESULTCODE, getIntent());
        }
        finish();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_date: //日历时间选择框
                if (!TextUtils.isEmpty(date)) {
                    return;
                }
                if (selecteYearMonthPopWindow == null) {
                    selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(mActivity, this, Integer.parseInt(year), Integer.parseInt(month));
                } else {
                    selecteYearMonthPopWindow.update();
                }
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.img_date_left: //月份减
                addCalender(-1);
                GoneBottom();
                break;
            case R.id.img_date_right: //月份加
                addCalender(1);
                GoneBottom();
                break;
            case R.id.rea_select_all_mode: //全选
                selectAll();
                break;
            case R.id.btn_set_mode: //修改模版或者删除
                delAndModifyClick();
                break;

        }
    }

    /**
     * 删除或者修改
     */
    public void delAndModifyClick() {
        int deleteLength = 0;
        final StringBuilder sb = new StringBuilder();
        //1.删除  2.修改
        if (selectStatus == 1) {
            for (int i = 0; i < remberWoreInfodapter.getWorkday().size(); i++) {
                if (remberWoreInfodapter.getWorkday().get(i).isSelected()) {
                    if (deleteLength == 0) {
                        sb.append(remberWoreInfodapter.getWorkday().get(i).getId() + "");
                    } else {
                        sb.append("," + remberWoreInfodapter.getWorkday().get(i).getId());
                    }
                    deleteLength += 1;
                }
            }
            if (deleteLength > 0) {
                String text = "本页共 " + (remberWoreInfodapter.getWorkday() == null ? 0 : remberWoreInfodapter.getWorkday().size()) + " 笔记工，即将删除选中的 " + deleteLength + " 笔。\n数据一经删除将无法恢复。请谨慎操作哦!";
                DialogOnlyTitle dialogOnlyTitle = new DialogOnlyTitle(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        delsetmount(sb.toString());
                    }
                }, -1, text);
                dialogOnlyTitle.setConfirmBtnName(getString(R.string.confirm_delete));
                dialogOnlyTitle.show();
                dialogOnlyTitle.setContentLeft();
                dialogOnlyTitle.getTvContent().setText(Html.fromHtml("本页共 <font color='#EB4E4E'>" + (remberWoreInfodapter.getWorkday() == null ? 0 : remberWoreInfodapter.getWorkday().size()) + " 笔 </font>记工，即将删除选中的 <font color='#EB4E4E'>" + deleteLength + " 笔</font>。<br />数据一经删除将无法恢复。请谨慎操作哦!"));
            } else {
                CommonMethod.makeNoticeShort(mActivity, "请选择需要删除的记录", CommonMethod.ERROR);
            }

        } else {
            for (int i = 0; i < remberWoreInfodapter.getWorkday().size(); i++) {
                if (remberWoreInfodapter.getWorkday().get(i).isSelected() && remberWoreInfodapter.getWorkday().get(i).getAccounts_type() == 1) {
                    if (deleteLength == 0) {
                        sb.append(remberWoreInfodapter.getWorkday().get(i).getId() + "");
                    } else {
                        sb.append("," + remberWoreInfodapter.getWorkday().get(i).getId());
                    }
                    deleteLength += 1;
                }
            }
            if (deleteLength > 0) {
                DialogModifySalaryMode dialogModifySalaryMode = new DialogModifySalaryMode(mActivity, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        autoRefresh();
                        GoneBottom();

                    }
                }, deleteLength, sb.toString(), role);
                dialogModifySalaryMode.show();
            } else {
                CommonMethod.makeNoticeShort(mActivity, "请选择要修改的点工记账记录", CommonMethod.ERROR);
            }
        }
    }

    /**
     * 日期加减一天
     *
     * @param add 1加一天 -1减一天
     */
    public void addCalender(int add) {
        try {
            Date date = (new SimpleDateFormat("yyyy-MM")).parse(year + "-" + month);
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            cal.add(Calendar.MONTH, add);
            String newDate = (new SimpleDateFormat("yyyy-MM")).format(cal.getTime());
            String[] split = newDate.split("-");
            //重置年月
            if (split.length == 2) {
                this.year = split[0];
                this.month = split[1];
                setDateText();
                setGoneArrow();
                autoRefresh();
                if (null != menuHeaderView) {
                    menuHeaderView.setDate(year, month);
                }
//                getDataTotal();
            }

        } catch (Exception e) {
            CommonMethod.makeNoticeShort(mActivity, "日期错误", CommonMethod.ERROR);
        }
    }

    /**
     * 隐藏左右箭头
     */
    public void setGoneArrow() {
        //获取当前日期
        Calendar calendar = Calendar.getInstance();
        int yearNow = calendar.get(calendar.YEAR);
        int monthNow = calendar.get(Calendar.MONTH) + 1;
        if (Integer.parseInt(year) <= 2014 && Integer.parseInt(month) <= 1) {
            //已经是2014-01
            findViewById(R.id.img_date_left).setVisibility(View.INVISIBLE);
            findViewById(R.id.img_date_right).setVisibility(View.VISIBLE);
        } else if (Integer.parseInt(year) >= yearNow && Integer.parseInt(month) >= monthNow) {
            //已经是当前年月
            findViewById(R.id.img_date_left).setVisibility(View.VISIBLE);
            findViewById(R.id.img_date_right).setVisibility(View.INVISIBLE);
        } else {
            findViewById(R.id.img_date_left).setVisibility(View.VISIBLE);
            findViewById(R.id.img_date_right).setVisibility(View.VISIBLE);
        }

        if (!TextUtils.isEmpty(date)) {
            findViewById(R.id.img_date_left).setVisibility(View.GONE);
            findViewById(R.id.img_date_right).setVisibility(View.GONE);
            headerView.findViewById(R.id.rb_statistics).setVisibility(View.GONE);
        }
        //是否隐藏查看更多
        if (getIntent().getBooleanExtra("hideRightLayout", false)) {
            findViewById(R.id.rb_filter).setVisibility(View.GONE);
        }
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                onRefresh();
            }
        });
    }

    //加载数据
    @Override
    public void onRefresh() {
        isFulsh = true;
        isHaveMoreData = true;
        pg = 1;
        getData(year + month);
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (view.getLastVisiblePosition() == (view.getCount() - 1) && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据
                isFulsh = false;
                loadMoreView.setVisibility(View.VISIBLE);
                pg += 1;
                if (findViewById(R.id.rea_mode_bottom).getVisibility() == View.VISIBLE) {
                    getHourData();
                } else {
                    getData(year + month);

                }

            }
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

    }

    /**
     * 获取记功流水点工数据
     */
    public void getHourData() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pagesize", String.valueOf(Constance.PAGE_SIZE));
        params.addBodyParameter("pg", String.valueOf(pg));
        params.addBodyParameter("date", year + "-" + month);

        params.addBodyParameter("accounts_type", "1");
        //rb_filter.setChecked(true);

        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_WORK_RECORD_FLOW, params,
                new RequestCallBackExpand<String>() {
                    @SuppressWarnings("deprecation")
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonNewJson baseJson = CommonNewJson.fromJson(responseInfo.result, AccountWorkRemberTop.class);
                            String msg = baseJson.getMsg();
                            if (!TextUtils.isEmpty(msg) && msg.equals(Constance.SUCCES_S)) {
                                isSelecteAll = false;
                                if (pg == 1) {
                                    setHeadValue((AccountWorkRemberTop) baseJson.getResult());

                                    if (null == ((AccountWorkRemberTop) baseJson.getResult()).getList() || ((AccountWorkRemberTop) baseJson.getResult()).getList().size() == 0) {
                                        DiaLogBottomRed diaLogBottomRed = new DiaLogBottomRed(mActivity, "我知道了", "没有需要修改的点工记录");
                                        findViewById(R.id.rea_mode_bottom).setVisibility(View.GONE);
                                        diaLogBottomRed.show();
                                        diaLogBottomRed.setOnDismissListener(new DialogInterface.OnDismissListener() {
                                            @Override
                                            public void onDismiss(DialogInterface dialog) {
                                                right_title(null);
                                            }
                                        });
                                    }

                                }
                                setHourVaues(((AccountWorkRemberTop) baseJson.getResult()).getList());

                            } else {
                                DataUtil.showErrOrMsg(mActivity, baseJson.getCode() + "", baseJson.getMsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException error, String msg) {
                        printNetLog(msg, mActivity);
                        closeDialog();
                        tv_cancel.setVisibility(View.GONE);
                        closeDialog();
                    }
                });

    }

    public void setHourVaues(List<AccountWorkRember> accountWorkRember) {
        if (null == hourWorkDay) {
            hourWorkDay = new ArrayList<>();
        }
        for (int i = 0; i < accountWorkRember.size(); i++) {
            accountWorkRember.get(i).setShowCb(true);
        }
        if (isFulsh) {
            hourWorkDay = accountWorkRember;
            remberWoreInfodapter = new RemberWoreInfosAdapter(mActivity, hourWorkDay, role, this);
            if (listView.getHeaderViewsCount() == 0) {
                listView.addHeaderView(headerView);
            }
            if (listView.getFooterViewsCount() == 0) {
                listView.addFooterView(loadMoreView);
            }
            remberWoreInfodapter.setUnClickItem(getIntent().getBooleanExtra("unClickItem", false));
            listView.setAdapter(remberWoreInfodapter);
            loadMoreView.setVisibility(View.GONE);
            listView.setSelection(0);
            mSwipeLayout.setRefreshing(false);
        } else {
            isHaveMoreData = accountWorkRember.size() >= 1 ? true : false;
            loadMoreView.setVisibility(View.GONE);
            int seletionPositon = accountWorkRember.size() > 0 ? (remberWoreInfodapter.getWorkday().size() + 1) : remberWoreInfodapter.getWorkday().size();
            hourWorkDay.addAll(accountWorkRember);
            remberWoreInfodapter.notifyDataSetChanged();
            listView.setSelection(seletionPositon);
            if (findViewById(R.id.rea_mode_bottom).getVisibility() == View.VISIBLE) {
                getSelectLength(0);
                LUtils.e("---------计算长度-------");
            } else {
                LUtils.e("------不---计算长度-------");

            }
        }
        if (listView.getFooterViewsCount() == 1 && remberWoreInfodapter.getWorkday().size() == 0) {
            layout_default.setVisibility(View.VISIBLE);
            if (rb_filter.isChecked()) {
                ((TextView) headerView.findViewById(R.id.tv_top)).setText("本页暂无记工数据");
            } else {
                ((TextView) headerView.findViewById(R.id.tv_top)).setText("本月暂无记工数据");
            }
        } else {
            layout_default.setVisibility(View.GONE);
        }
//        Utils.setListViewHeightBasedOnChildren(listView);
    }
}
