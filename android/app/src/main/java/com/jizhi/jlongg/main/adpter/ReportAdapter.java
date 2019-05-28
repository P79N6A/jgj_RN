package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Report;

import java.util.List;

/**
 * 功能:举报适配器
 * 时间:2016-4-18 15:27
 * 作者:xuj
 */
public class ReportAdapter extends BaseAdapter {
    private List<Report> list;
    private LayoutInflater inflater;
    private Context context;
    private Resources res;
    private ReportCallBack listener;
    private ListView listView;

    public ReportAdapter(Context context, List<Report> list,ReportCallBack listener,ListView listView) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
        this.listener = listener;
        this.listView = listView;
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


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_report, null);
            holder.title = (TextView) convertView.findViewById(R.id.title);
            holder.desc = (TextView) convertView.findViewById(R.id.desc);
            holder.select_image = (ImageView) convertView.findViewById(R.id.select_image);
            holder.other = (EditText)convertView.findViewById(R.id.other);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final Report report = list.get(position);
        if(TextUtils.isEmpty(report.getDesc())){
            holder.desc.setVisibility(View.GONE);
        }else{
            holder.desc.setText(report.getDesc());
        }
        holder.title.setText(report.getName());
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){
                int flag = holder.select_image.getVisibility();
                if(flag == View.GONE){
                    holder.title.setTextColor(res.getColor(R.color.app_color));
                    holder.select_image.setVisibility(View.VISIBLE);
                }else{
                    holder.title.setTextColor(res.getColor(R.color.gray_333333));
                    holder.select_image.setVisibility(View.GONE);
                }
                report.setIsSeleted(!report.isSeleted());
            }
        });
        return convertView;
    }

    class ViewHolder {
        /**
         * 标题
         */
        TextView title;
        /**
         * 描述
         */
        TextView desc;
        /** 选中图片 */
        ImageView select_image;
        /** 其他输入框 */
        EditText other;
    }



    public interface ReportCallBack{
        public void call(int code,String other);
    }


}
