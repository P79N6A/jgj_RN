package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.LogGroupBean;

import java.util.List;

/**
 * 发布项目所需工种适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 下午4:05:25
 */
public class LogModeAdapter extends BaseAdapter {
    private List<LogGroupBean> workTimes;
    private LayoutInflater inflater;
    private Context context;
    private GridViewItemListener GridViewItemListener;
    private boolean isAccountTime;

    public LogModeAdapter(Context context, List<LogGroupBean> workTimes, GridViewItemListener GridViewItemListener) {
        super();
        inflater = LayoutInflater.from(context);
        this.workTimes = workTimes;
        this.context = context;
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
        LogGroupBean workType = workTimes.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_log_mode, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.img_add = (ImageView) convertView.findViewById(R.id.img_add);
            holder.rea = (RelativeLayout) convertView.findViewById(R.id.rea);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.rea.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                GridViewItemListener.itemClick(position, holder.tv_name.getText().toString());
            }
        });
        if (workType.getCat_id().equals("-1")) {
            holder.img_add.setVisibility(View.VISIBLE);
            holder.tv_name.setVisibility(View.GONE);
        } else {
            holder.img_add.setVisibility(View.GONE);
            holder.tv_name.setVisibility(View.VISIBLE);
            holder.tv_name.setText(workType.getCat_name());
        }
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        ImageView img_add;
        RelativeLayout rea;
    }

    public interface GridViewItemListener {
        void itemClick(int position, String str);
    }
}
