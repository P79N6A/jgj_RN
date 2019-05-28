package com.jizhi.jlongg.main.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;

import com.baidu.mapapi.search.core.PoiInfo;
import com.hcs.uclient.utils.CallPhoneUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.adpter.MembersManagerAdapter;
import com.jizhi.jlongg.main.adpter.QuitTeamGroupAdapter;
import com.jizhi.jlongg.main.adpter.SourceMemberAdapter;
import com.jizhi.jlongg.main.adpter.TeamVersionAndCloudAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.SourceMemberProManager;
import com.jizhi.jlongg.main.dialog.DialogEditorSourcePro;
import com.jizhi.jlongg.main.dialog.DialogTeamManageSourceMemberTips;
import com.jizhi.jlongg.main.listener.SourceMemberListener;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
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
 * @time 2017年4月12日17:22:41
 */
@SuppressLint("NewApi")
public class TeamManagerActivity extends BaseActivity implements OnClickListener, AddMemberListener, ChatManagerAdapter.SwithBtnListener {
    /**
     * 成员列表数据、数据来源人数据
     */
    private List<GroupMemberInfo> memberList, sourceMemberList;
    /**
     * 成员、数据来源人GridView
     */
    private GridView memberGridView, sourceMemberGrid;
    /**
     * 查看全部成员、全部数据来源人布局
     */
    private View allSourceMemberLayout, sourceLine;
    /**
     * 项目组成员个数
     */
    private TextView memberCountTxt;
    /**
     * 数据来源人个数
     */
    private TextView sourceMembersText;
    /**
     * 数据来源人布局
     */
    private View sourceMembersLayout;
    /**
     * 项目组id,组id,项目组名称
     */
    private String teamId, teamName;
    /**
     * 是否是创建者 1表示创建者  0表示普通人员
     * 是否是管理员 1表示管理员  0表示非管理员
     */
    private boolean isMyselfGroup, isAdmin;
    /**
     * 讨论组人数
     */
    private int memberNum;
    /**
     * 项目是否关闭
     */
    private boolean isCloseTeam;
    /**
     * 项目组头像
     */
    private List<String> membersHeadPic;
    /**
     * 项目设置列表适配器
     */
    private ChatManagerAdapter adapter;
    /**
     * 底部项目购买信息
     */
    private ListView footListView;
    /**
     * 班组头像
     */
    private NineGroupChatGridImageView teamHeads;
    /**
     * 项目自名称
     */
    private TextView proNameText;
    /**
     * 是否是第一次加载
     */
    private boolean isFirstLoad = true;
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
        Intent intent = new Intent(context, TeamManagerActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_BOOLEAN, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    private List<ChatManagerItem> getList() {

        ChatManagerItem menu1 = new ChatManagerItem("项目名称", !isCloseTeam, false, GroupChatManagerActivity.GROUP_NAME);
        ChatManagerItem menu2 = new ChatManagerItem("项目二维码", !isCloseTeam, false, GroupChatManagerActivity.GROUP_SCAN);
        ChatManagerItem menu3 = new ChatManagerItem("项目地址", isCloseTeam ? false : isAdmin || isMyselfGroup, true, GroupChatManagerActivity.PROJECT_ADDRESS);
        ChatManagerItem menu4 = new ChatManagerItem("我在本组的名字", !isCloseTeam, true, GroupChatManagerActivity.GROUP_IN_MY_NAME);
        ChatManagerItem menu5 = new ChatManagerItem("消息免打扰", !isCloseTeam, false, GroupChatManagerActivity.MESSAGE_INTERRUPTION);
        ChatManagerItem menu6 = new ChatManagerItem("置顶聊天", !isCloseTeam, true, GroupChatManagerActivity.MESSAGE_TOP);
        ChatManagerItem menu7 = new ChatManagerItem("清空聊天记录", !isCloseTeam, true, GroupChatManagerActivity.CLEAR_MESSAGE);

        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
        chatManagerList.add(menu4);
        chatManagerList.add(menu5);
        chatManagerList.add(menu6);
        chatManagerList.add(menu7);

        if (isMyselfGroup) { //创建者
            ChatManagerItem menu8 = new ChatManagerItem("设置管理员", !isCloseTeam, true, GroupChatManagerActivity.SETTING_MANAGEMENT_RIGHTS);
            chatManagerList.add(menu8);
        }

        menu2.setItemType(ChatManagerItem.RIGHT_IMAGE_ITEM);
        menu5.setItemType(ChatManagerItem.SWITCH_BTN);
        menu6.setItemType(ChatManagerItem.SWITCH_BTN);
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

    private void initListView() {
        if (isFirstLoad) {
            isFirstLoad = false;
            final ListView listView = (ListView) findViewById(R.id.listView);
            View memberView = getLayoutInflater().inflate(R.layout.team_info_head, null); // 数据来源人
            teamHeads = (NineGroupChatGridImageView) memberView.findViewById(R.id.teamHeads);
            proNameText = (TextView) memberView.findViewById(R.id.proName);
            sourceLine = memberView.findViewById(R.id.sourceLine);
            footListView = (ListView) getLayoutInflater().inflate(R.layout.listview_no_title, null); // 云盘提示
            allSourceMemberLayout = memberView.findViewById(R.id.allSourceMemberLayout);
            sourceMembersLayout = memberView.findViewById(R.id.sourceMembersLayout);
            memberGridView = (GridView) memberView.findViewById(R.id.memberGrid);
            sourceMemberGrid = (GridView) memberView.findViewById(R.id.sourceMemberGrid);
            memberCountTxt = (TextView) memberView.findViewById(R.id.memberCountTxt);
            sourceMembersText = (TextView) memberView.findViewById(R.id.sourceMembersText);
            memberView.findViewById(R.id.allMemberLayout).setOnClickListener(this);
            memberView.findViewById(R.id.source_layout).setOnClickListener(this); //什么是数据来源人
            ListView quitList = (ListView) getLayoutInflater().inflate(R.layout.listview_no_title, null);
            quitList.setAdapter(new QuitTeamGroupAdapter(this, getCloseItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                @Override
                public void getSingleSelcted(SingleSelected bean) {
                    switch (bean.getSelecteNumber()) {
                        case CLOSE_TEAM: //创建者-->暂时关闭项目组
                            closeGroup();
                            break;
                        case QUIT_TEAM:  //普通成员或数据来源人-->退出项目组
                            quitGroup();
                            break;
                        case REOPEN: //重新开启
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

            final List<ChatManagerItem> list = getList();
            listView.addHeaderView(memberView, null, false);
            listView.addFooterView(footListView, null, false);
            listView.addFooterView(quitList, null, false);

            adapter = new ChatManagerAdapter(this, list, this);
            adapter.setClose(isCloseTeam);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    position -= listView.getHeaderViewsCount();
                    ChatManagerItem item = list.get(position);
                    if (!item.isClick()) {
                        return;
                    }
                    if (isCloseTeam) {
                        CommonMethod.makeNoticeShort(getApplicationContext(), "项目组已关闭无法点击", CommonMethod.ERROR);
                        return;
                    }
                    switch (item.getMenuType()) {
                        case GroupChatManagerActivity.PROJECT_ADDRESS: //项目地址
                            if (isMyselfGroup || isAdmin && TextUtils.isEmpty(getItemValue(GroupChatManagerActivity.PROJECT_ADDRESS))) { //只有创建者和管理员 并且未设置地址时 才能修改项目地址
                                SelecteCityActivity.actionStart(TeamManagerActivity.this, getItemValue(GroupChatManagerActivity.GROUP_NAME), teamId, true);
                            }
                            break;
                        case GroupChatManagerActivity.GROUP_NAME: //项目组名称
                            ModifyGroupTeamInfoActivity.actionStart(TeamManagerActivity.this, teamName, teamId,
                                    WebSocketConstance.TEAM, null, ModifyGroupTeamInfoActivity.UPDATE_TEAM_NAME);
                            break;
                        case GroupChatManagerActivity.GROUP_SCAN://项目组二维码
                            TeamGroupQrCodeActivity.actionStart(TeamManagerActivity.this, teamName, teamId, WebSocketConstance.TEAM, membersHeadPic);
                            break;
                        case GroupChatManagerActivity.GROUP_IN_MY_NAME://我在本群的名称
                            ModifyGroupTeamInfoActivity.actionStart(TeamManagerActivity.this, isNickName ? item.getValue() : null,
                                    teamId, WebSocketConstance.TEAM, null, ModifyGroupTeamInfoActivity.UPDATE_IN_GROUP_MY_NAME);
                            break;
                        case GroupChatManagerActivity.SETTING_MANAGEMENT_RIGHTS://设置管理员
                            AdministratorListActivity.actionStart(TeamManagerActivity.this, memberNum, teamId);
                            break;
                        case GroupChatManagerActivity.CLEAR_MESSAGE://清空聊天信息
                            DBMsgUtil.getInstance().clearMessage(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM);
                    }
                }
            });
        }
    }


    /**
     * 获取班组信息
     */
    private void getGroupInfo() {
        MessageUtil.getGroupInfo(this, teamId, WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                GroupDiscussionInfo groupInfo = groupManager.getGroup_info();
                membersHeadPic = groupManager.getMembers_head_pic();
                teamName = groupInfo.getGroup_name();
                isAdmin = groupManager.getIs_admin() == 1;
                isNickName = groupInfo.is_nickname == 1;
                List<GroupMemberInfo> allMemberList = groupManager.getMember_list(); //成员列表数据 包含数据来源人和普通成员
                memberNum = allMemberList == null ? 0 : allMemberList.size();
                initListView();
                teamHeads.setImagesData(membersHeadPic);
                proNameText.setText(groupInfo.getGroup_name());
                //每次都同步一下头像信息
                MessageUtil.modityLocalTeamGroupInfo(TeamManagerActivity.this, null, groupInfo.getGroup_name(), null,
                        teamId, WebSocketConstance.TEAM, null, null, membersHeadPic, allMemberList == null ? "0" : allMemberList.size() + "", 0, null,
                        null, null, null);
                if (groupManager.getCurrent_server() != null && groupManager.getCurrent_server().size() > 0) {
                    footListView.setAdapter(new TeamVersionAndCloudAdapter(TeamManagerActivity.this, groupManager.getCurrent_server(), isMyselfGroup, teamId, isCloseTeam));
                }
                List<ChatManagerItem> list = adapter.getList();
                for (ChatManagerItem menu : list) { //设置选项的值
                    int menuType = menu.getMenuType();
                    switch (menuType) {
                        case GroupChatManagerActivity.GROUP_NAME://项目组名称
                            if (!isMyselfGroup && !isAdmin) {  //如果是创建者或者管理员 才能修改项目组名称
                                menu.setClick(false);
                            }
                            menu.setValue(groupInfo.getGroup_name());
                            break;
                        case GroupChatManagerActivity.SETTING_MANAGEMENT_RIGHTS: //设置管理员
                            menu.setValue(groupManager.getAdmins_num() == 0 ? "" : groupManager.getAdmins_num() + "");
                            break;
                        case GroupChatManagerActivity.GROUP_IN_MY_NAME://我在本群的名称
                            menu.setValue(groupManager.getNickname());
                            break;
                        case GroupChatManagerActivity.MESSAGE_INTERRUPTION://消息免打扰
                            menu.setSwitchState(groupManager.getIs_no_disturbed() == 0 ? false : true);
                            break;
                        case GroupChatManagerActivity.MESSAGE_TOP://置顶聊天
                            menu.setSwitchState(groupManager.getIs_sticked() == 0 ? false : true);
                            break;
                        case GroupChatManagerActivity.PROJECT_ADDRESS: //项目地址
                            menu.setValue(TextUtils.isEmpty(groupInfo.getCity_name()) && !isAdmin && !isMyselfGroup ? "未设置" : groupInfo.getCity_name());
                            if (!TextUtils.isEmpty(groupInfo.getCity_name())) {
                                setItemClickState(GroupChatManagerActivity.PROJECT_ADDRESS, false);
                            }
                            break;
                    }
                }
                final ArrayList<GroupMemberInfo> mSourceMemberList = new ArrayList<>(); //数据来源人
                for (GroupMemberInfo groupMemberInfo : allMemberList) {
                    //我自己创建的项目组,才会检测是否有数据来源人
                    if (isMyselfGroup && groupMemberInfo.getIs_source_member() == 1) {
                        mSourceMemberList.add(groupMemberInfo);
                    }
                }
                if (allMemberList != null && allMemberList.size() > 0) { //成员列表
                    //只有管理员和创建者才显示删除按钮,头像只显示一排 一排最多7个头像,如果是创建者和管理员 还需要显示删除和添加成员按钮，如果是普通成员则只显示添加按钮
                    boolean isShowDelete = isAdmin || isMyselfGroup;
                    int maxMember = isShowDelete ? 5 : 6;
                    MembersManagerAdapter proMemberAdapter = new MembersManagerAdapter(TeamManagerActivity.this, allMemberList.size() > maxMember ?
                            allMemberList.subList(0, maxMember) : allMemberList,
                            teamId, WebSocketConstance.TEAM, TeamManagerActivity.this, true);
                    proMemberAdapter.setCreator(isMyselfGroup || isAdmin);
                    proMemberAdapter.setClose(isCloseTeam);
                    memberGridView.setAdapter(proMemberAdapter);
                    memberList = allMemberList;
                }
                if (isMyselfGroup) { //如果项目未关闭 并且是创建者 才显示数据来源人列表数据
                    if (isCloseTeam && mSourceMemberList != null && mSourceMemberList.size() == 0) {
                        sourceMemberGrid.setVisibility(View.GONE);
                        allSourceMemberLayout.setVisibility(View.GONE);
                        sourceMembersLayout.setVisibility(View.GONE);
                        sourceLine.setVisibility(View.GONE);
                    } else {
                        int maxMember = 5;
                        SourceMemberAdapter sourceMemberAdatper = new SourceMemberAdapter(TeamManagerActivity.this, mSourceMemberList.size() > maxMember ?
                                mSourceMemberList.subList(0, maxMember) : mSourceMemberList, TeamManagerActivity.this, isCloseTeam);
                        sourceMemberAdatper.setSourceMemberHeadClickListener(new SourceMemberAdapter.SourceMemberHeadClick() {
                            @Override
                            public void clickSourceHead(int position) {
                                if (isCloseTeam) {
                                    CommonMethod.makeNoticeLong(getApplicationContext(), "项目组已关闭无法点击", false);
                                    return;
                                }
                                getDataSource(mSourceMemberList.get(position));
                            }
                        });
                        sourceMemberGrid.setAdapter(sourceMemberAdatper);
                        sourceMembersText.setText("数据来源人(" + mSourceMemberList.size() + ")"); //数据来源人数量
                        sourceMemberList = mSourceMemberList;
                        allSourceMemberLayout.setVisibility(mSourceMemberList.size() > maxMember ? View.VISIBLE : View.GONE);
                    }
                } else {
                    sourceMemberGrid.setVisibility(View.GONE);
                    allSourceMemberLayout.setVisibility(View.GONE);
                    sourceMembersLayout.setVisibility(View.GONE);
                    sourceLine.setVisibility(View.GONE);
                }
//                memberCountTxt.setText("(" + memberNum + "/" + groupManager.getMax_person() + ")");
                memberCountTxt.setText(memberNum + "人");
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 获取数据来源人  数据源
     *
     * @param groupMemberInfo 数据来源人信息
     */
    private void getDataSource(final GroupMemberInfo groupMemberInfo) {
        MessageUtil.getSourceMemberSource(this, teamId, WebSocketConstance.TEAM, groupMemberInfo.getUid(), new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final SourceMemberProManager sourceMemberProManager = (SourceMemberProManager) object;
                if (sourceMemberProManager != null) {
                    final DialogEditorSourcePro sourceProEditor = new DialogEditorSourcePro(TeamManagerActivity.this,
                            groupMemberInfo.getReal_name(), groupMemberInfo.getTelephone(), sourceMemberProManager);
                    sourceProEditor.setListener(new SourceMemberListener() {
                        @Override
                        public void removeSource(Project project) {//移除单个现项目组源
                            MessageUtil.removeSingleSource(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM, project.getSelf_uid(),
                                    project.getPid() + "", new CommonHttpRequest.CommonRequestCallBack() {
                                        @Override
                                        public void onSuccess(Object object) {
                                            sourceProEditor.dismiss();
                                            getDataSource(groupMemberInfo);
                                        }

                                        @Override
                                        public void onFailure(HttpException exception, String errormsg) {

                                        }
                                    });
                        }

                        @Override
                        public void requestPro() {//要求同步项目组
                            ArrayList<GroupMemberInfo> list = new ArrayList<>();
                            groupMemberInfo.setIs_demand(1);
                            list.add(groupMemberInfo);
                            MessageUtil.addSourceMember(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM, list,
                                    null, new CommonHttpRequest.CommonRequestCallBack() {
                                        @Override
                                        public void onSuccess(Object object) {
                                        }

                                        @Override
                                        public void onFailure(HttpException exception, String errormsg) {

                                        }
                                    });
                        }

                        @Override
                        public void correlation() {//关联到本组
                            DealSourceActivity.actionStart(TeamManagerActivity.this, sourceMemberProManager.getList(), teamId);
                        }

                        @Override
                        public void clickName() {//点击名称去到查看资料页面
                            if (groupMemberInfo.getIs_active() == 0) {
                                CommonMethod.makeNoticeShort(TeamManagerActivity.this, "TA还没加入吉工家，没有更多资料了", CommonMethod.ERROR);
                                return;
                            }
                            ChatUserInfoActivity.actionStart(TeamManagerActivity.this, groupMemberInfo.getUid());
                        }

                        @Override
                        public void callPhone() {
                            CallPhoneUtil.callPhone(TeamManagerActivity.this, groupMemberInfo.getTelephone());
                        }
                    });
                    sourceProEditor.show();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    @Override
    public void add(int addType) {
        if (memberNum >= 500) {
            CommonMethod.makeNoticeLong(getApplicationContext(), "项目成员人数不能超过500人", CommonMethod.ERROR);
            return;
        }
        if (addType == MessageUtil.WAY_ADD_SOURCE_MEMBER) { //添加数据来源人
            AddMemberWayActivity.actionStart(this, addType, teamId,
                    Constance.TEAM, membersHeadPic, getItemValue(GroupChatManagerActivity.GROUP_NAME), sourceMemberList, false);
        } else { //添加项目组成员
            AddMemberWayActivity.actionStart(this, addType, teamId,
                    Constance.TEAM, membersHeadPic, getItemValue(GroupChatManagerActivity.GROUP_NAME), memberList, false);
        }
    }

    @Override
    public void remove(int removeType) {
        Intent intent = new Intent(this, DeleteMemberActivity.class);
        List<GroupMemberInfo> members = null;
        if (isMyselfGroup) { //班组创建者删除成员
            if (removeType == Constance.DELETE_MEMBER) {
                members = new ArrayList<>();
                for (GroupMemberInfo groupMemberInfo : memberList) {
                    if (groupMemberInfo.getIs_source_member() == 0) { //这里只删除普通的成员,不能删除数据来源人
                        members.add(groupMemberInfo);
                    }
                }
            } else { //删除数据来源人
                members = sourceMemberList;
            }
        } else { //管理员拥有的删除权限
            if (removeType == Constance.DELETE_MEMBER) { //删除成员
                members = new ArrayList<>();
                for (GroupMemberInfo groupMemberInfo : memberList) {
                    if (groupMemberInfo.getIs_source_member() == 0 && groupMemberInfo.getIs_admin() == 0) {  //只能删除普通成员和非数据来源人
                        members.add(groupMemberInfo);
                    }
                }
            }
        }
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) members);
        intent.putExtra(Constance.DELETE_MEMBER_TYPE, removeType == Constance.DELETE_MEMBER ? Constance.DELETE_TEAM_MEMBER : Constance.DELETE_SOURCE_DATA_MEMBER);
        intent.putExtra(Constance.GROUP_ID, teamId);
        startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (resultCode) {
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加项目组成员
                getGroupInfo();
                break;
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
                getGroupInfo();
                break;
            case Constance.DELETE_TEAM_MEMBER: //删除项目组成员
                getGroupInfo();
                break;
            case Constance.DELETE_SOURCE_DATA_MEMBER: //删除数据来源人
                getGroupInfo();
                break;
            case Constance.REFRESH: //刷新列表数据
                getGroupInfo();
                break;
            case Constance.SUCCESS: //修改项目组名称、我在本组的名称
                getGroupInfo();
                break;
            case Constance.CLICK_SINGLECHAT: //点击单聊
                setResult(Constance.CLICK_SINGLECHAT, data);
                finish();
                break;
            case Constance.RESULTCODE_NEAYBYADDE: //设置项目地址
                PoiInfo poiInfo = data.getParcelableExtra(Constance.BEAN_CONSTANCE);
                if (poiInfo != null) {
                    setItemValue(GroupChatManagerActivity.PROJECT_ADDRESS, poiInfo.address);
                    setItemClickState(GroupChatManagerActivity.PROJECT_ADDRESS, false);
                    adapter.notifyDataSetChanged();
                }
                break;
            case ProductUtil.PAID_GO_TO_ORDERLIST: //支付成功回订单列表
                setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
                finish();
                break;
            case ProductUtil.PAID_GO_HOME: //支付成功回主页
                setResult(ProductUtil.PAID_GO_HOME);
                finish();
                break;
        }
    }

    @Override
    public void toggle(int menuType, final boolean toggle) {
        switch (menuType) {
            case GroupChatManagerActivity.MESSAGE_TOP: //消息置顶
                MessageUtil.modifyTeamGroupInfo(this, teamId, WebSocketConstance.TEAM, null, null, null, null, toggle ? "1" : "0", null,
                        new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(TeamManagerActivity.this, toggle ? "1" : "0", null, null, teamId, WebSocketConstance.TEAM,
                                        null, null, null, null, 0, null, null,
                                        null, null);
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
                MessageUtil.modifyTeamGroupInfo(this, teamId, WebSocketConstance.TEAM, null, null, null, toggle ? "1" : "0", null, null,
                        new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(TeamManagerActivity.this, null, null, toggle ? "1" : "0",
                                        teamId, WebSocketConstance.TEAM, null, null, null, null, 0,
                                        null, null, null, null);
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
    public static final String CLOSE_TEAM = "3";
    public static final String QUIT_TEAM = "4";
    public static final String CLOSE_GROUP_AND_DELETE = "6";

    public List<SingleSelected> getCloseItem() {
        List<SingleSelected> list = new ArrayList<>();
        if (isMyselfGroup) { //创建者
            if (isCloseTeam) { //已经关闭了项目组
                list.add(new SingleSelected("重新开启", false, false, REOPEN));
                list.add(new SingleSelected("彻底删除", false, true, THROUGHT_DELETE));
            } else {
                list.add(new SingleSelected("暂时关闭项目组", false, true, CLOSE_TEAM));
                list.add(new SingleSelected("关闭并删除项目组", false, true, CLOSE_GROUP_AND_DELETE));
            }
        } else {
            list.add(new SingleSelected("退出项目组", false, true, QUIT_TEAM));
        }
        return list;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.source_layout: //什么是数据来源人介绍
                new DialogTeamManageSourceMemberTips(this, getString(R.string.source_member_title),
                        getString(R.string.source_member_descript)).show();
                break;
            case R.id.allMemberLayout: //查看全部成员
                MemberManagerActivity.actionStart(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM, isCloseTeam, isAdmin, isMyselfGroup);
                break;
            case R.id.allSourceMemberLayout: //查看全部数据来源人
                SourceMemberManagerActivity.actionStart(this, isCloseTeam, teamId);
                break;
        }
    }


    /**
     * 初始化数据
     */
    private void initData() {
        Intent intent = getIntent();
        GroupDiscussionInfo info = (GroupDiscussionInfo) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        isMyselfGroup = UclientApplication.getUid().equals(info.getCreater_uid());
        teamId = info.getGroup_id();
        isCloseTeam = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false); //是否是关闭项目组
    }


    private void initView() {
        getTextView(R.id.title).setText(R.string.team_setting);
    }

    /**
     * 重新开启项目组
     */
    private void reOpen() {
        MessageUtil.reOpen(this, teamId, WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                MessageUtil.addTeamOrGroupToLocalDataBase(TeamManagerActivity.this, "开启成功", groupDiscussionInfo, true);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 退出项目组
     */
    private void quitGroup() {
        MessageUtil.quitGroup(this, teamId, WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "退出成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 关闭项目组
     */
    private void closeGroup() {
        MessageUtil.closeTeamGroup(this, teamId, WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "关闭成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM);
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
        MessageUtil.thoroughDeleteGroup(this, teamId, WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(TeamManagerActivity.this, teamId, WebSocketConstance.TEAM);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    public String getItemValue(int item) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == item) { //所在项目组
                return bean.getValue();
            }
        }
        return null;
    }

    public void setItemClickState(int item, boolean isClick) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == item) {
                bean.setClick(isClick);
            }
        }
    }

    public void setItemValue(int item, String value) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == item) { //所在项目组
                bean.setValue(value);
            }
        }
    }


    @Override
    public void onFinish(View view) {
        Intent intent = getIntent();
        intent.putExtra(Constance.GROUP_NAME, getItemValue(GroupChatManagerActivity.GROUP_NAME));
        setResult(Constance.SET_PRO_NAME, intent);
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        Intent intent = getIntent();
        intent.putExtra(Constance.GROUP_NAME, getItemValue(GroupChatManagerActivity.GROUP_NAME));
        setResult(Constance.SET_PRO_NAME, intent);
        super.onBackPressed();
    }
}
