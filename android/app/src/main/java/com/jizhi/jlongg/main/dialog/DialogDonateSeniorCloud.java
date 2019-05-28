package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * 功能:活动期间赠送接口
 * 时间:2017年11月2日 14:51:37
 * 作者:hcs
 */

public class DialogDonateSeniorCloud extends Dialog implements View.OnClickListener {
    private Activity context;
    private String group_id;
    private DonateSeniorCloudInterfaceClickListener donateSeniorCloudInterfaceClickListener;

    @Override
    public void onClick(View v) {
        dismiss();
    }

    public DialogDonateSeniorCloud(Activity context, String group_id, DonateSeniorCloudInterfaceClickListener donateSeniorCloudInterfaceClickListener) {
        super(context, R.style.network_dialog_style);
        setContentView(R.layout.dialog_bottom_red);
        findViewById(R.id.redBtn).setOnClickListener(this);
        setCenterTextParameter(context);
        this.context = context;
        this.group_id = group_id;
        this.donateSeniorCloudInterfaceClickListener = donateSeniorCloudInterfaceClickListener;
        commendAttribute(true);
    }

    private void setCenterTextParameter(Context context) {
        TextView closeBtn = (TextView) findViewById(R.id.redBtn);
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) tv_content.getLayoutParams();
        int margin = DensityUtils.dp2px(context, 15);
        params.leftMargin = margin;
        params.rightMargin = margin;
        tv_content.setLayoutParams(params);
        tv_content.setTextSize(15);
        tv_content.setGravity(Gravity.LEFT);
        tv_content.setText(context.getString(R.string.donateSeniorCloud));
        closeBtn.setText("确认升级版本");
        closeBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DonateSeniorCloud();
                dismiss();
            }
        });
    }

    /**
     * 活动期间赠送接口
     */
    public void DonateSeniorCloud() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("group_id", group_id);
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DONATESANIORCLOUD, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Project> base = CommonJson.fromJson(responseInfo.result, Project.class);
                    if (base.getState() != 0) {
                        donateSeniorCloudInterfaceClickListener.donateSeniorCloudSuccess();
                    } else {
                        DataUtil.showErrOrMsg(context, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(context, context.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public interface DonateSeniorCloudInterfaceClickListener {
        public void donateSeniorCloudSuccess();
    }

}
