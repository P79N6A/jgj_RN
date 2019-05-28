package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.List;

public class ListViewOneRawMultiselectAdapter extends BaseAdapter {

    private List<WorkType> list;
    private LayoutInflater inflater;
    private Resources res;

    public ListViewOneRawMultiselectAdapter(Context context, List<WorkType> list) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        res = context.getResources();
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
        WorkType workType = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_type_of_work, null);
            holder.wtype = (TextView) convertView.findViewById(R.id.wtype);
            holder.lin_gou = (LinearLayout) convertView.findViewById(R.id.lin_gou);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (workType.isSelected()) {
            holder.lin_gou.setVisibility(View.VISIBLE);
            holder.wtype.setTextColor(res.getColor(R.color.app_color));
        } else {
            holder.lin_gou.setVisibility(View.GONE);
            holder.wtype.setTextColor(res.getColor(R.color.gray_666666));
        }
        holder.wtype.setText(workType.getWorkName());
        return convertView;
    }

    class ViewHolder {
        TextView wtype;
        LinearLayout lin_gou;
    }
}