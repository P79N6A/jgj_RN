package com.hcs.uclient.utils;

import android.content.Context;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class FUtils {

    /**
     * 复制单个文件
     *
     * @param oldPath String 原文件路径 如：c:/fqf.txt
     * @param newPath String 复制后路径 如：f:/fqf.txt
     * @return boolean
     */
    public static void copyFile(String oldPath, String newPath) {
        try {
            int bytesum = 0;
            int byteread = 0;
            File oldfile = new File(oldPath);
            if (oldfile.exists()) { //文件存在时
                InputStream inStream = new FileInputStream(oldPath); //读入原文件
                FileOutputStream fs = new FileOutputStream(newPath);
                byte[] buffer = new byte[1444];
                int length;
                while ((byteread = inStream.read(buffer)) != -1) {
                    bytesum += byteread; //字节数 文件大小
                    fs.write(buffer, 0, byteread);
                }
                inStream.close();
            }
        } catch (Exception e) {
            System.out.println("复制单个文件操作出错");
            e.printStackTrace();
        }
    }

    /**
     * 判断sd卡是否存在
     *
     * @return
     */
    public static boolean existSDCard() {
        return android.os.Environment.getExternalStorageState().equals(
                android.os.Environment.MEDIA_MOUNTED);
    }

    /**
     * 复制单个文件 并且删除原文件
     *
     * @param oldPath String 原文件路径 如：c:/fqf.txt
     * @param newPath String 复制后路径 如：f:/fqf.txt
     * @return boolean
     */
    public static void copyFileAndDeleteOldFile(String oldPath, String newPath) {
        InputStream inputStream = null;
        FileOutputStream outputStream = null;
        try {
            File oldfile = new File(oldPath);
            if (oldfile.exists()) { //文件存在时
                inputStream = new FileInputStream(oldPath); //读入原文件
                outputStream = new FileOutputStream(newPath);
                byte[] buffer = new byte[1444];
                int byteread;
                while ((byteread = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, byteread);
                }
                File file = new File(oldPath);
                if (file.exists()) { //删除原文件
                    file.delete();
                }
            }
        } catch (Exception e) {
            System.out.println("复制单个文件操作出错");
            e.printStackTrace();
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (inputStream != null) {
                try {
                    inputStream.close();
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
    public static void deleteFile(File file) {
        if (!file.exists()) {
            return;
        } else {
            System.out.println(file.getPath());
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
                    System.out.println(f.getAbsolutePath());
                    deleteFile(f);
                }
                file.delete();
            }
        }
    }

    /** * 从raw中读取txt */
//	private void readFromRaw(Context context) {
//		try {
//			InputStream is = context.getResources().openRawResource(R.raw.qq);
//			String text = readTextFromSDcard(is);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//	}

    /**
     * 从assets中读取txt
     */
    public static String readFromAssets(Context context, String fileName) {
        String text = "";
        try {
            InputStream is = context.getAssets().open(fileName);
            text = readTextFromSDcard(is);
        } catch (Exception e) {
            e.printStackTrace();
            text = "";
        }
        return text;
    }

    /**
     * 按行读取txt * * @param is * @return * @throws Exception
     */
    private static String readTextFromSDcard(InputStream is) throws Exception {
        InputStreamReader reader = new InputStreamReader(is);
        BufferedReader bufferedReader = new BufferedReader(reader);
        StringBuffer buffer = new StringBuffer("");
        String str;
        while ((str = bufferedReader.readLine()) != null) {
            buffer.append(str);
            buffer.append("\n");
        }
        return buffer.toString();
    }

}
