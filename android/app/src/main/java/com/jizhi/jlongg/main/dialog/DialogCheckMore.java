package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.checkplan.NewOrUpdateCheckContentActivity;
import com.jizhi.jlongg.main.activity.checkplan.NewPlanActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.status.CommonJson;
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
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class DialogCheckMore extends PopupWindowExpand implements View.OnClickListener, DiaLogTitleListener {
    private Activity activity;
    private GroupDiscussionInfo gnInfo;
    private String desc;
    private DialogTips closeDialog;
    private int is_operate;//1:可以删除与分享
    private String plan_id;//计划id

    public DialogCheckMore(Activity activity, GroupDiscussionInfo gnInfo, String desc, int is_operate, String plan_id) {
        super(activity);
        this.activity = activity;
        this.desc = desc;
        this.gnInfo = gnInfo;
        this.is_operate = is_operate;
        this.plan_id = plan_id;
        setPopView();
        updateContent();
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_check_more, null);
        setContentView(popView);
        setPopParameter();
    }

    public void updateContent() {
//        if (is_operate == 1) {
        popView.findViewById(R.id.tv_edit).setOnClickListener(this);
        popView.findViewById(R.id.tv_del).setOnClickListener(this);
        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);
//            popView.findViewById(R.id.tv_edit).setVisibility(View.VISIBLE);
//            popView.findViewById(R.id.tv_del).setVisibility(View.VISIBLE);
//            popView.findViewById(R.id.view_1).setVisibility(View.VISIBLE);
//            popView.findViewById(R.id.view_2).setVisibility(View.VISIBLE);
//        } else {
//            popView.findViewById(R.id.tv_edit).setVisibility(View.GONE);
//            popView.findViewById(R.id.tv_del).setVisibility(View.GONE);
//            popView.findViewById(R.id.view_1).setVisibility(View.GONE);
//            popView.findViewById(R.id.view_2).setVisibility(View.GONE);
//        }
//        popView.findViewById(R.id.tv_share).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_edit: //编辑
                NewPlanActivity.actionStart(activity, gnInfo.getGroup_id(), gnInfo.getGroup_name(), Integer.parseInt(plan_id), NewOrUpdateCheckContentActivity.UPDATE_CHECK);
                break;
            case R.id.tv_del: //删除
                if (closeDialog == null) {
                    closeDialog = new DialogTips(activity, this, desc, DialogTips.CLOSE_TEAM);
                }
                closeDialog.show();
                break;
        }
        dismiss();
    }


    /**
     * 删除检查计划
     */
    protected void delInspectplan() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("plan_id", plan_id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_INSPECTPLAN,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                                if (bean.getState() != 0) {

                                    activity.setResult(Constance.RESULTCODE_FINISH, activity.getIntent());
                                    activity.finish();
                                } else {
                                    DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
//                                if (null != customProgress) {
//                                    customProgress.dismiss();
//                                }
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
//                            if (null != customProgress) {
//                                customProgress.dismiss();
//                            }
                        }
                    });
    }

    @Override
    public void clickAccess(int position) {
        delInspectplan();
    }
}