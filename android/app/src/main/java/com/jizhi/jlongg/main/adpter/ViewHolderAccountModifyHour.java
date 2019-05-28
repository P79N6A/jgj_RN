package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountModifyBean;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;

import java.util.List;

public class ViewHolderAccountModifyHour extends AccountModefyRecycleViewHolder {
    private Activity activity;
    //左右记账类型
    private TextView tv_modify_type_left, tv_modify_type_right;
    //左右点工包工图标
    private ImageView img_type_left, img_type_right;

    public ViewHolderAccountModifyHour(View itemView, Activity activity,AccountModifyAdapter.ItemClickInterFace itemClickInterFace) {
        super(itemView);
        this.activity = activity;
        this.itemClickInterFace=itemClickInterFace;
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
        //左右点工包工图标
        img_type_left = (ImageView) itemView.findViewById(R.id.img_type_left);
        img_type_right = (ImageView) itemView.findViewById(R.id.img_type_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(AccountModifyBean bean) {
        LUtils.e("-------getRecord_id--------" + bean.getRecord_id());
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

            //上班加班时间
            if (String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.HOUR_WORKER) || String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.CONSTRACTOR_CHECK)) {
                ((TextView) itemView.findViewById(R.id.tv_worktime_right)).setText(AccountUtil.getAccountShowTypeString(activity, true, false, true, Float.parseFloat(bean.getRecord_info().getManhour()), bean.getRecord_info().getWorking_hours()));
                ((TextView) itemView.findViewById(R.id.tv_overtime_right)).setText(AccountUtil.getAccountShowTypeString(activity, true, false, false, Float.parseFloat(bean.getRecord_info().getOvertime()), bean.getRecord_info().getOvertime_hours()));
            }
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
                ((TextView) itemView.findViewById(R.id.tv_del_text_right)).setText(bean.getLast_operate_msg());
                itemView.findViewById(R.id.img_arrow_right).setVisibility(View.GONE);
            }
            //图标
            if (String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.HOUR_WORKER)) {
                img_type_right.setVisibility(View.VISIBLE);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    img_type_right.setBackground(ContextCompat.getDrawable(activity, R.drawable.hour_worker_flag));
                } else {
                    img_type_right.setBackgroundResource(R.drawable.hour_worker_flag);
                }
            } else if (String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.CONSTRACTOR_CHECK)) {
                img_type_right.setVisibility(View.VISIBLE);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    img_type_right.setBackground(ContextCompat.getDrawable(activity, R.drawable.constar_flag));
                } else {
                    img_type_right.setBackgroundResource(R.drawable.constar_flag);
                }
            } else {
                img_type_right.setVisibility(View.GONE);
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

            //上班加班时间
            if (String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.HOUR_WORKER) || String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.CONSTRACTOR_CHECK)) {
                ((TextView) itemView.findViewById(R.id.tv_worktime_left)).setText(AccountUtil.getAccountShowTypeString(activity, true, false, true, Float.parseFloat(bean.getRecord_info().getManhour()), bean.getRecord_info().getWorking_hours()));
                ((TextView) itemView.findViewById(R.id.tv_overtime_left)).setText(AccountUtil.getAccountShowTypeString(activity, true, false, false, Float.parseFloat(bean.getRecord_info().getOvertime()), bean.getRecord_info().getOvertime_hours()));
            }
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
            //图标
            if (String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.HOUR_WORKER)) {
                img_type_left.setVisibility(View.VISIBLE);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    img_type_left.setBackground(ContextCompat.getDrawable(activity, R.drawable.hour_worker_flag));
                } else {
                    img_type_left.setBackgroundResource(R.drawable.hour_worker_flag);
                }
            } else if (String.valueOf(bean.getRecord_info().getAccounts_type()).equals(AccountUtil.CONSTRACTOR_CHECK)) {
                img_type_left.setVisibility(View.VISIBLE);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                    img_type_left.setBackground(ContextCompat.getDrawable(activity, R.drawable.constar_flag));
                } else {
                    img_type_left.setBackgroundResource(R.drawable.constar_flag);
                }
            } else {
                img_type_left.setVisibility(View.GONE);
            }
        }


    }
}

