package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndSafeCheckDetailsAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckBean;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;


/**
 * CName:质量，安全检查大项中,小项列表详情页 2.3.0
 * User: hcs
 * Date: 2017-07-17
 * Time: 14:40
 */

public class MsgQualityAndSafeCheckDetailActivity extends BaseActivity implements MsgQualityAndSafeCheckDetailsAdapter.DelReplayInspectInfoListener, DiaLogTitleListener {
    private MsgQualityAndSafeCheckDetailActivity mActivity;
    private ExpandableListView listView;
    private QualityAndsafeCheckMsgBean gnInfo;
    private MsgQualityAndSafeCheckDetailsAdapter adapter;//检查计划适配器
    private TextView tv_name;//检查大项名称
    private List<QualityAndsafeCheckMsgBean> qualityAndsafeCheckMsgBeanList;//数据实体bean
    private boolean isBackFlush;//是否需要返回刷新

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_check_quality_and_safe_detail);
        initView();
        getIntentData();
        getChildInspectList(-1);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = MsgQualityAndSafeCheckDetailActivity.this;
        setTextTitle(R.string.r_check_detail);
        listView = (ExpandableListView) findViewById(R.id.listview);
        tv_name = (TextView) findViewById(R.id.tv_name);
        listView.setOnGroupExpandListener(new ExpandableListView.OnGroupExpandListener() {

            @Override
            public void onGroupExpand(int groupPosition) {
                for (int i = 0; i < adapter.getGroupCount(); i++) {
                    if (groupPosition != i) {
                        listView.collapseGroup(i);
                    }
                }
            }

        });

    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (QualityAndsafeCheckMsgBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        tv_name.setText(gnInfo.getInspect_name());
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, QualityAndsafeCheckMsgBean info) {
        Intent intent = new Intent(context, MsgQualityAndSafeCheckDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 检查记录
     */
    protected void getChildInspectList(final int position) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("gnInfo", gnInfo.getInsp_id());
        params.addBodyParameter("msg_type", gnInfo.getMsg_type());
        params.addBodyParameter("insp_id", gnInfo.getInsp_id());
        params.addBodyParameter("pu_inpsid", gnInfo.getPu_inpsid());
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_CHILDINSPECTLIST,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<QualityAndsafeCheckBean> beans = CommonJson.fromJson(responseInfo.result, QualityAndsafeCheckBean.class);

                                if (beans.getState() != 0) {
                                    qualityAndsafeCheckMsgBeanList = beans.getValues().getList();
                                    for (int i = 0; i < qualityAndsafeCheckMsgBeanList.size(); i++) {
                                        if (qualityAndsafeCheckMsgBeanList.get(i).getReply_list().size() <= 0) {
                                            LUtils.e(qualityAndsafeCheckMsgBeanList.get(i).getPrincipal_uid() + "-----111111--------------:" + UclientApplication.getUid(mActivity));
                                            if (qualityAndsafeCheckMsgBeanList.get(i).getPrincipal_uid().equals(UclientApplication.getUid(mActivity))) {
                                                ReplyInfo replyInfo = new ReplyInfo();
                                                replyInfo.setStatu(0);
                                                qualityAndsafeCheckMsgBeanList.get(i).getReply_list().add(replyInfo);
                                            }
                                        }
                                        LUtils.e(i + "----------------------:" + qualityAndsafeCheckMsgBeanList.get(i).getReply_list().size());
                                    }
                                    adapter = new MsgQualityAndSafeCheckDetailsAdapter(mActivity, qualityAndsafeCheckMsgBeanList, mActivity, gnInfo.getPu_inpsid(), gnInfo.getAll_pro_name());
                                    listView.setAdapter(adapter);
                                    adapter.setInspect_name(beans.getValues().getInspect_name());
                                    if (position != -1) {
                                        isBackFlush = true;
                                        listView.expandGroup(position);
                                    }
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
                                    finish();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                                mActivity.finish();
                            } finally {
                                closeDialog();
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            closeDialog();
                        }
                    });


    }

    /**
     * 删除
     */
    protected void delReplayInspectInfo(String id, final int position) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("reply_id", id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_REPLAYINSPECTINFO,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<QualityAndsafeCheckBean> beans = CommonJson.fromJson(responseInfo.result, QualityAndsafeCheckBean.class);

                                if (beans.getState() != 0) {
                                    getChildInspectList(position);
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
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
                            closeDialog();
                        }
                    });


    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            int position = data.getIntExtra("position", -1);
            if (position != -1) {
                getChildInspectList(position);
            }

        }
    }

    private DialogTips closeDialog;
    private String delId;
    private int pos;

    @Override
    public void delReplayInspectInfoClick(int position) {
        if (qualityAndsafeCheckMsgBeanList.get(position).getReply_list().size() > 0) {
            delId = qualityAndsafeCheckMsgBeanList.get(position).getReply_list().get(0).getId();
            pos = position;
            String desc = "你确定要删除该检查结果吗？";
            if (closeDialog == null) {
                closeDialog = new DialogTips(mActivity, this, desc, DialogTips.CLOSE_TEAM);
            }
            closeDialog.show();
        }
    }

    @Override
    public void clickAccess(int position) {
        delReplayInspectInfo(delId, pos);
    }

    @Override
    public void onBackPressed() {
        if (isBackFlush) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onBackPressed();
    }

    @Override
    public void onFinish(View view) {
        if (isBackFlush) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onFinish(view);
    }


}
