package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ReleaseProjectInfo;

import java.util.List;

/**
 * 功能:添加同步项目列表 Adapter
 * 时间:2016-4-18 18:34
 * 作者:xuj
 */
public class SynchStatementAddproAdapter extends BaseAdapter {
    private List<ReleaseProjectInfo> list;
    private LayoutInflater inflater;


    public SynchStatementAddproAdapter(Context context, List<ReleaseProjectInfo> list) {
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
        final ViewHolder holder;
        final ReleaseProjectInfo bean = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_synch_add_pro, null);
            holder.cb = (ImageView) convertView.findViewById(R.id.cb_del);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.line = convertView.findViewById(R.id.itemDiver);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(bean.getPro_name());
        holder.line.setVisibility(position == list.size()-1?View.GONE:View.VISIBLE);
        if (!bean.isSelected()) {
            holder.cb.setImageResource(R.drawable.checkbox_normal);
        } else {
            holder.cb.setImageResource(R.drawable.checkbox_pressed);
        }
        return convertView;
    }


    class ViewHolder {
        TextView tv_name;
        ImageView cb;
        View line;
    }
    public interface SynchStateAddCbLinstener{
        void checkboxClick(int position);
    }
}
