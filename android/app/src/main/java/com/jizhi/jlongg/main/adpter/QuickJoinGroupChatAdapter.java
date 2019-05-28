package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;


/**
 * 功能:快速加群列表适配器
 * 时间:2018年4月19日10:33:47
 * 作者:xuj
 */
public class QuickJoinGroupChatAdapter extends BaseExpandableListAdapter {

    /**
     * true表示已加入了地方工种群
     */
    private boolean isAddedWorkTypeGroupChat;
    /**
     * true表示已加入了地方工友群
     */
    private boolean isAddedAreaGroupChat;
    /**
     * 列表数据
     */
    private GroupManager groupManager;
    /**
     * context
     */
    private Activity context;
    /**
     * 只有本地群
     */
    private final int ONLY_LOCAL_WORK_GROUPCHAT = 0;
    /**
     * 只有工种群
     */
    private final int ONLY_WORK_TYPE_GROUPCHAT = 1;
    /**
     * 两者都有
     */
    private final int ALL = 2;


    /**
     * 是否已添加群聊
     *
     * @param context
     * @param groupManager
     * @param isAddedWorkTypeGroupChat true表示已加入了地方工种群
     * @param isAddedAreaGroupChat     true表示已加入了地方工友群
     */
    public QuickJoinGroupChatAdapter(Activity context, GroupManager groupManager, boolean isAddedWorkTypeGroupChat, boolean isAddedAreaGroupChat) {
        this.groupManager = groupManager;
        this.context = context;
        this.isAddedWorkTypeGroupChat = isAddedWorkTypeGroupChat;
        this.isAddedAreaGroupChat = isAddedAreaGroupChat;
    }

    @Override
    public int getGroupCount() {
        if (!isEmptyWorkTypeList() && !isEmptyLocalFriendList()) {
            return 2;
        } else if (!isEmptyLocalFriendList()) {
            return 1;
        } else if (!isEmptyWorkTypeList()) {
            return 1;
        }
        return 2;
    }

    @Override
    public int getGroupType(int groupPosition) {
        if (!isEmptyWorkTypeList() && !isEmptyLocalFriendList()) {
            return ALL;
        } else if (!isEmptyWorkTypeList()) {
            return ONLY_WORK_TYPE_GROUPCHAT;
        } else if (isEmptyLocalFriendList()) {
            return ONLY_LOCAL_WORK_GROUPCHAT;
        }
        return ALL;
    }

    @Override
    public int getGroupTypeCount() {
        return 3;
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        int groupType = getGroupType(groupPosition);
        switch (groupType) {
            case ALL:
                return groupPosition == 0 ? groupManager.getLocal_list().size() : groupManager.getWork_list().size();
            case ONLY_LOCAL_WORK_GROUPCHAT:
                return groupManager.getLocal_list().size();
            case ONLY_WORK_TYPE_GROUPCHAT:
                return groupManager.getWork_list().size();
        }
        return groupPosition == 0 ? groupManager.getLocal_list().size() : groupManager.getWork_list().size();
    }


    public boolean isEmptyWorkTypeList() {
        ArrayList<GroupDiscussionInfo> workTypeList = groupManager.getWork_list();
        if (workTypeList != null && workTypeList.size() > 0) {
            return false;
        }
        return true;
    }

    public boolean isEmptyLocalFriendList() {
        ArrayList<GroupDiscussionInfo> localFriendList = groupManager.getLocal_list();
        if (localFriendList != null && localFriendList.size() > 0) {
            return false;
        }
        return true;
    }


    @Override
    public Object getGroup(int groupPosition) {
        return null;
    }

    @Override
    public GroupDiscussionInfo getChild(int groupPosition, int childPosition) {
        int groupType = getGroupType(groupPosition);
        switch (groupType) {
            case ALL:
                return groupPosition == 0 ? groupManager.getLocal_list().get(childPosition) : groupManager.getWork_list().get(childPosition);
            case ONLY_LOCAL_WORK_GROUPCHAT:
                return groupManager.getLocal_list().get(childPosition);
            case ONLY_WORK_TYPE_GROUPCHAT:
                return groupManager.getWork_list().get(childPosition);
        }
        return groupPosition == 0 ? groupManager.getLocal_list().get(childPosition) : groupManager.getWork_list().get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        final GroupHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_head_quick_join_groupchat, null, false);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        int groupType = getGroupType(groupPosition);
        switch (groupType) {
            case ALL:
                holder.title.setTextColor(ContextCompat.getColor(context, groupPosition == 0 ? R.color.color_e28000 : R.color.color_2584EF));
                holder.title.setText(groupPosition == 0 ? R.string.quick_join_group : R.string.quick_join_work_group);
                if (groupPosition == 0) {
                    holder.titleDesc.setText(R.string.only_join_area_worker_group);
                } else {
//                    holder.value.setVisibility(View.VISIBLE);
//                    holder.value.setText(R.string.join_be_good_at_work);
                    holder.titleDesc.setText(R.string.only_join_work_group);
                }
                holder.icon.setImageResource(groupPosition == 0 ? R.drawable.local_work_icon : R.drawable.work_type_icon);
                break;
            case ONLY_LOCAL_WORK_GROUPCHAT:
                holder.title.setTextColor(ContextCompat.getColor(context, R.color.color_e28000));
                holder.title.setText(R.string.quick_join_group);
                holder.icon.setImageResource(R.drawable.local_work_icon);
                holder.titleDesc.setText(R.string.only_join_area_worker_group);
                break;
            case ONLY_WORK_TYPE_GROUPCHAT:
                holder.title.setTextColor(ContextCompat.getColor(context, R.color.color_2584EF));
                holder.title.setText(R.string.quick_join_work_group);
//                holder.value.setText(R.string.join_be_good_at_work);
                holder.titleDesc.setText(R.string.only_join_work_group);
                holder.icon.setImageResource(R.drawable.work_type_icon);
                break;
        }
        holder.itemDivider.setVisibility(groupPosition == 0 ? View.GONE : View.VISIBLE);
        return convertView;
    }


    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, final ViewGroup parent) {
        final ChildHolder childHolder;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_quick_join_groupchat, null, false);
            childHolder = new ChildHolder(convertView);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        final int groupType = getGroupType(groupPosition);
        final GroupDiscussionInfo groupDiscussionInfo = getChild(groupPosition, childPosition);
        childHolder.groupName.setText(groupDiscussionInfo.getGroup_name() + "(" + groupDiscussionInfo.getMembers_num() + ")");
        if (groupDiscussionInfo.is_exist == 0) {
            childHolder.joinBtn.setText("加入群聊");
            childHolder.joinIcon.setVisibility(View.VISIBLE);
            childHolder.joinBtn.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
            Utils.setBackGround(childHolder.joinBtnLayout, context.getResources().getDrawable(R.drawable.draw_sk_eb4e4e_2radius));
            childHolder.joinBtnLayout.setClickable(true);
            childHolder.joinBtnLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    switch (groupType) {
                        case ALL:
                            handlerJoinLogic(groupDiscussionInfo, groupPosition == 0 ? 2 : 1);
                            break;
                        case ONLY_LOCAL_WORK_GROUPCHAT:
                            handlerJoinLogic(groupDiscussionInfo, 2);
                            break;
                        case ONLY_WORK_TYPE_GROUPCHAT:
                            handlerJoinLogic(groupDiscussionInfo, 1);
                            break;
                    }
                }
            });
        } else {
            childHolder.joinBtn.setText("已加入");
            childHolder.joinIcon.setVisibility(View.GONE);
            childHolder.joinBtn.setTextColor(ContextCompat.getColor(context, R.color.color_666666));
            Utils.setBackGround(childHolder.joinBtnLayout, context.getResources().getDrawable(R.drawable.bg_gy_cccccc_2radius));
            childHolder.joinBtnLayout.setClickable(false);
        }
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) childHolder.itemDivider.getLayoutParams();
        params.leftMargin = childPosition == 0 ? 0 : DensityUtil.dp2px(33);
        childHolder.itemDivider.setLayoutParams(params);
        return convertView;
    }


    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    class GroupHolder {
        /**
         * 项目组名称
         */
        TextView title;
        /**
         * 图标
         */
        ImageView icon;
        /**
         * 标题描述
         */
        TextView titleDesc;
        /**
         * 分割线
         */
        View itemDivider;


        public GroupHolder(View convertView) {
            title = convertView.findViewById(R.id.title);
            icon = convertView.findViewById(R.id.icon);
            titleDesc = convertView.findViewById(R.id.title_desc);
            itemDivider = convertView.findViewById(R.id.item_divider);
        }
    }

    class ChildHolder {

        /**
         * 项目组名称
         */
        TextView groupName;
        /**
         * 加入群聊按钮
         */
        TextView joinBtn;
        /**
         * 加入群聊布局
         */
        View joinBtnLayout;
        /**
         * 加入群聊图标
         */
        ImageView joinIcon;
        /**
         * 分割线
         */
        View itemDivider;


        public ChildHolder(View convertView) {
            groupName = convertView.findViewById(R.id.group_name);
            joinBtn = convertView.findViewById(R.id.join_btn);
            joinBtnLayout = convertView.findViewById(R.id.join_btn_layout);
            joinIcon = convertView.findViewById(R.id.join_icon);
            itemDivider = convertView.findViewById(R.id.item_divider);
        }
    }

    /**
     * 处理加入群聊点击逻辑
     * 1、进入快速加群界面时，判断“快速加入地方群”、“快速加入工种群”的显示（加群消息存本地）；
     * 2、只允许用户加入一个工种群，点击了“+加入群聊”，弹框提示：
     * 只能加入一个工种群，请谨慎选择。
     * 确定加入选择的工种群吗？
     * 【取消】【确定】
     * 点击【确定】 后界面刷新，已添加的群状态变为“已加入”；
     * 点击【取消】，返回到快速加群界面；
     * 3、已加入一个群，再次点击其他的“加入群聊”，气泡提示：你已加入了一个工种，如想进其他工种群，联系吉工家客服拉你入群吧！
     * 4、添加群后，如后期再次点击到该页面，需显示已经加入的群；
     * 5、每次进入快速加群界面，需获取最新的群（如消息推送的时候是群1，但是用户并没有立即加入，后期再进入快速加群界面时，群1可能已经满了，目前群可能已经到了群15了），已经加入的群，需要显示出来；
     *
     * @param groupDiscussionInfo 组信息
     * @param addFrom             来自哪里的添加
     *                            1表示从快速加群-->工种群
     *                            2表示从快速加群-->地区群
     */
    private void handlerJoinLogic(final GroupDiscussionInfo groupDiscussionInfo, final int addFrom) {
        switch (addFrom) {
            case 1: //加入工种群
                if (isAddedWorkTypeGroupChat) {
                    CommonMethod.makeNoticeLong(context, "你已加入了一个工种群，不能再加入其它工种群啦！", CommonMethod.ERROR);
                    return;
                }
                new DialogLeftRightBtnConfirm(context, null,
                        "只能加入一个工种群，\n确定加入选择的工种群吗？", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        joinGroup(groupDiscussionInfo, addFrom);
                    }
                }).show();
                break;
            case 2: //加入地区群
                if (isAddedAreaGroupChat) {
                    CommonMethod.makeNoticeLong(context, "你已加入了一个地方群，不能再加入其它地方群啦！", CommonMethod.ERROR);
                    return;
                }
                //V3.5.3）三个类型的群，如果只存在一个群时，点击“+加入群聊”，直接加入群聊；
                //V3.5.3）如果同时存在2个或者3个地方群时，用户只能加入一个地方群，点击了“+加入群聊”，弹框提示：
                if (getChildrenCount(0) > 1) {
                    new DialogLeftRightBtnConfirm(context, null, "只能加入一个地方群，请谨慎选择。\n确定加入选择的地方群吗？", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {

                        }

                        @Override
                        public void clickRightBtnCallBack() {
                            joinGroup(groupDiscussionInfo, addFrom);
                        }
                    }).show();
                } else {
                    joinGroup(groupDiscussionInfo, addFrom);
                }
                break;
        }
    }

    /**
     * 加入群聊
     *
     * @param groupDiscussionInfo 组信息
     * @param addFrom             来自哪里的添加
     *                            1表示从快速加群-->工种群
     *                            2表示从快速加群-->地区群
     */
    private void joinGroup(final GroupDiscussionInfo groupDiscussionInfo, final int addFrom) {
        ArrayList<GroupMemberInfo> memberInfos = new ArrayList<>();
        GroupMemberInfo groupMemberInfo = new GroupMemberInfo(UclientApplication.getRealName(context), UclientApplication.getTelephone(context));
        groupMemberInfo.setUid(UclientApplication.getUid());
        memberInfos.add(groupMemberInfo);
        MessageUtil.addFastGroupChat(context, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type(), memberInfos, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (addFrom == 1) {
                    isAddedWorkTypeGroupChat = true;
                } else if (addFrom == 2) {
                    isAddedAreaGroupChat = true;
                }
                groupDiscussionInfo.setIs_exist(1);
                groupDiscussionInfo.setAdd_from(addFrom);
                //验证本地是否已加入过了这个群 如果没加入则加入到群聊中
                if (!MessageUtil.checkGroupIsExist(context, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type())) {
                    groupDiscussionInfo.setSort_time(System.currentTimeMillis() / 1000);
                    MessageUtil.addTeamOrGroupToLocalDataBase(context, null, groupDiscussionInfo, true);
                } else {
                    MessageUtil.modityLocalTeamGroupInfo(context, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type(), addFrom);
                }
                notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}


