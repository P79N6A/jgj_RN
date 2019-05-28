package com.jizhi.jlongg.service;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;

import com.hcs.uclient.utils.LUtils;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 功能:WebSocket 重连
 * 时间:2016年10月25日 11:40:07
 * 作者:xuj
 */
public class WebSocketReconnectionService extends Service {
    /**
     * WebSocket重练时间 每隔5秒
     */
    private int reconnectionTime = 5;
    /**
     * 循环定时器，发送WebSocket 重练服务
     */
    private ScheduledExecutorService scheduledExecutorService;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        startReconnectionSchedueld();
    }

    /**
     * Handler 当重新连接Socket时需要使用
     */
    private Handler handler;

    /**
     * 开启心跳包定时器
     */
    private void startReconnectionSchedueld() {
        LUtils.e("开启WebSocket定时器");
        handler = new Handler();
//        if (scheduledExecutorService == null) {
        //用一个定时器  来完成图片切换
        scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();
//        //通过定时器 来完成 每2秒钟切换一个图片
//        //经过指定的时间后，执行所指定的任务
//        //scheduleAtFixedRate(command, initialDelay, period, unit)
//        //command 所要执行的任务
//        //initialDelay 第一次启动时 延迟启动时间
//        //period  每间隔多次时间来重新启动任务
//        //unit 时间单位
        scheduledExecutorService.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
//                try {
//                    if (UclientApplication.isLogin(getApplicationContext())) {
//                        final SocketManager manager = SocketManager.getInstance(getApplicationContext());
//                        WebSocket socket = manager.getWebSocket();
//                        if (socket == null || socket.getSocketState().equals(WebSocket.Socket_CLOSE) || socket.getSocketState().equals(WebSocket.Socket_ERROR)) {
//                            LUtils.e("准备重连WebSocket");
//                            handler.post(new Runnable() {
//                                @Override
//                                public void run() {
//                                    manager.restartWebSocket(getApplicationContext());
//                                }
//                            });
//                        }
//                    }
//                } catch (Exception e) {
//                    LUtils.e("exception:" + e.toString());
//                    e.printStackTrace();
//                }
            }
        }, reconnectionTime, reconnectionTime, TimeUnit.SECONDS);
//        }
    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        LUtils.e("关闭WebSocket重连定时器");
        if (scheduledExecutorService != null) {
            scheduledExecutorService.shutdown();
        }
    }
}
