package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.os.Environment;
import android.view.View;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ScreenShot {

    public static Bitmap takeScreenShot(Activity activity) {
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap b1 = view.getDrawingCache();

        Rect frame = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        int statusBarHeight = frame.top;
        System.out.println(statusBarHeight);
        int width = activity.getWindowManager().getDefaultDisplay().getWidth();
        int height = activity.getWindowManager().getDefaultDisplay().getHeight();
        Bitmap b = Bitmap.createBitmap(b1, 0, statusBarHeight, width, height - statusBarHeight);
        view.destroyDrawingCache();
        return b;

    }

    public static Bitmap takeScreenShotClip(Activity activity, int x, int y, int width, int height) {
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap b1 = view.getDrawingCache();
        Rect frame = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        Bitmap b = Bitmap.createBitmap(b1, x, y, width, height);
        view.destroyDrawingCache();
        return b;

    }

    public static Bitmap takeScreenShotClip(Activity activity, int x, int y) {
        //整个手机屏幕的视图
        View view = activity.getWindow().getDecorView();
        view.setDrawingCacheEnabled(true);
        view.buildDrawingCache();
        Bitmap bitmap = view.getDrawingCache();
        // 获取状态栏高度
        Rect frame = new Rect();
        activity.getWindow().getDecorView().getWindowVisibleDisplayFrame(frame);
        int statusBarHeight = frame.top + DensityUtils.dp2px(activity, 65);
        LUtils.e("TAG", "" + statusBarHeight);
        // 获取屏幕长和高
        int width = activity.getWindowManager().getDefaultDisplay().getWidth();
        int height = activity.getWindowManager().getDefaultDisplay().getHeight();
        Bitmap b = Bitmap.createBitmap(bitmap, 0, statusBarHeight, width, height - statusBarHeight);
        //保存图片
        FileOutputStream fout = null;
        try {
            fout = new FileOutputStream(Environment.getExternalStorageDirectory().getAbsolutePath() + "/test.png");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        b.compress(Bitmap.CompressFormat.PNG, 100, fout);
        return b;
    }

    /**
     * 质量压缩方法
     *
     * @param image
     * @return
     */
    public static Bitmap compressImage(Bitmap image) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 80, baos);// 质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 50;
        while (baos.toByteArray().length / 1024 > 23) { // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset(); // 重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);// 这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;// 每次都减少10
            LUtils.e("压缩后图片的大小=" + (baos.toByteArray().length / 1024) + "KB");
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());// 把压缩后的数据baos存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);// 把ByteArrayInputStream数据生成图片
        return bitmap;
    }

    /**
     * 质量压缩方法
     *
     * @return
     */
    public static byte[] bitmap2Bytes(Bitmap bitmap) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG
                    , 40, output);
        int options = 100;
        while (output.toByteArray().length / 1024 > 25 && options != 0) {
            output.reset(); //清空output
            bitmap.compress(Bitmap.CompressFormat.JPEG, options, output);//这里压缩options%，把压缩后的数据存放到output中
            LUtils.e(options + "压缩后AAAA图片的大小Aa=" + output.toByteArray().length / 1024 + "KB");
            if (options < 20) {
                options -= 5;
            } else {
                options -= 10;
            }

        }
        return output.toByteArray();
    }

//    public static int getBitmapSize(Bitmap bitmap) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {  //SInce API 19
//            return bitmap.getAllocationByteCount();
//        }
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1) { //Since API 12
//            return bitmap.getByteCount();
//        }
//
//        return bitmap.getRowBytes() * bitmap.getHeight();
//    }

    public static boolean savePic(Bitmap b, String strFileName) {
        boolean sucess = false;
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(strFileName);
            if (null != fos) {
                b.compress(Bitmap.CompressFormat.PNG, 90, fos);
                fos.flush();
                fos.close();
                sucess = true;
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();

        }
        return sucess;
    }
}
