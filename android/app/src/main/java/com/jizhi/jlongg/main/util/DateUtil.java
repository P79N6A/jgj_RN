package com.jizhi.jlongg.main.util;

import android.annotation.SuppressLint;
import android.text.TextUtils;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.LunarCalendar;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {

    /**
     * 某年某月有多少天
     *
     * @param year
     * @param month
     * @return year年month月有多少天
     */
    public static int getMonthDays(int year, int month) {
        if (month > 12) {
            month = 1;
            year += 1;
        } else if (month < 1) {
            month = 12;
            year -= 1;
        }
        int[] arr = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int days = 0;

        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            arr[1] = 29; // 闰年2月29天
        }

        try {
            days = arr[month - 1];
        } catch (Exception e) {
            e.getStackTrace();
        }
        return days;
    }

    public static int getYear() {
        return Calendar.getInstance().get(Calendar.YEAR);
    }

    public static int getMonth() {
        return Calendar.getInstance().get(Calendar.MONTH) + 1;
    }

    public static int getCurrentMonthDay() {
        return Calendar.getInstance().get(Calendar.DAY_OF_MONTH);
    }

    public static int getWeekDay() {
        return Calendar.getInstance().get(Calendar.DAY_OF_WEEK);
    }

    public static int getHour() {
        return Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
    }

    public static int getMinute() {
        return Calendar.getInstance().get(Calendar.MINUTE);
    }

    public static CustomDate getNextSunday() {

        Calendar c = Calendar.getInstance();
        c.add(Calendar.DATE, 7 - getWeekDay() + 1);
        CustomDate date = new CustomDate(c.get(Calendar.YEAR),
                c.get(Calendar.MONTH) + 1, c.get(Calendar.DAY_OF_MONTH));
        return date;
    }

    public static int[] getWeekSunday(int year, int month, int day, int pervious) {
        int[] time = new int[3];
        Calendar c = Calendar.getInstance();
        c.set(Calendar.YEAR, year);
        c.set(Calendar.MONTH, month);
        c.set(Calendar.DAY_OF_MONTH, day);
        c.add(Calendar.DAY_OF_MONTH, pervious);
        time[0] = c.get(Calendar.YEAR);
        time[1] = c.get(Calendar.MONTH) + 1;
        time[2] = c.get(Calendar.DAY_OF_MONTH);
        return time;

    }

    public static int getWeekDayFromDate(int year, int month) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(getDateFromString(year, month));
        int week_index = cal.get(Calendar.DAY_OF_WEEK) - 1;
        if (week_index < 0) {
            week_index = 0;
        }
        return week_index;
    }

    @SuppressLint("SimpleDateFormat")
    public static Date getDateFromString(int year, int month) {
        String dateString = year + "-" + (month > 9 ? month : ("0" + month)) + "-01";
        Date date = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            date = sdf.parse(dateString);
        } catch (ParseException e) {
            System.out.println(e.getMessage());
        }
        return date;
    }

    public static boolean isToday(CustomDate date) {
        return (date.year == DateUtil.getYear()
                && date.month == DateUtil.getMonth() && date.day == DateUtil
                .getCurrentMonthDay());
    }

    public static boolean isCurrentMonth(CustomDate date) {
        return (date.year == DateUtil.getYear() && date.month == DateUtil
                .getMonth());
    }

    /**
     * 校正当前年份，小于2014的，当2014
     */
    public static int checkDate() {
        int year = 0;
        Calendar calendar = Calendar.getInstance();
        int systemYear = calendar.get(Calendar.YEAR);
        if (systemYear < 2014) {
            year = 2014;
        } else {
            return systemYear;
        }
        return year;
    }


    /**
     * 计算两个日期相差的月份数
     *
     * @param date1   日期1
     * @param date2   日期2
     * @param pattern 日期1和日期2的日期格式
     * @return 相差的月份数
     * @throws ParseException
     */
    public static int countMonths(String date1, String date2, String pattern) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);

        Calendar c1 = Calendar.getInstance();
        Calendar c2 = Calendar.getInstance();

        c1.setTime(sdf.parse(date1));
        c2.setTime(sdf.parse(date2));

        int year = c2.get(Calendar.YEAR) - c1.get(Calendar.YEAR);

        //开始日期若小月结束日期
        if (year < 0) {
            year = -year;
            return year * 12 + c1.get(Calendar.MONTH) - c2.get(Calendar.MONTH);
        }
        return year * 12 + c2.get(Calendar.MONTH) - c1.get(Calendar.MONTH);
    }

    /**
     * 月份或者天数 前面加0 的数据
     * 比如5月  变成05
     *
     * @throws ParseException
     */
    public static String dateToAddZeroDate(int date) {
        return date < 10 ? "0" + date : date + "";
    }


    /**
     * 将 2018年6月20日 转换成2018-06-20
     *
     * @param date 日期1
     * @throws ParseException
     */
    public static String dateFormat(String date) {
        if (TextUtils.isEmpty(date)) {
            return null;
        }
        date = date.replace("年", "-");
        if (date.contains("日")) {
            return date.replace("月", "-").replace("日", "");
        } else {
            return date.replace("月", "");
        }
    }


    /**
     * 根据年月日获取当前时间戳的0点开始的时间戳
     * 2018-08-10  获取的就是2018年8月10日0点的时间戳
     *
     * @return
     */
    public static long getTimeInMillis(String date) {
        if (TextUtils.isEmpty(date) || date.length() < 8) {
            return 0;
        }
        String[] dates = getDateArray(date);
        Calendar calendar = Calendar.getInstance();
        calendar.set(calendar.YEAR, Integer.parseInt(dates[0]));
        calendar.set(calendar.MONTH, Integer.parseInt(dates[1]));
        calendar.set(calendar.DAY_OF_MONTH, Integer.parseInt(dates[2]));
        calendar.set(Calendar.HOUR_OF_DAY, 0); //设置小时
        calendar.set(Calendar.MINUTE, 0);  //设置分钟
        calendar.set(Calendar.SECOND, 0); //设置秒
        calendar.set(Calendar.MILLISECOND, 0); //设置毫秒
        return calendar.getTimeInMillis();
    }


    /**
     * 将20180810这种日期格式拆解为 数组
     * int[0] = year
     * int[0] = month
     * int[0] = day
     *
     * @param date
     * @return
     */
    public static String[] getDateArray(String date) {
        if (TextUtils.isEmpty(date) || !date.contains("-")) {
            return null;
        }
        return date.split("-");
    }

    /**
     * 获取农历
     *
     * @param year
     * @param month
     * @param day
     * @return
     */
    public static String getLunarDate(int year, int month, int day) {
        StringBuilder builder = new StringBuilder();
        builder.append("(");
        int[] date = LunarCalendar.solarToLunar(year, month, day);
        builder.append(DatePickerUtil.getLunarMonth(date[1]) + "月");
        builder.append(DatePickerUtil.getLunarDate(date[2]));
        builder.append(")");
        return builder.toString();
    }


    /**
     * 根据年月日获取当前时间的毫秒数
     *
     * @param year
     * @param month
     * @param day
     * @return
     */
    public static long getTimeInMillis(int year, int month, int day) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(calendar.YEAR, year);
        calendar.set(calendar.MONTH, month - 1);
        calendar.set(calendar.DAY_OF_MONTH, day);
        return calendar.getTimeInMillis();
    }
}
