package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能:面对面成员建群适配器
 * 时间:2016-12-27 11:35:18
 * 作者:xuj
 */
public class FaceToFaceMembersManagerAdapter extends PersonBaseAdapter {
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 上下文 */
    private Context context;
    /* 班组人员数据 */
    private List<GroupMemberInfo> list;


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addListView(List<GroupMemberInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public FaceToFaceMembersManagerAdapter(Activity context, List<GroupMemberInfo> list) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.list = list;
    }


    @Override
    public int getCount() {
        if (list == null) {
            return 0;
        }
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_team_manager, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (holder != null) {
            bindData(holder, position);
        }
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        Resources res = context.getResources();
        final GroupMemberInfo bean = list.get(position);
        holder.tagIcon.setVisibility(View.GONE);
        holder.isActive.setVisibility(View.GONE);
        holder.userName.setText(bean.getReal_name());
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            tagIcon = (ImageView) view.findViewById(R.id.tagIcon);
            isActive =  view.findViewById(R.id.is_active);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }

        /**
         * 用户姓名
         */
        private TextView userName;
        /**
         * 是否是平台用户
         */
        private View isActive;
        /**
         * 创建者、管理员标签
         */
        private ImageView tagIcon;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
    }

    public List<GroupMemberInfo> getList() {
        return list;
    }


}
