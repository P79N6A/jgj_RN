package com.jizhi.jlongg.main.activity.check;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.CheckHostoryAdapter;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:检查记录2.3.4
 * User: hcs
 * Date: 2017-11-22
 * Time: 17:14
 */

public class CheckHistoryActivity extends BaseActivity implements CheckHostoryAdapter.CheckHistoryItemClick {
    private CheckHistoryActivity mActivity;
    /*组信息*/
    private CheckPlanListBean checkPlanListBean;
    /*listview*/
    private ListView listview;
    /*listview头部信息*/
    private View headerView;
    /*adapter*/
    private CheckHostoryAdapter checkHostoyrAdapter;
    private List<CheckPlanListBean> listBeen;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_insplan_check);
        getIntentData();
        initView();
        initHeadView();
        getInspectPlanLog();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, CheckPlanListBean info) {
        Intent intent = new Intent(context, CheckHistoryActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        checkPlanListBean = (CheckPlanListBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 初始化view
     */
    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), "检查记录");
        mActivity = CheckHistoryActivity.this;
        listview = (ListView) findViewById(R.id.listview);
        findViewById(R.id.rightImage).setVisibility(View.GONE);
    }

    /**
     * 初始化headView
     */
    private void initHeadView() {
        headerView = getLayoutInflater().inflate(R.layout.layout_head_check_history, null);
        listBeen = new ArrayList<>();
        listview.addHeaderView(headerView);
        checkHostoyrAdapter = new CheckHostoryAdapter(mActivity, listBeen, this);
        listview.setAdapter(checkHostoyrAdapter);
    }

    /**
     * 设置headView数据
     */
    private void setHeadData(CheckPlanListBean bean) {
        //检查计划
        TextView tv_check_name = (TextView) headerView.findViewById(R.id.tv_check_name);
        //检查项
        TextView tv_project_name = (TextView) headerView.findViewById(R.id.tv_project_name);
        //检查内容
        TextView tv_check_content = (TextView) headerView.findViewById(R.id.tv_check_content);
        //检查点
        TextView tv_s_project_name = (TextView) headerView.findViewById(R.id.tv_s_project_name);
        tv_check_name.setText(bean.getPlan_name());
        tv_project_name.setText(bean.getPro_name());
        tv_check_content.setText(bean.getContent_name());
        tv_s_project_name.setText(bean.getDot_name());
        listBeen = bean.getLog_list();
        checkHostoyrAdapter = new CheckHostoryAdapter(mActivity, listBeen, this);
        listview.setAdapter(checkHostoyrAdapter);
    }

    /**
     * 检查计划中记录
     */
    public void getInspectPlanLog() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("pro_id", checkPlanListBean.getPro_id() + "");//检查项id
        params.addBodyParameter("plan_id", checkPlanListBean.getPlan_id() + "");//检查计划id
        params.addBodyParameter("content_id", checkPlanListBean.getContent_id());//检查内容id
        params.addBodyParameter("dot_id", checkPlanListBean.getDot_id());//检查点id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_INSPECT_PLAN_LOG, params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<CheckPlanListBean> bean = CommonJson.fromJson(responseInfo.result, CheckPlanListBean.class);
                                if (bean.getState() != 0) {
                                    setHeadData(bean.getValues());
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                closeDialog();
                            }
                        }
                    }
        );
    }


    @Override
    public void itemClick(int position) {
        if (listBeen.get(position).isChild_isExpanded()) {
            listBeen.get(position).setChild_isExpanded(false);
        } else {
            listBeen.get(position).setChild_isExpanded(true);
        }
        checkHostoyrAdapter.notifyDataSetChanged();
    }
}
