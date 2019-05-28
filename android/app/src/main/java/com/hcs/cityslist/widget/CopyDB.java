package com.hcs.cityslist.widget;

import android.annotation.SuppressLint;
import android.content.Context;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * 复制本地数据库
 */
@SuppressLint("SdCardPath")
public class CopyDB {
    //    private String path = "/data/data/com.jizhi.jlongg/databases";
    public static final String jlongg = "baseinfo.db";
    public static final String huangli = "huangli.db";


    /**
     * 初始化数据库
     *
     * @author SHANHY
     */
    public void initDB(Context context, String dbName) {
        try {
            File dbdir = new File("/data/data/" + context.getPackageName() + "/databases");
            File dbfile = new File(dbdir, dbName);
            if (!dbdir.exists())
                dbdir.mkdirs();
            if (!dbfile.exists()) {
                copyDatabaseByAssets(dbfile, context, dbName);
            }
        } catch (Exception e) {

        }

    }

    /**
     * 复制数据库文件
     *
     * @author SHANHY
     */
    private void copyDatabaseByAssets(File file, Context context, String dbName) {
        try {
            file.mkdirs();
            if (file.exists())
                file.delete();
            file.createNewFile();
            InputStream from = context.getAssets().open(dbName);
            OutputStream to = new FileOutputStream(file);
            byte[] b = new byte[1024];
            int n = 0;
            while ((n = from.read(b)) > 0) {
                to.write(b, 0, n);
            }
            to.close();
            from.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
