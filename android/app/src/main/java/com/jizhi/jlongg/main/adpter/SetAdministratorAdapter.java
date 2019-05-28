package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.DeleteUserListener;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:管理员列表适配器
 * 时间:2016-3-18 19:13
 * 作者:xuj
 */
public class SetAdministratorAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 删除管理员事件
     */
    private DeleteUserListener listener;

    public SetAdministratorAdapter(Context context, List<GroupMemberInfo> list, DeleteUserListener listener) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
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


    private void bindData(ViewHolder holder, final int position) {
        GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.userName.setText(bean.getReal_name());
        holder.isCreater.setVisibility(bean.getIs_creater() == 1 ? View.VISIBLE : View.GONE); //如果是管理员需要显示管理员标志
        holder.deleteText.setVisibility(bean.getIs_creater() == 1 ? View.GONE : View.VISIBLE); //如果是管理员需要隐藏删除
        holder.tel.setText(bean.getTelephone());
        holder.deleteText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.remove(position);
                }
            }
        });
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            isCreater = convertView.findViewById(R.id.isCrator);
            userName = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
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
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
    }


    public List<GroupMemberInfo> getList() {
        return list;
    }

    public void setList(List<GroupMemberInfo> list) {
        this.list = list;
    }
}
