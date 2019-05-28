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
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.dialog.DialogOnlyTextDesc;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 记账-->添加工人、工头adapter
 *
 * @author Xuj
 * @version 1.0
 * @time 2016年2月19日 10:25:26
 */
public class AddWorkerOrForemanAdapter extends PersonBaseAdapter {


    /* 添加工人列表数据 */
    private List<PersonBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 是否是删除列表 */
    private Boolean isShowDel;
    /* 删除回调 */
    private DialogOnlyTextDesc.CloseListener listener;
    /* 上下文 */
    private BaseActivity context;
    /* 删除弹框 */
    private DialogOnlyTextDesc dialog;
    /* 过滤文本 */
    private String filterValue;

    public void setShowDel(Boolean showDel) {
        isShowDel = showDel;
        notifyDataSetChanged();
    }

    public AddWorkerOrForemanAdapter(BaseActivity context, List<PersonBean> list, DialogOnlyTextDesc.CloseListener listener) {
        super();
        isShowDel = false;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
        this.context = context;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<PersonBean> list) {
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
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.add_worker_or_foreman_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position) {
        PersonBean bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getName(), position);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(bean.getName())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getName());
                Matcher nameMatch = p.matcher(bean.getName());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.name.setText(builder);
            }
            if (!TextUtils.isEmpty(bean.getTelph())) { //电话号码不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getTelph());
                Matcher telMatch = p.matcher(bean.getTelph());
                while (telMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.tel.setText(builder);
            }
        } else {
            setTelphoneAndRealName(bean.getName(), bean.getTelph(), holder.name, holder.tel);
        }
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
            holder.catalog.setText(bean.isChecked() ? "已选中" : bean.getSortLetters());
        } else {
            holder.background.setVisibility(View.VISIBLE);
            holder.catalog.setVisibility(View.GONE);
        }
        if (isShowDel) {
            holder.btnDelete.setVisibility(View.VISIBLE);
            holder.selectedText.setVisibility(View.GONE);
        } else {
            holder.btnDelete.setVisibility(View.GONE);
            holder.selectedText.setVisibility(bean.isChecked() ? View.VISIBLE : View.GONE);
        }
        holder.btnDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deletePerson(context, position);
            }
        });
    }


    public void deletePerson(final BaseActivity activity, final int position) {
        if (dialog == null) {
            dialog = new DialogOnlyTextDesc(activity, listener, position, String.format(activity.getString(R.string.delperson), list.get(position).getName()));
        } else {
            dialog.updateContent(String.format(activity.getString(R.string.delperson), list.get(position).getName()), position);
        }
        dialog.show();
    }

    class ViewHolder {
        /* 首字母背景色 */
        View background;
        /* 人物名称 */
        TextView name;
        /* 电话号码 */
        TextView tel;
        /* 拼音首字母 */
        TextView catalog;
        /* 已选中文字 */
        TextView selectedText;
        /* 删除按钮 */
        TextView btnDelete;
        /* 头像、HashCode文本 */
        RoundeImageHashCodeTextLayout roundImageHashText;


        public ViewHolder(View convertView) {
            catalog = (TextView) convertView.findViewById(R.id.catalog);
            background = convertView.findViewById(R.id.background);
            name = (TextView) convertView.findViewById(R.id.name);
            tel = (TextView) convertView.findViewById(R.id.telph);
            selectedText = (TextView) convertView.findViewById(R.id.selectedText);
            btnDelete = (TextView) convertView.findViewById(R.id.btnDelete);
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


    public List<PersonBean> getList() {
        return list;
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
