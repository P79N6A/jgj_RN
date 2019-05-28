package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.AccountAllEditActivty;
import com.jizhi.jlongg.account.AccountDetailActivity;
import com.jizhi.jlongg.account.AccountEditActivity;
import com.jizhi.jlongg.account.AccountWagesEditActivty;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.adpter.EveryDayAttendanceAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.squareup.otto.Subscribe;

import org.joda.time.DateTime;

import java.util.ArrayList;
import java.util.List;

import noman.weekcalendar.WeekCalendar;
import noman.weekcalendar.eventbus.BusProvider;
import noman.weekcalendar.eventbus.Event;

/**
 * 功能: 每日考勤表
 * 作者：xuj
 * 时间: 2016-6-17 10:53
 */
public class EveryDayAttenDanceActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 日历滑动控件
     */
    private WeekCalendar weekCalendar;
    /**
     * 返回按钮旁文字 主要是滑动时间时动态切换
     */
    private TextView tvDate;
    /**
     * listView 适配器
     */
    private EveryDayAttendanceAdapter adapter;
    /**
     * 页面传递过来的时间
     */
    private String date;
    /**
     * 列表数据
     */
    private List<WorkDetail> list;
    /**
     * 长按点击下标
     */
    private int longClickPosition;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param date    日期  2015-08-02
     */
    public static void actionStart(Activity context, String date) {
        Intent intent = new Intent(context, EveryDayAttenDanceActivity.class);
        intent.putExtra(Constance.DATE, date);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.everydayattendance);
        setTextTitleAndRight(R.string.everyDayTitle, R.string.more);
        initView();
        BusProvider.getInstance().register(this);
        //未完善姓名
        IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {

            }
        });
    }

    private void initView() {
        date = getIntent().getStringExtra(Constance.DATE);
        if (TextUtils.isEmpty(date)) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "日期获取出错", CommonMethod.ERROR);
            finish();
            return;
        }
        weekCalendar = (WeekCalendar) findViewById(R.id.weekCalendar);
        tvDate = (TextView) findViewById(R.id.title);
        getButton(R.id.white_btn).setText("借支/结算");
        getButton(R.id.red_btn).setText("记一笔工");
        getTextView(R.id.defaultDesc).setText("无记账记录");
        TextView defaultDesc1Text = getTextView(R.id.defaultDesc1);
        defaultDesc1Text.setText("数据不丢失,对账有依据!");
        defaultDesc1Text.setVisibility(View.VISIBLE);
        initCalendar();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            adapter.notifyDataSetChanged();
        }
        getData(); //每次回到当前页面都刷新数据
    }

    /**
     * 初始化滚动日历视图
     */
    private void initCalendar() {
        calculateDates();
        jumpDate();
        getData();
    }

    private int year, month, day;

    /**
     * 计算日期
     */
    private void calculateDates() {
        String[] d = date.split("-");
        year = Integer.parseInt(d[0]);
        month = Integer.parseInt(d[1]);
        day = Integer.parseInt(d[2]);
        date = d[0] + d[1] + d[2];
        tvDate.setText(d[0] + "-" + d[1]);
    }


    private void setAdapter(List<WorkDetail> tops) {
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new EveryDayAttendanceAdapter(EveryDayAttenDanceActivity.this, tops, new EveryDayAttendanceAdapter.EveryDayItemClickListener() {
                @Override
                public void itemClick(int position) { //列表点击
                    handlerListItemClick(adapter.getList().get(position), false);
                }

                @Override
                public void deleteAccountInfo(int position) { //删除记账信息

                }

                @Override
                public void itemLongClick(final int longClickPosition) {
                    EveryDayAttenDanceActivity.this.longClickPosition = longClickPosition;
                }

                @Override
                public void expandableItemClick(int groupPosition, int childPosition) {

                }
            });
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(tops);
        }
    }

    /**
     * 处理ListView 子项点击事件
     *
     * @param bean
     */
    private void handlerListItemClick(final WorkDetail bean, boolean isEnterUpdateActivity) {
        //获取记账类型 1 表示点工 2. 表示包工 3. 表示借支 4. 表示结算
        final String accountType = bean.getAccounts_type();
        if (TextUtils.isEmpty(accountType)) { //记账类型为空
            return;
        }
        if (!isEnterUpdateActivity) {
            AccountDetailActivity.actionStart(EveryDayAttenDanceActivity.this, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()),true);
        } else {
            if (accountType.equals(AccountUtil.SALARY_BALANCE)) {
                //结算
                AccountWagesEditActivty.actionStart(this, null, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()), false);
            } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {
                //包工
                AccountAllEditActivty.actionStart(this, null, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()), false);
            } else {
                //点工
                AccountEditActivity.actionStart(this, null, accountType, Integer.parseInt(bean.getId()), UclientApplication.getRoler(getApplicationContext()), false);
            }
        }
    }


    /**
     * 获取每日考勤数据
     */
    public void getData() {
//        if (adapter != null) { //为了保证数据的完整性 请求都清空数据
//            adapter.updateList(null);
//        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("date", date);
        String httpUrl = NetWorkRequest.ERVER_DAY_WORK;
        CommonHttpRequest.commonRequest(this, httpUrl, WorkDetail.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<WorkDetail> list = (ArrayList<WorkDetail>) object;
                EveryDayAttenDanceActivity.this.list = list;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 删除每日考勤记账列表数据
     *
     * @param id
     */
    public void deleteItem(String id) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", id);
        String httpUrl = NetWorkRequest.DELETE_JLWORKDAY;
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                CommonMethod.makeNoticeLong(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                getData();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 跳转到对应的日期
     */
    public void jumpDate() {
        DateTime date = new DateTime(year, month, day, 0, 0);
        weekCalendar.setSelectedDate(date);
    }

    /***
     * Do not use this method
     * this is for receiving date,
     * use "setOndateClick" instead.
     */
    @Subscribe
    public void onDateClick(Event.OnDateClickEvent event) {
        DateTime selectedDate = event.getDateTime();
        StringBuilder builder = new StringBuilder();
        int year = selectedDate.getYear();
        String month = DateUtil.dateToAddZeroDate(selectedDate.getMonthOfYear());
        String day = DateUtil.dateToAddZeroDate(selectedDate.getDayOfMonth());
        builder.append(year + month + day);
        date = builder.toString();
        String showDate = year + "-" + month;
        if (!showDate.equals(tvDate.getText().toString())) {
            tvDate.setText(showDate);
        }
        this.year = year;
        this.month = selectedDate.getMonthOfYear();
        this.day = selectedDate.getDayOfMonth();
        getData();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        try {
            BusProvider.getInstance().unregister(this);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private final String ALL_WORK = "6";
    private final String ITEM_1 = "7";


    public List<SingleSelected> getFileterValue() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(true, true).setSelecteNumber(ITEM_1));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }

    /**
     * 筛选数据
     *
     * @param sortString 分别取值为 1-5
     *                   5、显示全部工种
     *                   1、显示点工
     *                   2、显示包工
     *                   3、显示借支
     *                   4、显示结算
     */
    public void filterData(String sortString) {
        if (list == null || list.size() == 0 || TextUtils.isEmpty(sortString)) {
            return;
        }
        List<WorkDetail> tops = null;
        if (sortString.equals(ALL_WORK)) { //显示全部工种
            tops = list;
        } else {
            for (WorkDetail workDetail : list) {
                String accountType = workDetail.getAccounts_type(); //获取记工类型
                if (TextUtils.isEmpty(accountType)) {
                    return;
                }
                if (accountType.equals(sortString)) {
                    if (tops == null) {
                        tops = new ArrayList<>();
                    }
                    tops.add(workDetail);
                }
            }
        }
        setAdapter(tops);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
//                if (list == null || list.size() == 0) { //没有数据时 不允许筛选
//                    return;
//                }
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getFileterValue(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case ITEM_1: //切换记工显示方式
                                AccountShowTypeActivity.actionStart(EveryDayAttenDanceActivity.this);
                                break;
                            case ALL_WORK: //全部的记工
                                filterData(ALL_WORK);
                                break;
                            case AccountUtil.HOUR_WORKER: //点工
                                filterData(AccountUtil.HOUR_WORKER);
                                break;
                            case AccountUtil.CONSTRACTOR: //包工
                                filterData(AccountUtil.CONSTRACTOR);
                                break;
                            case AccountUtil.BORROWING: //借支
                                filterData(AccountUtil.BORROWING);
                                break;
                            case AccountUtil.SALARY_BALANCE://结算
                                filterData(AccountUtil.SALARY_BALANCE);
                                break;
                            case AccountUtil.CONSTRACTOR_CHECK://包工记工天
                                filterData(AccountUtil.CONSTRACTOR_CHECK);
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.red_btn: //马上记一笔
                NewAccountActivity.actionStart(this, year + DateUtil.dateToAddZeroDate(month) + DateUtil.dateToAddZeroDate(day));
                break;
            case R.id.white_btn://借支结算
                NewAccountActivity.actionStart(this, year + DateUtil.dateToAddZeroDate(month) + DateUtil.dateToAddZeroDate(day), true);
                break;
        }
    }

    //    给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case 1: //删除记账
                DialogOnlyTitle dialogOnlyTitle = new DialogOnlyTitle(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        deleteItem(adapter.getList().get(longClickPosition).getId());
                    }
                }, -1, getString(R.string.delete_account_tips));
                dialogOnlyTitle.setConfirmBtnName(getString(R.string.confirm_delete));
                dialogOnlyTitle.show();
                break;
            case 2: //修改 直接进入记账详情页
                WorkDetail workDetail = adapter.getList().get(longClickPosition);
                handlerListItemClick(workDetail, true);
//                AccountDetailActivity.actionStart(EveryDayAttenDanceActivity.this, workDetail.getAccounts_type(), Integer.parseInt(workDetail.getId()), UclientApplication.getRoler(getApplicationContext()));
                break;
        }
        return super.onOptionsItemSelected(item);
    }
}
