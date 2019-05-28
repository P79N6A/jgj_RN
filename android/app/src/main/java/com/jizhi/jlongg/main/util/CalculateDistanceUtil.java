package com.jizhi.jlongg.main.util;

import android.content.Context;

import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;

import java.text.DecimalFormat;

/***
 * 计算距离
 *
 * @author Xuj
 * @time 2016年1月28日 15:09:03
 * @Version 1.0
 */
public class CalculateDistanceUtil {
    private final static double EARTH_RADIUS = 6378137;

    private final static String LAT = "lat";
    private final static String LNG = "lng";

    private final static DecimalFormat df = new DecimalFormat("#0.0");

    /**
     * 根据两点间经纬度坐标（double值），计算两点间距离，
     *
     * @param serviceLat 服务器返回纬度
     * @param serviceLng 服务器返回经度
     * @return 距离：单位为米
     */
    public static Double DistanceOfTwoPoints(Context context, double serviceLat, double serviceLng) {

        double currentLat = Double.parseDouble(SPUtils.get(context, LAT, "0", Constance.JLONGG).toString()); //当前系统中存放的纬度
        double currentLng = Double.parseDouble(SPUtils.get(context, LNG, "0", Constance.JLONGG).toString()); //当前系统中存放的经度
        if (currentLat == 0 || currentLng == 0) {
            return 0d;
        }
        double radLat1 = rad(currentLat);
        double radLat2 = rad(serviceLat);
        double a = radLat1 - radLat2;
        double b = rad(currentLng) - rad(serviceLng);
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
        s = s * EARTH_RADIUS;
        s = Math.round(s * 10000) / 10000;
        return s;
    }

    /**
     * 根据两点间经纬度坐标（double值），计算两点间距离，
     *
     * @param serviceLat 服务器返回纬度
     * @param serviceLng 服务器返回经度
     * @return 距离：单位为米
     */
    public static String DistanceOfTwoPointsString(Context context, double serviceLat, double serviceLng) {
        double currentLat = Double.parseDouble(SPUtils.get(context, LAT, "0", Constance.JLONGG).toString()); //当前系统中存放的纬度
        double currentLng = Double.parseDouble(SPUtils.get(context, LNG, "0", Constance.JLONGG).toString()); //当前系统中存放的经度
        if (currentLat == 0 || currentLng == 0) {
            return context.getString(R.string.location_error);
        }
        if (serviceLat == 0 || serviceLng == 0) {
            return context.getString(R.string.location_error);
        }
        double radLat1 = rad(currentLat);
        double radLat2 = rad(serviceLat);
        double a = radLat1 - radLat2;
        double b = rad(currentLng) - rad(serviceLng);
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) + Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
        s = s * EARTH_RADIUS;
        s = Math.round(s * 10000) / 10000;
        if (s <= 149) {
            return "0.1公里";
        } else {
            return df.format((float) s / 1000) + "公里";
        }
    }


    private static double rad(double d) {
        return d * Math.PI / 180.0;
    }

}
