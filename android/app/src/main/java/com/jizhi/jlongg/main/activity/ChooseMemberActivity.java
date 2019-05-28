package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ChooseMemberListAdapter;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:选择成员
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class ChooseMemberActivity extends BaseActivity implements View.OnClickListener, AdapterView.OnItemClickListener {
    /**
     * 底部按钮
     */
    private Button joinChatBtn;
    /**
     * 聊天成员适配器
     */
    private MemberRecyclerViewAdapter horizontalAdapter;
    /**
     * 通讯录适配器
     */
    private ChooseMemberListAdapter adapter;
    /**
     * 已选中的成员数量
     */
    private int selectSize;
    /**
     * 项目组信息
     */
    private GroupMemberInfo groupInfo;
    /**
     * 项目组是否全选按钮
     */
    private ImageView groupSelectImage;
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 搜索框输入的文件
     */
    private String matchString;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 项目组View
     */
    private View headView;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText;
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
     * @param context
     * @param chooseMemberType public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 1; //班组、项目组、群聊添加成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 2; //班组、项目组、群聊添加记账成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 3; //班组、项目组、群聊查看成员
     *                         public static final int WAY_CREATE_GROUP_CHAT = 4; //创建群聊
     * @param groupId          组id(如果只是查看列表成员或者是添加记账对象可以不传)
     * @param classType        组类型(如果只是查看列表成员或者是添加记账对象可以不传)
     * @param groupMemberInfos 成员列表信息
     * @param groupName        项目组名称
     */
    public static void actionStart(Activity context, int chooseMemberType, String groupName, String groupId, String classType,
                                   ArrayList<GroupMemberInfo> groupMemberInfos) {
        Intent intent = new Intent(context, ChooseMemberActivity.class);
        intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, chooseMemberType);
        intent.putExtra(Constance.BEAN_CONSTANCE, groupMemberInfos);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.initiate_group_chat);
        initView();
    }

    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
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
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(ChooseMemberActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(ChooseMemberActivity.class.getName()));

                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                            int headCount = listView.getHeaderViewsCount();
                            if (TextUtils.isEmpty(mMatchString)) {
                                if (headCount == 0) {
                                    listView.addHeaderView(headView, null, false);
                                }
                            } else {
                                if (headCount > 0) {
                                    listView.removeHeaderView(headView);
                                }
                            }
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

    private void btnUnClick() {
        switch (memberListType) {
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                joinChatBtn.setText("进入群聊");
                break;
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
            case MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON:
                joinChatBtn.setText("确定");
                break;
        }
        joinChatBtn.setClickable(false);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        switch (memberListType) {
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                joinChatBtn.setText(String.format(getString(R.string.join_groupchat_count), selectSize));
                break;
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
            case MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON:
                joinChatBtn.setText(String.format(getString(R.string.confirm_add_member_count), selectSize));
                break;
        }
        joinChatBtn.setClickable(true);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    /**
     * 初始化View
     */
    private void initView() {
        Intent intent = getIntent();
        list = (List<GroupMemberInfo>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE); //项目组成员列表信息
        listView = (ListView) findViewById(R.id.listView);
        boolean isShowSelecteIcon = false;
        memberListType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        switch (memberListType) {
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER: //查看成员
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER: //记单笔-->从班组、项目组、群聊添加记账成员
                setTextTitle(R.string.search_member);
                findViewById(R.id.recyclerviewLayout).setVisibility(View.GONE); //横向滚动的布局
                break;
            case MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON://借支增加“一天记多人”（只有从班组内的“借支/结算”进入借支界面，才有此功能）
                isShowSelecteIcon = true;
                setTextTitle(R.string.selecte_member);
                if (list != null && list.size() > 0) {
                    joinChatBtn = getButton(R.id.redBtn);
                    initRecyleListView();
                    btnUnClick();
                }
                break;
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //班组、项目组、群聊添加成员
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER://新建班组时从项目选择成员(选择单人)
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
                isShowSelecteIcon = true;
                setTextTitle(R.string.choose_member);
                if (list != null && list.size() > 0) {
                    joinChatBtn = getButton(R.id.redBtn);
                    initRecyleListView();
                    btnUnClick();
                }
                break;
        }
        defaultText = getTextView(R.id.defaultDesc);
        defaultText.setText(SearchEditextHanlderResult.getDefaultResultString(this.getClass().getName()));
        if (list != null && list.size() > 0) {
            TextView centerText = getTextView(R.id.center_text); //当前正在搜索的英文字母
            SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //侧边搜索框
            sideBar.setTextView(centerText);
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
            setAdapter(list, isShowSelecteIcon);
            initSeatchEdit();
        } else {
            findViewById(R.id.input_layout).setVisibility(View.GONE);
            findViewById(R.id.searchLine).setVisibility(View.GONE);
            findViewById(R.id.recyclerviewLayout).setVisibility(View.GONE);
            setAdapter(null, false);
        }
    }


    private void initRecyleListView() {
        RecyclerView mRecyclerView = (RecyclerView) findViewById(R.id.recyclerview);//横向滚动View
        WrapLinearLayoutManager linearLayoutManager = new WrapLinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());// 设置item动画
        horizontalAdapter = new MemberRecyclerViewAdapter(this);
        mRecyclerView.setAdapter(horizontalAdapter);
        horizontalAdapter.setOnItemClickLitener(new MemberRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                selectSize -= 1;
                if (selectSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                if (position < 0) {
                    position = 0;
                }
                horizontalAdapter.getSelectList().get(position).setSelected(false);
                horizontalAdapter.removeDataByPosition(position);
                adapter.notifyDataSetChanged();
                groupInfo.setSelected(false);
                groupSelectImage.setImageResource(R.drawable.checkbox_normal);
            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //添加成员、发起群聊按钮
                switch (memberListType) {
                    case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
                        addTeamGroupMember();
                        break;
                    case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
                        createGroupChat();
                        break;
                    case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组添加成员从项目选择
                    case MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON://借支增加“一天记多人”（只有从班组内的“借支/结算”进入借支界面，才有此功能）
                        Intent intent = getIntent();
                        ArrayList<GroupMemberInfo> memberInfos = (ArrayList<GroupMemberInfo>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
                        if (memberInfos == null) {
                            memberInfos = new ArrayList<>();
                        }
                        for (GroupMemberInfo info : adapter.getList()) {
                            if (info.isSelected()) {
                                memberInfos.add(info);
                            }
                        }
                        intent.putExtra(Constance.BEAN_ARRAY, memberInfos);
                        setResultParameter();
                        break;
                    case MessageUtil.WAY_ADD_SOURCE_MEMBER: //项目组添加数据来源人
                        addSourceMember();
                        break;
                }
                break;
        }
    }

    /**
     * 添加数据来源人
     */
    private void addSourceMember() {
        ArrayList<GroupMemberInfo> selectMemberList = new ArrayList<>();
        for (GroupMemberInfo info : list) {
            if (info.isSelected()) {
                selectMemberList.add(info);
            }
        }
        if (selectMemberList.size() == 0) {
            return;
        }
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        MessageUtil.addSourceMember(ChooseMemberActivity.this, groupId, WebSocketConstance.TEAM, selectMemberList, null, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Intent intent = getIntent();
                setResult(intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_ADD_SOURCE_MEMBER), intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    private void setAdapter(List<GroupMemberInfo> list, boolean isShowSelectIcon) {
        Utils.setPinYinAndSort(list);
        if (adapter == null) {
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.addHeaderView(initTeamInfo(), null, false);
            boolean showBottomDesc = false;//是否显示列表底部 文本描述
            switch (memberListType) {
                case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
//                case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
//                case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
                    showBottomDesc = true;
                    break;
            }
            String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
            String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
            adapter = new ChooseMemberListAdapter(this, list, isShowSelectIcon, showBottomDesc, groupId, classType);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(this);
        } else {
            adapter.updateListView(list);
        }
    }

    /**
     * 初始化讨论组头信息
     *
     * @return
     */
    private View initTeamInfo() {
        groupInfo = new GroupMemberInfo();
        groupInfo.setGroup_name(getIntent().getStringExtra(Constance.GROUP_NAME));
        headView = getLayoutInflater().inflate(R.layout.item_head_choose_member, null);
        TextView groupNameText = (TextView) headView.findViewById(R.id.groupName);
        groupSelectImage = (ImageView) headView.findViewById(R.id.seletedImage);
        switch (memberListType) {
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER: //查看成员
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER: //添加记账成员
                groupNameText.setText(Html.fromHtml("<font color='#333333'>" + groupInfo.getGroup_name() + "</font><font color='#999999'>(" + (list == null ? 0 : list.size()) + ")</font>"));
                headView.setClickable(false);
                groupSelectImage.setVisibility(View.GONE);
                break;
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组时从项目选择成员
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //添加成员
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //创建群聊，选择成员
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
            case MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON://借支增加“一天记多人”（只有从班组内的“借支/结算”进入借支界面，才有此功能）
                groupSelectImage.setVisibility(View.VISIBLE);
                groupNameText.setText(Html.fromHtml("<font color='#333333'>" + groupInfo.getGroup_name() + "</font>"));
                headView.setOnClickListener(new View.OnClickListener() { //设置取消全选和全选的事件
                    @Override
                    public void onClick(View v) {
                        boolean isSelect = !groupInfo.isSelected();
                        groupInfo.setSelected(isSelect);
                        groupSelectImage.setImageResource(isSelect ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                        ArrayList<GroupMemberInfo> groupMemberInfos = new ArrayList<>();
                        for (GroupMemberInfo info : list) {
                            if (info.isClickable()) { //只选择未添加的成员
                                groupMemberInfos.add(info);
                                info.setSelected(isSelect);
                            }
                        }
                        horizontalAdapter.setSelectList(isSelect ? groupMemberInfos : null);
                        selectSize = isSelect ? groupMemberInfos.size() : 0;
                        if (selectSize > 0) {
                            btnClick();
                        } else {
                            btnUnClick();
                        }
                        adapter.notifyDataSetChanged();
                        hideSoftKeyboard();
                    }
                });
                break;
        }
        return headView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        GroupMemberInfo bean = adapter.getList().get(position - listView.getHeaderViewsCount());
        if (!bean.isClickable()) {
            return;
        }
        switch (memberListType) {
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER: //查看成员
                if (bean.getIs_active() == 0) { //当前用户未注册
                    CommonMethod.makeNoticeShort(getApplicationContext(), "TA还没加入吉工家，没有更多资料了", CommonMethod.ERROR);
                    return;
                }
                ChatUserInfoActivity.actionStart(this, bean.getUid()); //进入 个人资料页面
                break;
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER: //记单笔-->添加记账成员
                CommonHttpRequest.addAccountPerson(ChooseMemberActivity.this, bean.getReal_name(), bean.getTelephone(), false, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        Intent intent = getIntent();
                        intent.putExtra(Constance.BEAN_CONSTANCE, (PersonBean) object);
                        setResultParameter();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
                break;
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建班组时从项目选择成员
            case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //班组、项目组、群聊添加成员
            case MessageUtil.WAY_CREATE_GROUP_CHAT: //发起群聊
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加数据来源人
            case MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON: //借支增加“一天记多人”（只有从班组内的“借支/结算”进入借支界面，才有此功能）
                bean.setSelected(!bean.isSelected());
                selectSize = bean.isSelected() ? selectSize + 1 : selectSize - 1;
                adapter.notifyDataSetChanged();
                if (selectSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                groupInfo.setSelected(selectSize == list.size() ? true : false);
                groupSelectImage.setImageResource(groupInfo.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                if (bean.isSelected()) {
                    horizontalAdapter.addData(bean);
                } else {
                    horizontalAdapter.removeDataByTelephone(bean.getTelephone());
                }
//            mRecyclerView.smoothScrollToPosition(horizontalAdapter.getSelectList().size() == 0 ? 0 : horizontalAdapter.getSelectList().size() - 1);
                hideSoftKeyboard();
                break;
        }
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
                MessageUtil.addTeamOrGroupToLocalDataBase(ChooseMemberActivity.this, null, groupDiscussionInfo, true);
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
     * 添加班组、项目组、群聊成员
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
                setResultParameter();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    private void setResultParameter() {
        Intent intent = getIntent();
        setResult(intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER), intent);
        finish();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //支付成功查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //支付成功返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }
}
