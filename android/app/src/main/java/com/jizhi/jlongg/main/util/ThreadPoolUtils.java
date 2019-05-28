package com.jizhi.jlongg.main.util;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by Administrator on 2017/9/25 0025.
 */

public class ThreadPoolUtils {


    private static final int CPU_COUNT = Runtime.getRuntime().availableProcessors();//cpu的个数
    private static final int CORE_POOL_SIZE = CPU_COUNT + 1; //核心线程数为手机cpu数量+1
    private static final int MAXIMUM_POOL_SIZE = CPU_COUNT * 2 + 1; //最大线程数为手机CPU数量×2+1
    private static final int KEEP_ALIVE = 1; //激活
    private static final BlockingQueue<Runnable> sPoolWorkQueue = new LinkedBlockingQueue<Runnable>(128);// //线程队列的大小为128

    private static final ThreadFactory sThreadFactory = new ThreadFactory() {
        private final AtomicInteger mCount = new AtomicInteger(1);

        public Thread newThread(Runnable r) {
            return new Thread(r, "AsyncTask #" + mCount.getAndIncrement());
        }
    };

    public static final ExecutorService fixedThreadPool = new ThreadPoolExecutor(CORE_POOL_SIZE, MAXIMUM_POOL_SIZE, KEEP_ALIVE, TimeUnit.SECONDS, sPoolWorkQueue, sThreadFactory); //线程池

}
