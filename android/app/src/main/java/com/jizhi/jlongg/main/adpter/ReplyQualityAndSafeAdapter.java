package com.jizhi.jlongg.main.adpter;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能: 选择质量，安全地址adapter
 * 作者：胡常生
 * 时间: 2017年5月27日 11:10:12
 */
public class ReplyQualityAndSafeAdapter extends BaseAdapter {


    /* 添加工人列表数据 */
    private List<ReplyInfo> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 上下文 */
    private BaseActivity context;


    public ReplyQualityAndSafeAdapter(BaseActivity context, List<ReplyInfo> list) {
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
    public void updateListView(List<ReplyInfo> list) {
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


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_reply_msg_quality_and_safe, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position) {
        ReplyInfo bean = list.get(position);
        holder.tv_name.setText(bean.getUser_info().getReal_name());
        if (!TextUtils.isEmpty(bean.getReply_status_text()) && !TextUtils.isEmpty(bean.getReply_text())) {
            holder.tv_content.setText(bean.getReply_status_text() + bean.getReply_text());
        } else if (!TextUtils.isEmpty(bean.getReply_status_text())) {
            holder.tv_content.setText(bean.getReply_status_text());
        } else if (!TextUtils.isEmpty(bean.getReply_text())) {
            holder.tv_content.setText(bean.getReply_text());
        }

        holder.tv_date.setText(bean.getCreate_time());
        holder.img_head.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), position);
        if (null != bean.getMsg_src() && bean.getMsg_src().size() > 0) {
            holder.img_contect.setView(bean.getMsg_src().get(0), bean.getUser_info().getReal_name(), 0);
            holder.img_contect.setVisibility(View.VISIBLE);
        } else {
            holder.img_contect.setVisibility(View.GONE);
        }

        if (position == list.size() - 1) {
            holder.background.setVisibility(View.GONE);
        } else {
            holder.background.setVisibility(View.VISIBLE);
        }
    }


    class ViewHolder {
        /* 人物名称 */
        TextView tv_name;
        /* 回复内容 */
        TextView tv_content;
        /* 回复日期 */
        TextView tv_date;
        /* 回复日期 */
        RoundeImageHashCodeTextLayout img_head;
        /* 图片内容 */
        RoundeImageHashCodeTextLayout img_contect;
        View background;

        public ViewHolder(View convertView) {
            tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            img_contect = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_contect);
            background = convertView.findViewById(R.id.background);

        }
    }
}
