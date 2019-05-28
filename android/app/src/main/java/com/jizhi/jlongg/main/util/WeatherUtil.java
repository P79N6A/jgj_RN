package com.jizhi.jlongg.main.util;


import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WeatherAttribute;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2017/6/1 0001.
 */

public class WeatherUtil {


    /**
     * 根据天气id 获取对应天气的id
     *
     * @param weatherId
     * @return
     */
    public static int getWeatherFill(int weatherId) {
        switch (weatherId) {
            case WeatherAttribute.CLEAR_DAY: //晴
                return R.drawable.calendar_weather_clear;
            case WeatherAttribute.SHADE: //阴
                return R.drawable.calendar_weather_overcast;
            case WeatherAttribute.CLOUDY: //多云
                return R.drawable.calendar_weather_cloudy;
            case WeatherAttribute.RAIN: //雨
                return R.drawable.calendar_weather_rain;
            case WeatherAttribute.WIND: //风
                return R.drawable.calendar_weather_wind;
            case WeatherAttribute.SNOW: //雪
                return R.drawable.calendar_weather_snow;
            case WeatherAttribute.FOG: //雾
                return R.drawable.calendar_weather_fog;
            case WeatherAttribute.HAZE: //霾
                return R.drawable.calendar_weather_haze;
            case WeatherAttribute.ICE_SNOW: //冰冻
                return R.drawable.calendar_weather_frost;
            case WeatherAttribute.POWER_CUT: //停电
                return R.drawable.calendar_weather_power_outage;
        }
        return R.drawable.record_popup_nothing; //无
    }


    /**
     * 根据天气id 获取对应天气的id
     *
     * @param weatherId
     * @return
     */
    public static int getWeather(int weatherId) {
        switch (weatherId) {
            case WeatherAttribute.CLEAR_DAY: //晴
                return R.drawable.record_popup_claer;
            case WeatherAttribute.SHADE: //阴
                return R.drawable.record_popup_overcast;
            case WeatherAttribute.CLOUDY: //多云
                return R.drawable.record_popup_cloudy;
            case WeatherAttribute.RAIN: //雨
                return R.drawable.record_popup_rain;
            case WeatherAttribute.WIND: //风
                return R.drawable.record_popup_wind;
            case WeatherAttribute.SNOW: //雪
                return R.drawable.record_popup_snow;
            case WeatherAttribute.FOG: //雾
                return R.drawable.record_popup_fog;
            case WeatherAttribute.HAZE: //霾
                return R.drawable.record_popup_haze;
            case WeatherAttribute.ICE_SNOW: //冰冻
                return R.drawable.record_popup_frost;
            case WeatherAttribute.POWER_CUT: //停电
                return R.drawable.record_popup_power_outage;
        }
        return R.drawable.record_popup_nothing; //无
    }

    /**
     * 获取所有的天气对象
     *
     * @return
     */
    public static List<WeatherAttribute> getAllWeatherAttribute() {
        List<WeatherAttribute> list = new ArrayList<>();
        WeatherAttribute weather1 = new WeatherAttribute(R.drawable.record_popup_claer, "晴", WeatherAttribute.CLEAR_DAY, R.color.color_f57665);
        WeatherAttribute weather2 = new WeatherAttribute(R.drawable.record_popup_overcast, "阴", WeatherAttribute.SHADE, R.color.color_9eaec6);
        WeatherAttribute weather3 = new WeatherAttribute(R.drawable.record_popup_cloudy, "多云", WeatherAttribute.CLOUDY, R.color.color_5fbef5);
        WeatherAttribute weather4 = new WeatherAttribute(R.drawable.record_popup_rain, "雨", WeatherAttribute.RAIN, R.color.color_6ca7f2);
        WeatherAttribute weather5 = new WeatherAttribute(R.drawable.record_popup_snow, "雪", WeatherAttribute.SNOW, R.color.color_6ca7f2);
        WeatherAttribute weather6 = new WeatherAttribute(R.drawable.record_popup_fog, "雾", WeatherAttribute.FOG, R.color.color_5fbef5);
        WeatherAttribute weather7 = new WeatherAttribute(R.drawable.record_popup_haze, "霾", WeatherAttribute.HAZE, R.color.color_9eaec6);
        WeatherAttribute weather8 = new WeatherAttribute(R.drawable.record_popup_frost, "冰冻", WeatherAttribute.ICE_SNOW, R.color.color_6c8ff2);
        WeatherAttribute weather9 = new WeatherAttribute(R.drawable.record_popup_wind, "风", WeatherAttribute.WIND, R.color.color_53d0e7);
        WeatherAttribute weather10 = new WeatherAttribute(R.drawable.record_popup_power_outage, "停电", WeatherAttribute.POWER_CUT, R.color.color_fcb550);
        WeatherAttribute weather11 = new WeatherAttribute(R.drawable.record_popup_nothing, "不选", WeatherAttribute.NOTHING, R.color.color_f57665);
        list.add(weather1);
        list.add(weather2);
        list.add(weather3);
        list.add(weather4);
        list.add(weather5);
        list.add(weather6);
        list.add(weather7);
        list.add(weather8);
        list.add(weather9);
        list.add(weather10);
        list.add(weather11);
        return list;
    }

    /**
     * 根据天气id 获取对应天气的对象
     *
     * @param weatherId
     * @return
     */
    public static WeatherAttribute getWeatherAttribute(int weatherId) {
        switch (weatherId) {
            case WeatherAttribute.CLEAR_DAY: //晴
                return new WeatherAttribute(R.drawable.record_popup_claer, "晴", WeatherAttribute.CLEAR_DAY, R.color.color_f57665);
            case WeatherAttribute.SHADE: //阴
                return new WeatherAttribute(R.drawable.record_popup_overcast, "阴", WeatherAttribute.SHADE, R.color.color_9eaec6);
            case WeatherAttribute.CLOUDY: //多云
                return new WeatherAttribute(R.drawable.record_popup_cloudy, "多云", WeatherAttribute.CLOUDY, R.color.color_5fbef5);
            case WeatherAttribute.RAIN: //雨
                return new WeatherAttribute(R.drawable.record_popup_rain, "雨", WeatherAttribute.RAIN, R.color.color_6ca7f2);
            case WeatherAttribute.WIND: //风
                return new WeatherAttribute(R.drawable.record_popup_wind, "风", WeatherAttribute.WIND, R.color.color_53d0e7);
            case WeatherAttribute.SNOW: //雪
                return new WeatherAttribute(R.drawable.record_popup_snow, "雪", WeatherAttribute.SNOW, R.color.color_6ca7f2);
            case WeatherAttribute.FOG: //雾
                return new WeatherAttribute(R.drawable.record_popup_fog, "雾", WeatherAttribute.FOG, R.color.color_5fbef5);
            case WeatherAttribute.HAZE: //霾
                return new WeatherAttribute(R.drawable.record_popup_haze, "霾", WeatherAttribute.HAZE, R.color.color_9eaec6);
            case WeatherAttribute.ICE_SNOW: //冰冻
                return new WeatherAttribute(R.drawable.record_popup_frost, "冰冻", WeatherAttribute.ICE_SNOW, R.color.color_6c8ff2);
            case WeatherAttribute.POWER_CUT: //停电
                return new WeatherAttribute(R.drawable.record_popup_power_outage, "停电", WeatherAttribute.POWER_CUT, R.color.color_fcb550);
        }
        return null;
    }
}
