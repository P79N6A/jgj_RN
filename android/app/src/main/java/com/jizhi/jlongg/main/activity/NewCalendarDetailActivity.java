package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.TextView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.higuide.HiGuide;
import com.jizhi.jlongg.higuide.Overlay;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.adpter.CalendarMainAdapter;
import com.jizhi.jlongg.main.adpter.CalendarViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.HorizotalItemBean;
import com.jizhi.jlongg.main.bean.RecordWorkPoints;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.ReWardDialog;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.fragment.worker.CalendarDetailFragment;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jongg.widget.ResetHeightViewPager;
import com.liaoinstan.springview.utils.DensityUtil;

import java.util.ArrayList;

/**
 * 功能:日历记账详情
 * 时间:2017年2月9日16:43:15
 * 作者:xuj
 */
public class NewCalendarDetailActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 存放日历的Fragment 集合
     */
    private ArrayList<Fragment> fragments;
    /**
     * ViewPager
     */
    private ResetHeightViewPager mViewPager;
    /**
     * 顶部月份
     */
    private TextView dateText;
    /**
     * VierPager 当前滑动位置
     */
    private int mCurrentIndex;
    /**
     * 结束动画,是否在加载动画
     */
    private boolean isFirstEnter = true;
    /**
     * 是否已加载了切换身份弹出框
     * 当本次角色和和上次记账角色不相同的时候需要弹出提示框
     */
    private boolean isLoadChangeRolerDialog;
    /**
     * 列表适配器
     */
    private CalendarMainAdapter adapter;
    /**
     * 左滑箭头
     */
    private View leftArrows;
    /**
     * 右滑箭头
     */
    private View rightArrows;

    private final int WORK_FLOW_TAG = 0; //记工流水
    private final int WORK_STATISTICAL_TAG = 1; //记工统计
    private final int CHECK_ACCOUNT_TAG = 2; //我要对账
    private final int UN_BALANCE_TAG = 3; //未结工资
    private final int EVALUATE_TAG = 4; //班组长，工人评价
    private final int WORK_SETTING_TAG = 5; //记工设置
    private final int LIKE_NUM_TAG = 6; //点个赞
    private final int RECOMMEND_OTHER_TAG = 7; //推荐给他人
    private final int SYNC_WORK = 8; //同步记工

    @Override
    protected void onResume() {
        super.onResume();
        if (!isFirstEnter && UclientApplication.isLogin(this)) { //只要登录成功就刷新数据
            CalendarDetailFragment framgent = (CalendarDetailFragment) fragments.get(mCurrentIndex);
            framgent.refreshData();
        }
        if (isFirstEnter) {
            isFirstEnter = false;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.record_calendar_new);
        initView();
//        loadAccountFlowGuide();
    }

    private ArrayList<HorizotalItemBean> getItem() {

        //true表示当前是工人角色,false表示是班组长角色
        boolean isWorker = UclientApplication.getRoler(this).equals(Constance.ROLETYPE_WORKER);

        Resources resource = getResources();
        ArrayList<HorizotalItemBean> list = new ArrayList<>();
        HorizotalItemBean item1 = new HorizotalItemBean("记工流水", WORK_FLOW_TAG, resource.getDrawable(R.drawable.calendar_record_detaila_icon));
        HorizotalItemBean item2 = new HorizotalItemBean("记工统计", WORK_STATISTICAL_TAG, resource.getDrawable(R.drawable.calendar_work_statistical_icon));
        HorizotalItemBean item3 = new HorizotalItemBean("我要对账", CHECK_ACCOUNT_TAG, resource.getDrawable(R.drawable.calendar_balance_account_icon));
        HorizotalItemBean item4 = new HorizotalItemBean(isWorker ? "未结工资" : "未结工人工资", "0.00", UN_BALANCE_TAG, resource.getDrawable(R.drawable.calendar_un_balance_icon));
        HorizotalItemBean item6 = new HorizotalItemBean(getString(isWorker ? R.string.foremans : R.string.worker_manager), isWorker ? "管理及评价班组长" : "管理及评价工人", EVALUATE_TAG, resource.getDrawable(R.drawable.calendar_person_manager_icon));
        HorizotalItemBean item7 = new HorizotalItemBean("记工设置", WORK_SETTING_TAG, resource.getDrawable(R.drawable.calendar_account_show_type_icon));
        HorizotalItemBean item8 = new HorizotalItemBean("打赏", LIKE_NUM_TAG, resource.getDrawable(R.drawable.calendar_like_red_pack_icon));
        HorizotalItemBean item9 = new HorizotalItemBean("推荐给他人", RECOMMEND_OTHER_TAG, resource.getDrawable(R.drawable.calendar_recommend_other_icon));


        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);

        if (isWorker) {
            list.add(item6);
            list.add(item7);
            list.add(item8);
            list.add(item9);
        } else {
            HorizotalItemBean item5 = new HorizotalItemBean("同步记工", SYNC_WORK, resource.getDrawable(R.drawable.calendar_sync_bill_icon));
            list.add(item5);
            list.add(item6);
            list.add(item8);
            list.add(item9);
            list.add(item7);
        }

        item4.setValueColor(Color.parseColor("#5ba0ed"));
        item6.setValueColor(Color.parseColor("#666666"));
        item7.setValueColor(Color.parseColor("#eb4e4e"));

        return list;
    }

    public void setItemValue(int item, String value, boolean isRefresh) {
        for (HorizotalItemBean bean : adapter.getList()) {
            if (bean.getMenuId() == item) { //所在项目组
                bean.setValue(value);
                break;
            }
        }
        if (isRefresh) {
            adapter.notifyDataSetChanged();
        }
    }

    public void setItemRedTips(int item, String value, boolean isRefresh) {
        for (HorizotalItemBean bean : adapter.getList()) {
            if (bean.getMenuId() == item) { //所在项目组
                bean.setRed_tips(value);
                break;
            }
        }
        if (isRefresh) {
            adapter.notifyDataSetChanged();
        }
    }


    public void setItemShowRedDot(int item, boolean isShow, boolean isRefresh) {
        for (HorizotalItemBean bean : adapter.getList()) {
            if (bean.getMenuId() == item) { //所在项目组
                bean.setShow_little_red_dot(isShow);
                break;
            }
        }
        if (isRefresh) {
            adapter.notifyDataSetChanged();
        }
    }


    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    loadAccountFlowGuide();
                }
            }, 1000);
        }
    }

    /**
     * 加载记工流水动画
     */
    private void loadAccountFlowGuide() {
        final String key = "show_flow_guide_" + AppUtils.getVersionName(getApplicationContext());
        boolean isShow = (boolean) SPUtils.get(getApplicationContext(), key, false, Constance.JLONGG);
        if (!isShow) {
            SPUtils.put(getApplicationContext(), key, true, Constance.JLONGG); // 存放Token信息
            GridView gridView = findViewById(R.id.navigation_gridview);
            View childView = gridView.getChildAt(0);
            if (childView != null) {
                new HiGuide(NewCalendarDetailActivity.this).addHightLight(childView, null, HiGuide.SHAPE_RECT,
                        new Overlay.Tips(R.layout.account_flow_guide, Overlay.Tips.TO_CENTER_OF, Overlay.Tips.ALIGN_TOP,
                                new Overlay.Tips.Margin(0, 0, DensityUtil.dp2px(10), 0))).touchDismiss(true).show();
            }
        }
    }


    private void initView() {
        setTextTitleAndRight(R.string.recordMerit, R.string.record_problem);
        dateText = getTextView(R.id.title);
        mViewPager = findViewById(R.id.viewPager);
        GridView gridView = findViewById(R.id.navigation_gridview);
        adapter = new CalendarMainAdapter(this, getItem());
        gridView.setAdapter(adapter);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Activity mActivity = NewCalendarDetailActivity.this;
                switch (adapter.getItem(position).getMenuId()) {
                    case WORK_FLOW_TAG: //记工流水
                        CalendarDetailFragment fragment = (CalendarDetailFragment) fragments.get(mCurrentIndex);
                        CustomDate showDate = fragment.getmShowDate();
                        if (showDate == null) {
                            showDate = new CustomDate();
                        }
                        RememberWorkerInfosActivity.actionStart(mActivity, showDate.getYear() + "", showDate.month < 10 ? "0" + showDate.month : String.valueOf(showDate.month),
                                UclientApplication.getRoler(mActivity));
                        break;
                    case WORK_STATISTICAL_TAG: //记工统计
                        StatisticalWorkFirstActivity.actionStart(mActivity);
                        break;
                    case CHECK_ACCOUNT_TAG://我要对账
                        if (!IsSupplementary.isFillRealNameIntentActivity(mActivity, false, RecordWorkConfirmActivity.class)) {
                            return;
                        }
                        break;
                    case UN_BALANCE_TAG: //未结工资
                        UnBalanceActivity.actionStart(mActivity);
                        break;
                    case EVALUATE_TAG://班组长，工人评价
                        ForemanWorkerManagerActivity.actionStart(mActivity);
                        break;
                    case WORK_SETTING_TAG: //记工设置
                        RecordAccountSettingActivity.actionStart(mActivity);
//                        AccountShowTypeActivity.actionStart(NewCalendarDetailActivity.this);
                        break;
                    case LIKE_NUM_TAG://点个赞
                        new ReWardDialog(mActivity).show();
                        break;
                    case RECOMMEND_OTHER_TAG: //推荐给他人
                        AppUtils.shareApp(NewCalendarDetailActivity.this);
                        break;
                    case SYNC_WORK://同步记工
                        SyncActivity.actionStart(NewCalendarDetailActivity.this, true);
                        break;
                }
            }
        });

        View foremanRecordBtnLayout = findViewById(R.id.foreman_record_btn_Layout);
        View workerRecordBtnLayout = findViewById(R.id.worker_record_btn_Layout); //在记一笔按钮
        if (UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_WORKER)) { //当前角色是工友
            workerRecordBtnLayout.setVisibility(View.VISIBLE); //显示马上记一笔按钮
            foremanRecordBtnLayout.setVisibility(View.GONE);
        } else {
            workerRecordBtnLayout.setVisibility(View.GONE); //隐藏马上记一笔按钮
            foremanRecordBtnLayout.setVisibility(View.VISIBLE);
        }


        leftArrows = findViewById(R.id.leftIcon);
        rightArrows = findViewById(R.id.rightIcon);
        leftArrows.setOnClickListener(this);
        rightArrows.setOnClickListener(this);
        rightArrows.setVisibility(View.INVISIBLE);

        fragments = new ArrayList<>();
        CustomDate currentTime = new CustomDate();
        int difference_between_month = 0; //相差月份个数
        try {
            difference_between_month = DateUtil.countMonths("2014-01", currentTime.getYear() + "-" + currentTime.getMonth(), "yyyy-MM"); // 获取2014年1月到现在相差多少个月
        } catch (Exception e) {
            e.printStackTrace();
        }
        int startYear = 2014; // 开始时间2014年
        int startMonth = 1; // 1月
        int startday = 1; // 第一天
        for (int i = 0; i <= difference_between_month; i++) {
            if (startMonth > 12) {
                startYear += 1;
                startMonth = 1;
            }
            CalendarDetailFragment fragment = new CalendarDetailFragment();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, new CustomDate(startYear, startMonth, startday));
            bundle.putInt("fragmentPosition", i);
            fragment.setArguments(bundle);
            fragments.add(fragment);
            startMonth += 1;
        }
        setViewPager();
    }

    private void setViewPager() {
        mViewPager.setAdapter(new CalendarViewPagerAdapter(getSupportFragmentManager(), fragments));
        mViewPager.setCurrentItem(fragments.size());
        mViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                try {
                    leftArrows.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
                    rightArrows.setVisibility(position == fragments.size() - 1 ? View.INVISIBLE : View.VISIBLE);
                    mCurrentIndex = position;
                    mViewPager.resetHeight(position); //由于每个Fragment高度不一致 重置viewpager的高度
                    CalendarDetailFragment fragment = (CalendarDetailFragment) (fragments.get(position));
                    int month = fragment.getmShowDate().month;
                    setDate(fragment.getmShowDate().year + "", month);
                    fragment.refreshData(); //每次滑动ViewPager则重新加载数据
                } catch (Exception e) {
                    e.getMessage();
                }
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        CalendarDetailFragment fragment = (CalendarDetailFragment) fragments.get(fragments.size() - 1);
        Bundle bundle = fragment.getArguments();
        CustomDate date = (CustomDate) bundle.getSerializable(Constance.BEAN_CONSTANCE);
        setDate(date.year + "", date.month);
        mCurrentIndex = fragments.size() - 1;
    }


    private void setDate(String year, int month) {
        dateText.setText(year + "年" + month + "月");
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.title: //日历时间选择框
                CalendarDetailFragment fragme = (CalendarDetailFragment) fragments.get(mCurrentIndex);
                WheelViewSelectYearAndMonth selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(this, new YearAndMonthClickListener() {
                    @Override
                    public void YearAndMonthClick(String year, String month) {
                        try {
                            int count = DateUtil.countMonths("2014-01", year + "-" + month, "yyyy-MM");
                            mViewPager.setCurrentItem(count);
                            setDate(year, Integer.parseInt(month));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }, fragme.getmShowDate().year, fragme.getmShowDate().month);
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.leftIcon: //点击回到上个月
                if (mCurrentIndex == 0) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex - 1);
                break;
            case R.id.rightIcon://点击去到下个月
                if (mCurrentIndex == fragments.size() - 1) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex + 1);
                break;
            case R.id.sundryDayIcon: //晒工天
//                IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
//                    @Override
//                    public void onSuccess() {
//                        X5WebViewActivity.actionStart(NewCalendarDetailActivity.this, NetWorkRequest.WEBURLS + "workday");
//                    }
//                });
                break;
            case R.id.recordOneAccount: //工人马上记一笔按钮
                NewAccountActivity.actionStart(this, false);
                break;
            case R.id.borrow_btn_worker: //工人 借支结算
            case R.id.borrow_btn_foreman: //班组长 借支/结算
                NewAccountActivity.actionStart(this, true);
                break;
            case R.id.recordSingleBtn: //工头记单笔按钮
                NewAccountActivity.actionStart(this, false);
                break;
            case R.id.recordMultipartBtn: //工头一天记多人按钮
                GetGroupAccountActivity.actionStart(this, true, null);
                break;
            case R.id.right_title: //记工说明
                HelpCenterUtil.actionStartHelpActivity(NewCalendarDetailActivity.this, 208);
                break;
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        if (requestCode == Constance.REQUEST) {
            AppUtils.showShareDialog(this);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
//            setResult(Constance.SAVE_BATCH_ACCOUNT, data);
//            finish();
        } else if (resultCode == Constance.SYNC_SUCCESS) {
            SyncReocrdAccountActivity.actionStart(NewCalendarDetailActivity.this);
        }
//        else if (resultCode == Constance.SWITCH_ROLER) { //切换了角色
//            setResult(Constance.SWITCH_ROLER);
//            finish();
//        }
        else if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE) {
            setItemValue(WORK_SETTING_TAG, AccountUtil.getCurrentAccountType(getApplicationContext()), true);
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊聊天
            setResult(resultCode, data);
            finish();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        }
    }


    /**
     * 设置 年收入、月收入 等相关信息
     *
     * @param bean 数据Modul
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public void setIncome(RecordWorkPoints bean) {
        if (TextUtils.isEmpty(bean.getY_m()) || bean.getY_m().length() != 6) {
            return;
        }
        CalendarDetailFragment fragment = (CalendarDetailFragment) fragments.get(mCurrentIndex);
        int serverYear = Integer.parseInt(bean.getY_m().substring(0, 4));
        int serverMonth = Integer.parseInt(bean.getY_m().substring(4));
        int currentFragmentPageYear = fragment.getmShowDate().year; //当前页面的年份
        int currentFragmentPageMonth = fragment.getmShowDate().month; //当前页面的月份
        if (currentFragmentPageYear == serverYear && currentFragmentPageMonth == serverMonth) { //当前日历年月相同的时候才需设置数据
            if (bean.getB_total() != null) { //设置 未结工资
                setItemValue(UN_BALANCE_TAG, bean.getB_total().getTotal() + bean.getB_total().getUnit(), false);
            }
        }
        //设置我要对账的个数
        setItemRedTips(CHECK_ACCOUNT_TAG, bean.getWait_confirm_num() > 0 ? bean.getWait_confirm_num() + "" : null, false);
        //1表示有同步给我的数据 需要显示
        setItemShowRedDot(SYNC_WORK, bean.getIs_red_flag() == 1, false);
        if (bean.getIs_diff_role() == 1 && !isLoadChangeRolerDialog) {//1表示上次记账的角色和本次不同 弹出是否需要切换角色的提示
            isLoadChangeRolerDialog = true;
            DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(this, null, null, new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                @Override
                public void clickLeftBtnCallBack() {

                }

                @Override
                public void clickRightBtnCallBack() {
                    ChooseRoleActivity.actionStart(NewCalendarDetailActivity.this, false);
                }
            });
            dialogLeftRightBtnConfirm.setRightBtnText(getString(R.string.go_to_change_role));
            dialogLeftRightBtnConfirm.setLeftBtnText(getString(R.string.no_change_role));
            dialogLeftRightBtnConfirm.setHtmlContent(UclientApplication.isForemanRoler(getApplicationContext()) ?
                    Utils.getHtmlColor666666("当前是") + Utils.getHtmlColor000000("&nbsp;【班组长】&nbsp;") + Utils.getHtmlColor666666("身份")
                            + Utils.getHtmlColor666666("<br/>你上一次是以") + Utils.getHtmlColor000000("&nbsp;【工人】&nbsp;")
                            + Utils.getHtmlColor666666("身份记录的，是否切换身份?") :
                    Utils.getHtmlColor666666("当前是") + Utils.getHtmlColor000000("&nbsp;【工人】&nbsp;") + Utils.getHtmlColor666666("身份")
                            + Utils.getHtmlColor666666("<br/>你上一次是以") + Utils.getHtmlColor000000("&nbsp;【班组长】&nbsp;")
                            + Utils.getHtmlColor666666("身份记录的，是否切换身份?"));
            dialogLeftRightBtnConfirm.show();
        }
        adapter.notifyDataSetChanged();
    }

    public ResetHeightViewPager getmViewPager() {
        return mViewPager;
    }


}
