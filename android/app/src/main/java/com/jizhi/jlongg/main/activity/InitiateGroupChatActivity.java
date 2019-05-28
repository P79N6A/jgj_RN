package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * CName:发起群聊或者添加成员
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class InitiateGroupChatActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 加入群聊按钮
     */
    private Button joinChatBtn;
    /**
     * 聊天成员适配器
     */
    private MemberRecyclerViewAdapter horizontalAdapter;
    /**
     * 当通讯录没有数据时，展示的布局
     */
    private View contactDefaultLayout;
    /**
     * listView列表
     */
    private ListView listView;
    /**
     * 通讯录适配器
     */
    private CommonPersonListAdapter adapter;
    /**
     * 当前选中的成员数量
     */
    private int selectMemberSize;
    /**
     * 横向滚动头像
     */
    private RecyclerView mRecyclerView;
    /**
     * 字母搜索框
     */
    private SideBar sideBar;
    /**
     *
     */
    private List<GroupMemberInfo> list;
    /**
     * 搜索时的输入框
     */
    private String matchString;
    /**
     * MessageUtils
     * public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 0X1; 班组、项目组、群聊添加成员
     * public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 0X2; 记单笔-->从班组、项目组、群聊添加记账成员
     * public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 0X3; 班组、项目组、群聊查看成员
     * public static final int WAY_CREATE_GROUP_CHAT = 0X14; 创建群聊、班组、项目组
     * public static final int WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER = 0X5; 新建班组时从项目选择成员
     * public static final int WAY_ADD_SOURCE_MEMBER = 0X101; 添加数据来源人
     */
    private int memberListType;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param chooseMemberType MessageUtils
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 0X1; 班组、项目组、群聊添加成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 0X2; 记单笔-->从班组、项目组、群聊添加记账成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 0X3; 班组、项目组、群聊查看成员
     *                         public static final int WAY_CREATE_GROUP_CHAT = 0X14; 创建群聊、班组、项目组
     *                         public static final int WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER = 0X5; 新建班组时从项目选择成员
     *                         public static final int WAY_ADD_SOURCE_MEMBER = 0X101; 添加数据来源人
     * @param groupId          组id(只有添加成员的时候需要传)
     * @param classType        组类型(只有添加成员的时候需要传)
     * @param isFromBatch
     * @param existTelphone    已存在的列表数据
     * @param mermbersHead     成员头像(主要是扫码添加群聊成员的时候使用,可以不传)
     * @param groupName        (主要是添加群聊成员的时候使用,可以不传)
     * @param uid              当从单聊设置里面发起群聊的时需要使用到的参数,创建群聊时则需要加上当前单聊人的ID
     */
    public static void actionStart(Activity context, int chooseMemberType, String classType, String groupId,
                                   boolean isFromBatch, String existTelphone, List<String> mermbersHead, String groupName, String uid) {
        Intent intent = new Intent(context, InitiateGroupChatActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, chooseMemberType);
        intent.putExtra(Constance.IS_FROM_BATCH, isFromBatch);
        intent.putExtra(Constance.EXIST_TELPHONES, existTelphone);
        intent.putExtra(Constance.GROUP_HEAD_IMAGE, (Serializable) mermbersHead);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.UID, uid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.initiate_group_chat);
        initView();
        getChatFriendsData();
    }

    private void initView() {
        memberListType = getIntent().getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        joinChatBtn = getButton(R.id.redBtn);
        TextView center_text = getTextView(R.id.center_text);
        sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        sideBar.setTextView(center_text);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (adapter != null) {
                    //该字母首次出现的位置
                    int position = adapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
        initListView();
        initRecyleListView();
    }

    private void btnUnClick() {
        switch (memberListType) {
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                joinChatBtn.setText("进入群聊");
                break;
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组
                joinChatBtn.setText("确定");
                break;
        }
        joinChatBtn.setClickable(false);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        switch (memberListType) {
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                joinChatBtn.setText(String.format(getString(R.string.join_groupchat_count), selectMemberSize));
                break;
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组
                joinChatBtn.setText(String.format(getString(R.string.confirm_add_member_count), selectMemberSize));
                break;
        }
        joinChatBtn.setClickable(true);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    private void initListView() {
        Intent intent = getIntent();
        int memberListType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        switch (memberListType) {
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //发起群聊
                setTextTitle(R.string.addMember);
                break;
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                setTextTitle(R.string.initiate_group_chat);
                break;
        }
        String classType = intent.getStringExtra(Constance.CLASSTYPE); //组的类型 可选的值有 group、team、groupChat、singleChat
        final View contactHeadView = getLayoutInflater().inflate(R.layout.choose_groupchat_head, null); // 通讯录头部
        contactDefaultLayout = getLayoutInflater().inflate(R.layout.contact_default, null); // 通讯录默认
        listView = (ListView) findViewById(R.id.listView);
        View searchLayout = findViewById(R.id.input_layout); //隐藏搜索框
        View searchLine = findViewById(R.id.searchLine);
        if (!TextUtils.isEmpty(classType)) {
            if (classType.equals(WebSocketConstance.GROUP_CHAT) || classType.equals(WebSocketConstance.SINGLECHAT)) {
                TextView defaultText = (TextView) contactDefaultLayout.findViewById(R.id.defaultText);
                TextView fromWorkCreate = (TextView) contactHeadView.findViewById(R.id.fromWorkCreate);
                defaultText.setText("你的通讯录中暂时没有更多的联系人可添加");
                fromWorkCreate.setText("从项目选择添加");
                contactHeadView.findViewById(R.id.selecteExistGroupLayout).setVisibility(View.GONE); //现有群布局
                contactHeadView.findViewById(R.id.faceToFaceCreateTeamLayout).setVisibility(View.GONE); //面对面建群布局
                switch (classType) {
                    case WebSocketConstance.GROUP_CHAT: //群聊
                        contactHeadView.findViewById(R.id.invinteHimLayout).setVisibility(View.VISIBLE); //邀他扫描二维码加入
                        break;
                    case WebSocketConstance.SINGLECHAT: //单聊
                        searchLine.setVisibility(View.GONE);
                        searchLayout.setVisibility(View.GONE);
                        contactHeadView.findViewById(R.id.invinteHimLayout).setVisibility(View.GONE); //邀他扫描二维码加入
                        break;
                }
                listView.addHeaderView(contactHeadView, null, false);
            }
        } else {
            listView.addHeaderView(contactHeadView, null, false);
            searchLine.setVisibility(View.GONE);
            searchLayout.setVisibility(View.GONE);
        }
        listView.addFooterView(contactDefaultLayout, null, false);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position = position - listView.getHeaderViewsCount();
                GroupMemberInfo bean = adapter.getList().get(position);
                if (!bean.isClickable()) {
                    return;
                }
                bean.setSelected(!bean.isSelected());
                selectMemberSize = bean.isSelected() ? selectMemberSize + 1 : selectMemberSize - 1;
                adapter.notifyDataSetChanged();
                if (selectMemberSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                if (bean.isSelected()) {
                    horizontalAdapter.addData(bean);
                } else {
                    horizontalAdapter.removeDataByTelephone(bean.getTelephone());
                }
            }
        });
        listView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
            @Override
            public void onGlobalLayout() {
                //动态计算默认页的高度
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                calculateDefaultHeight(listView, contactHeadView.getHeight());
                if (Build.VERSION.SDK_INT < 16) {
                    listView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    listView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
        btnUnClick();
        setAdapter(null);
        initSeatchEdit();
    }

    /**
     * 根据输入框中的值来过滤数据并更新ListView
     *
     * @param mMatchString 筛选文字
     */
    private void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 初始化搜索框
     */
    private void initSeatchEdit() {
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入名字或手机号码查找");
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
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
     * 计算默认页 高度
     *
     * @param listView
     * @param contactHeadViewHeight 头部高度
     */
    private void calculateDefaultHeight(ListView listView, int contactHeadViewHeight) {
        int listViewHeight = listView.getHeight();
        View layout = contactDefaultLayout.findViewById(R.id.contentLayout);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) layout.getLayoutParams();
        params.height = listViewHeight - contactHeadViewHeight - DensityUtils.dp2px(this, 7);
        layout.setLayoutParams(params);
    }

    private void initRecyleListView() {
        mRecyclerView = (RecyclerView) findViewById(R.id.recyclerview);
        WrapLinearLayoutManager linearLayoutManager = new WrapLinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
        // 设置item动画
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());
        horizontalAdapter = new MemberRecyclerViewAdapter(this);
        mRecyclerView.setAdapter(horizontalAdapter);
        horizontalAdapter.setOnItemClickLitener(new MemberRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                GroupMemberInfo groupMemberInfo = horizontalAdapter.getSelectList().get(position);
                selectMemberSize -= 1;
                if (selectMemberSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                if (position < 0) {
                    position = 0;
                }
                groupMemberInfo.setSelected(false);
                horizontalAdapter.removeDataByPosition(position);
                adapter.notifyDataSetChanged();
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //加入群聊按钮
                switch (memberListType) {
                    case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
                        addTeamGroupMember();
                        break;
                    case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                        createGroupChat();
                        break;
                    case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组添加成员从项目选择
                        Intent intent = getIntent();
                        ArrayList<GroupMemberInfo> memberInfos = new ArrayList<>();
                        for (GroupMemberInfo info : adapter.getList()) {
                            if (info.isSelected()) {
                                memberInfos.add(info);
                            }
                        }
                        intent.putExtra(Constance.BEAN_ARRAY, memberInfos);
                        setResult(MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER, intent);
                        finish();
                        break;
                }
                break;
            case R.id.selecteExistGroupLayout: //选择现有群
                ChooseTeamActivity.actionStart(this, MessageUtil.TYPE_GROUP_CHAT, null, null, null,
                        MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER);
                break;
            case R.id.workCircleCreateTeamLayout: //项目建群
                String existTelphone = getIntent().getStringExtra(Constance.EXIST_TELPHONES);
                ChooseTeamActivity.actionStart(this, MessageUtil.TYPE_GROUP_AND_TEAM, getIntent().getStringExtra(Constance.GROUP_ID), getIntent().getStringExtra(Constance.CLASSTYPE),
                        !TextUtils.isEmpty(existTelphone) ? existTelphone : UclientApplication.getTelephone(getApplicationContext()),
                        memberListType);
                break;
            case R.id.faceToFaceCreateTeamLayout: //面对面建群
                FaceToFaceCreateTeamActivity.actionStart(this);
                break;
            case R.id.invinteHimLayout://邀他扫描二维码加入
                String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
                String groupName = getIntent().getStringExtra(Constance.GROUP_NAME);
                String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
                List<String> memberHeads = (List<String>) getIntent().getSerializableExtra(Constance.GROUP_HEAD_IMAGE);
                TeamGroupQrCodeActivity.actionStart(InitiateGroupChatActivity.this, groupName, groupId, classType, memberHeads);
                break;
        }
    }

    /**
     * 获取好友列表
     */
    private void getChatFriendsData() {
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        MessageUtil.getFriendList(this, groupId, classType, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> serverList = (ArrayList<GroupMemberInfo>) object;
                removeExistTelphoneUser(getIntent().getStringExtra(Constance.EXIST_TELPHONES), serverList);
                setAdapter(serverList);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 添加成员
     */
    private void addTeamGroupMember() {
        ArrayList<GroupMemberInfo> selectMemberList = new ArrayList<>();
        for (GroupMemberInfo info : list) {
            if (info.isSelected()) {
                selectMemberList.add(info);
            }
        }
        if (selectMemberList.size() == 0) {
            return;
        }
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        MessageUtil.addMembers(this, groupId, classType, selectMemberList, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                setResult(MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 创建群聊
     */
    private void createGroupChat() {
        StringBuilder builder = new StringBuilder();
        for (GroupMemberInfo info : adapter.getList()) {
            if (info.isSelected()) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? info.getUid() : "," + info.getUid());
            }
        }
        if (!TextUtils.isEmpty(getIntent().getStringExtra(Constance.UID))) { //如果是从单聊界面跳转进来 则需要加上当前单聊人的ID
            builder.append("," + getIntent().getStringExtra(Constance.UID));
        }
        MessageUtil.createGroupChat(this, builder.toString(), null, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                //我们将新创建的班组存储在数据库中
                MessageUtil.addTeamOrGroupToLocalDataBase(InitiateGroupChatActivity.this, null, groupDiscussionInfo, true);
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, groupDiscussionInfo);
                setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 移除项目组、班组、群聊中已存在的群成员
     *
     * @param existTelphone 已存在的电话号码
     * @param serverList
     */
    private void removeExistTelphoneUser(String existTelphone, List<GroupMemberInfo> serverList) {
        if (TextUtils.isEmpty(existTelphone) || serverList == null || serverList.size() == 0) {
            return;
        }
        int size = serverList.size();
        for (int i = 0; i < size; i++) {
            if (existTelphone.contains(serverList.get(i).getTelephone())) {
                serverList.get(i).setClickable(false);
//                serverList.remove(i);
//                removeExistTelphoneUser(existTelphone, serverList);
//                return;
            }
        }
    }

    /**
     * 设置ListView 适配器
     *
     * @param list
     */
    private void setAdapter(List<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        InitiateGroupChatActivity.this.list = list;
        if (adapter == null) {
            adapter = new CommonPersonListAdapter(this, list, true);
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);
        }
        int footCount = listView.getFooterViewsCount();
        if (list != null && list.size() > 0) {
            if (footCount > 0) {
                listView.removeFooterView(contactDefaultLayout);
            }
            sideBar.setVisibility(View.VISIBLE);
        } else {
            if (footCount == 0) {
                listView.addFooterView(contactDefaultLayout, null, false);
            }
            sideBar.setVisibility(View.GONE);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER
                || resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT
                || resultCode == MessageUtil.WAY_ADD_SOURCE_MEMBER
                ) { //从项目添加人员成功
            setResult(resultCode, data);
            finish();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) { //创建群聊
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_GROUP_CHAT) { //点击群聊信息
            setResult(Constance.CLICK_GROUP_CHAT, data);
            finish();
        }
    }

}
