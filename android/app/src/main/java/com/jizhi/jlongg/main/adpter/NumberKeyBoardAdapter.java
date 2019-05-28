package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

import java.util.List;

/**
 * 功能:数字键盘适配器
 * 时间:2017年4月6日14:39:00
 * 作者:xuj
 */
public class NumberKeyBoardAdapter extends BaseAdapter {
    /* 成员列表数据 */
    private List<String> list;
    /* xml数据解析器 */
    private LayoutInflater inflater;
    /* 是否是修改手机号码的键盘 */
    private boolean isUpdateTelphone;


    public NumberKeyBoardAdapter(BaseActivity activity, List<String> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(activity);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            if (isUpdateTelphone) {
                convertView = inflater.inflate(R.layout.item_number_white_keyboard, null);
            } else {
                convertView = inflater.inflate(R.layout.item_number_black_keyboard, null);
            }
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(final ViewHolder holder, int position) {
        String desc = list.get(position);
        holder.number.setText(desc);
        holder.number.setTextSize(position == list.size() - 1 ? 20 : 25);
    }


    class ViewHolder {
        /* 是否是我创建的班组 */
        private TextView number;

        public ViewHolder(View view) {
            number = (TextView) view.findViewById(R.id.number);
        }
    }

    public boolean isUpdateTelphone() {
        return isUpdateTelphone;
    }

    public void setUpdateTelphone(boolean updateTelphone) {
        isUpdateTelphone = updateTelphone;
    }
}
