package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.TextView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.adpter.CalendarViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RecordWorkPoints;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.SyncInfo;
import com.jizhi.jlongg.main.dialog.AccountFlowGuideDialog;
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
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.ResetHeightViewPager;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;

import static com.jizhi.jlongg.R.id.rootLayout;

/**
 * 功能:日历记账详情
 * 时间:2017年2月9日16:43:15
 * 作者:xuj
 */
public class CalendarDetailActivity extends BaseActivity implements View.OnClickListener {
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
     * 未结工资金额
     */
    private TextView salaryMoney;
    /**
     * 记工显示方式文本
     */
    private TextView accountTypeText;
    /**
     * 我要对账的数量
     */
    private TextView unreadCheckAccountCount;
    /**
     * 是否从当前页面登录了
     */
    private boolean isLoginFromThisActivity;
    /**
     * VierPager 当前滑动位置
     */
    private int mCurrentIndex;
    /**
     * 结束动画,是否在加载动画
     */
    private boolean isFirstEnter = true;
    /**
     * 1表示有同步给我的数据 需要显示
     */
    private View isSyncToMeRedCircle;

    private Share share;
    /**
     * 是否已加载了切换身份弹出框
     * 当本次角色和和上次记账角色不相同的时候需要弹出提示框
     */
    private boolean isLoadChangeRolerDialog;

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
        setContentView(R.layout.record_calendar);
        initView();
        loadAccountFlowGuide();
    }

    /**
     * 加载记工流水动画
     */
    private void loadAccountFlowGuide() {
        String key = "show_flow_guide_" + AppUtils.getVersionName(getApplicationContext());
        // 是否显示记工流水动画
        boolean isShow = (boolean) SPUtils.get(getApplicationContext(), key, false, Constance.JLONGG);
        if (!isShow) {
            final View viewPager = findViewById(R.id.viewPager);
            viewPager.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕 设置背景图片的高度和宽度
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                    if (viewPager.getHeight() == 0) {
                        return;
                    }
                    final int[] location = new int[2];
                    findViewById(R.id.workFlowLayout).getLocationOnScreen(location);
                    int marginTop = location[1] - DensityUtils.getStatusHeight(getApplicationContext());
                    new AccountFlowGuideDialog(CalendarDetailActivity.this, marginTop).show();
                    if (Build.VERSION.SDK_INT < 16) {
                        viewPager.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        viewPager.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
            SPUtils.put(getApplicationContext(), key, true, Constance.JLONGG); // 存放Token信息
        }
    }


    private void initView() {
        setTextTitleAndRight(R.string.recordMerit, R.string.record_problem);
        //获取当前角色
        String currentRole = UclientApplication.getRoler(this);
        salaryMoney = getTextView(R.id.unBalanceAmounts);
        unreadCheckAccountCount = getTextView(R.id.unread_check_account_count);
        accountTypeText = getTextView(R.id.accountTypeText);
        isSyncToMeRedCircle = findViewById(R.id.is_red_flag);
        dateText = getTextView(R.id.title);
        mViewPager = (ResetHeightViewPager) findViewById(R.id.viewPager);
        View foremanRecordBtnLayout = findViewById(R.id.foremanRecordBtnLayout);
        View recordOneAccount = findViewById(R.id.recordOneAccount); //在记一笔按钮
        TextView salaryTips = getTextView(R.id.unBalanceTips);
        TextView personManagerDesc = getTextView(R.id.personManagerDesc);
        accountTypeText.setText(AccountUtil.getCurrentAccountType(getApplicationContext()));

        if (currentRole.equals(Constance.ROLETYPE_WORKER)) { //当前角色是工友
            salaryTips.setText("未结工资");
            personManagerDesc.setText("管理及评价班组长");
            findViewById(R.id.synclayout).setVisibility(View.GONE); //隐藏同步账单数据
            findViewById(R.id.syncItem).setVisibility(View.GONE);
            recordOneAccount.setVisibility(View.VISIBLE); //显示马上记一笔按钮
            foremanRecordBtnLayout.setVisibility(View.GONE);
            getTextView(R.id.personManager).setText(R.string.foremans);
        } else {
            personManagerDesc.setText("管理及评价工人");
            salaryTips.setText("未结工人工资");
            recordOneAccount.setVisibility(View.GONE); //隐藏马上记一笔按钮
            foremanRecordBtnLayout.setVisibility(View.VISIBLE);
            getTextView(R.id.personManager).setText(R.string.worker_manager);
        }

        findViewById(R.id.leftIcon).setOnClickListener(this);
        findViewById(R.id.rightIcon).setOnClickListener(this);


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
                //未完善姓名的用户不能查看日历数据
//                if (!IsSupplementary.isFillRealNameCallBackListener(CalendarDetailActivity.this, false, null)) {
//                    mViewPager.setCurrentItem(mCurrentIndex);
//                    return;
//                }
                try {
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
                selecteYearMonthPopWindow.showAtLocation(findViewById(rootLayout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
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
            case R.id.workStatistical: //记工统计 原(工资清单)
//                StatisticalWorkActivity.actionStart(this);
                StatisticalWorkFirstActivity.actionStart(this);
                break;
            case R.id.workFlow: //记工流水
                CalendarDetailFragment fragment = (CalendarDetailFragment) fragments.get(mCurrentIndex);
                CustomDate showDate = fragment.getmShowDate();
                if (showDate == null) {
                    showDate = new CustomDate();
                }
                RememberWorkerInfosActivity.actionStart(this, showDate.getYear() + "", showDate.month < 10 ? "0" + showDate.month : String.valueOf(showDate.month), UclientApplication.getRoler(CalendarDetailActivity.this));
                break;
            case R.id.syncBill: //同步账单
                //是否已完善了姓名
//                IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
//                    @Override
//                    public void onSuccess() {
//                        goSyncActivity();
//                    }
//                });
                break;
            case R.id.syncBillToMe: //同步给我的
                if (!IsSupplementary.isFillRealNameIntentActivity(this, false, SyncRecordToMeActivity.class)) {
                    return;
                }
                break;
            case R.id.balanceOfAccount: //我要对账
                if (!IsSupplementary.isFillRealNameIntentActivity(this, false, RecordWorkConfirmActivity.class)) {
                    return;
                }
                break;
            case R.id.recordOneAccount: //工人马上记一笔按钮
                NewAccountActivity.actionStart(this, false);
                break;
            case R.id.recordSingleBtn: //工头记单笔按钮
                NewAccountActivity.actionStart(this, false);
                break;
            case R.id.recordMultipartBtn: //工头一天记多人按钮
                GetGroupAccountActivity.actionStart(this, true, null);
                break;
            case R.id.unBalanceLayout: //未结工资
                UnBalanceActivity.actionStart(this);
                break;
            case R.id.right_title: //记工常见问题
                HelpCenterUtil.actionStartHelpActivity(CalendarDetailActivity.this, 208);
                break;
            case R.id.like: //点个赞
                new ReWardDialog(this).show();
                break;
            case R.id.personManagerLayout: //工人工头管理
                ForemanWorkerManagerActivity.actionStart(this);
                break;
            case R.id.recommendOther: //推荐给他人
                ShowShare();
                break;
            case R.id.sundryDayIcon: //晒工天
                //是否已完善了姓名
//                IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
//                    @Override
//                    public void onSuccess() {
//                        X5WebViewActivity.actionStart(CalendarDetailActivity.this, NetWorkRequest.WEBURLS + "workday");
//                    }
//                });
                break;
            case R.id.showAccountType: //切换记账显示方式
                AccountShowTypeActivity.actionStart(CalendarDetailActivity.this);
                break;
        }
    }

    public void ShowShare() {
        share = new Share();
        share.setTitle("1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！");
        share.setDescribe("我正在用招工找活、记工记账神器：吉工家APP");
        share.setUrl(NetWorkRequest.WEBURLS + "page/open-invite.html?uid=" + UclientApplication.getUid(CalendarDetailActivity.this) + "&plat=person");
        share.setImgUrl(NetWorkRequest.IP_ADDRESS + "media/default_imgs/logo.jpg");
        //微信小程序相关内容
        share.setAppId("gh_89054fe67201");
        share.setPath("/pages/work/index?suid=" + UclientApplication.getUid(CalendarDetailActivity.this));
        share.setWxMiniDrawable(2);
        if (Build.VERSION.SDK_INT >= 23) {
            String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
            ActivityCompat.requestPermissions(CalendarDetailActivity.this, mPermissionList, Constance.REQUEST);
        } else {
            showShareDialog();
        }
    }


    /**
     * 分享弹窗
     */
    public void showShareDialog() {
//        CustomShareDialog dialog = new CustomShareDialog(CalendarDetailActivity.this, true, share);
//        dialog.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
//        BackGroundUtil.backgroundAlpha(CalendarDetailActivity.this, 0.5F);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        if (requestCode == Constance.REQUEST) {
            showShareDialog();
        }
    }


    private void goSyncActivity() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pg", "1"); //当前页
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //分页编码
        String httpUrl = NetWorkRequest.SYNCED_TARGET_LIST;
        CommonHttpRequest.commonRequest(this, httpUrl, SyncInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<SyncInfo> list = (ArrayList<SyncInfo>) object;
                if (list != null && list.size() > 0) {
                    SyncReocrdAccountActivity.actionStart(CalendarDetailActivity.this);
                } else {
                    SelecteSyncTypeActivity.actionStart(CalendarDetailActivity.this);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.LOGIN_SUCCESS) {
            isLoginFromThisActivity = true;
        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
//            setResult(Constance.SAVE_BATCH_ACCOUNT, data);
//            finish();
        } else if (resultCode == Constance.SYNC_SUCCESS) {
            SyncReocrdAccountActivity.actionStart(CalendarDetailActivity.this);
        }
//        else if (resultCode == Constance.SWITCH_ROLER) { //切换了角色
//            setResult(Constance.SWITCH_ROLER);
//            finish();
//        }
        else if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE) {
            accountTypeText.setText(AccountUtil.getCurrentAccountType(getApplicationContext()));
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊聊天
            setResult(resultCode, data);
            finish();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        }
    }


    @Override
    public void onFinish(View view) {
        if (isLoginFromThisActivity) {
            setResult(Constance.LOGIN_SUCCESS);
        }
        super.onFinish(view);
    }


    @Override
    public void onBackPressed() {
        if (isLoginFromThisActivity) {
            setResult(Constance.LOGIN_SUCCESS);
        }
        super.onBackPressed();
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
                salaryMoney.setText(bean.getB_total().getTotal() + bean.getB_total().getUnit());
            }
        }
        if (bean.getWait_confirm_num() > 0) {
            unreadCheckAccountCount.setVisibility(View.VISIBLE);
            unreadCheckAccountCount.setText(bean.getWait_confirm_num() + "");
        } else {
            unreadCheckAccountCount.setVisibility(View.GONE);
        }
        isSyncToMeRedCircle.setVisibility(bean.getIs_red_flag() == 1 ? View.VISIBLE : View.GONE);
//        if (bean.getIs_diff_role() == 1 && !isLoadChangeRolerDialog) {//1表示上次记账的角色和本次不同 弹出是否需要切换角色的提示
//            isLoadChangeRolerDialog = true;
//            new DialogTips(CalendarDetailActivity.this, new DiaLogTitleListener() {
//                @Override
//                public void clickAccess(int position) {
//                    ChooseRoleActivity.actionStart(CalendarDetailActivity.this, false);
//                }
//            }, UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ?
//                    "当前是班组长身份，你上一笔记账是以工人身份记录的，是否切换身份。" :
//                    "当前是工人身份，你上一笔记账是以班组长身份记录的，是否切换身份。", "去切换身份", DialogTips.CLOSE_TEAM).show();
//        }
    }


    public ResetHeightViewPager getmViewPager() {
        return mViewPager;
    }


}
