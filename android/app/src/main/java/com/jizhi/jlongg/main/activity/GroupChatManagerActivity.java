package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.adpter.MembersManagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
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
 * CName:讨论组管理
 * User: xuj
 * Date: 2016-12-26
 * Time: 11:45:59
 */
public class GroupChatManagerActivity extends BaseActivity implements ChatManagerAdapter.SwithBtnListener, AddMemberListener {


    /**
     * 项目组
     */
    public static final int GROUP_NAME = 1; //项目组名称
    public static final int GROUP_SCAN = 2; //项目组二维码
    public static final int GROUP_IN_MY_NAME = 3; //我在本群的名称
    public static final int MESSAGE_INTERRUPTION = 4;//消息免打扰
    public static final int MESSAGE_TOP = 5; //置顶聊天
    public static final int SETTING_MANAGEMENT_RIGHTS = 6; //设置管理员
    public static final int PROJECT_ADDRESS = 7; //项目地址
    /**
     * 班组
     */
    public static final int BELONG_PRO = 8; //所属项目
    public static final int GROUP_PLACE = 9; //班组地点
    public static final int SET_REPLACE_FOREMAN = 10; //设置代班长
    /**
     * 群聊
     */
    public static final int CLEAR_MESSAGE = 11; //清空聊天记录
    public static final int UPGRADED = 12; //升级为：工作中的班组
    public static final int TRANSFER_MANAGEMENT_RIGHTS = 13; //转让管理权


    private GridView gridView;
    /**
     * 列表管理适配器
     */
    private ChatManagerAdapter adapter;
    /**
     * 群聊id
     */
    private String groupChatId;
    /**
     * 是否是我创建的群聊
     */
    private boolean isAdmin;
    /**
     * 群聊名称
     */
    private TextView groupChatName;
    /**
     * 所有成员的数据
     */
    private List<GroupMemberInfo> allTheMemberList;
    /**
     * 项目组头像
     */
    private List<String> membersHeadPicList;
    /**
     * 群聊名称
     */
    private TextView groupNameText;
    /**
     * 项目组成员个数
     */
    private TextView memberCountTxt;
    /**
     * 群聊头像
     */
    private NineGroupChatGridImageView teamHeads;
    /**
     * 是否已设置我在本组的名称
     */
    private boolean isNickName;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initData();
        initView();
        getGroupInfo();
    }


    /**
     * 获取班组信息
     */
    private void getGroupInfo() {
        MessageUtil.getGroupInfo(this, groupChatId, WebSocketConstance.GROUP_CHAT, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                GroupDiscussionInfo groupInfo = groupManager.getGroup_info();
                membersHeadPicList = groupManager.getMembers_head_pic();
                isNickName = groupInfo.is_nickname == 1;
                List<GroupMemberInfo> members = groupManager.getMember_list();
                //每次都同步一下头像信息
                MessageUtil.modityLocalTeamGroupInfo(GroupChatManagerActivity.this, null, groupInfo.getGroup_name(), null,
                        groupChatId, WebSocketConstance.GROUP_CHAT, null, null, membersHeadPicList, members == null ? "0" : members.size() + "", 0,
                        null, null, null, null);
                isAdmin = groupManager.getIs_admin() == 1 ? true : false;
                teamHeads.setImagesData(membersHeadPicList);
                groupNameText.setText(groupInfo.getGroup_name());
                List<ChatManagerItem> itemList = null;
                if (adapter == null) {
                    itemList = getList();
                    adapter = new ChatManagerAdapter(GroupChatManagerActivity.this, itemList, GroupChatManagerActivity.this);
                    final ListView listView = (ListView) findViewById(R.id.listView);
                    listView.setAdapter(adapter);
                    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                            position -= listView.getHeaderViewsCount();
                            ChatManagerItem item = adapter.getList().get(position);
                            if (!item.isClick()) { //如果不能点击则直接跳出
                                return;
                            }
                            switch (item.getMenuType()) {
                                case GROUP_NAME://群聊名称
                                    if (!isAdmin) { //只有管理员才能操作这些选项
                                        return;
                                    }
                                    ModifyGroupTeamInfoActivity.actionStart(GroupChatManagerActivity.this, item.getValue(), groupChatId,
                                            WebSocketConstance.GROUP_CHAT, null, ModifyGroupTeamInfoActivity.UPDATE_GROUPCHAT_NAME);
                                    break;
                                case GROUP_SCAN://二维码
                                    TeamGroupQrCodeActivity.actionStart(GroupChatManagerActivity.this, getItemValue(GROUP_NAME), groupChatId, WebSocketConstance.GROUP_CHAT, membersHeadPicList);
                                    break;
                                case GROUP_IN_MY_NAME://我在本群的名称
                                    ModifyGroupTeamInfoActivity.actionStart(GroupChatManagerActivity.this, isNickName ? item.getValue() : null,
                                            groupChatId, WebSocketConstance.GROUP_CHAT, null, ModifyGroupTeamInfoActivity.UPDATE_IN_GROUP_MY_NAME);
                                    break;
                                case UPGRADED://升级为：工作中的班组
                                    UpgradeActivity.actionStart(GroupChatManagerActivity.this, getItemValue(GROUP_NAME), groupChatId, allTheMemberList);
                                    break;
                                case TRANSFER_MANAGEMENT_RIGHTS://转让管理权
                                    SwitchManagerActivity.actionStart(GroupChatManagerActivity.this, allTheMemberList, groupChatId);
                                    break;
                                case GroupChatManagerActivity.CLEAR_MESSAGE://清空聊天信息
                                    DBMsgUtil.getInstance().clearMessage(GroupChatManagerActivity.this, groupChatId, WebSocketConstance.GROUP_CHAT);
                                    break;
                            }
                        }
                    });
                } else {
                    itemList = adapter.getList();
                }
                for (ChatManagerItem menu : itemList) {
                    int menuType = menu.getMenuType();
                    switch (menuType) {
                        case GROUP_NAME://群聊名称
                            menu.setValue(groupInfo.getGroup_name());
                            menu.setClick(isAdmin);
                            break;
                        case GROUP_IN_MY_NAME://我在本群的名称
                            menu.setValue(groupManager.getNickname());
                            break;
                        case MESSAGE_INTERRUPTION://消息免打扰
                            menu.setSwitchState(groupManager.getIs_no_disturbed() == 0 ? false : true);
                            break;
                        case MESSAGE_TOP://置顶聊天
                            menu.setSwitchState(groupManager.getIs_sticked() == 0 ? false : true);
                            break;
                    }
                }
                if (members != null && members.size() > 0) { //群聊成员
                    allTheMemberList = members;
                    //只有管理员和创建者才显示删除按钮,头像只显示一排 一排最多7个头像,如果是创建者和管理员 还需要显示删除和添加成员按钮，如果是普通成员则只显示添加按钮
                    groupChatName.setText(String.format(getString(R.string.group_chat_members_num), members.size()));
                    int maxMember = isAdmin ? 5 : 6;
                    MembersManagerAdapter membersAdapter = new MembersManagerAdapter(GroupChatManagerActivity.this, members.size() > maxMember ?
                            members.subList(0, maxMember) : members,
                            groupChatId, WebSocketConstance.GROUP_CHAT, GroupChatManagerActivity.this, true);
                    membersAdapter.setCreator(isAdmin);
                    gridView.setAdapter(membersAdapter);
                }
                memberCountTxt.setText(groupManager.getMembers_num() + "人");
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    private void initData() {
        Intent intent = getIntent();
        groupChatId = intent.getStringExtra(Constance.GROUP_CHAT_ID);
    }


    private void initView() {
        groupChatName = (TextView) findViewById(R.id.title);
        final ListView listView = (ListView) findViewById(R.id.listView);
        View memberView = getLayoutInflater().inflate(R.layout.item_group_chat_head, null); //成员列表
        View deleteBtn = getLayoutInflater().inflate(R.layout.item_button_chat_manager, null); // 删除群聊布局
        teamHeads = memberView.findViewById(R.id.teamHeads);
        groupNameText = memberView.findViewById(R.id.groupName);
        memberCountTxt = memberView.findViewById(R.id.memberCountTxt);
        memberView.findViewById(R.id.allMemberLayout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MemberManagerActivity.actionStart(GroupChatManagerActivity.this, groupChatId, WebSocketConstance.GROUP_CHAT, false, isAdmin, false);
            }
        });
        deleteBtn.findViewById(R.id.btn_delete).setOnClickListener(new View.OnClickListener() { //删除按钮
            @Override
            public void onClick(View v) { //删除群聊
                if (isAdmin) { //创建者
                    MessageUtil.quitGroup(GroupChatManagerActivity.this, groupChatId, WebSocketConstance.GROUP_CHAT, new CommonHttpRequest.CommonRequestCallBack() {
                        @Override
                        public void onSuccess(Object object) {
                            DBMsgUtil.getInstance().deleteMessage(GroupChatManagerActivity.this, groupChatId, WebSocketConstance.GROUP_CHAT);
                            setResult(Constance.GO_MAIN_ACTIVITY);
                            finish();
                        }

                        @Override
                        public void onFailure(HttpException exception, String errormsg) {

                        }
                    });
                } else { //普通成员
                    MessageUtil.quitGroup(GroupChatManagerActivity.this, groupChatId, WebSocketConstance.GROUP_CHAT, new CommonHttpRequest.CommonRequestCallBack() {
                        @Override
                        public void onSuccess(Object object) {
                            DBMsgUtil.getInstance().deleteMessage(GroupChatManagerActivity.this, groupChatId, WebSocketConstance.GROUP_CHAT);
                            setResult(Constance.GO_MAIN_ACTIVITY);
                            finish();
                        }

                        @Override
                        public void onFailure(HttpException exception, String errormsg) {

                        }
                    });
                }
            }
        });
        listView.addHeaderView(memberView, null, false);
        listView.addFooterView(deleteBtn, null, false);
        gridView = (GridView) memberView.findViewById(R.id.gridView);
    }


    private List<ChatManagerItem> getList() {
        ChatManagerItem menu1 = new ChatManagerItem("群聊名称", isAdmin, false, GROUP_NAME);
        ChatManagerItem menu2 = new ChatManagerItem("群二维码", true, true, GROUP_SCAN);
        ChatManagerItem menu3 = new ChatManagerItem("我在本群的名字", true, true, GROUP_IN_MY_NAME);
        ChatManagerItem menu4 = new ChatManagerItem("消息免打扰", true, false, MESSAGE_INTERRUPTION);
        ChatManagerItem menu5 = new ChatManagerItem("置顶聊天", true, true, MESSAGE_TOP);
        ChatManagerItem menu6 = new ChatManagerItem("清空聊天记录", true, true, CLEAR_MESSAGE);

        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
        chatManagerList.add(menu4);
        chatManagerList.add(menu5);
        chatManagerList.add(menu6);

        if (isAdmin) { //自己创建的群聊
            ChatManagerItem menu7 = new ChatManagerItem("升级为班组", true, false, UPGRADED, getString(R.string.upgrade_group_tips));
            ChatManagerItem menu8 = new ChatManagerItem("转让管理权 ", true, true, TRANSFER_MANAGEMENT_RIGHTS);
            chatManagerList.add(menu7);
            chatManagerList.add(menu8);
        }
        menu2.setItemType(ChatManagerItem.RIGHT_IMAGE_ITEM);
        menu4.setItemType(ChatManagerItem.SWITCH_BTN);
        menu5.setItemType(ChatManagerItem.SWITCH_BTN);
        return chatManagerList;
    }

    @Override
    public void toggle(int menuType, final boolean toggle) {
        switch (menuType) {
            case MESSAGE_TOP: //消息置顶
                MessageUtil.modifyTeamGroupInfo(this, groupChatId, WebSocketConstance.GROUP_CHAT, null, null, null, null,
                        toggle ? "1" : "0", null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(GroupChatManagerActivity.this, toggle ? "1" : "0", null, null,
                                        groupChatId, WebSocketConstance.GROUP_CHAT, null, null, null, null,
                                        0, null, null, null, null);
                                for (ChatManagerItem item : adapter.getList()) {
                                    if (item.getMenuType() == MESSAGE_TOP) {
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
            case MESSAGE_INTERRUPTION: //消息免打扰
                MessageUtil.modifyTeamGroupInfo(this, groupChatId, WebSocketConstance.GROUP_CHAT, null, null, null, toggle ? "1" : "0", null,
                        null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(GroupChatManagerActivity.this, null, null, toggle ? "1" : "0",
                                        groupChatId, WebSocketConstance.GROUP_CHAT, null, null, null, null,
                                        0, null, null, null, null);
                                for (ChatManagerItem item : adapter.getList()) {
                                    if (item.getMenuType() == MESSAGE_INTERRUPTION) {
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

    private String getExistPhone() {
        if (allTheMemberList != null && allTheMemberList.size() > 0) {
            StringBuilder builder = new StringBuilder();
            builder.append(UclientApplication.getTelephone(getApplicationContext())); //将自己给排除掉
            for (GroupMemberInfo groupMemberInfo : allTheMemberList) {
                builder.append("," + groupMemberInfo.getTelephone());
            }
            return builder.toString();
        } else {
            return UclientApplication.getTelephone(getApplicationContext());
        }
    }


    @Override
    public void add(int addType) { //添加成员
        InitiateGroupChatActivity.actionStart(this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER,
                WebSocketConstance.GROUP_CHAT, groupChatId, false, getExistPhone(), membersHeadPicList, getItemValue(GROUP_NAME), null);
    }

    @Override
    public void remove(int state) { //删除成员
        Intent intent = new Intent(this, DeleteMemberActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) allTheMemberList);
        intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_CHAT_MEMBER);
        intent.putExtra(Constance.GROUP_ID, groupChatId);
        startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST) { //添加班组对象回调
            switch (resultCode) {
                case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加项目组成员
                    getGroupInfo();
                    break;
                case Constance.REFRESH:
                    getGroupInfo();
                    break;
                case Constance.DELETE_GROUP_CHAT_MEMBER: //删除成员
                    getGroupInfo();
                    break;
                case Constance.SUCCESS: //修改我在项目中的名称
                    getGroupInfo();
                    break;
                case Constance.SWITCH_MANAMGER: //转让管理权
                    isAdmin = false; //我自己不再是管理员
                    adapter.setList(getList());
                    getGroupInfo();
                    break;
                case Constance.UPGRADE: //升级为班组
                    setResult(resultCode, data);
                    finish();
                    break;
                case Constance.CLICK_SINGLECHAT: //点击单聊信息
                    setResult(Constance.CLICK_SINGLECHAT, data);
                    finish();
                    break;
                case Constance.FIND_WORKER_CALLBACK: //点击群聊信息
                    setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
                    finish();
                    break;
            }
        }
    }


    public String getItemValue(int item) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == item) { //所在项目
                return bean.getValue();
            }
        }
        return null;
    }
}
