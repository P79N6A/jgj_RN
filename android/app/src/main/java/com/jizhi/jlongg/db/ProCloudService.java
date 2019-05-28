package com.jizhi.jlongg.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.db.dao.ProCloudDao;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * 云盘数据库
 *
 * @author Xuj
 * @version 1.0
 * @time 2017年8月24日15:18:04
 */
public class ProCloudService extends SQLiteOpenHelper implements ProCloudDao {


    private static ProCloudService mInstance = null;

    private static SQLiteDatabase db = null; //数据库操作对象

    private static final String TABLENAME = "t_cloud"; //表名称

    private static final String AUTOID = "_id integer primary key autoincrement"; //自增长ID
    private static final String FILE_ID = "file_id"; //文件id
    private static final String FILE_NAME = "file_name"; //文件名称
    private static final String OSS_FILE_NAME = "oss_file_name"; //bucketKey
    private static final String BUCKET_NAME = "bucket_name"; //bucketName

    private static final String FILE_SIZE = "file_size"; //文件大小
    private static final String FILE_CREATE_DATE = "file_create_date"; //文件创建时间
    private static final String FILE_BROAD_TYPE = "file_broad_type"; //文件属于哪个类型  比如word有2007和2003他们的格式都不一样  需要统一返回然后本地设置 相同的icon
    private static final String FILE_TYPE = "file_type"; //文件类型
    private static final String FILE_DOWNLOADING_SIZE = "file_downloading_size"; //文件已下载大小
    private static final String FILE_TOTAL_SIZE = "file_total_size"; //文件总大小
    private static final String FILE_PATH = "file_path";//文件路径
    private static final String FILE_THUMBNAIL_FILE_PATH = "thumbnail_file_path";//文件缩略图路径
    private static final String UID = "uid";//用户id
    private static final String FILE_LOCAL_PATH = "file_local_path";//文件本地路径
    private static final String FILE_TYPE_STATE = "file_type_state";//文件状态  分为 下载和上传 1为上传  2为下载
    private static final String FILE_STATE = "file_state";//文件状态 记录文件 未上传、上传中、上传完毕、未下载、下载中、下载完毕、


    private static final String FILE_PARENT_ID = "parent_id"; //文件父id
    private static final String FILE_GROUP_ID = "group_id"; //文件项目组id

    private static final String FILE_UPLOAD_ID = "upload_id"; //文件断点续传所需要的id


    //动态创建聊天信息表
    public static void createTable(SQLiteDatabase db) {
        StringBuilder createTable = new StringBuilder();
        createTable.append("CREATE TABLE IF NOT EXISTS " + TABLENAME);
        createTable.append("(" + AUTOID + "," + FILE_ID + " integer," + FILE_PARENT_ID + " varchar(50)," + FILE_GROUP_ID + " varchar(50)," + FILE_NAME + " varchar(255)," + BUCKET_NAME + " varchar(255)," + OSS_FILE_NAME + " varchar(255)," + FILE_SIZE + " real,"
                + FILE_CREATE_DATE + " varchar(50)," + FILE_BROAD_TYPE + " varchar(10)," + FILE_TYPE + " varchar(10),"
                + FILE_DOWNLOADING_SIZE + " integer," + FILE_TOTAL_SIZE + " integer," + FILE_PATH + " varchar(255)," + FILE_THUMBNAIL_FILE_PATH + "  varchar(255),"
                + UID + " varchar(50)," + FILE_LOCAL_PATH + " varchar(255)," + FILE_TYPE_STATE + " integer," + FILE_STATE + " integer," + FILE_UPLOAD_ID + " varchar(32))");
        db.execSQL(createTable.toString());
    }


    private ProCloudService(Context context) {
        super(context, DaoBaseConstance.CLOUD_DATABASE_NAME, null, DaoBaseConstance.CLOUD);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        //建表语句直接使用db.execSQL(String sql)方法执行SQL建表语句
    }


    public synchronized static ProCloudService getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new ProCloudService(context);
            db = mInstance.getWritableDatabase();
            createTable(db);
        }
        return mInstance;
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }


    /**
     * 关闭数据库
     */
    public void closeDB() {
        if (mInstance != null) {
            clearLoadingState();
            try {
                if (null != db) {
                    db.close();
                    db = null;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            mInstance = null;
            LUtils.e("云盘数据库关闭");
        }
    }

    /**
     * 关闭游标
     *
     * @param cursor
     */
    public void closeCurse(Cursor cursor) {
        if (null != cursor) {
            cursor.close();
        }
    }

    @Override
    public void clearLoadingState() {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FILE_STATE + " = ? where " + FILE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{CloudUtil.FILE_NO_COMPLETE_STATE + "", CloudUtil.FILE_LOADING_STATE + ""});
    }

    @Override
    public int getFileUpLoadState(Context context, String fileLocalPath, String groupId) { //获取文件已上传的信息  如果返回-1表示文件不存在
        try {
            StringBuffer sql = new StringBuffer();
            sql.append("select * from " + TABLENAME + " where " + UID + "= ? ");
            sql.append("and " + FILE_LOCAL_PATH + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
            Cursor cursor = db.rawQuery(sql.toString(), new String[]{UclientApplication.getUid(context), fileLocalPath, groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""});
            while (cursor.moveToNext()) {
                return cursor.getInt(cursor.getColumnIndex(FILE_STATE));
            }
            closeCurse(cursor);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return CloudUtil.FILE_NO_EXIST;
    }

    @Override
    public int getFileDownLoadState(Context context, String mFileId, String groupId) {//获取文件已下载的信息  如果返回-1表示文件不存在
        try {
            StringBuffer sql = new StringBuffer();
            sql.append("select * from " + TABLENAME + " where " + UID + "= ? ");
            sql.append("and " + FILE_ID + " = ? and " + FILE_GROUP_ID + " =  ? and " + FILE_TYPE_STATE + " = ? ");
            Cursor cursor = db.rawQuery(sql.toString(), new String[]{UclientApplication.getUid(context), mFileId, groupId, CloudUtil.FILE_TYPE_DOWNLOAD_TAG + ""});
            while (cursor.moveToNext()) {
                return cursor.getInt(cursor.getColumnIndex(FILE_STATE));
            }
            closeCurse(cursor);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return CloudUtil.FILE_NO_EXIST;
    }

    @Override
    public Cloud getFileDownLoadInfo(Context context, String mFileId, String groupId) { //获取文件下载信息
        try {
            StringBuffer sql = new StringBuffer();
            sql.append("select * from " + TABLENAME + " where " + UID + " = ? ");
            sql.append("and " + FILE_ID + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
            Cursor cursor = db.rawQuery(sql.toString(), new String[]{UclientApplication.getUid(context), mFileId, groupId, CloudUtil.FILE_TYPE_DOWNLOAD_TAG + ""});
            while (cursor.moveToNext()) {
                String fileId = cursor.getString(cursor.getColumnIndex(FILE_ID));//文件id
                String fileParentId = cursor.getString(cursor.getColumnIndex(FILE_PARENT_ID));//文件父id
                String fileGroupId = cursor.getString(cursor.getColumnIndex(FILE_GROUP_ID));//文件项目组id
                String fileName = cursor.getString(cursor.getColumnIndex(FILE_NAME));//文件名称
                String ossFileName = cursor.getString(cursor.getColumnIndex(OSS_FILE_NAME));//bucketKey
                String bucketName = cursor.getString(cursor.getColumnIndex(BUCKET_NAME));  //空间名称
                String fileSize = cursor.getString(cursor.getColumnIndex(FILE_SIZE)); //文件大小
                String fileCreateDate = cursor.getString(cursor.getColumnIndex(FILE_CREATE_DATE));  //文件创建时间
                String fileType = cursor.getString(cursor.getColumnIndex(FILE_TYPE));//文件类型
                String fileBroadType = cursor.getString(cursor.getColumnIndex(FILE_BROAD_TYPE)); //文件属于哪个类型  比如word有2007和2003他们的格式都不一样  需要统一返回然后本地设置 相同的icon
                String filePath = cursor.getString(cursor.getColumnIndex(FILE_PATH)); //文件路径
                String fileThrunPath = cursor.getString(cursor.getColumnIndex(FILE_THUMBNAIL_FILE_PATH)); //文件缩略图路径
                String fileLocalPath = cursor.getString(cursor.getColumnIndex(FILE_LOCAL_PATH)); //文件本地保存路径
                String upLoadId = cursor.getString(cursor.getColumnIndex(FILE_UPLOAD_ID)); //文件上传的id
                int fileTypeState = cursor.getInt(cursor.getColumnIndex(FILE_TYPE_STATE)); //文件下载状态
                long fileDownLoadingSize = cursor.getLong(cursor.getColumnIndex(FILE_DOWNLOADING_SIZE)); //文件已下载大小
                long fileTotalSize = cursor.getLong(cursor.getColumnIndex(FILE_TOTAL_SIZE)); //文件总大小
                int fileState = cursor.getInt(cursor.getColumnIndex(FILE_STATE)); //获取文件状态
                Cloud cloud = new Cloud(fileId, fileName, bucketName, ossFileName, fileSize, fileCreateDate,
                        fileType, fileBroadType, fileDownLoadingSize, filePath, fileThrunPath, fileLocalPath,
                        fileTotalSize, fileTypeState, fileState, fileParentId, fileGroupId, CloudUtil.FILE_TAG, upLoadId);
                return cloud;
            }
            closeCurse(cursor);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Cloud getFileUpLoadInfo(Context context, String mFileLocalPath, String groupId) { //获取文件上传信息
        try {
            StringBuffer sql = new StringBuffer();
            sql.append("select * from " + TABLENAME + " where " + UID + "= ? ");
            sql.append("and " + FILE_LOCAL_PATH + " = ? and " + FILE_GROUP_ID + " = ?  and " + FILE_TYPE_STATE + " = ? ");
            Cursor cursor = db.rawQuery(sql.toString(), new String[]{UclientApplication.getUid(context), mFileLocalPath, groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""});
            while (cursor.moveToNext()) {
                String fileId = cursor.getString(cursor.getColumnIndex(FILE_ID));//文件id
                String fileParentId = cursor.getString(cursor.getColumnIndex(FILE_PARENT_ID));//文件父id
                String fileGroupId = cursor.getString(cursor.getColumnIndex(FILE_GROUP_ID));//文件项目组id
                String fileName = cursor.getString(cursor.getColumnIndex(FILE_NAME));//文件名称
                String ossFileName = cursor.getString(cursor.getColumnIndex(OSS_FILE_NAME));//bucketKey
                String bucketName = cursor.getString(cursor.getColumnIndex(BUCKET_NAME));  //空间名称
                String fileSize = cursor.getString(cursor.getColumnIndex(FILE_SIZE)); //文件大小
                String fileCreateDate = cursor.getString(cursor.getColumnIndex(FILE_CREATE_DATE));  //文件创建时间
                String fileType = cursor.getString(cursor.getColumnIndex(FILE_TYPE));//文件类型
                String fileBroadType = cursor.getString(cursor.getColumnIndex(FILE_BROAD_TYPE)); //文件属于哪个类型  比如word有2007和2003他们的格式都不一样  需要统一返回然后本地设置 相同的icon
                String filePath = cursor.getString(cursor.getColumnIndex(FILE_PATH)); //文件路径
                String fileThrunPath = cursor.getString(cursor.getColumnIndex(FILE_THUMBNAIL_FILE_PATH)); //文件缩略图路径
                String fileLocalPath = cursor.getString(cursor.getColumnIndex(FILE_LOCAL_PATH)); //文件本地保存路径
                String upLoadId = cursor.getString(cursor.getColumnIndex(FILE_UPLOAD_ID)); //文件上传的id

                int fileTypeState = cursor.getInt(cursor.getColumnIndex(FILE_TYPE_STATE)); //文件下载状态
                long fileDownLoadingSize = cursor.getLong(cursor.getColumnIndex(FILE_DOWNLOADING_SIZE)); //文件已下载大小
                long fileTotalSize = cursor.getLong(cursor.getColumnIndex(FILE_TOTAL_SIZE)); //文件总大小
                int fileState = cursor.getInt(cursor.getColumnIndex(FILE_STATE)); //获取文件状态
                Cloud cloud = new Cloud(fileId, fileName, bucketName, ossFileName, fileSize, fileCreateDate,
                        fileType, fileBroadType, fileDownLoadingSize, filePath, fileThrunPath, fileLocalPath,
                        fileTotalSize, fileTypeState, fileState, fileParentId, fileGroupId, CloudUtil.FILE_TAG, upLoadId);
                return cloud;
            }
            closeCurse(cursor);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Cloud> getUploadOrDownLoadFileList(Context context, int mFileState, String groupId) { //获取文件上传目录、下载目录
        List<Cloud> list = null;
        Cloud cloud = null;
        try {
            Cursor cursor = db.rawQuery("select * from " + TABLENAME + " where " + UID + " = ? and " + FILE_TYPE_STATE + " = ? and " + FILE_GROUP_ID + " = ? order by " + FILE_CREATE_DATE + " desc ",
                    new String[]{UclientApplication.getUid(context), mFileState + "", groupId});
            while (cursor.moveToNext()) {
                String fileLocalPath = cursor.getString(cursor.getColumnIndex(FILE_LOCAL_PATH));//文件名称
//                if (!TextUtils.isEmpty(fileLocalPath)) {
//                    File file = new File(fileLocalPath); //判断上传的文件是否存在
//                    if (!file.exists()) {
//                        continue;
//                    }
//                }
                if (list == null) {
                    list = new ArrayList<>();
                }
                String fileId = cursor.getString(cursor.getColumnIndex(FILE_ID));//文件id
                String fileParentId = cursor.getString(cursor.getColumnIndex(FILE_PARENT_ID));//文件父id
                String fileGroupId = cursor.getString(cursor.getColumnIndex(FILE_GROUP_ID));//文件项目组id
                String fileName = cursor.getString(cursor.getColumnIndex(FILE_NAME));//文件名称
                String ossFileName = cursor.getString(cursor.getColumnIndex(OSS_FILE_NAME));//bucketKey
                String bucketName = cursor.getString(cursor.getColumnIndex(BUCKET_NAME));  //空间名称
                String fileSize = cursor.getString(cursor.getColumnIndex(FILE_SIZE)); //文件大小
                String fileCreateDate = cursor.getString(cursor.getColumnIndex(FILE_CREATE_DATE));  //文件创建时间
                String fileType = cursor.getString(cursor.getColumnIndex(FILE_TYPE));//文件类型
                String fileBroadType = cursor.getString(cursor.getColumnIndex(FILE_BROAD_TYPE)); //文件属于哪个类型  比如word有2007和2003他们的格式都不一样  需要统一返回然后本地设置 相同的icon
                String filePath = cursor.getString(cursor.getColumnIndex(FILE_PATH)); //文件路径
                String fileThrunPath = cursor.getString(cursor.getColumnIndex(FILE_THUMBNAIL_FILE_PATH)); //文件缩略图路径
                String upLoadId = cursor.getString(cursor.getColumnIndex(FILE_UPLOAD_ID)); //文件上传的id
                int fileTypeState = cursor.getInt(cursor.getColumnIndex(FILE_TYPE_STATE)); //文件下载状态
                long fileDownLoadingSize = cursor.getLong(cursor.getColumnIndex(FILE_DOWNLOADING_SIZE)); //文件已下载大小
                long fileTotalSize = cursor.getLong(cursor.getColumnIndex(FILE_TOTAL_SIZE)); //文件总大小
//                int fileState = cursor.getInt(cursor.getColumnIndex(FILE_STATE)); //获取文件状态
                cloud = new Cloud(fileId, fileName, bucketName, ossFileName, fileSize, fileCreateDate, fileType, fileBroadType,
                        fileDownLoadingSize, filePath, fileThrunPath, fileLocalPath, fileTotalSize, fileTypeState, fileTotalSize == fileDownLoadingSize
                        ? CloudUtil.FILE_COMPLETED_STATE : CloudUtil.FILE_NO_COMPLETE_STATE, fileParentId, fileGroupId, CloudUtil.FILE_TAG, upLoadId);
                list.add(cloud);
            }
            closeCurse(cursor);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateFileDownLoadProgress(Context context, Cloud cloud, String groupId) {
        LUtils.e("下载进度:" + cloud.getFile_downloading_size() + "     总进度:" + cloud.getFileTotalSize());
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FILE_DOWNLOADING_SIZE + " = ? where ");
        sql.append(UID + "= ? and " + FILE_ID + "= ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{cloud.getFile_downloading_size() + "", UclientApplication.getUid(context), cloud.getId(), groupId, CloudUtil.FILE_TYPE_DOWNLOAD_TAG + ""});
    }

    @Override
    public void updateFileUpLoadProgress(Context context, Cloud cloud, String groupId) {
        LUtils.e("上传进度:" + cloud.getFile_downloading_size() + "     总进度:" + cloud.getFileTotalSize());
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FILE_DOWNLOADING_SIZE + " = ? where ");
        sql.append(UID + "= ? and " + FILE_LOCAL_PATH + "= ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{cloud.getFile_downloading_size() + "", UclientApplication.getUid(context), cloud.getFileLocalPath(), groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""});
    }

    @Override
    public void setUpLoadId(Context context, Cloud cloud, String groupId) {
        LUtils.e("upLoadId:" + cloud.getUpLoadId());
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FILE_UPLOAD_ID + " = ? where ");
        sql.append(UID + "= ? and " + FILE_LOCAL_PATH + "= ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{cloud.getUpLoadId(), UclientApplication.getUid(context), cloud.getFileLocalPath(),
                groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""});
    }

    @Override
    public void updateFileDownloadFileState(Context context, Cloud cloud, String groupId) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FILE_STATE + " = " + cloud.getFileState() + "," + FILE_LOCAL_PATH + " = ? where ");
        sql.append(UID + "= ? and " + FILE_ID + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{cloud.getFileLocalPath(), UclientApplication.getUid(context), cloud.getId(), groupId, CloudUtil.FILE_TYPE_DOWNLOAD_TAG + ""});
    }

    @Override
    public void updateFileUpLoadFileState(Context context, Cloud cloud, String groupId) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FILE_STATE + " = " + cloud.getFileState() + " where ");
        sql.append(UID + "= ? and " + FILE_LOCAL_PATH + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{UclientApplication.getUid(context), cloud.getFileLocalPath(), groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""});
    }


    @Override
    public void saveFileDownLoadInfo(Context context, Cloud cloud) {
        if (isExistFileFromFileId(context, cloud.getId(), cloud.getGroup_id(), CloudUtil.FILE_TYPE_DOWNLOAD_TAG + "")) {
            return;
        }
        ContentValues cv = new ContentValues();
        cv.put(FILE_ID, cloud.getId()); //文件名称
        cv.put(FILE_NAME, cloud.getFile_name()); //文件名称
        cv.put(BUCKET_NAME, cloud.getBucket_name());
        cv.put(OSS_FILE_NAME, cloud.getOss_file_name());
        cv.put(FILE_SIZE, cloud.getFile_size());
        cv.put(FILE_CREATE_DATE, cloud.getDate());
        cv.put(FILE_BROAD_TYPE, cloud.getFile_broad_type());
        cv.put(FILE_TYPE, cloud.getFile_type());
        cv.put(FILE_PATH, cloud.getFile_path());
        cv.put(FILE_THUMBNAIL_FILE_PATH, cloud.getThumbnail_file_path());
        cv.put(FILE_LOCAL_PATH, cloud.getFileLocalPath());
        cv.put(FILE_DOWNLOADING_SIZE, cloud.getFile_downloading_size()); //文件已下载的大小
        cv.put(FILE_TOTAL_SIZE, cloud.getFileTotalSize()); //文件总大小
        cv.put(UID, UclientApplication.getUid(context));
        cv.put(FILE_TYPE_STATE, CloudUtil.FILE_TYPE_DOWNLOAD_TAG); //设置文件下载标识
        cv.put(FILE_STATE, cloud.getFileState());
        cv.put(FILE_GROUP_ID, cloud.getGroup_id()); //文件项目组id
        db.insert(TABLENAME, null, cv);
    }

    @Override
    public void saveFileUpLoadInfo(Context context, Cloud cloud, String groupId) {
        if (isExistFileFromLocalPath(context, cloud.getFileLocalPath(), groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + "")) { //如果有本地文件相同的路径则不保存数据库
            return;
        }
        ContentValues cv = new ContentValues();
        cv.put(FILE_ID, cloud.getId());
        cv.put(FILE_PATH, cloud.getFile_path());
        cv.put(FILE_THUMBNAIL_FILE_PATH, cloud.getFile_path());
        cv.put(FILE_NAME, cloud.getFile_name()); //文件名称
        cv.put(FILE_PARENT_ID, cloud.getParent_id()); //文件父类id
        cv.put(BUCKET_NAME, cloud.getBucket_name()); //空间名称
        cv.put(OSS_FILE_NAME, cloud.getOss_file_name()); //bucketKey
        cv.put(FILE_CREATE_DATE, cloud.getDate()); //文件时间
        cv.put(FILE_BROAD_TYPE, cloud.getFile_broad_type()); //文件大类型
        cv.put(FILE_TYPE, cloud.getFile_type()); //文件类型
        cv.put(FILE_LOCAL_PATH, cloud.getFileLocalPath()); //文件路径
        cv.put(FILE_DOWNLOADING_SIZE, cloud.getFile_downloading_size()); //文件已上传大小
        cv.put(FILE_TOTAL_SIZE, cloud.getFileTotalSize()); //文件总大小
        cv.put(UID, UclientApplication.getUid(context));
        cv.put(FILE_TYPE_STATE, CloudUtil.FILE_TYPE_UPLOAD_TAG); //文件状态
        cv.put(FILE_STATE, cloud.getFileState());
        cv.put(FILE_GROUP_ID, groupId); //文件项目组id
        cv.put(FILE_UPLOAD_ID, cloud.getUpLoadId());
        db.insert(TABLENAME, null, cv);
    }

    @Override
    public void deleteFileInfo(Context context, String fileId, String groupId, String fileTypeState) {
        StringBuffer sql = new StringBuffer();
        sql.append("delete from " + TABLENAME + " where ");
        sql.append(FILE_ID + "= ? and " + UID + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        db.execSQL(sql.toString(), new String[]{fileId, UclientApplication.getUid(context), groupId, fileTypeState});
    }

    /**
     * 根据文件id 判断文件是否存在
     *
     * @param fileId
     * @return
     */
    public boolean isExistFileFromFileId(Context context, String fileId, String groupId, String fileTypeState) {
        boolean isExist = false;
        StringBuffer sql = new StringBuffer();
        sql.append("select * from " + TABLENAME);
        sql.append(" where " + FILE_ID + " = ? and " + UID + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        Cursor cursor = db.rawQuery(sql.toString(), new String[]{fileId, UclientApplication.getUid(context), groupId, fileTypeState});
        if (cursor.moveToNext()) {
            isExist = true;
        }
        closeCurse(cursor);
        return isExist;
    }

    /**
     * 根据文件id 判断文件是否存在
     *
     * @param fileLocalPath 本地文件路径
     * @return
     */
    public boolean isExistFileFromLocalPath(Context context, String fileLocalPath, String groupId, String fileTypeState) {
        boolean isExist = false;
        StringBuffer sql = new StringBuffer();
        sql.append("select * from " + TABLENAME);
        sql.append(" where " + FILE_LOCAL_PATH + " = ? and " + UID + " = ? and " + FILE_GROUP_ID + " = ? and " + FILE_TYPE_STATE + " = ? ");
        Cursor cursor = db.rawQuery(sql.toString(), new String[]{fileLocalPath, UclientApplication.getUid(context), groupId, fileTypeState});
        if (cursor.moveToNext()) {
            isExist = true;
        }
        closeCurse(cursor);
        return isExist;
    }

}
