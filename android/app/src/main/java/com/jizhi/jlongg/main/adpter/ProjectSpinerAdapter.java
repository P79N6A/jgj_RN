package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;

import java.util.List;

public class ProjectSpinerAdapter extends BaseAdapter {

    private List<Project> list;

    private Resources res;

    private LayoutInflater inflater;

    public ProjectSpinerAdapter(Context context, List<Project> list) {
        this.list = list;
        inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        res = context.getResources();
    }



    public void setList(List<Project> list) {
        this.list = list;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int pos) {
        return list.get(pos);
    }

    @Override
    public long getItemId(int pos) {
        return pos;
    }

    @Override
    public View getView(int pos, View convertView, ViewGroup arg2) {
        ViewHolder viewHolder;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.spiner_item_layout, null);
            viewHolder.mTextView = (TextView) convertView.findViewById(R.id.textView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        if (list.get(pos).isSelected()) {
            viewHolder.mTextView.setTextColor(res.getColor(R.color.app_color));
        } else {
            viewHolder.mTextView.setTextColor(res.getColor(R.color.gray_666666));
        }
        viewHolder.mTextView.setText(list.get(pos).getPro_name());
        return convertView;
    }

    class ViewHolder {
        TextView mTextView;
    }


}
