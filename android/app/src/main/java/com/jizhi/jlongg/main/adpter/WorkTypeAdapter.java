package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
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
public class WorkTypeAdapter extends BaseAdapter {
    private List<WorkType> workTypes;
    private LayoutInflater inflater;
    private Context context;
    private WorkTypeClickListener workTypeClickListener;

    public WorkTypeAdapter(Context context, List<WorkType> workTypes,
                           WorkTypeClickListener workTypeClickListener) {
        super();
        this.workTypes = workTypes;
        this.context = context;
        this.workTypeClickListener = workTypeClickListener;
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

    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        WorkType workType = workTypes.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_type_of_work, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.wtype);
            holder.lin_gou = (LinearLayout) convertView.findViewById(R.id.lin_gou);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setFocusable(true);
        holder.tv_name.setFocusableInTouchMode(true);
        holder.tv_name.setText(workType.getWorkName());
        if (workType.isSelected()) {
            holder.lin_gou.setVisibility(View.VISIBLE);
        } else {
            holder.lin_gou.setVisibility(View.GONE);
        }
        convertView.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                workTypeClickListener.workTypeClick(position);
            }
        });
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        LinearLayout lin_gou;
    }

    public interface WorkTypeClickListener {
        void workTypeClick(int position);
    }
}
