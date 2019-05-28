package com.jizhi.jlongg.main.popwindow;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.dialog.PopupWindowExpand;

import java.util.ArrayList;
import java.util.List;

/**
 * 选择晴雨表弹出框
 *
 * @author Xuj
 * @date 2017年3月31日11:05:05
 */
public class SelecteLogWeatherPopWindow extends PopupWindowExpand implements View.OnClickListener {

    /**
     * 当前选中的天气
     */
    private WeatherAttribute selectedWeather;
    /**
     * 选中天气时的回调
     */
    private SelectedWeatherListener listener;

    /**
     * 天气的方向
     * 0:表示左上 1:右上  2:左下  3:右下
     */
    private int weatherDirection;
    /**
     * 适配器
     */
    private WeatherAdapter adapter;

    private List<WeatherAttribute> list;

    public SelecteLogWeatherPopWindow(Activity activity, SelectedWeatherListener listener) {
        super(activity);
        this.activity = activity;
        this.listener = listener;
        setPopView();
        initView();
    }


    public void setWeatherDirection(int weatherDirection, WeatherAttribute selectedWeather) {
        this.weatherDirection = weatherDirection;
        if (this.selectedWeather != null) {
            this.selectedWeather.setSelected(false);
            this.selectedWeather = null;
        }
        if (adapter != null && selectedWeather != null) {
            for (WeatherAttribute weatherAttribute : adapter.getList()) {
                if (weatherAttribute.getWeatherId() == selectedWeather.getWeatherId()) {
                    this.selectedWeather = weatherAttribute;
                    weatherAttribute.setSelected(true);
                    adapter.notifyDataSetChanged();
                    break;
                }
            }
        } else {
            adapter.notifyDataSetChanged();
        }
    }



    private List<WeatherAttribute> getData() {
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
//        WeatherAttribute weather11 = new WeatherAttribute(R.drawable.record_popup_nothing, "无", WeatherAttribute.NOTHING, R.color.color_f57665);
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
//        list.add(weather11);
        return list;
    }

    private void initView() {
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        GridView gridView = (GridView) popView.findViewById(R.id.gridView);
        gridView.setSelector(new ColorDrawable(Color.TRANSPARENT));
        list = getData();
        adapter = new WeatherAdapter(activity, list);
        gridView.setAdapter(adapter);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                            @Override
                                            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                                                selectItem(position);
                                                for (int i = 0; i < listSelect.size(); i++) {
                                                    for (int j = 0; j < list.size(); j++) {
//
                                                        if (listSelect.get(i).getWeatherIcon() == list.get(j).getWeatherIcon()) {
                                                            list.set(j, listSelect.get(i));
//                                                            list.get(j).setSelectOrder(listSelect.get(i).getSelectOrder());
                                                            if (list.get(j).getSelectOrder() == 1) {
                                                                teamPositon = j;
                                                            }
                                                        }
                                                    }
                                                }
                                                for (int i = 0; i < list.size(); i++) {
                                                    if (list.get(i).getSelectOrder() == 1 && teamPositon != i) {
                                                        list.get(i).setSelectOrder(0);
                                                    }
                                                }
                                                adapter.notifyDataSetChanged();
                                            }

                                        }

        );
    }

    //临时下标与集合
    private List<WeatherAttribute> listSelect;
    private int teamPositon;

    /**
     * 处理选择的天气信息
     *
     * @param positon
     */
    private void selectItem(int positon) {
        if (listSelect == null) {
            listSelect = new ArrayList<>();
        }
        list.get(positon).setSelectOrder(1);
        listSelect.add(list.get(positon));
        if (listSelect.size() >= 2) {
            WeatherAttribute weatherAttribute = listSelect.get(listSelect.size() - 2);
            weatherAttribute.setSelectOrder(1);
            listSelect.clear();

            listSelect.add(weatherAttribute);
            list.get(positon).setSelectOrder(2);
            listSelect.add(list.get(positon));
        }

    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.selecte_weather_popwindow_log, null);
        setContentView(popView);
        setPopParameter();
    }

    /**
     * 功能:晴雨表适配器
     * 时间:2017年3月31日11:07:19
     * 作者:xuj
     */
    public class WeatherAdapter extends BaseAdapter {
        /* 单元格 */
        private List<WeatherAttribute> list;
        /* xml 解析器 */
        private LayoutInflater inflater;
        private Context context;

        public WeatherAdapter(Context context, List<WeatherAttribute> list) {
            super();
            this.list = list;
            this.context = context;
            inflater = LayoutInflater.from(context);
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
                convertView = inflater.inflate(R.layout.weather_popwindow_log_grid_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }

        private void bindData(ViewHolder holder, int position, View convertView) {
            WeatherAttribute bean = list.get(position);
            holder.weatherText.setText(bean.getWeatherName());
            Utils.setBackGround(holder.img_weather, context.getResources().getDrawable(bean.getWeatherIcon()));

            if (bean.getSelectOrder() != 0) {
                Utils.setBackGround(holder.layout_weather, context.getResources().getDrawable(R.drawable.drawable_rectangle_999999_fafafa));
                holder.tv_count.setVisibility(View.VISIBLE);
                holder.tv_count.setText(bean.getSelectOrder() + "");
            } else {
                holder.tv_count.setVisibility(View.GONE);
                Utils.setBackGround(holder.layout_weather, null);
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                weatherText = (TextView) convertView.findViewById(R.id.weatherText);
                tv_count = (TextView) convertView.findViewById(R.id.tv_count);
                layout_weather = (LinearLayout) convertView.findViewById(R.id.layout_weather);
                img_weather = (ImageView) convertView.findViewById(R.id.img_weather);
            }

            /* 天气描述 */
            TextView weatherText;
            /* 数量 */
            TextView tv_count;
            /* 天气布局 */
            LinearLayout layout_weather;
            /* 天气图标 */
            ImageView img_weather;
        }

        public List<WeatherAttribute> getList() {
            return list;
        }

        public void setList(List<WeatherAttribute> list) {
            this.list = list;
        }
    }

    public interface SelectedWeatherListener {
        /**
         * 选择天气回调函数
         */
         void selectedWather(WeatherAttribute attribute1, WeatherAttribute attribute2);

        /**
         * 关闭天气弹窗
         */
         void dismissWather();

    }

    private WeatherAttribute attribute1, attribute2;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                if (listener != null) {
                    for (int i = 0; i < list.size(); i++) {
                        if (list.get(i).getSelectOrder() == 1) {
                            attribute1 = list.get(i);
                            LUtils.e(attribute1.getWeatherName() + "<--11---name");
                        } else if (list.get(i).getSelectOrder() == 2) {
                            attribute2 = list.get(i);
                            LUtils.e(attribute2.getWeatherName() + "<--22---name");
                        }
                    }
                    listener.selectedWather(attribute1, attribute2);
                }
                break;
        }
        dismiss();
    }

    @Override
    public void onDismiss() {
        listener.dismissWather();
        super.onDismiss();
    }
}
