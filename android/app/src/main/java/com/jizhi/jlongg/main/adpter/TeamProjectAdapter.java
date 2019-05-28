package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.Color;
import android.support.v4.content.ContextCompat;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:新建班组、项目管理
 * 时间:2016年8月30日 17:35:50
 * 作者:xuj
 */
public class TeamProjectAdapter extends BaseAdapter {

    /**
     * 项目列表数据
     */
    private List<Project> list;
    /**
     * 上下文
     */
    private Context context;
    /**
     * 过滤文本
     */
    private String filterValue;
    /**
     * true 表示正在编辑
     */
    private boolean isEditor;


    public TeamProjectAdapter(Context context, List<Project> list) {
        this.context = context;
        this.list = list;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Project getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        Project bean = list.get(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_selectproject, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(bean.getPro_name())) {
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getPro_name());
                Matcher nameMatch = p.matcher(bean.getPro_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.proName.setText(builder);
            }
        } else {
            if (bean.getIs_create_group() == 1) {  //是否已有班组
                holder.existProName.setVisibility(View.VISIBLE);
                holder.proName.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
            } else {
                holder.existProName.setVisibility(View.GONE);
                holder.proName.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            }
            holder.proName.setText(bean.getPro_name());
        }
        if (bean.isSelected()) {
            holder.existProName.setText("已选中");
            holder.existProName.setVisibility(View.VISIBLE);
            holder.icon.setVisibility(View.VISIBLE);
        } else {
            holder.icon.setVisibility(View.GONE);
        }


        holder.itemDiver.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
        return convertView;
    }

    class ViewHolder {

        public ViewHolder(View view) {
            proName = (TextView) view.findViewById(R.id.pro_name);
            icon = (ImageView) view.findViewById(R.id.icon);
            existProName = (TextView) view.findViewById(R.id.exist_pro_name);
            itemDiver = view.findViewById(R.id.itemDiver);
        }
        /**
         * 项目名
         */
        TextView proName;
        /**
         * 图标
         */
        ImageView icon;
        /**
         * 已存在的项目名
         */
        TextView existProName;
        /**
         * 分割线
         */
        View itemDiver;
    }

    public List<Project> getList() {
        return list;
    }

    public void setList(List<Project> list) {
        this.list = list;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<Project> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}