package noman.weekcalendar;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;

import org.joda.time.DateTime;

import java.text.DateFormatSymbols;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;
import noman.weekcalendar.eventbus.Event;
import noman.weekcalendar.view.WeekPager;

/**
 * 横向滚动的日历
 */
public class WeekCalendar extends LinearLayout {

    public WeekCalendar(Context context) {
        super(context);
        init();
    }

    public WeekCalendar(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();

    }

    public WeekCalendar(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        setOrientation(VERTICAL);
        GridView daysName = getDaysNames();
        WeekPager weekPager = new WeekPager(getContext());
        addView(daysName, 0);
        addView(weekPager);
    }

    private GridView getDaysNames() {
        GridView daysName = new GridView(getContext());
        daysName.setNumColumns(7);
        daysName.setAdapter(new BaseAdapter() {
            private String[] days = getWeekDayNames();

            public int getCount() {
                return days.length;
            }

            @Override
            public String getItem(int position) {
                return days[position];
            }

            @Override
            public long getItemId(int position) {
                return 0;
            }

            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                ViewHolder holder;
                if (convertView == null) {
                    LayoutInflater inflater = LayoutInflater.from(getContext());
                    convertView = inflater.inflate(R.layout.week_day_grid_item, null, false);
                    holder = new ViewHolder(convertView);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                TextView day = holder.day;
                day.setText(days[position]);
                day.setTextColor(ContextCompat.getColor(getContext(), position == 0 || position == days.length - 1 ? R.color.color_eb4e4e : R.color.gray_666666));
                return convertView;
            }

            private String[] getWeekDayNames() {
                String[] names = DateFormatSymbols.getInstance().getShortWeekdays();
                List<String> daysName = new ArrayList<>(Arrays.asList(names));
                daysName.remove(0);
                daysName.add(daysName.remove(0));
                int size = daysName.size();
                for (int i = 0; i < size; i++) {
                    String dateName = daysName.get(i);
                    if (dateName.contains("星期")) {
                        daysName.set(i, dateName.replace("星期", ""));
                    } else if (dateName.contains("周")) {
                        daysName.set(i, dateName.replace("周", ""));
                    }
                }
                names = new String[daysName.size()];
                daysName.toArray(names);
                return names;
            }
        });
        return daysName;
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            day = (TextView) view.findViewById(R.id.daytext);
        }

        private TextView day;
    }


    /**
     * 移动到上一天
     */
    public void moveToPrevious() {
        BusProvider.getInstance().post(new Event.UpdateSelectedDateEvent(-1));
    }

    /**
     * 移动到下一天
     */
    public void moveToNext() {
        BusProvider.getInstance().post(new Event.UpdateSelectedDateEvent(1));
    }

    public void setSelectedDate(DateTime selectedDate) {
        BusProvider.getInstance().post(new Event.JumpDateEvent(selectedDate));
    }

}
