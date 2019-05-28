package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.listener.AddSynchPersonListener;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:手机通讯录
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class SynContactsAdatper extends PersonBaseAdapter {
    /* 列表数据 */
    private List<SynBill> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 添加按钮回调 */
    private AddSynchPersonListener listener;
    /* 过滤文本 */
    private String filterValue;

    public SynContactsAdatper(Context context, List<SynBill> list, AddSynchPersonListener listener) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<SynBill> list) {
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


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_syn_contacts, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bingData(holder, position);
        return convertView;
    }

    private void bingData(ViewHolder holder, final int position) {
        final SynBill bean = list.get(position);
        holder.roundImageHashText.setView(null, bean.getReal_name(), position);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(bean.getReal_name())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getReal_name());
                Matcher nameMatch = p.matcher(bean.getReal_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.name.setText(builder);
            }
            if (!TextUtils.isEmpty(bean.getTelephone())) { //电话号码不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getTelephone());
                Matcher telMatch = p.matcher(bean.getTelephone());
                while (telMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.tel.setText(builder);
            }
        } else {
            setTelphoneAndRealName(bean.getReal_name(), bean.getTelephone(), holder.name, holder.tel);
        }
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            if (bean.getSortLetters().equals("@")) {
                holder.catalog.setText("已选中");
            } else {
                holder.catalog.setText(bean.getSortLetters());
            }
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalog.setVisibility(View.GONE);
        }
        if (bean.isAdd()) {
            holder.addBtn.setVisibility(View.INVISIBLE);
            holder.isAdd.setVisibility(View.VISIBLE);
        } else {
            holder.addBtn.setVisibility(View.VISIBLE);
            holder.isAdd.setVisibility(View.GONE);
        }
        holder.addBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.add(bean.getReal_name(), bean.getTelephone(), bean.getDescript(), position);
                }
            }
        });
    }


    public void setList(List<SynBill> list) {
        this.list = list;
    }

    class ViewHolder {
        /* 首字母背景色 */
        View background;
        /* 用户名称 */
        TextView name;
        /* 电话号码 */
        TextView tel;
        /* 拼音首字母 */
        TextView catalog;
        /* 添加按钮 */
        TextView addBtn;
        /**
         * 已添加布局
         */
        LinearLayout isAdd;
        /**
         * 头像、HashCode文本
         */
        private RoundeImageHashCodeTextLayout roundImageHashText;

        private ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            addBtn = (TextView) convertView.findViewById(R.id.add_btn);
            isAdd = (LinearLayout) convertView.findViewById(R.id.is_add);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
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

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
