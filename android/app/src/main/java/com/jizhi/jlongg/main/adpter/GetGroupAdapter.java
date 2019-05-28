package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.Color;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:批量记账选择班组列表
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class GetGroupAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<GroupDiscussionInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 过滤文本
     */
    private String filterValue;

    public GetGroupAdapter(Context context, List<GroupDiscussionInfo> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    public void updateList(List<GroupDiscussionInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public GroupDiscussionInfo getItem(int position) {
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
            convertView = inflater.inflate(R.layout.choose_group_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, int position, View convertView) {
        GroupDiscussionInfo bean = list.get(position);
        holder.selectedIcon.setVisibility(bean.is_selected == 1 ? View.VISIBLE : View.GONE);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            if (!TextUtils.isEmpty(bean.getGroup_name())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getGroup_name() + "(" + bean.getMembers_num() + "人)");
                Matcher nameMatch = Pattern.compile(filterValue).matcher(bean.getGroup_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.proName.setText(builder);
            }
        } else {
            Spanned spannable = Html.fromHtml("<font color='#333333'>" + bean.getGroup_name() + "</font><font color='#999999'>(" + bean.getMembers_num() + "人)</font>");
            holder.proName.setText(spannable);
        }
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            proName = (TextView) convertView.findViewById(R.id.proName);
            selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
        }

        /**
         * 项目描述
         */
        TextView proName;
        /**
         * 当前项目已选中图标
         */
        ImageView selectedIcon;
    }

    public List<GroupDiscussionInfo> getList() {
        return list;
    }

    public void setList(List<GroupDiscussionInfo> list) {
        this.list = list;
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupDiscussionInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }
}
