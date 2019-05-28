package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ChooseTeamAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:选择群聊、项目
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class ChooseTeamActivity extends BaseActivity {
    /**
     * listView
     */
    private ListView listView;
    /**
     * 列表适配器
     */
    private ChooseTeamAdapter adapter;
    /**
     * 1、项目  2、群聊  3、添加记账对象
     */
    private int showType;
    /**
     * 列表数据
     */
    private List<GroupDiscussionInfo> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 当本地没有数据的时候，需要加载一次服务器数据
     */
    private boolean loadOnceServerData;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText;


    /**
     * @param context
     * @param showGroupType    1、表示只显示项目，班组   2、表示查询群聊
     * @param groupId          组id(只有添加成员的时候需要传)
     * @param classType        组类型(只有添加成员的时候需要传)
     * @param chooseMemberType MessageUtils
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 0X1; 班组、项目组、群聊添加成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 0X2; 记单笔-->从班组、项目组、群聊添加记账成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 0X3; 班组、项目组、群聊查看成员
     *                         public static final int WAY_CREATE_GROUP_CHAT = 0X14; 创建群聊、班组、项目组
     *                         public static final int WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER = 0X5; 新建班组时从项目选择成员
     *                         public static final int WAY_ADD_SOURCE_MEMBER = 0X101; 添加数据来源人
     * @param existTelphons    已有的成员电话号码 用逗号隔开 ,排除相同电话号码
     */
    public static void actionStart(Activity context, int showGroupType, String groupId, String classType, String existTelphons, int chooseMemberType) {
        Intent intent = new Intent(context, ChooseTeamActivity.class);
        intent.putExtra("show_group_type", showGroupType);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, chooseMemberType);
        intent.putExtra(Constance.EXIST_TELPHONES, existTelphons);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contact_choose_team);
        initView();
        registerReceiver();
        loadLocalDataBaseData();
    }


    /**
     * 加载本地数据库数据
     */
    private void loadLocalDataBaseData() {
        //litepal 加载 数据库已存好的班组、项目组数据
        ArrayList<GroupDiscussionInfo> groupDiscussionList = null;
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        if (showType == MessageUtil.TYPE_GROUP_AND_TEAM) { //查询班组、项目组
            groupDiscussionList = MessageUtil.getLocalGroupTeam(false, groupId, classType);
        } else if (showType == MessageUtil.TYPE_GROUP_CHAT) { //查询群聊组
            groupDiscussionList = MessageUtil.getLocalGroupChat(groupId, classType);
        }
        if (groupDiscussionList == null || groupDiscussionList.size() == 0) { //如果第一次加载本地没有数据,则去加载一次服务器获取数据
            if (!loadOnceServerData) {
                loadOnceServerData = true;
                MessageUtil.getChatListData(ChooseTeamActivity.this, false);
            } else {
                setAdapter(null);
            }
            return;
        }
        setAdapter(groupDiscussionList);
    }


    /**
     * 初始化View
     */
    private void initView() {
        Intent intent = getIntent();
        listView = (ListView) findViewById(R.id.listView);
        showType = intent.getIntExtra("show_group_type", MessageUtil.TYPE_GROUP_AND_TEAM);
        defaultText = (TextView) findViewById(R.id.defaultDesc);
        defaultText.setText(showType == MessageUtil.TYPE_GROUP_AND_TEAM ? "你暂时没有加入任何项目\n不能从项目添加成员" : "你暂时还没有加入任何群聊");
        initSeatchEdit();
    }

    /**
     * 初始化搜索框
     */
    private void initSeatchEdit() {
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        if (showType == MessageUtil.TYPE_GROUP_AND_TEAM) {
            setTextTitle(R.string.choose_work_circle);
            mClearEditText.setHint("请输入项目名字查找");
        } else if (showType == MessageUtil.TYPE_GROUP_CHAT) { //群聊 隐藏搜索框
            setTextTitle(R.string.choose_team);
            mClearEditText.setHint("请输入群名称查找");
        }
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
     * 根据输入框中的值来过滤数据并更新ListView
     *
     * @param mMatchString
     */
    private void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<GroupDiscussionInfo> filterDataList = SearchMatchingUtil.match(GroupDiscussionInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(ChooseTeamActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(ChooseTeamActivity.class.getName()));
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    private void setAdapter(List<GroupDiscussionInfo> list) {
        this.list = list;
        if (TextUtils.isEmpty(matchString)) {
            findViewById(R.id.input_layout).setVisibility(list == null || list.size() == 0 ? View.GONE : View.VISIBLE);
        }
        if (adapter == null) {
            boolean showMemberNumber = false;
            switch (getIntent().getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER)) {
                case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER: //查看成员
                case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER: //添加记账成员
                    showMemberNumber = true;
                    break;
            }
            adapter = new ChooseTeamAdapter(this, list, showMemberNumber, showType);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { //listView 点击事件
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    position = position - listView.getHeaderViewsCount();
                    Intent intent = getIntent();
                    switch (showType) {
                        case MessageUtil.TYPE_GROUP_CHAT://如果是选择群聊直接进入聊天页
                            intent.putExtra(Constance.BEAN_CONSTANCE, adapter.getList().get(position));
                            setResult(Constance.CLICK_GROUP_CHAT, intent);
                            finish();
                            break;
                        case MessageUtil.TYPE_GROUP_AND_TEAM: //班组、项目组
                            if (getIntent().getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER) == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER) {
                                intent.putExtra(Constance.BEAN_CONSTANCE, adapter.getList().get(position));
                                setResult(Constance.CLICK_GROUP_CHAT, intent);
                                finish();
                            } else {
                                GroupDiscussionInfo groupDiscussionInfo = adapter.getList().get(position);
                                getMembers(groupDiscussionInfo.getGroup_name(), groupDiscussionInfo.getClass_type(), groupDiscussionInfo.getGroup_id());
                            }
                            break;
                    }
                }
            });
        } else {
            adapter.updateListView(list);
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER
                || resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER
                || resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER
                || resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT
                || resultCode == MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER
                || resultCode == MessageUtil.WAY_ADD_SOURCE_MEMBER
                ) { //从项目添加人员成功
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊
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

    /**
     * 获取项目组、班组成员列表
     *
     * @param groupName 班组、项目组名称
     * @param classType 组类型
     * @param groupId   组id
     */
    private void getMembers(final String groupName, final String classType, final String groupId) {
        final Intent intent = getIntent();
        MessageUtil.getGroupMembers(this, groupId, classType, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> serverList = (ArrayList<GroupMemberInfo>) object;
                if (serverList != null && serverList.size() > 0) {
                    int memberListType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                    String addMemberGroupId = intent.getStringExtra(Constance.GROUP_ID);
                    String addMemberClassType = intent.getStringExtra(Constance.CLASSTYPE);
                    removeExistTelphoneUser(getIntent().getStringExtra(Constance.EXIST_TELPHONES), serverList);
                    if (WebSocketConstance.GROUP_CHAT.equals(addMemberClassType) || memberListType == MessageUtil.WAY_CREATE_GROUP_CHAT) { //如果是群聊的添加成员需要排除未注册的成员
                        removeUnRegisterMember(serverList);
                    }
                    ChooseMemberActivity.actionStart(ChooseTeamActivity.this, memberListType, groupName, addMemberGroupId, addMemberClassType, serverList);
                } else {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "该项目中没有更多的成员可添加", CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 比较服务器聊聊对象和班组、项目组已添加的对象,移除已添加的对象
     *
     * @param serverList
     */
    private void removeExistTelphoneUser(String existTelphone, ArrayList<GroupMemberInfo> serverList) {
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
     * 排除未注册的成员
     *
     * @param serverList
     */
    private void removeUnRegisterMember(List<GroupMemberInfo> serverList) {
        if (serverList == null || serverList.size() == 0) {
            return;
        }
        int size = serverList.size();
        for (int i = 0; i < size; i++) {
            if (serverList.get(i).getIs_active() == 0) {
                serverList.remove(i);
                removeUnRegisterMember(serverList);
                return;
            }
        }
    }


    /**
     * 注册广播
     */
    public void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.LOAD_CHAT_LIST);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.LOAD_CHAT_LIST)) { //加载列表数据成功后的回调
                loadLocalDataBaseData();
            }
        }
    }
}
