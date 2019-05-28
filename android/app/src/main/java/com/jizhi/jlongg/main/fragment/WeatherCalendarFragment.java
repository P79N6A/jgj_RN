package com.jizhi.jlongg.main.fragment;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
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
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.enumclass.CalendarState;
import com.jizhi.jlongg.main.activity.WeatherTablelActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WeatherUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 晴雨表日历
 *
 * @author xuj
 * @version 1.1.4
 * @time 2017年3月29日10:23:42
 */
@SuppressLint("ValidFragment")
public class WeatherCalendarFragment extends Fragment {
    /**
     * 当前日历所属的月份
     */
    private CustomDate mShowDate;
    /**
     * 日历适配器
     */
    private CalendarItemAdapter calendarItemAdapter;
    /**
     * 点击的单元格
     */
    private Cell clickCell;
    /**
     * 项目组id
     */
    private String groupId;
    /**
     * 是否是第一次进入加载数据
     */
    private boolean isFirstLoadData;
    /**
     * 需求需要每次进入此页面时默认加载今天的数据,判断是否已加载今天的数据
     */
    private boolean isLoadTodayData;


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser == true) {//可见时执行的操作
            if (mShowDate == null) {
                isFirstLoadData = true;
            }
        } else {
            isFirstLoadData = false;
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST && resultCode == Constance.UPDATE_SUCCESS) {//已编辑了数据 重新加载数据
            refreshData();
            String day = clickCell.date.day < 10 ? "0" + clickCell.date.day : clickCell.date.day + "";
            String month = mShowDate.month < 10 ? "0" + mShowDate.month : mShowDate.month + "";
            clickWeather(mShowDate.year + month + day);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View mainView = inflater.inflate(R.layout.weather_table_gridview, container, false);
        mShowDate = (CustomDate) getArguments().getSerializable(Constance.BEAN_CONSTANCE);
        groupId = getArguments().getString(Constance.GROUP_ID);
        GridView gridView = (GridView) mainView.findViewById(R.id.gridView);
        gridView.setHorizontalSpacing(DensityUtils.dp2px(getActivity(), 1));
        gridView.setVerticalSpacing(DensityUtils.dp2px(getActivity(), 1));
        calendarItemAdapter = new CalendarItemAdapter(getActivity(), getCellData());
        gridView.setAdapter(calendarItemAdapter);
        initViewPagerHeight(gridView);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Cell cell = calendarItemAdapter.getList().get(position);
                if (cell != null && cell.state != CalendarState.UNREACH_DAY) { //还未到的天数则不能点击
                    if (clickCell != null) {
                        clickCell.isSelected = false;
                    }
                    cell.isSelected = true;
                    clickCell = cell;
                    calendarItemAdapter.notifyDataSetChanged();
                    String month = cell.date.month < 10 ? "0" + cell.date.month : cell.date.month + "";
                    String day = cell.date.day < 10 ? "0" + cell.date.day : cell.date.day + "";
                    clickWeather(cell.date.year + month + day);
                }
            }
        });
        if (isFirstLoadData && UclientApplication.isLogin(getActivity())) {
            refreshData();
        }
        if (!isLoadTodayData && DateUtil.isCurrentMonth(mShowDate)) { //第一次进入晴雨表 默认加载今天的数据
            isLoadTodayData = true;
            CustomDate customDate = new CustomDate();
            clickCell = getTodayCell(customDate);
            clickCell.isSelected = true;
            String month = customDate.month < 10 ? "0" + customDate.month : customDate.month + "";
            String day = customDate.day < 10 ? "0" + customDate.day : customDate.day + "";
            clickWeather(customDate.year + month + day);
        }
        return mainView;
    }

    /**
     * 获取今天的单元格
     *
     * @return
     */
    private Cell getTodayCell(CustomDate date) {
        for (Cell cell : calendarItemAdapter.getList()) {
            if (cell == null) {
                continue;
            }
            if (date.year == cell.date.year && date.month == cell.date.month && date.day == cell.date.day) {
                return cell;
            }
        }
        return null;
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
                WeatherTablelActivity activity = (WeatherTablelActivity) getActivity();
                int currentPosition = getArguments().getInt("fragmentPosition");
                activity.getmViewPager().setObjectForPosition(gridView, currentPosition);
                if (isFirstLoadData) { //第一次加载Fragment 重新计算一下ViewPager的高度
                    activity.getmViewPager().resetHeight(currentPosition);
                }
                if (Build.VERSION.SDK_INT < 16) {
                    getView().getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    getView().getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }

    /**
     * 清空单元格数据 主要是为了下次查询不会有错误数据
     */
    private void clearCellDate() {
        List<Cell> cells = calendarItemAdapter.getList();
        for (Cell cell : cells) {
            if (cell == null || cell.state == CalendarState.UNREACH_DAY) { //单元格为空的情况
                continue;
            }
            if (cell.weatherAttribute != null) {
                cell.weatherAttribute = null;
            }
        }
    }


    /**
     * 获取天气数据
     */
    public void getData(String date) {
        final WeatherTablelActivity activity = (WeatherTablelActivity) getActivity();
        String URL = NetWorkRequest.GET_WEATHER_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("group_id", groupId);// 项目组id
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);//类型为项目组
        params.addBodyParameter("month", date);//日期 如：201702
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBack<String>() {

            @Override
            public void onFailure(HttpException e, String errormsg) {
                activity.printNetLog(errormsg, activity);
            }

            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<WeatherAttribute> base = CommonListJson.fromJson(responseInfo.result, WeatherAttribute.class);
                    if (base.getState() != 0) {
                        clearCellDate();
                        List<WeatherAttribute> list = base.getValues();
                        if (list != null && list.size() > 0) {
                            for (WeatherAttribute weatherAttribute : list) {
                                List<Cell> cells = calendarItemAdapter.getList();
                                for (Cell cell : cells) {
                                    if (cell == null) {
                                        continue;
                                    }
                                    String[] date = weatherAttribute.getAll_date().split("-");
                                    int year = Integer.parseInt(date[0]);
                                    int month = Integer.parseInt(date[1]);
                                    int day = Integer.parseInt(date[2]);
                                    if (cell.date.year == year && cell.date.month == month && cell.date.day == day) { //如果记账日和当前单元格相等则 设置单元格数据
                                        cell.weatherAttribute = weatherAttribute;
                                        break;
                                    }
                                }
                            }
                        }
                        calendarItemAdapter.notifyDataSetChanged();
                    } else {
                        DataUtil.showErrOrMsg(getActivity(), base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 获取天气数据
     * % 默认选中今天
     * % 如果点击今天及以前未记录天气的日期，则进入{记录天气}页面
     * % 如果点击已记录天气的日期，则在天气详情区域显示天气详情
     * % 点击今天之后的日期，无反馈
     */
    public void clickWeather(String date) {
        final WeatherTablelActivity activity = (WeatherTablelActivity) getActivity();
        String URL = NetWorkRequest.GET_WEATHER_DAY_DETAIL;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("group_id", groupId);// 项目组id
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);//类型为项目组
        params.addBodyParameter("month", date);//日期 如：20170214
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<WeatherAttribute> base = CommonListJson.fromJson(responseInfo.result, WeatherAttribute.class);
                    if (base.getState() != 0) {
                        List<WeatherAttribute> list = base.getValues();
                        if (list != null && list.size() > 0) {
                            activity.fillWeatherData(base.getValues().get(0));
                        } else {
                            activity.fillWeatherData(null);
                        }
                    } else {
                        DataUtil.showErrOrMsg(getActivity(), base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
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

    public RequestParams params() {
        String month = mShowDate.month >= 10 ? mShowDate.month + "" : "0" + mShowDate.month; //讲2016-01月格式拼接为 1601
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter("date", mShowDate.year + month);// 项目id
        params.addBodyParameter("uid", UclientApplication.getUid(getActivity()));// 用户id
        return params;
    }


    /**
     * 数据查询
     */
    public void refreshData() {
        String month = mShowDate.month < 10 ? "0" + mShowDate.month : mShowDate.month + "";
        getData(mShowDate.year + month);
    }

    /**
     * 功能:晴雨表适配器
     * 时间:2017年3月31日14:16:39
     * 作者:xuj
     */
    public class CalendarItemAdapter extends BaseAdapter {
        /* 单元格 */
        private List<Cell> list;
        /* xml 解析器 */
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
                convertView = inflater.inflate(R.layout.weather_calendar_item, null);
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
                if (cell.state == CalendarState.TODAY) { //今天
                    holder.date.getPaint().setFakeBoldText(true); //设置字体加粗
                    holder.todayText.setVisibility(View.VISIBLE);
                    holder.date.setTextColor(ContextCompat.getColor(getActivity(), R.color.app_color));
                } else if (cell.state == CalendarState.UNREACH_DAY) { //今天以后的日期
                    holder.date.getPaint().setFakeBoldText(false); //取消字体加粗
                    holder.todayText.setVisibility(View.GONE);
                    holder.date.setTextColor(ContextCompat.getColor(getActivity(), R.color.color_666666));
                    Utils.setBackGround(convertView, getResources().getDrawable(R.color.white));
                } else { //今天之前的日期
                    holder.date.getPaint().setFakeBoldText(true); //设置字体加粗
                    holder.todayText.setVisibility(View.GONE);
                    holder.date.setTextColor(ContextCompat.getColor(getActivity(), R.color.color_333333));
                }
                if (cell.state != CalendarState.UNREACH_DAY) {
                    if (cell.isSelected) { //已选中的状态
                        Utils.setBackGround(convertView, getResources().getDrawable(R.drawable.bg_fafafa_sk_cccccc_1dp));
                        holder.topRedLine.setVisibility(View.VISIBLE);
                    } else { //未选中的状态
                        Utils.setBackGround(convertView, getResources().getDrawable(R.drawable.bg_f3f3f3_sk_white_half_dp));
                        holder.topRedLine.setVisibility(View.GONE);
                    }
                }
                WeatherAttribute weatherAttribute = cell.weatherAttribute;
                if (weatherAttribute != null) {
                    if (weatherAttribute.getWeat_one() != 0) { //天气1
                        holder.weatherIcon1.setImageResource(WeatherUtil.getWeatherFill(weatherAttribute.getWeat_one()));
                        holder.weatherIcon1.setVisibility(View.VISIBLE);
                    } else {
                        holder.weatherIcon1.setVisibility(View.INVISIBLE);
                    }
                    if (weatherAttribute.getWeat_two() != 0) { //天气2
                        holder.weatherIcon2.setImageResource(WeatherUtil.getWeatherFill(weatherAttribute.getWeat_two()));
                        holder.weatherIcon2.setVisibility(View.VISIBLE);
                    } else {
                        holder.weatherIcon2.setVisibility(View.INVISIBLE);
                    }
                    if (weatherAttribute.getWeat_three() != 0) { //天气3
                        holder.weatherIcon3.setImageResource(WeatherUtil.getWeatherFill(weatherAttribute.getWeat_three()));
                        holder.weatherIcon3.setVisibility(View.VISIBLE);
                    } else {
                        holder.weatherIcon3.setVisibility(View.INVISIBLE);
                    }
                    if (weatherAttribute.getWeat_four() != 0) { //天气4
                        holder.weatherIcon4.setImageResource(WeatherUtil.getWeatherFill(weatherAttribute.getWeat_four()));
                        holder.weatherIcon4.setVisibility(View.VISIBLE);
                    } else {
                        holder.weatherIcon4.setVisibility(View.INVISIBLE);
                    }
                } else {
                    if (!cell.isSelected) {
                        Utils.setBackGround(convertView, getResources().getDrawable(R.color.white));
                    }
                    holder.weatherIcon1.setVisibility(View.INVISIBLE);
                    holder.weatherIcon2.setVisibility(View.INVISIBLE);
                    holder.weatherIcon3.setVisibility(View.INVISIBLE);
                    holder.weatherIcon4.setVisibility(View.INVISIBLE);
                }
            }
        }

        class ViewHolder {
            public ViewHolder(View convertView) {
                weatherIcon1 = (ImageView) convertView.findViewById(R.id.weatherIcon1);
                weatherIcon2 = (ImageView) convertView.findViewById(R.id.weatherIcon2);
                weatherIcon3 = (ImageView) convertView.findViewById(R.id.weatherIcon3);
                weatherIcon4 = (ImageView) convertView.findViewById(R.id.weatherIcon4);
                date = (TextView) convertView.findViewById(R.id.date);
                todayText = (TextView) convertView.findViewById(R.id.todayText);
                topRedLine = convertView.findViewById(R.id.topRedLine);
            }

            /* 天气图标1 */
            ImageView weatherIcon1;
            /* 天气图标2 */
            ImageView weatherIcon2;
            /* 天气图标3 */
            ImageView weatherIcon3;
            /* 天气图标4 */
            ImageView weatherIcon4;
            /* 日历时间 */
            TextView date;
            /* 今天的文本 */
            TextView todayText;
            /* 顶部红色线条 */
            View topRedLine;
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
         * 天气属性
         */
        public WeatherAttribute weatherAttribute;
        /**
         * 选中当前单元格
         */
        public boolean isSelected;
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

        public Cell(CustomDate date, CalendarState state, int i, int j) {
            super();
            this.date = date;
            this.state = state;
            this.i = i;
            this.j = j;
        }
    }



    public CustomDate getmShowDate() {
        return mShowDate;
    }

    public Cell getClickCell() {
        return clickCell;
    }

    public void setClickCell(Cell clickCell) {
        this.clickCell = clickCell;
    }
}
