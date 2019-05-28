package com.jizhi.jlongg.main.activity.check;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.CheckProjectAdapter;
import com.jizhi.jlongg.main.bean.CheckListBean;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogCheckMore;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:检查项2.3.4
 * User: hcs
 * Date: 2017-11-22
 * Time: 17:14
 */

public class CheckProjectActivity extends BaseActivity implements CheckProjectAdapter.CheckProjectItemClickListener {
    private CheckProjectActivity mActivity;
    /*组信息*/
    private GroupDiscussionInfo gnInfo;
    /*检查id*/
    private String plan_id, pro_id;
    /*更多弹窗*/
    private DialogCheckMore dialogCheckMore;
    /*listview*/
    private ExpandableListView listview;
    /*listview头部信息*/
    private View headerView;
    /*adapter*/
    private CheckProjectAdapter checkProjectAdapter;
    private List<CheckPlanListBean> checkPlanListBean;
    /*是否刷新数据*/
    private boolean isFlushData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_check_quality_and_safe_detail);
        registerFinishActivity();
        getIntentData();
        initView();
//        initRightImageLog();
        initHeadView();
        getPlanProInfo(-1, -1);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String plan_id, String pro_id) {
        Intent intent = new Intent(context, CheckProjectActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.INSPLAN_ID, plan_id);//检查计划id
        intent.putExtra(Constance.PRO_ID, pro_id);//检查项id
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }


    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        plan_id = getIntent().getStringExtra(Constance.INSPLAN_ID);
        pro_id = getIntent().getStringExtra(Constance.PRO_ID);
    }

    /**
     * 初始化view
     */
    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), "检查项");
        mActivity = CheckProjectActivity.this;
        listview = (ExpandableListView) findViewById(R.id.listview);
    }

    /**
     * 初始化headView
     */
    private void initHeadView() {
        headerView = getLayoutInflater().inflate(R.layout.layout_head_check_project, null);
        listview.addHeaderView(headerView);
        checkPlanListBean = new ArrayList<>();
        checkProjectAdapter = new CheckProjectAdapter(mActivity, checkPlanListBean, gnInfo, this, plan_id, pro_id);
        listview.setAdapter(checkProjectAdapter);
    }

    private void setHeadData(CheckListBean checkListBean, int group_positon, int child_position) {
        TextView tv_name = (TextView) headerView.findViewById(R.id.tv_name);
        TextView tv_addr = (TextView) headerView.findViewById(R.id.tv_addr);
        TextView tv_state = (TextView) headerView.findViewById(R.id.tv_state);
        tv_name.setText(checkListBean.getPro_name());
        tv_addr.setText(checkListBean.getLocation_text());
        if (checkListBean.getStatus() == 0) {
            //0：未检查
            tv_state.setText("[未检查]");
            tv_state.setTextColor(ContextCompat.getColor(mActivity, R.color.color_999999));
        } else if (checkListBean.getStatus() == 1) {
            //1：待整改
            tv_state.setText("[待整改]");
            tv_state.setTextColor(ContextCompat.getColor(mActivity, R.color.color_eb4e4e));
        } else if (checkListBean.getStatus() == 2) {
            // 2：不用检查
            tv_state.setText("[不用检查]");
            tv_state.setTextColor(ContextCompat.getColor(mActivity, R.color.color_999999));
        } else if (checkListBean.getStatus() == 3) {
            //3：完成
            tv_state.setText("[通过]");
            tv_state.setTextColor(ContextCompat.getColor(mActivity, R.color.color_83c76e));
        } else {
            tv_state.setText("");
            tv_state.setTextColor(ContextCompat.getColor(mActivity, R.color.color_999999));
        }


        checkPlanListBean = checkListBean.getContent_list();
        checkProjectAdapter = new CheckProjectAdapter(mActivity, checkPlanListBean, gnInfo, this, plan_id, pro_id);
        listview.setAdapter(checkProjectAdapter);
        String ed_text = "检查计划：" + checkListBean.getPlan_name() + "" +
                    "\n" + "检查人：" + checkListBean.getUser_info().getReal_name() + "(" + checkListBean.getUser_info().getTelephone() + ")" +
                    "\n" + "检查项：" + checkListBean.getPro_name() + "\n";
        checkProjectAdapter.setEd_text(ed_text);
        if (group_positon != -1 && child_position != -1) {
            listview.expandGroup(group_positon);
            checkPlanListBean.get(group_positon).getDot_list().get(child_position).setChild_isExpanded(true);
            checkProjectAdapter.notifyDataSetChanged();
        }
    }

    public void initRightImageLog() {
        ImageView imageView = (ImageView) findViewById(R.id.rightImage);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) imageView.getLayoutParams();
        params.width = ViewGroup.LayoutParams.WRAP_CONTENT;
        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        imageView.setLayoutParams(params);
        imageView.setImageResource(R.drawable.white_dots);
//        findViewById(R.id.rightLayout).setVisibility(View.GONE);
    }

    /**
     * 获取检查计划中的检查项
     */
    protected void getPlanProInfo(final int group_positon, final int child_position) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        // 检查计划id
        params.addBodyParameter("plan_id", plan_id);
        // 检查计划id
        params.addBodyParameter("pro_id", pro_id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_PLAN_PRO_INFO,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<CheckListBean> bean = CommonJson.fromJson(responseInfo.result, CheckListBean.class);
                                if (bean.getState() != 0) {
                                    setHeadData(bean.getValues(), group_positon, child_position);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                                finish();
                            } finally {
                                closeDialog();
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            finish();
                        }
                    });
    }

    @Override
    public void childViewTopClick(int group_position, int child_position) {
        if (!checkPlanListBean.get(group_position).getDot_list().get(child_position).isChild_isExpanded()) {
            checkPlanListBean.get(group_position).getDot_list().get(child_position).setChild_isExpanded(true);
        } else {
            checkPlanListBean.get(group_position).getDot_list().get(child_position).setChild_isExpanded(false);
        }

        checkProjectAdapter.notifyDataSetChanged();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            int group_positon = data.getIntExtra("group_positon", -1);
            int child_positon = data.getIntExtra("child_positon", -1);
            getPlanProInfo(group_positon, child_positon);
            isFlushData = true;
        }
    }


    @Override
    public void onFinish(View view) {
        if (isFlushData) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        if (isFlushData) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}
