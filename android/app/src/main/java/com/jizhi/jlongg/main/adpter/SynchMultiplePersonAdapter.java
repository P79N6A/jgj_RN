package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:同步多个联系人
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class SynchMultiplePersonAdapter extends PersonBaseAdapter {
    /**
     * 列表数据
     */
    private List<SynBill> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 过滤文本
     */
    private String filterValue;

    public SynchMultiplePersonAdapter(Activity context, List<SynBill> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
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
            convertView = inflater.inflate(R.layout.item_synch_multipleperson, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, int position) {
        final SynBill bean = list.get(position);
        String descript = bean.getDescript();
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
        if (TextUtils.isEmpty(descript)) {
            holder.line.setVisibility(View.GONE);
            holder.descript.setText(null);
        } else {
            holder.line.setVisibility(View.VISIBLE);
            holder.descript.setText(bean.getDescript());
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
        if (bean.getIs_sync() == 1) { //当前对象已同步
            holder.selectedImage.setImageResource(R.drawable.checkbox_disable);
        } else {
            holder.selectedImage.setImageResource(bean.isSelcted() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        }
    }


    public void setList(List<SynBill> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            selectedImage = (ImageView) convertView.findViewById(R.id.seletedImage);
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            synchState = (TextView) convertView.findViewById(R.id.synchState);
            descript = (TextView) convertView.findViewById(R.id.descript);
            line = convertView.findViewById(R.id.line);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
        }

        /* 是否同步 */
        TextView synchState;
        /* 首字母背景色 */
        View background;
        /* 名称 */
        TextView name;
        /* 电话号码 */
        TextView tel;
        /* 首字母 */
        TextView catalog;
        /* 是否勾选 */
        ImageView selectedImage;
        /* 项目组名称 */
        TextView descript;

        View line;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
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


    /**
     * 局部刷新
     *
     * @param view
     * @param itemIndex
     */
    public void updateSingleView(View view, int itemIndex) {
        if (view == null) {
            return;
        }
        //从view中取得holder
        ViewHolder holder = (ViewHolder) view.getTag();
        bindData(holder, itemIndex);
    }

    public List<SynBill> getList() {
        return list;
    }


    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
