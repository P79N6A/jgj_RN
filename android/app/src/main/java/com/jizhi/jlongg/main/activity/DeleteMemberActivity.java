package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
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
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AddTeamPersonAdapter;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:删除班组成员
 * 作者：Xuj
 * 时间: 2016-9-1 16:37
 */
public class DeleteMemberActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 当前已选人数
     */
    private int selectMemberSize;
    /**
     * 当前筛选框的文字
     */
    private String matchString;
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 列表适配器
     */
    private AddTeamPersonAdapter adapter;
    /**
     * 成员头像横向滚动RecyclerView
     */
    private RecyclerView mRecyclerView;
    /**
     * 横向滚动聊天成员适配器
     */
    private MemberRecyclerViewAdapter horizontalAdapter;
    /**
     * 底部按钮
     */
    private Button removeMemberBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.initiate_group_chat);
        initView();
        initRecyleListView();
    }


    private void initView() {
        Intent intent = getIntent();
        //获取删除成员的类型
        //public static final int DELETE_GROUP_MEMBER = 5; //删除班組成員
        //public static final int DELETE_TEAM_MEMBER = 7; //删除项目组成員
        //public static final int DELETE_SOURCE_DATA_MEMBER = 0X102; //删除数据来源人
        //public static final int DELETE_GROUP_CHAT_MEMBER = 0X82; //删除群聊成员
        int deleteType = intent.getIntExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER);
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        if (TextUtils.isEmpty(groupId)) {
            CommonMethod.makeNoticeShort(this, "获取组id出错", CommonMethod.ERROR);
            finish();
            return;
        }
        ArrayList<GroupMemberInfo> list = (ArrayList<GroupMemberInfo>) intent.getSerializableExtra(Constance.BEAN_ARRAY); //每次查询列表数据返回到上级页面在传递回来的列表数据
        for (GroupMemberInfo group : list) {
            group.setClickable(true);
            group.setSelected(false);
        }
        removeCreatorAndAgenList(list);
        Utils.setPinYinAndSort(list); //排序
        this.list = list;
        SetTitleName.setTitle(findViewById(R.id.title), getString(deleteType == Constance.DELETE_SOURCE_DATA_MEMBER ? R.string.remove_data_source_member : R.string.remove_team_person));
        getTextView(R.id.defaultDesc).setText(deleteType == Constance.DELETE_SOURCE_DATA_MEMBER ? "没有可删除的数据来源人" : "没有可删除的成员");
        removeMemberBtn = getButton(R.id.redBtn);
        final ListView listView = (ListView) findViewById(R.id.listView);
        listView.setEmptyView(findViewById(R.id.defaultLayout));
        adapter = new AddTeamPersonAdapter(this, list);
        listView.setAdapter(adapter);
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
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
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                GroupMemberInfo bean = adapter.getList().get(position);
                if (!bean.isClickable()) {
                    return;
                }
                if (UclientApplication.getLoginTelephone(getApplicationContext()).equals(bean.getTelephone())) { //不能选择自己
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
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入姓名和手机号查找");
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
        btnUnClick();
    }

    private void btnUnClick() {
        removeMemberBtn.setText("确定");
        removeMemberBtn.setClickable(false);
        Utils.setBackGround(removeMemberBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        removeMemberBtn.setText(String.format(getString(R.string.confirm_add_member_count), selectMemberSize));
        removeMemberBtn.setClickable(true);
        Utils.setBackGround(removeMemberBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
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
     * 排除创建者以及代班长
     *
     * @param list
     */
    private void removeCreatorAndAgenList(ArrayList<GroupMemberInfo> list) {
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (list.get(i).getIs_creater() == 1 ||
                    UclientApplication.getUid().equals(list.get(i).getUid())) {
                list.remove(i);
                removeCreatorAndAgenList(list);
                break;
            }
        }
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
            case R.id.redBtn: //确定删除
                StringBuilder uids = new StringBuilder();
                int i = 0;
                for (GroupMemberInfo bean : list) {
                    if (bean.isSelected()) {
                        uids.append(i == 0 ? bean.getUid() : "," + bean.getUid());
                        i++;
                    }
                }
                if (!TextUtils.isEmpty(uids.toString())) {
                    int deleteType = getIntent().getIntExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER);
                    String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
                    switch (deleteType) {
                        case Constance.DELETE_GROUP_MEMBER: //删除班组成员
                            deleteMember(uids.toString(), WebSocketConstance.GROUP, groupId);
                            break;
                        case Constance.DELETE_TEAM_MEMBER: //删除项目组成员
                            deleteMember(uids.toString(), WebSocketConstance.TEAM, groupId);
                            break;
                        case Constance.DELETE_GROUP_CHAT_MEMBER: //删除群聊人员
                            deleteMember(uids.toString(), WebSocketConstance.GROUP_CHAT, groupId);
                            break;
                        case Constance.DELETE_SOURCE_DATA_MEMBER: //删除数据来源人
                            deleteSourceMember(uids.toString(), WebSocketConstance.TEAM, groupId);
                            break;
                    }
                } else
                    finish();
                break;
        }
    }

    /**
     * 删除成员
     *
     * @param uids      用户id 用逗号隔开   xx,xx,xx
     * @param classType 组类型
     * @param groupId   班组、项目组id
     */
    private void deleteMember(String uids, String classType, String groupId) {
        String httpUrl = NetWorkRequest.DEL_MEMBER;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("uid", uids);
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                setResult(getIntent().getIntExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER));
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 删除数据来源人成员
     *
     * @param uids      用户id 用逗号隔开   xx,xx,xx
     * @param classType 项目组
     * @param groupId   班组、项目组id
     */
    private void deleteSourceMember(String uids, String classType, String groupId) {
        String httpUrl = NetWorkRequest.DELETE_SOURCE_MEMBER;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("uid", uids);
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                //删除成员的类型
                setResult(getIntent().getIntExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_GROUP_MEMBER));
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}
