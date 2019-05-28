package com.jizhi.jlongg.main.util;

import android.content.Context;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Params;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.File;
import java.util.List;

/**
 * Created by Administrator on 2016/3/8.
 */
public class XutilExpand {

    /** 提交显示Dialog */
    public CustomProgress customProgress;


    public RequestParams getParams(Context context,List<Params> list){
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        for(int i = 0;i<list.size();i++){
            Params param = list.get(i);
            if(param.getType().equals(Constance.BEAN_FILE)){
                params.addBodyParameter(param.getKey(),new File(param.getValue().toString()));
            }else if(param.getValue().equals(Constance.BEAN_STRING)){
                params.addBodyParameter(param.getKey(),param.getValue().toString());
            }
        }
        return  params;
    }

    /**
     *  存在DiaLog 的网络请求
     * @param URL   网络连接地址
     * @param params  请求参数
     * @param context 上下文
     * @param listener 数据回调
     * @param string_for_dialog
     */
    public void SendNetworkRequestExistsDialog(String URL,List<Params> params, final Context context,final xutilsCallBack listener,String string_for_dialog){
        if(customProgress!=null){

        }else{
            customProgress = new CustomProgress(context);
            customProgress.show(context, string_for_dialog, false);
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST,URL,getParams(context,params),new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                         if(listener!=null){
                            listener.onSuccess(responseInfo.result);
                         }
                    }

                    @Override
                    public void onFailure(HttpException e, String errormsg) {
                        printNetLog(errormsg, context);
                        closeDialog();
                        if(listener!=null){
                            listener.onFailure();
                        }
                 }
        });
    }

    /** xutils 回调 */
    public interface xutilsCallBack{
        /** xutils 返回成功调用的方法*/
        public void onSuccess(String response);
        /** xutils 返回失败调用的方法 */
        public Object onFailure();
    }

    public void closeDialog() {
        if (null != customProgress) {
            customProgress.closeDialog();
            customProgress = null;
        }
    }


    /** 打印网络连接错误信息 */
    public void printNetLog(String msg,Context context) {
        StringBuffer sb = new StringBuffer();
        sb.append(context.getString(R.string.conn_fail));
        CommonMethod.makeNoticeShort(context, sb.toString(),CommonMethod.ERROR);
    }


}
