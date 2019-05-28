package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.baidu.mapapi.search.core.PoiInfo;
import com.jizhi.jlongg.R;

import java.util.List;

/**
 * 搜索地址adapter
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-16 上午9:52:18
 */
public class SignNearByInfoAdapter extends BaseAdapter {

    /**
     * 搜索地址列表数据
     */
    private List<PoiInfo> list;
    private LayoutInflater inflater;
    private int positionSelect = 0;

    public SignNearByInfoAdapter(Context context, List<PoiInfo> poiInfos, int positionSelect) {
        this.list = poiInfos;
        inflater = LayoutInflater.from(context);
        this.positionSelect = positionSelect;
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
        PoiInfo poiInfo = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_nearby, null);
            holder.addressName = (TextView) convertView.findViewById(R.id.tv_nearbyName);
            holder.addressDetail = (TextView) convertView.findViewById(R.id.tv_nearbyAddr);
            holder.img_icon = (ImageView) convertView.findViewById(R.id.img_icon);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.addressName.setText(poiInfo.name);
        holder.addressDetail.setText(poiInfo.address);
        holder.img_icon.setBackgroundResource(R.drawable.icon_hook_red);
        if (positionSelect == position) {
            holder.img_icon.setVisibility(View.VISIBLE);
        } else {
            holder.img_icon.setVisibility(View.GONE);
        }
        return convertView;
    }

    class ViewHolder {

        TextView addressName;
        TextView addressDetail;
        ImageView img_icon;
    }

    public void updateList(List<PoiInfo> poiInfos) {
        this.list = poiInfos;
        notifyDataSetChanged();
    }

    public List<PoiInfo> getList() {
        return list;
    }

    public void setList(List<PoiInfo> list) {
        this.list = list;
    }
}