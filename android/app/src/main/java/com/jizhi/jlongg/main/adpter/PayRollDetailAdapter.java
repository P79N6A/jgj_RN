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
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PayRollList;

import java.util.List;

/**
 * 功能:工资清单某人详情(1.4.5)
 * 时间:2016年7月22日 10:43:14
 * 作者:xuj
 */
public class PayRollDetailAdapter extends BaseAdapter {

    /**
     * 显示头部
     */
    private final int HEAD = 0;
    /**
     * 显示内容
     */
    private final int CONTENT = 1;

    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 资源对象类
     */
    private Resources res;
    /**
     * 工资清单列表数据
     */
    private List<PayRollList> list;


    @Override
    public int getItemViewType(int position) {
        PayRollList bean = list.get(position);
        if (!TextUtils.isEmpty(bean.getName())) { //如果项目名称为空则返回头
            return HEAD;
        } else {
            return CONTENT;
        }
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    public List<PayRollList> getList() {
        return list;
    }


    public PayRollDetailAdapter(Context context, List<PayRollList> list) {
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
    }


    public void updateList(List<PayRollList> list) {
        this.list = list;
    }


    @Override
    public int getCount() {
        return list.size();
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
        PayRollList bean = list.get(position);
        int state = getItemViewType(position);
        ViewHolder holder = null;
        if (state == HEAD) {
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.account_list_head, parent, false);
                holder = new ViewHolder(convertView, state);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            holder.projectName.setText(bean.getName());
        } else {
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_payroll_detail_value, parent, false);
                holder = new ViewHolder(convertView, state);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
//            bindData(holder, position);
        }
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
    }


    public class ViewHolder {

        public ViewHolder(View view, int state) {
            switch (state) {
                case HEAD:
                    projectName = (TextView) view.findViewById(R.id.projectName);
                    break;
                case CONTENT:
                    date = (TextView) view.findViewById(R.id.currentDate);
                    content = (TextView) view.findViewById(R.id.content);
                    total = (TextView) view.findViewById(R.id.total);
                    break;
            }
        }

        /**
         * 工头、班组长名称
         */
        private TextView projectName;
        /**
         * 日期
         */
        private TextView date;
        /**
         * 内容
         */
        private TextView content;
        /**
         * 金额
         */
        private TextView total;
    }
}
