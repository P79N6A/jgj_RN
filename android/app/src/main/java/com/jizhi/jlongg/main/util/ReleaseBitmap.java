package com.jizhi.jlongg.main.util;

import android.graphics.Bitmap;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.bean.Photo;

import java.util.List;

/**
 * 功能: 释放Bitmap 内存
 * 作者：Administrator
 * 时间: 2016-4-7 14:46
 */
public class ReleaseBitmap {


    public static void recycle(List<Bitmap> bitmapList) {
        if (bitmapList != null && bitmapList.size() > 0) {
            int size = bitmapList.size();

            for (int i = 0; i < size; i++) {
                Bitmap tempBitmap = bitmapList.get(i);
                if (tempBitmap != null && !tempBitmap.isRecycled()) {
                    bitmapList.get(i).recycle();
                    tempBitmap = null;
                }
            }
            System.gc();
        }
    }


    public static void recyclePhotos(List<Photo> bitmapList) {
        if (bitmapList != null && bitmapList.size() > 0) {
            int size = bitmapList.size();
            for (int i = 0; i < size; i++){
                Bitmap tempBitmap = bitmapList.get(i).getBitmap();
                if (tempBitmap != null && !tempBitmap.isRecycled()) {
                    tempBitmap.recycle();
                    tempBitmap = null;
                    LUtils.e("图片","正在释放第:"+(i+1));
                }
            }
            System.gc();
        }
    }
}
