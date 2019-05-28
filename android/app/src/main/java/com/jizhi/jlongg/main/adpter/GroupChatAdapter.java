package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.umeng.analytics.MobclickAgent;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:聊聊适配器
 * 时间:2016-3-18 19:13
 * 作者:xuj
 */
public class GroupChatAdapter extends BaseAdapter {
    /**
     * 成员列表数据
     */
    private List<GroupDiscussionInfo> list;
    /**
     * xml数据解析器
     */
    private LayoutInflater inflater;
    /**
     * activity
     */
    private BaseActivity activity;
    /**
     * 搜索文本
     */
    private String filterValue;
    /**
     * 去该项目首页按钮的回调
     */
    private SelecteProListener listener;


    public GroupChatAdapter(BaseActivity activity, List<GroupDiscussionInfo> list, SelecteProListener listener) {
        super();
        this.list = list;
        this.listener = listener;
        inflater = LayoutInflater.from(activity);
        this.activity = activity;
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
            convertView = inflater.inflate(R.layout.group_chat_item, null, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }


    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final GroupDiscussionInfo bean = list.get(position);
        final String classType = bean.getClass_type();
        final String groupName = bean.getGroup_name();
        final String groupId = bean.getGroup_id();
        if (!TextUtils.isEmpty(groupName)) {
            String indexOfGroupName = groupName.length() > 8 ? groupName.substring(0, 8) + "..." : groupName;
            if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
                //工作消息、招聘消息、活动消息、单聊不需要显示成员数量
                if (!MessageType.WORK_MESSAGE_ID.equals(groupId) && !MessageType.RECRUIT_MESSAGE_ID.equals(groupId) &&
                        !MessageType.ACTIVITY_MESSAGE_ID.equals(groupId) && !MessageType.NEW_FRIEND_MESSAGE_ID.equals(groupId) &&
                        !classType.equals(WebSocketConstance.SINGLECHAT)) {
                    indexOfGroupName = groupName + "(" + bean.getMembers_num() + ")";
                }
                if (!TextUtils.isEmpty(indexOfGroupName)) { //姓名不为空的时才进行模糊匹配
                    SpannableStringBuilder builder = new SpannableStringBuilder(indexOfGroupName);
                    Matcher nameMatch = Pattern.compile(filterValue).matcher(indexOfGroupName);
                    while (nameMatch.find()) {
                        ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                        builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                    }
                    holder.groupName.setText(builder);
                }
            } else {
                switch (classType) {
                    case WebSocketConstance.TEAM: //班组
                    case WebSocketConstance.GROUP://项目组
                    case WebSocketConstance.GROUP_CHAT: //群聊
                        holder.groupName.setText(indexOfGroupName + "(" + bean.getMembers_num() + ")");
                        break;
                    default:
                        holder.groupName.setText(indexOfGroupName);
                        break;
                }
            }
        }
        switch (groupId) {
            case MessageType.WORK_MESSAGE_ID: //工作消息
                holder.singImageIcon.loadLocalPic(R.drawable.work_message_chat_state, position);
                holder.teamHeads.setVisibility(View.GONE);
                holder.singImageIcon.setVisibility(View.VISIBLE);
                holder.selecteProBtn.setVisibility(View.GONE); //隐藏去首页选项
                break;
            case MessageType.ACTIVITY_MESSAGE_ID: //活动消息
                holder.singImageIcon.loadLocalPic(R.drawable.activity_message_chat_state, position);
                holder.teamHeads.setVisibility(View.GONE);
                holder.singImageIcon.setVisibility(View.VISIBLE);
                holder.selecteProBtn.setVisibility(View.GONE); //隐藏去首页选项
                break;
            case MessageType.RECRUIT_MESSAGE_ID: //招聘消息
                holder.singImageIcon.loadLocalPic(R.drawable.recruit_message_chat_state, position);
                holder.teamHeads.setVisibility(View.GONE);
                holder.singImageIcon.setVisibility(View.VISIBLE);
                holder.selecteProBtn.setVisibility(View.GONE); //隐藏去首页选项
                break;
            case MessageType.NEW_FRIEND_MESSAGE_ID: //新的朋友
                holder.singImageIcon.loadLocalPic(R.drawable.new_friend_message_chat_state, position);
                holder.teamHeads.setVisibility(View.GONE);
                holder.singImageIcon.setVisibility(View.VISIBLE);
                holder.selecteProBtn.setVisibility(View.GONE); //隐藏去首页选项
                break;
            default: //普通消息
                switch (classType) {
                    case WebSocketConstance.SINGLECHAT: //单聊信息
                        holder.teamHeads.setVisibility(View.GONE);
                        holder.singImageIcon.setVisibility(View.VISIBLE);
                        holder.singImageIcon.setDEFAULT_TEXT_SIZE(15);
                        holder.singImageIcon.setView(bean.getMembers_head_pic() == null || bean.getMembers_head_pic().size() == 0 ? "" : bean.getMembers_head_pic().get(0), groupName, position);
                        holder.selecteProBtn.setVisibility(View.GONE); //隐藏去首页选项
                        break;
                    case WebSocketConstance.TEAM: //班组
                    case WebSocketConstance.GROUP://项目组
                    case WebSocketConstance.GROUP_CHAT: //群聊
                        holder.teamHeads.setVisibility(View.VISIBLE);
                        holder.singImageIcon.setVisibility(View.GONE);
                        holder.teamHeads.setImagesData(bean.getMembers_head_pic()); //设置图片头像
                        if (classType.equals(WebSocketConstance.GROUP_CHAT)) { //群聊
                            holder.selecteProBtn.setVisibility(View.GONE);
                        } else {
                            holder.selecteProBtn.setVisibility(View.VISIBLE);
                            holder.selecteProBtn.setText(classType.equals(WebSocketConstance.TEAM) ? "去该项目首页" : "去该班组首页");
                            holder.selecteProBtn.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    MobclickAgent.onEvent(activity, "click_change_pro"); //U盟点击分享统计
                                    listener.selecte(bean);
                                }
                            });
                        }
                        break;
                }
                break;
        }
        if (!TextUtils.isEmpty(bean.getAt_message())) { //是否有人@我
            holder.isCallMe.setVisibility(View.VISIBLE);
            holder.isCallMe.setText(String.format(activity.getString(R.string.isCallMe), bean.getAt_message()));
        } else {
            holder.isCallMe.setVisibility(View.GONE);
        }
        if (bean.is_no_disturbed == 1) { //消息免打扰
            holder.unread_message_count.setVisibility(View.GONE);
            holder.noDisturbingMessageView.setVisibility(bean.getUnread_msg_count() > 0 ? View.VISIBLE : View.GONE);
            Drawable noDisturbingDrawable = activity.getResources().getDrawable(R.drawable.no_disturbing); //免打扰图标
            noDisturbingDrawable.setBounds(0, 0, noDisturbingDrawable.getIntrinsicWidth(), noDisturbingDrawable.getIntrinsicHeight()); //设置清除的图片
            holder.groupName.setCompoundDrawables(null, null, noDisturbingDrawable, null);
        } else {
            holder.noDisturbingMessageView.setVisibility(View.GONE);
            holder.groupName.setCompoundDrawables(null, null, null, null);
            if (bean.getUnread_msg_count() == 0) {
                holder.unread_message_count.setVisibility(View.GONE);
            } else {
                holder.unread_message_count.setText(Utils.setMessageCount(bean.getUnread_msg_count()));
                holder.unread_message_count.setVisibility(View.VISIBLE);
            }
        }
        holder.messageSendTime.setText(bean.getSend_time() != 0 ? Utils.simpleMessageForDateList(bean.getSend_time()) : "");
        holder.itemDiver.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
        Utils.setBackGround(convertView, bean.is_sticked == 0
                ? activity.getResources().getDrawable(R.drawable.draw_listview_selector_white_gray)
                : activity.getResources().getDrawable(R.drawable.listview_message_top)); //如果消息置顶则设置为另外一种颜色
        if (bean.getGroup_id().equals(MessageType.RECRUIT_MESSAGE_ID)) { //招聘消息 只取消息类型就行了
            holder.message.setText(TextUtils.isEmpty(bean.getTitle()) ? null : bean.getTitle());
        } else if (bean.getGroup_id().equals(MessageType.ACTIVITY_MESSAGE_ID)) { //活动消息
            holder.message.setText(TextUtils.isEmpty(bean.getTitle()) ? null : bean.getTitle());
        } else if (bean.getGroup_id().equals(MessageType.WORK_MESSAGE_ID)) { //工作消息
            holder.message.setText(!TextUtils.isEmpty(bean.getTitle()) ? bean.getTitle() : TextUtils.isEmpty(bean.getMsg_text()) ? "" : Html.fromHtml(bean.getMsg_text()));
        } else { //普通消息
            holder.message.setText(bean.getMsg_text());
        }
    }


    class ViewHolder {
        /* 讨论组聊天头像 */
        private NineGroupChatGridImageView teamHeads;
        /* 未读消息数 */
        private TextView unread_message_count;
        /* 班组名称 */
        private TextView groupName;
        /* 消息内容 */
        private TextView message;
        /* 是否有人@我 */
        private TextView isCallMe;
        /* 消息时间 */
        private TextView messageSendTime;
        /* 底部线 */
        private View itemDiver;
        /* 消息免打扰时提示的小红点 */
        private View noDisturbingMessageView;
        /* 去该项目首页按钮 */
        private TextView selecteProBtn;
        /* 单聊头像 */
        private RoundeImageHashCodeTextLayout singImageIcon;

        public ViewHolder(View view) {
            unread_message_count = (TextView) view.findViewById(R.id.unread_message_count);
            teamHeads = (NineGroupChatGridImageView) view.findViewById(R.id.teamHeads);
            groupName = (TextView) view.findViewById(R.id.group_name);
            noDisturbingMessageView = view.findViewById(R.id.noDisturbingMessageView);
            messageSendTime = (TextView) view.findViewById(R.id.messageSendTime);
            message = (TextView) view.findViewById(R.id.message);
            itemDiver = view.findViewById(R.id.itemDiver);
            isCallMe = (TextView) view.findViewById(R.id.isCallMe);
            selecteProBtn = (TextView) view.findViewById(R.id.selecteProBtn);
            singImageIcon = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.singImageIcon);
        }
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


    public interface SelecteProListener {
        public void selecte(GroupDiscussionInfo groupDiscussionInfo);
    }
}
