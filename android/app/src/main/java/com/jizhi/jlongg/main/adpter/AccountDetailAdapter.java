package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.text.Html;
import android.text.TextPaint;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountBean;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AccountDetailAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<AccountBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;

    private Context context;
    //记账类型，角色
    private String account_type;


    public AccountDetailAdapter(Context context, List<AccountBean> list, String account_type) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
        this.context = context;
        this.account_type = account_type;
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
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_account_detail, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final AccountBean bean = list.get(position);
        holder.rea_content.setVisibility(View.VISIBLE);
        holder.tv_name.setText(bean.getLeft_text());

        if (bean.getItem_type().equals(AccountBean.WORK_TIME) || bean.getItem_type().equals(AccountBean.OVER_TIME)) {
            if (!TextUtils.isEmpty(bean.getRight_value())) {
                if (bean.getCompany().equals("休息") || bean.getCompany().equals("无加班")) {
                    holder.tv_content.setText(bean.getCompany());
                } else {
                    holder.tv_content.setText(Html.fromHtml(bean.getRight_value() + bean.getCompany() + "<font color='#999999'>(" + bean.getWorking_hours() + "个工)</font>"));
//                    if (bean.getOneWork() == 1) {
//                        holder.tv_content.setText(Html.fromHtml(bean.getRight_value() + bean.getCompany() + "<font color='#999999'>(1个工)</font>"));
//                    } else if (bean.getOneWork() == 2) {
//                        holder.tv_content.setText(Html.fromHtml(bean.getRight_value() + bean.getCompany() + "<font color='#999999'>(半个工)</font>"));
//                    } else {
//                    }
                }
            }
        } else {
            TextPaint paint = holder.tv_content.getPaint();
            if (bean.getItem_type().equals(AccountBean.WAGE_INCOME_MONEY) || bean.getItem_type().equals(AccountBean.WAGE_SUBSIDY)
                        || bean.getItem_type().equals(AccountBean.WAGE_REWARD) || bean.getItem_type().equals(AccountBean.WAGE_FINE)
                        || bean.getItem_type().equals(AccountBean.WAGE_DEL) || bean.getItem_type().equals(AccountBean.UNIT_PRICE)) {
                paint.setFakeBoldText(true);
            } else {
                paint.setFakeBoldText(false);
            }
            holder.tv_content.setText(bean.getRight_value());
        }
//        AccountBean item1 = new AccountBean(role_type.equals(Constance.ROLETYPE_FM) ? "本次实付金额:" : "本次实收金额", "", AccountBean.WAGE_INCOME_MONEY);
//        AccountBean item2 = new AccountBean("补贴金额:", "", AccountBean.WAGE_SUBSIDY);
//        AccountBean item3 = new AccountBean("奖励金额:", "", AccountBean.WAGE_REWARD);
//        AccountBean item4 = new AccountBean("罚款金额:", "", AccountBean.WAGE_FINE);
//        AccountBean item5 = new AccountBean("抹零金额:", "", AccountBean.WAGE_DEL);

    }

    public List<AccountBean> getList() {
        return list;
    }

    public void setList(List<AccountBean> list) {
        this.list = list;
    }

    public void updateList(List<AccountBean> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            rea_content = (RelativeLayout) convertView.findViewById(R.id.rea_content);
        }

        /* 名称*/
        TextView tv_name;
        /* 内容 */
        TextView tv_content;

        RelativeLayout rea_content;
    }
}
