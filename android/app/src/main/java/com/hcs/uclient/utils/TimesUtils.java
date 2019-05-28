package com.hcs.uclient.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.jizhi.jlongg.main.util.Constance;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

@SuppressLint("SimpleDateFormat")
public class TimesUtils {
    /**
     * 毫秒换为时间 yyyy-MM-dd HH:mm:ss
     *
     * @param strDate
     * @return
     */
    public static String strToDateLong(long strDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String date = sdf.format(new Date(strDate * 1000));
        return date;
    }

    public static String getCurrYear() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        String date = sdf.format(new Date());
        return date;
    }

    /**
     * 获取今天时间
     * 格式yyyy-mm-dd (今天)
     *
     * @return
     */
    public static String getTodayDate() {
        //今天时间
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        String todayTime = df.format(new Date());
        return todayTime;
    }

    public static long strToLong(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return time;
    }

    public static String getYYYYMMDDDateStr(String strDate) {
        String newStr = "";
        try {
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
            Date date = sdf1.parse(strDate);//提取格式中的日期
            newStr = sdf1.format(date); //改变格式
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return newStr;
    }

    public static String getNowTime() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String time = df.format(new Date());
        return time;
    }

    public static String getNowTimeM() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        String time = df.format(new Date());
        return time;
    }

    public static String getYYYYMMDDTime() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String time = df.format(new Date());
        return time;
    }

    public static String getyyyyMMddTime() {
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        String time = df.format(new Date());
        return time;
    }

    public static String getHHMM() {
        SimpleDateFormat df = new SimpleDateFormat(" HH:mm");
        String time = df.format(new Date());
        return time;
    }

    public static int getHour() {
        Calendar cal = Calendar.getInstance(Locale.CHINA);
        cal.add(Calendar.DATE, -1);
        return cal.get(Calendar.HOUR_OF_DAY);
    }

    public static String getMsgdata(String date) {
        if (TextUtils.isEmpty(date)) {
            return null;
        }
        if (date.length() < 15) {
            return date;
        }
        try {
            // 当前的时间
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            long times = ((Date) df.parse(getNowTime())).getTime();
            // 比较的时间
            long dates = ((Date) df.parse(date)).getTime();

            if (dates == times) {
                // 如果的今天就小时 小时和分钟
                String[] newdate = (date.split(" ")[1]).split(":");
                return newdate[0] + ":" + newdate[1];
            } else {
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.DATE, -1);
                String yesterday = (new SimpleDateFormat("yyyy-MM-dd ").format(cal.getTime())).trim();
                String[] year = (date.split(" ")[0]).split("-");
                if (!year[0].trim().equals((cal.get(Calendar.YEAR) + "").trim())) {
                    //昨年
                    String[] d = date.split(" ");
                    return d[0] + " " + (d[1].split(":")[0]) + ":" + (d[1].split(":")[1]);
                }
                if (date.split(" ")[0].trim().equals(yesterday)) {
                    String[] newdate = (date.split(" ")[1]).split(":");
                    return "昨天" + " " + newdate[0] + ":" + newdate[1];
                } else {
                    //今年昨天以前
                    String[] newdates1 = (date.split(" ")[0]).split("-");
                    String[] newdates2 = (date.split(" ")[1]).split(":");
                    return newdates1[1] + "-" + newdates1[2] + " " + newdates2[0] + ":" + newdates2[1];
                }

            }
        } catch (Exception e) {
        }
        return date;
    }

    public static String getNowTimeAdd30() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MINUTE, calendar.get(Calendar.MINUTE) + 30);
        String time = calendar.getTimeInMillis() / 1000 + "";
        return time;
    }

    public static String getTimeMintus1(String strDate) {
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            Date date = df.parse(strDate);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 1);
            return calendar.get(Calendar.YEAR) + "" + (calendar.get(Calendar.MONTH) + 1) + "" + calendar.get(Calendar.DAY_OF_MONTH);
        } catch (Exception e) {
            LUtils.e(e.getMessage());
        }

        return "";
    }

    public static String dataFormat(String data) {
        // Date nowTime = new Date();
        // System.out.println(nowTime);
        SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return time.format(data);
    }

    public static String dataFormatMinAndSecond(long time) {
        String minute = (time / 60) + "";
        String second = (time % 60) + "";
        if (minute.length() == 1) {
            minute = "0" + minute;
        }
        if (second.length() == 1) {
            second = "0" + second;
        }
        return minute + ":" + second;
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String getTime() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
        String time = df.format(new Date());
        return time;
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String getCurrentTime() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日");
        String time = df.format(new Date());
        String mWay = String.valueOf(Calendar.getInstance().get(Calendar.DAY_OF_WEEK));
        if ("1".equals(mWay)) {
            mWay = "天";
        } else if ("2".equals(mWay)) {
            mWay = "一";
        } else if ("3".equals(mWay)) {
            mWay = "二";
        } else if ("4".equals(mWay)) {
            mWay = "三";
        } else if ("5".equals(mWay)) {
            mWay = "四";
        } else if ("6".equals(mWay)) {
            mWay = "五";
        } else if ("7".equals(mWay)) {
            mWay = "六";
        }
        return time + " 星期" + mWay;
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String getCurrentTimeNoWeek() {
        SimpleDateFormat df = new SimpleDateFormat("yyyy年MM月dd日");
        return df.format(new Date());
//        String mWay = String.valueOf(Calendar.getInstance().get(Calendar.DAY_OF_WEEK));
//        if ("1".equals(mWay)) {
//            mWay = "天";
//        } else if ("2".equals(mWay)) {
//            mWay = "一";
//        } else if ("3".equals(mWay)) {
//            mWay = "二";
//        } else if ("4".equals(mWay)) {
//            mWay = "三";
//        } else if ("5".equals(mWay)) {
//            mWay = "四";
//        } else if ("6".equals(mWay)) {
//            mWay = "五";
//        } else if ("7".equals(mWay)) {
//            mWay = "六";
//        }
//        return time + " 星期" + mWay;
    }

    /**
     * 判断当前日期是星期几
     *
     * @return dayForWeek 判断结果
     * @Exception 发生异常
     */
    public static String getWeek(int year, int month, int day) {
        String date;
        String pTime = (year * 10000 + month * 100 + day) + "";
        String Week = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        Calendar c = Calendar.getInstance();
        try {
            c.setTime(format.parse(pTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 1) {
            Week = "星期日";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 2) {
            Week = "星期一";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 3) {
            Week = "星期二";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 4) {
            Week = "星期三";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 5) {
            Week = "星期四";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 6) {
            Week = "星期五";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 7) {
            Week = "星期六";
        }
        boolean times = TimesUtils.isNowtime(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + ""));
        if (times) {
            date = year + "年" + (month < 10 ? "0" + month : month) + "月" + (day < 10 ? "0" + day : day) + "日" + " " + Week + "(今天)";
        } else {
            date = year + "年" + (month < 10 ? "0" + month : month) + "月" + (day < 10 ? "0" + day : day) + "日" + " " + Week;
        }
        return date;
    }


    /**
     * 判断当前日期是星期几
     *
     * @return dayForWeek 判断结果
     * @Exception 发生异常
     */
    public static String getWeekString(int year, int month, int day) {
        String pTime = (year * 10000 + month * 100 + day) + "";
        String week = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        Calendar c = Calendar.getInstance();
        try {
            c.setTime(format.parse(pTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 1) {
            week = "星期日";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 2) {
            week = "星期一";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 3) {
            week = "星期二";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 4) {
            week = "星期三";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 5) {
            week = "星期四";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 6) {
            week = "星期五";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 7) {
            week = "星期六";
        }
        return week;
    }


    /**
     * 判断当前日期是星期几
     *
     * @return dayForWeek 判断结果
     * @Exception 发生异常
     */
    public static String getWeekSimple(int year, int month, int day) {
        String pTime = (year * 10000 + month * 100 + day) + "";
        String Week = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        Calendar c = Calendar.getInstance();
        try {
            c.setTime(format.parse(pTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 1) {
            Week = "周日";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 2) {
            Week = "周一";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 3) {
            Week = "周二";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 4) {
            Week = "周三";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 5) {
            Week = "周四";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 6) {
            Week = "周五";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 7) {
            Week = "周六";
        }
        return Week;
    }

    //  String pTime = "2012-03-12";
    public static String getJuTiWeek(int year, int month, int day) {
        String pTime = (year * 10000 + month * 100 + day) + "";
        String Week = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        Calendar c = Calendar.getInstance();
        try {
            c.setTime(format.parse(pTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 1) {
            Week = "星期日";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 2) {
            Week = "星期一";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 3) {
            Week = "星期二";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 4) {
            Week = "星期三";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 5) {
            Week = "星期四";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 6) {
            Week = "星期五";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 7) {
            Week = "星期六";
        }
        return year + "年" + (month < 10 ? "0" + month : month) + "月" + (day < 10 ? "0" + day : day) + "日" + " " + Week;
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String simplemmddhhmm(long time) {
        SimpleDateFormat df = new SimpleDateFormat("MM-dd hh:mm");
        return df.format(new Date(time * 1000L));
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String simpleyyyyMMddhhmm(long time) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        return df.format(new Date(time * 1000L));
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String simpleyyyyMMDD(long time) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy.MM.dd");
        return df.format(new Date(time * 1000L));
    }

    /**
     * 获取当前年月日
     *
     * @return
     */
    public static String simpleyyyyMMdd(long time) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        return df.format(new Date(time * 1000L));

    }

    /**
     * 开始时间戳，结束时间戳，得分布时间差
     */
    public static String timeInterval(long starttime, long endtime) {
        StringBuffer sb = new StringBuffer();
        long time = (endtime - starttime);
        long mill = (long) Math.ceil(time);// 秒前
        long minute = (long) Math.ceil(time / 60f);// 分钟前
        long hour = (long) Math.ceil(time / 60 / 60f);// 小时
        long day = (long) Math.ceil(time / 24 / 60 / 60f);// 天前
        long Month = (long) Math.ceil(time / 30 / 24 / 60 / 60f);// 月前
        if (Month - 1 > 0) {
            sb.append(Month + "个月");
        } else if (day - 1 > 0) {
            sb.append(day + "天");
        } else if (hour - 1 > 0) {
            if (hour >= 24) {
                sb.append("1天");
            } else {
                sb.append(hour + "小时");
            }
        } else if (minute - 1 > 0) {
            if (minute == 60) {
                sb.append("1小时");
            } else {
                sb.append(minute + "分钟");
            }
        } else if (mill - 1 > 0) {
            if (mill == 60) {
                sb.append("1分钟");
            } else {
                sb.append(mill + "秒");
            }
        } else {
            sb.append("刚刚");
        }
        if (!sb.toString().equals("刚刚")) {
            sb.append("前");
        }
        sb.append("发布");
        return sb.toString();
    }

    /**
     * 工期耗时时长:start_time:启动时间;end_time:竣工时间
     */
    public static String limitTimeProject(long start_time, long end_time) {
        StringBuffer sb = new StringBuffer();
        long time = (end_time - start_time);
        long day = (long) Math.ceil(time / 24 / 60 / 60f);// 天前
        long Month = (long) Math.ceil(time / 30 / 24 / 60 / 60f);// 月前
        if (Month - 12 > 0) {
            sb.append(Month + "个月");
        } else {
            sb.append(day + "天");
        }
        return sb.toString();

    }

    public static String limitTimeProject(int timelimit) {
        int y = timelimit / 360;
        int m = (timelimit % 360) / 30;
        int d = (timelimit % 360) % 30;
        StringBuffer buffer = new StringBuffer();
        if (y != 0) {
            buffer.append(y + "年");
        }
        if (m != 0) {
            buffer.append(m + "个月");
        }
        if (d != 0) {
            buffer.append(d + "天");
        }

        if (buffer.toString().equals("")) {
            buffer.append("0天");
        }
        return buffer.toString();

    }

    public static long timeParseTolong(String times) {
        if (null == times || times.equals("")) {
            times = "0";
        }
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
                    "yyyy-MM-dd");
            Date date = simpleDateFormat.parse(times);
            long timeStemp = date.getTime() / 1000;
            return timeStemp;
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 获取当前时间
     */
    public static long getNowTimeMill() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar c = Calendar.getInstance(Locale.CHINESE);
        long nowtime = strToLong(sdf.format(c.getTime()));
        return nowtime;
    }

    /**
     * 获取当前时间加一个月的毫秒
     */
    public static long getNowTimeMillAdd1Month(Context context) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar c = Calendar.getInstance(Locale.CHINESE);
        int mnonth = c.get(Calendar.MONTH) + 1;
        c.set(Calendar.MONTH, mnonth);
        long nowtimeAdd1Month = strToLong(sdf.format(c.getTime()));
        SPUtils.put(context, Constance.OLDTIME, nowtimeAdd1Month, Constance.JLONGG);
        return nowtimeAdd1Month;
    }

    /**
     * 判断当前时间与本地时间谁大 当前时间大返回true需要跟新
     *
     * @param context
     * @return
     */
    public static boolean isBigNowTime(Context context) {
        long t = 0;
        long oldTime = (Long) SPUtils.get(context, Constance.OLDTIME, t, Constance.JLONGG);
        long nowTime = getNowTimeMill();
        if (oldTime == 0) {
            return true;
        } else if (oldTime < nowTime) {
            return true;
        }
        return false;
    }

    /**
     * 判断两个时间大小 返回true正常
     *
     * @param startTime
     * @param endTime
     * @return
     */
    public static boolean isBigTime(String startTime, String endTime) {


        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            long startTimeMill = ((Date) df.parse(startTime)).getTime();
            long endTimeMill = ((Date) df.parse(endTime)).getTime();

            if (endTimeMill >= startTimeMill) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {

        }
        return false;
    }

    /**
     * 将20150104格式转化为年月日
     */
    public static String ChageStrToDate(String str) {// 20150102
        if (TextUtils.isEmpty(str) && str.length() != 8 || str.equals("0")) {
            return "";
        }
        Log.e("str", str);
        StringBuilder sb = new StringBuilder();
        String year = str.substring(0, 4) + "-";
        String month = str.substring(4, 6) + "-";
        String day = str.substring(6, 8);
        sb.append(year + month + day);
        return sb.toString();
    }

    /**
     * 将20150104格式转化为年月日
     */
    public static Calendar getClender(String str) {// 20150102
        Calendar calendar = Calendar.getInstance();
        if (TextUtils.isEmpty(str) && str.length() != 8 || str.equals("0")) {
            return calendar;
        }
        Log.e("str", str);
//        StringBuilder sb = new StringBuilder();
//        String year = str.substring(0, 4) ;
//        String month = str.substring(4, 6) ;
//        String day = str.substring(6, 8);
//        calendar.set(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(day));
        return calendar;
    }

    /**
     * 得到当前年月日
     */
    public static int[] getCurrentTimeYearMonthDay() {
        int[] time = new int[3];
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String times = df.format(new Date());
        String[] str = times.split("-");
        for (int i = 0; i < str.length; i++) {
            time[i] = Integer.valueOf(str[i]);
        }
        return time;
    }

    public static int getwhichDayWeek(int year, int month, int day) {

        String pTime = (year * 10000 + month * 100 + day) + "";
        int Week = 1;
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        Calendar c = Calendar.getInstance();
        try {
            c.setTime(format.parse(pTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 1) {
            Week = 6;
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 2) {
            Week = 0;
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 3) {
            Week = 1;
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 4) {
            Week = 2;
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 5) {
            Week = 3;
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 6) {
            Week = 4;
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 7) {
            Week = 5;
        }
        return Week;
    }

    public static String getwhichDayWeeks(int year, int month, int day) {
        String pTime = (year * 10000 + month * 100 + day) + "";
        String Week = "";
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        Calendar c = Calendar.getInstance();
        try {
            c.setTime(format.parse(pTime));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 1) {
            Week = "星期日";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 2) {
            Week = "星期一";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 3) {
            Week = "星期二";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 4) {
            Week = "星期三";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 5) {
            Week = "星期四";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 6) {
            Week = "星期五";
        }
        if (c.get(Calendar.DAY_OF_WEEK) == 7) {
            Week = "星期六";
        }
        return Week;
    }

    /**
     * 解析日期，获取年月日星期
     */
    public static String parseDateToYearMonthDayWeek(int week) {

        String weekStr = "";
        /*星期日:Calendar.SUNDAY=1
         *星期一:Calendar.MONDAY=2
         *星期二:Calendar.TUESDAY=3
         *星期三:Calendar.WEDNESDAY=4
         *星期四:Calendar.THURSDAY=5
         *星期五:Calendar.FRIDAY=6
         *星期六:Calendar.SATURDAY=7 */
        switch (week) {
            case 1:
                weekStr = "星期日";
                break;
            case 2:
                weekStr = "星期一";
                break;
            case 3:
                weekStr = "星期二";
                break;
            case 4:
                weekStr = "星期三";
                break;
            case 5:
                weekStr = "星期四";
                break;
            case 6:
                weekStr = "星期五";
                break;
            case 7:
                weekStr = "星期六";
                break;
            default:
                break;
        }
        return weekStr;
    }

    /**
     * @return 指定日期字符串n天之前或者之后的日期
     */
    public static int getBeforeAfterDate(String endday) {


        SimpleDateFormat dfs = new SimpleDateFormat("yyyy-MM-dd");
//        String time = dfs.format(new Date());
        long between = 0;
        try {
            java.util.Date begin = dfs.parse(dfs.format(new Date()));
            java.util.Date end = dfs.parse(endday);
            between = (end.getTime() - begin.getTime());// 得到两者的毫秒数
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        long day = between / (24 * 60 * 60 * 1000);

        return (int) day;
    }

    /**
     * 判断两个时间大小 返回true正常
     *
     * @param endTime
     * @return
     */
    public static boolean isNowtime(String endTime) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String times = df.format(new Date());


        if (times.equals(endTime)) {
            return true;
        } else {
            return false;
        }

    }

    public static String getMessageTime(String date) {
        if (null == date) {
            return "";
        }
        if (date.length() < 15) {
            return date;
        }
        try {
            //当前的时间
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            if ((df.parse(getNowTime())).getTime() == (df.parse(date)).getTime()) {
                return dataToSrt(TimesUtils.strToLong(date), true);
            } else {
                return dataToSrt(TimesUtils.strToLong(date), false);
            }
        } catch (Exception e) {
        }
        return date;
    }

    public static String dataToSrt(long strDate, boolean isToday) {
        if (isToday) {
            SimpleDateFormat sdf = new SimpleDateFormat("MM-dd  HH:mm");
            String date = sdf.format(new Date(strDate));
            return "今日 " + date;
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 HH:mm");
            String date = sdf.format(new Date(strDate));
            return date;
        }

    }

    public static long strToLongYYYYMMDD(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return time;
    }

    public static long strToLongYYYYMMDDs(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return time;
    }

    public static long strToLongHHMM(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("HH:mm");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return time;
    }

    public static long strToLongYYYYMM(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return time;
    }

    public static long strToLongYYYYMMDDHHMM(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return time;
    }

    public static long strToLongYYYY(String strDate) {
        long time = 0;
        try {
            SimpleDateFormat df = new SimpleDateFormat("yyyy");
            Date date = df.parse(strDate);
            time = date.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return time;
    }

    /**
     * 是否小于今天
     *
     * @param data
     */
    public static boolean isLessThanToday(long data) {
        Calendar calendar = Calendar.getInstance();
        if (calendar.getTimeInMillis() / 1000 > data) {
            return true;
        }
        return false;
    }

    public static long getThenTimeInMillons(int year, int month, int day, int hour, int minute) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(calendar.YEAR, year);
        calendar.set(calendar.MONTH, month);
        calendar.set(calendar.DAY_OF_MONTH, day);
        calendar.set(calendar.HOUR_OF_DAY, hour);
        calendar.set(calendar.MINUTE, minute);
        return calendar.getTimeInMillis() / 1000;
    }
}
