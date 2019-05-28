package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.EvaluateTag;

import java.util.List;


/**
 * 功能:评价标签
 * 时间:2018年4月25日16:24:53
 * 作者:xuj
 */
public class EvaluateTagAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<EvaluateTag> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     *
     */
    private Context context;
    /**
     * 标签背景色
     */
    private Drawable tagDrawable;
    /**
     * 是否可编辑
     */
    private boolean isEditor;


    public EvaluateTagAdapter(Context context, List<EvaluateTag> list) {
        super();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public EvaluateTagAdapter(Context context, List<EvaluateTag> list,Drawable tagDrawable) {
        super();
        this.list = list;
        this.context = context;
        this.tagDrawable = tagDrawable;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public EvaluateTag getItem(int position) {
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
            convertView = inflater.inflate(R.layout.evaluate_tag_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final EvaluateTag bean = getItem(position);
        if (bean.getNum() == 0) {
            holder.tagName.setText(bean.getTag_name());
        } else {
            holder.tagName.setText(bean.getTag_name() + " " + bean.getNum());
        }
        if (isEditor) {
            holder.tagName.setTextColor(ContextCompat.getColor(context, bean.is_selected() ? R.color.app_color : R.color.color_999999));
            holder.tagName.setTextSize(14);
            Utils.setBackGround(convertView, context.getResources().getDrawable(bean.is_selected()
                    ? R.drawable.sk_d7252c_bg_white_20radius : R.drawable.sk_gy_999999_20radius));
        } else {
            holder.tagName.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            holder.tagName.setTextSize(11);
            Utils.setBackGround(convertView, tagDrawable == null ? context.getResources().getDrawable(R.drawable.sk_f5a6a6_bg_eb4e4e_20radius) : tagDrawable);
        }
        holder.isSelected.setVisibility(bean.is_selected() ? View.VISIBLE : View.GONE);
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            tagName = (TextView) convertView.findViewById(R.id.tagName);
            isSelected = convertView.findViewById(R.id.isSelected);
        }

        /**
         * 标签名称
         */
        TextView tagName;
        /**
         * 是否已选标签
         */
        View isSelected;
    }

    public void add(EvaluateTag tag) {
        if (list != null) {
            list.add(tag);
            notifyDataSetChanged();
        }
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public List<EvaluateTag> getList() {
        return list;
    }

    public void setList(List<EvaluateTag> list) {
        this.list = list;
    }

    public Drawable getTagDrawable() {
        return tagDrawable;
    }

    public void setTagDrawable(Drawable tagDrawable) {
        this.tagDrawable = tagDrawable;
    }
}
