package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * 功能: 修改整改措施
 * 作者：胡常生
 * 时间: 2018年1月17日 10:12:12
 */
public class QualityAndSafeChangeStepActivity extends BaseActivity {
    private QualityAndSafeChangeStepActivity mActivity;
    private EditText ed_desc;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_message_step);
        initView();
    }

    /**
     * initView
     */
    public void initView() {
        mActivity = QualityAndSafeChangeStepActivity.this;
        ed_desc = (EditText) findViewById(R.id.ed_desc);
        String text = getIntent().getStringExtra(Constance.CONTEXT);
        if (!TextUtils.isEmpty(text)) {
            ed_desc.setText(text);
            ed_desc.setSelection(text.length() );
        }

        SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
        SetTitleName.setTitle(findViewById(R.id.title), "整改措施");
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                modifyQualitySafe();

            }
        });
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context 上下文
     */
    public static void actionStart(Activity context, String msg_id, String msg_type, String text) {
        Intent intent = new Intent(context, QualityAndSafeChangeStepActivity.class);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.MSG_TYPE, msg_type);
        intent.putExtra(Constance.CONTEXT, text);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }


    /**
     * 修改整改措施
     */
    protected void modifyQualitySafe() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("msg_steps", ed_desc.getText().toString() + "");
        params.addBodyParameter("msg_id", getIntent().getStringExtra(Constance.MSG_ID));
        params.addBodyParameter("msg_type", getIntent().getStringExtra(Constance.MSG_TYPE));
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFY_QUALITY_AND_SAFE,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                                if (bean.getState() != 0) {
                                    setResult(Constance.REQUEST, getIntent());
                                    finish();
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

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            closeDialog();
                            finish();
                        }
                    });
    }

}
