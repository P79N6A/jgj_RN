package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.RemberInfoTargetNameBean;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能: 选择质量，安全地址adapter
 * 作者：胡常生
 * 时间: 2017年5月27日 11:10:12
 */
public class RemberWokerInfoPeopleAdapter extends BaseAdapter {


    /* 添加工人列表数据 */
    private List<RemberInfoTargetNameBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private ItemClickListener itemClickListener;

    public RemberWokerInfoPeopleAdapter(Activity context, List<RemberInfoTargetNameBean> list, ItemClickListener itemClickListener) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.itemClickListener = itemClickListener;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */

    public void updateList(List<RemberInfoTargetNameBean> list) {
        this.list = list;
        notifyDataSetChanged();
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


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_select_release_people, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemClickListener.itemClick(position);
            }
        });
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position) {
        RemberInfoTargetNameBean bean = list.get(position);
        holder.name.setText(bean.getName());
        holder.img_head.setView(bean.getHead_pic(), bean.getName(), 0);
        if (bean.isSelect()) {
            holder.img_hook.setVisibility(View.VISIBLE);
        } else {
            holder.img_hook.setVisibility(View.GONE);
        }
        holder.img_active.setVisibility(View.GONE);
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.catalog.setText(bean.getSortLetters());
        } else {
            holder.catalog.setVisibility(View.GONE);
        }
        holder.background.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
    }


    class ViewHolder {
        /* 人物名称 */
        TextView name;
        ImageView img_hook;
        ImageView img_active;
        RoundeImageHashCodeTextLayout img_head;
        View background;
        /* 拼音首字母 */
        TextView catalog;

        public ViewHolder(View convertView) {
            name = (TextView) convertView.findViewById(R.id.name);
            img_hook = (ImageView) convertView.findViewById(R.id.img_hook);
            img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            img_active = (ImageView) convertView.findViewById(R.id.img_active);
            background = (View) convertView.findViewById(R.id.background);
            catalog = (TextView) convertView.findViewById(R.id.catalog);

        }
    }


    /**
     * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
     */
    @SuppressWarnings("unused")
    public int getPositionForSection(int section) {
        for (int i = 0; i < getCount(); i++) {
            String sortStr = list.get(i).getSortLetters();
            if (null != sortStr) {
                char firstChar = sortStr.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }
        }
        return -1;
    }


    /**
     * 根据ListView的当前位置获取分类的首字母的Char ascii值
     */
    public int getSectionForPosition(int position) {
        if (null == list.get(position).getSortLetters()) {
            return 1;
        }
        return list.get(position).getSortLetters().charAt(0);
    }

    public interface ItemClickListener {
        void itemClick(int posotion);
    }
}