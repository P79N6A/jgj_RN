package com.jizhi.jlongg.main.application;

/**
 * huchangsheng：Administrator on 2016/3/8 15:34
 */

import android.os.Environment;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.Thread.UncaughtExceptionHandler;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class UnCeHandler implements UncaughtExceptionHandler {

    private Thread.UncaughtExceptionHandler mDefaultHandler;
    private String packgeName;
    UclientApplication application;


    public UnCeHandler(UclientApplication application) {
        packgeName = application.getPackageName();
        this.application = application;
    }

    public void cauchException() {

        // 程序崩溃时触发线程
        mDefaultHandler = Thread.getDefaultUncaughtExceptionHandler();
        Thread.setDefaultUncaughtExceptionHandler(this);
    }

    // 创建服务用于捕获崩溃异常
    @Override
    public void uncaughtException(Thread thread, Throwable ex) {
        // 保存错误日志
        saveCatchInfo2File(ex);
//        application.exit();
    }

    /**
     * 保存错误信息到文件中
     *
     * @return 返回文件名称
     */
    private String saveCatchInfo2File(Throwable ex) {
        Writer writer = new StringWriter();
        PrintWriter printWriter = new PrintWriter(writer);
        ex.printStackTrace(printWriter);
        Throwable cause = ex.getCause();
        while (cause != null) {
            cause.printStackTrace(printWriter);
            cause = cause.getCause();
        }
        printWriter.close();
        String sb = writer.toString();
        try {
            DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
            String time = formatter.format(new Date());
            String fileName = time + ".txt";
            if (Environment.getExternalStorageState().equals(
                    Environment.MEDIA_MOUNTED)) {
                String filePath = Environment.getExternalStorageDirectory()
                        + "/jizhi/" + packgeName + "/crash/";
                File dir = new File(filePath);
                if (!dir.exists()) {
                    if (!dir.mkdirs()) {
                        // 创建目录失败: 一般是因为SD卡被拔出了
                        return "";
                    }
                }
                FileOutputStream fos = new FileOutputStream(filePath + fileName);
                fos.write(sb.getBytes());
                fos.close();
                // 文件保存完了之后,在应用下次启动的时候去检查错误日志,发现新的错误日志,就发送给开发者
            }
            return fileName;
        } catch (Exception e) {
        }
        return null;
    }

}