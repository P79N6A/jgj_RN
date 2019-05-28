package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.GetGroupAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * 获取班组列表
 *
 * @author Xuj
 * @time 2017年2月16日9:39:12
 * @Version 1.0
 */
public class GetGroupAccountActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 班组列表适配器
     */
    private GetGroupAdapter adapter;
    /**
     * 列表数据
     */
    private List<GroupDiscussionInfo> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 底部布局
     */
    private View bottomLayout;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText;
    /**
     * 无数据时的按钮
     */
    private View defaultBtn;
    /**
     * 无数据时的布局
     */
    private View inputLayout;


    /**
     * @param context
     * @param isToMultipartAccount true表示进入批量记账 false表示记单笔从班组选择记账对象
     * @param existTelphons        已有的成员电话号码 用逗号隔开 ,排除相同电话号码
     */
    public static void actionStart(Activity context, boolean isToMultipartAccount, String existTelphons) {
        Intent intent = new Intent(context, GetGroupAccountActivity.class);
        intent.putExtra(Constance.BEAN_BOOLEAN, isToMultipartAccount);
        intent.putExtra(Constance.EXIST_TELPHONES, existTelphons);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    private void setAdapter(final List<GroupDiscussionInfo> list) {
        bottomLayout.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        inputLayout.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        this.list = list;
        if (adapter == null) {
            //true表示进入批量记账 false表示记单笔从班组选择记账对象
            final boolean isToMultipartAccount = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            final ListView listView = (ListView) findViewById(R.id.listView);
            listView.setDivider(null);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new GetGroupAdapter(GetGroupAccountActivity.this, list);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    position -= listView.getHeaderViewsCount();
                    final GroupDiscussionInfo bean = adapter.getItem(position);
                    if (isToMultipartAccount) {//批量记账
                        String pid = bean.getPro_id();
                        MultiPersonBatchAccountNewActivity.actionStart(GetGroupAccountActivity.this, pid, bean.getGroup_name(), false, bean.getGroup_id(), bean.getMembers_head_pic(),
                                bean.getAll_pro_name(), UclientApplication.getUid());
                    } else { //从班组选择
                        MessageUtil.getGroupMembers(GetGroupAccountActivity.this, bean.getGroup_id(), WebSocketConstance.GROUP, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                ArrayList<GroupMemberInfo> serverList = (ArrayList<GroupMemberInfo>) object;
                                if (serverList != null && serverList.size() > 0) {
                                    ChooseMemberActivity.actionStart(GetGroupAccountActivity.this, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER,
                                            bean.getGroup_name(), null, null, serverList);
                                } else {
                                    CommonMethod.makeNoticeShort(getApplicationContext(), "该项目中没有更多的成员可添加", CommonMethod.ERROR);
                                }
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                    }
                }
            });
        } else {
            adapter.setList(list);
            adapter.notifyDataSetChanged();
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.group_info);
        initView();
        getForemanGroupList();
    }

    private void initView() {
        setTextTitle(R.string.my_group_list);
        bottomLayout = findViewById(R.id.bottom_layout);
        defaultText = (TextView) findViewById(R.id.defaultDesc);
        TextView defaultText1 = (TextView) findViewById(R.id.defaultDesc1);
        defaultBtn = findViewById(R.id.defaultBtn);
        inputLayout = findViewById(R.id.input_layout);
        getTextView(R.id.red_btn).setText(R.string.create_group);
        defaultText1.setText(Utils.setSelectedFontChangeColor("点击“记工案例”，看看其他班组长怎么批量记工的",
                "记工案例", Color.parseColor("#eb4e4e"), false));
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.setHint("快速搜索关键字");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                filterData(inputText.toString());
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
                            defaultBtn.setVisibility(TextUtils.isEmpty(mMatchString) ? View.VISIBLE : View.GONE);
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 获取班组列表主要是批量记账以及选择班组时使用
     */
    public void getForemanGroupList() {
        String httpUrl = NetWorkRequest.GET_GROUP_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, GroupDiscussionInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupDiscussionInfo> list = (ArrayList<GroupDiscussionInfo>) object;
                for (GroupDiscussionInfo groupDiscussionInfo : list) {
                    groupDiscussionInfo.setGroup_name(groupDiscussionInfo.getPro_name());
                    //从本地数据库获取头像
                    groupDiscussionInfo.setMembers_head_pic(MessageUtil.loadHeadPicFromGroupId(groupDiscussionInfo.getGroup_id()));
                }
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
            setResult(resultCode);
            finish();
        } else if (resultCode == Constance.RESULTCODE_ADDCONTATS) { //批量记账成功
            setResult(resultCode, data);
            finish();
        } else if (resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER) { //新建班组回调成功
            setResult(resultCode, data);
            finish();
        } else {
            getForemanGroupList(); //重新刷新列表
        }
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.right_btn: //无数据时新建班组按钮
            case R.id.red_btn_layout: //底部新建班组
                IsSupplementary.isFillRealNameIntentActivity(this, false, CreateTeamGroupActivity.class);
                break;
            case R.id.left_btn: //用户案例
                HelpCenterUtil.actionStartHelpActivity(this, -2);
                break;
        }
    }
}