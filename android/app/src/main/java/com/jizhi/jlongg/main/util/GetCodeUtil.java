package com.jizhi.jlongg.main.util;

import android.app.Activity;

import com.google.gson.Gson;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * Created by Administrator on 2017/6/12 0012.
 */

public class GetCodeUtil {

    /**
     * 获取验证码
     *
     * @param telephone 电话
     * @param listener  加载回调
     */
    public static void getCode(final Activity context, String telephone, String type, final NetRequestListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("telph", telephone);
        params.addBodyParameter("type", type); //默认1 1、登陆验证码    2、修改手机号验证码  3、合伙人提现验证码
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_CODE, params, new RequestCallBack<String>() {
            @SuppressWarnings("deprecation")
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                Gson gson = new Gson();
                try {
                    BaseNetBean base = gson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() == 1) {
                        if (listener != null) {
                            listener.onSuccess();
                        }
                    } else {
                        DataUtil.showErrOrMsg(context, base.getErrno(), base.getErrmsg());
                        if (listener != null) {
                            listener.onFailure();
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(context.getApplicationContext(), context.getString(R.string.service_err), CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException error, String msg) {
                CommonMethod.makeNoticeShort(context.getApplicationContext(), context.getApplicationContext().getString(R.string.conn_fail), CommonMethod.ERROR);
                if (listener != null) {
                    listener.onFailure();
                }
            }
        });
    }


    public interface NetRequestListener {
        public void onFailure();

        public void onSuccess();
    }
}
