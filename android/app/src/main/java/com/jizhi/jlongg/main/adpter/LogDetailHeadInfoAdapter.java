package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.log.LogBaseAdapter;
import com.jizhi.jlongg.main.bean.LocationInfo;
import com.jizhi.jlongg.main.bean.LogModeBean;
import com.jizhi.jlongg.main.bean.WeatherInfo;
import com.jizhi.jlongg.main.util.DataUtil;

import java.util.List;


/**
 * CName:日志详情头部adapter2.3.0
 * User: hcs
 * Date: 2017-07-25
 * Time: 17:25
 */
public class LogDetailHeadInfoAdapter extends BaseAdapter {
    private List<LogModeBean> list;
    private LayoutInflater inflater;
    private Context context;

    public LogDetailHeadInfoAdapter(Context context, List<LogModeBean> list) {
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final Holder holder;
        final LogModeBean level = list.get(position);
        if (convertView == null) {
            holder = new Holder();
            convertView = inflater.inflate(R.layout.item_log_headview, null);
            holder.tv_hint_1 = (TextView) convertView.findViewById(R.id.tv_hint_1);
            holder.tv_hint_2 = (TextView) convertView.findViewById(R.id.tv_hint_2);
            holder.tv_hint_3 = (TextView) convertView.findViewById(R.id.tv_hint_3);
            holder.tv_text1 = (TextView) convertView.findViewById(R.id.tv_text1);
            holder.tv_text2 = (TextView) convertView.findViewById(R.id.tv_text2);
            holder.tv_text3 = (TextView) convertView.findViewById(R.id.tv_text3);
            holder.tv_weather_morning = (TextView) convertView.findViewById(R.id.tv_weather_morning);
            holder.tv_weather_afternoon = (TextView) convertView.findViewById(R.id.tv_weather_afternoon);
            holder.tv_temperature_morning = (TextView) convertView.findViewById(R.id.tv_temperature_morning);
            holder.tv_temperature_afternoon = (TextView) convertView.findViewById(R.id.tv_temperature_afternoon);
            holder.tv_wind_morning = (TextView) convertView.findViewById(R.id.tv_wind_morning);
            holder.tv_wind_afternoon = (TextView) convertView.findViewById(R.id.tv_wind_afternoon);
            holder.rea_context1 = (LinearLayout) convertView.findViewById(R.id.rea_context1);
            holder.rea_context2 = (LinearLayout) convertView.findViewById(R.id.rea_context2);
            holder.rea_location = (LinearLayout) convertView.findViewById(R.id.rea_location);
            holder.rea_weather = (RelativeLayout) convertView.findViewById(R.id.rea_weather);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        if (level.getElement_type().equals(LogBaseAdapter.TYPE_WEATHER_STR)) {
            holder.rea_context1.setVisibility(View.GONE);
            holder.rea_context2.setVisibility(View.GONE);
            holder.rea_location.setVisibility(View.GONE);
            holder.rea_weather.setVisibility(View.VISIBLE);
            Gson gson = new Gson();
            if (!TextUtils.isEmpty(level.getWeather_value())) {
                WeatherInfo weatherInfo = gson.fromJson(level.getWeather_value(), WeatherInfo.class);
                holder.tv_weather_morning.setText(!TextUtils.isEmpty(weatherInfo.getWeat_am()) ? weatherInfo.getWeat_am() : "");
                holder.tv_weather_afternoon.setText(!TextUtils.isEmpty(weatherInfo.getWeat_pm()) ? weatherInfo.getWeat_pm() : "");
                holder.tv_temperature_morning.setText(!TextUtils.isEmpty(weatherInfo.getTemp_am()) ? weatherInfo.getTemp_am() : "");
                holder.tv_temperature_afternoon.setText(!TextUtils.isEmpty(weatherInfo.getTemp_pm()) ? weatherInfo.getTemp_pm() : "");
                holder.tv_wind_morning.setText(!TextUtils.isEmpty(weatherInfo.getWind_am()) ? weatherInfo.getWind_am() : "");
                holder.tv_wind_afternoon.setText(!TextUtils.isEmpty(weatherInfo.getWind_pm()) ? weatherInfo.getWind_pm() : "");
            }

        } else {
            holder.rea_weather.setVisibility(View.GONE);
            if (level.getElement_type().equals(LogBaseAdapter.TYPE_TEXTAREA_STR)) {
                holder.tv_hint_2.setText(level.getElement_name() + ":");
                holder.tv_text2.setText(level.getElement_value());
                holder.rea_context2.setVisibility(View.VISIBLE);
                holder.rea_context1.setVisibility(View.GONE);
                holder.rea_location.setVisibility(View.GONE);

            } else if (level.getElement_type().equals(LogBaseAdapter.TYPE_LOG_LOC)) {
                LUtils.e("----------111---------位置进来了--");
                holder.rea_context2.setVisibility(View.GONE);
                holder.rea_context1.setVisibility(View.GONE);
                holder.rea_location.setVisibility(View.VISIBLE);
                if (TextUtils.isEmpty(level.getElement_name())) {
                    holder.tv_hint_3.setText("所在位置" + ":");
                } else {
                    holder.tv_hint_3.setText(level.getElement_name() + ":");
                }
                Gson gson = new Gson();
                if (!TextUtils.isEmpty(level.getElement_value())) {
                    LocationInfo info = gson.fromJson(level.getElement_value(), LocationInfo.class);
                    if (!TextUtils.isEmpty(info.getAddress()) && !TextUtils.isEmpty(info.getName())) {
                        holder.tv_text3.setText(info.getAddress() + "" + info.getName());
                    } else if (TextUtils.isEmpty(info.getAddress()) && !TextUtils.isEmpty(info.getName())) {
                        holder.tv_text3.setText(info.getName());
                    } else if (!TextUtils.isEmpty(info.getAddress()) && TextUtils.isEmpty(info.getName())) {
                        holder.tv_text3.setText(info.getAddress());
                    }
                }


            } else {
                holder.tv_hint_1.setText(level.getElement_name() + ":");
                holder.tv_text1.setText(level.getElement_value());
                holder.rea_context1.setVisibility(View.VISIBLE);
                holder.rea_context2.setVisibility(View.GONE);
                holder.rea_location.setVisibility(View.GONE);
            }
            DataUtil.setHtmlClick(holder.tv_text1, context);
            DataUtil.setHtmlClick(holder.tv_text2, context);
        }
        return convertView;
    }


    class Holder {
        TextView tv_hint_1;
        TextView tv_hint_2;
        TextView tv_hint_3;
        TextView tv_text1;
        TextView tv_text2;
        TextView tv_text3;
        LinearLayout rea_context1;
        LinearLayout rea_context2;
        RelativeLayout rea_weather;
        LinearLayout rea_location;
        TextView tv_weather_morning;
        TextView tv_weather_afternoon;
        TextView tv_temperature_morning;
        TextView tv_temperature_afternoon;
        TextView tv_wind_morning;
        TextView tv_wind_afternoon;
        View img_line;
    }


}
