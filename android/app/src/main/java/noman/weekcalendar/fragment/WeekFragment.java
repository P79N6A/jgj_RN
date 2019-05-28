package noman.weekcalendar.fragment;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.CalendarUtils;
import com.squareup.otto.Subscribe;

import org.joda.time.DateTime;
import org.joda.time.DateTimeConstants;

import java.util.ArrayList;
import java.util.Calendar;

import noman.weekcalendar.eventbus.BusProvider;
import noman.weekcalendar.eventbus.Event;
import noman.weekcalendar.view.WeekPager;

/**
 * Created by nor on 12/4/2015.
 */
public class WeekFragment extends Fragment {

    public static String DATE_KEY = "date_key";
    /**
     * 滑动Viewpager
     */
    private WeekPager weekPager;
    /**
     * 是否可见
     */
    private boolean isVisible;
    /**
     * GridView
     */
    private GridView gridView;
    /**
     * 开始时间、结束时间
     */
    private DateTime startDate, endDate, midDate, todayDate;
    /**
     * 当前时间的年，月，日
     */
    private int todayYear, todayMonth, today;




    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_week, container, false);
        gridView = rootView.findViewById(R.id.gridView);
        return rootView;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        init();
    }

    private void init() {
        BusProvider.getInstance().register(this);

        weekPager = (WeekPager) getView().getParent();
        todayDate = new DateTime();
        todayYear = todayDate.getYear();
        todayMonth = todayDate.getMonthOfYear();
        today = todayDate.getDayOfMonth();

        final ArrayList<DateTime> days = new ArrayList<>();
        midDate = (DateTime) getArguments().getSerializable(DATE_KEY);
        midDate = midDate.withDayOfWeek(DateTimeConstants.THURSDAY);
        //Getting all seven days
        for (int i = -3; i <= 3; i++)
            days.add(midDate.plusDays(i));

        startDate = days.get(0);
        endDate = days.get(days.size() - 1);

        final WeekAdapter weekAdapter = new WeekAdapter(getActivity(), days);
        gridView.setAdapter(weekAdapter);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (weekPager == null || weekPager.getSelectedDateTime() == null) {
                    return;
                }
                DateTime dateTime = days.get(position);
                if (weekPager.getSelectedDateTime().toLocalDate().equals(dateTime.toLocalDate())) {
                    return;
                }
                int calendayYear = dateTime.getYear();
                int calendayMonth = dateTime.getMonthOfYear();
                int calenday = dateTime.getDayOfMonth();
                if (calendayYear == 2013 || calendayYear > todayYear) {//只能点击2014年1月以后到今天的日期
                    return;
                } else if (todayYear == calendayYear) {
                    if (calendayMonth == todayMonth) {
                        if (calenday > today) {
                            return;
                        }
                    } else if (calendayMonth > todayMonth) {
                        return;
                    }
                }
                weekPager.setSelectedDateTime(dateTime);
                BusProvider.getInstance().post(new Event.InvalidateEvent()); //初始化选中状态
                BusProvider.getInstance().post(new Event.OnDateClickEvent(dateTime));
            }
        });
    }

    @Subscribe
    public void updateSelectedDate(Event.UpdateSelectedDateEvent event) {
        if (isVisible) {
            if (weekPager != null && weekPager.getSelectedDateTime() != null) {
                DateTime selectedDateTime = weekPager.getSelectedDateTime();
                weekPager.setSelectedDateTime(selectedDateTime.plusDays(event.getDirection()));
                if (selectedDateTime.toLocalDate().equals(endDate.plusDays(1).toLocalDate()) ||
                        selectedDateTime.toLocalDate().equals(startDate.plusDays(-1).toLocalDate())) { //判断是否是本周的第一天或者最后一天
                    if (!(selectedDateTime.toLocalDate().equals(startDate.plusDays(-1).toLocalDate()) && event.getDirection() == 1)
                            && !(selectedDateTime.toLocalDate().equals(endDate.plusDays(1)
                            .toLocalDate()) && event.getDirection() == -1))
                        BusProvider.getInstance().post(new Event.SetCurrentPageEvent(event.getDirection()));
                }
                BusProvider.getInstance().post(new Event.InvalidateEvent());
            }
        }
    }


    @Subscribe
    public void invalidate(Event.InvalidateEvent event) {
        gridView.invalidateViews();
    }


    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        isVisible = isVisibleToUser;
        super.setUserVisibleHint(isVisibleToUser);
    }

    private class WeekAdapter extends BaseAdapter {
        private ArrayList<DateTime> days;
        private Context context;

        public WeekAdapter(Context context, ArrayList<DateTime> days) {
            this.days = days;
            this.context = context;
        }

        @Override
        public int getCount() {
            return days.size();
        }

        @Override
        public DateTime getItem(int position) {
            return days.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            if (convertView == null) {
                convertView = LayoutInflater.from(context).inflate(R.layout.grid_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            DateTime dateTime = getItem(position);
            CalendarUtils utils = new CalendarUtils(UpdateStartDateForMonth(dateTime.getYear(), dateTime.getMonthOfYear(), dateTime.getDayOfMonth())); //计算农历工具类
            holder.daytext.setText(String.valueOf(dateTime.getDayOfMonth()));
            holder.lunarText.setText(utils.getChineseDate().trim()); //设置顶部农历

            int calendayYear = dateTime.getYear();
            int calendayMonth = dateTime.getMonthOfYear();
            int calenday = dateTime.getDayOfMonth();

            if (calendayYear == 2013 ||
                    calendayYear > todayYear ||
                    todayYear == calendayYear && todayMonth == calendayMonth && calenday > today ||
                    todayYear == calendayYear && calendayMonth > todayMonth) { //2014年1月1日以前和今天以后的日期不能点击
                holder.daytext.setTextColor(ContextCompat.getColor(getActivity(), R.color.color_999999));
                holder.lunarText.setTextColor(ContextCompat.getColor(getActivity(), R.color.gray_cccccc));
                holder.today.setVisibility(View.GONE);
                holder.redLine.setVisibility(View.INVISIBLE);
                Utils.setBackGround(convertView, getResources().getDrawable(R.color.white));
            } else if (todayYear == calendayYear && calendayMonth == todayMonth && calenday == today) { //今天
                holder.daytext.setTextColor(ContextCompat.getColor(getActivity(), R.color.app_color));
                holder.lunarText.setTextColor(ContextCompat.getColor(getActivity(), R.color.app_color));
                holder.today.setVisibility(View.VISIBLE);
                holder.redLine.setVisibility(View.INVISIBLE);
            } else {//今天之前的日期
                holder.daytext.setTextColor(ContextCompat.getColor(getActivity(), R.color.color_333333));
                holder.lunarText.setTextColor(ContextCompat.getColor(getActivity(), R.color.gray_cccccc));
                holder.today.setVisibility(View.GONE);
            }
            if (weekPager != null && weekPager.getSelectedDateTime() != null && weekPager.getSelectedDateTime().toLocalDate().equals(dateTime.toLocalDate())) {
                holder.daytext.setTextColor(ContextCompat.getColor(getActivity(), R.color.app_color));
                holder.lunarText.setTextColor(ContextCompat.getColor(getActivity(), R.color.app_color));
                holder.redLine.setVisibility(View.VISIBLE);
                Utils.setBackGround(convertView, getResources().getDrawable(R.color.color_fdf0f0));
            } else {
                holder.redLine.setVisibility(View.INVISIBLE);
                Utils.setBackGround(convertView, getResources().getDrawable(R.drawable.listview_selector_white_gray));
            }
            return convertView;
        }


        private Calendar UpdateStartDateForMonth(int year, int month, int day) {
            Calendar returnCalendar = Calendar.getInstance();
            returnCalendar.set(Calendar.YEAR, year);
            returnCalendar.set(Calendar.MONTH, month - 1);
            returnCalendar.set(Calendar.DAY_OF_MONTH, day);
            return returnCalendar;
        }
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            daytext = (TextView) view.findViewById(R.id.daytext);
            lunarText = (TextView) view.findViewById(R.id.lunarText);
            today = (TextView) view.findViewById(R.id.today);
            redLine = view.findViewById(R.id.redLine);
        }

        /**
         * 今天需要显示的线条
         */
        private View redLine;
        /**
         * 今天需要显示文字
         */
        private TextView today;
        /**
         * 日期
         */
        private TextView daytext;
        /**
         * 农历
         */
        private TextView lunarText;
    }


    @Override
    public void onDestroyView() {
        super.onDestroyView();
        BusProvider.getInstance().unregister(this);
    }
}
