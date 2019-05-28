package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.FriendBean;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能:好友列表
 * 时间:2016-4-14 10:40
 * 作者:xuj
 */
public class FriendListAdapter extends BaseAdapter {
    private Context context;
    private LayoutInflater inflater;
    private List<FriendBean> list;

    public FriendListAdapter(Context context, List<FriendBean> list) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.list = list;
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
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.know_friend_item, null);
            holder.head_pic = (ImageView) convertView.findViewById(R.id.headpic);
            holder.friendName = (TextView) convertView.findViewById(R.id.friendName);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        FriendBean bean = list.get(position);
        ImageLoader.getInstance().displayImage(NetWorkRequest.NETURL + bean.getHead_pic(), holder.head_pic, UtilImageLoader.getForeman());
        holder.friendName.setText(bean.getFriendname());
        return convertView;
    }

    class ViewHolder {

        /**
         * 头像
         */
        ImageView head_pic;
        /**
         * 好友名称
         */
        TextView friendName;
    }
}
