package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.MessageUtil;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:聊天适配器
 * 时间:2016-3-18 19:13
 * 作者:xuj
 */
public class ChooseTeamAdapter extends BaseAdapter {
    /**
     * 成员列表数据
     */
    private List<GroupDiscussionInfo> list;
    /**
     * xml数据解析器
     */
    private LayoutInflater inflater;
    /**
     * true 需要显示成员数量
     */
    private boolean showMemberNumber;
    /**
     * 显示类型
     * 1、表示只显示项目，班组   2、表示查询群聊
     */
    private int showGroupType;
    /**
     * 过滤文本
     */
    private String filterValue;


    public ChooseTeamAdapter(BaseActivity activity, List<GroupDiscussionInfo> list, boolean showMemberNumber, int showGroupType) {
        super();
        this.list = list;
        this.showMemberNumber = showMemberNumber;
        this.showGroupType = showGroupType;
        inflater = LayoutInflater.from(activity);
    }


    public void updateListView(List<GroupDiscussionInfo> list) {
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
            convertView = inflater.inflate(R.layout.item_choose_team, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(final ViewHolder holder, int position) {
        final GroupDiscussionInfo bean = list.get(position);
        String groupName = bean.getGroup_name();
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(groupName)) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(groupName);
                Matcher nameMatch = p.matcher(groupName);
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.proName.setText(builder);
            }
        } else {
//            String str = "<font color='#333333'>" + groupName + "</font>";
//            if (showMemberNumber) {
//                str += "<font color='#333333'>(" + bean.getMembers_num() + ")</font>";
//            }
//            holder.proName.setText(Html.fromHtml(str));
            holder.proName.setText(groupName);
        }
        if (!TextUtils.isEmpty(bean.getClass_type()) && (bean.getMembers_head_pic() != null && bean.getMembers_head_pic().size() > 0)) {
            holder.teamHeads.setVisibility(View.VISIBLE);
            holder.teamHeads.setImagesData(bean.getMembers_head_pic());
        } else {
            holder.teamHeads.setVisibility(View.INVISIBLE);
        }
        if (showMemberNumber) {
            holder.membersNum.setVisibility(View.VISIBLE);
            holder.membersNum.setText("(" + bean.getMembers_num() + ")");
        } else {
            holder.membersNum.setVisibility(View.GONE);
        }
        if (position == getCount() - 1) {
            holder.itemDivider.setVisibility(View.GONE);
            holder.bottomDesc.setVisibility(View.VISIBLE);
            holder.bottomDesc.setText("共" + list.size() + (showGroupType == MessageUtil.TYPE_GROUP_AND_TEAM ? "个项目" : "个群组"));
        } else {
            holder.itemDivider.setVisibility(View.VISIBLE);
            holder.bottomDesc.setVisibility(View.GONE);
        }
    }


    class ViewHolder {
        /**
         * 讨论组聊天头像
         */
        private NineGroupChatGridImageView teamHeads;
        /**
         * 名称
         */
        private TextView proName;
        /**
         * 人数
         */
        private TextView membersNum;
        /**
         * 底部人数
         */
        private TextView bottomDesc;
        /**
         * 分割线
         */
        private View itemDivider;


        public ViewHolder(View view) {
            proName = (TextView) view.findViewById(R.id.proName);
            membersNum = (TextView) view.findViewById(R.id.membersNum);
            bottomDesc = (TextView) view.findViewById(R.id.bottomDesc);
            teamHeads = (NineGroupChatGridImageView) view.findViewById(R.id.teamHeads);
            itemDivider = view.findViewById(R.id.itemDiver);
            if (!showMemberNumber) {
                membersNum.setVisibility(View.GONE);
            }
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
}
