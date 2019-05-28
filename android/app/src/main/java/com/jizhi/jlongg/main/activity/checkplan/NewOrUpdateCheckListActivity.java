package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.check.CheckListAdapter;
import com.jizhi.jlongg.main.bean.CheckContent;
import com.jizhi.jlongg.main.bean.CheckList;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:新建、修改检查项
 * User: xuj
 * Date: 2017年11月22日
 * Time: 10:37:57
 */
public class NewOrUpdateCheckListActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 检查项名称
     */
    private EditText checkListNameEdit;
    /**
     * 位置
     */
    private EditText addressEdit;
    /**
     * 检查内容适配器
     */
    private CheckListAdapter adapter;
    /**
     * listView
     */
    private ExpandableListView expandableListView;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId 项目组id
     * @param id      检查内容id
     * @param state   1、新建检查项  2、修改检查项
     */
    public static void actionStart(Activity context, String groupId, int id, int state) {
        Intent intent = new Intent(context, NewOrUpdateCheckListActivity.class);
        intent.putExtra(Constance.CLASSTYPE, WebSocketConstance.TEAM);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.ID, id);
        intent.putExtra(Constance.SEARCH_CHECK_STATE, state);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_check_list);
        initView();
    }

    /**
     * 计算默认页 高度
     *
     * @param listViewHeadView listView头部布局
     */
    private void calculateDefaultHeight(final View listViewHeadView) {
        //当布局加载完毕 计算默认页的高度
        listViewHeadView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                if (adapter != null) {
                    adapter.setListViewHeadHeight(listViewHeadView.getHeight());
                    adapter.notifyDataSetChanged();
                }
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                if (Build.VERSION.SDK_INT < 16) {
                    listViewHeadView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    listViewHeadView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
    }

    private void initView() {
        expandableListView = (ExpandableListView) findViewById(R.id.listView);
        TextView rightTitle = getTextView(R.id.right_title);
        TextView addText = getTextView(R.id.addText);
        addText.setText(R.string.selecte_check_content);
        rightTitle.setOnClickListener(this);
        findViewById(R.id.addBtnLayout).setOnClickListener(this);
        Intent intent = getIntent();
        //  1、新建检查内容  2、修改检查内容
        int state = intent.getIntExtra(Constance.SEARCH_CHECK_STATE, NewOrUpdateCheckContentActivity.UPDATE_CHECK);

        final View headView = getLayoutInflater().inflate(R.layout.new_check_list_head, null);

        checkListNameEdit = (EditText) headView.findViewById(R.id.checkListNameEdit);
        checkListNameEdit.setHint(R.string.input_check_list_name);
        checkListNameEdit.setVisibility(View.VISIBLE);

        addressEdit = (EditText) headView.findViewById(R.id.addressEdit);
        addressEdit.setHint(R.string.input_check_list_address);
        addressEdit.setVisibility(View.VISIBLE);

        expandableListView.addHeaderView(headView, null, false);


        if (state == NewOrUpdateCheckContentActivity.UPDATE_CHECK) { //修改检查项
            setTextTitleAndRight(R.string.update_check_list, R.string.save);
            CheckListHttpUtils.getCheckListDetail(this, intent.getIntExtra(Constance.ID, 0), new CheckListHttpUtils.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object checkPlan) {
                    CheckList checkList = (CheckList) checkPlan;

                    checkListNameEdit.setText(checkList.getPro_name()); //设置检查项名称
                    checkListNameEdit.setSelection(checkListNameEdit.getText().toString().length());

                    addressEdit.setText(checkList.getLocation_text()); //设置位置
                    addressEdit.setSelection(addressEdit.getText().toString().length());

                    ArrayList<CheckContent> contentList = checkList.getContent_list();
                    setAdapter(contentList);

                    calculateDefaultHeight(headView);
                }

                @Override
                public void onFailure(HttpException e, String s) {
                    finish();
                }
            });
        } else {
            //新建检查项
            setTextTitleAndRight(R.string.new_check_list, R.string.publish);
            setAdapter(null);
            calculateDefaultHeight(headView);
        }
        expandableListView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView expandableListView, View view, int i, long l) {
                return true;
            }
        });
    }


    /**
     * 展开listView选项
     */
    private void expandGroup() {
        if (adapter != null && !adapter.isEmptyData()) {
            int size = adapter.getGroupCount();
            for (int i = 0; i < size; i++) {
                expandableListView.expandGroup(i); // 展开被选的group
            }
        }
    }

    private void setAdapter(ArrayList<CheckContent> contentList) {
        if (adapter == null) {
            adapter = new CheckListAdapter(NewOrUpdateCheckListActivity.this, contentList, true, new CheckListAdapter.RemoveCheckContentListener() {
                @Override
                public void isRemoveAll() {

                }
            });
            expandableListView.setAdapter(adapter);
        } else {
            adapter.updateList(contentList);
        }
        expandGroup();
    }


    /**
     * 验证检查内容是否为空
     *
     * @return 检查点
     */
    private String checkContentIsEmpty() {
        if (adapter != null && !adapter.isEmptyData()) {
            StringBuilder builder = new StringBuilder();
            List<CheckContent> contentList = adapter.getList();
            for (CheckContent checkContent : contentList) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? checkContent.getContent_id() : "," + checkContent.getContent_id());
            }
            return builder.toString();
        } else {
            CommonMethod.makeNoticeShort(getApplicationContext(), "请选择检查内容", CommonMethod.ERROR);
            return null;
        }
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.addBtnLayout: //添加检查内容
                StringBuilder builder = new StringBuilder();
                if (adapter != null && !adapter.isEmptyData()) {
                    //将以选中的检查内容列表传递给后台服务器，让后台帮我们判断当前 检查内容是否已选中
                    for (CheckContent checkContent : adapter.getList()) {
                        builder.append(TextUtils.isEmpty(builder.toString()) ? checkContent.getContent_id() : "," + checkContent.getContent_id());
                    }
                }
                SelecteCheckContentActivity.actionStart(this, getIntent().getStringExtra(Constance.GROUP_ID), builder.toString(), adapter.getList());
                break;
            case R.id.right_title: //发布按钮
                String checkListName = checkListNameEdit.getText().toString(); //检查项名称
                if (TextUtils.isEmpty(checkListName)) { //检查名称和位置不能为空
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请填写检查项名称", CommonMethod.ERROR);
                    return;
                }
                String address = addressEdit.getText().toString(); //位置
                String contentIds = checkContentIsEmpty(); //获取提交的检查内容ids
                if (!TextUtils.isEmpty(contentIds)) {
                    Intent intent = getIntent();
                    //1、新建检查项  2、修改检查项
                    int state = intent.getIntExtra(Constance.SEARCH_CHECK_STATE, NewOrUpdateCheckContentActivity.UPDATE_CHECK);
                    if (state == NewOrUpdateCheckContentActivity.UPDATE_CHECK) { //修改检查项
                        int proIds = intent.getIntExtra(Constance.ID, 0); //检查项id
                        CheckListHttpUtils.updateCheckList(this, proIds, checkListName, address, contentIds, new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object checkPlan) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "修改成功", CommonMethod.SUCCESS);
                                setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {
                            }
                        });
                    } else { //新建检查项
                        String groupId = intent.getStringExtra(Constance.GROUP_ID);
                        CheckListHttpUtils.addCheckList(this, groupId, WebSocketConstance.TEAM, checkListName, address, contentIds, new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object checkPlan) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "发布成功", CommonMethod.SUCCESS);
                                setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {

                            }
                        });
                    }
                }
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SELECTED_CALLBACK) { //选择了检查内容回调
            //已选择的检查内容
            ArrayList<CheckContent> selectedCheckContentList = (ArrayList<CheckContent>) data.getSerializableExtra(Constance.BEAN_ARRAY);
            setAdapter(selectedCheckContentList);
        }
    }
}
