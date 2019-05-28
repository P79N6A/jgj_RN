package com.jizhi.jlongg.main.listener;

/**
 * 功能: 添加人员回调
 * 作者：Xuj
 * 时间: 2016年9月2日 15:04:34
 */
public interface SelectedLuckyDayListener {

    public void selectedLuckyDayClick(String yi, String type, int currLeft, int currRight);

    public void selectedCaldenerClick(String year, String month, String date, String week);
}
