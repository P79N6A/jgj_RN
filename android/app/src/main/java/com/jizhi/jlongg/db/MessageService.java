package com.jizhi.jlongg.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.jizhi.jlongg.db.dao.WorkCircleMessageDao;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * 消息缓存
 *
 * @author Xuj
 * @version 1.0
 * @time 2016年8月31日 10:45:05
 */
public class MessageService extends SQLiteOpenHelper implements WorkCircleMessageDao {

    private static final int DATABASE_VERSION = 1; //数据库版本

    private static MessageService mInstance = null;

    private static final String DATABASENAME = "baseinfo.db"; //数据库名

    private static SQLiteDatabase db = null; //数据库操作对象
    private static final String AUTOID = "_id integer primary key autoincrement";
    private static final String FIELDPRONAME = "pro_name"; //项目名称
    private static final String FIELDPROID = "pro_id"; //项目ID
    private static final String FIELDGROUPNAME = "group_name"; //讨论组、班组名称
    private static final String FIELDGROUPID = "group_id"; //讨论组ID
    private static final String FIELDGROUPTYPE = "group_type"; //组类型 group 班组 team讨论组
    private static final String FIELDMEMBERSHEADPIC = "members_head_pic";//讨论组头像
    private static final String FIELDUNREADMSGCOUNT = "unread_msg_count";//未读消息数
    private static final String FIELDUUID = "uid"; //用户id
    private static final String TABLENAME = "t_message"; //表名称

    private MessageService(Context context) {
        super(context, DATABASENAME, null, DATABASE_VERSION);
    }

    public synchronized static MessageService getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new MessageService(context);
            db = mInstance.getWritableDatabase();
        }
        return mInstance;
    }


    @Override
    public List<GroupDiscussionInfo> getWorkCircleCasheData() {
        GroupDiscussionInfo group = null;
        List<GroupDiscussionInfo> list = null;
        StringBuffer sql = new StringBuffer();
        sql.append("select * from " + TABLENAME);
        Cursor cursor = db.rawQuery(sql.toString(), new String[]{});
        while (cursor.moveToNext()) {
            if (list == null) {
                list = new ArrayList<GroupDiscussionInfo>();
            }
            String proName = cursor.getString(cursor.getColumnIndex(FIELDPRONAME)); //项目名称
            String groupName = cursor.getString(cursor.getColumnIndex(FIELDGROUPNAME)); //讨论组、班组名称
            String groupType = cursor.getString(cursor.getColumnIndex(FIELDGROUPTYPE)); //讨论组还是班组 group 班组 team讨论组
            String headPics = cursor.getString(cursor.getColumnIndex(FIELDMEMBERSHEADPIC)); //头像
            int unreadMsgCount = cursor.getInt(cursor.getColumnIndex(FIELDUNREADMSGCOUNT)); //未读消息数
            int proId = cursor.getInt(cursor.getColumnIndex(FIELDPROID)); //项目id
            int groupId = cursor.getInt(cursor.getColumnIndex(FIELDGROUPID)); //讨论组、班组id
            List<String> headList = new ArrayList<>();
            for (String head : headPics.split(";")) {
                headList.add(head);
            }
//            group = new GroupDiscussionInfo(groupId, groupName, proId, proName, unreadMsgCount, groupType, headList);
            list.add(group);
        }
        closeCurse(cursor);
        return list;
    }

    @Override
    public void saveWorkCircleSingleData(GroupDiscussionInfo bean) {
        StringBuilder headPic = new StringBuilder();
        int i = 0;
        for (String head : bean.getMembers_head_pic()) {  //将头像以;号形式隔开
            if (i != 0) {
                headPic.append(head + ";");
            }
            i += 1;
        }
        ContentValues cv = new ContentValues();
        cv.put(FIELDPRONAME, bean.getPro_name());
        cv.put(FIELDGROUPNAME, bean.getGroup_name());
        cv.put(FIELDGROUPTYPE, bean.getClass_type());
        cv.put(FIELDMEMBERSHEADPIC, headPic.toString());
        cv.put(FIELDUNREADMSGCOUNT, bean.getUnread_msg_count());
        cv.put(FIELDPROID, bean.getPro_id());
        cv.put(FIELDGROUPID, bean.getGroup_id());
        db.insert(TABLENAME, null, cv);


    }

    @Override
    public void saveWorkCircleMultiData(List<GroupDiscussionInfo> list) {
        for (GroupDiscussionInfo bean : list) {
            StringBuilder headPic = new StringBuilder();
            int i = 0;
            for (String head : bean.getMembers_head_pic()) {  //将头像以;号形式隔开
                if (i != 0) {
                    headPic.append(head + ";");
                }
                i += 1;
            }
            ContentValues cv = new ContentValues();
            cv.put(FIELDPRONAME, bean.getPro_name());
            cv.put(FIELDGROUPNAME, bean.getGroup_name());
            cv.put(FIELDGROUPTYPE, bean.getClass_type());
            cv.put(FIELDMEMBERSHEADPIC, headPic.toString());
            cv.put(FIELDUNREADMSGCOUNT, bean.getUnread_msg_count());
            cv.put(FIELDPROID, bean.getPro_id());
            cv.put(FIELDGROUPID, bean.getGroup_id());
            db.insert(TABLENAME, null, cv);
        }
    }


    @Override
    public void getAlreadClosedCasheData() {

    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        //建表语句直接使用db.execSQL(String sql)方法执行SQL建表语句
        StringBuilder createTable = new StringBuilder();
        createTable.append("create table " + TABLENAME);
        createTable.append("(" + AUTOID + "," + FIELDPRONAME + " varchar(20)," + FIELDPROID + " varchar(20)," + FIELDGROUPNAME
                + " varchar(20)," + FIELDGROUPID + " varchar(20)," + FIELDGROUPTYPE + " varchar(10)," +
                FIELDMEMBERSHEADPIC + " varchar(200)," + FIELDUNREADMSGCOUNT + " interger,FIELDUUID varchar(20)");
        db.execSQL(createTable.toString());
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }


    /**
     * 关闭数据库
     */
    public void closeDB() {
        if (mInstance != null) {
            try {
                if (null != db) {
                    db.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            mInstance = null;
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


}
