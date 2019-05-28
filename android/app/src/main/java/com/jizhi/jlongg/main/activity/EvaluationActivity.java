package com.jizhi.jlongg.main.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ListView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.EvaluationAdapter;
import com.jizhi.jlongg.main.bean.Evaluation;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.StarUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.ArrayList;
import java.util.List;

/**
 * 评价详情
 *
 * @author Xuj
 * @time 2015年11月16日 15:33:00
 */
public class EvaluationActivity extends BaseActivity implements OnScrollListener {

    private String TAG = getClass().getName();

    /**
     * 评论适配器
     */
    private EvaluationAdapter adapter;

    /**
     * 评论集合
     */
    private List<Evaluation> list;

    /**
     * 底部加载对话框
     */
    private View foot_view;

    /**
     * 分页number
     */
    private int pager = 1;

    /**
     * 当上拉数据小于10条的时候 则没有缓存数据了,为false则不在加载缓存数据
     */
    private boolean haveCashData = true;

    /**
     * 是否在加载缓存数据
     */
    private boolean isLoadCacheData = false;

    @ViewInject(R.id.listview)
    private ListView listView;


    public void onFinish(View view) {
        getRatingBar(R.id.overall).recycle();
        getRatingBar(R.id.credibility).recycle();
        getRatingBar(R.id.payspeed).recycle();
        getRatingBar(R.id.appetence).recycle();
        finish();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.evaluate);
        ViewUtils.inject(this); //Xutil必须调用的一句话
        initView();
        loadForeman();
    }


    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), getIntent().getStringExtra(Constance.BEAN_STRING));
        if (list == null) {
            list = new ArrayList<Evaluation>();
        }
        adapter = new EvaluationAdapter(this, list);
        foot_view = loadMoreDataView();
        listView.setAdapter(adapter);
        listView.setOnScrollListener(this);
    }

    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        int pid = getIntent().getIntExtra(Constance.PID, 0);
        if (pid == 0) { //工头-->我的收到评价 所需的参数
            params.addBodyParameter("from", "cms");
        } else {
            params.addBodyParameter("pid", pid + "");//项目id
        }
        params.addBodyParameter(Constance.PAGE, pager + "");
        return params;
    }


    /**
     * 加载工头评价详情  以及前10条 评价信息
     */
    public void loadForeman() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.APPRAISEDETAIL, params(),
                new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        LUtils.e(TAG, responseInfo.result);
                        try {
                            CommonJson<Evaluation> base = CommonJson.fromJson(responseInfo.result, Evaluation.class);
                            if (base.getState() != 0) {
                                findViewById(R.id.main).setVisibility(View.VISIBLE);
                                Evaluation bean = base.getValues();
                                getRatingBar(R.id.overall).setStarGrade(bean.getOverall()); //总体评价
                                getRatingBar(R.id.credibility).setStarGrade(bean.getCredibility()); //个人诚信
                                getRatingBar(R.id.payspeed).setStarGrade(bean.getPayspeed()); //结款速度
                                getRatingBar(R.id.appetence).setStarGrade(bean.getAppetence()); //带人态度
                                if (bean.getOverall() != 0) {
                                    getTextView(R.id.overall_text).setText(StarUtil.getStarText(bean.getOverall(), EvaluationActivity.this));
                                }
                                if (bean.getCredibility() != 0) {
                                    getTextView(R.id.credibility_text).setText(StarUtil.getStarText(bean.getCredibility(), EvaluationActivity.this));
                                }
                                if (bean.getPayspeed() != 0) {
                                    getTextView(R.id.payspeed_text).setText(StarUtil.getStarText(bean.getPayspeed(), EvaluationActivity.this));
                                }
                                if (bean.getAppetence() != 0) {
                                    getTextView(R.id.appetence_text).setText(StarUtil.getStarText(bean.getAppetence(), EvaluationActivity.this));
                                }
                                getTextView(R.id.has_been_evaluated).setText(String.format(getString(R.string.has_been_evaluated), bean.getCount()));//评价人数
                                if (bean.getContents() != null && bean.getContents().size() > 0) {
                                    list.addAll(bean.getContents());
                                    if (list.size() >= Constance.EVALUATION_PAGE_SIZE) {
                                        listView.addFooterView(foot_view, null, false);
                                    }
                                    adapter.notifyDataSetChanged();
                                    pager += 1;
                                }
                            } else {
                                DataUtil.showErrOrMsg(EvaluationActivity.this, base.getErrno(), base.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(EvaluationActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        }
                        closeDialog();
                    }
                });
    }


    /**
     * 查看评价详情
     */
    public void loadDetail() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.APPRAISEDETAIL, params(),
                new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        LUtils.e(TAG, responseInfo.result);

                        try {
                            CommonJson<Evaluation> base = CommonJson.fromJson(responseInfo.result, Evaluation.class);
                            if (base.getState() != 0) {
                                Evaluation bean = base.getValues();
                                if (bean.getContents() != null && bean.getContents().size() > 0) {
                                    list.addAll(bean.getContents());
                                    if (bean.getContents().size() < Constance.EVALUATION_PAGE_SIZE) {
                                        haveCashData = false;
                                        listView.removeFooterView(foot_view);
                                    }
                                } else {
                                    haveCashData = false;
                                    if (pager != 1) {
                                        listView.removeFooterView(foot_view);
                                    }
                                }
                                adapter.notifyDataSetChanged();
                                pager += 1;
                            } else {
                                DataUtil.showErrOrMsg(EvaluationActivity.this, base.getErrno(), base.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(EvaluationActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                        }
                        if (pager != 1) {
                            foot_view.setVisibility(View.GONE);
                        }
                        isLoadCacheData = false;
                    }

                    @Override
                    public void onFailure(HttpException error, String msg) {
                        printNetLog(msg, EvaluationActivity.this);
                        foot_view.setVisibility(View.GONE);
                        isLoadCacheData = false;
                    }
                });
    }


    private int lastItem;

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        lastItem = firstVisibleItem + visibleItemCount - 1;
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (lastItem < Constance.EVALUATION_PAGE_SIZE) { //当列表数据小于10条的时 不做上拉刷新数据
            return;
        }
        if (lastItem == list.size() && scrollState == OnScrollListener.SCROLL_STATE_IDLE) {
            if (!IsSupplementary.accessLogin(this)) {
                return;
            }
//			if (IsSupplementary.SupplementaryRegistrationWorker(this)) {
//				return;
//			}
            if (haveCashData && !isLoadCacheData) {
                isLoadCacheData = true;
                foot_view.setVisibility(View.VISIBLE);
                loadDetail();
            }
        }
    }
}
