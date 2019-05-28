package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PersonInfo;

/**
 * 功能:项目详情 拨打电话 适配器
 * 时间:2016-6-27 17:28
 * 作者: xuj
 */
public class CallPhoneAdapter extends BaseAdapter {
    private PersonInfo[] phoneList;
    private LayoutInflater inflater;

    public CallPhoneAdapter(Context context, PersonInfo[] phoneList) {
        super();
        this.phoneList = phoneList;
        inflater = LayoutInflater.from(context);

    }

    @Override
    public int getCount() {
        return phoneList == null ? 0 : phoneList.length;
    }

    @Override
    public Object getItem(int position) {
        return phoneList[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        PersonInfo phoneInfo = phoneList[position];
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_callphone, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_phone = (TextView) convertView.findViewById(R.id.tv_phone);
            holder.lin_callphone = (LinearLayout) convertView.findViewById(R.id.lin_callphone);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(phoneInfo.getFmname());
        holder.tv_phone.setText(phoneInfo.getTelph());
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        TextView tv_phone;
        LinearLayout lin_callphone;
    }
}
