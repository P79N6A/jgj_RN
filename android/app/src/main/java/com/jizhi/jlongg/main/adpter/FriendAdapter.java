package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.FriendBean;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 好友列表
 *
 * @author Xuj
 * @version 1.0
 * @time 2016年2月19日 10:25:26
 */
public class FriendAdapter extends BaseAdapter {
    private List<FriendBean> list;
    private LayoutInflater inflater;
    private Context context;
    private Resources res;

    public FriendAdapter(Context context, List<FriendBean> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
    }


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<FriendBean> list) {
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
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_friend, null);
            holder.catalog = (TextView) convertView.findViewById(R.id.catalog);
            holder.first_name = (TextView) convertView.findViewById(R.id.first_name);
            holder.head_pic = (ImageView) convertView.findViewById(R.id.head_pic);
            holder.name = (TextView) convertView.findViewById(R.id.name);
            holder.tel = (TextView) convertView.findViewById(R.id.telph);
            holder.gray_background = convertView.findViewById(R.id.gray_background);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        FriendBean bean = list.get(position);
        if (!TextUtils.isEmpty(bean.getHead_pic())) { //如果头像不为null
            holder.first_name.setVisibility(View.GONE);
            holder.head_pic.setVisibility(View.VISIBLE);
            ImageLoader.getInstance().displayImage(NetWorkRequest.NETURL + bean.getHead_pic(), holder.head_pic, UtilImageLoader.getFriend());
        } else {
            holder.first_name.setVisibility(View.VISIBLE);
            holder.head_pic.setVisibility(View.GONE);
            int value = position % 5;
            switch (value) {
                case 0:
                    Utils.setBackGround(holder.first_name, res.getDrawable(R.drawable.yw_dark_circle));
                    break;
                case 1:
                    Utils.setBackGround(holder.first_name, res.getDrawable(R.drawable.og_circle));
                    break;
                case 2:
                    Utils.setBackGround(holder.first_name, res.getDrawable(R.drawable.blue_circle_shape));
                    break;
                case 3:
                    Utils.setBackGround(holder.first_name, res.getDrawable(R.drawable.purple_background));
                    break;
                case 4:
                    Utils.setBackGround(holder.first_name, res.getDrawable(R.drawable.red_light_rect));
                    break;
            }
            String first_name = bean.getFriendname().substring(bean.getFriendname().length() - 1);
            holder.first_name.setText(first_name);
        }
        holder.name.setText(bean.getFriendname());
        holder.tel.setText(bean.getTelph());
        int section = getSectionForPosition(position);
        // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
        if (position == getPositionForSection(section)) {
            holder.catalog.setVisibility(View.VISIBLE);
            holder.catalog.setText(bean.getSortLetters());
            holder.gray_background.setVisibility(View.GONE);
        } else {
            holder.catalog.setVisibility(View.GONE);
            holder.gray_background.setVisibility(View.VISIBLE);
        }
        return convertView;
    }

    class ViewHolder {

        View gray_background;
        /**
         * 首字母背景色
         */
        ImageView head_pic;
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
        /**
         * 首字母
         */
        TextView catalog;

        /**
         * 是否勾选
         */
        ImageView image;
    }


    /**
     * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
     */
    @SuppressWarnings("unused")
    public int getPositionForSection(int section) {
        for (int i = 0; i < getCount(); i++) {
            String sortStr = list.get(i).getSortLetters();
            if (null != sortStr) {
                char firstChar = sortStr.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }
        }
        return -1;
    }

    /**
     * 根据ListView的当前位置获取分类的首字母的Char ascii值
     */
    public int getSectionForPosition(int position) {
        if (null == list.get(position).getSortLetters()) {
            return 1;
        }
        return list.get(position).getSortLetters().charAt(0);
    }


}
