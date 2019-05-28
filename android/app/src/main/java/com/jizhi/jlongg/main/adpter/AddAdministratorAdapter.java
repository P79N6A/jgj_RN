package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:添加管理员
 * 时间:2016-3-18 19:13
 * 作者:xuj
 */
public class AddAdministratorAdapter extends PersonBaseAdapter {
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;

    public AddAdministratorAdapter(Context context, List<GroupMemberInfo> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
    }


    public void updateList(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
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
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_administrator_list, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, int position) {
        GroupMemberInfo bean = list.get(position);
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            holder.catalog.setText(bean.getSortLetters());
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalog.setVisibility(View.GONE);
        }
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.userName.setText(bean.getReal_name());
        holder.tel.setText(bean.getTelephone());
        holder.deleteText.setVisibility(View.GONE);
        holder.isCreater.setVisibility(View.GONE);
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            isCreater = convertView.findViewById(R.id.isCrator);
            userName = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            deleteText = (TextView) convertView.findViewById(R.id.deleteText);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
        }

        /* 是否是创建者 */
        View isCreater;
        /* 用户名称 */
        TextView userName;
        /* 电话号码 */
        TextView tel;
        /* 删除管理员 */
        TextView deleteText;
        /* 首字母背景色 */
        View background;
        /* 首字母 */
        TextView catalog;
        /* 头像、HashCode文本 */
        RoundeImageHashCodeTextLayout roundImageHashText;
    }

    /**
     * 根据ListView的当前位置获取分类的首字母的Char ascii值
     */
    public int getSectionForPosition(int position) {
        if (null == list.get(position).getSortLetters()) {
            return 1;
        }
        return list.get(position).getSortLetters().charAt(0);
    }

    @SuppressWarnings("unused")
    public int getPositionForSection(int section) {
        for (int i = 0; i < getCount(); i++) {
            String sortStr = list.get(i).getSortLetters();
            if (null != sortStr) {
                char firstChar = sortStr.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }
        }
        return -1;
    }

    public List<GroupMemberInfo> getList() {
        return list;
    }

    public void setList(List<GroupMemberInfo> list) {
        this.list = list;
    }
}
