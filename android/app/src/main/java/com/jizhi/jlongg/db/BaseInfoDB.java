package com.jizhi.jlongg.db;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 基础信息db
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-25 下午4:42:45
 */
public class BaseInfoDB extends SQLiteOpenHelper {

    /**
     * 工作类型
     */
    public static final String jlg_work_type = "jlg_work_type";
    /**
     * 熟练度
     */
    public static final String jlg_work_level = "jlg_work_level";
    /**
     * 聊天信息
     */
    public static final String jlg_msg = "jlg_message";
    /**
     * 福利
     */
    public static final String jlg_work_status = "jlg_work_status";
    public static final String id = "id";
    public static final String name = "name";
    /**
     * 城市信息
     */
    public static final String jlg_city_data = "jlg_city_data";
    /**
     * 热门城市
     */
    public static final String jlg_hot_city = "jlg_hot_city";
    public static final String city_code = "city_code";
    public static final String city_name = "city_name";
    public static final String parent_id = "parent_id";
    private Context context;

    public BaseInfoDB(Context context) {
        super(context, DaoBaseConstance.DATABASE_NAME, null, DaoBaseConstance.DATABASE_VERSION);
        this.context = context;
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
//        String mobile = (String) SPUtils.get(context, Constance.TELEPHONE.toString(), "", Constance.JLONGG);
//        if (!mobile.equals("")) {
//            String sql = "CREATE TABLE IF NOT EXISTS  " + jlg_msg + "_" + mobile + "(" + "_id"
//                    + " integer primary key," + msg_id + " number," + msg_text
//                    + " TEXT," + date + " char(10)," + user_name + " char(15)," + head_pic + " varchar(50),"
//                    + group_id + " varchar(20)," + msg_type + " char(15)," + is_out_member + " char(10)," + msg_type_num +
//                    " char(5)," + local_id + " number," + msg_src + " TEXT," + msg_state + " integer," + voice_long + " char(2)," + unread_user_num + " char(4))";
//
//            db.execSQL(sql);
//        }


    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("delete from " + jlg_work_type + " where id=19");
        String mobile = (String) SPUtils.get(context, Constance.TELEPHONE.toString(), "", Constance.JLONGG);
        if (!mobile.equals("")) {
            LUtils.e("已经登陆了的:" + BaseInfoDB.jlg_msg + "_" + mobile);
        } else {
            LUtils.e("没有登陆:" + BaseInfoDB.jlg_msg);
        }
    }

    //聊天相关
    public static final String msg_id = "msg_id";
    public static final String msg_text = "msg_text";
    public static final String date = "date";
    public static final String user_name = "user_name";
    public static final String head_pic = "head_pic";
    public static final String group_id = "group_id";
    public static final String msg_type = "msg_type";
    public static final String msg_type_num = "msg_type_num";
    public static final String local_id = "local_id";
    public static final String msg_src = "msg_src";
    public static final String unread_user_num = "unread_user_num";
    public static final String accounts_type = "accounts_type";
    public static final String class_type = "class_type";
    public static final String uid = "uid";
    public static final String mobile_phone = "mobile_phone";
}
