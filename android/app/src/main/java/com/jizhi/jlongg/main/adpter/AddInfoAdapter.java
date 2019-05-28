package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AddInfoBean;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AddInfoAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<AddInfoBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private Context context;


    public AddInfoAdapter(Context context, List<AddInfoBean> list) {
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

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_modify_add_list, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_date.setText(list.get(position).getDate() + "(" + (list.get(position).getNl_date() + ")"));
        holder.tv_count.setText(context.getResources().getString(R.string.account_add_count, list.get(position).getNum()));
        if (position == list.size() - 1) {
            holder.img_line.setVisibility(View.GONE);
        } else {
            holder.img_line.setVisibility(View.VISIBLE);
        }
        return convertView;
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            tv_count = (TextView) convertView.findViewById(R.id.tv_count);
            img_line = (ImageView) convertView.findViewById(R.id.img_line);
        }

        /* 名称*/
        TextView tv_date;
        /* 内容 */
        TextView tv_count;
        ImageView img_line;
    }
}
