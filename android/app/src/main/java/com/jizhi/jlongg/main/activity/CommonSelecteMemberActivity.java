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
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.ReadAddressBook;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmojiUtil;
import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DiaLogAddMember;
import com.jizhi.jlongg.main.dialog.DialogRemoveContactsEmoji;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:公共添加成员方式
 * User: xuj
 * Date: 2018年8月15日
 * Time: 10:36:35
 */
public class CommonSelecteMemberActivity extends CommonSelecteMemberAbstractActivity implements View.OnClickListener {

    /**
     * listView
     */
    private ListView listView;
    /**
     * 底部按钮
     */
    private Button joinChatBtn;
    /**
     * 成员头像横向滚动RecyclerView
     */
    private RecyclerView mRecyclerView;
    /**
     * 横向滚动聊天成员适配器
     */
    private MemberRecyclerViewAdapter horizontalAdapter;
    /**
     * 当前选中的成员数量
     */
    private int selectMemberSize;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param title            导航栏标题
     * @param chooseMemberType public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 1; 班组、项目组、群聊添加成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 2; 记单笔-->从班组、项目组、群聊添加记账成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 3; 班组、项目组、群聊查看成员
     *                         public static final int WAY_CREATE_GROUP_CHAT = 4; 发起群聊
     *                         public static final int WAY_CREATE_GROUP = 5; 新建班组时从项目选择成员
     * @param classType        项目组类型
     * @param groupId          项目组id
     * @param existTelphons    已有的成员电话号码 用逗号隔开 ,排除相同电话号码
     */
    public static void actionStart(Activity context, String title, String classType, String groupId, int chooseMemberType, String existTelphons) {
        Intent intent = new Intent(context, CommonSelecteMemberActivity.class);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, chooseMemberType);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.TITLE, title);
        intent.putExtra(Constance.EXIST_TELPHONES, existTelphons);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.initiate_group_chat);
        initView();
        initRecyleListView();
        if (Build.VERSION.SDK_INT >= 23) {
            checkContactsPermission();
        } else {
            compareContact();
        }
    }


    /**
     * android 6.0需要动态检测权限
     */
    public void checkContactsPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) { //检查权限
            //进入到这里代表没有权限.
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_CONTACTS}, Constance.CHECKSELFPERMISSION);
        } else {
            compareContact();
        }
    }


    /**
     * 初始化
     */
    public void initView() {
        Intent intent = getIntent();
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        TextView descTxt = getTextView(R.id.defaultDesc);
        Button defaultBtn = getButton(R.id.defaultBtn);
        defaultBtn.setVisibility(View.VISIBLE);
        switch (classType) {
            case WebSocketConstance.TEAM:
                descTxt.setText("你还未添加项目组成员");
                defaultBtn.setText("添加项目组成员");
                break;
            case WebSocketConstance.GROUP:
                descTxt.setText("你还未添加班组成员");
                defaultBtn.setText("添加班组成员");
                break;
            case WebSocketConstance.GROUP_CHAT:
                descTxt.setText("你还未添加群聊成员");
                defaultBtn.setText("添加群聊成员");
                break;
        }
        getTextView(R.id.title).setText(intent.getStringExtra(Constance.TITLE));
        listView = findViewById(R.id.listView);
        joinChatBtn = getButton(R.id.redBtn);
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        sideBar.setTextView(center_text);
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {  // 设置右侧触摸监听
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
        mClearEditText.setHint("请输入姓名或手机号查找");
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
    }

    private void btnUnClick() {
        joinChatBtn.setClickable(false);
        joinChatBtn.setText("确定");
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        joinChatBtn.setClickable(true);
        joinChatBtn.setText(String.format(getString(R.string.confirm_add_member_count), selectMemberSize));
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
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
     * 排除已存在的号码
     */
    public void compareContact() {
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final ArrayList<GroupMemberInfo> localContacts = ReadAddressBook.getLocalContactsInfo(CommonSelecteMemberActivity.this); //读取本地通讯录的数据
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
     * 比较服务器聊聊对象和班组、项目组已添加的对象,移除已添加的对象
     *
     * @param localContacts 本地通讯录数据
     */
    private void removeExistTelphoneUser(String existTelphone, List<GroupMemberInfo> localContacts) {
        if (TextUtils.isEmpty(existTelphone) || localContacts == null || localContacts.size() == 0) {
            return;
        }
        int size = localContacts.size();
        for (int i = 0; i < size; i++) {
            if (existTelphone.contains(localContacts.get(i).getTelephone())) {
                localContacts.get(i).setClickable(false);
            }
        }
    }

    private void setAdapter(List<GroupMemberInfo> memberInfoList) {
        Utils.setPinYinAndSort(memberInfoList); //将获取的成员进行排序
        this.memberInfoList = memberInfoList;
        if (adapter == null) {
            adapter = new CommonPersonListAdapter(this, memberInfoList, true);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    final GroupMemberInfo bean = adapter.getList().get(position);
                    if (!bean.isClickable()) {
                        return;
                    }
                    if (UclientApplication.getLoginTelephone(getApplicationContext()).equals(bean.getTelephone())) { //不能选择自己
                        CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.add_fail), CommonMethod.ERROR);
                        return;
                    }
                    if (EmojiUtil.containsEmoji(bean.getReal_name())) {
                        final DialogRemoveContactsEmoji dialogRemoveContactsEmoji = new DialogRemoveContactsEmoji(CommonSelecteMemberActivity.this, bean.getTelephone());
                        dialogRemoveContactsEmoji.setListener(new DiaLogAddMember.AddGroupMemberListener() {
                            @Override
                            public void add(String telphone, String realName, String headPic) {
                                bean.setReal_name(realName);
                                bean.setTelephone(telphone);
                                adapter.notifyDataSetChanged();
                                clickItemStatus(bean);
                                dialogRemoveContactsEmoji.dismiss();
                            }
                        });
                        dialogRemoveContactsEmoji.show();
                        return;
                    }
                    clickItemStatus(bean);
                }
            });
        } else {
            adapter.updateListView(memberInfoList);
            adapter.notifyDataSetChanged();
        }
    }


    private void clickItemStatus(GroupMemberInfo bean) {
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

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.redBtn: //添加成员
                final Intent intent = getIntent();
                final int memberListType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                ArrayList<GroupMemberInfo> selectedList = new ArrayList<>();
                for (GroupMemberInfo bean : memberInfoList) {
                    if (bean.isSelected()) {
                        selectedList.add(bean);
                    }
                }
                if (selectedList.size() == 0) {
                    return;
                }
                switch (memberListType) {
                    case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //新建项目时候添加班组成员
                        intent.putExtra(Constance.BEAN_ARRAY, selectedList);
                        setResult(memberListType, intent);
                        finish();
                        break;
                    case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //项目组、班组添加成员
                        String classType = intent.getStringExtra(Constance.CLASSTYPE);
                        String groupId = intent.getStringExtra(Constance.GROUP_ID);
                        MessageUtil.addMembers(this, groupId, classType, selectedList, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                setResult(memberListType, intent);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                        break;
                }
        }
    }
}
