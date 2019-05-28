package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;

import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.LUtils;

import java.io.File;

/**
 * Created by Administrator on 2017/10/31 0031.
 */

public class PicUtils {


    public static void copyPicToDirection(Context context, String oldPicPath) {
        String saveDirection = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM).getAbsolutePath(); //保存的目录
        File file = new File(saveDirection);
        if (!file.exists()) {
            file.mkdirs();
        }
        String savePath = saveDirection + "/" + System.currentTimeMillis() + ".jpg";
        FUtils.copyFileAndDeleteOldFile(oldPicPath, savePath); //将下载好的文件拷贝到指定路径 然后再删除

        Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        Uri uri = Uri.fromFile(file);
        intent.setData(uri);
        context.sendBroadcast(intent);//这个广播的目的就是更新图库，发了这个广播进入相册就可以找到你保存的图片了！，记得要传你更新的file哦

        LUtils.e("oldPath:" + oldPicPath + "         savePath:" + savePath);
    }
}
