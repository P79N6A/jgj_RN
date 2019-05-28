package com.jizhi.jlongg.main.util;

import com.lidroid.xutils.HttpUtils;

/**
 * http帮助类
 *
 * @author xuj
 * @time 2015年11月28日 10:54:38
 */
public class SingsHttpUtils {
//    private volatile static HttpUtils http;

    private SingsHttpUtils() {
        super();
    }

    /**
     * 同步获取httpUtils
     *
     * @return
     */
    public synchronized static HttpUtils getHttp() {
//        if (http == null) {
//            synchronized (SingsHttpUtils.class) {
//                if (http == null) {
//                    http = new HttpUtils();
//                    http.configTimeout(30000);//设置超时时间为30秒
//                    http.configRequestThreadPoolSize(5);//设置线程数
//                }
//            }
//        }
//        return http;
        HttpUtils http = new HttpUtils();
        http.configTimeout(30000);//设置超时时间为30秒
        http.configRequestThreadPoolSize(5);//设置线程数
        return http;
    }
}
