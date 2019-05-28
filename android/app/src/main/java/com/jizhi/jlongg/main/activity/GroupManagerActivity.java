package com.jizhi.jlongg.main.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.adpter.MembersManagerAdapter;
import com.jizhi.jlongg.main.adpter.QuitTeamGroupAdapter;
import com.jizhi.jlongg.main.adpter.ReportPersonAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 班组管理
 *
 * @author Xuj
 * @time 2016年8月23日 16:28:37
 */
@SuppressLint("NewApi")
public class GroupManagerActivity extends BaseActivity implements OnClickListener, AddMemberListener,
        ChatManagerAdapter.SwithBtnListener {

    /**
     * 成员数据
     */
    private List<GroupMemberInfo> memberList;
    /**
     * 项目组头像
     */
    private List<String> members_head_pic;
    /**
     * 班组管理ListView 适配器
     */
    private ChatManagerAdapter adapter;
    /**
     * 项目成员适配器
     */
    private MembersManagerAdapter memberAdapter;
    /**
     * 班组成员、汇报成员
     */
    private GridView memberGridView, reportGrid;
    /**
     * 汇报对象Layout
     */
    private LinearLayout reportLayout;
    /**
     * 项目成员数量、汇报对象数量
     */
    private TextView memberCountTxt, reportMemberTxt;
    /**
     * 组id,项目id
     */
    private String groupId;
    /**
     * 是否是创建者 1表示创建者  0表示普通人员
     * 是否是数据来源人 1表示是数据来源人  0表示普通人员
     */
    private int isMyselfGroup;
    /**
     * 班组是否已关闭,true表示 是否是我代班的
     */
    private boolean isClose, isMyAgenUser;
    /**
     * 班组头像
     */
    private NineGroupChatGridImageView teamHeads;
    /**
     * 班组名称
     */
    private TextView proNameText;
    /**
     * 代班长信息
     */
    private AgencyGroupUser agencyGroupUser;
    /**
     * 是否已设置我在本组的名称
     */
    private boolean isNickName;


    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, boolean isClosed) {
        Intent intent = new Intent(context, GroupManagerActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_BOOLEAN, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     * @param info         项目组信息(毕传)
     * @param isClosed     true表示已关闭,false反之
     * @param isMyAgenUser 我是否为代班长
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, boolean isClosed, boolean isMyAgenUser) {
        Intent intent = new Intent(context, GroupManagerActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_BOOLEAN, isClosed);
        intent.putExtra("isMyAgenUser", isMyAgenUser);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    private List<ChatManagerItem> getList() {
        ChatManagerItem menu1 = new ChatManagerItem("所在项目", false, false, GroupChatManagerActivity.BELONG_PRO);
        ChatManagerItem menu2 = new ChatManagerItem("班组二维码", !isClose, false, GroupChatManagerActivity.GROUP_SCAN);
        ChatManagerItem menu3 = new ChatManagerItem("班组名称", isClose ? false : isMyselfGroup == 0 ? false : true, false, GroupChatManagerActivity.GROUP_NAME);
        ChatManagerItem menu4 = new ChatManagerItem("班组地点", isClose ? false : isMyselfGroup == 0 ? false : true, true, GroupChatManagerActivity.GROUP_PLACE);
        ChatManagerItem menu6 = new ChatManagerItem("我在本组的名字", !isClose, true, GroupChatManagerActivity.GROUP_IN_MY_NAME);
        ChatManagerItem menu7 = new ChatManagerItem("消息免打扰", !isClose, false, GroupChatManagerActivity.MESSAGE_INTERRUPTION);
        ChatManagerItem menu8 = new ChatManagerItem("置顶聊天", !isClose, true, GroupChatManagerActivity.MESSAGE_TOP);
        ChatManagerItem menu9 = new ChatManagerItem("清空聊天记录", !isClose, true, GroupChatManagerActivity.CLEAR_MESSAGE);


        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
        chatManagerList.add(menu4);

//       =getIntent().getBooleanExtra("isMyAgenUser", false);
        if (isMyselfGroup == 1) { //只有自己创建的才能看到代班长
            ChatManagerItem menu5 = new ChatManagerItem("设置代班长", !isClose, true, GroupChatManagerActivity.SET_REPLACE_FOREMAN);
            menu5.setMenuValue("可帮你记工记账及管理班组成员");
            menu5.setValueBottomColor(Color.parseColor("#eb4e4e"));
            menu5.setValueColor(Color.parseColor("#eb4e4e"));
            chatManagerList.add(menu5);
        } else {
            if (isMyAgenUser) { //只有当我是代班长的时候才添加
                ChatManagerItem menu5 = new ChatManagerItem("代班时间", false, true, GroupChatManagerActivity.SET_REPLACE_FOREMAN);
                menu5.setMenuValue("你可帮班组长管理班组及记工");
                menu5.setValueBottomColor(Color.parseColor("#eb4e4e"));
                menu5.setValueColor(Color.parseColor("#eb4e4e"));
                menu5.setValueBottomSize(13);
                chatManagerList.add(menu5);
            }
        }
        chatManagerList.add(menu6);
        chatManagerList.add(menu7);
        chatManagerList.add(menu8);
        chatManagerList.add(menu9);


        menu2.setItemType(ChatManagerItem.RIGHT_IMAGE_ITEM);
        menu7.setItemType(ChatManagerItem.SWITCH_BTN);
        menu8.setItemType(ChatManagerItem.SWITCH_BTN);
        return chatManagerList;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.team_manager);
        initData();
        initView();
        getGroupInfo();
    }


    /**
     * 获取班组信息
     */
    private void getGroupInfo() {
        MessageUtil.getGroupInfo(this, groupId, WebSocketConstance.GROUP, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                GroupDiscussionInfo groupInfo = groupManager.getGroup_info(); //项目组信息
                members_head_pic = groupManager.getMembers_head_pic();
                teamHeads.setImagesData(members_head_pic);
                proNameText.setText(groupInfo.getPro_name() + "-" + groupInfo.getGroup_name());
                isNickName = groupInfo.is_nickname == 1;
                List<GroupMemberInfo> members = groupManager.getMember_list();
                //每次都同步一下头像信息
                MessageUtil.modityLocalTeamGroupInfo(GroupManagerActivity.this, null, proNameText.getText().toString(), null,
                        groupId, WebSocketConstance.GROUP, null, null, members_head_pic, members == null ? "0" : members.size() + "", 0,
                        null, null, null, null);
                List<ChatManagerItem> list = adapter.getList();
                for (ChatManagerItem menu : list) {
                    int menuType = menu.getMenuType();
                    switch (menuType) {
                        case GroupChatManagerActivity.BELONG_PRO://所在项目
                            menu.setValue(groupInfo.getPro_name());
                            break;
                        case GroupChatManagerActivity.GROUP_NAME: //班组名称
                            menu.setValue(groupInfo.getGroup_name());
                            break;
                        case GroupChatManagerActivity.GROUP_PLACE://班组地点
                            menu.setValue(groupInfo.getCity_name());
                            break;
                        case GroupChatManagerActivity.GROUP_IN_MY_NAME://我在本组的名称
                            menu.setValue(groupManager.getNickname());
                            break;
                        case GroupChatManagerActivity.MESSAGE_INTERRUPTION://消息免打扰
                            menu.setSwitchState(groupManager.getIs_no_disturbed() == 0 ? false : true);
                            break;
                        case GroupChatManagerActivity.MESSAGE_TOP://置顶聊天
                            menu.setSwitchState(groupManager.getIs_sticked() == 0 ? false : true);
                            break;
                        case GroupChatManagerActivity.SET_REPLACE_FOREMAN: //代班长
                            AgencyGroupUser user = groupManager.getAgency_group_user();
                            if (user != null && !TextUtils.isEmpty(user.getUid())) { //代班长信息不为空
                                menu.setValue(isMyselfGroup == 1 ? user.getReal_name() : null); //代班长不需要显示自己姓名
                                if (!TextUtils.isEmpty(user.getStart_time()) && !TextUtils.isEmpty(user.getEnd_time())) {
                                    menu.setValueBottom(user.getStart_time().replaceAll("-", ".") + "-" + user.getEnd_time().replaceAll("-", "."));
                                } else if (!TextUtils.isEmpty(user.getStart_time())) {
                                    menu.setValueBottom(user.getStart_time().replaceAll("-", ".") + "起");
                                } else if (!TextUtils.isEmpty(user.getEnd_time())) {
                                    menu.setValueBottom("到" + user.getEnd_time().replaceAll("-", "."));
                                } else {
                                    menu.setValueBottom("无代班时间限制");
                                }
                            } else {
                                menu.setValue(null);
                                menu.setValueBottom(null);
                            }
                            GroupManagerActivity.this.agencyGroupUser = user;
                            break;
                    }
                }

                memberList = members;
                if (members != null && members.size() > 0) { //班组成员
                    //只有代班长和创建者才显示删除按钮,头像只显示一排 一排最多7个头像,如果是创建者和管理员 还需要显示删除和添加成员按钮，如果是普通成员则只显示添加按钮
                    boolean isProxyer = false;
                    for (GroupMemberInfo groupMemberInfo : members) {
                        if (groupMemberInfo.getIs_agency() == 1 && UclientApplication.getUid(getApplicationContext()).equals(groupMemberInfo.getUid())) { //代班长标识
                            isProxyer = true;
                            break;
                        }
                    }
                    //1、增加代班长标识；
                    //2、代班长可添加成员；
                    //3、代班长可删除除创建者和代班长自己以外的成员；
                    //4、代班长不可编辑班组名称和班组地点；
                    int maxMember = isProxyer || isMyselfGroup == 1 ? 5 : 6;
                    if (memberAdapter == null) {
                        memberAdapter = new MembersManagerAdapter(GroupManagerActivity.this, members.size() > maxMember ?
                                members.subList(0, maxMember) : members, groupId, WebSocketConstance.GROUP, GroupManagerActivity.this, true);
                        memberAdapter.setCreator(isProxyer || isMyselfGroup == 1 ? true : false);
                        memberAdapter.setClose(isClose);
                        memberGridView.setAdapter(memberAdapter);
                    } else {
                        memberAdapter.updateListView(members.size() > maxMember ?
                                members.subList(0, maxMember) : members);
                    }
                    memberCountTxt.setText(members.size() + "人");
                }
                if (isMyselfGroup == 1) { //汇报对象
                    List<GroupMemberInfo> reportUsers = groupManager.getReport_user_list(); //获取汇报对象
                    if (reportUsers != null && reportUsers.size() > 0) {
                        reportGrid.setAdapter(new ReportPersonAdapter(GroupManagerActivity.this, reportUsers, groupId));
                        reportMemberTxt.setText(String.valueOf(reportUsers.size()) + "人"); //汇报对象数量
                    } else {
                        reportLayout.setVisibility(View.GONE);
                    }
                }
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    @Override
    public void add(int addType) {
        AddMemberWayActivity.actionStart(this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER, groupId,
                WebSocketConstance.GROUP, members_head_pic, getItemValue(GroupChatManagerActivity.BELONG_PRO) + "-" +
                        getItemValue(GroupChatManagerActivity.GROUP_NAME), memberList, false); //添加成员
    }

    @Override
    public void remove(int state) {
        Intent intent = new Intent(this, DeleteMemberActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) memberList);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER);
        startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (resultCode) {
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加班组成员
                getGroupInfo();
                break;
            case Constance.REFRESH: //刷新数据
                getGroupInfo();
                break;
            case Constance.DELETE_GROUP_MEMBER: //删除班组成员
                getGroupInfo();
                break;
            case Constance.SET_CITY_INFO_SUCCESS: //设置班组地点成功后的回调
                getGroupInfo();
                break;
            case Constance.SUCCESS: //修改项目名称、我在本组的名称
                getGroupInfo();
                break;
            case Constance.CLICK_SINGLECHAT: //点击成员单聊
                setResult(Constance.CLICK_SINGLECHAT, data);
                finish();
                break;
            case Constance.FIND_WORKER_CALLBACK:
                setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
                finish();
                break;
        }
    }


    @Override
    public void toggle(int menuType, final boolean toggle) {
        switch (menuType) {
            case GroupChatManagerActivity.MESSAGE_TOP: //消息置顶
                MessageUtil.modifyTeamGroupInfo(this, groupId, WebSocketConstance.GROUP, null, null, null, null, toggle ? "1" : "0",
                        null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(GroupManagerActivity.this, toggle ? "1" : "0", null, null, groupId,
                                        WebSocketConstance.GROUP, null, null, null, null, 0,
                                        null, null, null, null);
                                for (ChatManagerItem item : adapter.getList()) {
                                    if (item.getMenuType() == GroupChatManagerActivity.MESSAGE_TOP) {
                                        item.setSwitchState(toggle);
                                        adapter.notifyDataSetChanged();
                                        break;
                                    }
                                }
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                break;
            case GroupChatManagerActivity.MESSAGE_INTERRUPTION: //消息免打扰
                MessageUtil.modifyTeamGroupInfo(this, groupId, WebSocketConstance.GROUP, null, null, null, toggle ? "1" : "0", null,
                        null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(GroupManagerActivity.this, null, null, toggle ? "1" : "0", groupId, WebSocketConstance.GROUP,
                                        null, null, null, null, 0, null, null, null, null);
                                for (ChatManagerItem item : adapter.getList()) {
                                    if (item.getMenuType() == GroupChatManagerActivity.MESSAGE_INTERRUPTION) {
                                        item.setSwitchState(toggle);
                                        adapter.notifyDataSetChanged();
                                        break;
                                    }
                                }
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                break;
        }
    }


    public static final String REOPEN = "1";
    public static final String THROUGHT_DELETE = "2";
    public static final String CLOSE_GROUP = "3";
    public static final String CLOSE_GROUP_AND_DELETE = "4";
    public static final String QUIT_GROUP = "5";


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.allMemberLayout: //查看全部成员
                MemberManagerActivity.actionStart(GroupManagerActivity.this, groupId, WebSocketConstance.GROUP, isClose, false, isMyselfGroup == 1);
                break;
        }
    }

    public List<SingleSelected> getCloseItem() {
        List<SingleSelected> list = new ArrayList<>();
        if (isMyselfGroup == 1) { //创建者
            if (isClose) { //已经关闭了项目组
                list.add(new SingleSelected("重新开启", false, false, REOPEN));
                list.add(new SingleSelected("彻底删除", false, true, THROUGHT_DELETE));
            } else {
                list.add(new SingleSelected("暂时关闭班组", false, false, CLOSE_GROUP));
                list.add(new SingleSelected("关闭并删除班组", false, true, CLOSE_GROUP_AND_DELETE));
            }
        } else {
            list.add(new SingleSelected("退出班组", false, true, QUIT_GROUP));
        }
        return list;
    }

    /**
     * 重新开启班组
     */
    private void reOpen() {
        MessageUtil.reOpen(this, groupId, WebSocketConstance.GROUP, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                MessageUtil.addTeamOrGroupToLocalDataBase(GroupManagerActivity.this, "开启成功", groupDiscussionInfo, true);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 退出班组
     */
    private void quitGroup() {
        MessageUtil.quitGroup(this, groupId, WebSocketConstance.GROUP, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "退出成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(GroupManagerActivity.this, groupId, WebSocketConstance.GROUP);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 彻底删除项目
     */
    private void thoroughDeleteGroup() {
        MessageUtil.thoroughDeleteGroup(this, groupId, WebSocketConstance.GROUP, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(GroupManagerActivity.this, groupId, WebSocketConstance.GROUP);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 关闭班组
     */
    private void closeGroup() {
        MessageUtil.closeTeamGroup(this, groupId, WebSocketConstance.GROUP, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "关闭成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(GroupManagerActivity.this, groupId, WebSocketConstance.GROUP);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    private void initData() {
        Intent intent = getIntent();
        GroupDiscussionInfo info = (GroupDiscussionInfo) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        isMyselfGroup = UclientApplication.getUid().equals(info.getCreater_uid()) ? 1 : 0;
        groupId = info.getGroup_id();
        isClose = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false); //是否是关闭项目
        isMyAgenUser = info.getAgency_group_user() != null && UclientApplication.getUid().equals(info.getAgency_group_user().getUid()) ? true : false;
    }

    private void initView() {
        getTextView(R.id.title).setText(R.string.group_setting);
        final ListView listView = (ListView) findViewById(R.id.listView);

        View memberView = getLayoutInflater().inflate(R.layout.group_info_head, null);
        memberGridView = (GridView) memberView.findViewById(R.id.memberGrid);
        reportLayout = (LinearLayout) memberView.findViewById(R.id.reportLayout);
        reportGrid = (GridView) memberView.findViewById(R.id.reportGrid);
        memberCountTxt = (TextView) memberView.findViewById(R.id.memberCountTxt);
        reportMemberTxt = (TextView) memberView.findViewById(R.id.reportMemberTxt);
        teamHeads = (NineGroupChatGridImageView) memberView.findViewById(R.id.teamHeads);
        proNameText = (TextView) memberView.findViewById(R.id.proName);

        memberView.findViewById(R.id.allMemberLayout).setOnClickListener(this);
        //如果不是创建者就隐藏汇报对象
        reportMemberTxt.setVisibility(isMyselfGroup == 0 ? View.GONE : View.VISIBLE);
        reportLayout.setVisibility(isMyselfGroup == 0 ? View.GONE : View.VISIBLE);
        listView.addHeaderView(memberView, null, false);

        final List<ChatManagerItem> list = getList();
        adapter = new ChatManagerAdapter(GroupManagerActivity.this, list, GroupManagerActivity.this);
        adapter.setClose(isClose);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position -= listView.getHeaderViewsCount();
                ChatManagerItem item = adapter.getItem(position);
                if (!item.isClick()) {
                    return;
                }
                if (isClose) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "班组已关闭无法点击", CommonMethod.ERROR);
                    return;
                }
                switch (item.getMenuType()) {
                    case GroupChatManagerActivity.GROUP_PLACE: //班组地点
                        SelectProviceAndCityActivity.actionStart(GroupManagerActivity.this, groupId, getItemValue(GroupChatManagerActivity.GROUP_PLACE), true);
                        break;
                    case GroupChatManagerActivity.GROUP_NAME: //班组名称
                        ModifyGroupTeamInfoActivity.actionStart(GroupManagerActivity.this, getItemValue(GroupChatManagerActivity.GROUP_NAME), groupId, WebSocketConstance.GROUP, null, ModifyGroupTeamInfoActivity.UPDATE_GROUP_NAME);
                        break;
                    case GroupChatManagerActivity.GROUP_SCAN: //班组二维码
                        TeamGroupQrCodeActivity.actionStart(GroupManagerActivity.this, getItemValue(GroupChatManagerActivity.BELONG_PRO) + "-" + getItemValue(GroupChatManagerActivity.GROUP_NAME), groupId, WebSocketConstance.GROUP, members_head_pic);
                        break;
                    case GroupChatManagerActivity.GROUP_IN_MY_NAME: //我在本组的名称
                        ModifyGroupTeamInfoActivity.actionStart(GroupManagerActivity.this, isNickName ? getItemValue(GroupChatManagerActivity.GROUP_IN_MY_NAME) : null, groupId, WebSocketConstance.GROUP, null, ModifyGroupTeamInfoActivity.UPDATE_IN_GROUP_MY_NAME);
                        break;
                    case GroupChatManagerActivity.SET_REPLACE_FOREMAN: //设置代班组长
                        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) { //代班长信息不为空
                            SetReplaceForemanActivity.actionStart(GroupManagerActivity.this, groupId, agencyGroupUser.getStart_time(),
                                    agencyGroupUser.getEnd_time(), agencyGroupUser.getReal_name(), agencyGroupUser.getUid());
                        } else {
                            SetReplaceForemanActivity.actionStart(GroupManagerActivity.this, groupId);
                        }
                        break;
                    case GroupChatManagerActivity.CLEAR_MESSAGE://清空聊天信息
                        DBMsgUtil.getInstance().clearMessage(GroupManagerActivity.this, groupId, WebSocketConstance.GROUP);
                        break;
                }
            }
        });
        ListView quitList = (ListView) getLayoutInflater().inflate(R.layout.listview_no_title, null);
        quitList.setAdapter(new QuitTeamGroupAdapter(GroupManagerActivity.this, getCloseItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
            @Override
            public void getSingleSelcted(SingleSelected bean) {
                switch (bean.getSelecteNumber()) {
                    case CLOSE_GROUP://创建者-->暂时关闭班组
                        closeGroup();
                        break;
                    case QUIT_GROUP://普通成员-->退出班组
                        quitGroup();
                        break;
                    case REOPEN: //创建者-->重新开启班组
                        reOpen();
                        break;
                    case THROUGHT_DELETE: //创建者-->项目当前的状态为关闭状态，那么可以彻底删除班组
                        thoroughDeleteGroup();
                        break;
                    case CLOSE_GROUP_AND_DELETE://创建者-->项目当前的状态为打开状态，关闭并删除班组
                        thoroughDeleteGroup();
                        break;
                }
            }
        }));
        listView.addFooterView(quitList, null, false);
    }

    public String getItemValue(int item) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == item) {
                return bean.getValue();
            }
        }
        return null;
    }


    @Override
    public void onFinish(View view) {
        Intent intent = getIntent();
        intent.putExtra(Constance.GROUP_NAME, getItemValue(GroupChatManagerActivity.BELONG_PRO) + "-" + getItemValue(GroupChatManagerActivity.GROUP_NAME));
        setResult(Constance.SET_PRO_NAME, intent);
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        Intent intent = getIntent();
        intent.putExtra(Constance.GROUP_NAME, getItemValue(GroupChatManagerActivity.BELONG_PRO) + getItemValue(GroupChatManagerActivity.GROUP_NAME));
        setResult(Constance.SET_PRO_NAME, intent);
        super.onBackPressed();
    }
}
