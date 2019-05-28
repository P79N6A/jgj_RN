package com.hcs.uclient.utils;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by Xuj on 2015/5/24.
 */
public class DownLoadingApkUtil {

    private Context context;

    private String updateMsg = "有最新的软件包，请下载！";// 提示消息

    private String downLoadFile = SDCardUtils.getSDCardPath() + "/yzg/"; //下载的文件地址

    private Dialog noticeDialog;// 提示有软件更新的对话框

    private Dialog downloadDialog;// 下载对话框

    private final String saveFileName = downLoadFile + "yzg.apk";

    // 进度条与通知UI刷新的handler和msg常量
    private ProgressBar mProgress;

    private static final int DOWN_UPDATE = 1;

    private static final int DOWN_OVER = 2;

    private int progress;// 当前进度

    private Thread downLoadThread; // 下载线程

    private boolean interceptFlag = false;// 用户取消下载

    private String apkUrl; //APK下载地址

    private TextView progress_txt;


    public DownLoadingApkUtil(Context context, String downPath) {
        this.context = context;
        this.apkUrl = NetWorkRequest.NETURL + downPath;
    }


    // 通知处理刷新界面的handler
    private Handler mHandler = new Handler() {
        @SuppressLint("HandlerLeak")
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case DOWN_UPDATE:
                    mProgress.setProgress(progress);
                    progress_txt.setText("已下载"+progress + "%");
                    break;
                case DOWN_OVER:
                    interceptFlag = true;
                    installApk();
                    break;
            }
            super.handleMessage(msg);
        }
    };

    // 显示更新程序对话框，供主程序调用
    public void checkUpdateInfo() {
        showNoticeDialog();
    }

    private void showNoticeDialog() {
        showDownloadDialog();
    }

    protected void showDownloadDialog() {
        android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(new ContextThemeWrapper(context, android.R.style.Theme_Holo_Light_Dialog));
        builder.setTitle("软件版本更新");
        final LayoutInflater inflater = LayoutInflater.from(context);
        View v = inflater.inflate(R.layout.progress, null);
        progress_txt = (TextView) v.findViewById(R.id.progress_txt);
        mProgress = (ProgressBar) v.findViewById(R.id.progress);
        builder.setView(v);// 设置对话框的内容为一个View
        builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                interceptFlag = true;
            }
        });
        downloadDialog = builder.create();
        downloadDialog.show();
        downloadApk();
    }

    private void downloadApk() {
        downLoadThread = new Thread(mdownApkRunnable);
        downLoadThread.start();
    }

    protected void installApk() {
        File apkfile = new File(saveFileName);
        if (!apkfile.exists()) {
            return;
        }
        Intent i = new Intent(Intent.ACTION_VIEW);
        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        i.setDataAndType(Uri.parse("file://" + apkfile.toString()), "application/vnd.android.package-archive");// File.toString()会返回路径信息
        context.startActivity(i);
        downloadDialog.dismiss();
    }

    private Runnable mdownApkRunnable = new Runnable() {
        @Override
        public void run() {
            URL url;
            try {
                File apkfile = new File(saveFileName);
                if (apkfile.exists()) {
                    apkfile.delete();
                }
                url = new URL(apkUrl);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.connect();
                int length = conn.getContentLength();
                InputStream ins = conn.getInputStream();
                File file = new File(downLoadFile);
                if (!file.exists()) {
                    file.mkdir();
                }
                String apkFile = saveFileName;
                File ApkFile = new File(apkFile);
                FileOutputStream outStream = new FileOutputStream(ApkFile);
                int count = 0;
                byte buf[] = new byte[1024];
                do {
                    int numread = ins.read(buf);
                    count += numread;
                    progress = (int) (((float) count / length) * 100);
                    // 下载进度
                    mHandler.sendEmptyMessage(DOWN_UPDATE);
                    if (numread <= 0) {
                        // 下载完成通知安装
                        mHandler.sendEmptyMessage(DOWN_OVER);
                        break;
                    }
                    outStream.write(buf, 0, numread);
                } while (!interceptFlag);// 点击取消停止下载
                outStream.close();
                ins.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };
}



