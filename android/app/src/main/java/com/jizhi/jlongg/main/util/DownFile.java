package com.jizhi.jlongg.main.util;

import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;

import java.io.File;

/**
 * Created by Administrator on 2016/3/3.
 */
public class DownFile {
    public static void downVoiceFile(String url, String sdPath, final FindInterface.SendString sendString) {
        File dir = new File(Constance.VOICEPATH);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.download(url, sdPath, true, false, new RequestCallBack<File>() {
            @Override
            public void onStart() {
            }

            @Override
            public void onLoading(long total, long current, boolean isUploading) {
                super.onLoading(total, current, isUploading);
            }

            @Override
            public void onFailure(HttpException error, String msg) {
                sendString.sendString("onFailure");
            }

            @Override
            public void onSuccess(ResponseInfo<File> responseInfo) {
                sendString.sendString(responseInfo.result.getPath().toString());
            }
        });
    }
}
