package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.adpter.MembersManagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

import static com.jizhi.jlongg.main.activity.GroupChatManagerActivity.MESSAGE_INTERRUPTION;
import static com.jizhi.jlongg.main.activity.GroupChatManagerActivity.MESSAGE_TOP;


/**
 * CName:单聊管理
 * User: xuj
 * Date: 2016-12-26
 * Time: 11:45:59
 */
public class SingleChatManagerActivity extends BaseActivity implements ChatManagerAdapter.SwithBtnListener, AddMemberListener {

    /**
     * 成员列表GridView
     */
    private GridView gridView;
    /**
     * 成员列表适配器
     */
    private ChatManagerAdapter adapter;
    /**
     * 单聊id
     */
    private String singleChatId;
    /**
     * 成员信息
     */
    private List<GroupMemberInfo> members;
    /**
     * 修改了成员昵称
     */
    private boolean MsgActIsFlush;
    /**
     * 修改了成员的昵称和uid
     */
    private String change_real_name, change_uid;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initData();
        initView();
        getSingChatInfo();
    }

    /**
     * 获取聊天信息设置
     */
    private void getSingChatInfo() {
        MessageUtil.getGroupInfo(this, singleChatId, WebSocketConstance.SINGLECHAT, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                List<GroupMemberInfo> members = groupManager.getMember_list();
                List<ChatManagerItem> list = adapter.getList();
                for (ChatManagerItem menu : list) {
                    switch (menu.getMenuType()) {
                        case MESSAGE_INTERRUPTION://消息免打扰
                            menu.setSwitchState(groupManager.getIs_no_disturbed() == 0 ? false : true);
                            break;
                        case MESSAGE_TOP://置顶聊天
                            menu.setSwitchState(groupManager.getIs_sticked() == 0 ? false : true);
                            break;
                    }
                }
                if (members != null && members.size() > 0) { //群聊成员
                    MembersManagerAdapter membersAdapter = new MembersManagerAdapter(SingleChatManagerActivity.this, members, null, WebSocketConstance.SINGLECHAT,
                            SingleChatManagerActivity.this, false);
                    gridView.setAdapter(membersAdapter);
                }
                adapter.notifyDataSetChanged();
                SingleChatManagerActivity.this.members = members;
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    private void initData() {
        Intent intent = getIntent();
        singleChatId = intent.getStringExtra(Constance.GROUP_CHAT_ID);
    }


    private void initView() {
        setTextTitle(R.string.group_message);
        final ListView listView = (ListView) findViewById(R.id.listView);
        View memberView = getLayoutInflater().inflate(R.layout.item_group_chat_head, null); // 通讯录默认

        memberView.findViewById(R.id.allMemberLayout).setVisibility(View.GONE);
        memberView.findViewById(R.id.memberLine).setVisibility(View.GONE);
        memberView.findViewById(R.id.team_head_layout).setVisibility(View.GONE);
        gridView = (GridView) memberView.findViewById(R.id.gridView);
        final List<ChatManagerItem> list = getList();
        listView.addHeaderView(memberView, null, false);
        adapter = new ChatManagerAdapter(this, list, this);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                ChatManagerItem item = list.get(position - listView.getHeaderViewsCount());
                if (!item.isClick()) {
                    return;
                }
                switch (item.getMenuType()) {
                    case GroupChatManagerActivity.CLEAR_MESSAGE://清空聊天信息
                        DBMsgUtil.getInstance().clearMessage(SingleChatManagerActivity.this, singleChatId, WebSocketConstance.SINGLECHAT);
                        break;
                }
            }
        });
    }

    /**
     * 获取单聊列表
     *
     * @return
     */
    private List<ChatManagerItem> getList() {
        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        String uid = UclientApplication.getUid(getApplicationContext());
        if (!TextUtils.isEmpty(singleChatId) && !TextUtils.isEmpty(uid) && !singleChatId.equals(uid)) { //如果是和自己聊天 则不需要显示消息免打扰
            ChatManagerItem menu1 = new ChatManagerItem("消息免打扰", true, false, MESSAGE_INTERRUPTION);
            chatManagerList.add(menu1);
            menu1.setItemType(ChatManagerItem.SWITCH_BTN);
        }
        ChatManagerItem menu2 = new ChatManagerItem("置顶聊天", true, true, MESSAGE_TOP);
        ChatManagerItem menu3 = new ChatManagerItem("清空聊天记录", true, true, GroupChatManagerActivity.CLEAR_MESSAGE);
        chatManagerList.add(menu2);
        chatManagerList.add(menu3);
        menu2.setItemType(ChatManagerItem.SWITCH_BTN);
        return chatManagerList;
    }

    @Override
    public void toggle(int menuType, final boolean toggle) {
        switch (menuType) {
            case GroupChatManagerActivity.MESSAGE_TOP: //消息置顶
                MessageUtil.modifyTeamGroupInfo(this, singleChatId, WebSocketConstance.SINGLECHAT, null, null, null, null,
                        toggle ? "1" : "0", null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(SingleChatManagerActivity.this, toggle ? "1" : "0", null, null, singleChatId,
                                        WebSocketConstance.SINGLECHAT, null, null, null, null, 0, null,
                                        null, null, null);
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
                MessageUtil.modifyTeamGroupInfo(this, singleChatId, WebSocketConstance.SINGLECHAT, null, null, null, toggle ? "1" : "0", null,
                        null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(SingleChatManagerActivity.this, null, null, toggle ? "1" : "0", singleChatId,
                                        WebSocketConstance.SINGLECHAT, null, null, null, null, 0, null,
                                        null, null, null);
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

    @Override
    public void add(int state) { //发起群聊
        if (members == null || members.size() == 0) {
            return;
        }
        String uid = members.get(0).getUid();
        String telephone = members.get(0).getTelephone();
        InitiateGroupChatActivity.actionStart(this, MessageUtil.WAY_CREATE_GROUP_CHAT,
                WebSocketConstance.SINGLECHAT, singleChatId, false, telephone + ","
                        + UclientApplication.getTelephone(getApplicationContext()), null, null, uid);
    }


    @Override
    public void remove(int state) {
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) { //点击群聊信息
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //点击单聊信息
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == Constance.FLUSH_NICKNAME) { //修改了名字
            MsgActIsFlush = true;
            change_real_name = data.getStringExtra(Constance.COMMENT_NAME);
            change_uid = data.getStringExtra(Constance.UID);
            setResult(Constance.FLUSH_NICKNAME, data);
            getSingChatInfo();
        } else {
            getSingChatInfo();
        }
//        else if (resultCode == Constance.SUCCESS) { //修改了备注名称
//            Intent intent = getIntent();
//            String commentName = intent.getStringExtra(Constance.COMMENT_NAME);
//            if (!TextUtils.isEmpty(commentName)) {
//                intent.putExtra(Constance.COMMENT_NAME, commentName); //设置备注名称，让聊天页可以修改名称
//                intent.putExtra(Constance.BEAN_STRING, WebSocketConstance.SINGLECHAT);
//                setResult(Constance.SUCCESS, intent);
//                if (members != null && members.size() > 0) { //修改刚刚已改好的备注
//                    members.get(0).setReal_name(commentName);
//                    adapter.notifyDataSetChanged();
//                }
//            }
//        }
    }


    @Override
    public void onFinish(View view) {
        if (MsgActIsFlush) {
            Intent intent = new Intent();
            intent.putExtra(Constance.COMMENT_NAME, change_real_name);
            intent.putExtra(Constance.UID, change_uid);
            setResult(Constance.FLUSH_NICKNAME, intent);
        }
        super.onFinish(view);


    }

    @Override
    public void onBackPressed() {
        if (MsgActIsFlush) {
            Intent intent = new Intent();
            intent.putExtra(Constance.COMMENT_NAME, change_real_name);
            intent.putExtra(Constance.UID, change_uid);
            setResult(Constance.FLUSH_NICKNAME, intent);
        }
        super.onBackPressed();
    }
}
