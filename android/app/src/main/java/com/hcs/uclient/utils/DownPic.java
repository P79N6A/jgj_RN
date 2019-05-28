package com.hcs.uclient.utils;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.provider.MediaStore;

import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.CommonMethod;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class DownPic {
    private Context Context;
    private CustomProgress customProgress;
    private String fileName;

    public DownPic(Context Context, String fileName) {
        this.Context = Context;
        this.fileName = fileName;
    }

    public static String getSDPath() {
        File sdDir = null;
        boolean sdCardExist = Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED); //判断sd卡是否存在
        if (sdCardExist) {
            sdDir = Environment.getExternalStorageDirectory();//获取跟目录
        }
        return sdDir.toString();
    }


    /**
     * 保存文件
     *
     * @param bm
     * @throws IOException
     */
    public void saveFile(Bitmap bm) throws IOException {
        String path = getSDPath() + "/吉工家账单/";
        File dirFile = new File(path);
        if (!dirFile.exists()) {
            dirFile.mkdir();
        }
        File myCaptureFile = new File(path + fileName);
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(myCaptureFile));
        bm.compress(Bitmap.CompressFormat.JPEG, 100, bos);
        bos.flush();
        bos.close();
    }

    public static void saveImageToGallery(Context context, Bitmap bmp) {
        // 首先保存图片
//        File appDir = new File(Environment.getExternalStorageDirectory(), "Boohee");
//        if (!appDir.exists()) {
//            appDir.mkdir();
//        }
        String path = getSDPath() + "/吉工家账单/";
        File dirFile = new File(path);
        if (!dirFile.exists()) {
            dirFile.mkdir();
        }
        String fileName = System.currentTimeMillis() + ".jpg";
        File file = new File(path, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 其次把文件插入到系统图库
        try {
//            MediaStore.Images.Media.insertImage(context.getContentResolver(),
//                        file.getAbsolutePath(), fileName, null);

            try {
                ContentResolver cr = context.getContentResolver();
                insertImage(cr, bmp, fileName, "a photo from jgjia", "我是filename没啥用");
            } catch (Exception e) {
                e.printStackTrace();
            }
            //对某些不更新相册的应用程序强制刷新
            Intent intent2 = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            Uri uri = Uri.fromFile(new File("/sdcard/image.jpg"));//固定写法
            intent2.setData(uri);
            context.sendBroadcast(intent2);


        } catch (Exception e) {
            e.printStackTrace();
        }
        // 最后通知图库更新
        context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://" + path)));
    }

    private class MyTask extends AsyncTask<String, Integer, String> {
        //onPreExecute方法用于在执行后台任务前做一些UI操作
        @Override
        protected void onPreExecute() {
//            Log.e("-------------------", "========onPreExecute=========");
            if (customProgress == null) {
                customProgress = new CustomProgress(Context);
            }
            customProgress.show(Context, "正在下载中", false);
        }

        //doInBackground方法内部执行后台任务,不可在此方法内修改UI
        @Override
        protected String doInBackground(String... params) {
//            Log.e("-------------------", "========doInBackground=========");
            try {
                HttpClient client = new DefaultHttpClient();
                URL myFileUrl = new URL(params[0]);
                HttpURLConnection conn;
                conn = (HttpURLConnection) myFileUrl.openConnection();
                conn.setDoInput(true);
                conn.connect();
                InputStream is = conn.getInputStream();
                Bitmap bitmap = BitmapFactory.decodeStream(is);
                saveImageToGallery(Context, bitmap);

            } catch (Exception e) {
                e.getMessage();
            }
            return null;
        }

        //onProgressUpdate方法用于更新进度信息
        @Override
        protected void onProgressUpdate(Integer... progresses) {
        }

        //onPostExecute方法用于在执行完后台任务后更新UI,显示结果
        @Override
        protected void onPostExecute(String result) {
//            Log.e("-------------------", "========onPostExecute=========");
            if (null != customProgress) {
                customProgress.closeDialog();
            }
            CommonMethod.makeNoticeLong(Context, "下载成功,请在SD卡吉工家账单下查看", CommonMethod.SUCCESS);
        }

        //onCancelled方法用于在取消执行中的任务时更改UI
        @Override
        protected void onCancelled() {
        }
    }

    public void downLoadPic(String url) {
        MyTask myTask = new MyTask();
        myTask.execute(url);
    }

    /**
     * Insert an image and create a thumbnail for it.
     *
     * @param cr          The content resolver to use
     * @param source      The stream to use for the image
     * @param title       The name of the image
     * @param description The description of the image
     * @return The URL to the newly created image, or <code>null</code> if the image failed to be stored
     * for any reason.
     */
    public static String insertImage(ContentResolver cr, Bitmap source,
                                     String title, String description, String fileName) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.TITLE, title);
        values.put(MediaStore.Images.Media.DESCRIPTION, description);
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg");
        values.put(MediaStore.Images.Media.DATE_ADDED, System.currentTimeMillis());
        values.put(MediaStore.Images.Media.DATE_MODIFIED, System.currentTimeMillis());
        values.put(MediaStore.Images.Media.DATE_TAKEN, System.currentTimeMillis());
        values.put(MediaStore.Images.Media.DISPLAY_NAME, fileName);
        values.put(MediaStore.Images.Media.LATITUDE, 36);
        values.put(MediaStore.Images.Media.LONGITUDE, 120);
        values.put(MediaStore.Images.Media.BUCKET_DISPLAY_NAME, "6666");


        Uri url = null;
        String stringUrl = null;    /* value to be returned */

        try {
            url = cr.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);

            if (source != null) {
                OutputStream imageOut = cr.openOutputStream(url);
                try {
                    source.compress(Bitmap.CompressFormat.JPEG, 36, imageOut);
                } finally {
                    imageOut.close();
                }

                long id = ContentUris.parseId(url);
                // Wait until MINI_KIND thumbnail is generated.
                Bitmap miniThumb = MediaStore.Images.Thumbnails.getThumbnail(cr, id,
                            MediaStore.Images.Thumbnails.MINI_KIND, null);
                // This is for backward compatibility.
                Bitmap microThumb = StoreThumbnail(cr, miniThumb, id, 50F, 50F,
                            MediaStore.Images.Thumbnails.MICRO_KIND);
            } else {
                cr.delete(url, null, null);
                url = null;
            }
        } catch (Exception e) {
            if (url != null) {
                cr.delete(url, null, null);
                url = null;
            }
        }

        if (url != null) {
            stringUrl = url.toString();
        }

        return stringUrl;
    }

    private static final Bitmap StoreThumbnail(
                ContentResolver cr,
                Bitmap source,
                long id,
                float width, float height,
                int kind) {
        // create the matrix to scale it
        Matrix matrix = new Matrix();

        float scaleX = width / source.getWidth();
        float scaleY = height / source.getHeight();

        matrix.setScale(scaleX, scaleY);

        Bitmap thumb = Bitmap.createBitmap(source, 0, 0,
                    source.getWidth(),
                    source.getHeight(), matrix,
                    true);

        ContentValues values = new ContentValues(4);
        values.put(MediaStore.Images.Thumbnails.KIND, kind);
        values.put(MediaStore.Images.Thumbnails.IMAGE_ID, (int) id);
        values.put(MediaStore.Images.Thumbnails.HEIGHT, thumb.getHeight());
        values.put(MediaStore.Images.Thumbnails.WIDTH, thumb.getWidth());

        Uri url = cr.insert(MediaStore.Images.Thumbnails.EXTERNAL_CONTENT_URI, values);

        try {
            OutputStream thumbOut = cr.openOutputStream(url);

            thumb.compress(Bitmap.CompressFormat.JPEG, 100, thumbOut);
            thumbOut.close();
            return thumb;
        } catch (FileNotFoundException ex) {
            return null;
        } catch (IOException ex) {
            return null;
        }
    }
}