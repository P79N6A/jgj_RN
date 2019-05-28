package com.jizhi.jlongg.main.fragment.worker;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.enumclass.CalendarState;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.EveryDayAttenDanceActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RecordAccount;
import com.jizhi.jlongg.main.bean.RecordWorkPoints;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CalendarUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.ResetHeightViewPager;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * 日期详情
 *
 * @author xuj
 * @version 1.0.2
 * @time 2017年2月9日15:40:05
 */
@SuppressLint("ValidFragment")
public class CalendarDetailFragment extends Fragment {
    /**
     * 当前日历所属的月份
     */
    private CustomDate mShowDate;
    /**
     * 日历适配器
     */
    private CalendarItemAdapter calendarItemAdapter;
    /**
     * true表示刷新列表数据 ,默认是true如果数据刷新成功后则设置成false
     */
    private boolean isRefreshCellDate = true;
    /**
     * 是否是第一次加载数据
     */
    private boolean isFirstLoadData;
    /**
     * 已加载到的缓存数据
     */
    private RecordWorkPoints recordAccount;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser == true) {//可见时执行的操作
            if (mShowDate == null) {
                isFirstLoadData = true;
            }
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.gridview_no_head, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mShowDate = (CustomDate) getArguments().getSerializable(Constance.BEAN_CONSTANCE);
//        LUtils.e("重新调用:" + "   year:" + mShowDate.year + "      month:" + mShowDate.month + "        visible:" + getUserVisibleHint() + "         " + toString() + " isAdded:" + isAdded());
        GridView gridView = (GridView) getView().findViewById(R.id.gridView);
        gridView.setHorizontalSpacing(DensityUtils.dp2px(getActivity(), 1));
        gridView.setVerticalSpacing(DensityUtils.dp2px(getActivity(), 1));
        calendarItemAdapter = new CalendarItemAdapter(getActivity(), getCellData());
        gridView.setAdapter(calendarItemAdapter);
        initViewPagerHeight(gridView);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (StrUtil.isFastDoubleClick()) { //防止按钮被过快的点击
                    return;
                }
                Cell cell = calendarItemAdapter.getList().get(position);
                if (cell != null && cell.state != CalendarState.UNREACH_DAY) { //还未到的天数则不能点击
                    if (cell.recordAccount == null && getBaseActivity().getMainCalendarFragment().showDiffRolerDialog(-1, cell)) {
                        return;
                    }
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
                }
            }
        });
        //首次加载
        if (isFirstLoadData) {
            isFirstLoadData = false;
            //预加载数据
            RecordWorkPoints prestrainData = getBaseActivity().getMainCalendarFragment().getPrestrainData();
            //如果首次进入的时候预加载的数据不为空则取预加载的数据
            if (prestrainData != null) {
                initCellData(prestrainData, getBaseActivity());
            } else {
                refreshData();
            }
        } else {
            if (recordAccount != null && !isRefreshCellDate) {
                initCellData(recordAccount, getBaseActivity());
            } else {
                refreshData();
            }
        }
    }

    private AppMainActivity getBaseActivity() {
        return ((AppMainActivity) getActivity());
    }

    /**
     * 初始化viewpager的高度
     *
     * @param gridView
     */
    private void initViewPagerHeight(final GridView gridView) {
        gridView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
            @Override
            public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                if (getBaseActivity() != null && getBaseActivity().getMainCalendarFragment() != null) {
                    ResetHeightViewPager calendarViewPager = getBaseActivity().getMainCalendarFragment().getCalendarViewPagaer();
                    int currentPosition = getArguments().getInt("fragmentPosition");
                    calendarViewPager.setObjectForPosition(gridView, currentPosition);
                    if (getUserVisibleHint()) { //第一次加载Fragment 重新计算一下ViewPager的高度
                        calendarViewPager.resetHeight(currentPosition);
                    }
                    if (Build.VERSION.SDK_INT < 16) {
                        getView().getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        getView().getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            }
        });
    }

    /**
     * 获取单元格数据
     *
     * @return
     */
    private List<Cell> getCellData() {
        int TOTAL_COL = 7; //7列
        int TOTAL_ROW = 6; //6行
        List<Cell> cells = new ArrayList<>();
        int todayDate = DateUtil.getCurrentMonthDay(); //获取今天的日期
        int currentMonthDays = DateUtil.getMonthDays(mShowDate.year, mShowDate.month);  // 当前月的天数
        int firstDayWeek = DateUtil.getWeekDayFromDate(mShowDate.year, mShowDate.month);
        boolean isCurrentMonth = false;
        if (DateUtil.isCurrentMonth(mShowDate)) {
            isCurrentMonth = true;
        }
        int day = 0;

        for (int j = 0; j < TOTAL_ROW; j++) {
            for (int i = 0; i < TOTAL_COL; i++) {
                int position = i + j * TOTAL_COL; // 单元格位置
                if (position < firstDayWeek) {
                    cells.add(null);
                } else if (position >= firstDayWeek && position < firstDayWeek + currentMonthDays) {
                    day++;
                    Cell cell = new Cell(CustomDate.modifiDayForObject(mShowDate, day), CalendarState.CURRENT_MONTH_DAY, i, j);
                    cells.add(cell);
                    if (isCurrentMonth && day == todayDate) { //今天
                        cell.state = CalendarState.TODAY;
                    } else if (isCurrentMonth && day > todayDate) {//大于今天的日期
                        cell.state = CalendarState.UNREACH_DAY;
                    }
                }
            }
        }
        return cells;
    }

    /**
     * 清空单元格数据 主要是为了当网络延迟时下次查询不会有错误数据
     */
    public void clearCellDate(boolean isNotifyAdapter) {
        List<Cell> cells = calendarItemAdapter.getList();
        for (Cell cell : cells) {
            if (cell == null || cell.state == CalendarState.UNREACH_DAY) { //单元格为空和还未到达的天数的情况
                continue;
            }
            cell.recordAccount = null;
        }
        if (isNotifyAdapter) {
            calendarItemAdapter.notifyDataSetChanged();
        }
    }

    /**
     * 查询当月的记账信息
     */
    public void refreshData() {
        //如果没有完善姓名则不能请求数据
        if (mShowDate == null || !UclientApplication.isHasRealName(getActivity().getApplicationContext()) || !isRefreshCellDate) {
            return;
        }
        final AppMainActivity activity = getBaseActivity();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity.getApplicationContext());
        String month = mShowDate.month >= 10 ? mShowDate.month + "" : "0" + mShowDate.month; //讲2016-01月格式拼接为 1601
        params.addBodyParameter("date", mShowDate.year + month);// 项目id
        String httpUrl = NetWorkRequest.WORKER_MONTH_TOTAL;
        CommonHttpRequest.commonRequest(activity, httpUrl, RecordWorkPoints.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
//                clearCellDate(false);
                RecordWorkPoints recordWorkPoints = (RecordWorkPoints) object;
                CalendarDetailFragment.this.recordAccount = recordWorkPoints;
                initCellData(recordWorkPoints, activity);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }


    private void initCellData(RecordWorkPoints recordIncome, AppMainActivity activity) {
        isRefreshCellDate = false;
        if (activity.getMainCalendarFragment() != null) {
            activity.getMainCalendarFragment().setIncome(recordIncome); //设置记账信息
        }
        if (recordIncome.getList() != null && recordIncome.getList().size() > 0) { //是否有记账的日期
            for (RecordAccount accountDetail : recordIncome.getList()) {
                List<Cell> cells = calendarItemAdapter.getList();
                for (Cell cell : cells) {
                    if (cell == null || cell.state == CalendarState.UNREACH_DAY) {
                        continue;
                    }
                    if (cell.date.day == accountDetail.getDate()) { //如果记账日和当前单元格相等则 设置单元格数据
                        cell.recordAccount = accountDetail;
                        break;
                    }
                }
            }
        }
        calendarItemAdapter.notifyDataSetChanged();
    }

    /**
     * 功能:记账每天记账详情适配器
     * 时间:2017年4月21日16:04:53
     * 作者:xuj
     */
    public class CalendarItemAdapter extends BaseAdapter {
        /**
         * 日历单元格
         */
        private List<Cell> list;
        /**
         * xml 解析器
         */
        private LayoutInflater inflater;

        public CalendarItemAdapter(Context context, List<Cell> list) {
            super();
            this.list = list;
            inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.calendar_month_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }


        private void bindData(ViewHolder holder, int position, View convertView) {
            Cell cell = list.get(position);
            if (cell == null) { //单元格为null
                convertView.setVisibility(View.GONE);
            } else {
                convertView.setVisibility(View.VISIBLE);
                holder.date.setText(String.valueOf(cell.date.day));
                RecordAccount detail = cell.getRecordAccount();
                if (detail != null) { //如果单元格有数据则填充数据
                    holder.lunarCalendar.setVisibility(View.GONE); //有数据的情况下 隐藏农历
                    if (detail.getIs_record() == 0) { //如果这个类型为0 表示当前日期 未记录 点工和包工记工天
                        //1休息表示。 2:表示包工
                        switch (detail.getRwork_type()) {
                            case 1: //休息
                                holder.normalTime.setVisibility(View.VISIBLE);
                                holder.normalTime.setText("休");
                                holder.normalTime.setTextSize(18);
                                holder.normalTime.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_15a153));
                                break;
                            case 2: //包工
                                holder.normalTime.setVisibility(View.VISIBLE);
                                holder.normalTime.setText("包工");
                                holder.normalTime.setTextSize(12);
                                holder.normalTime.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_333333));
                                break;
                            default:
                                holder.normalTime.setVisibility(View.GONE);
                                break;
                        }
                        initCommonInfo(detail, holder);
                        //隐藏加班时长的控件
                        holder.overTime.setVisibility(View.GONE);
                        //只有包工需要显示记账选中标识
                        holder.recordAccountIcon.setVisibility(detail.getRwork_type() == 2 ? View.VISIBLE : View.GONE);
                        //休息显示的布局颜色是绿色
                        Utils.setBackGround(convertView, getResources().getDrawable(detail.getRwork_type() == 1 ? R.drawable.bg_e8fef2_sk_15a153_3_radius : R.drawable.bg_fff2ea_sk_ff6600_3_radius));
                    } else {
                        holder.recordAccountIcon.setVisibility(View.VISIBLE);
                        holder.normalTime.setVisibility(View.VISIBLE);
                        holder.normalTime.setTextSize(9);

                        String nom = AccountUtil.getAccountShowTypeString(getActivity(), false,
                                false, true, detail.getManhour(), detail.getWorking_hours());

                        holder.normalTime.setText(TextUtils.isEmpty(nom) || nom.equals("休息") ? "" : nom); //上班时长数据
                        holder.normalTime.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_333333));
                        if (detail.getOvertime() != 0) {
                            holder.overTime.setText(AccountUtil.getAccountShowTypeString(getActivity(), false,
                                    false, false, detail.getOvertime(), detail.getOvertime_hours())); //加班时长数据
                            holder.overTime.setVisibility(View.VISIBLE);
                            holder.overTime.setTextSize(9);
                        } else {
                            holder.overTime.setVisibility(View.INVISIBLE);
                        }
                        initCommonInfo(detail, holder);
                        //设置点工，包工记工天 背景为橙色
                        Utils.setBackGround(convertView, getResources().getDrawable(R.drawable.bg_fff2ea_sk_ff6600_3_radius));
                    }
                } else {
                    holder.recordAccountIcon.setVisibility(View.GONE);
                    holder.lunarCalendar.setVisibility(View.VISIBLE);
                    holder.lunarCalendar.setText(cell.lunarCalendar);
                    holder.rightIcon.setVisibility(View.GONE);
                    holder.leftIcon.setVisibility(View.GONE);
                    holder.normalTime.setText("");
                    holder.overTime.setText("");
                    Utils.setBackGround(convertView, getResources().getDrawable(cell.state == CalendarState.UNREACH_DAY ? R.color.white : R.drawable.calendar_selector_white_fdf0f0));
                }
                if (cell.state == CalendarState.TODAY) { //如果为今天则不显示差帐图标
                    holder.date.getPaint().setFakeBoldText(true); //设置字体加粗
                    if (detail == null) {//如果日历单元格没有数据 文本设置成黑色
                        holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.app_color));
                        holder.lunarCalendar.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.app_color));
                        holder.todayText.setVisibility(View.VISIBLE);
                    } else {//如果是休息文本显示成绿色，否则是橙色
                        holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), detail.getRwork_type() == 1 ? R.color.color_15a153 : R.color.color_ff6600));
                        holder.todayText.setVisibility(View.GONE);
                    }
                } else if (cell.state == CalendarState.UNREACH_DAY) { //还未到的天数
                    holder.date.getPaint().setFakeBoldText(false); //取消字体加粗
                    holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_666666));
                    holder.lunarCalendar.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_666666));
                    holder.todayText.setVisibility(View.GONE);
                } else { //正常的天数
                    holder.date.getPaint().setFakeBoldText(true); //设置字体加粗
                    if (detail == null) {//如果日历单元格没有数据 文本设置成黑色
                        holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_333333));
                        holder.lunarCalendar.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_666666));
                    } else {//rwork_type==1 是休息的表示文本显示成绿色，否则是橙色
                        holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), detail.getRwork_type() == 1 ? R.color.color_15a153 : R.color.color_ff6600));
                    }
                    holder.todayText.setVisibility(View.GONE);
                }
            }
        }


        private void initCommonInfo(RecordAccount detail, ViewHolder holder) {
            if (detail.getIs_notes() == 1) { //有备注需要显示备注的按钮
                holder.rightIcon.setVisibility(View.VISIBLE);
                holder.rightIcon.setImageResource(R.drawable.icon_remark);
            } else {
                holder.rightIcon.setVisibility(View.GONE);
            }
            //3:表示借支；4:结算
            switch (detail.getAwork_type()) {
                case 3:
                    holder.leftIcon.setVisibility(View.VISIBLE);
                    holder.leftIcon.setImageResource(R.drawable.icon_borrow);
                    break;
                case 4:
                    holder.leftIcon.setVisibility(View.VISIBLE);
                    holder.leftIcon.setImageResource(R.drawable.icon_weight);
                    break;
                default:
                    holder.leftIcon.setVisibility(View.GONE);
                    break;
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                date = (TextView) convertView.findViewById(R.id.current_date);
                recordAccountIcon = convertView.findViewById(R.id.record_account_icon);
                lunarCalendar = convertView.findViewById(R.id.lunar_calendar);
                todayText = (TextView) convertView.findViewById(R.id.today_text);
                leftIcon = (ImageView) convertView.findViewById(R.id.left_icon);
                rightIcon = (ImageView) convertView.findViewById(R.id.right_icon);
                normalTime = (TextView) convertView.findViewById(R.id.normal_time);
                overTime = (TextView) convertView.findViewById(R.id.over_time);
            }

            /**
             * 左边的图标
             */
            ImageView leftIcon;
            /**
             * 右边的图标
             */
            ImageView rightIcon;
            /**
             * 日历时间
             */
            TextView date;
            /**
             * 农历
             */
            TextView lunarCalendar;
            /**
             * 上班时常
             */
            TextView normalTime;
            /**
             * 加班时常
             */
            TextView overTime;
            /**
             * 今天的文本
             */
            TextView todayText;
            /**
             * 记账黄色选中沟图标
             */
            ImageView recordAccountIcon;
        }

        public List<Cell> getList() {
            return list;
        }

        public void setList(List<Cell> list) {
            this.list = list;
        }
    }


    /**
     * 单元格元素
     *
     * @author wuwenjie
     */
    public class Cell {
        /**
         * 记账状态
         */
        public RecordAccount recordAccount;
        /**
         * 当前日期
         */
        public CustomDate date;
        /**
         * 农历
         */
        public String lunarCalendar;
        /**
         * 日期状态   可选值  今天、今天以后的日期、今天以前的日期
         */
        public CalendarState state;
        /**
         * 行
         */
        public int i;
        /**
         * 列
         */
        public int j;

        public Cell(CustomDate date, CalendarState state, int i, int j) {
            super();
            this.date = date;
            this.state = state;
            this.i = i;
            this.j = j;
            if (state != null) {
                Calendar calendar = Calendar.getInstance();
                calendar.set(Calendar.YEAR, date.year);
                calendar.set(Calendar.MONTH, date.month - 1);
                calendar.set(Calendar.DAY_OF_MONTH, date.day);
                lunarCalendar = new CalendarUtils(calendar).getChineseDate().trim(); //计算农历工具类
            }
        }

        public RecordAccount getRecordAccount() {
            return recordAccount;
        }

    }

    public CustomDate getmShowDate() {
        return mShowDate;
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
//        super.onSaveInstanceState(outState);
//        LUtils.e("内存被杀了:" + "   year:" + mShowDate.year + "      month:" + mShowDate.month + "        visible:" + getUserVisibleHint());
    }

    public boolean isRefreshCellDate() {
        return isRefreshCellDate;
    }

    public void setRefreshCellDate(boolean refreshCellDate) {
        isRefreshCellDate = refreshCellDate;
    }
}
