package com.jizhi.jlongg.main.adpter;

import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

/**
 * Created by Administrator on 2016/12/21 0021.
 */

public class PersonBaseAdapter extends BaseAdapter {


    @Override
    public int getCount() {
        return 0;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return null;
    }

    /**
     * 设置电话号码和名称
     *
     * @param realName
     * @param telphone
     * @param nameText
     * @param telText
     */
    public void setTelphoneAndRealName(String realName, String telphone, TextView nameText, TextView telText) {
        nameText.setText(realName);
        telText.setText(telphone);
        telText.setVisibility(TextUtils.isEmpty(telphone) ? View.GONE : View.VISIBLE); //如果电话号码为空则隐藏
    }
}
