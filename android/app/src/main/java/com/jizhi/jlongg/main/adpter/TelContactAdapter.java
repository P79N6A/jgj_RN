package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:手机通讯录适配器
 * 时间:2016-12-23 15:01:14
 * 作者:xuj
 */
public class TelContactAdapter extends PersonBaseAdapter {

    /**
     * 列表数据
     */
    public ArrayList<GroupMemberInfo> list;
    /**
     * 上下文
     */
    private Context context;
    /**
     * 筛选文本框
     */
    private String filterValue;

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(ArrayList<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public TelContactAdapter(BaseActivity context, ArrayList<GroupMemberInfo> list) {
        super();
        this.list = list;
        this.context = context;
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
            convertView = LayoutInflater.from(context).inflate(R.layout.item_tel_contact, null);
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
        holder.isRegister.setVisibility(bean.getIs_active() == 0 ? View.VISIBLE : View.GONE);
        holder.divier.setVisibility(position == list.size() - 1 ? View.INVISIBLE : View.VISIBLE);
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.catalog.setText(bean.getSortLetters());
        } else {
            holder.catalog.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(bean.getUid()) && bean.getUid().equals(UclientApplication.getUid(context))) { //用户id不为空并且为自己时
            holder.tel.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
            holder.name.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
            Utils.setBackGround(convertView, context.getResources().getDrawable(R.drawable.listview_selector_gray_white));
        } else {
            Utils.setBackGround(convertView, context.getResources().getDrawable(R.drawable.listview_selector_white_gray));
            holder.name.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            holder.tel.setTextColor(ContextCompat.getColor(context, R.color.color_666666));
        }
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            isRegister = (ImageView) convertView.findViewById(R.id.isRegister);
            divier = convertView.findViewById(R.id.itemDiver);
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
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
         * 是否注册
         */
        ImageView isRegister;
        /**
         * 首字母
         */
        TextView catalog;
        /**
         * 头像、HashCode文本
         */
        private RoundeImageHashCodeTextLayout roundImageHashText;


        View divier;
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

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
