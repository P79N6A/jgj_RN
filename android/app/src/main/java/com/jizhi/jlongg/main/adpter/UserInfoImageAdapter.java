package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.bumptech.glide.Glide;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;

/**
 * 功能:显示九宫格图片
 * 时间:2016年8月25日 18:15:44
 * 作者:xuj
 */
public class UserInfoImageAdapter extends BaseAdapter {

    /* 图片数据源 */
    private List<String> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 是否显示移除图标 */
    private boolean showRemoveIcon;
    private Context context;


    public UserInfoImageAdapter(Context context, List<String> list) {
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public Object getItem(int arg0) {
        return list.get(arg0);
    }

    public long getItemId(int arg0) {
        return arg0;
    }


    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_grid_experience_detail, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.remove.setVisibility(View.GONE);
        new GlideUtils().glideImage(context, NetWorkRequest.CDNURL + "media/simages/m/" + list.get(position), holder.image, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);

//        Glide.with(context).load(NetWorkRequest.CDNURL + "media/simages/m/" + list.get(position)).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(holder.image);


        return convertView;
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            image = (ImageView) view.findViewById(R.id.image);
            remove = (RelativeLayout) view.findViewById(R.id.remove);
        }

        private ImageView image;
        private RelativeLayout remove;
    }

    public List<String> getList() {
        return list;
    }

    public void setList(List<String> list) {
        this.list = list;
    }
}
