package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ExpandableListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.QuickJoinGroupChatAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupManager;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;


/**
 * 快速加群列表
 *
 * @author Xuj
 * @time 2018年12月18日10:51:58
 * @Version 1.0
 */
public class QuickJoinGroupChatActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 完善工种类型的布局
     */
    private View completeWorkTypeView;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, QuickJoinGroupChatActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.expandablelistview_no_swipe);
        initView();
        getData();
    }

    private void initView() {
        setTextTitle(R.string.quick_join_group);
    }

    /**
     * 获取快速加群列表数据
     */
    private void getData() {
        String httpUrl = NetWorkRequest.FAST_GROUP_CHAT_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, GroupManager.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupManager groupManager = (GroupManager) object;
                if (groupManager != null) {
                    GroupDiscussionInfo areaJoinGroupChat = MessageUtil.getAreaJoinGroupChat();
                    GroupDiscussionInfo workTypeGroupChat = MessageUtil.getWorkTypeGroupChat();
                    if (areaJoinGroupChat != null) {
                        //如果本地已有了从地区添加的群聊则替换服务器的数据
                        if (groupManager.getLocal_list() != null) {
                            groupManager.getLocal_list().set(0, areaJoinGroupChat);
                        } else {
                            ArrayList arrayList = new ArrayList();
                            arrayList.add(areaJoinGroupChat);
                            groupManager.setLocal_list(arrayList);
                        }
                    }
                    if (workTypeGroupChat != null) {
                        if (groupManager.getWork_list() != null) {
                            int count = 0;
                            for (GroupDiscussionInfo groupDiscussionInfo : groupManager.getWork_list()) {
                                //如果服务器返回的列表数据里面有本地已存在的则需要删除
                                if (groupDiscussionInfo.getGroup_id().equals(workTypeGroupChat.getGroup_id()) &&
                                        groupDiscussionInfo.getClass_type().equals(workTypeGroupChat.getClass_type())) {
                                    groupManager.getWork_list().remove(count);
                                    break;
                                }
                                count++;
                            }
                            groupManager.getWork_list().add(0, workTypeGroupChat);
                        } else {
                            ArrayList arrayList = new ArrayList();
                            arrayList.add(workTypeGroupChat);
                            groupManager.setWork_list(arrayList);
                        }
                    }
                    setAdapter(groupManager, workTypeGroupChat != null, areaJoinGroupChat != null);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    private void setAdapter(GroupManager groupManager, boolean isAddWorkTypeGroupChat, boolean isAddAreaGroupChat) {
        ExpandableListView listView = findViewById(R.id.listView);
        if (completeWorkTypeView == null) {
            completeWorkTypeView = getLayoutInflater().inflate(R.layout.quick_join_group_complete_work_type, null); // 加载对话框
            completeWorkTypeView.findViewById(R.id.complete_work_layout).setOnClickListener(this);
        }
        if (groupManager.getWork_list() != null && groupManager.getWork_list().size() > 0) {
            if (listView.getFooterViewsCount() > 0) {
                listView.removeFooterView(completeWorkTypeView);
            }
        } else {
            if (listView.getFooterViewsCount() == 0) {
                listView.addFooterView(completeWorkTypeView);
            }
        }
        QuickJoinGroupChatAdapter adapter = new QuickJoinGroupChatAdapter(QuickJoinGroupChatActivity.this, groupManager, isAddWorkTypeGroupChat, isAddAreaGroupChat);
        listView.setAdapter(adapter);
        if (adapter.getGroupCount() > 0) { //由于是二级菜单
            int listSize = adapter.getGroupCount();
            for (int i = 0; i < listSize; i++) {
                listView.expandGroup(i);
            }
        }
        listView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                return true;
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.complete_work_layout: //完善工种信息
                X5WebViewActivity.actionStart(QuickJoinGroupChatActivity.this, NetWorkRequest.WEBURLS + "my/resume");
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        getData();
    }
}