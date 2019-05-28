package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PayRollPageOne;
import com.jizhi.jlongg.main.util.RecordUtils;

import java.util.List;

/**
 * 功能:工资清单列表(1.4.5)
 * 时间:2016年7月22日 10:43:14
 * 作者:xuj
 */
public class PayRollAdapter extends BaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 资源对象类
     */
    private Context context;
    /**
     * 工资清单列表数据
     */
    private List<PayRollPageOne> list;

    public List<PayRollPageOne> getList() {
        return list;
    }


    public PayRollAdapter(Context context, List<PayRollPageOne> list) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }


    public void updateList(List<PayRollPageOne> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public void addMoreList(List<PayRollPageOne> list) {
        this.list.addAll(list);
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
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.payroll_item, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        PayRollPageOne bean = list.get(position);
        holder.name.setText(bean.getName());
        holder.totalManhour.setText(RecordUtils.getNormalTotalWorkString(bean.getTotal_manhour(), true));
        holder.totalOvertime.setText(RecordUtils.getOverTimeTotalWorkString(bean.getTotal_overtime(), true));
        holder.total.setTextColor(ContextCompat.getColor(context, bean.getTotal() >= 0 ? R.color.app_color : R.color.green)); //总金额如果大于0 则用红色  小于0用绿色
        if (bean.getNew_total() != null) {
            holder.total.setText(bean.getNew_total().getPre_unit() + bean.getNew_total().getTotal() + bean.getNew_total().getUnit());
        }
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            name = (TextView) view.findViewById(R.id.name);
            totalManhour = (TextView) view.findViewById(R.id.totalManhour);
            totalOvertime = (TextView) view.findViewById(R.id.totalOvertime);
            total = (TextView) view.findViewById(R.id.total);
        }


        /**
         * 工头、班组长名称
         */
        private TextView name;
        /**
         * 上班合计
         */
        private TextView totalManhour;
        /**
         * 加班合计
         */
        private TextView totalOvertime;
        /**
         * 工钱(元)
         */
        private TextView total;

    }
}
