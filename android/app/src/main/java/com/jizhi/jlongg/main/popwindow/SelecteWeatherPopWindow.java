package com.jizhi.jlongg.main.popwindow;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.dialog.PopupWindowExpand;
import com.jizhi.jlongg.main.util.WeatherUtil;

import java.util.List;

/**
 * 选择晴雨表弹出框
 *
 * @author Xuj
 * @date 2017年3月31日11:05:05
 */
public class SelecteWeatherPopWindow extends PopupWindowExpand implements View.OnClickListener {

    /**
     * 选中天气时的回调
     */
    private SelectedWeatherListener listener;
    /**
     * 天气开始的下标
     * 0:表示左上 1:右上  2:左下  3:右下
     */
    private int weatherDirection;
    /**
     * 适配器
     */
    private WeatherAdapter adapter;

    public SelecteWeatherPopWindow(Activity activity, SelectedWeatherListener listener) {
        super(activity);
        this.activity = activity;
        this.listener = listener;
        setPopView();
        initView();
    }


    public void setWeatherDirection(int weatherDirection) {
        this.weatherDirection = weatherDirection;
    }


    private void initView() {
        popView.findViewById(R.id.clearAll).setOnClickListener(this);
        popView.findViewById(R.id.redBtn).setOnClickListener(this);
        GridView gridView = (GridView) popView.findViewById(R.id.gridView);
        adapter = new WeatherAdapter(activity, WeatherUtil.getAllWeatherAttribute());
        gridView.setAdapter(adapter);
        gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                WeatherAttribute clickWether = adapter.getList().get(position);
                if (listener != null) { //回调给Activity
                    listener.selectedWather(clickWether, weatherDirection);
                    if (clickWether.getWeatherId() != WeatherAttribute.NOTHING) {
                        weatherDirection += 1;
                    }
                }

            }
        });
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.selecte_weather_popwindow, null);
        setContentView(popView);
        setPopParameter();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.clearAll: //清空重选
                if (listener != null) {
                    listener.clearAllWeather();
                }
                break;
            case R.id.redBtn:
                dismiss();
                break;
        }
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

        public WeatherAdapter(Context context, List<WeatherAttribute> list) {
            super();
            this.list = list;
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
                convertView = inflater.inflate(R.layout.weather_popwindow_grid_item, null);
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
            Drawable drawable = activity.getResources().getDrawable(bean.getWeatherIcon());
            drawable.setBounds(0, 0, drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight());
            holder.weatherText.setText(bean.getWeatherName());
            holder.weatherText.setCompoundDrawables(null, drawable, null, null);
            Utils.setBackGround(holder.weatherText, activity.getResources().getDrawable(bean.isSelected() ? R.drawable.bg_fafafa_sk_cccccc_1dp : R.color.transparent));
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                weatherText = (TextView) convertView.findViewById(R.id.weatherText);
            }

            /* 天气描述 */
            TextView weatherText;
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
         *
         * @param attribute        天气属性
         * @param weatherDirection 0:表示左上 1:右上  2:左下  3:右下
         */
        public void selectedWather(WeatherAttribute attribute, int weatherDirection);

        /**
         * 清空所有的天气
         */
        public void clearAllWeather();
    }


}
