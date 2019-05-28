package com.hcs.uclient.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.text.DecimalFormat;


/**
 * 数据管理类
 */
public class ImageUtils {

    /**
     * 获取图片的宽高
     *
     * @param drawableResource
     * @return
     */
    public static int[] getImageWidthHeight(Context context, int drawableResource) {
//        BitmapFactory.Options options = new BitmapFactory.Options();
//        /**
//         * 最关键在此，把options.inJustDecodeBounds = true;
//         * 这里再decodeFile()，返回的bitmap为空，但此时调用options.outHeight时，已经包含了图片的高了
//         */
//        options.inJustDecodeBounds = true;
//        BitmapFactory.decodeResource(context.getResources(), drawableResource, options);// 此时返回的bitmap为null
//        /**
//         *options.outHeight为原始图片的高
//         */
//        return new int[]{options.outWidth, options.outHeight};
        Bitmap bitmap = BitmapFactory.decodeResource(context.getResources(), drawableResource);
        int height = bitmap.getHeight();
        int width = bitmap.getWidth();
        if (bitmap != null && !bitmap.isRecycled()) {
            bitmap.recycle();
            bitmap = null;
            System.gc();
        }
        return new int[]{width, height};
    }

    /**
     * 根据路径 转bitmap
     *
     * @param urlpath
     * @return
     */
    public static Bitmap getBitMBitmap(String urlpath) {

        Bitmap map = null;
        try {
            URL url = new URL(urlpath);
            URLConnection conn = url.openConnection();
            conn.connect();
            InputStream in;
            in = conn.getInputStream();
            map = BitmapFactory.decodeStream(in);
            // TODO Auto-generated catch block
        } catch (IOException e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * 根据路径 转bitmap
     *
     * @param filePath
     * @return
     */
    public static Bitmap getFileBitmap(String filePath, Context context) {

        Bitmap map = null;
        try {
            File file = new File(filePath);
            Uri uri = Uri.fromFile(file);
            map = MediaStore.Images.Media.getBitmap(context.getContentResolver(), uri);
            // TODO Auto-generated catch block
        } catch (IOException e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * 把batmap 转file
     *
     * @param bitmap
     * @param filepath
     */
    public static File saveBitmapFile(Bitmap bitmap, String filepath) {
        File file = new File(filepath);//将要保存图片的路径
        try {
            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bos.flush();
            bos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return file;
    }

    public static String FormetFileSize(long fileS) {
        DecimalFormat df = new DecimalFormat("#.00");
        String fileSizeString = "";
        if (fileS < 1024) {
            fileSizeString = df.format((double) fileS) + "B";
        } else if (fileS < 1048576) {
            fileSizeString = df.format((double) fileS / 1024) + "K";
        } else if (fileS < 1073741824) {
            fileSizeString = df.format((double) fileS / 1048576) + "M";
        } else {
            fileSizeString = df.format((double) fileS / 1073741824) + "G";
        }
        return fileSizeString;
    }
}
