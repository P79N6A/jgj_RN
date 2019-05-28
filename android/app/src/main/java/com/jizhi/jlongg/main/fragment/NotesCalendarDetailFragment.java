package com.jizhi.jlongg.main.fragment;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
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
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.activity.notebook.NoteBookTodayListActivity;
import com.jizhi.jlongg.activity.notebook.SaveNoteBookActivity;
import com.jizhi.jlongg.enumclass.CalendarState;
import com.jizhi.jlongg.main.activity.NotesCalendarActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.util.CalendarUtils;
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
 * 日期详情
 *
 * @author xuj
 * @version 1.0.2
 * @time 2017年2月9日15:40:05
 */
@SuppressLint("ValidFragment")
public class NotesCalendarDetailFragment extends Fragment {
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
        } else {
            isFirstLoadData = false;
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
        initViewPagerHeight(gridView);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (StrUtil.isFastDoubleClick()) { //防止按钮被过快的点击
                    return;
                }
                Cell cell = calendarItemAdapter.getList().get(position);
//                if (cell != null && cell.state != CalendarState.UNREACH_DAY && cell.notes != null) { //还未到的天数则不能点击
//                    /**
//                     * 如果当天有记工记录，则进入{每日考勤表}页面
//                     * 如果当天无记工记录，则进入{添加记工}页面
//                     */
//                    String year = cell.date.year + "";
//                    String month = cell.date.month < 10 ? "0" + cell.date.month : cell.date.month + "";
//                    String day = cell.date.day < 10 ? "0" + cell.date.day : cell.date.day + "";
//                    NoteBookTodayListActivity.actionStart(getActivity(), year + "-" + month + "-" + day,
//                            TimesUtils.getWeekString(cell.date.year, cell.date.month, cell.date.day));
//                }
                /**
                 * 如果当天有记工记录，则进入{每日考勤表}页面
                 * 如果当天无记工记录，则进入{添加记工}页面
                 */
                if (cell != null && cell.notes != null) {
                    NoteBookTodayListActivity.actionStart(getActivity(), cell.date.year, cell.date.month, cell.date.day,
                            TimesUtils.getWeekString(cell.date.year, cell.date.month, cell.date.day));
                } else {
                    SaveNoteBookActivity.actionStart(getActivity(), null, cell.date.year, cell.date.month, cell.date.day);
                }


            }
        });
        if (isFirstLoadData && UclientApplication.isLogin(getActivity())) {
            refreshData();
        }
        return mainView;
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
                NotesCalendarActivity activity = (NotesCalendarActivity) getActivity();
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
    private void clearCellDate() {
        List<Cell> cells = calendarItemAdapter.getList();
        for (Cell cell : cells) {
            if (cell == null || cell.state == CalendarState.UNREACH_DAY) { //单元格为空和还未到达的天数的情况
                continue;
            }
            cell.notes = null;
        }
    }


    /**
     * 查询当月的记账信息
     */
    public void refreshData() {
        if (mShowDate == null) {
            return;
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        String month = mShowDate.month >= 10 ? mShowDate.month + "" : "0" + mShowDate.month; //讲2016-01月格式拼接为 1601
        params.addBodyParameter("month", mShowDate.year + month);// 项目id
        String httpUrl = NetWorkRequest.NOTES_CALENDAR;
        CommonHttpRequest.commonRequest(getActivity(), httpUrl, NoteBook.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                clearCellDate();
                ArrayList<NoteBook> list = (ArrayList<NoteBook>) object;
                if (list != null && list.size() > 0) { //是否有记账的日期
                    for (NoteBook noteBook : list) {
                        List<Cell> cells = calendarItemAdapter.getList();
                        for (Cell cell : cells) {
                            if (cell == null) {
                                continue;
                            }
                            if (cell.date.day == noteBook.getDate()) { //如果记账日和当前单元格相等则 设置单元格数据
                                cell.notes = noteBook;
                                break;
                            }
                        }
                    }
                }
                calendarItemAdapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
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
        /**
         * 底部间距
         */
        private int dateTopMargin;

        public CalendarItemAdapter(Context context, List<Cell> list) {
            super();
            this.list = list;
            inflater = LayoutInflater.from(context);
            dateTopMargin = ImageUtils.getImageWidthHeight(getActivity(), R.drawable.notes_important_icon)[1] / 2;
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
                convertView = inflater.inflate(R.layout.notes_calendar_item, null);
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
                holder.dateText.setText(String.valueOf(cell.date.day));
                holder.luncherText.setText(cell.state == CalendarState.TODAY ? cell.luncherDate + "\n(今天)" : cell.luncherDate);
                NoteBook noteBook = cell.notes;
                if (noteBook != null) {
                    holder.importantIcon.setVisibility(noteBook.getIs_import() == 1 ? View.VISIBLE : View.GONE);
                    Utils.setBackGround(holder.dateLayout, ContextCompat.getDrawable(getActivity(), R.drawable.bg_1b71d2_5radius));
                } else {
                    holder.importantIcon.setVisibility(View.GONE);
                    Utils.setBackGround(holder.dateLayout, ContextCompat.getDrawable(getActivity(), R.drawable.white));
                }
                if (cell.state == CalendarState.TODAY) { //如果为今天则不显示差帐图标
                    holder.dateText.getPaint().setFakeBoldText(true); //设置字体加粗
                    holder.dateText.setTextColor(ContextCompat.getColor(getActivity(), noteBook != null ? R.color.white : R.color.app_color));
                    holder.luncherText.setTextColor(ContextCompat.getColor(getActivity(), noteBook != null ? R.color.white : R.color.app_color));
//                    holder.dateText.setAlpha(1.0f);
//                    holder.luncherText.setAlpha(1.0f);
                } else if (cell.state == CalendarState.UNREACH_DAY) { //还未到的天数
//                    holder.dateText.getPaint().setFakeBoldText(false); //取消字体加粗
//                    holder.dateText.setTextColor(ContextCompat.getColor(getActivity(), R.color.color_333333_new));
//                    holder.luncherText.setTextColor(ContextCompat.getColor(getActivity(), R.color.color_999999));
//                    holder.dateText.setAlpha(0.5f);
//                    holder.luncherText.setAlpha(0.5f);
                    holder.dateText.getPaint().setFakeBoldText(true); //设置字体加粗
                    holder.dateText.setTextColor(ContextCompat.getColor(getActivity(), noteBook != null ? R.color.white : R.color.color_333333));
                    holder.luncherText.setTextColor(ContextCompat.getColor(getActivity(), noteBook != null ? R.color.white : R.color.color_999999));
                } else { //正常的天数
                    holder.dateText.getPaint().setFakeBoldText(true); //设置字体加粗
                    holder.dateText.setTextColor(ContextCompat.getColor(getActivity(), noteBook != null ? R.color.white : R.color.color_333333));
                    holder.luncherText.setTextColor(ContextCompat.getColor(getActivity(), noteBook != null ? R.color.white : R.color.color_999999));
//                    holder.dateText.setAlpha(1.0f);
//                    holder.luncherText.setAlpha(1.0f);
                }
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                importantIcon = (ImageView) convertView.findViewById(R.id.important_icon);
                dateText = (TextView) convertView.findViewById(R.id.date_text);
                luncherText = (TextView) convertView.findViewById(R.id.luncher_text);
                dateLayout = convertView.findViewById(R.id.date_layout);

                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) dateLayout.getLayoutParams();
                params.topMargin = dateTopMargin;
                dateLayout.setLayoutParams(params);
            }

            /**
             * 重要的图标标识
             */
            ImageView importantIcon;
            /**
             * 日期
             */
            TextView dateText;
            /**
             * 农历
             */
            TextView luncherText;
            /**
             * 日历布局
             */
            View dateLayout;
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
    class Cell {
        /**
         * 记账状态
         */
        private NoteBook notes;
        /**
         * 当期那日期
         */
        public CustomDate date;
        /**
         * 日期状态   可选值  今天、今天以后的日期、今天以前的日期
         */
        public CalendarState state;
        /**
         * 农历日期
         */
        public String luncherDate;
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
                luncherDate = new CalendarUtils(calendar).getChineseDate().trim(); //计算农历工具类
            }
        }
    }

    public CustomDate getmShowDate() {
        return mShowDate;
    }

}
