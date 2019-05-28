//package com.jizhi.jlongg.main.activity;
//
//import android.Manifest;
//import android.app.Activity;
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//import android.content.pm.PackageManager;
//import android.os.Build;
//import android.os.Bundle;
//import android.support.annotation.NonNull;
//import android.support.v4.app.ActivityCompat;
//import android.support.v4.content.ContextCompat;
//import android.text.Editable;
//import android.text.Html;
//import android.text.InputFilter;
//import android.text.TextUtils;
//import android.text.TextWatcher;
//import android.view.View;
//import android.widget.AdapterView;
//import android.widget.ListView;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//
//import com.hcs.cityslist.widget.ClearEditText;
//import com.hcs.cityslist.widget.SideBar;
//import com.hcs.uclient.utils.ReadAddressBook;
//import com.hcs.uclient.utils.Utils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
//import com.jizhi.jlongg.main.application.UclientApplication;
//import com.jizhi.jlongg.main.bean.AddressBook;
//import com.jizhi.jlongg.main.bean.BaseRequestParameter;
//import com.jizhi.jlongg.main.bean.GroupManager;
//import com.jizhi.jlongg.main.bean.GroupMemberInfo;
//import com.jizhi.jlongg.main.util.CommonMethod;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.PinYin2Abbreviation;
//import com.jizhi.jlongg.main.util.ProductUtil;
//import com.jizhi.jlongg.main.util.SearchMatchingUtil;
//import com.jizhi.jlongg.main.util.WebSocket;
//import com.jizhi.jlongg.main.util.WebSocketConstance;
//
//import java.io.Serializable;
//import java.util.ArrayList;
//import java.util.List;
//
///**
// * 功能:从通讯录添加班组、项目组成员
// * 时间:2016年8月23日 17:41:01
// * 作者:xuj
// */
//public class FromContactAddTeamGroupMemberActivity extends BaseActivity implements View.OnClickListener {
//
//    /**
//     * 当前已选人数
//     */
//    private int selectSize;
//    /**
//     * 已选人员数量
//     */
//    private TextView personCount;
//    /**
//     * 当勾选添加的人数大于1时展示 否则隐藏
//     */
//    private RelativeLayout bottomLayout;
//    /**
//     * 成员列表适配器
//     */
//    private CommonPersonListAdapter adapter;
//    /**
//     * 列表数据
//     */
//    private List<GroupMemberInfo> list = new ArrayList<>();
//    /**
//     * 当前筛选框文字
//     */
//    private String matchString;
//    /**
//     * listView
//     */
//    private ListView listView;
//
//
//    /**
//     * 启动当前Acitivty
//     *
//     * @param context
//     * @param addType    Constance.ADD_MEMBER 添加成员
//     * @param groupId    项目组id
//     * @param memberList 成员列表
//     */
//    public static void actionStart(Activity context, int addType, String groupId, String classType, int memberNum, int isSenior, int buyerPerson,
//                                   List<GroupMemberInfo> memberList, boolean isFromBatch) {
//        Intent intent = new Intent(context, FromContactAddTeamGroupMemberActivity.class);
//        intent.putExtra(Constance.GROUP_ID, groupId);
//        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) memberList);
//        intent.putExtra(Constance.CLASSTYPE, classType);
//        intent.putExtra(Constance.ADD_MEMBER_TYPE, addType);
//        intent.putExtra(Constance.TEAM_MEMBER_NUMBER, memberNum); //项目成员数量
//        intent.putExtra(Constance.GET_PRO_VERSION, isSenior); //项目版本
//        intent.putExtra(Constance.GET_PRO_BUYER, buyerPerson); //项目已购人数
//        intent.putExtra(Constance.IS_FROM_BATCH, isFromBatch);
//        context.startActivityForResult(intent, Constance.REQUEST);
//    }
//
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.work_circle_add_member);
//        initView();
//        registerReceiver();
//        if (Build.VERSION.SDK_INT >= 23) {
//            requestPermission();
//        } else {
//            compareContact();
//        }
//    }
//
//
//
//    /**
//     * 检测权限之后的回调
//     *
//     * @param requestCode
//     * @param permissions
//     * @param grantResults
//     */
//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//        switch (requestCode) {
//            case Constance.CHECKSELFPERMISSION:
//                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {//用户同意授权
//                    compareContact();
//                } else {//用户拒绝授权
//                    finish();
//                }
//                break;
//        }
//    }
//
//
//    /**
//     * 初始化
//     */
//    public void initView() {
//        setTextTitle(R.string.addMember);
//        listView = (ListView) findViewById(R.id.listView);
//        personCount = getTextView(R.id.person_count);
//        bottomLayout = (RelativeLayout) findViewById(R.id.bottom_layout);
//        TextView confirmAdd = (TextView) findViewById(R.id.confirm_add);
//        TextView centerText = getTextView(R.id.center_text);
//        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
//        confirmAdd.setText("确认添加");
//        sideBar.setTextView(centerText);
//        // 设置右侧触摸监听
//        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
//            @Override
//            public void onTouchingLetterChanged(String s) {
//                if (adapter != null) {
//                    //该字母首次出现的位置
//                    int position = adapter.getPositionForSection(s.charAt(0));
//                    if (position != -1) {
//                        listView.setSelection(position);
//                    }
//                }
//            }
//        });
//        initSeatchEdit();
//    }
//
//    /**
//     * 初始化搜索框
//     */
//    private void initSeatchEdit() {
//        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
//        mClearEditText.setHint("请输入名字或手机号码查找");
//        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
//        // 根据输入框输入值的改变来过滤搜索
//        mClearEditText.addTextChangedListener(new TextWatcher() {
//            @Override
//            public void onTextChanged(CharSequence s, int start, int before, int count) {
//                filterData(s.toString());
//            }
//
//            @Override
//            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
//            }
//
//            @Override
//            public void afterTextChanged(Editable s) {
//            }
//        });
//    }
//
//    /**
//     * 搜索框 筛选数据
//     *
//     * @param mMatchString
//     */
//    private synchronized void filterData(final String mMatchString) {
//        if (adapter == null || list == null || list.size() == 0) {
//            return;
//        }
//        matchString = mMatchString;
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
//                if (mMatchString.equals(matchString)) {
//                    runOnUiThread(new Runnable() {
//                        @Override
//                        public void run() {
//                            adapter.setFilterValue(mMatchString);
//                            adapter.updateListView(filterDataList);
//                        }
//                    });
//                }
//            }
//        }).start();
//    }
//
//
//    @Override
//    public void onClick(View v) {
//        switch (v.getId()) {
//            case R.id.confirm_add: //添加成员
//                Intent intent = getIntent();
//                int addType = intent.getIntExtra(Constance.ADD_MEMBER_TYPE, Constance.ADD_MEMBER);
//                ArrayList<GroupMemberInfo> selectedList = new ArrayList<>();
//                for (GroupMemberInfo bean : list) {
//                    if (addType == Constance.CREATE_PRO_ADD_MEMBER) { //新建项目时候添加班组成员
//                        if (bean.isSelected() || !bean.isClickable()) {
//                            selectedList.add(bean);
//                        }
//                    } else {
//                        if (bean.isSelected()) {
//                            selectedList.add(bean);
//                        }
//                    }
//                }
//                if (selectedList.size() == 0) {
//                    return;
//                }
//                int buyerPerson = intent.getIntExtra(Constance.GET_PRO_BUYER, 0); //获取已购买的人数
//                int memberNum = intent.getIntExtra(Constance.TEAM_MEMBER_NUMBER, 0); //获取成员数量
//                int isSenior = intent.getIntExtra(Constance.GET_PRO_VERSION, 0); //获取系统版本
//                String classType = intent.getStringExtra(Constance.CLASSTYPE);
//                String groupId = intent.getStringExtra(Constance.GROUP_ID);
//                if (classType.equals(WebSocketConstance.TEAM)) { //只有添加项目组成员才判断是否过期
//                    if (ProductUtil.checkAddPersonPermission(this, isSenior, memberNum, selectedList.size(), buyerPerson, getIntent().getStringExtra(Constance.GROUP_ID))) {
//                        return;
//                    }
//                }
//                switch (addType) {
//                    case Constance.ADD_MEMBER: //项目组、班组添加成员
//                        if (classType.equals(WebSocketConstance.TEAM)) { //添加项目组成员
//                        } else { //添加班组成员
//                        }
//                        break;
//                    case Constance.CREATE_PRO_ADD_MEMBER://新建项目时候添加班组成员
//                        intent.putExtra(Constance.BEAN_ARRAY, selectedList);
//                        setResult(Constance.ADD_MEMBER, intent);
//                        finish();
//                        break;
//                }
//        }
//    }
//
//
//    /**
//     * 比较通讯录如果相同号码的数据不可点击
//     */
//    public void compareContact() {
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                Intent intent = getIntent();
//                //获取上个Acitivty 带过来的成员列表信息
//                final List<GroupMemberInfo> fromBeformActivityMemberList = (List<GroupMemberInfo>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
//                List<AddressBook> contacts = ReadAddressBook.getAddrBook(FromContactAddTeamGroupMemberActivity.this); //读取本地通讯录的数据
//                if (fromBeformActivityMemberList != null && fromBeformActivityMemberList.size() > 0) {
//                    for (GroupMemberInfo group : fromBeformActivityMemberList) {
//                        group.setClickable(false);
//                        list.add(group);
//                    }
//                    if (contacts != null && contacts.size() > 0) { //本地通讯录的数据
//                        for (AddressBook contact : contacts) {
//                            boolean isExistUser = false; //用户是否已存在
//                            for (GroupMemberInfo info : list) {
//                                if (TextUtils.isEmpty(contact.getTelph())) {
//                                    continue;
//                                }
//                                if (contact.getTelph().equals(info.getTelphone())) { //本地通讯录号码与传递过来的号码是否相同
//                                    isExistUser = true;
//                                    break;
//                                }
//                            }
//                            if (!isExistUser) { //只添加不存在的通讯录成员
//                                list.add(contactSwitchGroupMemberInfo(contact));
//                            }
//                        }
//                    }
//                } else {
//                    if (contacts != null && contacts.size() > 0) {
//                        for (AddressBook contact : contacts) {
//                            if (TextUtils.isEmpty(contact.getTelph())) {
//                                continue;
//                            }
//                            list.add(contactSwitchGroupMemberInfo(contact));
//                        }
//                    }
//                }
//                runOnUiThread(new Runnable() {
//                    @Override
//                    public void run() {
//                        Utils.setPinYinAndSort(list); //将获取的成员进行排序
//                        setAdapter();
//                        getContactData();
//                    }
//                });
//            }
//        }).start();
//    }
//
//
//    /**
//     * 本地与服务器电话号码不相同的处理
//     */
//    public GroupMemberInfo contactSwitchGroupMemberInfo(AddressBook contact) {
//        GroupMemberInfo bean = new GroupMemberInfo();
//        bean.setReal_name(contact.getName());
//        bean.setTelphone(contact.getTelph());
//        bean.setClickable(true); //设置可以点击
//        bean.setSortLetters(PinYin2Abbreviation.getPingYin(contact.getName().substring(0, 1)).toUpperCase()); //转换首字母小写
//        return bean;
//    }
//
//
//    /**
//     * 显示底部Layout
//     */
//    private void showBottomLayout() {
//        personCount.setText(Html.fromHtml("<font color='#666666'>已选中</font><font color='#d7252c'> " + selectSize + "</font><font color='#666666'>人</font>"));
//        bottomLayout.setVisibility(selectSize == 0 ? View.GONE : View.VISIBLE);
//    }
//
//
//    private void setAdapter() {
//        if (adapter == null) {
//            ListView listView = (ListView) findViewById(R.id.listView);
//            adapter = new CommonPersonListAdapter(this, list, true);
//            listView.setAdapter(adapter);
//            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//                @Override
//                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
//                    GroupMemberInfo bean = adapter.getList().get(position);
//                    if (!bean.isClickable()) {
//                        return;
//                    }
//                    if (bean.getTelphone().equals(UclientApplication.getLoginTelephone(getApplicationContext()))) {
//                        CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.add_fail), CommonMethod.ERROR);
//                        return;
//                    }
//                    boolean isSelected = bean.isSelected();
//                    selectSize = isSelected ? selectSize - 1 : selectSize + 1;
//                    bean.setSelected(!isSelected);
//                    adapter.updateSingleView(view, position);
//                    showBottomLayout();
//                }
//            });
//        } else {
//            adapter.notifyDataSetChanged();
//        }
//    }
//
//
//    /**
//     * 广播回调
//     */
//    class MessageBroadcast extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String action = intent.getAction();
//            if (action.equals(WebSocketConstance.ACTION_ADD_MEMBERS)) { //添加人员
//                GroupManager groupManager = (GroupManager) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                intent.putExtra(Constance.BEAN_ARRAY, (Serializable) groupManager.getMember_list());
//                intent.putExtra(Constance.GROUP_NAME, groupManager.getTeam_comment());
//                FromContactAddTeamGroupMemberActivity.this.setResult(getIntent().getIntExtra(Constance.ADD_MEMBER_TYPE, Constance.ADD_MEMBER), intent);
//                finish();
//            } else if (action.equals(WebSocketConstance.ACTION_SINGLE_CHAT)) { //获取通讯录好友列表  主要是做好友的添加
//                GroupManager manager = (GroupManager) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                if (!TextUtils.isEmpty(manager.getClass_type()) && manager.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
//                    List<GroupMemberInfo> friendList = manager.getMember_list();
//                    if (friendList != null && friendList.size() > 0) {
//                        ruledOut(friendList);
//                    }
//                }
//            }
//        }
//    }
//
//    /**
//     * 排除本地通讯录中已存在的电话号码
//     * 主要是获取自己的好友 有可能在本地已经添加过了
//     *
//     * @param friendList
//     */
//    private void ruledOut(List<GroupMemberInfo> friendList) {
//        int size = friendList.size();//好友数量
//        for (int i = 0; i < size; i++) {
//            for (GroupMemberInfo localContact : list) {
//                if (localContact.getTelphone().equals(friendList.get(i).getTelphone())) {
//                    friendList.remove(i);
//                    ruledOut(friendList);
//                    return;
//                }
//            }
//        }
//        list.addAll(friendList);
//        Utils.setPinYinAndSort(list);
//        setAdapter();
//    }
//
//    /**
//     * 注册广播
//     */
//    public void registerReceiver() {
//        IntentFilter filter = new IntentFilter();
//        filter.addAction(WebSocketConstance.ACTION_ADD_MEMBERS);
//        filter.addAction(WebSocketConstance.ACTION_SINGLE_CHAT);
//        receiver = new MessageBroadcast();
//        registerLocal(receiver, filter);
//    }
//
//
//    @Override
//    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        if (resultCode == Constance.ADD_MEMBER) { //从项目添加人员成功
//            setResult(Constance.ADD_MEMBER);
//            finish();
//        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //支付成功查看订单
//            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
//            finish();
//        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //支付成功返回首页
//            setResult(ProductUtil.PAID_GO_HOME);
//            finish();
//        }
//    }
//
//
//    /**
//     * 获取通讯录数据
//     */
//    private void getContactData() {
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            BaseRequestParameter requestParameter = new BaseRequestParameter();
//            requestParameter.setAction(WebSocketConstance.ACTION_SINGLE_CHAT);
//            requestParameter.setCtrl(WebSocketConstance.CTRL_IS_CHAT);
//            requestParameter.setClass_type(WebSocketConstance.SINGLECHAT);
//            requestParameter.setCur_class_type(WebSocketConstance.SINGLECHAT);
//            webSocket.requestServerMessage(requestParameter);
//        }
//    }
//}
