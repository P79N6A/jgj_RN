package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ReadAddressBook;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.SourceMemberProInfo;
import com.jizhi.jlongg.main.bean.SourceMemberProManager;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.ResizeAnimation;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:添加数据来源人
 * 时间:2016年8月23日 17:41:01
 * 作者:xuj
 */
public class AddSourceMemberActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 当前选中的成员数量
     */
    private int selectMemberSize;
    /**
     * 聊天成员适配器
     */
    private MemberRecyclerViewAdapter horizontalAdapter;
    /**
     * 横向滚动头像
     */
    private RecyclerView mRecyclerView;
    /**
     * 列表适配器
     */
    private CommonPersonListAdapter adapter;
    /**
     * 数据来源人未处理的数据源
     */
    private ArrayList<SourceMemberProInfo> unDealList;
    /**
     * 列表数据
     */
    private ArrayList<GroupMemberInfo> list;
    /**
     * 筛选框输入的文字
     */
    private String matchString;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 加入群聊按钮
     */
    private Button joinChatBtn;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId          项目组id
     * @param chooseMemberType MessageUtils
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 0X1; 班组、项目组、群聊添加成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 0X2; 记单笔-->从班组、项目组、群聊添加记账成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 0X3; 班组、项目组、群聊查看成员
     *                         public static final int WAY_CREATE_GROUP_CHAT = 0X14; 创建群聊、班组、项目组
     *                         public static final int WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER = 0X5; 新建班组时从项目选择成员
     *                         public static final int WAY_ADD_SOURCE_MEMBER = 0X101; 添加数据来源人
     * @param existPhone       成员列表中已存在的电话号码、需要将相同电话号码的人给排除掉
     */
    public static void actionStart(Activity context, String groupId, int chooseMemberType, String existPhone) {
        Intent intent = new Intent(context, AddSourceMemberActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, chooseMemberType);
        intent.putExtra(Constance.EXIST_TELPHONES, existPhone);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_source_person);
        initView();
        if (Build.VERSION.SDK_INT >= 23) {
            checkContactsPermission();
        } else {
            initData();
        }
    }

    private void initData() {
        compareContact();
        getUnDealDataSource();
    }


    /**
     * android 6.0需要动态检测权限
     */
    public void checkContactsPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) { //检查权限
            //进入到这里代表没有权限.
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_CONTACTS}, Constance.CHECKSELFPERMISSION);
        } else {
            initData();
        }
    }

    private void btnUnClick() {
        joinChatBtn.setText("添加");
        joinChatBtn.setClickable(false);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        joinChatBtn.setText(String.format(getString(R.string.add_member_count), selectMemberSize));
        joinChatBtn.setClickable(true);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    /**
     * 初始化
     */
    public void initView() {
        TextView defaultDesc = getTextView(R.id.defaultDesc);
        Button defaultBtn = getButton(R.id.defaultBtn);
        defaultBtn.setText("添加数据来源人");
        defaultDesc.setText("当前没有可选数据来源人");
        setTextTitle(R.string.add_data_source_member);
        listView = (ListView) findViewById(R.id.listView);
        joinChatBtn = getButton(R.id.redBtn);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        mClearEditText.setHint("请输入姓名和手机号查找");
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        joinChatBtn.setText("添加");
        sideBar.setTextView(center_text);
        //设置右侧触摸监听
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
        btnUnClick();
        initRecyleListView();
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
                selectMemberSize -= 1;
                if (selectMemberSize > 0) {
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
            }
        });
    }

    /**
     * 获取未处理的数据源
     */
    private void getUnDealDataSource() {
        final String teamId = getIntent().getStringExtra(Constance.GROUP_ID);
        MessageUtil.getSourceMemberSource(this, teamId, WebSocketConstance.TEAM, null, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final SourceMemberProManager sourceMemberProManager = (SourceMemberProManager) object;
                if (sourceMemberProManager != null && sourceMemberProManager.getSync_count() != null && sourceMemberProManager.getSync_count().getSync_unsource_person_count() > 0) {
                    unDealList = sourceMemberProManager.getList();
                    startDealSourceAnim();
                    TextView sourceMember = getTextView(R.id.sourceMember);
                    sourceMember.setText(String.format(getString(R.string.currentSourceMember), sourceMemberProManager.getSync_count().getSync_unsource_person_count()));
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
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
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.sourceLayout: //选择现成数据源
                DealSourceActivity.actionStart(this, unDealList, getIntent().getStringExtra(Constance.GROUP_ID));
                break;
            case R.id.redBtn: //确认添加按钮
                final ArrayList<GroupMemberInfo> selectedMemberList = new ArrayList<>();
                for (GroupMemberInfo bean : list) {
                    if (bean.isSelected()) {
                        selectedMemberList.add(bean);
                    }
                }
                String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
                MessageUtil.addSourceMember(AddSourceMemberActivity.this, groupId, WebSocketConstance.TEAM, selectedMemberList, null, new CommonHttpRequest.CommonRequestCallBack() {
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
                break;
        }
    }


    /**
     * 比较服务器聊聊对象和班组、项目组已添加的对象,移除已添加的对象
     *
     * @param localContacts
     */
    private void removeExistTelphoneUser(String existTelphone, List<GroupMemberInfo> localContacts) {
        if (TextUtils.isEmpty(existTelphone) || localContacts == null || localContacts.size() == 0) {
            return;
        }
        int size = localContacts.size();
        for (int i = 0; i < size; i++) {
            if (existTelphone.contains(localContacts.get(i).getTelephone())) {
                localContacts.get(i).setClickable(false);
//                localContacts.remove(i);
//                removeExistTelphoneUser(existTelphone, localContacts);
//                return;
            }
        }
    }

    private void setAdapter(ArrayList<GroupMemberInfo> list) {
        this.list = list;
        Utils.setPinYinAndSort(list); //将获取的成员进行排序
        if (adapter == null) {
            adapter = new CommonPersonListAdapter(this, list, true);
            listView.setAdapter(adapter);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    GroupMemberInfo bean = adapter.getList().get(position);
                    if (!bean.isClickable()) {
                        return;
                    }
                    if (UclientApplication.getLoginTelephone(getApplicationContext()).equals(bean.getTelephone())) {
                        CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.add_fail), CommonMethod.ERROR);
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
        } else {
            adapter.updateListView(list);
        }
    }

    /**
     * 比较通讯录如果相同号码的数据不可点击
     */
    public void compareContact() {
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final ArrayList<GroupMemberInfo> localContacts = ReadAddressBook.getLocalContactsInfo(AddSourceMemberActivity.this); //读取本地通讯录的数据
                String existTelephone = getIntent().getStringExtra(Constance.EXIST_TELPHONES); //已有的电话号码
                removeExistTelphoneUser(existTelephone, localContacts);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        setAdapter(localContacts);
                    }
                });
            }
        });
    }


    /**
     * 开启处理数据源的动画
     */
    private void startDealSourceAnim() {
        View sourceLayout = findViewById(R.id.sourceLayout);
        sourceLayout.setVisibility(View.VISIBLE);
        ResizeAnimation animation = new ResizeAnimation(sourceLayout);
        animation.setDuration(500);
        animation.setParams(0, DensityUtils.dp2px(AddSourceMemberActivity.this, 40));
        sourceLayout.startAnimation(animation);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == MessageUtil.WAY_ADD_SOURCE_MEMBER) { //添加数据来源人
            setResult(resultCode, data);
            finish();
        } else if (resultCode == ProductUtil.PAID) { //已支付的标志
            setResult(ProductUtil.PAID, data);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }


}
