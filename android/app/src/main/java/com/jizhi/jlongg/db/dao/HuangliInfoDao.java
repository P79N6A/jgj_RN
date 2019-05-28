package com.jizhi.jlongg.db.dao;

import com.jizhi.jlongg.main.bean.Huangli;
import com.jizhi.jlongg.main.bean.Other;

import java.util.List;

/**
 * 基础信息接口
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-25 下午4:48:45
 */
public interface HuangliInfoDao {

    /**
     * 吉凶dialog数据
     */
    List<Other> selectInfoJixong();

    /**
     * 吉凶list
     */
    List<Other> selectInfoJixongList(String starttime, String endtime, String yi, String str);

    /**
     * 黄历
     */
    Huangli selectHuangliInfo(String solardate);


}
