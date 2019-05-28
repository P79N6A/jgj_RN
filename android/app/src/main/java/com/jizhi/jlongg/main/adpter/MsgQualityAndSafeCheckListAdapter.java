package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;

import java.util.List;

/**
 * CName:质量，安全检查列表页大项Adapter 2.3.0
 * User: hcs
 * Date: 2017-07-18
 * Time: 11:18
 */

public class MsgQualityAndSafeCheckListAdapter extends BaseAdapter {
    private List<QualityAndsafeCheckMsgBean> list;
    private LayoutInflater inflater;

    public MsgQualityAndSafeCheckListAdapter(Context context, List<QualityAndsafeCheckMsgBean> list) {
        this.list = list;
        inflater = LayoutInflater.from(context);
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

    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final QualityAndsafeCheckMsgBean msgEntity = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message_quality_and_safe_check_list, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_inspect_name = (TextView) convertView.findViewById(R.id.tv_inspect_name);
            holder.tv_child_inspect_name = (TextView) convertView.findViewById(R.id.tv_child_inspect_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(msgEntity.getInspect_name());
        if (msgEntity.getChange_color() > 0) {
            holder.tv_inspect_name.setText(Html.fromHtml("剩余<font color='#eb4e4e'>" + msgEntity.getChange_color() + "</font>项未检查"));
        } else {
            holder.tv_inspect_name.setText("已完成检查");
        }

        holder.tv_child_inspect_name.setText(msgEntity.getChild_inspect_name());
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        TextView tv_inspect_name;
        TextView tv_child_inspect_name;
    }
}
