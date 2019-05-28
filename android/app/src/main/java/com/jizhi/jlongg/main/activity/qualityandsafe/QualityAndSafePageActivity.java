package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.PayHintActivity;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.QualityAndSafeIndex;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;


/**
 * CName:质量，安全首页2.3.4
 * User: hcs
 * Date: 2017-11-17
 * Time: 13:17
 */

public class QualityAndSafePageActivity extends BaseActivity implements View.OnClickListener {
    private QualityAndSafePageActivity mActivity;
    /*组信息*/
    private GroupDiscussionInfo gnInfo;
    private String msg_type;
    //待整改,待复查，待我整改，待我复查，我提供的；
    private TextView tv_rectification, tv_review, tv_me_rectification, tv_me_review, tv_me_submit;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quality_and_safe_page);
        registerFinishActivity();
        getIntentData();
        initView();
        getQualitySafeIndex();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msgType) {
        Intent intent = new Intent(context, QualityAndSafePageActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        msg_type = getIntent().getStringExtra(Constance.MSG_TYPE);
        if (gnInfo.getIs_closed() == 1) {
            findViewById(R.id.lin_send).setVisibility(View.GONE);
            findViewById(R.id.img_close).setVisibility(View.VISIBLE);
            Utils.setBackGround(findViewById(R.id.img_close), gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? getResources().getDrawable(R.drawable.team_closed_icon) : getResources().getDrawable(R.drawable.group_closed_icon));
        }
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = QualityAndSafePageActivity.this;
        LUtils.e("-------------:" + msg_type);
        if (msg_type.equals(MessageType.MSG_QUALITY_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.messsage_quality));
            SetTitleName.setTitle(findViewById(R.id.tv_send), getString(R.string.release_quality_question));
        } else if (msg_type.equals(MessageType.MSG_SAFE_STRING)) {
            LUtils.e("--------22-----:" + msg_type);
            SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.messsage_safety));
            SetTitleName.setTitle(findViewById(R.id.tv_send), getString(R.string.release_safe_question));
        }
        tv_rectification = findViewById(R.id.tv_rectification);
        tv_review = findViewById(R.id.tv_review);
        tv_me_rectification = findViewById(R.id.tv_me_rectification);
        tv_me_review = findViewById(R.id.tv_me_review);
        tv_me_submit = findViewById(R.id.tv_me_submit);
        findViewById(R.id.title).setOnClickListener(this);

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.lin_rectification:
                //待整改
                QualityAndSafeListActivity.actionStart(mActivity, gnInfo, msg_type, 1, 1, null, "待整改");
                break;
            case R.id.lin_review:
                //待复查
                QualityAndSafeListActivity.actionStart(mActivity, gnInfo, msg_type, 2, 2, null, "待复查");
                break;
            case R.id.lin_complete:
                //已完成
                QualityAndSafeListActivity.actionStart(mActivity, gnInfo, msg_type, 3, 3, null, "已完成");
                break;
            case R.id.lin_me_rectification:
                //待我整改
                QualityAndSafeListActivity.actionStart(mActivity, gnInfo, msg_type, 1, 4, UclientApplication.getUid(mActivity), "待我整改");
                //带我整改红点
                findViewById(R.id.view_circle_me_rectification).setVisibility(View.GONE);
                break;
            case R.id.lin_me_review:
                //待我复查
                QualityAndSafeListActivity.actionStart(mActivity, gnInfo, msg_type, 2, 5, UclientApplication.getUid(mActivity), "待我复查");
                findViewById(R.id.view_circle_me_review).setVisibility(View.GONE);
                break;
            case R.id.lin_me_submit:
                //我提交的
                QualityAndSafeListActivity.actionStart(mActivity, gnInfo, msg_type, 0, 6, UclientApplication.getUid(mActivity), "我提交的");
                break;
            case R.id.btn_send:
                //发质量安全问题
                //发布
                if (MessageUtils.isCloseGroupAndTeam(gnInfo, mActivity)) {
                    return;
                }
                ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, msg_type.equals(MessageType.MSG_SAFE_STRING) ? MessageType.MSG_SAFE_STRING : MessageType.MSG_QUALITY_STRING, null);
                break;
            case R.id.title:
                if (msg_type.equals(MessageType.MSG_QUALITY_STRING)) {
                    if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                        HelpCenterUtil.actionStartHelpActivity(QualityAndSafePageActivity.this, 180);
                    } else {
                        HelpCenterUtil.actionStartHelpActivity(QualityAndSafePageActivity.this, 196);
                    }

                } else if (msg_type.equals(MessageType.MSG_SAFE_STRING)) {
                    if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                        HelpCenterUtil.actionStartHelpActivity(QualityAndSafePageActivity.this, 181);
                    } else {
                        HelpCenterUtil.actionStartHelpActivity(QualityAndSafePageActivity.this, 197);
                    }
                }
                break;
            case R.id.lin_statistics:
                //统计
                if (gnInfo.getIs_senior() == 0 && gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                    if (msg_type.equals(MessageType.MSG_QUALITY_STRING)) {
                        //质量统计
                        PayHintActivity.actionStart(mActivity, "质量统计", gnInfo.getGroup_id(), gnInfo.getIs_buyed(), NetWorkRequest.HELPDETAIL + 104);
                    } else if (msg_type.equals(MessageType.MSG_SAFE_STRING)) {
                        //安全统计
                        PayHintActivity.actionStart(mActivity, "安全统计", gnInfo.getGroup_id(), gnInfo.getIs_buyed(), NetWorkRequest.HELPDETAIL + 103);
                    }
                    return;
                }
                //统计
                String uri = NetWorkRequest.STCHARTS + "group_id=" + gnInfo.getGroup_id() + "&class_type=" + gnInfo.getClass_type() + "&msg_type=" + msg_type;
                X5WebViewActivity.actionStart(mActivity, uri);
                break;

        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            Intent intent = new Intent();
            intent.putExtra(Constance.BEAN_CONSTANCE, data.getSerializableExtra(Constance.BEAN_CONSTANCE));
            setResult(Constance.CLICK_SINGLECHAT, intent);
            finish();

            return;
        }
        getQualitySafeIndex();
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.SELECTED_ACTOR) {
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        } else if (requestCode == Constance.REQUEST_WEB && resultCode == Constance.REQUEST_WEB) {
            gnInfo.setIs_senior(1);
            //统计
            String uri = NetWorkRequest.STCHARTS + "group_id=" + gnInfo.getGroup_id() + "&class_type=" + gnInfo.getClass_type() + "&msg_type=" + msg_type;
            X5WebViewActivity.actionStart(mActivity, uri);
        }
    }

    /**
     * 质量/安全首页
     */
    protected void getQualitySafeIndex() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        // 检查计划id
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("msg_type", msg_type);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_QUALITYSAFEINDEX,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<QualityAndSafeIndex> bean = CommonJson.fromJson(responseInfo.result, QualityAndSafeIndex.class);
                            if (bean.getState() != 0) {
                                //待整改,待复查，待我整改，待我复查，我提交的;
                                if (!TextUtils.isEmpty(bean.getValues().getIs_statu_rect())) {
                                    //待整改
                                    tv_rectification.setText("待整改(" + bean.getValues().getIs_statu_rect() + ")");
                                } else {
                                    tv_rectification.setText("待整改");
                                }

                                if (!TextUtils.isEmpty(bean.getValues().getIs_statu_check())) {
                                    //待复查
                                    tv_review.setText("待复查(" + bean.getValues().getIs_statu_check() + ")");
                                } else {
                                    tv_review.setText("待复查");
                                }
                                if (!TextUtils.isEmpty(bean.getValues().getRect_me())) {
                                    //待我整改
                                    tv_me_rectification.setText("待我整改(" + bean.getValues().getRect_me() + ")");
                                } else {
                                    tv_me_rectification.setText("待我整改");
                                }
                                if (!TextUtils.isEmpty(bean.getValues().getCheck_me())) {
                                    //待我整改
                                    tv_me_review.setText("待我复查(" + bean.getValues().getCheck_me() + ")");
                                } else {
                                    tv_me_review.setText("待我复查");
                                }

                                if (!TextUtils.isEmpty(bean.getValues().getOffer_me())) {
                                    //待我整改
                                    tv_me_submit.setText("我提交的(" + bean.getValues().getOffer_me() + ")");
                                } else {
                                    tv_me_submit.setText("我提交的");
                                }
                                if (bean.getValues().getRect_me_red() == 1) {
                                    //带我整改红点
                                    findViewById(R.id.view_circle_me_rectification).setVisibility(View.VISIBLE);
                                } else {
                                    //带我整改红点
                                    findViewById(R.id.view_circle_me_rectification).setVisibility(View.GONE);
                                }
                                if (bean.getValues().getCheck_me_red() == 1) {
                                    //带我复查
                                    findViewById(R.id.view_circle_me_review).setVisibility(View.VISIBLE);
                                } else {
                                    findViewById(R.id.view_circle_me_review).setVisibility(View.GONE);
                                }


                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
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
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }

}
