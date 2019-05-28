package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.List;

/**
 * 发布项目所需工种适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 下午4:05:25
 */
public class FindProjectWorkTypeAdapter extends BaseAdapter {
    private List<WorkType> workTypes;
    private LayoutInflater inflater;
    private Context context;

    public FindProjectWorkTypeAdapter(Context context, List<WorkType> workTypes) {
        super();
        this.workTypes = workTypes;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return workTypes == null ? 0 : workTypes.size();
    }

    @Override
    public Object getItem(int position) {
        return workTypes.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        WorkType workType = workTypes.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_findproject_worktype_top, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(workType.getWorkName());
        if (workTypes.get(position).getWorkName().equals("更多..")) {
            holder.tv_name.setTextColor(context.getResources().getColor(R.color.app_color));
        } else {
            holder.tv_name.setTextColor(context.getResources().getColor(R.color.gray_333333));
        }
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
    }
}
