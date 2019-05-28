package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.check.CheckListAdapter;
import com.jizhi.jlongg.main.bean.CheckContent;
import com.jizhi.jlongg.main.bean.CheckList;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:查看检查项
 * User: xuj
 * Date: 2017年11月22日
 * Time: 14:58:16
 */
public class SeeCheckListActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 是否修改了数据
     */
    private boolean isUpdate;
    /**
     * listView
     */
    private ExpandableListView expandableListView;
    /**
     * 检查内容适配器
     */
    private CheckListAdapter adapter;
    /**
     * 检查项名称
     */
    private EditText checkListNameEdit;
    /**
     * 位置布局 如果发布时没有填写 需要将其隐藏
     */
    private View addressLayout;
    /**
     * 位置输入框
     */
    private EditText addressEdittext;
    /**
     * 右上角显示更多布局
     */
    private TextView rightTitle;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId    项目组id
     * @param id         检查内容id
     * @param onlySearch 是否只具备查看功能  当从选择检查项里面点击跳转到查看页面时候 只具备查看功能
     */
    public static void actionStart(Activity context, String groupId, int id, boolean onlySearch) {
        Intent intent = new Intent(context, SeeCheckListActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.ID, id);
        intent.putExtra(Constance.BEAN_BOOLEAN, onlySearch);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_check_list);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.check_list);
        findViewById(R.id.addLayout).setVisibility(View.GONE);
        rightTitle = getTextView(R.id.right_title);
        rightTitle.setText(R.string.more);
        expandableListView = (ExpandableListView) findViewById(R.id.listView);

        View headView = getLayoutInflater().inflate(R.layout.new_check_list_head, null);
        checkListNameEdit = (EditText) headView.findViewById(R.id.checkListNameEdit);
        addressEdittext = (EditText) headView.findViewById(R.id.addressEdit);
        addressLayout = headView.findViewById(R.id.addressLayout);
        expandableListView.addHeaderView(headView);
        loadData();
    }


    private void loadData() {
        int proId = getIntent().getIntExtra(Constance.ID, 0);
        CheckListHttpUtils.getCheckListDetail(this, proId, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                CheckList checkList = (CheckList) checkPlan;
                if (TextUtils.isEmpty(checkList.getLocation_text())) { //如果位置信息为空则需要隐藏 位置布局
                    addressLayout.setVisibility(View.GONE);
                } else {
                    addressEdittext.setText(checkList.getLocation_text()); //设置检查项地址
                    addressEdittext.setEnabled(false);
                    addressEdittext.setVisibility(View.VISIBLE);
                    addressLayout.setVisibility(View.VISIBLE);
                }

                checkListNameEdit.setText(checkList.getPro_name());
                checkListNameEdit.setEnabled(false);
                checkListNameEdit.setVisibility(View.VISIBLE);
                boolean onlySearch = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
                rightTitle.setVisibility(checkList.getIs_operate() == 1 && !onlySearch ? View.VISIBLE : View.GONE);
                ArrayList<CheckContent> contentList = checkList.getContent_list();
                setAdapter(contentList);
            }

            @Override
            public void onFailure(HttpException e, String s) {
                finish();
            }
        });
    }

    private void setAdapter(ArrayList<CheckContent> contentList) {
        if (adapter == null) {
            adapter = new CheckListAdapter(SeeCheckListActivity.this, contentList, false, null);
            expandableListView.setAdapter(adapter);
            expandableListView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
                @Override
                public boolean onGroupClick(ExpandableListView expandableListView, View view, int i, long l) {
                    return true;
                }
            });
        } else {
            adapter.updateList(contentList);
        }
        expandGroup();
    }


    public List<SingleSelected> getPopWindowItem() {
        List<SingleSelected> list = new ArrayList<>();

        list.add(new SingleSelected("修改", false, false, SeeCheckContentActivity.UPDATE));
        list.add(new SingleSelected("删除", false, false, SeeCheckContentActivity.DELETE));
        list.add(new SingleSelected("取消", false, false, SeeCheckContentActivity.CANCEL));

        return list;
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.right_title: //查看检查项时的按钮
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getPopWindowItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case SeeCheckContentActivity.UPDATE:  //修改检查项
                                final Intent intent = getIntent();
                                String groupId = intent.getStringExtra(Constance.GROUP_ID);
                                int proId = getIntent().getIntExtra(Constance.ID, 0);
                                NewOrUpdateCheckListActivity.actionStart(SeeCheckListActivity.this, groupId, proId, NewOrUpdateCheckContentActivity.UPDATE_CHECK);
                                break;
                            case SeeCheckContentActivity.DELETE: //删除检查项
                                DialogOnlyTitle deleteDialog = new DialogOnlyTitle(SeeCheckListActivity.this, new DiaLogTitleListener() {
                                    @Override
                                    public void clickAccess(int position) {
                                        //检查项id
                                        int proId = getIntent().getIntExtra(Constance.ID, 0);
                                        CheckListHttpUtils.deleteCheckList(SeeCheckListActivity.this, proId, new CheckListHttpUtils.CommonRequestCallBack() {
                                            @Override
                                            public void onSuccess(Object checkPlan) {
                                                setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT);
                                                finish();
                                            }

                                            @Override
                                            public void onFailure(HttpException e, String s) {

                                            }
                                        });
                                    }
                                }, -1, "是否删除该检查项");
                                deleteDialog.show();
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST) { //修改检查内容成功
            isUpdate = true;
            loadData();
        }
    }

    /**
     * 展开listView选项
     */
    private void expandGroup() {
        if (adapter != null && !adapter.isEmpty()) {
            int size = adapter.getGroupCount();
            for (int i = 0; i < size; i++) {
                expandableListView.expandGroup(i); // 展开被选的group
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (isUpdate) {
            setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST);
        }
        super.onBackPressed();
    }

    @Override
    public void onFinish(View view) {
        if (isUpdate) {
            setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_LIST);
        }
        super.onFinish(view);
    }


}
