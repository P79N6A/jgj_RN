package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.EvaluateDetailAdapter;
import com.jizhi.jlongg.main.adpter.EvaluateTagAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.EvaluateDetailInfo;
import com.jizhi.jlongg.main.bean.EvaluateInfo;
import com.jizhi.jlongg.main.bean.EvaluateTag;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.FlowTagView;
import com.jizhi.jongg.widget.PageListView;
import com.jizhi.jongg.widget.StarBar;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 评价详情
 *
 * @author Xuj
 * @time 2018年6月14日15:26:23
 * @Version 1.0
 */
public class EvaluationDetailActivity extends BaseActivity implements PullRefreshCallBack {

    /**
     * 启动当前Activity
     *
     * @param context
     * @param uid     当前评价人的id
     * @param roler   如果是从工作消息里面点进来的话 需要将评论人的角色传进来
     */
    public static void actionStart(Activity context, String uid, String roler) {
        Intent intent = new Intent(context, EvaluationDetailActivity.class);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.ROLE, roler);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 想再次合作的概率,客户端换算成百分比  *100%
     */
    private TextView wantCooperationRate;
    /**
     * 工作态度，专业技能，靠谱程度
     */
    private StarBar workingAttitudeStarBar, professionalSkillsStarBar, degreeOfReliabilitystarBar;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 标签
     */
    private FlowTagView tagView;
    /**
     * 列表适配器
     */
    private EvaluateDetailAdapter adapter;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pagelistview_no_swipe);
        initView();
        getEvaluateInfo();
    }


    private void initView() {
        setTextTitle(R.string.evaluation_details);
        String roler = UclientApplication.getRoler(getApplicationContext());

        View headView = getLayoutInflater().inflate(R.layout.evaluate_detail_head, null); // 加载对话框

        TextView star1Text = (TextView) headView.findViewById(R.id.star1Text);
        TextView star2Text = (TextView) headView.findViewById(R.id.star2Text);

        star1Text.setText(roler.equals(Constance.ROLETYPE_FM) ? "工作态度" : "没有拖欠工资");
        star2Text.setText(roler.equals(Constance.ROLETYPE_FM) ? "专业技能" : "没有辱骂工人");

        pageListView = (PageListView) findViewById(R.id.listView);

        wantCooperationRate = (TextView) headView.findViewById(R.id.wantCooperationRate);

        workingAttitudeStarBar = (StarBar) headView.findViewById(R.id.workingAttitudeStarBar);
        professionalSkillsStarBar = (StarBar) headView.findViewById(R.id.professionalSkillsStarBar);
        degreeOfReliabilitystarBar = (StarBar) headView.findViewById(R.id.degreeOfReliabilitystarBar);

        tagView = (FlowTagView) headView.findViewById(R.id.tagView);
        pageListView.addHeaderView(headView, null, false);
        pageListView.setAdapter(null);

        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        pageListView.setPullRefreshCallBack(this); //设置上拉、下拉刷新回调
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getEvaluateListInfo();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getEvaluateListInfo();
    }


    /**
     * 获取评价信息
     */
    private void getEvaluateInfo() {
        String httpUrl = NetWorkRequest.EVALUATE_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID));
        String evalutionRoler = getIntent().getStringExtra(Constance.ROLE); //如果是从工作消息里面点进来的话 需要将评论人的角色传进来
        if (!TextUtils.isEmpty(evalutionRoler)) {
            params.addBodyParameter("cur_role", evalutionRoler);
        }
        CommonHttpRequest.commonRequest(this, httpUrl, EvaluateInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                EvaluateInfo evaluateInfo = (EvaluateInfo) object;
                if (evaluateInfo == null) {
                    finish();
                    return;
                }
                String tips = UclientApplication.isForemanRoler(getApplicationContext()) ? "愿意再次雇佣他" : "愿意再次为他工作";
//                int percentage = (int) (evaluateInfo.getWant_cooperation_rate() * 100); //百分比
                //XX人参与评价，其中XX人愿意再次雇佣他（XX  前面取评价总人数，后面取选择愿意雇佣的人数）
                wantCooperationRate.setText(Html.fromHtml("<font color='#eb4e4e'>" + evaluateInfo.getEvaluate_pnum() +
                        "</font><font color='#000000'>人参与评价，其中</font><font color='#eb4e4e'>" + evaluateInfo.getWant_pnum() +
                        "</font><font color='#000000'>人" + tips + "</font>"));
                workingAttitudeStarBar.setStarMark(evaluateInfo.getAttitude_or_arrears());
                professionalSkillsStarBar.setStarMark(evaluateInfo.getProfessional_or_abuse());
                degreeOfReliabilitystarBar.setStarMark(evaluateInfo.getReliance_degree());
                ArrayList<EvaluateTag> tagList = evaluateInfo.getTag_list();

                if (tagList == null || tagList.size() == 0) {
                    tagView.setVisibility(View.GONE);
                    findViewById(R.id.tagViewLine).setVisibility(View.GONE);
                } else {
                    findViewById(R.id.tagViewLine).setVisibility(View.VISIBLE);
                    tagView.setVisibility(View.VISIBLE);
                    tagView.setAdapter(new EvaluateTagAdapter(EvaluationDetailActivity.this, tagList));
                }
                pageListView.setPageNum(1);
                getEvaluateListInfo();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 获取评价列表信息
     */
    private void getEvaluateListInfo() {
        String httpUrl = NetWorkRequest.EVALUATE_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID));
        params.addBodyParameter("pg", pageListView.getPageNum() + "");  //页码
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //每页显示多少条数据
        String evalutionRoler = getIntent().getStringExtra(Constance.ROLE); //如果是从工作消息里面点进来的话 需要将评论人的角色传进来
        if (!TextUtils.isEmpty(evalutionRoler)) {
            params.addBodyParameter("cur_role", evalutionRoler);
        }
        CommonHttpRequest.commonRequest(this, httpUrl, EvaluateDetailInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    ArrayList<EvaluateDetailInfo> list = (ArrayList<EvaluateDetailInfo>) object;
                    setAdapter(list);
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                    pageListView.loadOnFailure();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    private void setAdapter(List<EvaluateDetailInfo> list) {
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new EvaluateDetailAdapter(this, list);
            pageListView.setListViewAdapter(adapter); //设置适配器
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(list);//替换数据
            } else {
                adapter.addList(list); //添加数据
            }
        }
        pageListView.loadDataFinish(list);
    }


}
