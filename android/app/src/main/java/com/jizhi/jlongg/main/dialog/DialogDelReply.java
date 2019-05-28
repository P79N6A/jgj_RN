package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
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
public class DialogDelReply extends PopupWindowExpand implements View.OnClickListener {
    private Activity activity;
    private CustomProgress customProgress;
    private String id;
    private String msg_type;
    private DelSuccessClickListener delSuccessClickListener;
    private int position;


    public DialogDelReply(Activity activity, String id, String msg_type, int position,DelSuccessClickListener delSuccessClickListener) {
        super(activity);
        this.activity = activity;
        this.id = id;
        this.msg_type = msg_type;
        this.position = position;
        this.delSuccessClickListener = delSuccessClickListener;
        setPopView();
        updateContent();
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_log_more, null);
        setContentView(popView);
        setPopParameter();
    }

    public void updateContent() {
        popView.findViewById(R.id.tv_edit).setVisibility(View.GONE);
        popView.findViewById(R.id.view_1).setVisibility(View.GONE);
        popView.findViewById(R.id.tv_del).setOnClickListener(this);
        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_del: //删除
                delReply();
                break;
        }
        dismiss();
    }

    /**
     * 删除质量安全
     */
    protected void delReply() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", id);
        params.addBodyParameter("msg_type", msg_type);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_REPLY_MSG,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<ReplyInfo> bean = CommonListJson.fromJson(responseInfo.result, ReplyInfo.class);
                                if (bean.getState() != 0) {
                                    CommonMethod.makeNoticeShort(activity, "删除成功", CommonMethod.SUCCESS);
                                    delSuccessClickListener.delClickSuccess(position);
                                } else {
                                    DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                if (null != customProgress) {
                                    customProgress.dismiss();
                                }
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            if (null != customProgress) {
                                customProgress.dismiss();
                            }
                        }
                    });
    }


    public void createCustomDialog() {
        if (customProgress != null) {
        } else {
            customProgress = new CustomProgress(activity);
            customProgress.show(activity, "请稍候…", false);
        }

    }

    public interface DelSuccessClickListener {
        void delClickSuccess(int position);
    }
}
