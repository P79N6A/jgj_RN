package com.compress;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.support.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class Luban1 {

    public static final int FIRST_GEAR = 1;
    public static final int THIRD_GEAR = 3;
    //


    private static final String TAG = "Luban";

    public static String DEFAULT_DISK_CACHE_DIR = File.separator + "jtemp";

    private static volatile Luban1 INSTANCE;

    private final File mCacheDir;


    private OnCompressListener compressListener;

    private File mFile;

    private String saveFileName;
    private int gear = THIRD_GEAR;

    Luban1(File cacheDir) {
        mCacheDir = cacheDir;
    }

    /**
     * Returns a directory with a default name in the private cache directory of the application to use to store
     * retrieved media and thumbnails.
     *
     * @param context A context.
     * @see #getPhotoCacheDir(Context, String)
     */
    public static File getPhotoCacheDir(Context context) {
        return getPhotoCacheDir(context, Luban1.DEFAULT_DISK_CACHE_DIR);
    }

    /**
     * Returns a directory with the given name in the private cache directory of the application to use to store
     * retrieved media and thumbnails.
     *
     * @param context   A context.
     * @param cacheName The name of the subdirectory in which to store the cache.
     * @see #getPhotoCacheDir(Context)
     */
    public static File getPhotoCacheDir(Context context, String cacheName) {
        File cacheDir = new File(context.getCacheDir() + cacheName);
        if (!cacheDir.exists()) {
            cacheDir.mkdirs();
        }
        return cacheDir;
    }

    public static Luban1 get(Context context) {
        if (INSTANCE == null) INSTANCE = new Luban1(Luban1.getPhotoCacheDir(context));
        return INSTANCE;
    }

    public File launch() {
        Preconditions.checkNotNull(mFile, "the image file cannot be null, please call .load() before this method!");
        return thirdCompress(mFile.getAbsolutePath());
    }

    public Luban1 load(File file) {
        mFile = file;
        return this;
    }

    public Luban1 setCompressListener(OnCompressListener listener) {
        compressListener = listener;
        return this;
    }

    public Luban1 putGear(int gear) {
        this.gear = gear;
        return this;
    }

    private File thirdCompress(@NonNull String filePath) {
        String thumb = mCacheDir.getAbsolutePath() + "/" + saveFileName;

        double scale;

        int angle = getImageSpinAngle(filePath);
        int width = getImageSize(filePath)[0];
        int height = getImageSize(filePath)[1];
        int thumbW = width % 2 == 1 ? width + 1 : width;
        int thumbH = height % 2 == 1 ? height + 1 : height;

        width = thumbW > thumbH ? thumbH : thumbW;
        height = thumbW > thumbH ? thumbW : thumbH;

        double c = ((double) width / height);

        if (c <= 1 && c > 0.5625) {
            if (height < 1664) {
                scale = (width * height) / Math.pow(1664, 2) * 150;
                scale = scale < 60 ? 60 : scale;
            } else if (height >= 1664 && height < 4990) {
                thumbW = width / 2;
                thumbH = height / 2;
                scale = (thumbW * thumbH) / Math.pow(2495, 2) * 300;
                scale = scale < 60 ? 60 : scale;
            } else if (height >= 4990 && height < 10240) {
                thumbW = width / 4;
                thumbH = height / 4;
                scale = (thumbW * thumbH) / Math.pow(2560, 2) * 300;
                scale = scale < 100 ? 100 : scale;
            } else {
                int multiple = height / 1280 == 0 ? 1 : height / 1280;
                thumbW = width / multiple;
                thumbH = height / multiple;
                scale = (thumbW * thumbH) / Math.pow(2560, 2) * 300;
                scale = scale < 100 ? 100 : scale;
            }
        } else if (c <= 0.5625 && c > 0.5) {
            int multiple = height / 1280 == 0 ? 1 : height / 1280;
            thumbW = width / multiple;
            thumbH = height / multiple;
            scale = (thumbW * thumbH) / (1440.0 * 2560.0) * 200;
            scale = scale < 100 ? 100 : scale;
        } else {
            int multiple = (int) Math.ceil(height / (1280.0 / c));
            thumbW = width / multiple;
            thumbH = height / multiple;
            scale = ((thumbW * thumbH) / (1280.0 * (1280 / c))) * 500;
            scale = scale < 100 ? 100 : scale;
        }

        return compress(filePath, thumb, thumbW, thumbH, angle, (long) scale);
    }

    private File firstCompress(@NonNull File file) {
        int minSize = 60;
        int longSide = 720;
        int shortSide = 1280;

        String filePath = file.getAbsolutePath();
        String thumbFilePath = mCacheDir.getAbsolutePath() + "/" + System.currentTimeMillis();
        long size = 0;
        long maxSize = file.length() / 5;

        int angle = getImageSpinAngle(filePath);
        int[] imgSize = getImageSize(filePath);
        int width = 0, height = 0;
        if (imgSize[0] <= imgSize[1]) {
            double scale = (double) imgSize[0] / (double) imgSize[1];
            if (scale <= 1.0 && scale > 0.5625) {
                width = imgSize[0] > shortSide ? shortSide : imgSize[0];
                height = width * imgSize[1] / imgSize[0];
                size = minSize;
            } else if (scale <= 0.5625) {
                height = imgSize[1] > longSide ? longSide : imgSize[1];
                width = height * imgSize[0] / imgSize[1];
                size = maxSize;
            }
        } else {
            double scale = (double) imgSize[1] / (double) imgSize[0];
            if (scale <= 1.0 && scale > 0.5625) {
                height = imgSize[1] > shortSide ? shortSide : imgSize[1];
                width = height * imgSize[0] / imgSize[1];
                size = minSize;
            } else if (scale <= 0.5625) {
                width = imgSize[0] > longSide ? longSide : imgSize[0];
                height = width * imgSize[1] / imgSize[0];
                size = maxSize;
            }
        }

        return compress(filePath, thumbFilePath, width, height, angle, size);
    }

    /**
     * obtain the image's width and height
     *
     * @param imagePath the path of image
     */
    public int[] getImageSize(String imagePath) {
        int[] res = new int[2];

        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        options.inSampleSize = 1;
        BitmapFactory.decodeFile(imagePath, options);

        res[0] = options.outWidth;
        res[1] = options.outHeight;

        return res;
    }

    /**
     * obtain the thumbnail that specify the size
     *
     * @param imagePath the target image path
     * @param width     the width of thumbnail
     * @param height    the height of thumbnail
     * @return {@link Bitmap}
     */
    private Bitmap compress(String imagePath, int width, int height) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(imagePath, options);

        int outH = options.outHeight;
        int outW = options.outWidth;
        int inSampleSize = 1;

        if (outH > height || outW > width) {
            int halfH = outH / 2;
            int halfW = outW / 2;

            while ((halfH / inSampleSize) > height && (halfW / inSampleSize) > width) {
                inSampleSize *= 2;
            }
        }

        options.inSampleSize = inSampleSize;

        options.inJustDecodeBounds = false;

        int heightRatio = (int) Math.ceil(options.outHeight / (float) height);
        int widthRatio = (int) Math.ceil(options.outWidth / (float) width);

        if (heightRatio > 1 || widthRatio > 1) {
            if (heightRatio > widthRatio) {
                options.inSampleSize = heightRatio;
            } else {
                options.inSampleSize = widthRatio;
            }
        }
        options.inJustDecodeBounds = false;

        return BitmapFactory.decodeFile(imagePath, options);
    }

    /**
     * obtain the image rotation angle
     *
     * @param path path of target image
     */
    private int getImageSpinAngle(String path) {
        int degree = 0;
        try {
            ExifInterface exifInterface = new ExifInterface(path);
            int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
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

    /**
     * 指定参数压缩图片
     * create the thumbnail with the true rotate angle
     *
     * @param largeImagePath the big image path
     * @param thumbFilePath  the thumbnail path
     * @param width          width of thumbnail
     * @param height         height of thumbnail
     * @param angle          rotation angle of thumbnail
     * @param size           the file size of image
     */
    private File compress(String largeImagePath, String thumbFilePath, int width, int height, int angle, long size) {
        Bitmap thbBitmap = compress(largeImagePath, width, height);

        thbBitmap = rotatingImage(angle, thbBitmap);

        return saveImage(thumbFilePath, thbBitmap, size);
    }

    /**
     * 旋转图片
     * rotate the image with specified angle
     *
     * @param angle  the angle will be rotating 旋转的角度
     * @param bitmap target image               目标图片
     */
    private static Bitmap rotatingImage(int angle, Bitmap bitmap) {
        //rotate image
        Matrix matrix = new Matrix();
        matrix.postRotate(angle);

        //create a new image
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
    }

    /**
     * 保存图片到指定路径
     * Save image with specified size
     *
     * @param filePath the image file save path 储存路径
     * @param bitmap   the image what be save   目标图片
     * @param size     the file size of image   期望大小
     */
    private File saveImage(String filePath, Bitmap bitmap, long size) {
        Preconditions.checkNotNull(bitmap, TAG + "bitmap cannot be null");
        if (!mCacheDir.exists()) {
            mCacheDir.mkdirs();
        }
        FileOutputStream fileOutputStream = null;
        ByteArrayOutputStream baos = null;
        File result = null;
        try {
            result = new File(filePath + ".JPEG");
            if (!result.exists()) {
                try {
                    result.createNewFile();// 创建文件
                } catch (IOException e) {
                    e.printStackTrace();
                    return null;
                }
            }
            baos = new ByteArrayOutputStream();
            int options = 100;
            bitmap.compress(Bitmap.CompressFormat.JPEG, options, baos);
            while (baos.toByteArray().length / 1024 > size) {
                baos.reset();
                options -= 6;
                bitmap.compress(Bitmap.CompressFormat.JPEG, options, baos);
            }
            fileOutputStream = new FileOutputStream(result.getAbsolutePath(), false);
            fileOutputStream.write(baos.toByteArray());
            fileOutputStream.flush();
            // 写数据 注意这里，两个参数，第一个是写入的文件，第二个是指是覆盖还是追加，
            // 默认是覆盖的，就是不写第二个参数，这里设置为true就是说不覆盖，是在后面追加。
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (fileOutputStream != null) {
                try {
                    fileOutputStream.close();
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
        return result;
    }

    public String getSaveFileName() {
        return saveFileName;
    }

    public Luban1 setSaveFileName(String saveFileName) {
        this.saveFileName = saveFileName;
        return this;
    }
}