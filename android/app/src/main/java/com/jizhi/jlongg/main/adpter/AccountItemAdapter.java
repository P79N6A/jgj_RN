package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.RecordItem;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AccountItemAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<RecordItem> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;

    public AccountItemAdapter(Context context, List<RecordItem> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
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
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.little_work_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, int position, View convertView) {
        final RecordItem bean = list.get(position);
        holder.text.setText(bean.getText());
        holder.value.setText(bean.getValue());
        holder.value.setHint(bean.getHintValue());
        if (bean.isShowLine()) {
            holder.line.setVisibility(View.VISIBLE);
            holder.background.setVisibility(View.GONE);
        } else {
            holder.line.setVisibility(View.GONE);
            holder.background.setVisibility(View.VISIBLE);
        }
        holder.value.setTextColor(bean.getValueColor() != 0 ? bean.getValueColor() : res.getColor(R.color.color_333333)); //如果没有设置颜色则默认为333333
        holder.guideImage.setVisibility(bean.isClick() ? View.VISIBLE : View.INVISIBLE);
        Utils.setBackGround(convertView, bean.isClick() ? res.getDrawable(R.drawable.listview_selector_white_gray)
                : res.getDrawable(R.color.white));
    }

    public List<RecordItem> getList() {
        return list;
    }

    public void setList(List<RecordItem> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            line = convertView.findViewById(R.id.itemDiver);
            background = convertView.findViewById(R.id.background);
            text = (TextView) convertView.findViewById(R.id.text);
            value = (TextView) convertView.findViewById(R.id.value);
            guideImage = (ImageView) convertView.findViewById(R.id.guideImage);
        }

        /* 线、背景 */
        View line, background;
        /* 用户名称*/
        TextView text;
        /* 时间 */
        TextView value;
        /* 评论内容 */
        ImageView guideImage;
    }
}
