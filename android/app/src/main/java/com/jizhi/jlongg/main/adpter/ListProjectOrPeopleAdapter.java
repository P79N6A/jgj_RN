package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BillingListDetail;
import com.jizhi.jlongg.main.util.Constance;

import java.util.List;

/**
 * 记工清单详情adapter
 *
 * @author Xuj
 * @version 1.0.4
 * @time 2016年2月29日 15:25:46
 */
public class ListProjectOrPeopleAdapter extends BaseAdapter {
    private List<BillingListDetail> list;
    private LayoutInflater inflater;
    private Resources res;
    private int filter;


    public void setList(List<BillingListDetail> list) {
        this.list = list;
    }

    public ListProjectOrPeopleAdapter(Context context, List<BillingListDetail> list, int filter) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
        this.filter = filter;
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
            convertView = inflater.inflate(R.layout.item_list_project_or_person_detail, null);
            holder.pname = (TextView) convertView.findViewById(R.id.pname);
            holder.total_poor = (TextView) convertView.findViewById(R.id.total_poor);
            holder.total = (TextView) convertView.findViewById(R.id.total);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        BillingListDetail bean = list.get(position);
        switch (filter) {
            case Constance.TYPE_PROJECT://列表点击项目
                holder.pname.setText(bean.getName());
                break;
            case Constance.TYPE_PERSON://列表点击人物
                holder.pname.setText(bean.getPname());
                break;
        }
        holder.total_poor.setText(bean.getT_poor() + "笔");
        holder.total.setText("¥" + bean.getT_total());
        if (Float.parseFloat(bean.getT_total()) > 0) {
            holder.total.setTextColor(res.getColor(R.color.red_f75a23));
        } else {
            holder.total.setTextColor(res.getColor(R.color.green_7ec568));
        }
        return convertView;
    }

    class ViewHolder {
        /**
         * 名称
         */
        TextView pname;
        /**
         * 差账个数
         */
        TextView total_poor;
        /**
         * 金额
         */
        TextView total;

    }


}
