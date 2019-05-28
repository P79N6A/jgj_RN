package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.EvaluateDetailInfo;
import com.jizhi.jlongg.main.bean.EvaluateTag;
import com.jizhi.jongg.widget.FlowTagView;

import java.util.List;


/**
 * 功能:评价详情信息
 * 时间:2018年5月3日14:38:28
 * 作者:xuj
 */
public class EvaluateDetailAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<EvaluateDetailInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;

    private Context context;


    public EvaluateDetailAdapter(Context context, List<EvaluateDetailInfo> list) {
        super();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public EvaluateDetailInfo getItem(int position) {
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
            convertView = inflater.inflate(R.layout.evaluate_detail_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final EvaluateDetailInfo bean = getItem(position);
        holder.newEvaluationIcon.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
        holder.evaluateContent.setText(bean.getContent());
        holder.evaluateTime.setText(bean.getPub_date());
        holder.userNameText.setText(bean.getUser_info().getReal_name());
        List<EvaluateTag> tagList = bean.getTag_list();

        if (tagList == null || tagList.size() == 0) {
            holder.tagView.setVisibility(View.GONE);
        } else {
            holder.tagView.setVisibility(View.VISIBLE);
            holder.tagView.setAdapter(new EvaluateTagAdapter(context, tagList, context.getResources().getDrawable(R.drawable.sk_f8cb82_bg_fef0d9_20radius)));
        }
    }

    public List<EvaluateDetailInfo> getList() {
        return list;
    }

    public void setList(List<EvaluateDetailInfo> list) {
        this.list = list;
    }

    public void updateList(List<EvaluateDetailInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addList(List<EvaluateDetailInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            newEvaluationIcon = convertView.findViewById(R.id.newEvaluationIcon);
            userNameText = (TextView) convertView.findViewById(R.id.userNameText);
            evaluateTime = (TextView) convertView.findViewById(R.id.evaluateTime);
            evaluateContent = (TextView) convertView.findViewById(R.id.evaluateContent);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            tagView = (FlowTagView) convertView.findViewById(R.id.tagView);
        }


        /**
         * 最新的一条评价
         */
        View newEvaluationIcon;
        /**
         * 评价人名称
         */
        TextView userNameText;
        /**
         * 评价时间
         */
        TextView evaluateTime;
        /**
         * 评价内容
         */
        TextView evaluateContent;
        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 标签view
         */
        FlowTagView tagView;
    }
}
