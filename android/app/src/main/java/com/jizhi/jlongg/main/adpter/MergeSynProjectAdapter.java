package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.listener.SelectSynchProListener;

import java.util.List;

/**
 * 功能:合并同步项目
 * 时间:2016年9月9日 17:51:12
 * 作者:xuj
 */
public class MergeSynProjectAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<Project> list;
    /* xml 解析器 */
    private LayoutInflater inflater;
    /* 当前选中的数量 */
    private SelectSynchProListener listener;
    /* 当前选中项目的数量 */
    private int selectedSize;

    public MergeSynProjectAdapter(Context context, List<Project> list, SelectSynchProListener listener) {
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
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
        final Project bean = list.get(position);
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_merge_syn_project, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.proName.setText(bean.getPro_name());
        holder.bottomLine.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
        holder.selectedImage.setImageResource(!bean.isSelected() ? R.drawable.checkbox_normal : R.drawable.checkbox_pressed);
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                boolean isSelected = !bean.isSelected();
                selectedSize = isSelected ? selectedSize + 1 : selectedSize - 1;
                if (listener != null) {
                    listener.selected(selectedSize);
                }
                bean.setIsSelected(isSelected);
                notifyDataSetChanged();
            }
        });
        return convertView;
    }


    class ViewHolder {
        /* 项目名称 */
        TextView proName;
        /* 选中状态 */
        ImageView selectedImage;
        /* 底部线条 */
        View bottomLine;

        public ViewHolder(View convertView) {
            selectedImage = (ImageView) convertView.findViewById(R.id.checkbox);
            proName = (TextView) convertView.findViewById(R.id.pro_name);
            bottomLine = convertView.findViewById(R.id.bottom_line);
        }
    }


    public List<Project> getList() {
        return list;
    }

    public void setList(List<Project> list) {
        this.list = list;
    }
}
