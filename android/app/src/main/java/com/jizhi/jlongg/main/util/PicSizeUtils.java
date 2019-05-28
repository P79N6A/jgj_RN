package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Environment;

import com.jizhi.jlongg.main.bean.Photo;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 图片帮助类
 *
 * @author zhaoping
 */
public class PicSizeUtils {

    public static int IMAGE_BIG_SIZE = 50;


    /**
     * 添加到图库
     */
    public static void galleryAddPic(Context context, String path) {
        Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        File f = new File(path);
        Uri contentUri = Uri.fromFile(f);
        mediaScanIntent.setData(contentUri);
        context.sendBroadcast(mediaScanIntent);
    }

    /**
     * 获取保存图片的目录
     *
     * @return
     */
    public static File getAlbumDir() {
        // DIRECTORY_PICTURES 图片存放的标准目录。 手机截图等相关图片操作都放在此目录下
        File dir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), getAlbumName());
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return dir;
    }


    /**
     * 获取保存 隐患检查的图片文件夹名称
     *
     * @return
     */
    public static String getAlbumName() {
        return "jlg";
    }

    /**
     * 根据路径删除图片
     *
     * @param path
     */
    public static void deleteTempFile(String path) {
        File file = new File(path);
        if (file.exists()) {
            file.delete();
        }
    }


    /**
     * 根据路径获得突破并压缩返回bitmap用于显示
     *
     * @param filePath             图片ra
     * @param imageName            图片名称
     * @param isDeleteOriginalFile 是否删除源文件
     * @return
     */
    public static Photo getSmallBitmap(String filePath, String imageName, boolean isDeleteOriginalFile) {
        final BitmapFactory.Options options = new BitmapFactory.Options();
        //不在内存中加载图片
        options.inJustDecodeBounds = true;
        //创建Bitmap
        Bitmap tempBitmap = BitmapFactory.decodeFile(filePath, options);
        //计算缩放值
        options.inSampleSize = calculateInSampleSize(options, 480, 800);
//        //内存中加载图片
        options.inJustDecodeBounds = false;
        //获得原图旋转角度
        int degree = getBitmapDegree(filePath);
        //获得旋转后的图片
        Bitmap bitmap = rotateBitmapByDegree(BitmapFactory.decodeFile(filePath, options), degree);
        File compressFile = new File(PicSizeUtils.getAlbumDir(), "small_" + imageName);
        Photo photo = compressImage(compressFile, bitmap);
        if (isDeleteOriginalFile) {
            deleteTempFile(filePath);//删除拍摄原图
        }
        return photo;
    }

    private static Photo compressImage(File file, Bitmap bitmap) {
        FileOutputStream fileOut = null;
        ByteArrayOutputStream baos = null;
        try {
            fileOut = new FileOutputStream(file);
            baos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
            int options = 100;
            while (baos.toByteArray().length / 1024 > IMAGE_BIG_SIZE) {  //循环判断如果压缩后图片是否大于60kb,大于继续压缩
                baos.reset();//重置baos即清空baos
                options -= 10;//每次都减少10
                bitmap.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            }
            baos.writeTo(fileOut);
            baos.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (fileOut != null) {
                try {
                    fileOut.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (baos != null) {
                try {
                    baos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据baos存放到ByteArrayInputStream中  
        Bitmap bim = BitmapFactory.decodeStream(isBm, null, null);
        if (bim != null) {
            Photo photo = new Photo(bim, file.getAbsolutePath());
            return photo;
        }
        return null;//把ByteArrayInputStream数据生成图片  
    }


    /**
     * 计算图片的缩放值
     *
     * @param options
     * @param reqWidth
     * @param reqHeight
     * @return
     */
    public static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
        // Raw height and width of image
        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;
        if (height > reqHeight || width > reqWidth) {
            // Calculate ratios of height and width to requested height and
            // width
            final int heightRatio = Math.round((float) height / (float) reqHeight);
            final int widthRatio = Math.round((float) width / (float) reqWidth);
//			 Choose the smallest ratio as inSampleSize value, this will
//			 guarantee a final image with both dimensions larger than or equal to the
//			 requested height and width.
            inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
        }
        return inSampleSize;
    }

    /**
     * 读取图片的旋转的角度
     *
     * @param path 图片绝对路径
     * @return 图片的旋转角度
     */
    public static int getBitmapDegree(String path) {
        int degree = 0;
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            int orientation = exifInterface.getAttributeInt(
                    ExifInterface.TAG_ORIENTATION,
                    ExifInterface.ORIENTATION_NORMAL);
            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    degree = 90;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    degree = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    degree = 270;
                    break;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return degree;
    }

    // 2、将图片按照某个角度进行旋转

    /**
     * 将图片按照某个角度进行旋转
     *
     * @param bm     需要旋转的图片
     * @param degree 旋转角度
     * @return 旋转后的图片
     */
    public static Bitmap rotateBitmapByDegree(Bitmap bm, int degree) {
        Bitmap returnBm = null;
        // 根据旋转角度，生成旋转矩阵
        Matrix matrix = new Matrix();
        matrix.postRotate(degree);
        try {
            // 将原始图片按照旋转矩阵进行旋转，并得到新的图片
            returnBm = Bitmap.createBitmap(bm, 0, 0, bm.getWidth(), bm.getHeight(), matrix, true);
        } catch (OutOfMemoryError e) {

        } catch (Exception e) {
        }
        if (returnBm == null) {
            returnBm = bm;
        }
        if (bm != returnBm) {
            bm.recycle();
        }
        return returnBm;
    }


    /**
     * 把程序拍摄的照片放到 SD卡的 Pictures目录中 jlg 文件夹中
     * 照片的命名规则为：jlg_20150125_173729.jpg
     *
     * @return
     * @throws IOException
     */
    public static File createImageRandomName() {
        SimpleDateFormat simple = new SimpleDateFormat("yyyyMMdd_HHmmss");
        StringBuffer buffer = new StringBuffer();
        buffer.append("jlg_" + simple.format(new Date()) + ".jpg");
        File image = new File(PicSizeUtils.getAlbumDir(), buffer.toString());
        return image;
    }


    public static Bitmap revitionImageSize(String path) throws IOException {
        BufferedInputStream in = new BufferedInputStream(new FileInputStream(new File(path)));
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeStream(in, null, options);
        in.close();
        int i = 0;
        Bitmap bitmap = null;
        while (true) {
            if ((options.outWidth >> i <= 1000) && (options.outHeight >> i <= 1000)) {
                in = new BufferedInputStream(new FileInputStream(new File(path)));
                options.inSampleSize = (int) Math.pow(2.0D, i);
                options.inJustDecodeBounds = false;
                bitmap = BitmapFactory.decodeStream(in, null, options);
                break;
            }
            i += 1;
        }
        return bitmap;
    }

    public static String SDPATH = Environment.getExternalStorageDirectory() + "/formats/";


    public static void deleteDir() {
        // DIRECTORY_PICTURES 图片存放的标准目录。 手机截图等相关图片操作都放在此目录下
        File dir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), getAlbumName());
        if (dir.exists()) {
            dir.delete();// 删除目录本身
        }
    }


    public static Bitmap readBitmapByInputSize(String filePath, int outWidth, int outHeight) {
        //outWidth和outHeight是目标图片的最大宽度和高度，用作限制
        FileInputStream fs = null;
        BufferedInputStream bs = null;
        try {
            fs = new FileInputStream(filePath);
            bs = new BufferedInputStream(fs);
            BitmapFactory.Options options = setBitmapOption(filePath, outWidth, outHeight);
            Bitmap degreeBitmap = rotateBitmapByDegree(BitmapFactory.decodeStream(bs, null, options), getBitmapDegree(filePath));//修改图片的旋转角度 以免出现图片摆放不正确的Bug
            return degreeBitmap;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (bs != null) {
                    bs.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (fs != null) {
                try {
                    fs.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        return null;
    }

    private static BitmapFactory.Options setBitmapOption(String file, int width, int height) {
        BitmapFactory.Options opt = new BitmapFactory.Options();
        opt.inJustDecodeBounds = true;
        //设置只是解码图片的边距，此操作目的是度量图片的实际宽度和高度
        BitmapFactory.decodeFile(file, opt);

        int outWidth = opt.outWidth; //获得图片的实际高和宽
        int outHeight = opt.outHeight;
        opt.inDither = false;
        opt.inPreferredConfig = Bitmap.Config.RGB_565;
        //设置加载图片的颜色数为16bit，默认是RGB_8888，表示24bit颜色和透明通道，但一般用不上
        opt.inSampleSize = 1;
        //设置缩放比,1表示原比例，2表示原来的四分之一....
        //计算缩放比
        if (outWidth != 0 && outHeight != 0 && width != 0 && height != 0) {
            int sampleSize = (outWidth / width + outHeight / height) / 2;
            opt.inSampleSize = sampleSize;
        }

        opt.inJustDecodeBounds = false;//最后把标志复原
        return opt;
    }


}
