package com.jizhi.jlongg.db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import com.jizhi.jlongg.db.dao.HuangliInfoDao;
import com.jizhi.jlongg.main.bean.Huangli;
import com.jizhi.jlongg.main.bean.Other;

import java.util.ArrayList;
import java.util.List;

/**
 * 基础信息增删改实现类
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-25 下午4:50:00
 */
public class HuangliBaseInfoService extends SQLiteOpenHelper implements HuangliInfoDao {

    public final String HL_JIXIONG = "jgj_jixiong";
    public final String HL_HUANGLI = "jgj_huangli";

    private static SQLiteDatabase db = null;
    private static HuangliBaseInfoService mInstance = null;

    public HuangliBaseInfoService(Context context) {
        super(context, DaoBaseConstance.HUANGLI_DATABASE_NAME, null, DaoBaseConstance.HUANGLI_DATABASE_VERSION);
    }

    public synchronized static HuangliBaseInfoService getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new HuangliBaseInfoService(context);
            db = mInstance.getWritableDatabase();
        }
        return mInstance;
    }

    @Override
    public List<Other> selectInfoJixong() {
        ArrayList<Other> hl = new ArrayList<>();
        String sql = "select * from " + HL_JIXIONG;
        Cursor cursor = db.rawQuery(sql, null);

        while (cursor.moveToNext()) {
            String name = cursor.getString(1);
            String content = cursor.getString(2);
            Other mode = new Other();
            mode.setName(name);
            mode.setContent(content);
            hl.add(mode);
        }
        return hl;
    }

    @Override
    public List<Other> selectInfoJixongList(String starttime, String endtime, String yi, String str) {
        ArrayList<Other> hl = new ArrayList<>();
        String sql = "select all_date,zh_month,zh_day,weekday from " + HL_HUANGLI + " where (all_date between \'" + starttime + "\' and \'" + endtime + " \') and " + yi + " like '%" + str + "%' ";
        Cursor cursor = db.rawQuery(sql, null);
        while (cursor.moveToNext()) {
            String solarDate = cursor.getString(0);
            String lunarMonth = cursor.getString(1);
            String lunarDate = cursor.getString(2);
            if (lunarDate.equals("廿")) {
                lunarDate = "二十";
            }
            String week = cursor.getString(3);
            Other mode = new Other();
            mode.setTemp(solarDate);
            mode.setWeek(week);
            mode.setContent(solarDate + "  " + lunarMonth + "  " + lunarDate + "  " + week);
            System.out.println(mode.getContent());
            hl.add(mode);
        }
        return hl;
    }

    @Override
    public Huangli selectHuangliInfo(String solardate) {
        System.out.println("solardate:" + solardate);
        Huangli hl = new Huangli();
        String sql = "select yi,ji,xishen,fushen,caishen,jishi,jieqi,all_date from jgj_huangli where all_date= \'" + solardate + "\'";
        Cursor cursor = db.rawQuery(sql, null);
        while (cursor.moveToNext()) {
            hl.setYi(cursor.getString(0));
            hl.setJi(cursor.getString(1));
            hl.setXishen(cursor.getString(2));
            hl.setFushen(cursor.getString(3));
            hl.setCaishen(cursor.getString(4));
            hl.setJishi(cursor.getString(5));
            hl.setJieqi(cursor.getString(6));
            hl.setSolarDate(cursor.getString(7));
        }
        return hl;
    }

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

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {

    }
}
