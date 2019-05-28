package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.Color;
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
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:消息转发适配器
 * 时间:2019年3月26日10:50:20
 * 作者:xuj
 */
public class MessageTransmitAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private ArrayList<GroupDiscussionInfo> list;
    /**
     * context
     */
    private Context context;
    /**
     * 搜索文本
     */
    private String filterValue;
    /**
     * true表示多选
     */
    private boolean isMultiPart;


    public MessageTransmitAdapter(Context context, ArrayList<GroupDiscussionInfo> list) {
        super();
        this.list = list;
        this.context = context;
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
            convertView = LayoutInflater.from(context).inflate(R.layout.forward_message_item, null, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final GroupDiscussionInfo groupDiscussionInfo = list.get(position);
        final String classType = groupDiscussionInfo.getClass_type();
        final String groupName = groupDiscussionInfo.getGroup_name();
        if (!TextUtils.isEmpty(groupName)) {
            if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
                SpannableStringBuilder builder = new SpannableStringBuilder(groupName);
                Matcher nameMatch = Pattern.compile(filterValue).matcher(groupName);
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.groupName.setText(builder);
            } else {
                holder.groupName.setText(groupName);
            }
        }
        switch (classType) {
            case WebSocketConstance.SINGLECHAT: //单聊信息
                holder.memberNum.setVisibility(View.GONE);
                holder.teamHeads.setVisibility(View.GONE);
                holder.singImageIcon.setVisibility(View.VISIBLE);
                holder.singImageIcon.setDEFAULT_TEXT_SIZE(15);
                holder.singImageIcon.setView(groupDiscussionInfo.getMembers_head_pic() == null || groupDiscussionInfo.getMembers_head_pic().size() == 0 ? "" : groupDiscussionInfo.getMembers_head_pic().get(0), groupName, position);
                break;
            case WebSocketConstance.TEAM: //班组
            case WebSocketConstance.GROUP://项目组
            case WebSocketConstance.GROUP_CHAT: //群聊
                holder.memberNum.setVisibility(View.VISIBLE);
                holder.teamHeads.setVisibility(View.VISIBLE);
                holder.singImageIcon.setVisibility(View.GONE);
                holder.teamHeads.setImagesData(groupDiscussionInfo.getMembers_head_pic()); //设置图片头像
                holder.memberNum.setText(groupDiscussionInfo.getMembers_num() + "人");
                break;
        }
        holder.firstTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
        if (isMultiPart) {
            holder.multipartIcon.setVisibility(View.VISIBLE);
            holder.multipartIcon.setImageResource(groupDiscussionInfo.is_selected == 1 ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        } else {
            holder.multipartIcon.setVisibility(View.GONE);
        }
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            firstTips = convertView.findViewById(R.id.first_tips);
            groupName = (TextView) convertView.findViewById(R.id.group_name);
            multipartIcon = (ImageView) convertView.findViewById(R.id.multipart_icon);
            memberNum = (TextView) convertView.findViewById(R.id.member_num);
            singImageIcon = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.singImageIcon);
            teamHeads = (NineGroupChatGridImageView) convertView.findViewById(R.id.teamHeads);
        }

        /**
         * 组名称
         */
        private TextView groupName;
        /**
         * 单选框
         */
        private ImageView multipartIcon;
        /**
         * 成员数量
         */
        private TextView memberNum;
        /**
         * 单聊头像
         */
        private RoundeImageHashCodeTextLayout singImageIcon;
        /**
         * 群聊头像
         */
        private NineGroupChatGridImageView teamHeads;
        /**
         *
         */
        private View firstTips;
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }

    public boolean isMultiPart() {
        return isMultiPart;
    }

    public void setMultiPart(boolean multiPart) {
        isMultiPart = multiPart;
    }


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(ArrayList<GroupDiscussionInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }
}
