package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
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
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:人员列表适配器
 * 时间:2016-12-21 10:56:28
 * 作者:xuj
 */
public class CommonPersonListAdapter extends PersonBaseAdapter {

    private BaseActivity context;
    /**
     * 班组人员列表数据
     */
    public List<GroupMemberInfo> list;
    /**
     * 是否显示Item选择框
     */
    private boolean showSelectImageView;
    /**
     * 是否显示成员数量
     */
    private boolean showMemberCount = true;
    /**
     * 是否隐藏电话
     */
    private boolean isHiddenTel;
    /**
     * 过滤文本
     */
    private String filterValue;
    /**
     * 底部文本
     */
    private String footText;

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public CommonPersonListAdapter(BaseActivity context, List<GroupMemberInfo> list, boolean showItemSelectView) {
        super();
        this.list = list;
        this.context = context;
        this.showSelectImageView = showItemSelectView;
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
            convertView = LayoutInflater.from(context).inflate(R.layout.item_add_team_person, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }


    private void bindData(ViewHolder holder, int position, View convertView) {
        GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
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
        if (isHiddenTel) {
            holder.tel.setVisibility(View.GONE);
        }
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            holder.catalog.setText(bean.getSortLetters());
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalog.setVisibility(View.GONE);
        }
        if (showSelectImageView) { //是否显示选中框
            if (!bean.isClickable()) {
                holder.seletedImage.setImageResource(R.drawable.checkbox_disable);
                holder.isAdd.setVisibility(View.VISIBLE);
            } else {
                holder.seletedImage.setImageResource(bean.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                holder.isAdd.setVisibility(View.GONE);
            }
            holder.personCount.setVisibility(View.GONE);
        } else {
            holder.seletedImage.setVisibility(View.GONE);
            if (showMemberCount && position == list.size() - 1) { //设置人员总数
                if (TextUtils.isEmpty(footText)) {
                    holder.personCount.setText(String.format(context.getString(R.string.contact_person_count), list.size()));
                } else {
                    holder.personCount.setText(footText);
                }
                holder.personCount.setVisibility(View.VISIBLE);
            } else {
                holder.personCount.setVisibility(View.GONE);
            }
        }
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            seletedImage = (ImageView) convertView.findViewById(R.id.seletedImage);
            personCount = (TextView) convertView.findViewById(R.id.personCount);
            isAdd = (TextView) convertView.findViewById(R.id.isAdd);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
        }

        /**
         * 首字母背景色
         */
        View background;
        /**
         * 名称
         */
        TextView name;
        /**
         * 电话号码
         */
        TextView tel;
        /**
         * 首字母
         */
        TextView catalog;
        /**
         * 是否勾选
         */
        ImageView seletedImage;
        /**
         * 人员数量
         */
        TextView personCount;
        /**
         * 是否已添加
         */
        TextView isAdd;
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
        bindData(holder, itemIndex, view);
    }

    public List<GroupMemberInfo> getList() {
        return list;
    }


    public void setShowMemberCount(boolean showMemberCount) {
        this.showMemberCount = showMemberCount;
    }

    public boolean isHiddenTel() {
        return isHiddenTel;
    }

    public void setHiddenTel(boolean hiddenTel) {
        isHiddenTel = hiddenTel;
    }


    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }

    public String getFootText() {
        return footText;
    }

    public void setFootText(String footText) {
        this.footText = footText;
    }
}
