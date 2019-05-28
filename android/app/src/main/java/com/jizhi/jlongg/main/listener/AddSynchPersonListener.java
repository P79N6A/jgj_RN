package com.jizhi.jlongg.main.listener;

/**
 * 功能:添加记账对象
 * 作者：Administrator
 * 时间: 2016-5-25 15:54
 */
public interface AddSynchPersonListener {
    /**
     * @param real_name 用户名
     * @param telphone 电话号码
     * @param descript 描述
     * @param position
     */
    public void add(String real_name, String telphone, String descript, int position);

}
