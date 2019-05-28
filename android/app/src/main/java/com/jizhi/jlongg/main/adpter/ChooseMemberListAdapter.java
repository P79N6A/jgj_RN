package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
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
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogUnRegister;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:选择成员
 * 时间:2016-12-23 15:01:14
 * 作者:xuj
 */
public class ChooseMemberListAdapter extends PersonBaseAdapter {
    /**
     * 班组人员列表数据
     */
    public List<GroupMemberInfo> list;
    /**
     * 是否显示选中框
     */
    private boolean isShowSelecteIcon;
    /**
     * 是否显示底部文字描述
     */
    private boolean isShowBottomDesc;
    /**
     * 过滤文本
     */
    private String filterValue;
    /**
     * 项目组id,项目类型
     */
    private String groupId, classType;
    /**
     * 上下文
     */
    private Context context;


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public ChooseMemberListAdapter(Context context, List<GroupMemberInfo> list, boolean isShowSelecteIcon, boolean isShowBottomDesc, String groupId, String classType) {
        super();
        this.context = context;
        this.list = list;
        this.isShowBottomDesc = isShowBottomDesc;
        this.isShowSelecteIcon = isShowSelecteIcon;
        this.groupId = groupId;
        this.classType = classType;
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
            convertView = LayoutInflater.from(context).inflate(R.layout.item_choose_member, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(ViewHolder holder, int position, View convertView) {
        final GroupMemberInfo bean = list.get(position);
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
        holder.seletedImage.setImageResource(bean.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        if (isShowBottomDesc) {
            holder.bottomDesc.setVisibility(position == list.size() - 1 ? View.VISIBLE : View.GONE);
        } else {
            holder.bottomDesc.setVisibility(View.GONE);
        }
        if (isShowSelecteIcon) {
            holder.seletedImage.setVisibility(View.VISIBLE);
            if (!bean.isClickable()) {
                holder.seletedImage.setImageResource(R.drawable.checkbox_disable);
                holder.isAdd.setVisibility(View.VISIBLE);
            } else {
                holder.seletedImage.setImageResource(bean.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                holder.isAdd.setVisibility(View.GONE);
            }
        } else {
            holder.seletedImage.setVisibility(View.GONE);
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
        holder.isRegister.setVisibility(bean.getIs_active() == 0 ? View.VISIBLE : View.INVISIBLE);
        holder.isRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new DialogUnRegister((Activity) context, classType, groupId, bean).show();
            }
        });
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            isAdd = convertView.findViewById(R.id.isAdd);
            seletedImage = (ImageView) convertView.findViewById(R.id.seletedImage);
            bottomDesc = (TextView) convertView.findViewById(R.id.bottomDesc);
            isRegister = (ImageView) convertView.findViewById(R.id.isRegister);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
            background = convertView.findViewById(R.id.background);
            catalog = (TextView) convertView.findViewById(R.id.catalog);
        }


        /**
         * 名称
         */
        TextView name;
        /**
         * 电话号码
         */
        TextView tel;
        /**
         * 是否勾选
         */
        ImageView seletedImage;
        /**
         * 人员数量
         */
        TextView bottomDesc;
        /**
         * 是否注册
         */
        ImageView isRegister;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
        /**
         * 首字母
         */
        TextView catalog;
        /**
         * 首字母背景色
         */
        View background;
        /**
         * 是否已添加
         */
        View isAdd;

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

    public List<GroupMemberInfo> getList() {
        return list;
    }


    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
