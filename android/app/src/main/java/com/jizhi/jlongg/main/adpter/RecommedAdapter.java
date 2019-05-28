package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Recommend;

import java.util.List;

/**
 * 功能:推荐
 * 时间:2016-4-18 18:34
 * 作者:xuj
 */
public class RecommedAdapter extends BaseAdapter {
    private List<Recommend> list;
    private LayoutInflater inflater;
    private Context context;


    public RecommedAdapter(Context context, List<Recommend> list) {
        this.context = context;
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
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_recommend, null);
            holder.tv_title = (TextView) convertView.findViewById(R.id.tv_title);
            holder.tv_conent = (TextView) convertView.findViewById(R.id.tv_conent);
            holder.img = (ImageView) convertView.findViewById(R.id.img);
            holder.line = convertView.findViewById(R.id.itemDiver);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.line.setVisibility(position == 0 ? View.GONE : View.VISIBLE);
        Recommend bean = list.get(position);
        holder.tv_title.setText(bean.getTitle());
        holder.tv_conent.setText(bean.getContent());
        holder.img.setImageResource(bean.getIcon());
        return convertView;
    }

    class ViewHolder {
        TextView tv_title;
        TextView tv_conent;
        ImageView img;
        View line;

    }
}
