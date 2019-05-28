package com.jizhi.jlongg.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 功能:WebSocket 心跳服务
 * 时间:2016年8月29日 14:36:55
 * 作者:xuj
 */
public class WebSocketHeartRateService extends Service {
    /**
     * 心跳包发送的间隔时间 ,每隔40秒发送一次
     */
    private int HEART_SEND_TIME = 4 * 10;
    /**
     * 循环定时器，发送心跳包
     */
    private ScheduledExecutorService scheduledExecutorService;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        startHearSchedueld();
    }

    /**
     * 开启心跳包定时器
     */
    private void startHearSchedueld() {
        LUtils.e("开启心跳包定时器");
        //用一个定时器  来完成图片切换
//        if (scheduledExecutorService == null) {
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
                if (UclientApplication.isLogin(getApplicationContext())) {
                    SocketManager socketManager = SocketManager.getInstance(getApplicationContext());
                    if (socketManager.getWebSocket() != null && socketManager.socketState.equals(SocketManager.SOCKET_OPEN)) {
                        WebSocketBaseParameter request = new WebSocketBaseParameter();
                        request.setAction(WebSocketConstance.ACTION_HEARTBEAT);
                        request.setCtrl(WebSocketConstance.MESSAGE);
                        socketManager.getWebSocket().requestServerMessage(request);
                    }
                }
            }
        }, HEART_SEND_TIME, HEART_SEND_TIME, TimeUnit.SECONDS);
//        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (scheduledExecutorService != null) {
            LUtils.e("关闭心跳包定时器");
            scheduledExecutorService.shutdown();
        }
    }

}
