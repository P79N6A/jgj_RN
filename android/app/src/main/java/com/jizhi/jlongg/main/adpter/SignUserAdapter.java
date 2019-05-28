package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.SigninDetailActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.SignListBean;

import java.util.List;


/**
 * 签到列表适配器
 * huchangsheng：Administrator on 2016/2/24 15:42
 */
public class SignUserAdapter extends BaseAdapter {
    private List<SignListBean> list;
    private LayoutInflater inflater;
    private Context context;
    private GroupDiscussionInfo info;
    private int size;

    public SignUserAdapter(Context context, List<SignListBean> list, GroupDiscussionInfo info) {
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
            convertView = inflater.inflate(R.layout.item_message_sign_child_member, null);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_count = (TextView) convertView.findViewById(R.id.tv_count);
            holder.tv_time = (TextView) convertView.findViewById(R.id.tv_time);
            holder.tv_address = (TextView) convertView.findViewById(R.id.tv_address);
            holder.rea_top = (RelativeLayout) convertView.findViewById(R.id.rea_top);
            holder.lin_sign = (RelativeLayout) convertView.findViewById(R.id.lin_sign);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        if (TimesUtils.getTodayDate().trim().equals(bean.getSign_date())) {
            holder.tv_date.setText("今日 " + bean.getSign_date_str());
        } else {
            holder.tv_date.setText(bean.getSign_date_str());
        }
        holder.tv_count.setText(Html.fromHtml("签到<font color=red>" + bean.getSign_date_num() + "</font>次"));
        holder.tv_address.setText(bean.getSign_addr());
        holder.tv_time.setText(bean.getSign_time());
        holder.lin_sign.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SigninDetailActivity.actionStart((Activity) context, bean.getId());
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
        /* 日期 */
        TextView tv_date;
        TextView tv_count;
        TextView tv_time;
        TextView tv_address;
        RelativeLayout rea_top;
        RelativeLayout lin_sign;
    }

}
