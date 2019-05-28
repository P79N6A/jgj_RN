package com.jizhi.jlongg.main.strategy;

import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ProListActivity;
import com.jizhi.jlongg.main.activity.ReplyMsgContentActivity;
import com.jizhi.jlongg.main.adpter.ChatMainGridModelAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;

/**
 * 班组、项目组策略
 *
 * @author Xuj
 * @time 2018年6月19日14:29:38
 * @Version 1.0
 */
public class TeamGroupStrategy extends MainStrategy {
    /**
     * activity
     */
    private BaseActivity activity;
    /**
     * 班组信息
     */
    private GridView messageGridView;
    /**
     * 群聊消息数
     */
    private TextView teamMessageCount;
    /**
     * 工作回复消息数
     */
    private TextView workReplyCount;
    /**
     * 群聊消息数layout
     */
    private View teamMessageLayout;
    /**
     * 群聊消息数layout
     */
    private View workReplyLayout;
    /**
     * 是否是我创建的项目组
     */
    private ImageView is_myself_group;
    /**
     * 代班长表示
     */
    private ImageView proxyFlag;
    /**
     * 项目名称
     */
    private TextView proName;
    /**
     * 切换项目  主要是做点击区域使用
     */
    private RelativeLayout changeTeamInfoLayout;
    /**
     * 其他项目小红点
     */
    private View otherGroupRedCircle;
    /**
     * 项目是否已关闭
     */
    private ImageView isClosedIcon;
    /**
     * 项目组头像
     */
    private NineGroupChatGridImageView teamHeads;


    public TeamGroupStrategy(BaseActivity activity) {
        this.activity = activity;
    }


    @Override
    public View getView(LayoutInflater inflater) {
        View convertView = inflater.inflate(R.layout.new_work_circle_hava_data, null, false);
        setView(convertView);
        return convertView;
    }

    @Override
    void setView(View convertView) {
        teamHeads = (NineGroupChatGridImageView) convertView.findViewById(R.id.teamHeads);
        changeTeamInfoLayout = (RelativeLayout) convertView.findViewById(R.id.changeTeamInfoLayout);
        messageGridView = (GridView) convertView.findViewById(R.id.messageGridView);
        teamMessageCount = (TextView) convertView.findViewById(R.id.teamMessageCount);
        workReplyCount = (TextView) convertView.findViewById(R.id.workReplyCount);
        teamMessageLayout = convertView.findViewById(R.id.teamMessageLayout);
        workReplyLayout = convertView.findViewById(R.id.workReplyLayout);
        is_myself_group = (ImageView) convertView.findViewById(R.id.is_myself_group);
        proxyFlag = (ImageView) convertView.findViewById(R.id.proxyFlag);
        proName = (TextView) convertView.findViewById(R.id.proName);
        otherGroupRedCircle = convertView.findViewById(R.id.otherGroupRedCircle);
        isClosedIcon = (ImageView) convertView.findViewById(R.id.isClosedIcon);
    }

    @Override
    public void bindData(Object object, View convertView, final int position) {
        final ChatMainInfo chatMainInfo = (ChatMainInfo) object;
        if (chatMainInfo == null || chatMainInfo.getGroup_info() == null) {
            return;
        }
        final GroupDiscussionInfo groupInfo = chatMainInfo.getGroup_info(); //项目组信息
        final String classType = groupInfo.getClass_type(); //获取组的类型 Team表示项目组  Group表示班组
        boolean isMyselfGroup = UclientApplication.getUid().equals(groupInfo.getCreater_uid()); //是否是我创建的班组,如果创建者的id和登录者的uid相同 则认为是创建者
        AgencyGroupUser agencyGroupUser = groupInfo.getAgency_group_user(); //获取带班组信息
        teamHeads.setImagesData(groupInfo.getMembers_head_pic()); //设置图片头像
        messageGridView.setAdapter(new ChatMainGridModelAdapter(activity, chatMainInfo, isMyselfGroup));
        proName.setText(groupInfo.getGroup_name()); //项目名称
        teamMessageCount.setText(Utils.setMessageCount(groupInfo.getUnread_msg_count())); //设置未读群聊信息
        workReplyCount.setText(Utils.setMessageCount(chatMainInfo.getWork_message_num())); //设置工作回复消息
        setViewMessageState(groupInfo.getUnread_msg_count(), teamMessageCount); //设置群聊消息未读状态 显示红色 还是黑色的字体
        setViewMessageState(chatMainInfo.getWork_message_num(), workReplyCount); //设置群聊消息未读状态 显示红色 还是黑色的字体
        is_myself_group.setVisibility(isMyselfGroup ? View.VISIBLE : View.GONE); //是否是我创建的班组
        otherGroupRedCircle.setVisibility(chatMainInfo.getOther_group_unread_msg_count() == 1 ? View.VISIBLE : View.GONE); //其他项目小红点
        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
            proxyFlag.setVisibility(View.VISIBLE);
            proxyFlag.setImageResource(agencyGroupUser.getUid().equals(UclientApplication.getUid()) ?
                    R.drawable.i_proxy_person_icon : R.drawable.other_proxy_person_icon);
        } else {
            proxyFlag.setVisibility(View.GONE);
        }
        if (groupInfo.getIs_closed() == 1) { //项目已关闭
            isClosedIcon.setVisibility(View.VISIBLE);
            isClosedIcon.setImageResource(classType.equals(WebSocketConstance.GROUP) ? R.drawable.group_closed_icon : R.drawable.team_closed_icon);
        } else {
            isClosedIcon.setVisibility(View.GONE);
        }
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch (view.getId()) {
                    case R.id.teamMessageLayout: //群聊消息
                        clickGroupMessage(groupInfo);
                        break;
                    case R.id.workReplyLayout: //工作回复
                        clickWorkMessage(chatMainInfo, groupInfo);
                        break;
                    case R.id.changeTeamInfoLayout: //切换项目
                        changePro(groupInfo);
                        break;
                }
            }
        };
        changeTeamInfoLayout.setOnClickListener(onClickListener);
        teamMessageLayout.setOnClickListener(onClickListener);
        workReplyLayout.setOnClickListener(onClickListener);
    }


    /**
     * 设置消息未读和已读的状态
     *
     * @param messageCount
     * @param teamMessageCount
     */
    private void setViewMessageState(int messageCount, TextView teamMessageCount) {
        if (messageCount > 0) { //有未读消息
            teamMessageCount.setTextSize(11);
            teamMessageCount.setTextColor(ContextCompat.getColor(activity, R.color.white));
            Utils.setBackGround(teamMessageCount, activity.getResources().getDrawable(R.drawable.badge_shape));
        } else { //没有未读消息
            teamMessageCount.setTextSize(15);
            teamMessageCount.setTextColor(ContextCompat.getColor(activity, R.color.color_333333));
            Utils.setBackGround(teamMessageCount, null);
        }
    }


    /**
     * 点击群聊消息
     *
     * @param groupInfo
     */
    private void clickGroupMessage(final GroupDiscussionInfo groupInfo) {
        //组已关闭
        if (groupInfo.getIs_closed() == 1) {
            CommonMethod.makeNoticeLong(activity, "该" + (groupInfo.getClass_type().equals(WebSocketConstance.GROUP) ? "班组" : "项目组") + "已经删除无法聊天", CommonMethod.ERROR);
            return;
        }
        //登录用户是否已完善了姓名
        IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                //完善姓名成功
                Utils.sendBroadCastToUpdateInfo(activity);
                MessageUtil.clearUnreadMessageCount(activity, groupInfo);
            }
        });
    }

    /**
     * 点击工作消息
     *
     * @param chatMainInfo
     * @param groupInfo
     */
    private void clickWorkMessage(final ChatMainInfo chatMainInfo, final GroupDiscussionInfo groupInfo) {
        //登录用户是否已完善了姓名
        IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                toWorkMessage(chatMainInfo, groupInfo);
            }
        });
    }


    private void toWorkMessage(ChatMainInfo chatMainInfo, GroupDiscussionInfo groupInfo) {
        MessageUtil.cleaWorkMessageCount(chatMainInfo);
        workReplyCount.setText("0");
        setViewMessageState(0, workReplyCount);
        ReplyMsgContentActivity.actionStart(activity, groupInfo, MessageType.MSG_SAFE_STRING);
    }


    /**
     * 切换项目
     *
     * @param groupInfo
     */
    private void changePro(final GroupDiscussionInfo groupInfo) {
        IsSupplementary.isFillRealNameCallBackListener(activity, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                ProListActivity.actionStart(activity, groupInfo.getGroup_id());
            }
        });
    }
}
