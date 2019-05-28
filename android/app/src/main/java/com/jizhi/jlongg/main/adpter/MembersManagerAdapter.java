package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.MemberManagerActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogUnRegister;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:成员管理适配器
 * 时间:2016-12-27 11:35:18
 * 作者:xuj
 */
public class MembersManagerAdapter extends PersonBaseAdapter {
    /**
     * 成员头像
     */
    private static final int TYPE_MEMBER = 0;
    /**
     * 添加人员、刪除人员
     */
    private static final int TYPE_ADD_OR_REMOVE = 1;
    /**
     * 成员列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 上下文
     */
    private Activity context;
    /**
     * 班组管理添加、删除人员回调
     */
    private AddMemberListener listener;
    /**
     * 是否是创建者、如果是创建者则有删除成员的权利
     */
    private boolean isCreator;
    /**
     * 是否关闭了本组
     */
    private boolean isClose;
    /**
     * 组类型
     */
    private String classType;
    /**
     * groupId
     */
    private String groupId;
    /**
     * 过滤文本
     */
    private String filterValue;
    /**
     * 点击头像跳转到全部成员
     */
    private boolean isClickHeadIntentAllMember;

    public void setCreator(boolean creator) {
        isCreator = creator;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public MembersManagerAdapter(Activity context, List<GroupMemberInfo> list, String groupId, String classType,
                                 AddMemberListener listener, boolean isClickHeadIntentAllMember) {
        this.context = context;
        this.list = list;
        this.classType = classType;
        this.groupId = groupId;
        this.listener = listener;
        this.isClickHeadIntentAllMember = isClickHeadIntentAllMember;
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
            return 0;
        }
        if (isClose || !TextUtils.isEmpty(filterValue)) {
            return list.size();
        }
        return isCreator ? list.size() + 2 : list.size() + 1;
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
                convertView = LayoutInflater.from(context).inflate(R.layout.item_team_manager_remove, parent, false);
                ImageView image = (ImageView) convertView.findViewById(R.id.remove_add_image);
                TextView state = (TextView) convertView.findViewById(R.id.state);
                image.setImageResource(position == list.size() ? R.drawable.icon_member_add : R.drawable.icon_member_delete);
                state.setText(position == list.size() ? "添加" : "删除");
                convertView.findViewById(R.id.remove_add_image).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (listener == null || isClose) {
                            return;
                        }
                        if (position == list.size()) { //添加
                            listener.add(MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                        } else { //删除
                            listener.remove(Constance.DELETE_MEMBER);
                        }
                    }
                });
                break;
            case TYPE_MEMBER:
                ViewHolder holder = null;
                if (convertView == null) {
                    convertView = LayoutInflater.from(context).inflate(R.layout.item_team_manager, parent, false);
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
        if (!TextUtils.isEmpty(classType) && classType.equals(WebSocketConstance.GROUP_CHAT)) {
            holder.tagIcon.setVisibility(View.GONE);
        } else if (bean.getIs_admin() == 1 ||
                bean.getIs_creater() == 1 ||
                bean.getIs_agency() == 1) {
            holder.tagIcon.setVisibility(View.VISIBLE);
            if (bean.getIs_creater() == 1) { //创建者
                holder.tagIcon.setImageResource(R.drawable.icon_creator);
            } else if (bean.getIs_agency() == 1) { //代班长
                holder.tagIcon.setImageResource(R.drawable.icon_proxyer);
            } else if (bean.getIs_admin() == 1) { //管理员
                holder.tagIcon.setImageResource(R.drawable.icon_administrator);
            }
        } else {
            holder.tagIcon.setVisibility(View.GONE);
        }
        String name = NameUtil.setName(bean.getReal_name());
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(name)) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(name);
                Matcher nameMatch = p.matcher(name);
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.userName.setText(builder);
            }
        } else {
            holder.userName.setText(name);
        }
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.isActive.setVisibility(!TextUtils.isEmpty(classType) && classType.equals(WebSocketConstance.GROUP_CHAT) ? View.GONE : bean.getIs_active() == 0 ? View.VISIBLE : View.GONE);
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                    if (isClickHeadIntentAllMember) {
                        MemberManagerActivity.actionStart(context, groupId, classType, isClose, isCreator, isCreator);
                    } else {
                        if (bean.getIs_active() == 0) { //未注册
                            new DialogUnRegister(context, classType, groupId, bean).show();
                        } else {
                            Intent intent = new Intent(context, ChatUserInfoActivity.class);
                            intent.putExtra(Constance.CLASSTYPE, classType);
                            intent.putExtra(Constance.GROUP_ID, groupId);
                            intent.putExtra(Constance.UID, bean.getUid());
                            intent.putExtra(Constance.BEAN_BOOLEAN, true);
                            (context).startActivityForResult(intent, Constance.REQUEST);
                        }
                    }
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

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getClassType() {
        return classType;
    }

    public void setClassType(String classType) {
        this.classType = classType;
    }


    public boolean isClose() {
        return isClose;
    }

    public void setClose(boolean close) {
        isClose = close;
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
