package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.OtherCityBean;

import java.util.List;

/**
 * 功能: 其他城市工种
 * 时间:2016-4-23 12:30
 * 作者: xuj
 */
public class ChooseOtherCityDataAdapter extends BaseAdapter {
    private Context context;
    private List<OtherCityBean> list;
    private LayoutInflater inflater;

    private boolean isJob;

    public ChooseOtherCityDataAdapter(Context context, List<OtherCityBean> list,boolean isJob) {
        this.context = context;
        this.list = list;
        this.inflater = LayoutInflater.from(context);
        this.isJob = isJob;
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
        chooseOtherCityDataHolder holder;
        OtherCityBean bean = list.get(position);
        if (convertView == null) {
            holder = new chooseOtherCityDataHolder();
            convertView = inflater.inflate(R.layout.choose_othercity_data_item, null);
            holder.shortname = (TextView) convertView.findViewById(R.id.shortname);
            holder.pronum = (TextView) convertView.findViewById(R.id.pronum);
            convertView.setTag(holder);
        } else {
            holder = (chooseOtherCityDataHolder) convertView.getTag();
        }
        if(isJob){
            holder.pronum.setText(bean.getPronum() + "个工作");
        }else{
            holder.pronum.setText(bean.getWorkernum() + "个帮手");
        }
        StringBuffer sb = new StringBuffer();
        String[] data = bean.getShortname();
        for (int i = 0; i < data.length; i++) {
            if (i == 0) {
                sb.append(data[i]);
            } else {
                sb.append(" - " + data[i]);
            }
        }
        holder.shortname.setText(sb.toString());
        return convertView;
    }

    public class chooseOtherCityDataHolder {
        TextView shortname;
        TextView pronum;
    }

}
