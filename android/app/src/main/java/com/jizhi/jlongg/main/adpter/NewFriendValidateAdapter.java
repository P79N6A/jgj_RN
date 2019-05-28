package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.FriendValidate;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能:新朋友、适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class NewFriendValidateAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<FriendValidate> list;
    /* xml解析器 */
    private LayoutInflater inflater;


    public NewFriendValidateAdapter(Context context, List<FriendValidate> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    public void updateList(List<FriendValidate> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<FriendValidate> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public List<FriendValidate> getList() {
        return list;
    }

    public void setList(List<FriendValidate> list) {
        this.list = list;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public FriendValidate getItem(int position) {
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
            convertView = inflater.inflate(R.layout.new_friend_validate_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position) {
        final FriendValidate bean = list.get(position);
        holder.realName.setText(bean.getReal_name());
        holder.msgText.setText(bean.getMsg_text());
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.line.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
        // 1：未加入,2:已加入，3：已过期
        switch (bean.getStatus()) {
            case 1:
                holder.addBtn.setVisibility(View.VISIBLE);
                holder.state.setVisibility(View.GONE);
                break;
            case 2:
                holder.addBtn.setVisibility(View.GONE);
                holder.state.setVisibility(View.VISIBLE);
                holder.state.setText("已添加");
                break;
            case 3:
                holder.addBtn.setVisibility(View.GONE);
                holder.state.setVisibility(View.VISIBLE);
                holder.state.setText("已过期");
                break;
        }
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            line = convertView.findViewById(R.id.itemDiver);
            realName = (TextView) convertView.findViewById(R.id.realName);
            msgText = (TextView) convertView.findViewById(R.id.msgText);
            state = (TextView) convertView.findViewById(R.id.state);
            addBtn = convertView.findViewById(R.id.addBtn);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
        }

        /* 线 */
        View line;
        /* 用户名称*/
        TextView realName;
        /* 时间 */
        TextView msgText;
        /* 加入状态 */
        TextView state;
        /* 添加按钮布局 */
        View addBtn;
        /* 头像、HashCode文本 */
        RoundeImageHashCodeTextLayout roundImageHashText;
    }

}
