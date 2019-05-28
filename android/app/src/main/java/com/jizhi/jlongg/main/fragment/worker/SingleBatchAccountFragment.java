package com.jizhi.jlongg.main.fragment.worker;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.enumclass.CalendarState;
import com.jizhi.jlongg.main.activity.SingleBatchAccountActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.RecordAccount;
import com.jizhi.jlongg.main.bean.RecordWorkPoints;
import com.jizhi.jlongg.main.dialog.DiaLogBottomRed;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CalendarUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * 批量记账月显示
 *
 * @author xuj
 * @version 1.0.2
 * @time 2017年2月9日18:49:05
 */
@SuppressLint("ValidFragment")
public class SingleBatchAccountFragment extends Fragment {
    /**
     * 当前日历所属的月份
     */
    private CustomDate mShowDate;
    /**
     * 日历适配器
     */
    private CalendarItemAdapter calendarItemAdapter;
    /**
     * 是否是第一次加载数据
     */
    private boolean isFirstLoadData;

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
        View mainView = inflater.inflate(R.layout.gridview_no_head, container, false);
        mShowDate = (CustomDate) getArguments().getSerializable(Constance.BEAN_CONSTANCE);
        GridView gridView = (GridView) mainView.findViewById(R.id.gridView);
        gridView.setHorizontalSpacing(DensityUtils.dp2px(getActivity(), 1));
        gridView.setVerticalSpacing(DensityUtils.dp2px(getActivity(), 1));
        calendarItemAdapter = new CalendarItemAdapter(getActivity(), getCellData());
        gridView.setAdapter(calendarItemAdapter);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Cell cell = calendarItemAdapter.getList().get(position);
                if (cell != null && cell.state != CalendarState.UNREACH_DAY) {//还未到的天数则不能点击
                    SingleBatchAccountActivity activity = ((SingleBatchAccountActivity) getActivity());
                    if (TextUtils.isEmpty(activity.getUid())) {
                        if (cell.isSelected) { //取消选中的效果
                            changeSelecteStatus(cell, activity);
                        } else {
                            CommonMethod.makeNoticeLong(getActivity().getApplicationContext(), getString(R.string.ple_select_ob), CommonMethod.ERROR);
                        }
                        return;
                    }
                    if (!activity.isSetSalary()) {//检测是否已设置薪资标准
                        if (cell.isSelected) { //取消选中的效果
                            changeSelecteStatus(cell, activity);
                        } else {
                            CommonMethod.makeNoticeLong(getActivity(), activity.isHourWork() ? "请先设置工资标准" : "请先设置考勤模板", CommonMethod.ERROR);
                        }
                        return;
                    }
                    RecordAccount recordAccount = cell.recordAccount;
                    if (recordAccount != null) {
                        /**
                         2、从点工进入一人记多天界面，默认选中点工；
                         选中未记账的日期，记账成功后，表示对该日期新记“点工“账；
                         选中已记点工的日期，表示对这一天的点工进行修改；
                         点击选择已记1笔包工记工天的日期，提示“该日期已记1笔包工记工天了”；
                         点击选择已经记了2笔的日期（2笔包工记工天/2笔点工/1笔点工1笔包工），提示“该日期已记2笔工了，不能再记啦~”；

                         3、从包工记工天进入一人记多天界面，默认选中包工记工天；
                         选中未记账的日期，记账成功后，表示对该日期新记“包工记工天“账；
                         选中已记包工记工天的日期，表示对这一天的包工记工天进行修改；
                         点击选择已记1笔点工的日期，提示“该日期已记1笔点工了”；
                         点击选择已经记了2笔的日期（2笔包工记工天/2笔点工/1笔点工1笔包工），提示“该日期已记了2笔工了，不能再记啦~”；

                         4、如记账双方开启了我要对账，记账对象也已经对我记过工，点击气泡提示：
                         ①、他对我记了1笔点工，我还未确认的，点击日期提示：他已对你记了1笔点工！
                         ②、他对我记了1笔包工记工天，我还未确认的，点击日期提示：他已对你记了1笔包工记工天！
                         ③、他对我记了1笔点工1笔包工记工天，我还未确认的，点击日期提示：他已对你记了1笔点工1笔包工记工天！
                         ④、他对我记了2笔点工，我还未确认的，点击日期提示：他已对你记了2笔点工！
                         ⑤、他对我记了2笔包工记工天，我还未确认的，点击日期提示：他已对你记了2笔包工记工天！
                         5、在点工下选择的日期和在包工记工天下选择的日期，点击记工时提交后，同时提交数据；
                         6、在点工类型下选择的日期，在包工记工天下点击在点工下选中的日期，表示取消选中点工，再次点击才表示选中包工记工天的日期；
                         */
                        if ((recordAccount.getIs_double() == 1 && recordAccount.getMsg() != null &&
                                !TextUtils.isEmpty(recordAccount.getMsg().getMsg_text())) || (recordAccount.getIs_record_to_me() == 1 && recordAccount.getMsg() != null &&
                                !TextUtils.isEmpty(recordAccount.getMsg().getMsg_text()))) { //有提示信息则打印他
                            if (cell.isSelected) { //如果已选中的状态则可以取消掉
                                changeSelecteStatus(cell, activity);
                            } else {
                                new DiaLogBottomRed(activity, "我知道了", recordAccount.getMsg().getMsg_text()).show();
                            }
                            return;
                        }
                        if (recordAccount.getAccounts_type() != 0 && recordAccount.getAccounts_type() != getCurrentAccountType()) {
                            if (cell.isSelected) { //如果已选中的状态则可以取消掉
                                changeSelecteStatus(cell, activity);
                            } else {
                                new DiaLogBottomRed(activity, "我知道了", recordAccount.getMsg().getMsg_text()).show();
                            }
                            return;
                        }
                    }
                    if (!checkForemanIsProxyDate(cell.date.year + "-" + cell.date.month + "-" + cell.date.day)) {
                        return;
                    }
                    changeSelecteStatus(cell, activity);
                }
            }
        });
        if (isFirstLoadData) {
            getMonthAccountData();
            isFirstLoadData = false;
        }
        return mainView;
    }

    /**
     * 改变选中状态
     */
    public void changeSelecteStatus(Cell cell, SingleBatchAccountActivity activity) {
        cell.isSelected = !cell.isSelected;
        cell.selecteAccountType = cell.isSelected ? activity.currentWork : 0;
        calendarItemAdapter.notifyDataSetChanged();
        int selectDaySize = getSelectDaySize();
        activity.setConfirmState(selectDaySize);
    }


    /**
     * 检查代班长记录时是否在记账时间范围内
     * 如果不是代班长记账则不用检查时间
     *
     * @param clickDate 选择的时间
     */
    private boolean checkForemanIsProxyDate(String clickDate) {
        AgencyGroupUser user = (AgencyGroupUser) getActivity().getIntent().getSerializableExtra("agencyGroupUser"); //如果代班长信息不为空需要验证一下时间是否开始时间和结束时间范围内
        if (user == null || TextUtils.isEmpty(user.getUid())) {
            return true;
        }
        String startTime = user.getStart_time(); //代班长记账开始时间
        String endTime = user.getEnd_time(); //代班长记账结束时间
        long clickDateTimeInMillis = DateUtil.getTimeInMillis(clickDate);
        if (!TextUtils.isEmpty(startTime) && !TextUtils.isEmpty(endTime)) { //代班开始时间结束都不为空
            //如果点击的时间小于开始时间或者点击的时间大于结束时间则进入此判断
            if (clickDateTimeInMillis < DateUtil.getTimeInMillis(startTime) || clickDateTimeInMillis > DateUtil.getTimeInMillis(endTime)) {
                CommonMethod.makeNoticeLong(getActivity().getApplicationContext(), "代班长只能在" + startTime.replaceAll("-", ".") +
                        "~" + endTime.replaceAll("-", ".") + "时间段内记账", CommonMethod.ERROR);
                return false;
            }
        } else if (!TextUtils.isEmpty(startTime)) {
            if (clickDateTimeInMillis < DateUtil.getTimeInMillis(startTime)) {
                CommonMethod.makeNoticeLong(getActivity().getApplicationContext(), "代班长不能记录" + startTime.replaceAll("-", ".") + "以前的账", CommonMethod.ERROR);
                return false;
            }
        } else if (!TextUtils.isEmpty(endTime)) {
            if (clickDateTimeInMillis > DateUtil.getTimeInMillis(endTime)) {
                CommonMethod.makeNoticeLong(getActivity().getApplicationContext(), "代班长不能记录" + endTime.replaceAll("-", ".") + "以后的账", CommonMethod.ERROR);
                return false;
            }
        }
        return true;
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
        int monthDay = DateUtil.getCurrentMonthDay(); // 今天
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
                    if (isCurrentMonth && day == monthDay) { //今天
                        cell.state = CalendarState.TODAY;
                    } else if (isCurrentMonth && day > monthDay) {//大于今天的日期
                        cell.state = CalendarState.UNREACH_DAY;
                    }
                }
            }
        }
        return cells;
    }

    /**
     * 获取选中的日历
     */
    public List<Cell> getSelecteDay() {
        List<Cell> selectCellList = null; //选中的单元格
        List<Cell> cells = calendarItemAdapter.getList();
        for (Cell cell : cells) {
            if (cell == null || cell.state == CalendarState.UNREACH_DAY) { //单元格为空和未到达的天数的情况
                continue;
            }
            if (cell.isSelected) {
                if (selectCellList == null) {
                    selectCellList = new ArrayList<>();
                }
                selectCellList.add(cell);
            }
        }
        return selectCellList;
    }

    /**
     * 清空记账状态
     *
     * @param clearCalendarCell 清空单元格记账信息
     * @param clearSelectCell   清空单元格选中的记账信息
     */
    public void clearAccountState(boolean clearCalendarCell, boolean clearSelectCell) {
        if (!clearCalendarCell && !clearSelectCell) {
            return;
        }
        List<Cell> cells = calendarItemAdapter.getList();
        for (Cell cell : cells) {
            if (cell == null || cell.state == CalendarState.UNREACH_DAY) { //单元格为空和还未到达的天数的情况
                continue;
            }
            if (clearCalendarCell) {
                cell.recordAccount = null;
            }
            if (clearSelectCell) {
                cell.isSelected = false;
            }
        }
        if (clearSelectCell) {
            ((SingleBatchAccountActivity) getActivity()).setConfirmState(0); //清空选中的状态按钮
        }
        calendarItemAdapter.notifyDataSetChanged();
    }

    /**
     * 获取选中的日历
     */
    public int getSelectDaySize() {
        int size = 0;
        List<Cell> cells = calendarItemAdapter.getList();
        for (Cell cell : cells) {
            if (cell == null) { //单元格为空的情况
                continue;
            }
            if (cell.state == CalendarState.UNREACH_DAY) { //还未到达的天数
                continue;
            }
            if (cell.isSelected) {
                size += 1;
            }
        }
        return size;
    }

    /**
     * 查询当月的记账信息
     */
    public void getMonthAccountData() {
        SingleBatchAccountActivity activity = (SingleBatchAccountActivity) getActivity();
        String uid = activity.getUid();
        if (TextUtils.isEmpty(uid) || !UclientApplication.isHasRealName(getActivity().getApplicationContext())) { //如果没有选择记账对象或者未完善姓名则不允许请求日历记账数据
            return;
        }
        String groupId = activity.getIntent().getStringExtra(Constance.GROUP_ID);
        String agencyUid = activity.getIntent().getStringExtra("agency_uid");
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        //格式为: 1601
        params.addBodyParameter("date", mShowDate.year + (mShowDate.month >= 10 ? mShowDate.month + "" : "0" + mShowDate.month));// 项目id
        params.addBodyParameter("uid", uid);// 用户id
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId);// 班组id
        }
        if (!TextUtils.isEmpty(agencyUid)) {
            params.addBodyParameter("agency_uid", agencyUid);//代班长id
        }
        CommonHttpRequest.commonRequest(getActivity(), NetWorkRequest.WORKER_MONTH_TOTAL, RecordWorkPoints.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                RecordWorkPoints recordIncome = (RecordWorkPoints) object;
                if (recordIncome.getList() != null && recordIncome.getList().size() > 0) { //是否有记账的日期
                    for (RecordAccount accountDetail : recordIncome.getList()) {
                        List<Cell> cells = calendarItemAdapter.getList();
                        for (SingleBatchAccountFragment.Cell cell : cells) {
                            if (cell == null || cell.state == CalendarState.UNREACH_DAY) {
                                continue;
                            }
                            if (cell.date.day == accountDetail.getDate()) { //如果记账日和当前单元格相等则 设置单元格数据
                                cell.recordAccount = accountDetail;
                                break;
                            }
                        }
                    }
                    calendarItemAdapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }


    /**
     * 功能:一人记多天 日历适配器
     * 时间:2017年9月29日16:04:07
     * 作者:xuj
     */
    public class CalendarItemAdapter extends BaseAdapter {
        /**
         * 单元格
         */
        private List<Cell> list;
        /**
         * xml解析器
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
                convertView = inflater.inflate(R.layout.calendar_click_month_item, null);
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
                RecordAccount detail = cell.recordAccount;
                if (detail != null) { //如果单元格有数据则填充数据
                    if (detail.getIs_record_to_me() == 1) { //别人给我记的工 不需要显示记账信息
                        initNoCellView(holder, cell, convertView);
                    } else {
                        holder.lunarCalendar.setVisibility(View.GONE);
                        if (detail.getIs_record() == 0) { //如果这个类型为0 表示当前日期 未记录 点工和包工记工天
                            holder.leftIcon.setVisibility(View.GONE);
                            switch (detail.getRwork_type()) {
                                case 1: //休息
                                    holder.normalTime.setVisibility(View.VISIBLE);
                                    holder.normalTime.setText("休");
                                    holder.normalTime.setTextSize(18);
                                    holder.normalTime.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_15a153));
                                    break;
                                default://借支和结算
                                    holder.normalTime.setVisibility(View.GONE);
                                    break;
                            }
                            if (detail.getIs_notes() == 1) { //有备注
                                holder.rightIcon.setVisibility(View.VISIBLE);
                                holder.rightIcon.setImageResource(R.drawable.icon_remark);
                            } else {
                                holder.rightIcon.setVisibility(View.GONE);
                            }
                            //隐藏加班时长的控件
                            holder.overTime.setVisibility(View.GONE);
                            holder.recordAccountIcon.setVisibility(View.GONE);
                            //休息显示的布局颜色是绿色
                            Utils.setBackGround(convertView, getResources().getDrawable(detail.getRwork_type() == 1 ? R.drawable.bg_e8fef2_sk_15a153_3_radius : R.drawable.bg_fff2ea_sk_ff6600_3_radius));
                        } else {
                            holder.recordAccountIcon.setVisibility(View.VISIBLE);
                            holder.normalTime.setVisibility(View.VISIBLE);
                            holder.normalTime.setTextSize(9);
                            holder.normalTime.setText(AccountUtil.getAccountShowTypeString(getActivity(), false,
                                    false, true, detail.getManhour(), detail.getWorking_hours())); //上班时长数据
                            holder.normalTime.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_333333));
                            if (detail.getOvertime() != 0) {
                                holder.overTime.setText(AccountUtil.getAccountShowTypeString(getActivity(), false,
                                        false, false, detail.getOvertime(), detail.getOvertime_hours())); //加班时长数据
                                holder.overTime.setVisibility(View.VISIBLE);
                                holder.overTime.setTextSize(9);
                            } else {
                                holder.overTime.setVisibility(View.INVISIBLE);
                            }
                            holder.leftIcon.setVisibility(View.GONE);
                            if (detail.getIs_notes() == 1) { //有备注需要显示备注的按钮
                                holder.rightIcon.setVisibility(View.VISIBLE);
                                holder.rightIcon.setImageResource(R.drawable.icon_remark);
                            } else {
                                holder.rightIcon.setVisibility(View.GONE);
                            }
                            Utils.setBackGround(convertView, getResources().getDrawable(R.drawable.bg_fff2ea_sk_ff6600_3_radius));
                        }
                    }
                } else {
                    initNoCellView(holder, cell, convertView);
                }
                if (cell.state == CalendarState.TODAY) { //如果为今天则不显示差帐图标
                    holder.date.getPaint().setFakeBoldText(true); //设置字体加粗
                    if (detail == null || detail.getIs_record_to_me() == 1) {//如果日历单元格没有数据 文本设置成黑色
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
                    if (detail == null || detail.getIs_record_to_me() == 1) {//如果日历单元格没有数据 文本设置成黑色
                        holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_333333));
                        holder.lunarCalendar.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), R.color.color_666666));
                    } else {//如果是休息文本显示成绿色，否则是橙色
                        holder.date.setTextColor(ContextCompat.getColor(getActivity().getApplicationContext(), detail.getRwork_type() == 1 ? R.color.color_15a153 : R.color.color_ff6600));
                    }
                    holder.todayText.setVisibility(View.GONE);
                }
                if (cell.state != CalendarState.UNREACH_DAY) {//还未到的天数
                    setSelectedState(holder, cell.isSelected, convertView, cell);
                }
            }
        }


        private void initNoCellView(ViewHolder holder, Cell cell, View convertView) {
            holder.recordAccountIcon.setVisibility(View.GONE);
            holder.lunarCalendar.setVisibility(View.VISIBLE);
            holder.lunarCalendar.setText(cell.lunarCalendar);
            holder.rightIcon.setVisibility(View.GONE);
            holder.leftIcon.setVisibility(View.GONE);
            holder.normalTime.setText("");
            holder.overTime.setText("");
            Utils.setBackGround(convertView, getResources().getDrawable(cell.state == CalendarState.UNREACH_DAY ? R.color.white : R.drawable.calendar_selector_white_fdf0f0));
        }


        /**
         * 设置选中状态
         *
         * @param holder
         * @param isSelected 是否选中
         */
        private void setSelectedState(ViewHolder holder, boolean isSelected, View convertView, Cell cell) {
            if (isSelected) { //选中的状态
                if (holder.isSelectedIcon.getVisibility() == View.GONE) {
                    showSelecteAnim(holder, convertView, cell);
                } else {
                    setItemSelecteState(holder, convertView, cell);
                }
            } else {
                if (holder.isSelectedIcon.getVisibility() == View.VISIBLE) {
                    hideSelecteAnim(holder);
                } else {
                    setItemUnSelecteState(holder);
                }
            }
        }

        /**
         * 设置单元格选中状态
         *
         * @param holder
         * @param convertView
         */
        private void setItemSelecteState(ViewHolder holder, View convertView, Cell cell) {
            holder.isSelectedIcon.setVisibility(View.VISIBLE);
            RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.isSelectedIcon.getLayoutParams();
            params.width = convertView.getWidth();
            params.height = convertView.getHeight();
            holder.isSelectedIcon.setLayoutParams(params);
            holder.isSelectedIcon.setImageResource(AccountUtil.HOUR_WORKER_INT == cell.selecteAccountType ? R.drawable.single_batch_day_hour_icon : R.drawable.single_batch_day_constractor_icon);
            Utils.setBackGround(convertView, null);
        }

        /**
         * 设置单元格未选中状态
         */
        private void setItemUnSelecteState(ViewHolder holder) {
            holder.isSelectedIcon.setVisibility(View.GONE);
        }

        private void showSelecteAnim(final ViewHolder holder, final View convertView, Cell cell) {
            setItemSelecteState(holder, convertView, cell);
            Animation animation = AnimationUtils.loadAnimation(getActivity(), R.anim.show_scale_animation);
            holder.isSelectedIcon.startAnimation(animation);//开始动画
        }

        private void hideSelecteAnim(final ViewHolder holder) {
            Animation animation = AnimationUtils.loadAnimation(getActivity(), R.anim.hide_scale_animation);
            holder.isSelectedIcon.startAnimation(animation);//开始动画
            animation.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {
                }

                @Override
                public void onAnimationRepeat(Animation animation) {
                }

                @Override
                public void onAnimationEnd(Animation animation) {//动画结束
                    setItemUnSelecteState(holder);
                }
            });
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                isSelectedIcon = (ImageView) convertView.findViewById(R.id.is_select);
                leftIcon = (ImageView) convertView.findViewById(R.id.left_icon);
                rightIcon = (ImageView) convertView.findViewById(R.id.right_icon);
                lunarCalendar = convertView.findViewById(R.id.lunar_calendar);
                date = (TextView) convertView.findViewById(R.id.current_date);
                recordAccountIcon = convertView.findViewById(R.id.record_account_icon);
                normalTime = (TextView) convertView.findViewById(R.id.normal_time);
                overTime = (TextView) convertView.findViewById(R.id.over_time);
                dateLayout = convertView.findViewById(R.id.date_layout);
                todayText = (TextView) convertView.findViewById(R.id.today_text);
            }

            /**
             * 日期格式布局
             */
            View dateLayout;
            /**
             * 日历时间
             */
            TextView date;
            /**
             * 记账标识图标
             */
            ImageView recordAccountIcon;
            /**
             * 农历
             */
            TextView lunarCalendar;
            /**
             * 今天的文本
             */
            TextView todayText;
            /**
             * 左边的图标
             */
            ImageView leftIcon;
            /**
             * 右边的图标
             */
            ImageView rightIcon;
            /**
             * 上班时常
             */
            TextView normalTime;
            /**
             * 加班时常
             */
            TextView overTime;
            /**
             * 是否已经选中
             */
            ImageView isSelectedIcon;
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
        private RecordAccount recordAccount;
        /**
         * 记账类型 1是点工，5是包工考勤
         */
        public int selecteAccountType;
        /**
         * 农历
         */
        public String lunarCalendar;
        /**
         * 当期那日期
         */
        public CustomDate date;
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
        /**
         * 是否选中当前日期记账
         */
        public boolean isSelected;

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
    }


    public CustomDate getmShowDate() {
        return mShowDate;
    }


    public int getCurrentAccountType() {
        return ((SingleBatchAccountActivity) getActivity()).currentWork;
    }


}
