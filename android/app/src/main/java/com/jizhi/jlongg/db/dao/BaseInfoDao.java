package com.jizhi.jlongg.db.dao;

import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.List;

/**
 * 基础信息接口
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-25 下午4:48:45
 */
public interface BaseInfoDao {
    /**
     * 增加数据
     */
    void insertBaseInfo(WorkType type, String tableName);

    /**
     * 查询是否添加过此条数据
     */
    boolean isInsertInfo(String name, String tableName);

    /**
     * 查询所有数据
     */
    List<WorkType> selectInfo(String tableName);


    /**
     * 查询主页所需数据
     */
    List<WorkType> selectInfoForMain(String tableName);

    /**
     * 根据表明和id查询对象的数据 单条
     */
    String selectInfoName(String tableName, int id);

    /**
     * 根据id查询省市区
     */
    List<CityInfoMode> SelectCity(String patent_id);

    /**
     * 根据名字查询信息
     */
    CityInfoMode selectCityName(String cityName);

    /**
     * 查询是否添加过此条城市数据
     */
    boolean isInsertCity(String name, String tableName);

    /**
     * 增加城市信息
     */
    CityInfoMode insertCityInfo(CityInfoMode cityInfoMode,
                                String tableName);

    /**
     * 增加城市信息
     */
    List<CityInfoMode> selectCites(String tableName);

    /**
     * 根据表明和城市名查询城市编号
     */
    String selectCityCode(String tableName, String city_name);

    /**
     * 查询熟练度
     */
    String selectWorklevel(int id);

    /**
     * 查询所有城市信息
     */
    List<CityInfoMode> selectAllCity();

    void clearTable(String tableName);

    void insertWorkType(int id, String name, String tableName);

    /**
     * 增加城市信息
     */
    CityInfoMode selectProvince(String city_code);

//    /**
//     * 增加聊天信息
//     */
//    void insertMessageAll(String tableName, List<ChatMsgEntity> chatMsgEntity);

//    /**
//     * 增加单条聊天信息
//     */
//    void insertMessage(String tableName, ChatMsgEntity chatMsgEntity);
//
//    /**
//     * 修改单条聊天信息
//     */
//    void updateMessage(String tableName, ChatMsgEntity chatMsgEntity);
//
//    /**
//     * 查询聊天信息
//     */
//    List<ChatMsgEntity> selectMessage(String tableName, String msgType, String group_id, String limit, String msg_id, String calssType);

//    /**
//     * 查询最大id
//     */
//    String selectMaxId(String tableName, String msgType, String group_id);
//
//    /**
//     * 查询未读数量
//     */
//    void UpdateUnread_user_num(String tableName, ChatMsgEntity msg);
//
//    void UpdateMsgRead(String tableName, List<ChatMsgEntity> msg);
//
//    void UpdateVoiceLocalRead(String tableName, String msgId);
//
//    /**
//     * 撤回
//     */
//    void RecallMsgUpdate(String tableName, ChatMsgEntity msg);
//
//    void DeleteFialMsg(String tableName, String local_id);
}
