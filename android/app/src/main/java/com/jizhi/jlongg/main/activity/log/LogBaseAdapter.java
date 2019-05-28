package com.jizhi.jlongg.main.activity.log;

import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * CName:新发日志适配器基类
 * User: hcs
 * Date: 2017-07-21
 * Time: 16:29
 */

public class LogBaseAdapter extends BaseAdapter {
    public static final int TYPE_TEXT = 0;//单行输入框
    public static final int TYPE_TEXTAREA = 1;//多行输入框
    public static final int TYPE_NUMBER = 2;//数字输入框
    public static final int TYPE_SELECT = 3;//列表
    public static final int TYPE_DATE = 4;//时间
    public static final int TYPE_DATEFRAME = 5;//时间范围
    public static final int TYPE_WEATHER = 6;//天气
    public static final int TYPE_LOGDATE = 7;//发布时间
    public static final int TYPE_LOGLOC = 8;//位置信息


    public static final String TYPE_TEXT_STR = "text";//单行输入框
    public static final String TYPE_TEXTAREA_STR = "textarea";//多行输入框
    public static final String TYPE_NUMBER_STR = "number";//数字输入框
    public static final String TYPE_SELECT_STR = "select";//列表
    public static final String TYPE_DATE_STR = "date";//时间
    public static final String TYPE_DATEFRAME_STR = "dateframe";//时间范围
    public static final String TYPE_WEATHER_STR = "weather";//天气
    public static final String TYPE_LOGDATE_STR = "logdate";//发布时间
    public static final String TYPE_LOG_LOC = "location";//位置信息

    public static final String DATE_TYPE_DAY = "day";// 日期 yyyy-mm-dd
    public static final String DATE_TYPE_TIME = "time";//时间 H:i
    public static final String DATE_TYPE_ALL = "all";//日期和时间 yyyy-mm-dd H:i
    public static final String DATE_TYPE_MONTH = "month";// 年月yyyy-mm
    public static final String DATE_TYPE_YEAR = "year";//年 yyyy

    @Override
    public int getCount() {
        return 0;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return null;
    }

    class TextHolder {

        //天气类型
        //天气：上午，下午；
        protected TextView tv_weather_morning;
        protected TextView tv_weather_afternoon;
        //温度上午，下午；风力，上午，下午
        protected EditText ed_temperature_morning;
        protected EditText ed_temperature_afternoon;
        protected EditText ed_wind_morning;
        protected EditText ed_wind_afternoon;
        //单行输入框框
        protected TextView tv_name;
        protected TextView tv_company;
        protected EditText ed_text;
        protected TextView tv_text;
        protected ImageView img_select_loc;
        protected LinearLayout rea_reset_location;//重新定位
        protected RelativeLayout rea_location_change;//微调
        protected RelativeLayout rea_weather_morning,rea_weather_afternoon;//风力上午下午布局
        protected View view_cursor_morning,view_cursor_adaternoon;//风力上午下午光标
        //时间
        protected TextView tv_time_start;
        protected TextView tv_time_end;
        protected TextView tv_text_start;
        protected TextView tv_text_end;
        protected RelativeLayout rea_time_start;
        protected RelativeLayout rea_time_end;
        protected RelativeLayout rea_time_single;


    }

    /**
     * 天气
     *
     * @param convertView
     */
    public TextHolder findWeatherView(View convertView) {
        TextHolder holder = new TextHolder();
        holder.tv_weather_morning =  convertView.findViewById(R.id.tv_weather_morning);
        holder.tv_weather_afternoon =convertView.findViewById(R.id.tv_weather_afternoon);
        holder.rea_weather_morning =convertView.findViewById(R.id.rea_weather_morning);
        holder.rea_weather_afternoon =convertView.findViewById(R.id.rea_weather_afternoon);
        holder.tv_text =  convertView.findViewById(R.id.tv_text);
        holder.ed_temperature_morning = convertView.findViewById(R.id.ed_temperature_morning);
        holder.ed_temperature_afternoon =  convertView.findViewById(R.id.ed_temperature_afternoon);
        holder.ed_wind_morning =  convertView.findViewById(R.id.ed_wind_morning);
        holder.ed_wind_afternoon =  convertView.findViewById(R.id.ed_wind_afternoon);
        holder.view_cursor_morning =  convertView.findViewById(R.id.view_cursor_morning);
        holder.view_cursor_adaternoon =  convertView.findViewById(R.id.view_cursor_adaternoon);
        return holder;
    }

    /**
     * 文字单行多行
     *
     * @param convertView
     */
    public TextHolder findTextView(View convertView) {
        TextHolder holder = new TextHolder();
        holder.tv_name =  convertView.findViewById(R.id.tv_name);
        holder.ed_text =  convertView.findViewById(R.id.ed_text);
        return holder;
    }

    /**
     * 选择框
     *
     * @param convertView
     */
    public TextHolder findSelectView(View convertView) {
        TextHolder holder = new TextHolder();
        holder.tv_text =  convertView.findViewById(R.id.tv_text);
        return holder;
    }

    /**
     * 选择框
     *
     * @param convertView
     */
    public TextHolder findLocView(View convertView) {
        TextHolder holder = new TextHolder();
//        holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
        holder.tv_text =  convertView.findViewById(R.id.tv_text);
        holder.img_select_loc =  convertView.findViewById(R.id.img_select_loc);
        holder.rea_reset_location =  convertView.findViewById(R.id.rea_reset_location);
        holder.rea_location_change =  convertView.findViewById(R.id.rea_location_change);
        return holder;
    }

    /**
     * 选择框时间两个
     *
     * @param convertView
     */
    public TextHolder findSelectTimeSView(View convertView) {
        TextHolder holder = new TextHolder();
        holder.tv_time_start =  convertView.findViewById(R.id.tv_time_start);
        holder.tv_time_end =  convertView.findViewById(R.id.tv_time_end);
        holder.tv_text_start =  convertView.findViewById(R.id.tv_text_start);
        holder.tv_text_end =  convertView.findViewById(R.id.tv_text_end);
        holder.rea_time_start =  convertView.findViewById(R.id.rea_time_start);
        holder.rea_time_end =  convertView.findViewById(R.id.rea_time_end);
        return holder;
    }

    /**
     * 选择框时间单个
     *
     * @param convertView
     */
    public TextHolder findSelectTimeView(View convertView) {
        TextHolder holder = new TextHolder();
        holder.tv_name =  convertView.findViewById(R.id.tv_name);
        holder.tv_text =  convertView.findViewById(R.id.tv_text);
        holder.rea_time_single =  convertView.findViewById(R.id.rea_time_single);
        return holder;
    }

    /**
     * 数字单行
     *
     * @param convertView
     */
    public TextHolder findTextNumberView(View convertView) {
        TextHolder holder = new TextHolder();
        holder.tv_name =  convertView.findViewById(R.id.tv_name);
        holder.tv_company =  convertView.findViewById(R.id.tv_company);
        holder.ed_text =  convertView.findViewById(R.id.ed_text);
        return holder;
    }

//    /**
//     * 时间选择
//     *
//     * @param convertView
//     */
//    public TextHolder findTimeView(View convertView) {
//        TextHolder holder = new TextHolder();
//        holder.tv_time_start = (TextView) convertView.findViewById(R.id.tv_time_start);
//        holder.tv_time_end = (TextView) convertView.findViewById(R.id.tv_time_end);
//        holder.tv_text_start = (TextView) convertView.findViewById(R.id.tv_text_start);
//        holder.tv_text_end = (TextView) convertView.findViewById(R.id.tv_text_end);
//        return holder;
//    }
}
