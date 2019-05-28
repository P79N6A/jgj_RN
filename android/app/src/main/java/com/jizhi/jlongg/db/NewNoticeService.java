package com.jizhi.jlongg.db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.jizhi.jlongg.db.dao.NewNoticeDao;
import com.jizhi.jlongg.main.bean.NewMessage;

import java.util.List;

/**
 * 新通知
 *
 * @author Xuj
 * @version 1.0
 * @time 2016年9月8日 16:25:49
 */
public class NewNoticeService extends SQLiteOpenHelper implements NewNoticeDao {


    private static NewNoticeService mInstance = null;

    private static SQLiteDatabase db = null; //数据库操作对象

    private static final String AUTOID = "_id integer primary key autoincrement"; //自增长ID
    private static final String FIELDCLASSTYPE = "class_type"; //消息类型
    private static final String FIELDTITLE = "title"; //标题
    private static final String FIELDDATE = "date"; //消息接收时间
    private static final String FIELDGROUPNAME = "group_name"; //讨论组名称
    private static final String FIELDMEMBERSHEADPIC = "members_head_pic"; //头像
    private static final String FIELDUSERNAME = "user_name"; //执行人
    private static final String FIELDTEAMNAME = "team_name";//班组名称
    private static final String FIELDMERGEBEFOR = "merge_befor";//合并后的名称
    private static final String FIELDMERGEAFTER = "merge_after";//合并前的名称
    private static final String FIELDTAGUID = "target_uid";//同步人的id
    private static final String FIELDTELEPHONE = "telphone";//电话号码
    private static final String FIELDGROUPID = "group_id";//项目id
    private static final String FIELDTEAMID = "team_id";//讨论组id
    private static final String FIELDNOTICEID = "notice_id";//项目提醒Id
    private static final String FIELDUUID = "uid"; //用户id
    private static final String FIELDCANCLICK = "can_click"; //是否能点击
    private static final String FIELDMEMBERNUM = "members_num"; //成员个数
    private static final String FIELDBILLID = "bill_id";//记账人id
    private static final String FIELDPROID = "pro_id";//项目id
    private static final String FIELDSPLITBEFOR = "split_befor";//拆分前的名称
    private static final String FIELDSPLITAFTER = "split_after";//拆分后的名称
    private static final String FIELDMERGEID = "merge_last_msg_id";
    private static final String FIELD_SYNC_STATE = "sync_state"; //主要是同步的时候使用  0表示还未操作 1表示同步成功 2表示拒绝

    private static final String TABLENAME = "t_new_notice"; //表名称

    private static final String FIELDMEMBERSHEADPIC_BIG = "members_head_pic_big"; //头像大

    private static final String FIELD_EXPIRE_INFO = "expire_info"; //过期提示信息
    private static final String FIELD_IS_PAY = "is_pay"; //是否已支付过期提示


    private NewNoticeService(Context context) {
        super(context, DaoBaseConstance.MESSAGE_DATABASE_NAME, null, DaoBaseConstance.MESSAGE_DATABASE_VERSION);
    }

    public synchronized static NewNoticeService getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new NewNoticeService(context);
            db = mInstance.getWritableDatabase();
            createTable(db);
        }
        return mInstance;
    }


    //动态创建聊天信息表
    public static void createTable(SQLiteDatabase db) {
        StringBuilder createTable = new StringBuilder();
        createTable.append("CREATE TABLE IF NOT EXISTS " + TABLENAME);
        createTable.append("(" + AUTOID + "," + FIELDCLASSTYPE + " varchar(20)," + FIELDTITLE + " varchar(20)," + FIELDDATE
                + " varchar(20)," + FIELDGROUPNAME + " varchar(20)," + FIELDMEMBERSHEADPIC_BIG + " varchar(1500)," + FIELDMEMBERSHEADPIC + " varchar(200)," +
                FIELDUSERNAME + " varchar(10)," + FIELDTEAMNAME + " varchar(20)," + FIELDMERGEBEFOR + " varchar(20),"
                + FIELDMERGEAFTER + " varchar(20)," + FIELDTELEPHONE + " varchar(20)," + FIELDGROUPID + " varchar(20),"
                + FIELDTEAMID + " varchar(20)," + FIELDNOTICEID + " varchar(20)," + FIELDUUID + " varchar(20)," + FIELDCANCLICK + " varchar(2)," + FIELDTAGUID + " varchar(10),"
                + FIELDMEMBERNUM + " varchar(10)," + FIELDBILLID + " varchar(20)," + FIELDPROID + " varchar(20)," + FIELDSPLITBEFOR
                + " varchar(20)," + FIELDSPLITAFTER + " varchar(20)," + FIELDMERGEID + " varchar(20)," + FIELD_EXPIRE_INFO +
                " varchar(255)," + FIELD_IS_PAY + " integer," + FIELD_SYNC_STATE + " integer)");
        db.execSQL(createTable.toString());
    }


    @Override
    public List<NewMessage> getAllMessage(Context context) {
//        NewMessage notice = null;
//        List<NewMessage> list = null;
//        try {
//            StringBuffer sql = new StringBuffer();
//            sql.append("select * from " + TABLENAME + " where " + FIELDUUID + "= ?");
//            sql.append(" order by " + FIELDDATE + " desc");
//            Cursor cursor = db.rawQuery(sql.toString(), new String[]{UclientApplication.getUid(context)});
//            while (cursor.moveToNext()) {
//                if (list == null) {
//                    list = new ArrayList<>();
//                }
//                String headPics = null;
//                String oldHead = cursor.getString(cursor.getColumnIndex(FIELDMEMBERSHEADPIC)); //头像
//                if (!TextUtils.isEmpty(oldHead)) {
//                    headPics = oldHead;
//                } else {
//                    String newHead = cursor.getString(cursor.getColumnIndex(FIELDMEMBERSHEADPIC_BIG));
//                    headPics = newHead;
//                }
//                String classType = cursor.getString(cursor.getColumnIndex(FIELDCLASSTYPE));//消息类型
//                String title = cursor.getString(cursor.getColumnIndex(FIELDTITLE));  //标题
//                String date = cursor.getString(cursor.getColumnIndex(FIELDDATE));
//                date = !TextUtils.isEmpty(date) ? Utils.simpleForDate(Long.parseLong(date)) : "1970-01-01";
//                String groupName = cursor.getString(cursor.getColumnIndex(FIELDGROUPNAME));  //讨论组名称
//                String userName = cursor.getString(cursor.getColumnIndex(FIELDUSERNAME)); //执行人
//                String teamName = cursor.getString(cursor.getColumnIndex(FIELDTEAMNAME));//班组名称
//                String mergeBefor = cursor.getString(cursor.getColumnIndex(FIELDMERGEBEFOR)); //合并后的名称
//                String mergeAfter = cursor.getString(cursor.getColumnIndex(FIELDMERGEAFTER)); //合并前的名称
//                String telephone = cursor.getString(cursor.getColumnIndex(FIELDTELEPHONE)); //电话号码
//                String groupId = cursor.getString(cursor.getColumnIndex(FIELDGROUPID)); //项目id
//                String teamId = cursor.getString(cursor.getColumnIndex(FIELDTEAMID)); //讨论组id
//                String canClick = cursor.getString(cursor.getColumnIndex(FIELDCANCLICK)); //是否能点击
//                int noticeId = cursor.getInt(cursor.getColumnIndex(FIELDNOTICEID)); //消息id
//                String tagetUid = cursor.getString(cursor.getColumnIndex(FIELDTAGUID)); //被操作的对象
//                String billId = cursor.getString(cursor.getColumnIndex(FIELDBILLID)); //记账人id
//                String memberNum = cursor.getString(cursor.getColumnIndex(FIELDMEMBERNUM)); //讨论组人员个数
//                String proId = cursor.getString(cursor.getColumnIndex(FIELDPROID)); //项目id
//                String splitBefor = cursor.getString(cursor.getColumnIndex(FIELDSPLITBEFOR)); //拆分前的名称
//                String splitAfter = cursor.getString(cursor.getColumnIndex(FIELDSPLITAFTER)); //拆分后的名称
//                String mergeId = cursor.getString(cursor.getColumnIndex(FIELDMERGEID));
//                String info = cursor.getString(cursor.getColumnIndex(FIELD_EXPIRE_INFO));
//                int isPay = cursor.getInt(cursor.getColumnIndex(FIELD_IS_PAY));
//                int syncState = cursor.getInt(cursor.getColumnIndex(FIELD_SYNC_STATE));
//                List<String> headList = null;
//                if (!TextUtils.isEmpty(headPics)) {
//                    headList = new ArrayList<>();
//                    for (String head : headPics.split(";")) {
//                        headList.add(head);
//                    }
//                }
//                notice = new NewMessage(classType, title, date, groupName, headList, userName, teamName,
//                        mergeBefor, mergeAfter, telephone, groupId, teamId, noticeId, canClick, tagetUid,
//                        memberNum, billId, proId, splitBefor, splitAfter, mergeId, isPay, info, syncState);
//                list.add(notice);
//            }
//            closeCurse(cursor);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//
//    @Override
//    public void saveNoticeSingleData(NewMessage bean, String uid) {
//        if (isExistNoticeId(bean, uid)) {
//            return;
//        }
//        ContentValues cv = new ContentValues();
//        if (bean.getMembers_head_pic() != null && bean.getMembers_head_pic().size() > 0) {
//            StringBuilder headPic = new StringBuilder();
//            int i = 0;
//            for (String head : bean.getMembers_head_pic()) {  //将头像以;号形式隔开
//                if (i == 0) {
//                    headPic.append(head);
//                } else {
//                    headPic.append(";" + head);
//                }
//                i += 1;
//            }
//            cv.put(FIELDMEMBERSHEADPIC, headPic.toString());
//            cv.put(FIELDMEMBERSHEADPIC_BIG, headPic.toString());
//        }
//
//        cv.put(FIELDCLASSTYPE, bean.getClass_type());
//        cv.put(FIELDTITLE, bean.getTitle());
//        cv.put(FIELDDATE, bean.getDate());
//        cv.put(FIELDGROUPNAME, bean.getGroup_name());
//        cv.put(FIELDUSERNAME, bean.getUser_name());
////        cv.put(FIELDTEAMNAME, bean.getTeam_name());
//        cv.put(FIELDMERGEBEFOR, bean.getMerge_befor());
//        cv.put(FIELDMERGEAFTER, bean.getMerge_after());
//        cv.put(FIELDTELEPHONE, bean.getTelphone());
//        cv.put(FIELDGROUPID, bean.getGroup_id());
////        cv.put(FIELDTEAMID, bean.getTeam_id());
////        cv.put(FIELDNOTICEID, bean.getNotice_id());
//        cv.put(FIELDUUID, uid);
//        cv.put(FIELDCANCLICK, bean.getCan_click());
//        cv.put(FIELDTAGUID, bean.getTarget_uid());
//        cv.put(FIELDMEMBERNUM, bean.getMembers_num());
//        cv.put(FIELDBILLID, bean.getBill_id());
//        cv.put(FIELDPROID, bean.getPro_id());
//        cv.put(FIELDSPLITBEFOR, bean.getSplit_befor());
//        cv.put(FIELDSPLITAFTER, bean.getSplit_after());
//        cv.put(FIELDMERGEID, bean.getMerge_last_msg_id());
//        cv.put(FIELD_IS_PAY, bean.getIsPay());
//        cv.put(FIELD_EXPIRE_INFO, bean.getInfo());
//        db.insert(TABLENAME, null, cv);
//    }
//
//    @Override
//    public void updatePayState(String noticeId) {
//        StringBuffer sql = new StringBuffer();
//        sql.append("update " + TABLENAME);
//        sql.append(" set " + FIELD_IS_PAY + " = " + ProductUtil.PAID + " where ");
//        sql.append(FIELDNOTICEID + " = ? ");
//        db.execSQL(sql.toString(), new String[]{String.valueOf(noticeId)});
        return null;
    }


    @Override
    public void updateGroupName(NewMessage bean, String updateName) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FIELDTEAMNAME + " = ?   where ");
        sql.append(FIELDNOTICEID + "=?");
//        db.execSQL(sql.toString(), new String[]{updateName, bean.getNotice_id()});
    }

    @Override
    public void setSyncTag(String noticeId, int syncTag) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FIELD_SYNC_STATE + " = ?   where ");
        sql.append(FIELDNOTICEID + "=?");
        db.execSQL(sql.toString(), new String[]{syncTag + "", noticeId});
    }


    @Override
    public boolean isExistNoticeId(NewMessage bean, String uid) {
        boolean isExist = false;
        StringBuffer sql = new StringBuffer();
        sql.append("select * from " + TABLENAME);
        sql.append(" where " + FIELDNOTICEID + " = ?");
        sql.append(" and " + FIELDUUID + " = ?");
//        Cursor cursor = db.rawQuery(sql.toString(), new String[]{String.valueOf(bean.getNotice_id()), uid});
//        if (cursor.moveToNext()) {
//            isExist = true;
//        }
//        closeCurse(cursor);
        return isExist;
    }

    @Override
    public void updateGroupType(int noticeId, String classType) {
        StringBuffer sql = new StringBuffer();
        sql.append("update " + TABLENAME);
        sql.append(" set " + FIELDCLASSTYPE + " = ? where ");
        sql.append(FIELDNOTICEID + "=?");
        db.execSQL(sql.toString(), new String[]{classType, String.valueOf(noticeId)});
    }

    @Override
    public void remove(NewMessage bean) {
        StringBuffer sql = new StringBuffer();
        sql.append("delete from " + TABLENAME);
        sql.append(" where ");
        sql.append(FIELDNOTICEID + "=?");
//        db.execSQL(sql.toString(), new String[]{String.valueOf(bean.getNotice_id())});
    }

    @Override
    public void updatePayState(String noticeId) {

    }

    @Override
    public void saveNoticeMultiData(List<NewMessage> list, String uid) {
//        for (NewMessage bean : list) {
//            if (isExistNoticeId(bean, uid)) {
//                continue;
//            }
//            ContentValues cv = new ContentValues();
//            if (bean.getMembers_head_pic() != null && bean.getMembers_head_pic().size() > 0) {
//                StringBuilder headPic = new StringBuilder();
//                int i = 0;
//                for (String head : bean.getMembers_head_pic()) {  //将头像以;号形式隔开
//                    if (i == 0) {
//                        headPic.append(head);
//                    } else {
//                        headPic.append(";" + head);
//                    }
//                    i += 1;
//                }
//                cv.put(FIELDMEMBERSHEADPIC, headPic.toString());
//                cv.put(FIELDMEMBERSHEADPIC_BIG, headPic.toString());
//            }
//
//            cv.put(FIELDCLASSTYPE, bean.getClass_type());
//            cv.put(FIELDTITLE, bean.getTitle());
//            cv.put(FIELDDATE, bean.getDate());
//            cv.put(FIELDGROUPNAME, bean.getGroup_name());
//            cv.put(FIELDUSERNAME, bean.getUser_name());
////            cv.put(FIELDTEAMNAME, bean.getTeam_name());
//            cv.put(FIELDMERGEBEFOR, bean.getMerge_befor());
//            cv.put(FIELDMERGEAFTER, bean.getMerge_after());
//            cv.put(FIELDTELEPHONE, bean.getTelphone());
//            cv.put(FIELDGROUPID, bean.getGroup_id());
////            cv.put(FIELDTEAMID, bean.getTeam_id());
////            cv.put(FIELDNOTICEID, bean.getNotice_id());
//            cv.put(FIELDUUID, uid);
//            cv.put(FIELDCANCLICK, bean.getCan_click());
//            cv.put(FIELDTAGUID, bean.getTarget_uid());
//            cv.put(FIELDMEMBERNUM, bean.getMembers_num());
//            cv.put(FIELDBILLID, bean.getBill_id());
//            cv.put(FIELDPROID, bean.getPro_id());
//            cv.put(FIELDSPLITBEFOR, bean.getSplit_befor());
//            cv.put(FIELDSPLITAFTER, bean.getSplit_after());
//            cv.put(FIELDMERGEID, bean.getMerge_last_msg_id());
//            cv.put(FIELD_IS_PAY, bean.getIsPay());
//            cv.put(FIELD_EXPIRE_INFO, bean.getInfo());
//            db.insert(TABLENAME, null, cv);
//        }
    }

    @Override
    public void saveNoticeSingleData(NewMessage bean, String uid) {

    }


    @Override
    public void onCreate(SQLiteDatabase db) {
        //建表语句直接使用db.execSQL(String sql)方法执行SQL建表语句

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        if (DaoBaseConstance.MESSAGE_DATABASE_VERSION == 2) {
            db.execSQL("ALTER TABLE " + TABLENAME + " ADD COLUMN " + FIELDMEMBERSHEADPIC_BIG + " varchar(1500)");
        } else if (DaoBaseConstance.MESSAGE_DATABASE_VERSION == 3) {
            db.execSQL("ALTER TABLE " + TABLENAME + " ADD COLUMN " + FIELD_EXPIRE_INFO + " varchar(255)");
            db.execSQL("ALTER TABLE " + TABLENAME + " ADD COLUMN " + FIELD_IS_PAY + " integer");
        } else if (DaoBaseConstance.MESSAGE_DATABASE_VERSION == 4) {
            db.execSQL("ALTER TABLE " + TABLENAME + " ADD COLUMN " + FIELD_SYNC_STATE + " integer");
        }

//        sqlite3中对表字段的增删改查
//        android今天在做数据库升级时，碰到要对原来数据库中一张表的一个字段名进行修改，但是用：
//        alter table tablename rename column oldColumnName to newColumnName;
//        始终不成功，后面查阅相关信息：
//        SQLite supports a limited subset of ALTER TABLE. The ALTER TABLE command in SQLite allows the user to rename a table or to add a new column to an existing table. It is not possible to rename a column, remove a column, or add or remove constraints from a table.
//        sqlite支持一个更改表内容的有限子集，就是说在sqlite更改表的命令中，只允许用户重命名表名或者增加多一个列到一个的表中。而重命名一个字段名和删除一个字段、或者增加和删除系统规定的参数这些操作是不可能的。
//        后面只能先重命名原来的表，之后新建一张表，把原来的数据复制到新表中，最后删除掉旧的表就可以了。效率有点低，但是没办法。
//        String rename_sql = "ALTER TABLE " + TABLENAME + " RENAME TO temp";
//        String insert_sql = "INSERT INTO " + TABLENAME + " SELECT * FROM temp";
//        String drop_sql = "DROP TABLE temp";
//        db.execSQL(rename_sql);
//        createTable(db);
//        db.execSQL(insert_sql);
//        db.execSQL(drop_sql);
    }


    /**
     * 关闭数据库
     */
    public void closeDB() {
        if (mInstance != null) {
            try {
                if (null != db) {
                    db.close();
                    db = null;
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
