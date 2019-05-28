package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountModifyBean;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;

import java.util.List;

public class ViewHolderAccountModifyBorrow extends AccountModefyRecycleViewHolder {
    //左右记账类型
    private TextView tv_modify_type_left, tv_modify_type_right;

    public ViewHolderAccountModifyBorrow(View itemView, Activity activity, AccountModifyAdapter.ItemClickInterFace itemClickInterFace) {
        super(itemView);
        this.activity = activity;
        this.itemClickInterFace = itemClickInterFace;
        initAlickItemView();
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<AccountModifyBean> list) {
        this.position = position;
        setItemAlickData(list.get(position));
        setItemData(list.get(position));
        setShowCenterDate(position, list);
    }

    /**
     * 获取itemView
     */
    public void initItemView() {
        //左右记账类型
        tv_modify_type_left = (TextView) itemView.findViewById(R.id.tv_modify_type_left);
        tv_modify_type_right = (TextView) itemView.findViewById(R.id.tv_modify_type_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(AccountModifyBean bean) {
        if (UclientApplication.getUid(UclientApplication.getInstance()).equals(bean.getUser_info().getUid())) {
            //修改时间
            ((TextView) itemView.findViewById(R.id.tv_change_account_right)).setText(bean.getCreate_time());
            //记账时间
            ((TextView) itemView.findViewById(R.id.tv_modify_date_right)).setText(bean.getRecord_time() + "(" + bean.getNl_date() + ")");
            //工人名字
            ((TextView) itemView.findViewById(R.id.tv_name_right)).setText(NameUtil.setName(bean.getRecord_info().getWorker_name()));
            //班组长名字
            ((TextView) itemView.findViewById(R.id.tv_role_name_right)).setText("班组长：" + NameUtil.setName(bean.getRecord_info().getForeman_name()));
            //项目名字
            ((TextView) itemView.findViewById(R.id.tv_proname_right)).setText(NameUtil.setRemark(bean.getRecord_info().getProname(),4));
            //金额
            ((TextView) itemView.findViewById(R.id.tv_amounts_right)).setText(bean.getRecord_info().getAmounts());
            //记账类型
            ((TextView) itemView.findViewById(R.id.tv_type_right)).setText(AccountUtil.getAccountText(String.valueOf(bean.getRecord_info().getAccounts_type())));
            //2修改3删除
            if (bean.getRecord_type() == 2) {
                //2修改
                tv_modify_type_right.setText("修改了记账-" + AccountUtil.getAccountText(String.valueOf(bean.getRecord_info().getAccounts_type())));
                tv_modify_type_right.setTextColor(ContextCompat.getColor(activity, R.color.color_27b441));
                ((TextView) itemView.findViewById(R.id.tv_change_account_right)).setTextColor(ContextCompat.getColor(activity, R.color.color_27b441));
                itemView.findViewById(R.id.tv_del_text_right).setVisibility(View.GONE);
                itemView.findViewById(R.id.img_arrow_right).setVisibility(View.VISIBLE);
            } else {
                //3删除
                tv_modify_type_right.setText("删除了记账-" + AccountUtil.getAccountText(String.valueOf(bean.getRecord_info().getAccounts_type())));
                tv_modify_type_right.setTextColor(ContextCompat.getColor(activity, R.color.color_eb4e4e));
                ((TextView) itemView.findViewById(R.id.tv_change_account_right)).setTextColor(ContextCompat.getColor(activity, R.color.color_eb4e4e));
                //金额
                itemView.findViewById(R.id.tv_del_text_right).setVisibility(View.VISIBLE);
                itemView.findViewById(R.id.img_arrow_right).setVisibility(View.GONE);
                ((TextView) itemView.findViewById(R.id.tv_del_text_right)).setText(bean.getLast_operate_msg());
            }
        } else {
            //修改时间
            ((TextView) itemView.findViewById(R.id.tv_change_account_left)).setText(bean.getCreate_time());
            //记账时间
            ((TextView) itemView.findViewById(R.id.tv_modify_date_left)).setText(bean.getRecord_time() + "(" + bean.getNl_date() + ")");
            //工人名字
            ((TextView) itemView.findViewById(R.id.tv_name_left)).setText(NameUtil.setName(bean.getRecord_info().getWorker_name()));
            //班组长名字
            ((TextView) itemView.findViewById(R.id.tv_role_name_left)).setText("班组长：" + NameUtil.setName(bean.getRecord_info().getForeman_name()));
            //项目名字
            ((TextView) itemView.findViewById(R.id.tv_proname_left)).setText(NameUtil.setRemark(bean.getRecord_info().getProname(),4));
            //金额
            ((TextView) itemView.findViewById(R.id.tv_amounts_left)).setText(bean.getRecord_info().getAmounts());
            //记账类型
            ((TextView) itemView.findViewById(R.id.tv_type_left)).setText(AccountUtil.getAccountText(String.valueOf(bean.getRecord_info().getAccounts_type())));
            //2修改3删除
            if (bean.getRecord_type() == 2) {
                //2修改
                tv_modify_type_left.setText("修改了记账-" + AccountUtil.getAccountText(String.valueOf(bean.getRecord_info().getAccounts_type())));
                tv_modify_type_left.setTextColor(ContextCompat.getColor(activity, R.color.color_27b441));
                ((TextView) itemView.findViewById(R.id.tv_change_account_left)).setTextColor(ContextCompat.getColor(activity, R.color.color_27b441));
                itemView.findViewById(R.id.tv_del_text_left).setVisibility(View.GONE);
                itemView.findViewById(R.id.img_arrow_left).setVisibility(View.VISIBLE);
            } else {
                //3删除
                tv_modify_type_left.setText("删除了记账-" + AccountUtil.getAccountText(String.valueOf(bean.getRecord_info().getAccounts_type())));
                tv_modify_type_left.setTextColor(ContextCompat.getColor(activity, R.color.color_eb4e4e));
                ((TextView) itemView.findViewById(R.id.tv_change_account_left)).setTextColor(ContextCompat.getColor(activity, R.color.color_eb4e4e));
                //金额
                itemView.findViewById(R.id.tv_del_text_left).setVisibility(View.VISIBLE);
                itemView.findViewById(R.id.img_arrow_left).setVisibility(View.GONE);
                ((TextView) itemView.findViewById(R.id.tv_del_text_left)).setText(bean.getLast_operate_msg());
            }
        }
    }


}

