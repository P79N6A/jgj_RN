package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.activity.StatisticalWorkSecondActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.WorkBaseInfo;
import com.jizhi.jlongg.main.util.Constance;

import java.util.List;


/**
 * 功能:未结工资列表适配器
 * 时间:2018年1月8日15:40:30
 * 作者:xuj
 */
public class UnBalanceAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<WorkBaseInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 上下文
     */
    private Activity activity;


    public UnBalanceAdapter(Activity activity, List<WorkBaseInfo> list) {
        super();
        this.list = list;
        this.activity = activity;
        inflater = LayoutInflater.from(activity);
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public WorkBaseInfo getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.un_balance_item, null, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, final View convertView) {
        final WorkBaseInfo bean = list.get(position);
        holder.name.setText(bean.getUser_info() != null ? bean.getUser_info().getReal_name() : ""); //设置姓名
        holder.amounts.setText(bean.getAmounts()); //设置金额
        holder.goBalanceBtn.setVisibility(View.VISIBLE);
        holder.isSelected.setVisibility(View.GONE);
        holder.goBalanceBtn.setOnClickListener(new View.OnClickListener() {//点击该“去结算”跳转至结算记账页面，默认选择该对象为记账对象；
            @Override
            public void onClick(View v) {
                PersonBean personBean = new PersonBean();
                personBean.setName(bean.getUser_info().getReal_name());
                if (!TextUtils.isEmpty(bean.getUser_info().getUid())) {
                    personBean.setUid(Integer.parseInt(bean.getUser_info().getUid()));
                }
                NewAccountActivity.actionStart(activity, 1, personBean, bean.getAmounts(), true);
            }
        });
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                StatisticalWorkSecondActivity.actionStart(activity,
                        null, null, null, null,
                        bean.getUser_info().getUid(), bean.getUser_info().getReal_name(), null, UclientApplication.getRoler(activity).equals(Constance.ROLETYPE_FM) ?
                                StatisticalWorkSecondActivity.TYPE_FROM_WORKER : StatisticalWorkSecondActivity.TYPE_FROM_FOREMAN, bean.getUser_info().getUid(),
                        "person", false, false, null, false, true);
//                StatisticalWorkByMonthActivity.actionStart(activity, null, null, "person", bean.getUser_info().getReal_name(), bean.getUser_info().getUid(), null, true);
            }
        });
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            name = convertView.findViewById(R.id.name);
            amounts = convertView.findViewById(R.id.amounts);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            isSelected = convertView.findViewById(R.id.isSelected);
            goBalanceBtn = convertView.findViewById(R.id.goBalanceBtn);
        }

        /**
         * 姓名
         */
        TextView name;
        /**
         * 金额
         */
        TextView amounts;
        /**
         * 列表分割线
         */
        View itemDiver;
        /**
         * 单选框
         */
        ImageView isSelected;
        /**
         * 去结算按钮
         */
        Button goBalanceBtn;
    }

    public void updateList(List<WorkBaseInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<WorkBaseInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }


    public List<WorkBaseInfo> getList() {
        return list;
    }

    public void setList(List<WorkBaseInfo> list) {
        this.list = list;
    }


}
