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
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.QualitySafeLocation;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能: 选择质量，安全地址adapter
 * 作者：胡常生
 * 时间: 2017年5月27日 11:10:12
 */
public class SelectReleaseAdapter extends BaseAdapter {


    /* 添加工人列表数据 */
    private List<QualitySafeLocation> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 是否是删除列表 */
    private Boolean isShowDel;
    /* 上下文 */
    private BaseActivity context;
    /* 过滤文本 */
    private String filterValue;


    public SelectReleaseAdapter(BaseActivity context, List<QualitySafeLocation> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.context = context;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<QualitySafeLocation> list) {
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
            convertView = inflater.inflate(R.layout.item_select_release_address, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position) {
        QualitySafeLocation bean = list.get(position);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(bean.getText())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getText());
                Matcher nameMatch = p.matcher(bean.getText());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.name.setText(builder);
            }
        } else {
            holder.name.setText(bean.getText());
        }
        if (position == list.size() - 1) {
            holder.background.setVisibility(View.GONE);
        } else {
            holder.background.setVisibility(View.VISIBLE);
        }
    }


    class ViewHolder {
        /* 人物名称 */
        TextView name;
        View background;

        public ViewHolder(View convertView) {
            name = (TextView) convertView.findViewById(R.id.name);
            background = (View) convertView.findViewById(R.id.background);
        }
    }

    public List<QualitySafeLocation> getList() {
        return list;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
