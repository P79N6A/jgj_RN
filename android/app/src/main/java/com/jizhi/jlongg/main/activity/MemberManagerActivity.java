package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.widget.GridView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.MembersManagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * CName:成员数量管理
 * User: xuj
 * Date: 2016-12-26
 * Time: 2016-12-26 17:16:51
 */
public class MemberManagerActivity extends BaseActivity implements com.jizhi.jlongg.listener.AddMemberListener {
    /**
     * 成员数据
     */
    private List<GroupMemberInfo> memberList;
    /**
     * 项目组头像
     */
    private List<String> membersHeadPicList;
    /**
     * 成员适配器
     */
    private MembersManagerAdapter membersAdapter;
    /**
     * 导航栏标题
     */
    private TextView title;
    /**
     * 是否是管理员
     */
    private boolean isAdmin;
    /**
     * 是否是创建者
     */
    private boolean isCreator;
    /**
     * 当前筛选框文字
     */
    private String matchString;
    /**
     * 成员数量、是否是高级版、购买人数、项目是否已过期、是否可以降级
     */
    private int memberNum;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText;
    /**
     * 组名称
     */
    private String groupName;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupId, String classType, boolean isClose, boolean isAdmin, boolean isCreator) {
        Intent intent = new Intent(context, MemberManagerActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.IS_CLOSED, isClose);
        intent.putExtra(Constance.IS_ADMIN, isAdmin);
        intent.putExtra(Constance.IS_CREATOR, isCreator);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.all_members);
        initView();
        getGroupInfo();
    }

    private void initView() {
        title = (TextView) findViewById(R.id.title);
        isCreator = getIntent().getBooleanExtra(Constance.IS_CREATOR, false);
        isAdmin = getIntent().getBooleanExtra(Constance.IS_ADMIN, false);
        defaultText = getTextView(R.id.defaultDesc);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        mClearEditText.setHint("请输入名字进行查找");
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }

    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (membersAdapter == null || memberList == null || memberList.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, memberList, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(MemberManagerActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(MemberManagerActivity.class.getName()));
                            membersAdapter.setFilterValue(mMatchString);
                            membersAdapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    @Override
    public void add(int addType) {
        Intent intent = getIntent();
        final String groupId = intent.getStringExtra(Constance.GROUP_ID);
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        switch (classType) {
            case WebSocketConstance.TEAM: //项目组
                if (memberNum >= 500) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "项目成员人数不能超过500人", CommonMethod.ERROR);
                    return;
                }
                AddMemberWayActivity.actionStart(this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER, groupId, classType, membersHeadPicList,
                        groupName, memberList, false); //添加成员
                break;
            case WebSocketConstance.GROUP: //班组
                AddMemberWayActivity.actionStart(this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER, groupId, classType, membersHeadPicList,
                        groupName, memberList, false); //添加成员
                break;
            case WebSocketConstance.GROUP_CHAT://群聊
                InitiateGroupChatActivity.actionStart(this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER,
                        WebSocketConstance.GROUP_CHAT, groupId, false, getExistPhone(), membersHeadPicList, groupName, null);
                break;
        }
    }

    private String getExistPhone() {
        if (memberList != null && memberList.size() > 0) {
            StringBuilder builder = new StringBuilder();
            builder.append(UclientApplication.getTelephone(getApplicationContext())); //将自己给排除掉
            for (GroupMemberInfo groupMemberInfo : memberList) {
                builder.append("," + groupMemberInfo.getTelephone());
            }
            return builder.toString();
        } else {
            return UclientApplication.getTelephone(getApplicationContext());
        }
    }

    @Override
    public void remove(int removeType) {
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        Intent intent = new Intent(this, DeleteMemberActivity.class);
        switch (classType) {
            case WebSocketConstance.TEAM: //项目组
                List<GroupMemberInfo> members = null;
                if (isCreator) { //创建者
                    members = membersAdapter.getList();
                } else {//管理员 需要排除其他管理员
                    for (GroupMemberInfo info : membersAdapter.getList()) {
                        if (members == null) {
                            members = new ArrayList<>();
                        }
                        if (info.getIs_admin() == 0 && info.getIs_source_member() == 0) { //只能删除普通成员和非数据来源人
                            members.add(info);
                        }
                    }
                }
                intent.putExtra(Constance.BEAN_ARRAY, (Serializable) members);
                intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_TEAM_MEMBER);
                break;
            case WebSocketConstance.GROUP: //班组
                intent.putExtra(Constance.BEAN_ARRAY, (Serializable) membersAdapter.getList());
                intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER);
                break;
            case WebSocketConstance.GROUP_CHAT://群聊
                intent.putExtra(Constance.BEAN_ARRAY, (Serializable) membersAdapter.getList());
                intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_CHAT_MEMBER);
                break;
        }
        intent.putExtra(Constance.GROUP_ID, groupId);
        startActivityForResult(intent, Constance.REQUEST);
    }

    private void setGroupMemberInfo(GroupManager groupManager) {
        List<GroupMemberInfo> groupMemberInfos = groupManager.getMember_list();
        if (groupMemberInfos != null && groupMemberInfos.size() > 0) { //群聊成员
            String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
            switch (classType) {
                case WebSocketConstance.GROUP_CHAT:
                    title.setText(String.format(getString(R.string.group_num), groupMemberInfos.size()));
                    groupName = groupManager.getGroup_info().getGroup_name();
                    break;
                case WebSocketConstance.GROUP:
                    title.setText(String.format(getString(R.string.memebers_num), groupMemberInfos.size()));
                    groupName = groupManager.getGroup_info().getPro_name() + "-" + groupManager.getGroup_info().getGroup_name();
                    break;
                case WebSocketConstance.TEAM:
                    memberNum = groupManager.getMembers_num(); //项目成员数量
                    title.setText(String.format(getString(R.string.memebers_num), groupManager.getMembers_num()));
                    groupName = groupManager.getGroup_info().getGroup_name();
                    break;
            }
            //班组 代班长
            boolean isProxyer = false;
            if (classType.equals(WebSocketConstance.GROUP)) {
                for (GroupMemberInfo groupMemberInfo : groupMemberInfos) {
                    if (groupMemberInfo.getIs_agency() == 1 && UclientApplication.getUid(getApplicationContext()).equals(groupMemberInfo.getUid())) { //代班长标识
                        isProxyer = true;
                        break;
                    }
                }
            }
            if (membersAdapter == null) {
                GridView gridView = (GridView) findViewById(R.id.gridView);
                gridView.setEmptyView(findViewById(R.id.defaultLayout));
                membersAdapter = new MembersManagerAdapter(MemberManagerActivity.this, groupMemberInfos,
                        getIntent().getStringExtra(Constance.GROUP_ID), classType, MemberManagerActivity.this, false);
                membersAdapter.setCreator(isProxyer || isAdmin || isCreator);
                membersAdapter.setClose(getIntent().getBooleanExtra(Constance.IS_CLOSED, false));
                gridView.setAdapter(membersAdapter);
            } else {
                membersAdapter.updateListView(groupMemberInfos);
            }
        }
        membersHeadPicList = groupManager.getMembers_head_pic();
        memberList = groupMemberInfos;
    }


    /**
     * 获取班组信息
     */
    private void getGroupInfo() {
        Intent intent = getIntent();
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        MessageUtil.getGroupInfo(this, groupId, classType, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                setGroupMemberInfo(groupManager);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER ||
                resultCode == Constance.DELETE_GROUP_CHAT_MEMBER ||
                resultCode == Constance.DELETE_MEMBER ||
                resultCode == Constance.DELETE_TEAM_MEMBER ||
                resultCode == Constance.DELETE_GROUP_MEMBER) { //如果添加成员、或者删除了人员就刷新列表
            setResult(resultCode);
            getGroupInfo();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_GROUP_CHAT) {
            setResult(Constance.CLICK_GROUP_CHAT, data);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }
}
