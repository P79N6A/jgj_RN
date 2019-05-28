package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkTime;

import java.util.List;

/**
 * 发布项目所需工种适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 下午4:05:25
 */
public class WorkTimeAdapter extends BaseAdapter {
    private List<WorkTime> workTimes;
    private LayoutInflater inflater;
    private Context context;
    private GridViewItemListener GridViewItemListener;
    private int maxSize;
    private boolean isAccountTime;

    public WorkTimeAdapter(Context context, List<WorkTime> workTimes, GridViewItemListener GridViewItemListener, int maxSize) {
        super();
        inflater = LayoutInflater.from(context);
        this.workTimes = workTimes;
        this.context = context;
        this.maxSize = maxSize;
        this.GridViewItemListener = GridViewItemListener;
    }

    public boolean isAccountTime() {
        return isAccountTime;
    }

    public void setAccountTime(boolean accountTime) {
        isAccountTime = accountTime;
    }

    @Override
    public int getCount() {
        return workTimes == null ? 0 : workTimes.size();
    }

    @Override
    public Object getItem(int position) {
        return workTimes.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        WorkTime workType = workTimes.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_worktime, null);
            holder.tv_name = convertView.findViewById(R.id.tv_name);
            holder.tv_hour = convertView.findViewById(R.id.tv_hour);
            holder.rea = convertView.findViewById(R.id.rea);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (workType.isOneWork()) {
            Utils.setBackGround(holder.rea, context.getResources().getDrawable(R.drawable.draw_rectangle_red_white));
            holder.tv_name.setTextColor(context.getResources().getColor(R.color.app_color));
            holder.tv_hour.setTextColor(context.getResources().getColor(R.color.app_color));
        } else {
            Utils.setBackGround(holder.rea, context.getResources().getDrawable(R.drawable.draw_rectangle_gray_white));
            holder.tv_name.setTextColor(context.getResources().getColor(R.color.gray_333333));
            holder.tv_hour.setTextColor(context.getResources().getColor(R.color.gray_666666));
        }
        String worktime = workType.getWorkTimes() + "";
        if (worktime.contains(".0")) {
            worktime = worktime.replace(".0", "");
        }
        holder.tv_name.setText(workType.getWorkTimes() == 0 ? workType.getWorkName() : worktime + workType.getWorkName());
        if (isAccountTime) {
            float ban = (float) (maxSize / 2);
            if (maxSize % 2 != 0) {
                ban = ban + 0.5f;
            }
            if (workType.getWorkTimes() == maxSize) {
                holder.tv_hour.setVisibility(View.VISIBLE);
                holder.tv_hour.setText("(1个工)");
            } else if (workType.getWorkTimes() == ban) {
                holder.tv_hour.setVisibility(View.VISIBLE);
                holder.tv_hour.setText("(0.5个工)");
            } else {
                holder.tv_hour.setVisibility(View.GONE);
                holder.tv_hour.setText("");
            }
        }
        holder.rea.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                GridViewItemListener.itemClick(position, holder.tv_hour.getText().toString());
            }
        });
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        TextView tv_hour;
        RelativeLayout rea;
    }

    public interface GridViewItemListener {
        void itemClick(int position, String str);
    }
}
