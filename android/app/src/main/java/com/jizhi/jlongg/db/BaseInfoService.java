package com.jizhi.jlongg.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.jizhi.jlongg.db.dao.BaseInfoDao;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.ArrayList;
import java.util.List;

/**
 * 基础信息增删改实现类
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-25 下午4:50:00
 */
public class BaseInfoService implements BaseInfoDao {
    private static BaseInfoDB baseInfoDB = null;
    private static SQLiteDatabase db = null;
    private static BaseInfoService mInstance = null;
    private static String mobile;

    public BaseInfoService(Context context) {

    }

    public synchronized static BaseInfoService getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new BaseInfoService(context);
            baseInfoDB = new BaseInfoDB(context);
            db = baseInfoDB.getWritableDatabase();
        }
//        createMessageTable(context);
        return mInstance;

    }

//    //动态创建聊天信息表
//    public static void createMessageTable(Context context) {
//        mobile = SPUtils.get(context, Constance.TELEPHONE.toString(), "", Constance.JLONGG) + "_";
//        if (!mobile.equals("") && !mobile.equals("_")) {
//            String sql = "CREATE TABLE IF NOT EXISTS  " + BaseInfoDB.jlg_msg + "_" + mobile + "(" + "_id"
//                    + " integer primary key AUTOINCREMENT ," + BaseInfoDB.msg_id + " number," + BaseInfoDB.msg_text + " TEXT," + BaseInfoDB.is_readed + " char(2)," + BaseInfoDB.accounts_type + " char(2),"
//                    + BaseInfoDB.date + " char(10)," + BaseInfoDB.user_name + " char(15)," + BaseInfoDB.head_pic + " varchar(50)," + BaseInfoDB.bill_id + " varchar(10),"
//                    + BaseInfoDB.group_id + " varchar(20)," + BaseInfoDB.msg_type + " char(15)," + BaseInfoDB.is_out_member + " char(10)," + BaseInfoDB.msg_type_num +
//                    " char(5)," + BaseInfoDB.local_id + " number," + BaseInfoDB.msg_src + " TEXT," + BaseInfoDB.msg_state + " integer," + BaseInfoDB.voice_long + " char(2)," + BaseInfoDB.class_type + " char(10)," + BaseInfoDB.unread_user_num + " char(4))";
//            db.execSQL(sql);
//        }
//}

    /**
     * 增加基础信息
     */
    @Override
    public void insertBaseInfo(WorkType type, String tableName) {
        ContentValues cv = new ContentValues();
        cv.put(BaseInfoDB.id, type.getWorktype());
        cv.put(BaseInfoDB.name, type.getWorkName());
        db.insert(tableName, null, cv);
    }

    @Override
    public boolean isInsertInfo(String name, String tableName) {
        Cursor cursor = db.query(tableName, null, BaseInfoDB.name + "=?",
                new String[]{String.valueOf(name)}, null, null, null);

        if (null != cursor && cursor.getCount() != 0) {
            // 已经添加过
            closeCurse(cursor);
            return true;
        } else {
            // 没有添加过
            closeCurse(cursor);
            return false;
        }
    }

    @Override
    public boolean isInsertCity(String name, String tableName) {
        Cursor cursor = db.query(tableName, null, BaseInfoDB.city_name + "=?", new String[]{String.valueOf(name)}, null, null, null);
        if (null != cursor && cursor.getCount() != 0) {
            // 已经添加过
            closeCurse(cursor);
            return true;
        } else {
            // 没有添加过
            closeCurse(cursor);
            return false;
        }
    }

    @Override
    public List<WorkType> selectInfo(String tableName) {
        List<WorkType> workTypes = new ArrayList<>();
        Cursor cursor = db.query(tableName, null, null, null, null, null, null);
        while (cursor.moveToNext()) {
            String id = cursor.getString(cursor.getColumnIndex(BaseInfoDB.id));
            String name = cursor.getString(cursor.getColumnIndex(BaseInfoDB.name));
            if (name.equals("已开工也找新工作")) {
                name = "已开工也在找新工作";
            }
            WorkType type = new WorkType(id, name);
            type.setIsSelected(false);
            workTypes.add(type);
        }
        closeCurse(cursor);
        return workTypes;
    }


    @Override
    public List<WorkType> selectInfoForMain(String tableName) {
        List<WorkType> workTypes = new ArrayList<WorkType>();
        Cursor cursor = db.query(tableName, null, null, null, null, null, null);
        int i = 0;
        while (cursor.moveToNext()) {
            if (i == 11) {
                break;
            }
            String id = cursor.getString(cursor.getColumnIndex(BaseInfoDB.id));
            String name = cursor.getString(cursor.getColumnIndex(BaseInfoDB.name));
            WorkType type = new WorkType(id, name);
            type.setIsSelected(false);
            workTypes.add(type);
            i += 1;
        }
        workTypes.add(new WorkType("更多.."));
        closeCurse(cursor);
        return workTypes;
    }


    @Override
    public List<CityInfoMode> selectCites(String tableName) {
        List<CityInfoMode> cityInfoModes = new ArrayList<CityInfoMode>();
        Cursor cursor = db.query(tableName, null, null, null, null, null, null);
        while (cursor.moveToNext()) {
            String name = cursor.getString(cursor.getColumnIndex(BaseInfoDB.city_name));
            String code = cursor.getString(cursor.getColumnIndex(BaseInfoDB.city_code));
            CityInfoMode type = new CityInfoMode(name, code);
            cityInfoModes.add(type);
        }
        closeCurse(cursor);
        return cityInfoModes;
    }

    @Override
    public String selectInfoName(String tableName, int id) {
        String names = "";
        String sql = "select name from " + tableName + " where id=" + id + "";
        Cursor cursor = db.rawQuery(sql, null);
        while (cursor.moveToNext()) {
            names = cursor.getString(cursor.getColumnIndex(BaseInfoDB.name));
        }
        closeCurse(cursor);
        return names;
    }

    @Override
    public String selectCityCode(String tableName, String city_name) {
        String city_code = "";
        // LIKE '成都市%'
        String sql = "select " + BaseInfoDB.city_code + " from " + tableName
                + " where " + BaseInfoDB.city_name + " like " + "\'"
                + city_name + "%\'";
        Cursor cursor = db.rawQuery(sql, null);
        while (cursor.moveToNext()) {
            city_code = cursor.getString(cursor.getColumnIndex(BaseInfoDB.city_code));
        }
        closeCurse(cursor);
        return city_code;
    }

    @Override
    public ArrayList<CityInfoMode> SelectCity(String patent_id) {
        ArrayList<CityInfoMode> modes = new ArrayList<>();
        String sql = "select * from " + BaseInfoDB.jlg_city_data + " where parent_id=?";
        Cursor cursor = db.rawQuery(sql, new String[]{patent_id});
        while (cursor.moveToNext()) {
            String city_code = cursor.getString(cursor.getColumnIndex(BaseInfoDB.city_code));
            String city_name = cursor.getString(cursor.getColumnIndex(BaseInfoDB.city_name));
            String parent_id = cursor.getString(cursor.getColumnIndex(BaseInfoDB.parent_id));
            CityInfoMode mode = new CityInfoMode(city_code, city_name, parent_id);
            modes.add(mode);
        }
        closeCurse(cursor);
        return modes;
    }

    @Override
    public CityInfoMode selectCityName(String cityCode) {
        CityInfoMode cityInfoMode = new CityInfoMode();
        String sql = "select c.city_name,b.city_name,a.city_name,a.city_code"
                + " from " + BaseInfoDB.jlg_city_data + " as a"
                + " inner join jlg_city_data as b on a.parent_id = b.city_code"
                + " inner join jlg_city_data as c on b.parent_id = c.city_code"
                + " where a.city_code=" + cityCode + ";";
        Cursor cursor = db.rawQuery(sql, null);
        StringBuffer buffer = new StringBuffer();
        while (cursor.moveToNext()) {
            String a = cursor.getString(0);
            String b = cursor.getString(1);
            String c = cursor.getString(2);
            int d = cursor.getInt(3);
            buffer.append(a + " " + b + " " + c);
            cityInfoMode.setCity_name(buffer.toString());
            cityInfoMode.setCity_code(d + "");

        }
        closeCurse(cursor);
        return cityInfoMode;
    }

    @Override
    public CityInfoMode insertCityInfo(CityInfoMode cityInfoMode, String tableName) {
        ContentValues cv = new ContentValues();
        cv.put(BaseInfoDB.city_name, cityInfoMode.getCity_name());
        cv.put(BaseInfoDB.city_code, cityInfoMode.getCity_code());
        db.insert(tableName, null, cv);
        return null;
    }

    public void closeCurse(Cursor cursor) {
        if (null != cursor) {
            cursor.close();
        }

    }

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

    @Override
    public String selectWorklevel(int ids) {
        String names = "";
        String sql = "select name from " + BaseInfoDB.jlg_work_level
                + " where id=" + ids + "";
        Cursor cursor = db.rawQuery(sql, null);
        while (cursor.moveToNext()) {
            names = cursor.getString(cursor.getColumnIndex(BaseInfoDB.name));
        }
        closeCurse(cursor);
        return names;
    }


    @Override
    public List<CityInfoMode> selectAllCity() {
        ArrayList<CityInfoMode> modes = new ArrayList<CityInfoMode>();
        String sql = "SELECT "
                + BaseInfoDB.city_name
                + " , "
                + BaseInfoDB.city_code
                + " FROM "
                + BaseInfoDB.jlg_city_data
                + " where substr(city_code,5,2)=\'00\' and substr(city_code,3,4)!=\'0000\'";
        Cursor cursor = db.rawQuery(sql, null);
        while (cursor.moveToNext()) {
            CityInfoMode cityInfoMode = new CityInfoMode();
            String city_name = cursor.getString(cursor
                    .getColumnIndex(BaseInfoDB.city_name));
            String city_code = cursor.getString(cursor
                    .getColumnIndex(BaseInfoDB.city_code));
            cityInfoMode.setCity_name(city_name);
            cityInfoMode.setCity_code(city_code);
            modes.add(cityInfoMode);
        }
        closeCurse(cursor);
        return modes;
    }

    //
    @Override
    public void clearTable(String tableName) {
        db.execSQL("delete from " + tableName);
        db.execSQL("update sqlite_sequence set seq=0 where name=\' " + tableName + "\'");
    }

    @Override
    public void insertWorkType(int id, String name, String tableName) {
        db.execSQL("insert into " + tableName + "(id,name) values(" + id + ",\' " + name + "\')");
    }

    @Override
    public CityInfoMode selectProvince(String city_codes) {

        CityInfoMode mode = null;
        String sql = "select * from " + BaseInfoDB.jlg_city_data
                + " where city_code=?";
        Cursor cursor = db.rawQuery(sql, new String[]{city_codes});
        while (cursor.moveToNext()) {
            String city_code = cursor.getString(cursor
                    .getColumnIndex(BaseInfoDB.city_code));
            String city_name = cursor.getString(cursor
                    .getColumnIndex(BaseInfoDB.city_name));
            String parent_id = cursor.getString(cursor
                    .getColumnIndex(BaseInfoDB.parent_id));
            mode = new CityInfoMode(city_code, city_name,
                    parent_id);
        }
        closeCurse(cursor);
        return mode;

    }

//    /**
//     * 增加多条消息
//     *
//     * @param tableName
//     * @param msgList
//     */
//    @Override
//    public void insertMessageAll(String tableName, List<ChatMsgEntity> msgList) {
//        tableName = tableName + "_" + mobile;
//        if (null == msgList || msgList.size() == 0) {
//            return;
//        }
//        db.beginTransaction();
//        for (int i = 0; i < msgList.size(); i++) {
//            String msg_src = "";
//            if (null != msgList.get(i).getMsg_src()) {
//                msg_src = new Gson().toJson(msgList.get(i).getMsg_src());
//            }
//            String Unread_user_num = "";
//            if (null != msgList.get(i).getRead_info()) {
//                Unread_user_num = msgList.get(i).getRead_info().getUnread_user_num();
//            }
//            String Voice_long = "0";
//            if (null != msgList.get(i).getVoice_long()) {
//                Voice_long = msgList.get(i).getVoice_long();
//            }
//            String sql = "replace into " + tableName + "(" + BaseInfoDB.msg_id + "," + BaseInfoDB.msg_text + "," + BaseInfoDB.is_readed + "," + BaseInfoDB.accounts_type
//                    + "," + BaseInfoDB.date + "," + BaseInfoDB.user_name + "," + BaseInfoDB.head_pic + "," + BaseInfoDB.bill_id
//                    + "," + BaseInfoDB.group_id + "," + BaseInfoDB.msg_type + ","
//                    + BaseInfoDB.is_out_member + "," + BaseInfoDB.msg_type_num + "," + BaseInfoDB.local_id
//                    + "," + BaseInfoDB.msg_state + "," + BaseInfoDB.voice_long + "," + BaseInfoDB.unread_user_num + "," + BaseInfoDB.msg_src + "," + BaseInfoDB.class_type
//                    + ") values(\'" + msgList.get(i).getMsg_id() + "\',\'" + msgList.get(i).getMsg_text() + "\',\'" + msgList.get(i).getIs_readed() + "\',\'" + (null == msgList.get(i).getAccounts_type() ? "1" : msgList.get(i).getAccounts_type()) + "\',\'"
//                    + msgList.get(i).getDate() + "\',\'" + msgList.get(i).getUser_name() + "\',\'" + msgList.get(i).getHead_pic() + "\',\'" + (null == msgList.get(i).getBill_id() ? "0" : msgList.get(i).getBill_id()) + "\',\'"
//                    + msgList.get(i).getGroup_id() + "\',\'" + msgList.get(i).getMsg_type() + "\',\'"
//                    + msgList.get(i).getIs_out_member() + "\',\'" + msgList.get(i).getMsg_type_num() + "\',\'" + msgList.get(i).getLocal_id() + "\',\'"
//                    + msgList.get(i).getMsg_state() + "\',\'" + Voice_long + "\',\'" + Unread_user_num + "\',\'" + msg_src + "\',\'" + msgList.get(i).getClass_type() + "\')";
//            db.execSQL(sql);
//        }
//        db.setTransactionSuccessful();
//        db.endTransaction();
//    }
//
//    /**
//     * 增加单条消息
//     *
//     * @param tableName
//     */
//    @Override
//    public void insertMessage(String tableName, ChatMsgEntity msg) {
//        tableName = tableName + "_" + mobile;
//        if (null == msg) {
//            return;
//        }
//        String msg_src = "";
//        if (null != msg.getMsg_src()) {
//            msg_src = new Gson().toJson(msg.getMsg_src());
//        }
//        String Unread_user_num = "";
//        if (null != msg.getRead_info()) {
//            Unread_user_num = msg.getRead_info().getUnread_user_num();
//        }
//        String Voice_long = "0";
//        if (null != msg.getVoice_long() && !msg.getVoice_long().equals("")) {
//            Voice_long = msg.getVoice_long();
//        }
//        if (null != msg.getLocal_id() && !msg.getLocal_id().equals("server")) {
//            db.execSQL("delete from " + tableName + " where " + BaseInfoDB.local_id + "=" + msg.getLocal_id());
//        }
//        String sql = "replace into " + tableName + "(" + BaseInfoDB.msg_id + "," + BaseInfoDB.msg_text + "," + BaseInfoDB.is_readed + "," + BaseInfoDB.accounts_type
//                + "," + BaseInfoDB.date + "," + BaseInfoDB.user_name + "," + BaseInfoDB.head_pic + "," + BaseInfoDB.bill_id
//                + "," + BaseInfoDB.group_id + "," + BaseInfoDB.msg_type + ","
//                + BaseInfoDB.is_out_member + "," + BaseInfoDB.msg_type_num + "," + BaseInfoDB.local_id
//                + "," + BaseInfoDB.msg_state + "," + BaseInfoDB.voice_long + "," + BaseInfoDB.unread_user_num + "," + BaseInfoDB.msg_src + "," + BaseInfoDB.class_type
//                + ") values(\'" + (null == msg.getMsg_id() ? 0 : msg.getMsg_id()) + "\',\'" + (null == msg.getMsg_text() ? "" : msg.getMsg_text()) + "\',\'" + (null == msg.getIs_readed() ? "" : msg.getIs_readed()) + "\',\'" + (null == msg.getAccounts_type() ? "1" : msg.getAccounts_type()) + "\',\'"
//                + (null == msg.getDate() ? "" : msg.getDate()) + "\',\'" + (null == msg.getUser_name() ? "" : msg.getUser_name()) + "\',\'" + (null == msg.getHead_pic() ? "" : msg.getHead_pic()) + "\',\'" + (null == msg.getBill_id() ? "0" : msg.getBill_id()) + "\',\'"
//                + (null == msg.getGroup_id() ? "" : msg.getGroup_id()) + "\',\'" + (null == msg.getMsg_type() ? "" : msg.getMsg_type()) + "\',\'"
//                + (null == msg.getIs_out_member() ? "" : msg.getIs_out_member()) + "\',\'" + msg.getMsg_type_num() + "\',\'" + (null == msg.getLocal_id() ? "" : msg.getLocal_id()) + "\',\'"
//                + msg.getMsg_state() + "\',\'" + Voice_long + "\',\'" + Unread_user_num + "\',\'" + msg_src + "\',\'" + msg.getClass_type() + "\')";
//
//        db.execSQL(sql);
//
//    }
//
//    /**
//     * 更新消息信息
//     *
//     * @param tableName
//     */
//    @Override
//    public void updateMessage(String tableName, ChatMsgEntity msg) {
//        tableName = tableName + "_" + mobile;
//        ContentValues cv = new ContentValues();
////        cv.put(_id, msg.getMsg_id());
//        cv.put(BaseInfoDB.msg_id, msg.getMsg_id());
//        cv.put(BaseInfoDB.msg_text, msg.getMsg_text());
//        cv.put(BaseInfoDB.is_readed, msg.getAccounts_type());
//        cv.put(BaseInfoDB.accounts_type, msg.getRecord_id());
//        cv.put(BaseInfoDB.bill_id, msg.getBill_id());
//        cv.put(BaseInfoDB.date, msg.getDate());
//        cv.put(BaseInfoDB.user_name, msg.getUser_name());
//        cv.put(BaseInfoDB.head_pic, msg.getHead_pic());
//        cv.put(BaseInfoDB.group_id, msg.getGroup_id());
//        cv.put(BaseInfoDB.msg_type, msg.getMsg_type());
//        cv.put(BaseInfoDB.is_out_member, msg.getIs_out_member());
//        cv.put(BaseInfoDB.msg_type_num, msg.getMsg_type_num());
//        cv.put(BaseInfoDB.local_id, msg.getLocal_id());
//        cv.put(BaseInfoDB.class_type, msg.getClass_type());
//        cv.put(BaseInfoDB.msg_state, 0);
//        if (null != msg.getMsg_src()) {
//            cv.put(BaseInfoDB.msg_src, new Gson().toJson(msg.getMsg_src()));
//        }
//        db.update(tableName, cv, BaseInfoDB.local_id + "=?", new String[]{msg.getLocal_id()});
//    }
//
//    /**
//     * 查询对应消息内容
//     *
//     * @param tableName
//     */
//    @Override
//    public List<ChatMsgEntity> selectMessage(String tableName, String msgType, String group_id, String limit, String msg_id, String calssType) {
//        tableName = tableName + "_" + mobile;
//        String sql = "";
//        if (null != msgType && !msgType.equals(WebSocketConstance.ALL)) {
//            sql = "select * from " + tableName
//                    + " where " + BaseInfoDB.msg_type + "=\'" + msgType + "\' and " + BaseInfoDB.group_id + "=" + group_id + " and " + BaseInfoDB.class_type + "=\'" + calssType
//                    + "\' and " + BaseInfoDB.msg_id + " < " + msg_id + " order by " + BaseInfoDB.msg_id +
//                    " desc limit " + limit;
//        } else {
//            sql = "select * from " + tableName + " where " + BaseInfoDB.group_id + "=" + group_id + " and " + BaseInfoDB.msg_id + " < " + msg_id + " order by " + BaseInfoDB.msg_id +
//                    " desc limit " + limit;
//        }
//
//        LUtils.e(msgType + ",,," + sql);
//        List<ChatMsgEntity> msgList = new ArrayList<>();
//        Cursor cursor = db.rawQuery(sql, null);
//
//        while (cursor.moveToNext()) {
//            ChatMsgEntity entity = new ChatMsgEntity();
//            entity.setMsg_id(cursor.getString(cursor.getColumnIndex(BaseInfoDB.msg_id)));
//            entity.setGroup_id(cursor.getString(cursor.getColumnIndex(BaseInfoDB.group_id)));
//            entity.setHead_pic(cursor.getString(cursor.getColumnIndex(BaseInfoDB.head_pic)));
//            entity.setRecord_id(cursor.getString(cursor.getColumnIndex(BaseInfoDB.bill_id)));
//            entity.setBill_id(cursor.getString(cursor.getColumnIndex(BaseInfoDB.bill_id)));
//            entity.setAccounts_type(cursor.getString(cursor.getColumnIndex(BaseInfoDB.accounts_type)));
//            entity.setUser_name(cursor.getString(cursor.getColumnIndex(BaseInfoDB.user_name)));
//            entity.setIs_readed(cursor.getString(cursor.getColumnIndex(BaseInfoDB.is_readed)));
//            entity.setMsg_text(cursor.getString(cursor.getColumnIndex(BaseInfoDB.msg_text)));
//            entity.setMsg_type(cursor.getString(cursor.getColumnIndex(BaseInfoDB.msg_type)));
//            entity.setMsg_type_num(cursor.getInt(cursor.getColumnIndex(BaseInfoDB.msg_type_num)));
//            entity.setDate(cursor.getString(cursor.getColumnIndex(BaseInfoDB.date)));
//            entity.setLocal_id(cursor.getString(cursor.getColumnIndex(BaseInfoDB.local_id)));
//            entity.setClass_type(cursor.getString(cursor.getColumnIndex(BaseInfoDB.class_type)));
//            entity.setVoice_long(cursor.getString(cursor.getColumnIndex(BaseInfoDB.voice_long)));
//            String msg_path = cursor.getString(cursor.getColumnIndex(BaseInfoDB.msg_src));
//
//            if (null != msg_path && !msg_path.equals("") && !msg_path.equals("[]")) {
//                List<String> list = new ArrayList<>();
//                msg_path = msg_path.replace("[", "").replace("]", "").replace("\"", "");
//                String[] path = msg_path.split(",");
//                for (int i = 0; i < path.length; i++) {
//                    list.add(path[i]);
//                }
//                entity.setMsg_src(list);
//            }
//            ReadInfo readInfo = new ReadInfo();
//            String unread_user_num = cursor.getString(cursor.getColumnIndex(BaseInfoDB.unread_user_num));
//            if (TextUtils.isEmpty(unread_user_num)) {
//                unread_user_num = "0";
//            }
//            readInfo.setUnread_user_num(unread_user_num);
//            entity.setRead_info(readInfo);
//            msgList.add(entity);
//        }
//
//        Collections.reverse(msgList);
//        closeCurse(cursor);
//
//        return msgList;
//    }
//
//    /**
//     * 获取最大消息id
//     *
//     * @param tableName
//     */
//    @Override
//    public String selectMaxId(String tableName, String msgType, String group_id) {
//        tableName = tableName + "_" + mobile;
//        String sql = "";
//        if (null != msgType && !msgType.equals(WebSocketConstance.ALL)) {
//            sql = "select max(" + BaseInfoDB.msg_id + ") from " + tableName + " where " + BaseInfoDB.msg_type + "=\'" + msgType + "\' and " + BaseInfoDB.group_id + "=" + group_id + "";
//        } else {
//            sql = "select max(" + BaseInfoDB.msg_id + ") from " + tableName + " where " + BaseInfoDB.group_id + "=" + group_id + "";
//        }
//
////        LUtils.e(sql);
//        Cursor cursor = db.rawQuery(sql, null);
//        String msg_id = "0";
//        if (null == cursor) {
//            return msg_id;
//        }
//        while (cursor.moveToNext()) {
//            msg_id = cursor.getString(0);
//        }
//        if (null == msg_id || msg_id.equals("")) {
//            msg_id = "0";
//        }
//
//        return msg_id;
//    }
//
//    /**
//     * 查询未读数量
//     */
//    @Override
//    public void UpdateUnread_user_num(String tableName, ChatMsgEntity msg) {
//        tableName = tableName + "_" + mobile;
//        if (null != msg && null != msg.getRead_info()) {
//            ContentValues cv = new ContentValues();
//            cv.put(BaseInfoDB.unread_user_num, msg.getRead_info().getUnread_user_num());
//            db.update(tableName, cv, BaseInfoDB.msg_id + "=?", new String[]{msg.getMsg_id()});
//        }
//    }
//
//    /**
//     * 查询消息已读未读状态
//     */
//    @Override
//    public void UpdateMsgRead(String tableName, List<ChatMsgEntity> msg) {
//        tableName = tableName + "_" + mobile;
//        if (null != msg && msg.size() > 0) {
//            for (int i = 0; i < msg.size(); i++) {
//                ContentValues cv = new ContentValues();
//                cv.put(BaseInfoDB.is_readed, 1);
//                db.update(tableName, cv, BaseInfoDB.msg_id + "=?", new String[]{msg.get(i).getMsg_id()});
//            }
//        }
//
//    }
//
//
//    /**
//     * 跟新语音消息本地是否已读VoiceLocal 0,未读 1.已读
//     */
//    @Override
//    public void UpdateVoiceLocalRead(String tableName, String msgId) {
//        tableName = tableName + "_" + mobile;
//        ContentValues cv = new ContentValues();
//        cv.put(BaseInfoDB.bill_id, 1);
//        db.update(tableName, cv, BaseInfoDB.msg_id + "=?", new String[]{msgId});
//    }
//
//    @Override
//    public void RecallMsgUpdate(String tableName, ChatMsgEntity msg) {
//        tableName = tableName + "_" + mobile;
//        ContentValues cv = new ContentValues();
//        cv.put(BaseInfoDB.msg_type_num, MessageType.MSG_MENBERJOIN);
//        cv.put(BaseInfoDB.msg_text, msg.getMsg_text());
//        db.update(tableName, cv, BaseInfoDB.msg_id + "=? and " + BaseInfoDB.class_type + "=?", new String[]{msg.getMsg_id(), msg.getClass_type()});
//    }
//
//    @Override
//    public void DeleteFialMsg(String tableName, String local_id) {
//        tableName = tableName + "_" + mobile;
//        db.delete(tableName, BaseInfoDB.local_id + "=?", new String[]{local_id});
//    }
}
