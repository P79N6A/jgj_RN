package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.dialog.DiaLogRedProgress;
import com.jizhi.jlongg.main.dialog.DiaLogRedProgressSuccesss;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 功能:新增同步
 * 时间:2018年5月4日16:33:22
 * 作者:xuj
 */

public class AddSyncActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 同步项目,同步对象名称
     */
    private TextView syncProjectName, syncPersonText;
    /**
     * 同步对象id,同步对象名称,同步对象id
     */
    private String pid, proName, uid;
    /**
     * 是否能点击同步对象
     * true表示能，false表示不能
     */
    private boolean canClickSyncPerson;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param id      1：同步记工记账;2:同步记工
     */
    public static void actionStart(Activity context, String id) {
        Intent intent = new Intent(context, AddSyncActivity.class);
        intent.putExtra(Constance.ID, id);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param id      1：同步记工记账;2:同步记工
     * @param uid     用户id主要是系统消息里面使用
     * @param msgId   消息id,如果是通过同步消息同步则需要传该参数，需要更新原来的消息内容
     */
    public static void actionStart(Activity context, String id, String uid, String userName, String msgId) {
        Intent intent = new Intent(context, AddSyncActivity.class);
        intent.putExtra(Constance.ID, id);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.MSG_ID, msgId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_sync);
        initView();
    }


    private void initView() {
        syncProjectName = getTextView(R.id.syncProjectName);
        syncPersonText = getTextView(R.id.syncPersonText);
        uid = getIntent().getStringExtra(Constance.UID);
        String id = getIntent().getStringExtra(Constance.ID);
        setTextTitle(id.equals("1") ? R.string.add_sync_record_account : R.string.add_sync_account);
        //如果uid不为空的话，表示从系统消息里面点进来的，那么同步对象则不能选择
        if (!TextUtils.isEmpty(uid)) {
            findViewById(R.id.syncPersonIcon).setVisibility(View.INVISIBLE);
            findViewById(R.id.syncPersonLayout).setClickable(false);
            Utils.setBackGround(findViewById(R.id.syncPersonLayout), getResources().getDrawable(R.color.white));
        } else {
            canClickSyncPerson = true;
        }
        syncPersonText.setText(getIntent().getStringExtra(Constance.USERNAME));
        getButton(R.id.red_btn).setText("立即同步");
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.syncProjectLayout: //同步项目
                SyncSelecteProjectActivity.actionStart(this, pid);
                break;
            case R.id.syncPersonLayout: //同步对象
                if (!canClickSyncPerson) {
                    return;
                }
                AddSyncPersonActivity.actionStart(this, 1);
                break;
            case R.id.red_btn: //立即同步
                if (TextUtils.isEmpty(proName) || TextUtils.isEmpty(pid)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请选择同步项目", CommonMethod.ERROR);
                    return;
                }
                if (TextUtils.isEmpty(uid)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请选择同步对象", CommonMethod.ERROR);
                    return;
                }
                syncNow();
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 1) { //添加同步对象成功
            if (data != null) {
                PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                syncPersonText.setText(personBean.getReal_name());
                uid = personBean.getTarget_uid();
            }
        } else if (resultCode == 2) {//添加同步项目成功
            if (data != null) {
                pid = data.getStringExtra(Constance.PRO_ID);
                proName = data.getStringExtra(Constance.PRONAME);
                syncProjectName.setText(proName);
            }
        }
    }

    /**
     * 立即同步
     */
    public void syncNow() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        //项目 格式： “11404,1,中建投峰汇中心;11404,2,福年广场项目” (target_uid,pid,pro_name)
        params.addBodyParameter("pro_info", uid + "," + pid + "," + proName);
        params.addBodyParameter("sync_type", getIntent().getStringExtra(Constance.ID));
        params.addBodyParameter("msg_id", getIntent().getStringExtra(Constance.MSG_ID)); //消息id,如果是通过同步消息同步则需要传该参数，需要更新原来的消息内容
        String httpUrl = NetWorkRequest.SYNCPRO;
        CommonHttpRequest.commonRequest(this, httpUrl, MessageBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final MessageBean messageBean = (MessageBean) object;
                if (messageBean != null) {
                    DiaLogRedProgress dialog = new DiaLogRedProgress(AddSyncActivity.this, new DiaLogRedProgressSuccesss.OnLoadCompleteListener() {
                        @Override
                        public void complete() { //动画执行完毕的回调
                            Intent intent = getIntent();
                            intent.putExtra(Constance.BEAN_CONSTANCE, messageBean);
                            setResult(Constance.SYNC_SUCCESS, intent);
                            finish();
                        }
                    });
                    dialog.show();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}
