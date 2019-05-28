package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Environment;
import android.text.TextPaint;
import android.text.TextUtils;

import com.compress.Luban1;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.lidroid.xutils.http.RequestParams;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;

/**
 * 水印图片工具类
 *
 * @author cheng
 */
public class ImageUtil {

    public static void compressImageSetParams(RequestParams params, String mSelectPath, Context context) {
        if (TextUtils.isEmpty(mSelectPath)) {
            return;
        }
        // 拥有可读可写权限
        if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) { //内存卡状态
            List<String> list = Utils.getImageWidthAndHeight(mSelectPath);
            if (list != null && list.size() == 2) {
                String upLoadFilePath = list.get(0) + "_" + list.get(1) + "_" + "images" + 1;
                File file = Luban1.get(context)
                        .load(new File(mSelectPath)).setSaveFileName(upLoadFilePath)                     //传人要压缩的图片
                        .putGear(Luban1.THIRD_GEAR).launch();     //设定压缩档次，默认三挡
                params.addBodyParameter("file[" + 1 + "]", file);
                LUtils.e("path:" + file.getAbsolutePath());
            }
        } else {
            CommonMethod.makeNoticeShort(context, "图片上传失败,请确认你的内存卡是否可用?", CommonMethod.ERROR);
        }
    }

    public static void compressImageSetParams(RequestParams params, List<String> mSelectPath, Context context) {
        if (mSelectPath == null || mSelectPath.size() == 0) {
            return;
        }
        // 拥有可读可写权限
        if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) { //内存卡状态
            int index = 0;
            for (String imageFilePath : mSelectPath) {
                index += 1;
                List<String> list = Utils.getImageWidthAndHeight(imageFilePath);
                if (list != null && list.size() == 2) {
                    String upLoadFilePath = list.get(0) + "_" + list.get(1) + "_" + "images" + index;
                    File file = Luban1.get(context)
                            .load(new File(imageFilePath)).setSaveFileName(upLoadFilePath)                     //传人要压缩的图片
                            .putGear(Luban1.THIRD_GEAR).launch();     //设定压缩档次，默认三挡
                    params.addBodyParameter("file[" + index + "]", file);
                    LUtils.e("path:" + file.getAbsolutePath());
                }
            }
        } else {
            CommonMethod.makeNoticeShort(context, "图片上传失败,请确认你的内存卡是否可用?", CommonMethod.ERROR);
        }
    }


    // 穿件带字母的标记图片
    public static Bitmap createDrawable(Activity activity, Bitmap sourBitmap) {
        String address = SPUtils.get(activity, Constance.ADDRESS, "", Constance.JLONGG).toString();
        String name = SPUtils.get(activity, Constance.USERNAME, "", Constance.JLONGG).toString();
        int width = sourBitmap.getWidth();
        int height = sourBitmap.getHeight();

        Bitmap imgTemp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(imgTemp);
        Paint paint = new Paint(); // 建立画笔
        paint.setDither(true);
        paint.setFilterBitmap(true);
        Rect src = new Rect(0, 0, width, height);
        Rect dst = new Rect(0, 0, width, height);
        canvas.drawBitmap(sourBitmap, src, dst, paint);

        Paint textPaint = new Paint(Paint.ANTI_ALIAS_FLAG
                | Paint.DEV_KERN_TEXT_FLAG);
        textPaint.setTextSize(dp2px(activity, 15));
        textPaint.setTypeface(Typeface.DEFAULT); // 采用默认的宽度
        textPaint.setColor(Color.WHITE);
        int Y = sourBitmap.getHeight() - dp2px(activity, 10);
        canvas.drawText(address, dp2px(activity, 15), Y, paint);
        canvas.drawText(name, dp2px(activity, 15), Y - dp2px(activity, 15), paint);
        canvas.save();
        canvas.restore();
        return imgTemp;

    }

    /**
     * 绘制文字到右下角
     *
     * @param context
     * @param bitmap
     * @return
     */
    public static Bitmap drawTextBottom(Context context, Bitmap bitmap) {
        String address = SPUtils.get(context, Constance.ADDRESS, "", Constance.JLONGG).toString();
        String name = SPUtils.get(context, Constance.USERNAME, "", Constance.JLONGG).toString();
        name = name + "  " + TimesUtils.getNowTimeM();
//        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        TextPaint paint = new TextPaint(Paint.ANTI_ALIAS_FLAG | Paint.DEV_KERN_TEXT_FLAG);// 设置画笔
        paint.setColor(Color.WHITE);
        paint.setTypeface(Typeface.DEFAULT);// 采用默认的宽度
        paint.setTextSize(dp2px(context, 10));
        Rect bounds = new Rect();
        paint.getTextBounds(name, 0, name.length(), bounds);
        Bitmap.Config bitmapConfig = bitmap.getConfig();
        paint.setDither(true); // 获取跟清晰的图像采样
        paint.setFilterBitmap(true);// 过滤一些
        if (bitmapConfig == null) {
            bitmapConfig = Bitmap.Config.ARGB_8888;
        }
        bitmap = bitmap.copy(bitmapConfig, true);

        Canvas canvas = new Canvas(bitmap);
        int Y = bitmap.getHeight() - dp2px(context, 10);
        canvas.drawText(address, dp2px(context, 15), Y - dp2px(context, 5), paint);
        canvas.drawText(name, dp2px(context, 15), Y - dp2px(context, 23), paint);
        return bitmap;
    }

//    /**
//     * 绘制文字到右下角
//     *
//     * @param context
//     * @param bitmap
//     * @return
//     */
//    public static Bitmap drawTextBottom(Context context, Bitmap bitmap) {
//        String address = SPUtils.get(context, Constance.ADDRESS, "", Constance.JLONGG).toString();
//        String name = SPUtils.get(context, Constance.USERNAME, "", Constance.JLONGG).toString();
//
//        int width = bitmap.getWidth();
//        int hight = bitmap.getHeight();
////        //建立一个空的Bitmap
////        Bitmap icon = Bitmap.createBitmap(width, hight, Bitmap.Config.ARGB_8888);
//        // 初始化画布绘制的图像到icon上
//        Canvas canvas = new Canvas(bitmap);
//        // 建立画笔
//        Paint photoPaint = new Paint();
//        // 获取更清晰的图像采样，防抖动
//        photoPaint.setDither(true);
//        // 过滤一下，抗剧齿
//        photoPaint.setFilterBitmap(true);
//
//        Rect src = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());// 创建一个指定的新矩形的坐标
//        Rect dst = new Rect(0, 0, width, hight);// 创建一个指定的新矩形的坐标
//        canvas.drawBitmap(bitmap, src, dst, photoPaint);// 将photo 缩放或则扩大到dst使用的填充区photoPaint
//        //自定义的画笔
//        TextPaint paint = new TextPaint(Paint.ANTI_ALIAS_FLAG | Paint.DEV_KERN_TEXT_FLAG);// 设置画笔
//        paint.setColor(Color.RED);
//        paint.setTypeface(Typeface.MONOSPACE);// 采用默认的宽度
//        paint.setTextSize(dp2px(context, 10));
////  　　　　drawText(canvas, textPaint, str, 45, hight / 5, width);
////        canvas.drawText();
//        int Y = bitmap.getHeight() - dp2px(context, 10);
//        canvas.drawText(address, dp2px(context, 15), 0, paint);
//        canvas.drawText(name, dp2px(context, 15), Y - dp2px(context, 15), paint);
//        canvas.save(Canvas.ALL_SAVE_FLAG);
//        canvas.restore();
//        return bitmap;
//    }

    public static Bitmap createWaterMaskBitmap(Context context, Bitmap bitmap, Bitmap watermark) {
        if (context == null) {
            return null;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        //创建一个水印bitmap
        Bitmap waterBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);// 创建一个新的和SRC长度宽度一样的位图
        //将该图片作为画布
        Canvas canvas = new Canvas(waterBitmap);
        //在画布 0，0坐标上开始绘制原始图片
        canvas.drawBitmap(bitmap, 0, 0, null);
        //在画布上绘制水印图片
        canvas.drawBitmap(watermark, 0, bitmap.getHeight() - watermark.getHeight(), null);
//        int widthText = ScreenUtils.getScreenWidth(context);
//        int heightText = ScreenUtils.getScreenHeight(context);
//        //创建一个文字bitmap
//        Bitmap textBitmap = Bitmap.createBitmap(widthText, heightText, Config.ARGB_8888);// 创建一个新的和SRC长度宽度一样的位图
//        Canvas canvasText = new Canvas(textBitmap);
//        //在画布 0，0坐标上开始绘制原始图片
////        canvas.drawBitmap(bitmap, 0, 0, null);
//        int Y = bitmap.getHeight() - dp2px(context, 10);
////        int Y = ScreenUtils.getScreenHeight(context) - dp2px(context, 10);
//        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        paint.setDither(true); // 获取跟清晰的图像采样
//        paint.setFilterBitmap(true);// 过滤一些
//        paint.setColor(Color.WHITE);
//        paint.setTextSize(dp2px(context, 10));
//        canvas.drawText(address, dp2px(context, 15), Y, paint);
//        canvas.drawText(name, dp2px(context, 15), Y - dp2px(context, 15), paint);
        // 保存
//        canvas.save(Canvas.ALL_SAVE_FLAG);
        canvas.save();
        // 存储
        canvas.restore();
        return waterBitmap;
    }

//    /**
//     * 设置水印图片在左上角
//     *
//     * @param src
//     * @param watermark
//     * @param paddingLeft
//     * @param paddingTop
//     * @return
//     */
//    public static Bitmap createWaterMaskLeftTop(
//                Context context, Bitmap src, Bitmap watermark,
//                int paddingLeft, int paddingTop) {
//        return createWaterMaskBitmap(src, watermark,
//                    dp2px(context, paddingLeft), dp2px(context, paddingTop));
//    }
//
//    private static Bitmap createWaterMaskBitmap(Bitmap src, Bitmap watermark,
//                                                int paddingLeft, int paddingTop) {
//        if (src == null) {
//            return null;
//        }
//        int width = src.getWidth();
//        int height = src.getHeight();
//        //创建一个bitmap
//        Bitmap newb = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);// 创建一个新的和SRC长度宽度一样的位图
//        //将该图片作为画布
//        Canvas canvas = new Canvas(newb);
//        //在画布 0，0坐标上开始绘制原始图片
//        canvas.drawBitmap(src, 0, 0, null);
//        //在画布上绘制水印图片
//        canvas.drawBitmap(watermark, paddingLeft, paddingTop, null);
//        // 保存
//        canvas.save(Canvas.ALL_SAVE_FLAG);
//        // 存储
//        canvas.restore();
//        return newb;
//    }
//
//    /**
//     * 设置水印图片在右下角
//     *
//     * @param src
//     * @param watermark
//     * @param paddingRight
//     * @param paddingBottom
//     * @return
//     */
//    public static Bitmap createWaterMaskRightBottom(
//                Context context, Bitmap src, Bitmap watermark,
//                int paddingRight, int paddingBottom) {
//        return createWaterMaskBitmap(src, watermark,
//                    src.getWidth() - watermark.getWidth() - dp2px(context, paddingRight),
//                    src.getHeight() - watermark.getHeight() - dp2px(context, paddingBottom));
//    }
//
//    /**
//     * 设置水印图片到右上角
//     *
//     * @param src
//     * @param watermark
//     * @param paddingRight
//     * @param paddingTop
//     * @return
//     */
//    public static Bitmap createWaterMaskRightTop(
//                Context context, Bitmap src, Bitmap watermark,
//                int paddingRight, int paddingTop) {
//        return createWaterMaskBitmap(src, watermark,
//                    src.getWidth() - watermark.getWidth() - dp2px(context, paddingRight),
//                    dp2px(context, paddingTop));
//    }
//
//    /**
//     * 设置水印图片到左下角
//     *
//     * @param src
//     * @param watermark
//     * @param paddingLeft
//     * @param paddingBottom
//     * @return
//     */
//    public static Bitmap createWaterMaskLeftBottom(
//                Context context, Bitmap src, Bitmap watermark,
//                int paddingLeft, int paddingBottom) {
//        return createWaterMaskBitmap(src, watermark, dp2px(context, paddingLeft),
//                    src.getHeight() - watermark.getHeight() - dp2px(context, paddingBottom));
//    }
//
//    /**
//     * 设置水印图片到中间
//     *
//     * @param src
//     * @param watermark
//     * @return
//     */
//    public static Bitmap createWaterMaskCenter(Bitmap src, Bitmap watermark) {
//        return createWaterMaskBitmap(src, watermark,
//                    (src.getWidth() - watermark.getWidth()) / 2,
//                    (src.getHeight() - watermark.getHeight()) / 2);
//    }
//
//    /**
//     * 给图片添加文字到左上角
//     *
//     * @param context
//     * @param bitmap
//     * @param text
//     * @return
//     */
//    public static Bitmap drawTextToLeftTop(Context context, Bitmap bitmap, String text,
//                                           int size, int color, int paddingLeft, int paddingTop) {
//        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        paint.setColor(color);
//        paint.setTextSize(dp2px(context, size));
//        Rect bounds = new Rect();
//        paint.getTextBounds(text, 0, text.length(), bounds);
//        return drawTextToBitmap(context, bitmap, text, paint, bounds,
//                    dp2px(context, paddingLeft),
//                    dp2px(context, paddingTop) + bounds.height());
//    }
//
//    /**
//     * 绘制文字到右下角
//     *
//     * @param context
//     * @param bitmap
//     * @param text
//     * @param size
//     * @param color
//     * @return
//     */
//    public static Bitmap drawTextToRightBottom(Context context, Bitmap bitmap, String text,
//                                               int size, int color, int paddingRight, int paddingBottom) {
//        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        paint.setColor(color);
//        paint.setTextSize(dp2px(context, size));
//        Rect bounds = new Rect();
//        paint.getTextBounds(text, 0, text.length(), bounds);
//        return drawTextToBitmap(context, bitmap, text, paint, bounds,
//                    bitmap.getWidth() - bounds.width() - dp2px(context, paddingRight),
//                    bitmap.getHeight() - dp2px(context, paddingBottom));
//    }
//
//    /**
//     * 绘制文字到右上方
//     *
//     * @param context
//     * @param bitmap
//     * @param text
//     * @param size
//     * @param color
//     * @param paddingRight
//     * @param paddingTop
//     * @return
//     */
//    public static Bitmap drawTextToRightTop(Context context, Bitmap bitmap, String text,
//                                            int size, int color, int paddingRight, int paddingTop) {
//        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        paint.setColor(color);
//        paint.setTextSize(dp2px(context, size));
//        Rect bounds = new Rect();
//        paint.getTextBounds(text, 0, text.length(), bounds);
//        return drawTextToBitmap(context, bitmap, text, paint, bounds,
//                    bitmap.getWidth() - bounds.width() - dp2px(context, paddingRight),
//                    dp2px(context, paddingTop) + bounds.height());
//    }
//
//    /**
//     * 绘制文字到左下方
//     *
//     * @param context
//     * @param bitmap
//     * @param text
//     * @param size
//     * @param color
//     * @param paddingLeft
//     * @param paddingBottom
//     * @return
//     */
//    public static Bitmap drawTextToLeftBottom(Context context, Bitmap bitmap, String text,
//                                              int size, int color, int paddingLeft, int paddingBottom) {
//        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        paint.setColor(color);
//        paint.setTextSize(dp2px(context, size));
//        Rect bounds = new Rect();
//        paint.getTextBounds(text, 0, text.length(), bounds);
//        return drawTextToBitmap(context, bitmap, text, paint, bounds,
//                    dp2px(context, paddingLeft),
//                    bitmap.getHeight() - dp2px(context, paddingBottom));
//    }
//
//    public static Bitmap createBitmap(Bitmap src, String str) {
//        int w = src.getWidth();
//        int h = src.getHeight();
//
//        Date date = new Date();
//        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//        String time = format.format(date);
//
//        String mstrTitle = str + time;
//        Bitmap bmpTemp = Bitmap.createBitmap(w, h,
//                    Bitmap.Config.ARGB_8888);
//        Canvas canvas = new Canvas(bmpTemp);
//        Paint p = new Paint();
//        String familyName = "宋体";
//        Typeface font = Typeface.create(familyName, Typeface.BOLD);
//        p.setColor(Color.BLUE);
//        p.setTypeface(font);
//        p.setTextSize(22);
//        canvas.drawBitmap(src, 0, 0, p);
//        canvas.drawText(mstrTitle, 0, 20, p);
//        canvas.save(Canvas.ALL_SAVE_FLAG);
//        canvas.restore();
//        return bmpTemp;
//    }
//
//
//    /**
//     * 绘制文字到中间
//     *
//     * @param context
//     * @param bitmap
//     * @param text
//     * @param size
//     * @param color
//     * @return
//     */
//    public static Bitmap drawTextToCenter(Context context, Bitmap bitmap, String text,
//                                          int size, int color) {
//        TextPaint paint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
//        paint.setColor(color);
//        paint.setTextSize(dp2px(context, size));
//        Rect bounds = new Rect();
//        paint.getTextBounds(text, 0, text.length(), bounds);
//        return drawTextToBitmap(context, bitmap, text, paint, bounds,
//                    (bitmap.getWidth() - bounds.width()) / 2,
//                    (bitmap.getHeight() + bounds.height()) / 2);
//    }
//
//    //图片上绘制文字
//    private static Bitmap drawTextToBitmap(Context context, Bitmap bitmap, String text,
//                                           Paint paint, Rect bounds, int paddingLeft, int paddingTop) {
//        android.graphics.Bitmap.Config bitmapConfig = bitmap.getConfig();
//
//        paint.setDither(true); // 获取跟清晰的图像采样
//        paint.setFilterBitmap(true);// 过滤一些
//        if (bitmapConfig == null) {
//            bitmapConfig = android.graphics.Bitmap.Config.ARGB_8888;
//        }
//        bitmap = bitmap.copy(bitmapConfig, true);
//        Canvas canvas = new Canvas(bitmap);
//
//        canvas.drawText(text, paddingLeft, paddingTop, paint);
//        return bitmap;
//    }
//
//    /**
//     * 缩放图片
//     *
//     * @param src
//     * @param w
//     * @param h
//     * @return
//     */
//    public static Bitmap scaleWithWH(Bitmap src, double w, double h) {
//        if (w == 0 || h == 0 || src == null) {
//            return src;
//        } else {
//            // 记录src的宽高
//            int width = src.getWidth();
//            int height = src.getHeight();
//            // 创建一个matrix容器
//            Matrix matrix = new Matrix();
//            // 计算缩放比例
//            float scaleWidth = (float) (w / width);
//            float scaleHeight = (float) (h / height);
//            // 开始缩放
//            matrix.postScale(scaleWidth, scaleHeight);
//            // 创建缩放后的图片
//            return Bitmap.createBitmap(src, 0, 0, width, height, matrix, true);
//        }
//    }

    //在这里抽取了一个方法   可以封装到自己的工具类中...
    public static File getFile(Bitmap bitmap) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, baos);
        File file = new File(Environment.getExternalStorageDirectory() + "/temp.jpg");
        if (file.exists()) {
            file.delete();
        }
        try {
            file.createNewFile();
            FileOutputStream fos = new FileOutputStream(file);
            InputStream is = new ByteArrayInputStream(baos.toByteArray());
            int x = 0;
            byte[] b = new byte[1024 * 100];
            while ((x = is.read(b)) != -1) {
                fos.write(b, 0, x);
            }
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return file;
    }


    /**
     * dip转pix
     *
     * @param context
     * @param dp
     * @return
     */
    public static int dp2px(Context context, float dp) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }


    public interface CompressImageListener {
        public void compressSuccess(RequestParams requestParams);
    }
}
