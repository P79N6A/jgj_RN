package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 好友列表
 *
 * @author Xuj
 * @version 1.0
 * @time 2016年2月19日 10:25:26
 */
public class ReadInfoAdapter extends BaseAdapter {
    private List<UserInfo> list;
    private Context context;

    public ReadInfoAdapter(Context context, List<UserInfo> list) {
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


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final UserInfo bean = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(context).inflate(R.layout.item_read_list, null);
            holder.first_name = convertView.findViewById(R.id.first_name);
            holder.head_pic = convertView.findViewById(R.id.head_pic);
            holder.name = convertView.findViewById(R.id.name);
            holder.tel = convertView.findViewById(R.id.telph);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        if (!TextUtils.isEmpty(bean.getHead_pic())) { //如果头像不为null
            holder.first_name.setVisibility(View.GONE);
            holder.head_pic.setVisibility(View.VISIBLE);
            holder.head_pic.setView(bean.getHead_pic(), bean.getReal_name(), position);
        } else {
            holder.first_name.setVisibility(View.VISIBLE);
            holder.head_pic.setVisibility(View.GONE);
            int value = position % 5;
            switch (value) {
                case 0:
                    Utils.setBackGround(holder.first_name, context.getResources().getDrawable(R.drawable.yw_dark_circle));
                    break;
                case 1:
                    Utils.setBackGround(holder.first_name, context.getResources().getDrawable(R.drawable.og_circle));
                    break;
                case 2:
                    Utils.setBackGround(holder.first_name, context.getResources().getDrawable(R.drawable.blue_circle_shape));
                    break;
                case 3:
                    Utils.setBackGround(holder.first_name, context.getResources().getDrawable(R.drawable.purple_background));
                    break;
                case 4:
                    Utils.setBackGround(holder.first_name, context.getResources().getDrawable(R.drawable.red_light_rect));
                    break;
            }
            String first_name = bean.getReal_name().substring(bean.getReal_name().length() - 1);
            holder.first_name.setText(first_name);
        }
        holder.name.setText(bean.getReal_name());
        holder.tel.setText(bean.getTelephone());
        holder.tel.setVisibility(View.GONE);
        holder.head_pic.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ChatUserInfoActivity.actionStart((Activity) context, bean.getUid());
            }
        });
        return convertView;
    }

    class ViewHolder {

        /**
         * 首字母背景色
         */
        RoundeImageHashCodeTextLayout head_pic;
        /**
         * 首字母
         */
        TextView first_name;
        /**
         * 名称
         */
        TextView name;
        /**
         * 电话号码
         */
        TextView tel;
    }

}
