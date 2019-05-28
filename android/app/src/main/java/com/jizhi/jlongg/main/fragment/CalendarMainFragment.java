package com.jizhi.jlongg.main.fragment;

import android.annotation.TargetApi;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.activity.notebook.NoteBookListActivity;
import com.jizhi.jlongg.listener.ScrollViewListener;
import com.jizhi.jlongg.main.activity.EveryDayAttenDanceActivity;
import com.jizhi.jlongg.main.activity.ForemanWorkerManagerActivity;
import com.jizhi.jlongg.main.activity.GetGroupAccountActivity;
import com.jizhi.jlongg.main.activity.MyGroupTeamActivity;
import com.jizhi.jlongg.main.activity.NetFailActivity;
import com.jizhi.jlongg.main.activity.RecordAccountSettingActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.activity.SingleBatchAccountActivity;
import com.jizhi.jlongg.main.activity.StatisticalWorkFirstActivity;
import com.jizhi.jlongg.main.activity.SyncActivity;
import com.jizhi.jlongg.main.activity.UnBalanceActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.adpter.CalendarMainAdapter;
import com.jizhi.jlongg.main.adpter.CalendarViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.HorizotalItemBean;
import com.jizhi.jlongg.main.bean.RecordWorkPoints;
import com.jizhi.jlongg.main.custom.ButtonTouchChangeAlpha;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.fragment.worker.CalendarDetailFragment;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.ObservableScrollView;
import com.jizhi.jongg.widget.ResetHeightViewPager;
import com.liaoinstan.springview.utils.DensityUtil;
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.AnimatorListenerAdapter;
import com.nineoldandroids.animation.ObjectAnimator;

import java.text.SimpleDateFormat;
import java.util.ArrayList;


/**
 * 功能:项目Fragment
 * 作者：xuj
 * 时间: 2017年4月19日10:43:22
 */
public class CalendarMainFragment extends BaseFragment implements View.OnClickListener {
    /**
     * 网络连接失败布局
     */
    private LinearLayout netFailLayout;
    /**
     * 当前角色名称
     */
    private TextView navigationRolerText;
    /**
     * 日历ViewPager
     */
    private ResetHeightViewPager calendarViewPagaer;
    /**
     * 存放日历的Fragment 集合
     */
    private ArrayList<Fragment> calendarFragments;
    /**
     * 记账日历左滑箭头
     */
    private View dateLeftArrows;
    /**
     * 记账日历右滑箭头
     */
    private View dateRightArrows;
    /**
     * 顶部月份
     */
    private TextView dateText;
    /**
     * 我的项目班组 小红点
     */
    private View otherGroupRedCircle;
    /**
     * 日历VierPager 当前滑动位置
     */
    private int mCurrentIndex;
    /**
     * 如果退出、删除、关闭 群聊信息
     * 如果这个变量为true  则每次回到这个页面 都会重新请求服务器
     * 默认为false
     */
    private boolean isRequestServer = false;
    /**
     * 当前Activity是否在前台
     */
    private boolean isFront = false;
    /**
     * 底部功能模块适配器
     */
    private CalendarMainAdapter adapter;
    /**
     * 是否已加载了切换身份弹出框
     * 当本次角色和和上次记账角色不相同的时候需要弹出提示框
     */
    private boolean isLoadChangeRolerDialog;
    /**
     * 当本次角色和和上次记账角色不相同的时候需要弹出提示框
     */
    private boolean isDiffRole;
    /**
     * 首次进入页面的标识
     */
    private boolean isFirstEnter = true;
    /**
     * true表示正在显示日历引导页,正在显示记事本引导,正在显示滑动引导页
     */
    private boolean showCalendarScrollGuiding, showNotesGuiding, showScrollGuiding;
    /**
     * 模块加载完毕的标识,是否加载滑动引导页标识
     */
    private boolean loadedMenuLayoutFinish, isShowScrollGuide;
    /**
     * 当前角色
     */
    private String currentRoler;
    /**
     * 滑动动画
     */
    private ObjectAnimator translateAnimation;
    /**
     * 加载数据库中的标识
     */
    private boolean isLoadingDataBase;
    /**
     * 是否已修改了群聊信息
     * 如果在项目或班组设置里面进行了修改数据那么会发送一条广播将这个变量设为true
     * 如果这个变量为true  则每次回到这个页面 都会重新读取本地数据库进行数据的刷新
     * 默认为false
     */
    private boolean isUpdateLocalGroupInfo = false;
    /**
     * 预加载的日历数据
     * 只会在闪屏页WelcomeActivity里面加载一次最新月份的数据
     * 保证数据能及时出来
     */
    public static RecordWorkPoints prestrainData;


    private final int WORK_FLOW_TAG = 0; //记工流水
    private final int WORK_STATISTICAL_TAG = 1; //记工统计
    private final int CHECK_ACCOUNT_TAG = 2; //我要对账
    private final int UN_BALANCE_TAG = 3; //未结工资
    private final int EVALUATE_TAG = 4; //班组长，工人评价
    private final int WORK_SETTING_TAG = 5; //记工设置
    private final int RECORD_ACCOUNT_NOTES = 6; //记工说明
    private final int SYNC_WORK = 7; //同步记工
    private final int SUN_WORKING_DAY = 8; //晒工天


    @Override
    public void onPause() {
        super.onPause();
        if (showScrollGuiding && translateAnimation != null) {
            translateAnimation.cancel();
        }
        isFront = false;
    }

    @Override
    public void onResume() {
        super.onResume();
        isFront = true;
        if (showScrollGuiding && translateAnimation != null) {
            translateAnimation.start();
        }
        if (!isFirstEnter && UclientApplication.isLogin(getActivity())) { //只要登录成功就刷新数据
            CalendarDetailFragment framgent = (CalendarDetailFragment) calendarFragments.get(mCurrentIndex);
            framgent.refreshData();
        }
        if (isFirstEnter) {
            isFirstEnter = false;
        }
        if (isRequestServer) { //请求服务器数据
            isRequestServer = false;
            isUpdateLocalGroupInfo = false;
            MessageUtil.getWorkCircleData(getActivity());
            return;
        }
        if (isUpdateLocalGroupInfo) {
            isUpdateLocalGroupInfo = false;
            loadLocalDataBaseData();
        }
    }

    /**
     * 加载本地数据库数据
     */
    private void loadLocalDataBaseData() {
        LUtils.e("刷新首页数据:" + new SimpleDateFormat("yyyy-MM-dd hh:ss:mm").format(new java.util.Date()));
        if (!isLoadingDataBase) {
            isLoadingDataBase = true;
            //加载离线消息有可能速度会很快，频繁刷新数据库不是很好，我们这里每次只要涉及到加载数据库的操作就延迟0.2秒
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    otherGroupRedCircle.setVisibility(MessageUtil.isShowMainLittleRedCircle(null, null) ? View.VISIBLE : View.GONE);
                    isLoadingDataBase = false;
                }
            }, 100);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.calendar_main_fragment_layout, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView(savedInstanceState);
        MessageUtil.getWorkCircleData(getActivity()); //获取首页收据
    }


    @Override
    public void initFragmentData() {
        setAdapter();
        initRoleInfo(false);
        currentRoler = UclientApplication.getRoler(getActivity().getApplicationContext());
    }

    private ArrayList<HorizotalItemBean> getItem() {

        LUtils.e("加载功能模块数据");
        //true表示当前是工人角色,false表示是班组长角色
        boolean isWorker = UclientApplication.getRoler(getActivity().getApplicationContext()).equals(Constance.ROLETYPE_WORKER);

        Resources resource = getResources();
        ArrayList<HorizotalItemBean> list = new ArrayList<>();
        HorizotalItemBean item1 = new HorizotalItemBean("记工流水", WORK_FLOW_TAG, resource.getDrawable(R.drawable.calendar_record_detaila_icon));
        HorizotalItemBean item2 = new HorizotalItemBean("记工统计", WORK_STATISTICAL_TAG, resource.getDrawable(R.drawable.calendar_work_statistical_icon));
        HorizotalItemBean item3 = new HorizotalItemBean("未结工资", UN_BALANCE_TAG, resource.getDrawable(R.drawable.calendar_un_balance_icon));
        HorizotalItemBean item4 = new HorizotalItemBean("我要对账", CHECK_ACCOUNT_TAG, resource.getDrawable(R.drawable.calendar_balance_account_icon));
        HorizotalItemBean item5 = new HorizotalItemBean(getString(isWorker ? R.string.foremans : R.string.worker_manager), isWorker ? "管理及评价班组长" : "管理及评价工人", EVALUATE_TAG, resource.getDrawable(R.drawable.calendar_person_manager_icon));
        HorizotalItemBean item6 = new HorizotalItemBean("晒工天", SUN_WORKING_DAY, resource.getDrawable(R.drawable.calendar_sun_account_day));
        HorizotalItemBean item7 = new HorizotalItemBean("记工设置", WORK_SETTING_TAG, resource.getDrawable(R.drawable.calendar_account_show_type_icon));
        HorizotalItemBean item8 = new HorizotalItemBean("记工说明", RECORD_ACCOUNT_NOTES, resource.getDrawable(R.drawable.calendar_record_notes));

        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        list.add(item5);

        if (isWorker) {
            list.add(item6);
            list.add(item7);
            list.add(item8);
        } else {
            list.add(item6);
            list.add(new HorizotalItemBean("同步记工", SYNC_WORK, resource.getDrawable(R.drawable.calendar_sync_bill_icon)));
            list.add(item7);
            list.add(item8);
        }

        item5.setValueColor(Color.parseColor("#666666"));

        return list;
    }

    private void setAdapter() {
        if (adapter == null) {
            GridView gridView = getView().findViewById(R.id.navigation_gridview);
            adapter = new CalendarMainAdapter(getActivity(), getItem());
            adapter.setListener(new CalendarMainAdapter.ScrollGuideListener() {
                @Override
                public void loadMenuFinish(boolean isShowScrollGuide) {
                    loadedMenuLayoutFinish = true;
                    CalendarMainFragment.this.isShowScrollGuide = isShowScrollGuide;
                }
            });
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    int count = (int) SPUtils.get(getActivity().getApplicationContext(), "scroll_guide_count", 0, Constance.JLONGG);
                    SPUtils.put(getActivity().getApplicationContext(), "scroll_guide_count", count + 1, Constance.JLONGG);
                    switch (adapter.getItem(position).getMenuId()) {
                        case WORK_FLOW_TAG: //记工流水
                            IsSupplementary.isFillRealNameCallBackListener(getActivity(), false, new IsSupplementary.CallSupplementNameSuccess() {
                                @Override
                                public void onSuccess() {
                                    //完善姓名成功,发送广播更新前端个人资料
                                    DataUtil.UpdateLoginver(getActivity());
                                    Intent intent = new Intent();
                                    intent.setAction(WebSocketConstance.ACTION_UPDATEUSERINFO);
                                    getActivity().sendBroadcast(intent);
                                    CalendarDetailFragment fragment = (CalendarDetailFragment) calendarFragments.get(mCurrentIndex);
                                    CustomDate showDate = fragment.getmShowDate();
                                    if (showDate == null) {
                                        showDate = new CustomDate();
                                    }
                                    RememberWorkerInfosActivity.actionStart(getActivity(), showDate.getYear() + "",
                                            showDate.month < 10 ? "0" + showDate.month : String.valueOf(showDate.month), UclientApplication.getRoler(getActivity()));
                                }
                            });
                            break;
                        case WORK_STATISTICAL_TAG: //记工统计
                            IsSupplementary.isFillRealNameIntentActivity(getActivity(), false, StatisticalWorkFirstActivity.class);
                            break;
                        case CHECK_ACCOUNT_TAG://我要对账
                            IsSupplementary.isFillRealNameIntentActivity(getActivity(), false, RecordWorkConfirmActivity.class);
                            break;
                        case UN_BALANCE_TAG: //未结工资
                            IsSupplementary.isFillRealNameIntentActivity(getActivity(), false, UnBalanceActivity.class);
                            break;
                        case EVALUATE_TAG://班组长，工人评价
                            IsSupplementary.isFillRealNameIntentActivity(getActivity(), false, ForemanWorkerManagerActivity.class);
                            break;
                        case WORK_SETTING_TAG: //记工设置
                            RecordAccountSettingActivity.actionStart(getActivity());
                            break;
                        case SYNC_WORK://同步记工
                            IsSupplementary.isFillRealNameCallBackListener(getActivity(), false, new IsSupplementary.CallSupplementNameSuccess() {
                                @Override
                                public void onSuccess() {
                                    SyncActivity.actionStart(getActivity(), true);
                                }
                            });
                            break;
                        case SUN_WORKING_DAY: //晒工天
                            IsSupplementary.isFillRealNameCallBackListener(getActivity(), false, new IsSupplementary.CallSupplementNameSuccess() {
                                @Override
                                public void onSuccess() {
                                    X5WebViewActivity.actionStart(getActivity(), NetWorkRequest.WEBURLS + "workday");
                                }
                            });
                            break;
                        case RECORD_ACCOUNT_NOTES: //记工说明
                            HelpCenterUtil.actionStartHelpActivity(getActivity(), 208);
                            break;
                    }
                }
            });
        } else {
            //防止重复加载数据我们在这里重新设置一下加载的方法
            if (!UclientApplication.getRoler(getActivity().getApplicationContext()).equals(currentRoler)) {
                adapter.setList(getItem());
                adapter.notifyDataSetChanged();
            }
        }
    }

    /**
     * 初始化布局
     */
    private void initView(Bundle savedInstanceState) {
        currentRoler = UclientApplication.getRoler(getActivity().getApplicationContext());
        otherGroupRedCircle = getView().findViewById(R.id.other_group_red_circle);
        dateText = getView().findViewById(R.id.title);
        dateLeftArrows = getView().findViewById(R.id.date_left_arrow_icon);
        dateRightArrows = getView().findViewById(R.id.date_right_arrow_icon);
        dateRightArrows.setVisibility(View.INVISIBLE);
        navigationRolerText = getView().findViewById(R.id.navigation_roler_text);
        calendarViewPagaer = getView().findViewById(R.id.calendar_viewPager);
        netFailLayout = getView().findViewById(R.id.net_fail_Layout);

        netFailLayout.setOnClickListener(this); //网络连接失败
        navigationRolerText.setOnClickListener(this);
        dateLeftArrows.setOnClickListener(this);
        dateRightArrows.setOnClickListener(this);
        getView().findViewById(R.id.title).setOnClickListener(this);
        getView().findViewById(R.id.my_group_layout).setOnClickListener(this);
        getView().findViewById(R.id.borrow_balance_btn).setOnClickListener(this);
        getView().findViewById(R.id.record_account_red_btn).setOnClickListener(this);
        getView().findViewById(R.id.record_account_right_btn).setOnClickListener(this);
        getView().findViewById(R.id.notes_icon).setOnClickListener(this);
        getView().findViewById(R.id.notes_guide_icon).setOnClickListener(this); //覆盖记事本引导的点击动画以免盖住的部分还能点击
        initRoleInfo(true);
        setCalendarViewPager(savedInstanceState);
        ObservableScrollView scrollView = getView().findViewById(R.id.scrollView_layout);
        scrollView.setScrollViewListener(new ScrollViewListener() {
            @Override
            public void onScrollChanged(ObservableScrollView scrollView, int x, int y, int oldx, int oldy) {
                if (showScrollGuiding) {
                    hideGuideView(getView().findViewById(R.id.scroll_guide_layout), 3);
                }
            }
        });
    }

    /**
     * 初始化班组长，工人信息
     */
    private void initRoleInfo(boolean isFristLoad) {
        if (isFristLoad || !UclientApplication.getRoler(getActivity().getApplicationContext()).equals(currentRoler)) {
            if (calendarFragments != null && calendarFragments.size() > 0) {
                //切换角色后 设置为当前月
                calendarViewPagaer.setCurrentItem(calendarFragments.size() - 1);
            }
            //防止重复加载数据我们在这里重新设置一下加载的方法
            ButtonTouchChangeAlpha recordAccountRightBtn = getView().findViewById(R.id.record_account_right_btn);
            ImageView recordAccountRedBtn = getView().findViewById(R.id.record_account_red_btn);
            if (UclientApplication.isForemanRoler(getActivity().getApplicationContext())) { //班组长角色
                recordAccountRightBtn.setText(R.string.record_once_account);
                recordAccountRedBtn.setImageResource(R.drawable.calendar_main_multipart_record_account);
            } else {
                recordAccountRightBtn.setText(R.string.single_person_batch_account);
                recordAccountRedBtn.setImageResource(R.drawable.calendar_main_record_single_account);
            }
            navigationRolerText.setText(UclientApplication.getRoler(getActivity()).equals(Constance.ROLETYPE_FM) ? "我是班组长" : "我是工人");
            isLoadChangeRolerDialog = false;
        }
    }


    private void setCalendarViewPager(Bundle savedInstanceState) {
        calendarFragments = new ArrayList<>();
        CustomDate currentTime = new CustomDate();
        int differenceBetweenMonth = 0; //相差月份个数
        try {
            differenceBetweenMonth = DateUtil.countMonths("2014-01", currentTime.getYear() + "-" + currentTime.getMonth(), "yyyy-MM"); // 获取2014年1月到现在相差多少个月
        } catch (Exception e) {
            e.printStackTrace();
        }
        int startYear = 2014; // 开始时间2014年
        int startMonth = 1; // 1月
        int startday = 1; // 第一天
        for (int i = 0; i <= differenceBetweenMonth; i++) {
            if (startMonth > 12) {
                startYear += 1;
                startMonth = 1;
            }
            CalendarDetailFragment fragment = new CalendarDetailFragment();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, new CustomDate(startYear, startMonth, startday));
            bundle.putInt("fragmentPosition", i);
            fragment.setArguments(bundle);
            calendarFragments.add(fragment);
            startMonth += 1;
        }
        mCurrentIndex = savedInstanceState != null ? savedInstanceState.getInt("position") : calendarFragments.size() - 1;
        calendarViewPagaer.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                try {
                    if (showCalendarScrollGuiding) { //如果在显示日历滑动引导页 则滑动后需要隐藏,并且标识已滑动过的标识
                        hideGuideView(getView().findViewById(R.id.calendar_scroll_guide_text), 1);
                    }
                    mCurrentIndex = position;
                    dateLeftArrows.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
                    dateRightArrows.setVisibility(position == calendarFragments.size() - 1 ? View.INVISIBLE : View.VISIBLE);
                    CalendarDetailFragment calendarDetailFragment = (CalendarDetailFragment) (calendarFragments.get(position));
                    calendarDetailFragment.refreshData(); //每次滑动ViewPager则重新加载数据
                    setTitleDate(calendarDetailFragment.getmShowDate().year + "", calendarDetailFragment.getmShowDate().month);
                    calendarViewPagaer.resetHeight(position);
                } catch (Exception e) {
                    e.getMessage();
                    LUtils.e(e.toString());
                }
            }

            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        calendarViewPagaer.setAdapter(new CalendarViewPagerAdapter(getActivity().getSupportFragmentManager(), calendarFragments));
        calendarViewPagaer.setCurrentItem(mCurrentIndex);

        CustomDate date = (CustomDate) calendarFragments.get(mCurrentIndex).getArguments().getSerializable(Constance.BEAN_CONSTANCE);
        setTitleDate(date.year + "", date.month);

        calendarViewPagaer.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                if (calendarViewPagaer.getHeight() == 0 || calendarViewPagaer.getWidth() == 0) {
                    return;
                }
                setAdapter();
                if (Build.VERSION.SDK_INT >= 16) {
                    calendarViewPagaer.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                } else {
                    calendarViewPagaer.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                }
            }
        });
    }


    private void setTitleDate(String year, int month) {
        dateText.setText(year + "年" + month + "月");
    }


    @Override
    public void onClick(View v) {
        int id = v.getId();
        Intent intent = null;
        switch (id) {
            case R.id.my_group_layout: //我的项目组班组
                intent = new Intent(getActivity(), MyGroupTeamActivity.class);
                break;
            case R.id.net_fail_Layout: //网络连接失败
                intent = new Intent(getActivity(), NetFailActivity.class);
                break;
            case R.id.notes_icon: //记事本
                if (showNotesGuiding) {
                    hideGuideView(getView().findViewById(R.id.notes_guide_icon), 2);
                }
                intent = new Intent(getActivity(), NoteBookListActivity.class);
                break;
            case R.id.navigation_roler_text: //切换角色
                intent = new Intent(getActivity(), ChooseRoleActivity.class);
                intent.putExtra(Constance.BEAN_BOOLEAN, false);
                break;
            case R.id.title: //日历时间选择框
                CalendarDetailFragment fragme = (CalendarDetailFragment) calendarFragments.get(mCurrentIndex);
                WheelViewSelectYearAndMonth selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(getActivity(), new YearAndMonthClickListener() {
                    @Override
                    public void YearAndMonthClick(String year, String month) {
                        try {
                            int count = DateUtil.countMonths("2014-01", year + "-" + month, "yyyy-MM");
                            calendarViewPagaer.setCurrentItem(count);
                            setTitleDate(year, Integer.parseInt(month));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }, fragme.getmShowDate().year, fragme.getmShowDate().month);
                selecteYearMonthPopWindow.showAtLocation(getActivity().getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
                break;
            case R.id.date_left_arrow_icon: //点击回到上个月
                if (mCurrentIndex == 0) {
                    return;
                }
                calendarViewPagaer.setCurrentItem(mCurrentIndex - 1);
                break;
            case R.id.date_right_arrow_icon://点击去到下个月
                if (mCurrentIndex == calendarFragments.size() - 1) {
                    return;
                }
                calendarViewPagaer.setCurrentItem(mCurrentIndex + 1);
                break;
            case R.id.borrow_balance_btn: //借支,结算按钮
                if (showDiffRolerDialog(v.getId(), null)) {
                    return;
                }
                NewAccountActivity.actionStart(getActivity(), true);
                break;
            case R.id.record_account_red_btn: //如果是工头则是批量记工，如果是工人则是记一笔工
                if (showDiffRolerDialog(v.getId(), null)) {
                    return;
                }
                if (UclientApplication.isForemanRoler(getActivity())) {
                    GetGroupAccountActivity.actionStart(getActivity(), true, null);
                } else {
                    NewAccountActivity.actionStart(getActivity(), false);
                }
                break;
            case R.id.record_account_right_btn://如果是工头则是记一笔工，如果是工人则是批量记多天
                if (showDiffRolerDialog(v.getId(), null)) {
                    return;
                }
                if (UclientApplication.isForemanRoler(getActivity())) {
                    NewAccountActivity.actionStart(getActivity(), false);
                } else {
                    SingleBatchAccountActivity.actionStart(getActivity(), null, null, null, null, null, AccountUtil.HOUR_WORKER_INT);
                }
                break;
        }
        if (intent != null) {
            getActivity().startActivityForResult(intent, Constance.REQUEST);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
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
        //设置我要对账的个数
        setItemRedTips(CHECK_ACCOUNT_TAG, bean.getWait_confirm_num() > 0 ? bean.getWait_confirm_num() + "" : null, false);
        //1表示有同步给我的数据 需要显示
        setItemShowRedDot(SYNC_WORK, bean.getIs_red_flag() == 1, false);
        //1表示上次记账的角色和本次不同 弹出是否需要切换角色的提示
        isDiffRole = bean.getIs_diff_role() == 1;
        if (adapter != null) {
            adapter.notifyDataSetChanged();
        }
    }

    /**
     * @param viewId 如果viewId为-1 表示是从记账日历上面点击日历跳转的页面
     * @param cell   单元格数据 如果不是从单元格上面点击过来的则不用传这个参数
     * @return
     */
    public boolean showDiffRolerDialog(final int viewId, final CalendarDetailFragment.Cell cell) {
        if (isDiffRole && !isLoadChangeRolerDialog) {
            isLoadChangeRolerDialog = true;
            final boolean isForeman = UclientApplication.isForemanRoler(getActivity().getApplicationContext());
            DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(getActivity(), null, null, new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                @Override
                public void clickLeftBtnCallBack() {
                    switch (viewId) {
                        case R.id.borrow_balance_btn: //借支,结算按钮
                            NewAccountActivity.actionStart(getActivity(), true);
                            break;
                        case R.id.record_account_red_btn: //如果是工头则是批量记工，如果是工人则是记一笔工
                            if (UclientApplication.isForemanRoler(getActivity())) {
                                GetGroupAccountActivity.actionStart(getActivity(), true, null);
                            } else {
                                NewAccountActivity.actionStart(getActivity(), false);
                            }
                            break;
                        case R.id.record_account_right_btn://如果是工头则是记一笔工，如果是工人则是批量记多天
                            if (UclientApplication.isForemanRoler(getActivity())) {
                                NewAccountActivity.actionStart(getActivity(), false);
                            } else {
                                SingleBatchAccountActivity.actionStart(getActivity(), null, null, null, null, null, AccountUtil.HOUR_WORKER_INT);
                            }
                            break;
                        case -1://点击记账日历上面的按钮
                            /**
                             * 如果当天有记工记录，则进入{每日考勤表}页面
                             * 如果当天无记工记录，则进入{添加记工}页面
                             */
                            String year = cell.date.year + "";
                            String month = cell.date.month < 10 ? "0" + cell.date.month : cell.date.month + "";
                            String day = cell.date.day < 10 ? "0" + cell.date.day : cell.date.day + "";
                            if (cell.recordAccount != null) {
                                String selecteDate = year + "-" + month + "-" + day; //当前选中的时间
                                EveryDayAttenDanceActivity.actionStart(getActivity(), selecteDate);
                            } else {
                                NewAccountActivity.actionStart(getActivity(), year + "" + month + "" + day);
                            }
                            break;
                    }
                }

                @Override
                public void clickRightBtnCallBack() {
                    CommonHttpRequest.changeRoler(getActivity(), false, isForeman ? Constance.ROLETYPE_WORKER : Constance.ROLETYPE_WORKER, null);
                }
            });
            dialogLeftRightBtnConfirm.setRightBtnText(getString(isForeman ? R.string.change_roler_worker : R.string.change_roler_foreman));
            dialogLeftRightBtnConfirm.setLeftBtnText(getString(R.string.no_change_role));
            dialogLeftRightBtnConfirm.setHtmlContent(isForeman ?
                    Utils.getHtmlColor666666("你当前是") + Utils.getHtmlColor000000("&nbsp;【班组长】<br/>") + Utils.getHtmlColor666666("与上一次记工身份不一致，是否切换？") :
                    Utils.getHtmlColor666666("你当前是") + Utils.getHtmlColor000000("&nbsp;【工人】<br/>") + Utils.getHtmlColor666666("与上一次记工身份不一致，是否切换？"));
            dialogLeftRightBtnConfirm.show();
            return true;
        }
        return false;
    }


    public void setItemRedTips(int item, String value, boolean isRefresh) {
        if (adapter != null && adapter.getCount() > 0) {
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
    }

    public void setItemShowRedDot(int item, boolean isShow, boolean isRefresh) {
        if (adapter != null && adapter.getCount() > 0) {
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
    }

    public ResetHeightViewPager getCalendarViewPagaer() {
        return calendarViewPagaer;
    }


    public void handlerBroadcastData(String action, Intent intent) {
        switch (action) {
            case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS: //加载首页Http数据成功后的回调
                if (isFront) { //如果是在首页页面的话 直接刷新本地数据
                    loadLocalDataBaseData();
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isUpdateLocalGroupInfo = true;
                }
                break;
            case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR: //加载首页http数据失败后的回调
                if (isFront) { //如果是在首页页面的话 直接刷新本地数据
                    loadLocalDataBaseData();
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isUpdateLocalGroupInfo = true;
                }
                break;
            case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST://当接收到这个广播的时候如果停留在当前页面则刷新本地列表数据，否则设置标识在onResume里刷新本地数据
            case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN:
                if (isFront) { //如果是在首页页面的话 直接刷新本地数据
                    loadLocalDataBaseData();
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isUpdateLocalGroupInfo = true;
                }
                break;
            case WebSocketConstance.CANCEL_CHAT_MAIN_INDEX_SUCCESS:
                isRequestServer = false;
                break;
            case WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST://当接收到这个广播的时候如果停留在当前页面则重新调用Http获取首页数据,否则设置标识在onResume里调用Http数据
                if (isFront) {
                    MessageUtil.getWorkCircleData(getActivity());
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isRequestServer = true;
                }
                break;
            case ConnectivityManager.CONNECTIVITY_ACTION: //网络状态发生变化时候的调用
                netFailLayout.setVisibility(intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false) ? View.GONE : View.VISIBLE);
                break;
            case Constance.ACCOUNT_INFO_CHANGE: //记账信息发生变化
                LUtils.e("切换角色");
                for (Fragment fragment : calendarFragments) {
                    if (fragment != null) {
                        CalendarDetailFragment detailFragment = (CalendarDetailFragment) fragment;
                        if (!detailFragment.isRefreshCellDate() && !fragment.isHidden()) {
                            detailFragment.clearCellDate(true);
                        }
                        //设置刷新数据的标识
                        detailFragment.setRefreshCellDate(true);
                    }
                }
                if (Utils.isTopActivity(getActivity())) { //停留在当前页面的只需要刷新当前的数据就OK了
                    ((CalendarDetailFragment) (calendarFragments.get(mCurrentIndex))).refreshData();
                }
                break;
        }
    }

//    /**
//     * 计算导航栏右边记事本图标引导页位置
//     *
//     * @param notesStatus 2表示已记过记事本信息
//     *                    1表示未记过记事本信息
//     */
//    public void checkNotesGuide(final int notesStatus) {
//        //将记事本引导图标放在这个图标下
//        final ImageView notesIcon = getView().findViewById(R.id.notes_icon);
//        notesIcon.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
//            public void onGlobalLayout() {
//                if (notesIcon.getHeight() == 0 || notesIcon.getWidth() == 0) {
//                    return;
//                }
//                //记事本引导图标
//                ImageView notesGuideIcon = getView().findViewById(R.id.notes_guide_icon);
//                notesGuideIcon.setImageResource(notesStatus == 1 ? R.drawable.main_notes_un_record_guide : R.drawable.main_notes_recorded_guide);
//                int[] localtion = ScreenUtils.getLocationOnScreenUnContainsStatusHeight(getActivity().getApplicationContext(), notesIcon);
//                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) notesGuideIcon.getLayoutParams();
//                //将图标放在记事本的中间位置对齐记事本中间的事字
//                params.rightMargin = ((RelativeLayout.LayoutParams) notesIcon.getLayoutParams()).rightMargin - DensityUtil.dp2px(6);
//                //将引导页放在记事本图标的下面5dp的位置
//                params.topMargin = localtion[1] + notesIcon.getHeight() + DensityUtil.dp2px(3);
//                notesGuideIcon.setLayoutParams(params);
//                notesGuideIcon.setVisibility(View.VISIBLE);
//                showNotesGuiding = true;
//                if (Build.VERSION.SDK_INT >= 16) {
//                    notesIcon.getViewTreeObserver().removeOnGlobalLayoutListener(this);
//                } else {
//                    notesIcon.getViewTreeObserver().removeGlobalOnLayoutListener(this);
//                }
//            }
//        });
//    }


    /**
     * 计算滑动引导页位置
     */
    public void checkScrollGuide() {
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                //当首页弹框显示完毕后 如果首页菜单模块还未加载完毕则循环直到加载完毕
                while (!loadedMenuLayoutFinish) {
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        int count = (int) SPUtils.get(getActivity().getApplicationContext(), "scroll_guide_count", 0, Constance.JLONGG);
                        if (count <= 5 && isShowScrollGuide) {
                            //列表滑动引导图标布局
                            getView().findViewById(R.id.scroll_guide_layout).setVisibility(View.VISIBLE);
                            View scrollPointLayout = getView().findViewById(R.id.scroll_point_icon);
                            ObjectAnimator translateAnimation = ObjectAnimator.ofFloat(scrollPointLayout, "translationY", 0, DensityUtil.dp2px(5)).setDuration(1000);
                            translateAnimation.setRepeatCount(Integer.MAX_VALUE);
                            translateAnimation.setRepeatMode(android.animation.ObjectAnimator.REVERSE);
                            translateAnimation.start();
                            CalendarMainFragment.this.translateAnimation = translateAnimation;
                            showScrollGuiding = true;
                        }
                    }
                });
            }
        });
    }

    /**
     * 检查日历滑动的引导页
     */
    public void checkCalendarScrollGuide() {
        //true表示已经滑动过了日历
        boolean showCalendarScrollGuide = (boolean) SPUtils.get(getActivity().getApplicationContext(), "is_show_calendar_scroll_guide", false, Constance.JLONGG);
        if (showCalendarScrollGuide) {
            return;
        }
        //检查日历是否已显示过滑动动画
        getView().findViewById(R.id.below_calendar_text_tips).setVisibility(View.GONE);
        getView().findViewById(R.id.calendar_scroll_guide_text).setVisibility(View.VISIBLE);
        showCalendarScrollGuiding = true;
    }


//    /**
//     * 获取记事本状态是否已记过
//     */
//    public void getNoteBookStatus() {
//        //true表示已经点过了记事本
//        if ((boolean) SPUtils.get(getActivity().getApplicationContext(), "is_show_notes_guide", false, Constance.JLONGG)) {
//            return;
//        }
//        //2表示已记过记事本信息
//        //1表示未记过记事本信息
//        final int notesStatus = (int) SPUtils.get(getActivity().getApplicationContext(), "notes_status", 0, Constance.JLONGG);
//        if (notesStatus == 0) { //如果等于0表示还未请求过 记事本列表数据
//            RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity().getApplicationContext());
//            params.addBodyParameter("pg", "1");
//            params.addBodyParameter("pagesize", "20");
//            String httpUrl = NetWorkRequest.GET_NOTEBOOK_LIST;
//            CommonHttpRequest.commonRequest(getActivity(), httpUrl, NoteBook.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
//                @Override
//                public void onSuccess(Object object) {
//                    ArrayList<NoteBook> list = (ArrayList<NoteBook>) object;
//                    if (list != null && list.size() > 0) {
//                        //2表示已记过记事本信息
//                        //1表示未记过记事本信息
//                        SPUtils.put(getActivity().getApplicationContext(), "notes_status", 2, Constance.JLONGG);
//                        checkNotesGuide(2);
//                    } else {
//                        SPUtils.put(getActivity().getApplicationContext(), "notes_status", 1, Constance.JLONGG);
//                        checkNotesGuide(1);
//                    }
//                }
//
//                @Override
//                public void onFailure(HttpException exception, String errormsg) {
//                }
//            });
//        } else {
//            checkNotesGuide(notesStatus);
//        }
//    }

    /**
     * 检查功能引导页 状态
     */
    public void checkGuide() {
//        getNoteBookStatus();
        checkCalendarScrollGuide();
        checkScrollGuide();
    }

    /**
     * 隐藏引导页
     *
     * @param guideView
     * @param guideType 1.表示隐藏日历滑动页 2.表示隐藏记事本 3.表示隐藏滑动
     * @param
     */
    public void hideGuideView(final View guideView, final int guideType) {
        switch (guideType) {
            case 1:
                showCalendarScrollGuiding = false;
                SPUtils.put(getActivity().getApplicationContext(), "is_show_calendar_scroll_guide", true, Constance.JLONGG); // 存放Token信息
                break;
            case 2:
                showNotesGuiding = false;
                SPUtils.put(getActivity().getApplicationContext(), "is_show_notes_guide", true, Constance.JLONGG);
                break;
            case 3:
                showScrollGuiding = false;
                LUtils.e("关闭滑动引导");
                if (translateAnimation != null) {
                    translateAnimation.cancel();
                    translateAnimation = null;
                    LUtils.e("关闭滑动动画");
                }
                break;
        }

        if (guideView != null) {
            ObjectAnimator alphaAnimation = ObjectAnimator.ofFloat(guideView, "alpha", 1.0f, 0.0f).setDuration(800);
            alphaAnimation.addListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationCancel(Animator animation) {
                    super.onAnimationCancel(animation);
                }

                @Override
                public void onAnimationEnd(Animator animation) {
                    super.onAnimationEnd(animation);
                    if (guideType == 1) {
                        getView().findViewById(R.id.below_calendar_text_tips).setVisibility(View.VISIBLE);
                    }
                    guideView.setVisibility(View.GONE);
                }

                @Override
                public void onAnimationRepeat(Animator animation) {
                    super.onAnimationRepeat(animation);
                }

                @Override
                public void onAnimationStart(Animator animation) {
                    super.onAnimationStart(animation);
                }
            });
            alphaAnimation.start();
        }
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
//        super.onSaveInstanceState(outState);
        outState.putInt("position", mCurrentIndex);
    }

    public RecordWorkPoints getPrestrainData() {
        return prestrainData;
    }
}

