package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.EvaluateDetailAdapter;
import com.jizhi.jlongg.main.adpter.EvaluateTagAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.EvaluateBillInfo;
import com.jizhi.jlongg.main.bean.EvaluateDetailInfo;
import com.jizhi.jlongg.main.bean.EvaluateInfo;
import com.jizhi.jlongg.main.bean.EvaluateTag;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.FlowTagView;
import com.jizhi.jongg.widget.PageListView;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.jizhi.jongg.widget.StarBar;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 班组长、工人评价详情
 *
 * @author Xuj
 * @time 2018年3月13日14:42:30
 * @Version 1.0
 */
public class PersonEvaluateInfoActivity extends BaseActivity implements View.OnClickListener, PullRefreshCallBack {
    /**
     * 头像
     */
    private RoundeImageHashCodeTextLayout headImageView;
    /**
     * 班组长,工人名称、记账人名称、电话号码
     */
    private TextView userNameText, recordNameText;
    /**
     * 上班时长、加班时长、借支笔数、结算笔数
     */
    private TextView manhourText, overTimeText, borrowCountText, balanceCountText;
    /**
     * 点工金额，借支金额，结算金额，未结金额
     */
    private TextView littleWorkAmountText, borrowTotalText, balanceTotalText, unBalanceTotalText;
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


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String uid, String headImage, String userName, String telphone) {
        Intent intent = new Intent(context, PersonEvaluateInfoActivity.class);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.TELEPHONE, telphone);
        intent.putExtra(Constance.HEAD_IMAGE, headImage);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_bottom_red_btn);
        initView();
        getEvaluateInfo();
        registerReceiver();
    }


    private void initView() {
        String roler = UclientApplication.getRoler(getApplicationContext());
        setTextTitle(roler.equals(Constance.ROLETYPE_FM) ? R.string.worker_info : R.string.foreman_info);

        View headView = getLayoutInflater().inflate(R.layout.evaluate_head_new, null); // 加载对话框

        TextView star1Text = (TextView) headView.findViewById(R.id.star1Text);
        TextView star2Text = (TextView) headView.findViewById(R.id.star2Text);

        star1Text.setText(roler.equals(Constance.ROLETYPE_FM) ? "工作态度" : "没有拖欠工资");
        star2Text.setText(roler.equals(Constance.ROLETYPE_FM) ? "专业技能" : "没有辱骂工人");


        TextView itemTitleName = (TextView) headView.findViewById(R.id.itemTitleName);

        pageListView = (PageListView) findViewById(R.id.listView);
        headImageView = (RoundeImageHashCodeTextLayout) headView.findViewById(R.id.headImageView);
        userNameText = (TextView) headView.findViewById(R.id.userNameText);
        recordNameText = (TextView) headView.findViewById(R.id.recordNameText);
        TextView telText = (TextView) headView.findViewById(R.id.telText);

        manhourText = (TextView) headView.findViewById(R.id.manhourText);
        overTimeText = (TextView) headView.findViewById(R.id.overTimeText);
        borrowCountText = (TextView) headView.findViewById(R.id.borrowCountText);
        balanceCountText = (TextView) headView.findViewById(R.id.balanceCountText);
        littleWorkAmountText = (TextView) headView.findViewById(R.id.littleWorkAmountText);
        borrowTotalText = (TextView) headView.findViewById(R.id.borrowTotalText);
        balanceTotalText = (TextView) headView.findViewById(R.id.balanceTotalText);
        unBalanceTotalText = (TextView) headView.findViewById(R.id.unBalanceTotalText);
        wantCooperationRate = (TextView) headView.findViewById(R.id.wantCooperationRate);

        workingAttitudeStarBar = (StarBar) headView.findViewById(R.id.workingAttitudeStarBar);
        professionalSkillsStarBar = (StarBar) headView.findViewById(R.id.professionalSkillsStarBar);
        degreeOfReliabilitystarBar = (StarBar) headView.findViewById(R.id.degreeOfReliabilitystarBar);

        tagView = (FlowTagView) headView.findViewById(R.id.tagView);
        Button goEvaluateBtn = getButton(R.id.red_btn);
        goEvaluateBtn.setText("去评价");
        pageListView.addHeaderView(headView, null, false);
        pageListView.setAdapter(null);

        itemTitleName.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? R.string.workers : R.string.foremans);

        findViewById(R.id.bottom_layout).setVisibility(View.GONE);

        pageListView.setPullUpToRefreshView(loadMoreDataView()); //设置上拉刷新组件
        pageListView.setPullRefreshCallBack(this); //设置上拉、下拉刷新回调


        telText.setText(getIntent().getStringExtra(Constance.TELEPHONE)); //设置电话号码
        headImageView.setView(getIntent().getStringExtra(Constance.HEAD_IMAGE), getIntent().getStringExtra(Constance.USERNAME), 0); //设置头像
        userNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置名称
        recordNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置记账对象名称
    }

    /**
     * 获取评价信息
     */
    private void getEvaluateInfo() {
        String httpUrl = NetWorkRequest.EVALUATE_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID));
        CommonHttpRequest.commonRequest(this, httpUrl, EvaluateInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                EvaluateInfo evaluateInfo = (EvaluateInfo) object;
                if (evaluateInfo == null) {
                    finish();
                    return;
                }
                EvaluateBillInfo billInfo = evaluateInfo.getBill_info(); //记账信息
                if (billInfo != null) {
                    findViewById(R.id.billInfoItem).setVisibility(View.VISIBLE);
                    findViewById(R.id.billInfoLayout).setVisibility(View.VISIBLE);
                    findViewById(R.id.billInfoTitleLayout).setVisibility(View.VISIBLE);
                    if (billInfo.getWork_type() != null) { //点工
                        manhourText.setText(RecordUtils.getNormalWorkUtil(billInfo.getWork_type().getWorking_hours(), true, true));
                        overTimeText.setText(RecordUtils.getOverTimeWorkUtil(billInfo.getWork_type().getOvertime_hours(), true, true));
                        littleWorkAmountText.setText(billInfo.getWork_type().getAmounts()); //设置点工金额
                    }
//                    if (billInfo.getContract_type() != null) { //包工
//                        contractorWorkAmountText.setText(billInfo.getContract_type().getAmounts()); //设置包工金额
//                    }
                    if (billInfo.getExpend_type() != null) { //借支
                        borrowCountText.setText(String.format(getString(R.string.borrow_params), (int) billInfo.getExpend_type().getTotal()));
                        borrowTotalText.setText(billInfo.getExpend_type().getAmounts()); //设置借支金额
                    }
                    if (billInfo.getBalance_type() != null) { //结算
                        balanceCountText.setText(String.format(getString(R.string.balance_params), (int) billInfo.getBalance_type().getTotal()));
                        balanceTotalText.setText(billInfo.getBalance_type().getAmounts());//设置结算金额
                    }
                    if (billInfo.getUnbalance_type() != null) {//未结
                        unBalanceTotalText.setText(billInfo.getUnbalance_type().getAmounts());
                    }
                } else {
                    findViewById(R.id.billInfoTitleLayout).setVisibility(View.GONE);
                    findViewById(R.id.billInfoItem).setVisibility(View.GONE);
                    findViewById(R.id.billInfoLayout).setVisibility(View.GONE);
                }
                int percentage = (int) (evaluateInfo.getWant_cooperation_rate() * 100); //百分比

                String roler = UclientApplication.getRoler(getApplicationContext());
                String tips = roler.equals(Constance.ROLETYPE_FM) ? "雇佣他" : "为他工作";
                wantCooperationRate.setText(Utils.setSelectedFontChangeColor(percentage + "%的人愿意再次" + tips, percentage + "%",
                        Color.parseColor("#d7252c"),false));
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
                    tagView.setAdapter(new EvaluateTagAdapter(PersonEvaluateInfoActivity.this, tagList));
                }
//                findViewById(R.id.bottom_layout).setVisibility(evaluateInfo.getCan_evaluate() == 1 ? View.VISIBLE : View.GONE);
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


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.editorNameText: //编辑姓名
//                AddWorkerActivity.actionStart(this, true, getIntent().getStringExtra(Constance.USERNAME), getIntent().getStringExtra(Constance.TELEPHONE),false);
//                DiaLogUpdateAccountName diaLogUpdateAccountName = new DiaLogUpdateAccountName(this, new IsSupplementary.SupplementNameListener() {
//                    @Override
//                    public void clickSupplementName(String name) {
//                        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//                        if (webSocket != null) {
//                            BaseRequestParameter baseRequestParameter = new BaseRequestParameter();
//                            baseRequestParameter.setAction(WebSocketConstance.ACTION_SET_COMMENT);
//                            baseRequestParameter.setCtrl(WebSocketConstance.CTRL_IS_CHAT);
//                            baseRequestParameter.setUid(getIntent().getStringExtra(Constance.UID));
//                            baseRequestParameter.setComment(name);
//                            webSocket.requestServerMessage(baseRequestParameter, PersonEvaluateInfoActivity.this);
//                        }
//                    }
//                });
//                diaLogUpdateAccountName.openKeyBoard();
//                diaLogUpdateAccountName.show();
                break;
            case R.id.red_btn: //去评价
                //是否已完善了姓名
//                IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
//                    @Override
//                    public void onSuccess() {
//                        goEvaluateActivity();
//                    }
//                });
                break;
            case R.id.billInfoLayout: //记账信息
//                StatisticalWorkSecondActivity.actionStart(PersonEvaluateInfoActivity.this,
//                        null, null, null, null,
//                        null, null, null, StatisticalWorkSecondActivity.TYPE_FROM_WORKER,
//                        getIntent().getStringExtra(Constance.UID), "person",
//                        false, false, true, false);
//                StatisticalWorkByMonthActivity.actionStart(this, null, null, "person", getIntent().getStringExtra(Constance.USERNAME), getIntent().getStringExtra(Constance.UID), null, false);
                break;
        }
    }

    private void goEvaluateActivity() {
//        Intent intent = getIntent();
//        String uid = intent.getStringExtra(Constance.UID);
//        String headImage = intent.getStringExtra(Constance.HEAD_IMAGE);
//        String userName = intent.getStringExtra(Constance.USERNAME);
//        GoEvaluateActivity.actionStart(this, uid, headImage, userName);
    }

    /**
     * 注册广播
     */
    public void registerReceiver() {
        IntentFilter filter = new IntentFilter();
//        filter.addAction(WebSocketConstance.ACTION_SET_COMMENT); //设置备注名称
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }


    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
//            if (action.equals(WebSocketConstance.ACTION_SET_COMMENT)) { //设置备注名称
//                UserInfo userInfo = (UserInfo) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                getIntent().putExtra(Constance.USERNAME, userInfo.getComment());
//                headImageView.setView(getIntent().getStringExtra(Constance.HEAD_IMAGE), getIntent().getStringExtra(Constance.USERNAME), 0); //设置头像
//                userNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置名称
//                recordNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置记账对象名称
//                PersonEvaluateInfoActivity.this.setResult(Constance.REFRESH);
//            }
        }
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getEvaluateListInfo();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getEvaluateListInfo();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.REFRESH) {
            getEvaluateInfo();
        }
//        else if (resultCode == Constance.MANUAL_ADD_OR_EDITOR_PERSON) {
//            String userName = data.getStringExtra(Constance.USERNAME);
//            editorName(userName);
//        }
    }

    /**
     * 编辑姓名
     *
     * @param userName
     */
    private void editorName(String userName) {
        if (TextUtils.isEmpty(userName)) {
            return;
        }
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            BaseRequestParameter baseRequestParameter = new BaseRequestParameter();
//            baseRequestParameter.setAction(WebSocketConstance.ACTION_SET_COMMENT);
//            baseRequestParameter.setCtrl(WebSocketConstance.CTRL_IS_CHAT);
//            baseRequestParameter.setUid(getIntent().getStringExtra(Constance.UID));
//            baseRequestParameter.setComment(userName);
//            webSocket.requestServerMessage(baseRequestParameter, PersonEvaluateInfoActivity.this);
//        }
    }
}