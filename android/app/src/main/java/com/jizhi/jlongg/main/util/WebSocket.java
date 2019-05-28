package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.NetWorkUtil;
import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountSendSuccess;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageFailBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonNewJson;
import com.jizhi.jlongg.main.bean.status.CommonNewListJson;
import com.jizhi.jlongg.network.NetWorkRequest;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;
import org.json.JSONObject;

import java.io.Serializable;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * 功能: WebSocket扩展类
 * 作者：Xuj
 * 时间: 2016-8-31 20:16
 */
public class WebSocket extends WebSocketClient {

    /**
     * 上下文
     */
    private Context context;

    /**
     * webSocket监听器
     */
    private WebSocketStatusListener webSocketListener;


    public WebSocket(Context context, String webSocketParameter, WebSocketStatusListener webSocketListener) throws URISyntaxException {
        super(new URI(NetWorkRequest.SERVER + webSocketParameter));
        this.context = context;
        this.webSocketListener = webSocketListener;
        LUtils.e("-------WebSocket ------------url:" + NetWorkRequest.SERVER + webSocketParameter);
    }


    @Override
    public void onOpen(ServerHandshake handshakedata) {
        if (webSocketListener != null) {
            webSocketListener.onOen();
        }
        //Socket连接成功后发起广播 回执一些 还未回执的消息
        LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(SocketManager.SOCKET_OPEN));
    }

    /**
     * 根据 后台返回的Action解析数据 并使用相应的实体类
     * 比如发送消息里面 需要获取 MessageEntity 类来解析数据
     *
     * @param action
     * @return
     */
    public Class getResolutionDataClass(String action) {
        switch (action) {
            case WebSocketConstance.SENDMESSAGE:
                return MessageBean.class;
            case WebSocketConstance.RECEIVEMESSAGE:
                if (ThreadPoolManager.isRunning) {
                    LUtils.e(WebSocketConstance.RECEIVEMESSAGE + "----丢弃-------EEEEE-----------" + ThreadPoolManager.isRunning);
                    return null;
                } else {
                    LUtils.e(WebSocketConstance.RECEIVEMESSAGE + "----保留-------EEEEE-----------" + ThreadPoolManager.isRunning);
                }
                return MessageBean.class;
            case WebSocketConstance.GET_CALLBACK_OPERATIONMESSAGE:
                return MessageBean.class;
            case WebSocketConstance.MSGREADTOSENDER:
                return MessageBean.class;
            case WebSocketConstance.RECALLMESSAGE:
                return MessageBean.class;
            case WebSocketConstance.RED_DOTMESSAGE:
                return MessageBean.class;
            case WebSocketConstance.FRIENDMESSAGETOSENDER:
                return MessageBean.class;
        }
        return null;
    }

    @Override
    public void onMessage(String message) {
        LUtils.e("接收的json:" + message);
        if (TextUtils.isEmpty(message)) {
            return;
        }
        BaseNetNewBean firstCheck = new Gson().fromJson(message, BaseNetNewBean.class);
        try {
            //确认消息是否已报错
            if (firstCheck != null && !firstCheck.getMsg().equals("success")) {
                //解决分享转发错误提示问题
                // 分享数据 is_source => 1
                //转发数据 is_source => 2
                if (message.contains("is_source") || message.contains("local_id")) {
                    CommonJson<MessageFailBean> base = CommonJson.fromJson(message, MessageFailBean.class);

                    if (null != base.getResult() && !TextUtils.isEmpty(base.getResult().getLocal_id())) {
                        DBMsgUtil.getInstance().upMessageStatus(base.getResult().getLocal_id());

                        if (base.getResult().getIs_source() == 0) {
                            sendErrorMsg(firstCheck);
                        }
                        Intent intent = new Intent(WebSocketConstance.SEND_MSG_FAIL);
                        intent.putExtra("local_id", base.getResult().getLocal_id());
                        LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
                    }
                    return;
                }
               sendErrorMsg(firstCheck);
                LUtils.e("------ccc------------"+firstCheck);
                return;
            }
            if (!message.contains("action")) {
                return;
            }
            String action = new JSONObject(message).getString("action");
            Class t = getResolutionDataClass(action);
            if (t == null) {
                return;
            }
            boolean isList = message.contains("result\":[");
            if (isList) { //处理服务器返回的集合数据,我们这里判断只要包含result:[ 就认为返回的是 数组  result:{ 就认为返回的是对象
                LUtils.e("--------接收到的是数组---11----");
                CommonNewListJson base = CommonNewListJson.fromJson(message, t);
                //自己手动添加朋友，不需处理排重问题
                if (base.getAction().equals(WebSocketConstance.FRIENDMESSAGETOSENDER)) {
                    LUtils.e("--------接收到的是数组-222------");
                    base.setAction(WebSocketConstance.RECEIVEMESSAGE);
                }
                resolution(base.getResult(), base.getAction(), base.getMsg(), base);
            } else { //处理服务器返回的对象数据
                CommonNewJson base = CommonNewJson.fromJson(message, t);
                resolution(base.getResult(), base.getAction(), base.getMsg(), base);
            }
        } catch (Exception e) {
            e.printStackTrace();
            LUtils.e("WebSocket错误:" + e.toString());
        }
    }

    /**
     * 解析数据
     *
     * @param result
     * @param action
     * @param msg
     * @param baseNetNewBean
     */
    private void resolution(Object result, String action, String msg, BaseNetNewBean baseNetNewBean) {
        if (!TextUtils.isEmpty(msg) && msg.equals("success")) {
            Intent intent = new Intent(action);
            intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) result);
            LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
        } else {
            sendErrorMsg(baseNetNewBean);
        }
    }


    private void sendErrorMsg(BaseNetNewBean baseNetNewBean) {
        Message errorMessage = Message.obtain();
        errorMessage.obj = baseNetNewBean;
        mHandler.sendMessage(errorMessage);
    }

    @Override
    public void onClose(int code, String reason, boolean remote) {

        if (webSocketListener != null) {
            webSocketListener.onClose();
        }
    }

    @Override
    public void onError(Exception exception) {
        if (webSocketListener != null) {
            webSocketListener.onError();
        }
    }

    public void requestServerMessage(WebSocketBaseParameter requestServer) {
        try {
            if (!isConnection(context)) { //是否开启了连接
                return;
            }
            String token = UclientApplication.getToken(UclientApplication.getInstance());
            requestServer.setToken(token.substring(token.indexOf(" ") + 1, token.length()));
            requestServer.setVer(String.valueOf(AppUtils.getVersionName(UclientApplication.getInstance())));
            String json = new Gson().toJson(requestServer);
            send(json);
            LUtils.e("发送的json：" + json);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean isConnection(Context context) {
        if (!NetWorkUtil.isNetworkAvailable(context)) { //网络连接不可用 跳出当前
            return false;
        }
        if (!getConnection().isOpen()) {
            return false;
        }
        return true;
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            BaseNetNewBean netWorkError = (BaseNetNewBean) msg.obj;
            DataUtil.showErrOrMsg(context, netWorkError.getCode() + "", netWorkError.getMsg());
        }
    };


    public interface WebSocketStatusListener {
        public void onOen();

        public void onClose();

        public void onError();
    }


}
