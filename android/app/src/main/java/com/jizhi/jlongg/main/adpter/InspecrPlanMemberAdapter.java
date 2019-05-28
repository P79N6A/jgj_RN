package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能:成员管理适配器
 * 时间:2016-12-27 11:35:18
 * 作者:xuj
 */
public class InspecrPlanMemberAdapter extends PersonBaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 成员数据
     */
    private List<GroupMemberInfo> list;
    private Activity context;


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public InspecrPlanMemberAdapter(Activity context, List<GroupMemberInfo> list) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.context = context;
    }


    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

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
        final GroupMemberInfo bean = list.get(position);
        holder.tagIcon.setVisibility(View.GONE);
        holder.isActive.setVisibility(View.GONE);
        holder.userName.setText(NameUtil.setName(bean.getReal_name()));
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ChatUserInfoActivity.actionStart(context, bean.getUid());
            }
        };
        holder.roundImageHashText.setOnClickListener(onClickListener);
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            tagIcon = (ImageView) view.findViewById(R.id.tagIcon);
            isActive = view.findViewById(R.id.is_active);
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

    public void setList(List<GroupMemberInfo> list) {
        this.list = list;
    }
}
