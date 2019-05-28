package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Handler;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.application.UclientApplication;

/**
 * 功能: Socket管理类
 * 作者：xuj
 * 时间:2018年10月18日10:29:38
 */
public class SocketManager implements WebSocket.WebSocketStatusListener {
    /**
     * webSocket接口
     */
    private WebSocket webSocket;
    /**
     * SocketManager实例
     */
    private static volatile SocketManager socketManager;
    /**
     * Context上下文
     */
    private Context context;
    /**
     * 当前Socket状态
     */
    public String socketState = SOCKET_CLOSE;
    /**
     * WebSocket 关闭状态
     */
    public final static String SOCKET_CLOSE = "socket_close";
    /**
     * WebSocket 开启状态
     */
    public final static String SOCKET_OPEN = "socket_open";
    /**
     * WebSocket 错误状态
     */
    public final static String SOCKET_ERROR = "socket_error";
    /**
     * WebSocket正在重连
     */
    public final static String SOCKET_CONNECTIONING = "socket_connecting";


    public static SocketManager getInstance(Context context) {
        if (socketManager == null) {
            synchronized (DBMsgUtil.class) {
                if (socketManager == null) {
                    socketManager = new SocketManager(context);
                }
            }
        }
        return socketManager;
    }

    private SocketManager(Context context) {
        this.context = context;
    }

    public WebSocket getWebSocket() {
        return webSocket;
    }

    public void init() {
        if (webSocket == null) {
            setStatus(SOCKET_CONNECTIONING);
            createClient(context);
        }
    }


    /**
     * 创建客户端
     *
     * @param context
     * @return
     */
    private void createClient(Context context) {
        if (SOCKET_OPEN.equals(socketState)) { //连接中或者已连接,则不发起新的连接
            return;
        }
        if (!UclientApplication.isLogin(context)) {
            return;
        }

        if (webSocket != null) {
            webSocket.close();
            webSocket = null;
        }
        try {
            webSocket = new WebSocket(context, getSocketConnectionParameter(context), this);
            webSocket.connect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 获取Socket连接参数
     * 如?token=3bb95c9c57f284c2a573fad17c404191&os=I&client_type=person&ver=3.4.0
     *
     * @return
     */
    private String getSocketConnectionParameter(Context context) {
        String token = UclientApplication.getToken(context);
        StringBuilder builder = new StringBuilder();
        builder.append("?token=" + token.substring(token.indexOf(" ") + 1, token.length()));
        builder.append("&os=A");
        builder.append("&client_type=person");
        builder.append("&ver=" + String.valueOf(AppUtils.getVersionName(context)));
        return builder.toString();
    }


    /**
     * 清空Socket
     */
    public void clearWebSocket() {
        if (this.webSocket != null) {
            webSocket.close();
            webSocket = null;
        }
        socketManager = null;
        LUtils.e("清空所有的连接");
    }

    private int reconnectCount = 0;//重连次数
    private long minInterval = 3000;//重连最小时间间隔
//    private long maxInterval = 60000;//重连最大时间间隔

    /**
     * 重连WebSocket
     */
    public void
    reconnect() {
        if (!isNetConnect()) {
//            reconnectCount = 0;
            LUtils.e("重连失败网络不可用");
            return;
        }
        //这里其实应该还有个用户是否登录了的判断 因为当连接成功后我们需要发送用户信息到服务端进行校验
        //由于我们这里是个demo所以省略了
//        if (webSocket != null &&
//                !webSocket.isOpen() &&//当前连接断开了
//                !socketState.equals(SOCKET_CONNECTIONING) && UclientApplication.isLogin(context)) {//不是正在重连状态
//            reconnectCount++;
//            setStatus(SOCKET_CONNECTIONING);
//            long reconnectTime = minInterval;
//            if (reconnectCount > 3) {
//                long temp = minInterval * (reconnectCount - 2);
//                reconnectTime = temp > maxInterval ? maxInterval : temp;
//            }
//            LUtils.e(String.format("WebSocket_status 准备开始第%d次重连,重连间隔%d秒", reconnectCount, reconnectTime / 1000));
//            mHandler.postDelayed(mReconnectTask, reconnectTime);
//        }

        if (webSocket != null &&
                !webSocket.isOpen() &&//当前连接断开了
                !socketState.equals(SOCKET_CONNECTIONING) && UclientApplication.isLogin(context)) {//不是正在重连状态
            reconnectCount++;
            if (reconnectCount > 3) {
                return;
            }
            setStatus(SOCKET_CONNECTIONING);
            long reconnectTime = minInterval * reconnectCount;
            LUtils.e(String.format("WebSocket_status 准备开始第%d次重连,重连间隔%d秒", reconnectCount, reconnectTime / 1000));
            mHandler.postDelayed(mReconnectTask, reconnectTime);
        }
    }


    /**
     * 马上重连WebSocket
     */
    public void reconnectNow() {
        if (!isNetConnect()) {
//            reconnectCount = 0;
            LUtils.e("重连失败网络不可用");
            return;
        }
        //这里其实应该还有个用户是否登录了的判断 因为当连接成功后我们需要发送用户信息到服务端进行校验
        //由于我们这里是个demo所以省略了
        if (webSocket != null &&
                !webSocket.isOpen() &&//当前连接断开了
                !socketState.equals(SOCKET_CONNECTIONING) && UclientApplication.isLogin(context)) {//不是正在重连状态
            setStatus(SOCKET_CONNECTIONING);
            mHandler.postDelayed(mReconnectTask, 0);
        }
    }

    private Handler mHandler = new Handler();

    private Runnable mReconnectTask = new Runnable() {
        @Override
        public void run() {
            if (webSocket != null) {
                webSocket.close();
                webSocket = null;
            }
            createClient(context);
        }
    };


    /**
     * 当前是否有网络连接
     *
     * @return
     */
    private boolean isNetConnect() {
        ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivity != null) {
            NetworkInfo info = connectivity.getActiveNetworkInfo();
            if (info != null && info.isConnected()) {
                // 当前网络是连接的
                if (info.getState() == NetworkInfo.State.CONNECTED) {
                    // 当前所连接的网络可用
                    return true;
                }
            }
        }
        return false;
    }

    private void cancelReconnect() {
//        reconnectCount = 0;
        mHandler.removeCallbacks(mReconnectTask);
    }

    private void setStatus(String status) {
        this.socketState = status;
        LUtils.e("WebSocket_status:" + status);
    }

    @Override
    public void onOen() {
        setStatus(SOCKET_OPEN);
        cancelReconnect();
    }

    @Override
    public void onClose() {
        setStatus(SOCKET_CLOSE);
        reconnect();
    }

    @Override
    public void onError() {
        setStatus(SOCKET_ERROR);
        reconnect();
    }
}
