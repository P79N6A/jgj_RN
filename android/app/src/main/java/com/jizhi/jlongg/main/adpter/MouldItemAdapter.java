package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageModel;

import java.util.List;


/**
 * 功能:添加好友 消息模板适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class MouldItemAdapter extends BaseAdapter {


    /**
     * 已选中的下标
     */
    private int selectedPostion;
    /**
     * 列表数据
     */
    private List<MessageModel> list;
    /**
     * 上下文
     */
    private Context context;

    public MouldItemAdapter(Context context, List<MessageModel> list) {
        super();
        this.list = list;
        this.context = context;
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public MessageModel getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.mould_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }

    private void bindData(final ViewHolder holder, int position) {
        holder.mouldName.setText(getItem(position).getMsg_text());
        holder.itemDiver.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
        holder.selectedIcon.setVisibility(position == selectedPostion ? View.VISIBLE : View.GONE);
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            itemDiver = convertView.findViewById(R.id.itemDiver);
            mouldName = (TextView) convertView.findViewById(R.id.mouldName);
            selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
        }

        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 消息模板
         */
        TextView mouldName;
        /**
         * 选中消息的图标
         */
        ImageView selectedIcon;
    }

    public int getSelectedPostion() {
        return selectedPostion;
    }

    public void setSelectedPostion(int selectedPostion) {
        this.selectedPostion = selectedPostion;
    }
}
