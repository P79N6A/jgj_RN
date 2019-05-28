package com.jizhi.jlongg.main.activity.checkplan;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.check.CreateCheckContentAdapter;
import com.jizhi.jlongg.main.bean.CheckContent;
import com.jizhi.jlongg.main.bean.CheckPoint;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.lidroid.xutils.exception.HttpException;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:新建、修改检查内容
 * User: xuj
 * Date: 2017年11月17日
 * Time: 10:01:41
 */
public class NewOrUpdateCheckContentActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 检查内容名称
     */
    private EditText checkContentNameEdit;
    /**
     * 检查点适配器
     */
    private CreateCheckContentAdapter adapter;


    public static final int CREATE_CHECK = 1; //新建检查内容
    public static final int UPDATE_CHECK = 2; //修改检查内容


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId 项目组id
     * @param id      检查内容id
     * @param state   1、新建检查内容  2、修改检查内容
     */
    public static void actionStart(Activity context, String groupId, int id, int state) {
        Intent intent = new Intent(context, NewOrUpdateCheckContentActivity.class);
        intent.putExtra(Constance.CLASSTYPE, WebSocketConstance.TEAM);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.ID, id);
        intent.putExtra(Constance.SEARCH_CHECK_STATE, state);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_check_content);
        initView();
    }

    /**
     * 计算ListView 头部的高度
     *
     * @param listViewHeadView listView头部布局
     */
    private void calculateDefaultHeight(final View listViewHeadView) {
        //当布局加载完毕 计算默认页的高度
        listViewHeadView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                //设置ListView头部的高度
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
        final ListView listView = (ListView) findViewById(R.id.listView);

        TextView rightTitle = getTextView(R.id.right_title);
        final TextView addText = getTextView(R.id.addText);

        findViewById(R.id.addBtnLayout).setOnClickListener(this);
        rightTitle.setOnClickListener(this);

        Intent intent = getIntent();
        //  1、新建检查内容  2、修改检查内容
        int state = intent.getIntExtra(Constance.SEARCH_CHECK_STATE, UPDATE_CHECK);
        addText.setText(R.string.add_check_point);
        final View headView = getLayoutInflater().inflate(R.layout.new_check_content_head, null);
        checkContentNameEdit = (EditText) headView.findViewById(R.id.checkContentNameEdit);
        checkContentNameEdit.setHint(R.string.input_check_content);
        checkContentNameEdit.setVisibility(View.VISIBLE);
        checkContentNameEdit.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    // 在TOUCH的UP事件中，要保存当前的行下标，因为弹出软键盘后，整个画面会被重画
                    // 在getView方法的最后，要根据index和当前的行下标手动为EditText设置焦点
                    if (adapter != null) {
                        adapter.editTouchIndex = -1;
                    }
                }
                return false;
            }
        });
        listView.addHeaderView(headView, null, false);
        if (state == UPDATE_CHECK) { //修改检查内容
            setTextTitleAndRight(R.string.update_check_content, R.string.save);
            CheckListHttpUtils.getCheckContentDetail(this, intent.getIntExtra(Constance.ID, 0), new CheckListHttpUtils.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object checkPlan) {
                    CheckContent checkContent = (CheckContent) checkPlan;
                    checkContentNameEdit.setText(checkContent.getContent_name()); //设置检查内容名称
                    checkContentNameEdit.setSelection(checkContentNameEdit.getText().toString().length());
                    adapter = new CreateCheckContentAdapter(NewOrUpdateCheckContentActivity.this, checkContent.getDot_list());
                    listView.setAdapter(adapter);
                    calculateDefaultHeight(headView);
                }

                @Override
                public void onFailure(HttpException e, String s) {
                    finish();
                }
            });
        } else { //新建检查内容
            setTextTitleAndRight(R.string.create_check_content, R.string.publish);
            List<CheckPoint> list = new ArrayList<>();
            CheckPoint checkPoint = new CheckPoint(true);
            list.add(checkPoint);
            adapter = new CreateCheckContentAdapter(NewOrUpdateCheckContentActivity.this, list);
            listView.setAdapter(adapter);
            calculateDefaultHeight(headView);
        }
    }


    /**
     * 验证检查点是否还有未添的信息
     *
     * @return 检查点数组
     */
    private String checkPointIsFillInfo() {
        if (adapter != null && adapter.getCount() > 0) {
            List<CheckPoint> list = adapter.getList();
            for (CheckPoint checkPoint : list) {
                if (TextUtils.isEmpty(checkPoint.getDot_name())) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请填写检查点要求", CommonMethod.ERROR);
                    return null;
                }
            }
            return new Gson().toJson(list);
        } else {
            CommonMethod.makeNoticeShort(getApplicationContext(), "请添加检查点", CommonMethod.ERROR);
            return null;
        }
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.right_title: //发布按钮
                String checkContentName = checkContentNameEdit.getText().toString();
                if (TextUtils.isEmpty(checkContentName)) { //检查名称不能为空
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请填写检查内容名称", CommonMethod.ERROR);
                    return;
                }
                String dotsJson = checkPointIsFillInfo();
                if (!TextUtils.isEmpty(dotsJson)) {
                    Intent intent = getIntent();
                    //1、新建检查内容  2、修改检查内容
                    int state = intent.getIntExtra(Constance.SEARCH_CHECK_STATE, UPDATE_CHECK);
                    if (state == UPDATE_CHECK) { //修改检查内容
                        int contentId = intent.getIntExtra(Constance.ID, 0);
                        CheckListHttpUtils.updateCheckContent(this, contentId, checkContentName, dotsJson, new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object checkPlan) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "修改成功", CommonMethod.SUCCESS);
                                setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {
                            }
                        });
                    } else { //新建检查内容
                        String groupId = intent.getStringExtra(Constance.GROUP_ID);
                        CheckListHttpUtils.addCheckContent(this, groupId, WebSocketConstance.TEAM, checkContentName, dotsJson, new CheckListHttpUtils.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                CheckContent checkContent = (CheckContent) object;
                                Intent intent1 = getIntent();
                                intent1.putExtra(Constance.BEAN_CONSTANCE, checkContent);
                                CommonMethod.makeNoticeShort(getApplicationContext(), "发布成功", CommonMethod.SUCCESS);
                                setResult(Constance.DELETE_OR_UPDATE_OR_CREATE_CHECK_CONTENT, intent1);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException e, String s) {

                            }
                        });
                    }
                }
                break;
            case R.id.addBtnLayout: //添加检查点
                if (adapter == null) {
                    adapter = new CreateCheckContentAdapter(this, null);
                }
                CheckPoint checkPoint = new CheckPoint(true);
                if (adapter.getList() == null) { //检查内容为空
                    List<CheckPoint> list = new ArrayList<>();
                    list.add(checkPoint);
                    adapter.setList(list);
                } else {
                    adapter.getList().add(adapter.getList().size(), checkPoint);
                }
                adapter.editTouchIndex = -1;
                adapter.notifyDataSetChanged();
                break;
        }
    }


}
