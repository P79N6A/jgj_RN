package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:成员管理适配器
 * 时间:2016-12-27 11:35:18
 * 作者:xuj
 */
public class MembersNoTagAdapter extends PersonBaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 成员头像
     */
    private static final int TYPE_MEMBER = 0;
    /**
     * 添加人员、刪除人员
     */
    private static final int TYPE_ADD_OR_REMOVE = 1;
    /**
     * 成员数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 班组管理添加、删除人员回调
     */
    private AddMemberListener listener;


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public MembersNoTagAdapter(Activity context, List<GroupMemberInfo> list, AddMemberListener listener) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.listener = listener;
    }


    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        if (list == null) {
            return TYPE_ADD_OR_REMOVE;
        }
        if (position >= list.size()) {
            return TYPE_ADD_OR_REMOVE;
        } else {
            return TYPE_MEMBER;
        }
    }

    @Override
    public int getCount() {
        if (list == null) {
            return 1;
        }
        return list.size() + 1;//只有查看全部成员才会返回所有的成员数量
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
        int type = getItemViewType(position);
        switch (type) {
            case TYPE_ADD_OR_REMOVE:
                convertView = inflater.inflate(R.layout.item_team_manager_remove, parent, false);
                ImageView image = (ImageView) convertView.findViewById(R.id.remove_add_image);
                TextView state = (TextView) convertView.findViewById(R.id.state);
                image.setImageResource(R.drawable.icon_member_add);
                state.setText("添加");
                convertView.findViewById(R.id.remove_add_image).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (listener != null) {
                            listener.add(MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                        }
                    }
                });
                break;
            case TYPE_MEMBER:
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
                break;
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
                listener.remove(position);
                list.remove(position);
                notifyDataSetChanged();
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
