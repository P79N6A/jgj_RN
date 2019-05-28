package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ChatManagerItem;

import java.util.ArrayList;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class ShareMenuAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private ArrayList<ChatManagerItem> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;


    public ShareMenuAdapter(Context context, ArrayList<ChatManagerItem> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public ChatManagerItem getItem(int position) {
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
            convertView = inflater.inflate(R.layout.item_share_menu, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        ChatManagerItem chatManagerItem = getItem(position);
        holder.menuName.setText(chatManagerItem.getMenu());
        if (chatManagerItem.getMenuDrawable() != null) {
//            Drawable mClearDrawable = chatManagerItem.getMenuDrawable();
//            mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
//            holder.menuName.setCompoundDrawables(null, mClearDrawable, null, null);
            holder.menuSrc.setImageDrawable(chatManagerItem.getMenuDrawable());
        }
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            menuName = convertView.findViewById(R.id.menu_name);
            menuSrc = convertView.findViewById(R.id.menu_src);
        }

        /* 菜单名称 */
        TextView menuName;


        ImageView menuSrc;
    }
}
