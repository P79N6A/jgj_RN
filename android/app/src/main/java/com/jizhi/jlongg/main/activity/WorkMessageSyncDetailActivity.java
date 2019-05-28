package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 功能: 工作消息查看同步消息详情
 * 作者：xuj
 * 时间:2018年10月17日16:15:32
 */
public class WorkMessageSyncDetailActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 同步类型
     */
    private String syncType;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param syncType     同步类型
     * @param msgId        消息id
     * @param realName     同步人名称
     * @param msgSenderUid 发送人id
     */
    public static void actionStart(Activity context, String syncType, String msgId, String realName, String msgSenderUid) {
        Intent intent = new Intent(context, WorkMessageSyncDetailActivity.class);
        intent.putExtra("sync_type", syncType);
        intent.putExtra(Constance.MSG_ID, msgId);
        intent.putExtra(Constance.USERNAME, realName);
        intent.putExtra(Constance.UID, msgSenderUid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.work_message_sync_detail);
        initView();
    }


    private void initView() {
        syncType = getIntent().getStringExtra("sync_type");
        ImageView imageView = getImageView(R.id.detail_image);

        TextView leftBtn = getTextView(R.id.left_btn);
        TextView rightBtn = getTextView(R.id.right_btn);

        switch (syncType) {
            case MessageType.DEMAND_SYNC_BILL: //记工同步请求
                setTextTitle(R.string.record_account_request);
                leftBtn.setText("拒绝");
                rightBtn.setText("同步");
                Utils.setBackGround(leftBtn, getResources().getDrawable(R.drawable.draw_sk_666666_5radius));
                Utils.setBackGround(rightBtn, getResources().getDrawable(R.drawable.draw_eb4e4e_5radius));
                imageView.setImageResource(R.drawable.sync_account_detail_icon);
                break;
            case MessageType.REQUIRE_SYNC_PROJECT: //记工记账同步请求
                setTextTitle(R.string.request_sync_project);
                leftBtn.setText("拒绝");
                rightBtn.setText("同步");
                Utils.setBackGround(leftBtn, getResources().getDrawable(R.drawable.draw_sk_666666_5radius));
                Utils.setBackGround(rightBtn, getResources().getDrawable(R.drawable.draw_eb4e4e_5radius));
                imageView.setImageResource(R.drawable.sync_request_detail_icon);
                break;
        }
    }

    @Override
    public void onClick(View v) {
        String msgId = getIntent().getStringExtra(Constance.MSG_ID);
        switch (v.getId()) {
            case R.id.left_btn: //拒绝按钮
                refuseSync(msgId, getIntent().getStringExtra(Constance.USERNAME));
                break;
            case R.id.right_btn: //同意按钮
                agreeSycn(msgId, getIntent().getStringExtra(Constance.UID));
                break;
        }
    }

    /**
     * 拒绝同步项目 或拒绝同步记账信息
     *
     * @param msgId    消息id
     * @param realName 同步人名称
     */
    private void refuseSync(final String msgId, String realName) {
        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(this, null, "你确定要拒绝同步项目给" + realName + "吗？",
                new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                        params.addBodyParameter(MessageType.MSG_ID, msgId);
                        CommonHttpRequest.commonRequest(WorkMessageSyncDetailActivity.this, NetWorkRequest.REFUSE_SYNC_PROJECT, MessageBean.class, CommonHttpRequest.OBJECT, params, true,
                                new CommonHttpRequest.CommonRequestCallBack() {
                                    @Override
                                    public void onSuccess(Object object) {
                                        Intent intent = getIntent();
                                        intent.putExtra(Constance.BEAN_CONSTANCE, (MessageBean) object);
                                        setResult(Constance.SYNC_SUCCESS, intent);
                                        finish();
                                    }

                                    @Override
                                    public void onFailure(HttpException error, String msg) {
                                    }
                                });
                    }
                });
        dialogLeftRightBtnConfirm.setRightBtnText("确认拒绝");
        dialogLeftRightBtnConfirm.show();
    }

    /**
     * 同意同步
     *
     * @param msgId        消息id
     * @param msgSenderUid 发消息发送者名称
     */
    public void agreeSycn(final String msgId, String msgSenderUid) {
        getUserInfoByUid(msgSenderUid, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                UserInfo userInfo = (UserInfo) object;
                if (userInfo != null && !TextUtils.isEmpty(userInfo.getReal_name())) {
                    String msgType = WorkMessageSyncDetailActivity.this.syncType;
                    if (MessageType.REQUIRE_SYNC_PROJECT.equals(msgType)) { //点击【同步】，界面跳转到“新增同步记工”界面；
                        AddSyncActivity.actionStart(WorkMessageSyncDetailActivity.this, "2", userInfo.getUid(), userInfo.getReal_name(), msgId);
                    } else if (MessageType.DEMAND_SYNC_BILL.equals(msgType)) { //点击【同步】，页面跳转到要求同步项目界面；
                        AddSyncActivity.actionStart(WorkMessageSyncDetailActivity.this, "1", userInfo.getUid(), userInfo.getReal_name(), msgId); //点击【同步】，界面跳转到“新增同步记工记账”界面;
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 根据uid获取用户信息
     *
     * @param uid
     */
    private void getUserInfoByUid(String uid, CommonHttpRequest.CommonRequestCallBack commonRequestCallBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_USER_INFO_BY_UID, UserInfo.class, CommonHttpRequest.OBJECT, params, true, commonRequestCallBack);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SYNC_SUCCESS) { //同步成功后的回调
            setResult(resultCode, data);
            finish();
        }
    }
}
