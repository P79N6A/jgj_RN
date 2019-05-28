package com.hcs.uclient.utils;

import com.jizhi.jlongg.main.bean.CalendarModel;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * CName:日期辅助类
 * User: hcs
 * Date: 2016-06-23
 * Time: 14:50
 */
public class DatePickerUtil {

    /**
     * 年范围在：1900~今年
     *
     * @return
     */
    public static ArrayList<CalendarModel> getYearData(int startYear, int endYear) {
        ArrayList<CalendarModel> list = new ArrayList<>();
        for (int i = startYear; i <= endYear; i++) {
            CalendarModel calendarModel = new CalendarModel();
            calendarModel.setCalendarYear(String.valueOf(i));
            list.add(calendarModel);
        }
        return list;
    }

    public static ArrayList<CalendarModel> getMonthData(int startIndex, int endIndex) {
        ArrayList<CalendarModel> list = new ArrayList<>();
        for (int i = startIndex; i <= endIndex; i++) {
            CalendarModel calendarModel = new CalendarModel();
            calendarModel.setSolarCalendarMonth(i + "");
            calendarModel.setLunarCalendarMonth(DatePickerUtil.getLunarMonth(i));
            list.add(calendarModel);
        }
        return list;
    }

    /**
     * 日范围在1~lastDay
     *
     * @param lastDay
     * @return
     */
    public static ArrayList<CalendarModel> getDayData(int lastDay) {
        ArrayList<CalendarModel> list = new ArrayList<>();
        for (int i = 1; i <= lastDay; i++) {
            CalendarModel calendarModel = new CalendarModel();
            calendarModel.setSolarCalendarDate(String.valueOf(i));
            calendarModel.setLunarCalendarMonth(DatePickerUtil.getLunarDate(i));
            list.add(calendarModel);
        }
        return list;
    }

    /**
     * 初始化周
     *
     * @return
     */
    public static ArrayList<CalendarModel> getWeek() {
        ArrayList<CalendarModel> list = new ArrayList<>();
        for (int i = 1; i <= 7; i++) {
            CalendarModel calendarModel = new CalendarModel();
            switch (i) {
                case 1:
                    calendarModel.setWeekStr("周一");
                    break;
                case 2:
                    calendarModel.setWeekStr("周二");
                    break;
                case 3:
                    calendarModel.setWeekStr("周三");
                    break;
                case 4:
                    calendarModel.setWeekStr("周四");
                    break;
                case 5:
                    calendarModel.setWeekStr("周五");
                    break;
                case 6:
                    calendarModel.setWeekStr("周六");
                    break;
                case 7:
                    calendarModel.setWeekStr("周日");
                    break;
            }
            list.add(calendarModel);
        }
        return list;
    }

    /**
     * 初始化农历月
     *
     * @return
     */
    public static String getLunarMonth(int i) {
        String lunarMonth = "";
        switch (i) {
            case 1:
                lunarMonth = "正";
                break;
            case 2:
                lunarMonth = "二";
                break;
            case 3:
                lunarMonth = "三";
                break;
            case 4:
                lunarMonth = "四";
                break;
            case 5:
                lunarMonth = "五";
                break;
            case 6:
                lunarMonth = "六";
                break;
            case 7:
                lunarMonth = "七";
                break;
            case 8:
                lunarMonth = "八";
                break;
            case 9:
                lunarMonth = "九";
                break;
            case 10:
                lunarMonth = "十";
                break;
            case 11:
                lunarMonth = "冬";
                break;
            case 12:
                lunarMonth = "腊";
                break;
        }
        return lunarMonth;
    }

    /**
     * 获取特定年月对应的天数
     *
     * @param year
     * @param month
     * @return
     */
    public static int getLastDay(int year, int month) {
        if (month == 2) {
            // 2月闰年的话返回29，防止28
            return isLeapYear(year) ? 29 : 28;
        }
        // 一三五七八十腊，三十一天永不差
        return month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 ? 31 : 30;
    }

    /**
     * 初始化农历日
     *
     * @return
     */
    public static String getLunarDate(int i) {
        String lunarMonth = "";
        switch (i) {
            case 1:
                lunarMonth = "初一";
                break;
            case 2:
                lunarMonth = "初二";
                break;
            case 3:
                lunarMonth = "初三";
                break;
            case 4:
                lunarMonth = "初四";
                break;
            case 5:
                lunarMonth = "初五";
                break;
            case 6:
                lunarMonth = "初六";
                break;
            case 7:
                lunarMonth = "初七";
                break;
            case 8:
                lunarMonth = "初八";
                break;
            case 9:
                lunarMonth = "初九";
                break;
            case 10:
                lunarMonth = "初十";
                break;
            case 11:
                lunarMonth = "十一";
                break;
            case 12:
                lunarMonth = "十二";
                break;
            case 13:
                lunarMonth = "十三";
                break;
            case 14:
                lunarMonth = "十四";
                break;
            case 15:
                lunarMonth = "十五";
                break;
            case 16:
                lunarMonth = "十六";
                break;
            case 17:
                lunarMonth = "十七";
                break;
            case 18:
                lunarMonth = "十八";
                break;
            case 19:
                lunarMonth = "十九";
                break;
            case 20:
                lunarMonth = "二十";
                break;
            case 21:
                lunarMonth = "廿一";
                break;
            case 22:
                lunarMonth = "廿二";
                break;
            case 23:
                lunarMonth = "廿三";
                break;
            case 24:
                lunarMonth = "廿四";
                break;
            case 25:
                lunarMonth = "廿五";
                break;
            case 26:
                lunarMonth = "廿六";
                break;
            case 27:
                lunarMonth = "廿七";
                break;
            case 28:
                lunarMonth = "廿八";
                break;
            case 29:
                lunarMonth = "廿九";
                break;
            case 30:
                lunarMonth = "三十";
                break;
        }

        return lunarMonth;
    }

    /**
     * 判断是否闰年
     *
     * @param year
     * @return
     */
    public static boolean isLeapYear(int year) {
        return (year % 100 == 0 && year % 400 == 0) || (year % 100 != 0 && year % 4 == 0);
    }

    /**
     * 年范围在：1900~今年
     *
     * @return
     */
    public static int getYearCurrent(List<CalendarModel> yearList, int year) {
        for (int i = 1; i <= yearList.size() - 1; i++) {
            if (yearList.get(i).getCalendarYear().equals(year + "")) {
                return i;
            }
        }
        return 0;
    }


    /**
     * 获取今天的日期
     *
     * @return
     */
    public static Calendar getTodayDate() {
        int[] date = new int[3];
        Calendar calendar = Calendar.getInstance();
        date[0] = calendar.get(Calendar.YEAR);
        date[1] = calendar.get(Calendar.MONTH);
        date[2] = calendar.get(Calendar.DAY_OF_MONTH);
        return calendar;
    }

    /**
     * 获取当年的第一天
     *
     * @return
     */
    public static Calendar getCurrYearFirst() {
        Calendar currCal = Calendar.getInstance();
        int currentYear = currCal.get(Calendar.YEAR);
        return getYearFirst(currentYear);
    }

    /**
     * 获取某年第一天日期
     *
     * @param year 年份
     * @return Date
     */
    public static Calendar getYearFirst(int year) {
        int[] date = new int[3];
        Calendar calendar = Calendar.getInstance();
        calendar.clear();
        calendar.set(Calendar.YEAR, year);
        date[0] = calendar.get(Calendar.YEAR);
        date[1] = calendar.get(Calendar.MONTH);
        date[2] = calendar.get(Calendar.DAY_OF_MONTH);
        return calendar;
    }

    /**
     * 支持转换的最小农历年份
     */
    public static final int MIN_YEAR = 1900;
    /**
     * 支持转换的最大农历年份
     */
    public static final int MAX_YEAR = 2099;

    /**
     * 公历每月前的天数
     */
    private static final int DAYS_BEFORE_MONTH[] = {0, 31, 59, 90, 120, 151,
            181, 212, 243, 273, 304, 334, 365};

    /**
     * 用来表示1900年到2099年间农历年份的相关信息，共24位bit的16进制表示，其中： 1. 前4位表示该年闰哪个月； 2.
     * 5-17位表示农历年份13个月的大小月分布，0表示小，1表示大； 3. 最后7位表示农历年首（正月初一）对应的公历日期。
     * <p>
     * 以2014年的数据0x955ABF为例说明： 1001 0101 0101 1010 1011 1111 闰九月 农历正月初一对应公历1月31号
     */
    private static final int LUNAR_INFO[] = {0x84B6BF,/* 1900 */
            0x04AE53, 0x0A5748, 0x5526BD, 0x0D2650, 0x0D9544, 0x46AAB9, 0x056A4D,
            0x09AD42, 0x24AEB6, 0x04AE4A,/* 1901-1910 */
            0x6A4DBE, 0x0A4D52, 0x0D2546, 0x5D52BA, 0x0B544E, 0x0D6A43,
            0x296D37, 0x095B4B, 0x749BC1, 0x049754,/* 1911-1920 */
            0x0A4B48, 0x5B25BC, 0x06A550, 0x06D445, 0x4ADAB8, 0x02B64D,
            0x095742, 0x2497B7, 0x04974A, 0x664B3E,/* 1921-1930 */
            0x0D4A51, 0x0EA546, 0x56D4BA, 0x05AD4E, 0x02B644, 0x393738,
            0x092E4B, 0x7C96BF, 0x0C9553, 0x0D4A48,/* 1931-1940 */
            0x6DA53B, 0x0B554F, 0x056A45, 0x4AADB9, 0x025D4D, 0x092D42,
            0x2C95B6, 0x0A954A, 0x7B4ABD, 0x06CA51,/* 1941-1950 */
            0x0B5546, 0x555ABB, 0x04DA4E, 0x0A5B43, 0x352BB8, 0x052B4C,
            0x8A953F, 0x0E9552, 0x06AA48, 0x6AD53C,/* 1951-1960 */
            0x0AB54F, 0x04B645, 0x4A5739, 0x0A574D, 0x052642, 0x3E9335,
            0x0D9549, 0x75AABE, 0x056A51, 0x096D46,/* 1961-1970 */
            0x54AEBB, 0x04AD4F, 0x0A4D43, 0x4D26B7, 0x0D254B, 0x8D52BF,
            0x0B5452, 0x0B6A47, 0x696D3C, 0x095B50,/* 1971-1980 */
            0x049B45, 0x4A4BB9, 0x0A4B4D, 0xAB25C2, 0x06A554, 0x06D449,
            0x6ADA3D, 0x0AB651, 0x095746, 0x5497BB,/* 1981-1990 */
            0x04974F, 0x064B44, 0x36A537, 0x0EA54A, 0x86B2BF, 0x05AC53,
            0x0AB647, 0x5936BC, 0x092E50, 0x0C9645,/* 1991-2000 */
            0x4D4AB8, 0x0D4A4C, 0x0DA541, 0x25AAB6, 0x056A49, 0x7AADBD,
            0x025D52, 0x092D47, 0x5C95BA, 0x0A954E,/* 2001-2010 */
            0x0B4A43, 0x4B5537, 0x0AD54A, 0x955ABF, 0x04BA53, 0x0A5B48,
            0x652BBC, 0x052B50, 0x0A9345, 0x474AB9,/* 2011-2020 */
            0x06AA4C, 0x0AD541, 0x24DAB6, 0x04B64A, 0x6a573D, 0x0A4E51,
            0x0D2646, 0x5E933A, 0x0D534D, 0x05AA43,/* 2021-2030 */
            0x36B537, 0x096D4B, 0xB4AEBF, 0x04AD53, 0x0A4D48, 0x6D25BC,
            0x0D254F, 0x0D5244, 0x5DAA38, 0x0B5A4C,/* 2031-2040 */
            0x056D41, 0x24ADB6, 0x049B4A, 0x7A4BBE, 0x0A4B51, 0x0AA546,
            0x5B52BA, 0x06D24E, 0x0ADA42, 0x355B37,/* 2041-2050 */
            0x09374B, 0x8497C1, 0x049753, 0x064B48, 0x66A53C, 0x0EA54F,
            0x06AA44, 0x4AB638, 0x0AAE4C, 0x092E42,/* 2051-2060 */
            0x3C9735, 0x0C9649, 0x7D4ABD, 0x0D4A51, 0x0DA545, 0x55AABA,
            0x056A4E, 0x0A6D43, 0x452EB7, 0x052D4B,/* 2061-2070 */
            0x8A95BF, 0x0A9553, 0x0B4A47, 0x6B553B, 0x0AD54F, 0x055A45,
            0x4A5D38, 0x0A5B4C, 0x052B42, 0x3A93B6,/* 2071-2080 */
            0x069349, 0x7729BD, 0x06AA51, 0x0AD546, 0x54DABA, 0x04B64E,
            0x0A5743, 0x452738, 0x0D264A, 0x8E933E,/* 2081-2090 */
            0x0D5252, 0x0DAA47, 0x66B53B, 0x056D4F, 0x04AE45, 0x4A4EB9,
            0x0A4D4C, 0x0D1541, 0x2D92B5 /* 2091-2099 */
    };

    /**
     * 将农历日期转换为公历日期
     *
     * @param year     农历年份
     * @param month    农历月
     * @param monthDay 农历日
     *                 返回农历日期对应的公历日期，year0, month1, day2.
     */
    public static final int[] lunarToSolar(int year, int month, int monthDay) {
        boolean isLeapMonth = isLeapYear(year); //是否是闰月
        int dayOffset;
        int leapMonth;
        int i;
        if (year < MIN_YEAR || year > MAX_YEAR || month < 1 || month > 12
                || monthDay < 1 || monthDay > 30) {
            throw new IllegalArgumentException(
                    "Illegal lunar date, must be like that:\n\t"
                            + "year : 1900~2099\n\t" + "month : 1~12\n\t"
                            + "day : 1~30");
        }

        dayOffset = (LUNAR_INFO[year - MIN_YEAR] & 0x001F) - 1;

        if (((LUNAR_INFO[year - MIN_YEAR] & 0x0060) >> 5) == 2)
            dayOffset += 31;

        for (i = 1; i < month; i++) {
            if ((LUNAR_INFO[year - MIN_YEAR] & (0x80000 >> (i - 1))) == 0)
                dayOffset += 29;
            else
                dayOffset += 30;
        }

        dayOffset += monthDay;
        leapMonth = (LUNAR_INFO[year - MIN_YEAR] & 0xf00000) >> 20;

        // 这一年有闰月
        if (leapMonth != 0) {
            if (month > leapMonth || (month == leapMonth && isLeapMonth)) {
                if ((LUNAR_INFO[year - MIN_YEAR] & (0x80000 >> (month - 1))) == 0)
                    dayOffset += 29;
                else
                    dayOffset += 30;
            }
        }

        if (dayOffset > 366 || (year % 4 != 0 && dayOffset > 365)) {
            year += 1;
            if (year % 4 == 1)
                dayOffset -= 366;
            else
                dayOffset -= 365;
        }

        int[] solarInfo = new int[3];
        for (i = 1; i < 13; i++) {
            int iPos = DAYS_BEFORE_MONTH[i];
            if (year % 4 == 0 && i > 2) {
                iPos += 1;
            }

            if (year % 4 == 0 && i == 2 && iPos + 1 == dayOffset) {
                solarInfo[1] = i;
                solarInfo[2] = dayOffset - 31;
                break;
            }

            if (iPos >= dayOffset) {
                solarInfo[1] = i;
                iPos = DAYS_BEFORE_MONTH[i - 1];
                if (year % 4 == 0 && i > 2) {
                    iPos += 1;
                }
                if (dayOffset > iPos)
                    solarInfo[2] = dayOffset - iPos;
                else if (dayOffset == iPos) {
                    if (year % 4 == 0 && i == 2)
                        solarInfo[2] = DAYS_BEFORE_MONTH[i]
                                - DAYS_BEFORE_MONTH[i - 1] + 1;
                    else
                        solarInfo[2] = DAYS_BEFORE_MONTH[i]
                                - DAYS_BEFORE_MONTH[i - 1];

                } else
                    solarInfo[2] = dayOffset;
                break;
            }
        }
        solarInfo[0] = year;

        return solarInfo;
    }

    /**
     * 将年月日的int数组转换为Calendar对象
     *
     * @param date
     */
    public static Calendar strongYearMonthDayToCalendar(int[] date) {
        final Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, date[0]);
        calendar.set(Calendar.MONTH, date[1] - 1);
        calendar.set(Calendar.DAY_OF_MONTH, date[2]);
        return calendar;
    }


}
