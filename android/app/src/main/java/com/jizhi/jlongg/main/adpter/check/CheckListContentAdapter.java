package com.jizhi.jlongg.main.adpter.check;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseCheckInfo;

import java.util.List;

/**
 * CName:检查项、检查内容适配器
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class CheckListContentAdapter extends BaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 列表数据
     */
    private List<BaseCheckInfo> list;

    public CheckListContentAdapter(Activity context, List<BaseCheckInfo> list) {
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public BaseCheckInfo getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup arg2) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.check_list_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(position, convertView, holder);
        return convertView;
    }

    private void bindData(final int position, View convertView, ViewHolder holder) {
        BaseCheckInfo baseCheckInfo = list.get(position);
        holder.divider.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
        holder.name.setText(baseCheckInfo.getName());
    }

    class ViewHolder {
        /**
         * 分割线
         */
        View divider;
        /**
         * 名称
         */
        TextView name;

        public ViewHolder(View convertView) {
            divider = convertView.findViewById(R.id.divider);
            name = (TextView) convertView.findViewById(R.id.name);
        }

    }


    public void updateListView(List<BaseCheckInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<BaseCheckInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public List<BaseCheckInfo> getList() {
        return list;
    }

    public void setList(List<BaseCheckInfo> list) {
        this.list = list;
    }
}
