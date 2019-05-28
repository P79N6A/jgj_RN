package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.UnDealSourceAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.SourceMemberProInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;

/**
 * CName:处理数据源列表
 * User: xuj
 * Date: 2016-11-11 11:37:26
 */
public class DealSourceActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 列表适配器
     */
    private UnDealSourceAdapter adapter;
    /**
     * 当前选中的项目组个数
     */
    private TextView selectedCount;
    /**
     * 要求同步其他项目组图标
     */
    private ImageView requestOtherProImg;
    /**
     * 要求同步项目组选中状态
     */
    private boolean selectedState;
    /**
     * 已选个数
     */
    private int selectedSize;


    /**
     * 启动当前Acitivyt
     *
     * @param context
     * @param unDealList 未处理的数据源列表数据
     * @param groupId    项目组id
     */
    public static void actionStart(Activity context, ArrayList<SourceMemberProInfo> unDealList, String groupId) {
        Intent intent = new Intent(context, DealSourceActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, unDealList);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.un_deal_sourcelist);
        initView();
    }

    private void initView() {
        Intent intent = getIntent();
        //未处理的数据源
        ArrayList<SourceMemberProInfo> unDealList = (ArrayList<SourceMemberProInfo>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        if (unDealList == null) {
            finish();
            return;
        }
        requestOtherProImg = (ImageView) findViewById(R.id.requestOtherProImg);
        selectedCount = (TextView) findViewById(R.id.selectedCount);

        View view = findViewById(R.id.requestOtherProLayout);
        getTextView(R.id.confirm_add).setText(R.string.confirm);
        getTextView(R.id.title).setText(R.string.current_source_list);
        view.setVisibility(View.VISIBLE);
        ExpandableListView expandablelistView = (ExpandableListView) findViewById(R.id.listView);
        adapter = new UnDealSourceAdapter(DealSourceActivity.this, unDealList, new UnDealSourceAdapter.SelecteSourceProjectListener() {
            @Override
            public void selecte(Project project) {
                calculateSelectedCount();
            }
        });
        expandablelistView.setAdapter(adapter);
        expandablelistView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                return true;
            }
        });
        expandGroup(expandablelistView);
        calculateSelectedCount();
        view.setOnClickListener(this);
    }


    /**
     * 展开listView选项
     */
    private void expandGroup(ExpandableListView expandablelistView) {
        int size = adapter.getGroupList().size();
        for (int i = 0; i < size; i++) {
            expandablelistView.expandGroup(i); // 展开被选的group
        }
    }

    /**
     * 计算选中的人数
     */
    private void calculateSelectedCount() {
        int size = 0;
        for (SourceMemberProInfo group : adapter.getGroupList()) {
            for (Project child : group.getSync_unsource().getList()) {
                if (child.isSelected()) {
                    size += 1;
                }
            }
        }
        selectedCount.setText(Html.fromHtml("<font color='#666666'>已选中</font><font color='#d7252c'> " + size + "</font> <font color='#666666'>个项目</font>"));
        selectedSize = size;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.confirm_add://添加数据来源人
                addSourceMember();
                break;
            case R.id.requestOtherProLayout: //要求同步其他项目
                selectedState = !selectedState;
                requestOtherProImg.setImageResource(selectedState ? R.drawable.check_checked : R.drawable.check_normal);
                break;
        }
    }


    private void addSourceMember() {
        if (selectedSize == 0) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "请选择你要同步的项目", CommonMethod.ERROR);
            return;
        }
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        MessageUtil.addSourceMember(this, groupId, WebSocketConstance.TEAM, getCommitSourcePerson(), getCommitSourceIds(), new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                setResult(MessageUtil.WAY_ADD_SOURCE_MEMBER, getIntent());
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 提交数据来源人源id
     *
     * @return
     */
    private String getCommitSourceIds() {
        StringBuilder sourceIds = new StringBuilder();
        int count = 0;
        for (SourceMemberProInfo group : adapter.getGroupList()) {
            for (Project child : group.getSync_unsource().getList()) {
                if (child.isSelected()) {
                    sourceIds.append(count == 0 ? child.getPid() : "," + child.getPid());
                }
                count++;
            }
        }
        return sourceIds.toString();
    }

    /**
     * 获取提交数据来源人信息
     */
    private ArrayList<GroupMemberInfo> getCommitSourcePerson() {
        ArrayList<GroupMemberInfo> selectedList = new ArrayList<>();
        for (SourceMemberProInfo groupMemberInfo : adapter.getGroupList()) {
            for (Project child : groupMemberInfo.getSync_unsource().getList()) {
                if (child.isSelected()) {
                    GroupMemberInfo memberInfo = new GroupMemberInfo();
                    memberInfo.setReal_name(groupMemberInfo.getReal_name());
                    memberInfo.setTelephone(groupMemberInfo.getTelephone());
                    memberInfo.setIs_demand(selectedState ? 1 : 0);
                    selectedList.add(memberInfo);
                    break;
                }
            }
        }
        return selectedList;
    }
}
