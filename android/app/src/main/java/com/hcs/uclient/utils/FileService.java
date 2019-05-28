package com.hcs.uclient.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Picture;
import android.os.Environment;
import android.util.Log;
import android.webkit.WebView;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileService {
    /**
     * 声明上下文
     */
    private Context context;
    /**
     * 文件夹名字
     */
    private static final String FOLDER_NAME = "/SnapShotImage";

    private static final String TAG = "FileService";

    // 构造函数
    public FileService(Context context) {
        this.context = context;
    }

    /**
     * 保存bitmap到文件
     *
     * @param filename
     * @param bmp
     * @return
     */
    public String saveBitmapToSDCard(String filename, Bitmap bmp) {

        // 文件相对路径
        String fileName = null;
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            // 文件保存的路径
            String fileDir = Environment.getExternalStorageDirectory() + FOLDER_NAME;

            // 如果文件夹不存在，创建文件夹
            if (!createDir(fileDir)) {
                Log.e(TAG, "创建文件夹失败!");
            }
            // 声明文件对象
            File file = null;
            // 声明输出流
            FileOutputStream outStream = null;

            try {
                // 如果有目标文件，直接获得文件对象，否则创建一个以filename为名称的文件
                file = new File(fileDir, filename);

                // 获得文件相对路径
                fileName = file.toString();
                // 获得输出流，如果文件中有内容，追加内容
                outStream = new FileOutputStream(fileName);
                if (outStream != null) {
                    bmp.compress(Bitmap.CompressFormat.PNG, 90, outStream);
                    outStream.close();
                }

            } catch (Exception e) {
                Log.e(TAG, e.toString());
            } finally {
                // 关闭流
                try {
                    if (outStream != null) {
                        outStream.close();
                    }
                } catch (IOException e) {
                    Log.e(TAG, e.toString());
                }
            }
        }
        return fileName;
    }

    /**
     * 创建指定路径的文件夹，并返回执行情况 ture or false
     *
     * @param filePath
     * @return
     */
    public boolean createDir(String filePath) {
        File fileDir = new File(filePath); // 生成文件流对象
        boolean bRet = true;
        // 如果文件不存在，创建文件
        if (!fileDir.exists()) {
            // 获得文件或文件夹名称
            String[] aDirs = filePath.split("/");
            StringBuffer strDir = new StringBuffer();
            for (int i = 0; i < aDirs.length; i++) {
                // 获得文件上一级文件夹
                fileDir = new File(strDir.append("/").append(aDirs[i]).toString());
                // 是否存在
                if (!fileDir.exists()) {
                    // 不存在创建文件失败返回FALSE
                    if (!fileDir.mkdir()) {
                        bRet = false;
                        break;
                    }
                }
            }
        }

        return bRet;
    }

    /**
     * 截取webView快照(webView加载的整个内容的大小)
     *
     * @param webView
     * @return
     */
    public Bitmap captureWebView(WebView webView) {
        Picture snapShot = webView.capturePicture();

        Bitmap bmp = Bitmap.createBitmap(snapShot.getWidth(), snapShot.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bmp);
        snapShot.draw(canvas);
        return bmp;
    }


}
