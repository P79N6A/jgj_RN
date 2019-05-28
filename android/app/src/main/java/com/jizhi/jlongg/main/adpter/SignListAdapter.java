package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.SignListBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.message.UserSignListActivity;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 签到列表适配器
 */
public class SignListAdapter extends BaseAdapter {
    private List<SignListBean> list;
    private LayoutInflater inflater;
    private Context context;
    private GroupDiscussionInfo info;


    public SignListAdapter(Context context, List<SignListBean> list, GroupDiscussionInfo info) {
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
        final SignListBean bean = list.get(position);
        if (convertView == null) {
            holder = new Holder();
            convertView = inflater.inflate(R.layout.item_message_sign_child_creator, null);
            holder.tv_date = convertView.findViewById(R.id.tv_date);
            holder.tv_count = convertView.findViewById(R.id.tv_count);
            holder.img_head = convertView.findViewById(R.id.img_head);
            holder.tv_name = convertView.findViewById(R.id.tv_name);
            holder.tv_time = convertView.findViewById(R.id.tv_time);
            holder.tv_address = convertView.findViewById(R.id.tv_address);
            holder.lin_sign = convertView.findViewById(R.id.lin_sign);
            holder.rea_top = convertView.findViewById(R.id.rea_top);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        if (TimesUtils.getTodayDate().trim().equals(bean.getSign_date())) {
            holder.tv_date.setText("今日 " + bean.getSign_date_str());
        } else {
            holder.tv_date.setText(bean.getSign_date_str());
        }

        holder.tv_count.setText(Html.fromHtml("<font color=red>" + bean.getSign_date_num() + "</font>人已签到"));
        holder.tv_name.setText(bean.getSign_user_info().getUid().equals(UclientApplication.getUid()) ? "我" : bean.getSign_user_info().getReal_name());
        holder.img_head.setView(bean.getSign_user_info().getHead_pic(), bean.getSign_user_info().getReal_name(), 0);
        holder.tv_address.setText(bean.getSign_addr());
        holder.tv_time.setText(bean.getSign_time());
        holder.lin_sign.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                UserSignListActivity.actionStart((Activity) context, info, bean.getSign_user_info());
            }
        });
        if (position != 0) {
            if (bean.getSign_date().equals(list.get(position - 1).getSign_date())) {
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
        RoundeImageHashCodeTextLayout img_head;
        TextView tv_date;
        TextView tv_count;
        TextView tv_name;
        TextView tv_time;
        TextView tv_address;
        LinearLayout lin_sign;
        RelativeLayout rea_top;
    }

}
