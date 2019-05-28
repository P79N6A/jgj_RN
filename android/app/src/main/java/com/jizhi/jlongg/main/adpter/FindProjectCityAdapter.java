package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CityInfoMode;

import java.util.List;

/**
 * 城市 市 适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 下午4:05:25
 */
public class FindProjectCityAdapter extends BaseAdapter {
    private List<CityInfoMode> cityList;
    private LayoutInflater inflater;
    private Context context;


    public void updateList(List<CityInfoMode> cityList) {
        this.cityList = cityList;
        notifyDataSetChanged();
    }

    public FindProjectCityAdapter(Context context, List<CityInfoMode> cityList) {
        super();
        this.context = context;
        this.cityList = cityList;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return cityList == null ? 0 : cityList.size();
    }

    @Override
    public Object getItem(int position) {
        return cityList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_city, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(cityList.get(position).getCity_name());
        Utils.setBackGround(convertView, context.getResources().getDrawable(R.drawable.listview_selector_f3f3f3_to_white));
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
    }

    public List<CityInfoMode> getCityList() {
        return cityList;
    }

}
