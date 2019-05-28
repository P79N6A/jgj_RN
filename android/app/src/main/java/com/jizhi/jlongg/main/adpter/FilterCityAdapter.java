package com.jizhi.jlongg.main.adpter;

import android.annotation.SuppressLint;
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
 * 城市筛选适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 上午11:03:03
 */
@SuppressLint("DefaultLocale")
public class FilterCityAdapter extends BaseAdapter {
    private List<CityInfoMode> list;

    private Context context;
    private LayoutInflater inflater;

    public FilterCityAdapter(Context mContext, List<CityInfoMode> list) {
        this.list = list;
        this.context = mContext;
        inflater = LayoutInflater.from(mContext);
    }


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<CityInfoMode> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public int getCount() {
        return this.list.size();
    }

    public Object getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup arg2) {
        final ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_city, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.line = convertView.findViewById(R.id.itemDiver);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(list.get(position).getCity_name());
        holder.line.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
        Utils.setBackGround(convertView, context.getResources().getDrawable(R.drawable.draw_listview_selector_white_gray_bottom_5radius));

        return convertView;

    }

    class ViewHolder {
        TextView tv_name;
        View line;
    }

    public List<CityInfoMode> getList() {
        return list;
    }

    public void setList(List<CityInfoMode> list) {
        this.list = list;
    }
}

