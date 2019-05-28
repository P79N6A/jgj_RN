package com.jizhi.jlongg.main.strategy;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.CreateTeamGroupActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.activity.StatisticalWorkFirstActivity;
import com.jizhi.jlongg.main.activity.UnBalanceActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;

import static android.view.View.GONE;

/**
 * 班组、项目组策略
 *
 * @author Xuj
 * @time 2018年6月19日14:29:38
 * @Version 1.0
 */
public class AccountStrategy extends MainStrategy {

    /**
     * 加载的三种状态
     * 0表示加载成功，没有班组和项目组信息
     * 1表示加载失败，需要显示加载失败的布局
     * 2表示加载中，需要显示加载中的布局
     */
    public static final int LOADING_STATE = 2;
    public static final int LOAD_FAIL_STATE = 1;
    public static final int LOAD_SUCCESS_STATE = 0;

    /**
     * activity
     */
    private BaseActivity activity;
    /**
     * 记工流水
     */
    private TextView workFlow;
    /**
     * 记工统计
     */
    private TextView workStatistical;
    /**
     * 未结工资
     */
    private TextView unBalance;
    /**
     * 我要对账
     */
    private TextView balanceOfAccount;
    /**
     * 本月上班时间
     */
    private TextView monthNormalTimeText;
    /**
     * 本月加班时长
     */
    private TextView monthOverTimeText;
    /**
     * 今日上班时长
     */
    private TextView dayNormalTimeText;
    /**
     * 今日加班时长
     */
    private TextView dayOverTimeText;
    /**
     * 创建班组
     */
    private TextView createGroupBtn;
    /**
     * 扫描二维码
     */
    private TextView scanBtn;
    /**
     * 无班组，项目组时展示的布局
     */
    private View noGroupLayout;
    /**
     * 加载首页时的页面
     */
    private View loadingProgressbar;
    /**
     * 加载首页失败后的页面
     */
    private View loadFailLayout;
    /**
     * 加载中班组，项目组的布局
     */
    private View loadingGroupLayout;
    /**
     * 加载的三种状态
     * 0表示加载成功，没有班组和项目组信息
     * 1表示加载失败，需要显示加载失败的布局
     * 2表示加载中，需要显示加载中的布局
     */
    private int load_state = LOADING_STATE;


    public AccountStrategy(BaseActivity activity) {
        this.activity = activity;
    }


    @Override
    public View getView(LayoutInflater inflater) {
        View convertView = inflater.inflate(R.layout.main_account_no_data_item, null, false);
        setView(convertView);
        return convertView;
    }

    @Override
    void setView(View convertView) {
        noGroupLayout = convertView.findViewById(R.id.no_group_layout);
        loadingProgressbar = convertView.findViewById(R.id.loading_progressbar);
        loadFailLayout = convertView.findViewById(R.id.load_fail_layout);
        loadingGroupLayout = convertView.findViewById(R.id.loading_group_layout);
        workFlow = (TextView) convertView.findViewById(R.id.workFlow);
        workStatistical = (TextView) convertView.findViewById(R.id.workStatistical);
        unBalance = (TextView) convertView.findViewById(R.id.unBalance);
        balanceOfAccount = (TextView) convertView.findViewById(R.id.balanceOfAccount);
        monthNormalTimeText = (TextView) convertView.findViewById(R.id.monthNormalTime);
        monthOverTimeText = (TextView) convertView.findViewById(R.id.monthOverTime);
        dayNormalTimeText = (TextView) convertView.findViewById(R.id.dayNormalTime);
        dayOverTimeText = (TextView) convertView.findViewById(R.id.dayOverTime);
        createGroupBtn = (TextView) convertView.findViewById(R.id.createGroupBtn);
        scanBtn = (TextView) convertView.findViewById(R.id.scanBtn);
        unBalance.setText(UclientApplication.getRoler(activity.getApplicationContext()).equals(Constance.ROLETYPE_WORKER) ? "未结工资" : "未结工人工资");
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.workFlow: //记工流水
                        IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
                            @Override
                            public void onSuccess() {
                                CustomDate showDate = new CustomDate();
                                RememberWorkerInfosActivity.actionStart(activity, showDate.getYear() + "", showDate.month < 10 ? "0" + showDate.month : String.valueOf(showDate.month));
                            }
                        });
                        break;
                    case R.id.workStatistical: //记工统计
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, StatisticalWorkFirstActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.unBalance: //未结工资
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, UnBalanceActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.balanceOfAccount: //我要对账
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, RecordWorkConfirmActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.createGroupBtn: //新建项目
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, CreateTeamGroupActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.scanBtn: //扫描二维码
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, CaptureActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.load_fail_layout: //加载失败重新刷新首页数据
                        loadingGroupLayout.setVisibility(View.VISIBLE);
                        loadingProgressbar.setVisibility(View.VISIBLE);
                        loadFailLayout.setVisibility(GONE);
                        MessageUtil.getWorkCircleData(activity); //获取首页收据
                        break;
                }
            }
        };
        workFlow.setOnClickListener(onClickListener);
        workStatistical.setOnClickListener(onClickListener);
        unBalance.setOnClickListener(onClickListener);
        balanceOfAccount.setOnClickListener(onClickListener);
        createGroupBtn.setOnClickListener(onClickListener);
        scanBtn.setOnClickListener(onClickListener);
        loadFailLayout.setOnClickListener(onClickListener);
    }

    @Override
    public void bindData(Object object, View convertView, final int position) {
        /**
         * 加载的三种状态
         * 0表示加载成功，没有班组和项目组信息
         * 1表示加载失败，需要显示加载失败的布局
         * 2表示加载中，需要显示加载中的布局
         */
        switch (load_state) {
            case 0://0表示加载成功
                loadingGroupLayout.setVisibility(View.GONE);
                noGroupLayout.setVisibility(View.VISIBLE);
                AccountInfoBean accountInfoBean = (AccountInfoBean) object;
                if (accountInfoBean == null || accountInfoBean.getMonth() == null || accountInfoBean.getToday() == null) {
                    return;
                }
                monthNormalTimeText.setText("上班" + AccountUtil.getAccountShowTypeString(activity, false, true, true, accountInfoBean.getMonth().getManhour(), accountInfoBean.getMonth().getWorking_hours()));
                monthOverTimeText.setText("加班" + AccountUtil.getAccountShowTypeString(activity, false, true, false, accountInfoBean.getMonth().getOvertime(), accountInfoBean.getMonth().getOvertime_hours()));
                dayNormalTimeText.setText("上班" + AccountUtil.getAccountShowTypeString(activity, false, true, true, accountInfoBean.getToday().getManhour(), accountInfoBean.getToday().getWorking_hours()));
                dayOverTimeText.setText("加班" + AccountUtil.getAccountShowTypeString(activity, false, true, false, accountInfoBean.getToday().getOvertime(), accountInfoBean.getToday().getOvertime_hours()));
                break;
            case 1://1表示加载失败
                loadingGroupLayout.setVisibility(View.VISIBLE);
                loadingProgressbar.setVisibility(View.GONE);
                loadFailLayout.setVisibility(View.VISIBLE);
                noGroupLayout.setVisibility(View.GONE);
                break;
            case 2://2表示加载中
                loadingGroupLayout.setVisibility(View.VISIBLE);
                loadingProgressbar.setVisibility(View.VISIBLE);
                loadFailLayout.setVisibility(GONE);
                noGroupLayout.setVisibility(View.GONE);
                break;
        }
    }

    public int getLoad_state() {
        return load_state;
    }

    public void setLoad_state(int load_state) {
        this.load_state = load_state;
    }
}
