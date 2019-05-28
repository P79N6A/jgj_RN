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
import com.hcs.uclient.utils.CallPhoneUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.SourceMemberAdapter;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.SourceMemberProManager;
import com.jizhi.jlongg.main.dialog.DialogEditorSourcePro;
import com.jizhi.jlongg.main.listener.SourceMemberListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * CName:展示全部的数据来源人
 * User: xuj
 * Date: 2016-12-26
 * Time: 2016-12-26 17:16:51
 */
public class SourceMemberManagerActivity extends BaseActivity implements AddMemberListener {
    /**
     * 数据来源人成员数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 成员适配器
     */
    private SourceMemberAdapter membersAdapter;
    /**
     * 导航条标题
     */
    private TextView title;
    /**
     * 当前筛选框文字
     */
    private String matchString;
    /**
     * 成员数量、是否是高级版、购买人数、项目是否已过期、是否可以降级
     */
    private int memberNum;
    /**
     * 项目组名称
     */
    private String teamId;
    /**
     * 是否已关闭
     */
    private boolean isClosed;
    /**
     * 项目名称
     */
    private String groupName;
    /**
     * 组成员头像
     */
    private List<String> membersHeadPic;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, boolean isClosedTeam, String teamId) {
        Intent intent = new Intent(context, SourceMemberManagerActivity.class);
        intent.putExtra(Constance.IS_CLOSED, isClosedTeam);
        intent.putExtra(Constance.TEAM_ID, teamId);
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
        isClosed = getIntent().getBooleanExtra(Constance.IS_CLOSED, false);
        title = (TextView) findViewById(R.id.title);
        teamId = getIntent().getStringExtra(Constance.TEAM_ID);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入名字进行查找");
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


    /**
     * 获取班组信息
     */
    private void getGroupInfo() {
        MessageUtil.getGroupInfo(this, teamId, WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                List<GroupMemberInfo> membersList = groupManager.getMember_list(); //获取成员数量
                List<GroupMemberInfo> sourceMembers = null;
                if (membersList != null && membersList.size() > 0) {
                    sourceMembers = new ArrayList<>();
                    for (GroupMemberInfo groupMemberInfo : membersList) {
                        if (groupMemberInfo.getIs_source_member() == 1) {
                            sourceMembers.add(groupMemberInfo);
                        }
                    }
                    memberNum = sourceMembers.size(); //项目成员数量
                }
                groupName = groupManager.getGroup_info().getGroup_name();
                membersHeadPic = groupManager.getMembers_head_pic();
                title.setText(String.format(getString(R.string.all_source_member), sourceMembers == null ? 0 : sourceMembers.size()));
                if (membersAdapter == null) {
                    GridView sourceMemberGrid = (GridView) findViewById(R.id.gridView);
                    membersAdapter = new SourceMemberAdapter(SourceMemberManagerActivity.this, sourceMembers, SourceMemberManagerActivity.this, isClosed);
                    membersAdapter.setSourceMemberHeadClickListener(new SourceMemberAdapter.SourceMemberHeadClick() {
                        @Override
                        public void clickSourceHead(int position) {
                            getDataSource(membersAdapter.getList().get(position));
                        }
                    });
                    sourceMemberGrid.setAdapter(membersAdapter);
                } else {
                    membersAdapter.updateListView(sourceMembers);
                }
                SourceMemberManagerActivity.this.list = sourceMembers;
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 获取数据来源人  数据源
     *
     * @param groupMemberInfo 数据来源人信息
     */
    private void getDataSource(final GroupMemberInfo groupMemberInfo) {
        MessageUtil.getSourceMemberSource(this, teamId, WebSocketConstance.TEAM, groupMemberInfo.getUid(), new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final SourceMemberProManager sourceMemberProManager = (SourceMemberProManager) object;
                if (sourceMemberProManager != null) {
                    final DialogEditorSourcePro sourceProEditor = new DialogEditorSourcePro(SourceMemberManagerActivity.this,
                            groupMemberInfo.getReal_name(), groupMemberInfo.getTelephone(), sourceMemberProManager);
                    sourceProEditor.setListener(new SourceMemberListener() {
                        @Override
                        public void removeSource(Project project) {//移除单个现项目组源
                            MessageUtil.removeSingleSource(SourceMemberManagerActivity.this, teamId, WebSocketConstance.TEAM, project.getSelf_uid(),
                                    project.getPid() + "", new CommonHttpRequest.CommonRequestCallBack() {
                                        @Override
                                        public void onSuccess(Object object) {
                                            sourceProEditor.dismiss();
                                            getDataSource(groupMemberInfo);
                                        }

                                        @Override
                                        public void onFailure(HttpException exception, String errormsg) {

                                        }
                                    });
                        }

                        @Override
                        public void requestPro() {//要求同步项目组
                            ArrayList<GroupMemberInfo> list = new ArrayList<>();
                            groupMemberInfo.setIs_demand(1);
                            list.add(groupMemberInfo);
                            MessageUtil.addSourceMember(SourceMemberManagerActivity.this, teamId, WebSocketConstance.TEAM, list,
                                    null, new CommonHttpRequest.CommonRequestCallBack() {
                                        @Override
                                        public void onSuccess(Object object) {
                                        }

                                        @Override
                                        public void onFailure(HttpException exception, String errormsg) {

                                        }
                                    });
                        }

                        @Override
                        public void correlation() {//关联到本组
                            DealSourceActivity.actionStart(SourceMemberManagerActivity.this, sourceMemberProManager.getList(), teamId);
                        }

                        @Override
                        public void clickName() {//点击名称去到查看资料页面
                            if (groupMemberInfo.getIs_active() == 0) {
                                CommonMethod.makeNoticeShort(SourceMemberManagerActivity.this, "TA还没加入吉工家，没有更多资料了", CommonMethod.ERROR);
                                return;
                            }
                            ChatUserInfoActivity.actionStart(SourceMemberManagerActivity.this, groupMemberInfo.getUid());
                        }

                        @Override
                        public void callPhone() {
                            CallPhoneUtil.callPhone(SourceMemberManagerActivity.this, groupMemberInfo.getTelephone());
                        }
                    });
                    sourceProEditor.show();
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
        if (membersAdapter == null || list == null || list.size() == 0) {
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
        if (memberNum >= 500) {
            CommonMethod.makeNoticeLong(getApplicationContext(), "项目成员人数不能超过500人", CommonMethod.ERROR);
            return;
        }
        AddMemberWayActivity.actionStart(this, addType, teamId, Constance.TEAM, membersHeadPic, groupName, membersAdapter.getList(), false);
    }

    @Override
    public void remove(int state) {
        Intent intent = new Intent(this, DeleteMemberActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) membersAdapter.getList());
        intent.putExtra(Constance.DELETE_MEMBER_TYPE, Constance.DELETE_SOURCE_DATA_MEMBER);
        intent.putExtra(Constance.GROUP_ID, teamId);
        startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_ADD_SOURCE_MEMBER || resultCode == Constance.DELETE_SOURCE_DATA_MEMBER) {
            setResult(resultCode);
            getGroupInfo();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_GROUP_CHAT) { //创建群聊
            setResult(Constance.CLICK_GROUP_CHAT, data);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }
}
