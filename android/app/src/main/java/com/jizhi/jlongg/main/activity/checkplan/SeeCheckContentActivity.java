package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.check.ShowCheckContentOrChechPointAdapter;
import com.jizhi.jlongg.main.bean.CheckContent;
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
 * CName:查看检查内容
 * User: xuj
 * Date: 2017年11月17日
 * Time: 10:01:41
 */
public class SeeCheckContentActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 是否修改了数据
     */
    private boolean isUpdate;
    /**
     * 检查内容输入框
     */
    private TextView checkContentNameText;
    /**
     * 右上角显示更多布局
     */
    private TextView rightTitle;
    /**
     * listView
     */
    private ListView listView;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId  项目组id
     * @param id       检查内容id
     * @param isClosed true表示项目组已关闭
     */
    public static void actionStart(Activity context, String groupId, int id, boolean isClosed) {
        Intent intent = new Intent(context, SeeCheckContentActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.ID, id);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_check_content);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.check_content);
        findViewById(R.id.addLayout).setVisibility(View.GONE);
        if (!getIntent().getBooleanExtra(Constance.IS_CLOSED, false)) {
            rightTitle = getTextView(R.id.right_title);
            rightTitle.setText(R.string.more);
        }
        listView = (ListView) findViewById(R.id.listView);
        View headView = getLayoutInflater().inflate(R.layout.new_check_content_head, null);
        checkContentNameText = (TextView) headView.findViewById(R.id.checkContentNameText);
        listView.addHeaderView(headView);
        loadData();
    }


    private void loadData() {
        CheckListHttpUtils.getCheckContentDetail(this, getIntent().getIntExtra(Constance.ID, 0), new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                CheckContent checkContent = (CheckContent) checkPlan;
                checkContentNameText.setVisibility(View.VISIBLE);
                checkContentNameText.setText(checkContent.getContent_name()); //设置检查内容名称
                if (!getIntent().getBooleanExtra(Constance.IS_CLOSED, false)) {
                    rightTitle.setVisibility(checkContent.getIs_operate() == 1 ? View.VISIBLE : View.GONE);
                }
                listView.setAdapter(new ShowCheckContentOrChechPointAdapter(SeeCheckContentActivity.this, checkContent.getDot_list(), false));
            }

            @Override
            public void onFailure(HttpException e, String s) {
                finish();
            }
        });
    }


    public static final String UPDATE = "1";
    public static final String DELETE = "2";
    public static final String CANCEL = "3";

    public List<SingleSelected> getPopWindowItem() {
        List<SingleSelected> list = new ArrayList<>();

        list.add(new SingleSelected("修改", false, false, UPDATE));
        list.add(new SingleSelected("删除", false, false, DELETE));
        list.add(new SingleSelected("取消", false, false, CANCEL));

        return list;
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.right_title: //查看检查内容时的按钮
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getPopWindowItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case UPDATE:  //修改检查内容
                                final Intent intent = getIntent();
                                String groupId = intent.getStringExtra(Constance.GROUP_ID);
                                int contentId = intent.getIntExtra(Constance.ID, 0);
                                NewOrUpdateCheckContentActivity.actionStart(SeeCheckContentActivity.this, groupId, contentId, NewOrUpdateCheckContentActivity.UPDATE_CHECK);
                                break;
                            case DELETE: //删除检查内容
                                DialogOnlyTitle deleteDialog = new DialogOnlyTitle(SeeCheckContentActivity.this, new DiaLogTitleListener() {
                                    @Override
                                    public void clickAccess(int position) {
                                        int contentId = getIntent().getIntExtra(Constance.ID, 0);
                                        CheckListHttpUtils.deleteCheckContent(SeeCheckContentActivity.this, contentId, new CheckListHttpUtils.CommonRequestCallBack() {
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
                                }, -1, "是否删除该检查内容");
                                deleteDialog.show();
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT) { //修改检查内容成功
            isUpdate = true;
            loadData();
        }
    }

    @Override
    public void onBackPressed() {
        if (isUpdate) {
            setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT);
        }
        super.onBackPressed();
    }

    @Override
    public void onFinish(View view) {
        if (isUpdate) {
            setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT);
        }
        super.onFinish(view);
    }

}
