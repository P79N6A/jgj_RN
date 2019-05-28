package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Other;

import java.util.List;

/**
 * 选吉日适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 下午4:05:25
 */
public class LuckyDayAdapter extends BaseAdapter {
    private List<Other> list;
    private LayoutInflater inflater;
    private Context context;

    public LuckyDayAdapter(Context context, List<Other> list) {
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

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_luckday, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_day = (TextView) convertView.findViewById(R.id.tv_day);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(list.get(position).getContent());

        int times = TimesUtils.getBeforeAfterDate(list.get(position).getTemp());
        if (times == 0) {
            holder.tv_day.setText("今天");
        } else if (times > 0) {
            holder.tv_day.setText(Math.abs(times) + "天后");
        } else if (times < 0) {
            holder.tv_day.setText(Math.abs(times) + "天前");
        }
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        TextView tv_day;
    }

}
