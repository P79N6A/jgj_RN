package com.jizhi.jlongg.main.util;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class UtilFile {
    /**
     * app 图片保存路径
     */
    public static String JGJIMAGEPATH = Environment.getExternalStorageDirectory() + "/Jgj";
    /**
     * 二维码路径
     */
    public static String QRIMAGEPATH = Environment.getExternalStorageDirectory() + "/Jgj/QcPic";

    public static String picDir() {
        File destDir = new File(JGJIMAGEPATH + File.separator);// 文件目录
        if (!destDir.exists()) {// 判断目录是否存在，不存在创建
            destDir.mkdir();// 创建目录
        }
        return destDir.getPath();
    }

    public static String qRCodeDir() {
        File destDir = new File(QRIMAGEPATH);// 文件目录
        if (!destDir.exists()) {// 判断目录是否存在，不存在创建
            destDir.mkdirs();// 创建目录
        }
        return destDir.getAbsolutePath() + File.separator;
    }

    public static Object[] saveBitmapToFile(String url) throws IOException {
        File imageFile = null;
        if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) {//内存卡是否可用
            Object[] objects = new Object[2];
            try {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                Bitmap bitmap = PicSizeUtils.readBitmapByInputSize(url, 300, 300);
                if (bitmap != null) {
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos);
                    // 获取扩展存储设备的文件目录
                    File destDir = new File(UtilFile.JGJIMAGEPATH + File.separator + "jtemp");// 文件目录
                    if (!destDir.exists()) {// 判断目录是否存在，不存在创建
                        destDir.mkdirs();// 创建目录
                    }
                    // 打开文件
                    imageFile = new File(destDir.getAbsolutePath() + File.separator + "images1.JPEG");
                    // 判断文件是否存在,不存在则创建
                    if (!imageFile.exists()) {
                        imageFile.createNewFile();// 创建文件
                    }
                    // 写数据 注意这里，两个参数，第一个是写入的文件，第二个是指是覆盖还是追加，
                    // 默认是覆盖的，就是不写第二个参数，这里设置为true就是说不覆盖，是在后面追加。
                    FileOutputStream outputStream = new FileOutputStream(imageFile, false);
                    outputStream.write(baos.toByteArray());// 写入内容
                    outputStream.close();// 关闭流
                    baos.close();
                    objects[0] = imageFile.getAbsolutePath();
                    objects[1] = bitmap;
                }
                return objects;
            } catch (Exception e) {
                e.getStackTrace();
            }
        }
        return null;
    }

    /**
     * Constructs an intent for image cropping. 调用图片剪辑程序
     */
    public static Intent getCropImageIntent(File file, File cropPath) {
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(Uri.fromFile(file), "image/*")
                .putExtra("crop", "true")
                .putExtra("aspectX", 1)
                .putExtra("aspectY", 1)
                .putExtra("outputX", 400)
                .putExtra("outputY", 400)
                .putExtra("scale", true)//黑边
                .putExtra("circleCrop", true)
                .putExtra("scaleUpIfNeeded", true)//黑边
                .putExtra("return-data", false)
                .putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(cropPath));
        return intent;
    }


    /**
     * Constructs an intent for image cropping. 调用图片剪辑程序
     */
    public static Intent getCropImageIntent(File file) {
        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(Uri.fromFile(file), "image/*")
                .putExtra("crop", "true")
                .putExtra("aspectX", 1)
                .putExtra("aspectY", 1)
                .putExtra("outputX", 400)
                .putExtra("outputY", 400)
                .putExtra("scale", true)//黑边
                .putExtra("circleCrop", true)
                .putExtra("scaleUpIfNeeded", true)//黑边
                .putExtra("return-data", false)
                .putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(file));
        return intent;
    }


    /**
     * 复制单个文件
     *
     * @param oldPath String 原文件路径 如：c:/fqf.txt
     * @param newPath String 复制后路径 如：f:/fqf.txt
     * @return boolean
     */
    public static void copyFile(String oldPath, String newPath) {
        FileOutputStream fs = null;
        InputStream inStream = null;
        try {
            int bytesum = 0;
            int byteread = 0;
            File newfile = new File(newPath);
            if (newfile.exists()) {
                newfile.delete();
            }
            inStream = new FileInputStream(oldPath); //读入原文件
            fs = new FileOutputStream(newPath);
            byte[] buffer = new byte[1444];
            while ((byteread = inStream.read(buffer)) != -1) {
                bytesum += byteread; //字节数 文件大小
                fs.write(buffer, 0, byteread);
            }
        } catch (Exception e) {
            System.out.println("复制单个文件操作出错");
            e.printStackTrace();
        } finally {
            if (fs != null) {
                try {
                    fs.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (inStream != null) {
                try {
                    inStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 递归删除文件和文件夹
     *
     * @param file 要删除的根目录
     */
    public static void RecursionDeleteFile(File file) {
        if (file.isFile()) {
            file.delete();
            return;
        }
        if (file.isDirectory()) {
            File[] childFile = file.listFiles();
            if (childFile == null || childFile.length == 0) {
                file.delete();
                return;
            }
            for (File f : childFile) {
                RecursionDeleteFile(f);
            }
            file.delete();
        }
    }


}
