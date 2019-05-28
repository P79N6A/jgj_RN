package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.NoticeListBean;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.HorizotalImageLayout;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 通知列表适配器
 */
public class NoticeListAdapter extends BaseAdapter {
    private List<NoticeListBean> list;
    private LayoutInflater inflater;
    private Context context;
    private GroupDiscussionInfo info;


    public NoticeListAdapter(Context context, List<NoticeListBean> list, GroupDiscussionInfo info) {
        this.context = context;
        this.list = list;
        this.info = info;
        inflater = LayoutInflater.from(context);
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
    public View getView(int position, View convertView, ViewGroup parent) {
        final Holder holder;
        final NoticeListBean bean = list.get(position);
        if (convertView == null) {
            holder = new Holder();
            convertView = inflater.inflate(R.layout.item_list_notice, null);
            holder.rea_top = convertView.findViewById(R.id.rea_top);
            holder.img_head = convertView.findViewById(R.id.img_head);
            holder.tv_name = convertView.findViewById(R.id.tv_name);
            holder.tv_date = convertView.findViewById(R.id.tv_date);
            holder.tv_date_top = convertView.findViewById(R.id.tv_date_top);
            holder.tv_content = convertView.findViewById(R.id.tv_content);
            holder.ngl_images = convertView.findViewById(R.id.ngl_images);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        holder.img_head.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), 0);
        holder.tv_name.setText(NameUtil.setName(bean.getUser_info().getReal_name()));
        holder.tv_date.setText(bean.getSend_time());
        if (TimesUtils.getTodayDate().trim().equals(bean.getSend_date())) {
            holder.tv_date_top.setText("今日 " + bean.getSend_date_str());
        } else {
            holder.tv_date_top.setText(bean.getSend_date_str());
        }
        if (!TextUtils.isEmpty(bean.getMsg_text())) {
            holder.tv_content.setVisibility(View.VISIBLE);
            holder.tv_content.setText(bean.getMsg_text());
        } else {
            holder.tv_content.setVisibility(View.GONE);
        }
        if (bean.getMsg_src().size() == 0) {
            holder.ngl_images.setVisibility(View.GONE);
            holder.tv_content.setMaxLines(2);
        } else {
            holder.tv_content.setMaxLines(2);
            holder.ngl_images.setVisibility(View.VISIBLE);
            holder.ngl_images.createImages(bean.getMsg_src(), DensityUtils.dp2px(context, 20));

        }
        if (position != 0) {
            if (bean.getSend_date().equals(list.get(position - 1).getSend_date())) {
                holder.rea_top.setVisibility(View.GONE);
            } else {
                holder.rea_top.setVisibility(View.VISIBLE);
            }
        } else {
            holder.rea_top.setVisibility(View.VISIBLE);
        }
        return convertView;
    }


    class Holder {
        RelativeLayout rea_top;
        TextView tv_date_top;
        RoundeImageHashCodeTextLayout img_head;
        TextView tv_name;
        TextView tv_date;
        TextView tv_content;
        HorizotalImageLayout ngl_images;

    }

}
