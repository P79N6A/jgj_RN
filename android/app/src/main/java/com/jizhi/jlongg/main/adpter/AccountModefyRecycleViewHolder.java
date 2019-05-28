package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountModifyBean;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

public abstract class AccountModefyRecycleViewHolder extends RecyclerView.ViewHolder {
    protected AccountModifyAdapter.ItemClickInterFace itemClickInterFace;
    //左右布局
    protected RelativeLayout rea_layout_left, rea_layout_right;
    //左右头像
    protected RoundeImageHashCodeTextLayout img_head_left, img_head_right;
    //左,右用户名字
    protected TextView tv_username_left, tv_username_right;
    protected int position;
    protected Activity activity;
    //时间中间布局
    private RelativeLayout rea_center;
    //中间布局
    private TextView tv_center_text;

    public AccountModefyRecycleViewHolder(View itemView) {
        super(itemView);
    }

    public abstract void bindHolder(int position, List<AccountModifyBean> list);

    /**
     * 初始化相同的view
     */
    public void initAlickItemView() {
        //左右布局
        rea_layout_left = (RelativeLayout) itemView.findViewById(R.id.rea_layout_left);
        rea_layout_right = (RelativeLayout) itemView.findViewById(R.id.rea_layout_right);
        rea_center = (RelativeLayout) itemView.findViewById(R.id.rea_center);
        //左右头像
        img_head_left = (RoundeImageHashCodeTextLayout) itemView.findViewById(R.id.img_head_left);
        img_head_right = (RoundeImageHashCodeTextLayout) itemView.findViewById(R.id.img_head_right);
        //左用户名字
        tv_username_left = (TextView) itemView.findViewById(R.id.tv_username_left);
        //右用户名字
        tv_username_right = (TextView) itemView.findViewById(R.id.tv_username_right);
        tv_center_text = (TextView) itemView.findViewById(R.id.tv_center_text);
    }

    /**
     * 设置显示左边还是右边
     *
     * @param bean
     */
    public void setItemAlickData(AccountModifyBean bean) {

        if (UclientApplication.getUid(UclientApplication.getInstance()).equals(bean.getUser_info().getUid())) {
            rea_layout_right.setVisibility(View.VISIBLE);
            rea_layout_left.setVisibility(View.GONE);
            tv_username_right.setText(bean.getRole() == 2 ? "班组长(" + bean.getUser_info().getReal_name() + ")" : "代班长(" + bean.getUser_info().getReal_name() + ")");
            img_head_right.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), 0);
            itemView.findViewById(R.id.layout_right).setOnClickListener(onClickListener);
            img_head_right.setOnClickListener(onClickListener);

        } else {
            rea_layout_left.setVisibility(View.VISIBLE);
            rea_layout_right.setVisibility(View.GONE);
            tv_username_left.setText(bean.getRole() == 2 ? "班组长(" + bean.getUser_info().getReal_name() + ")" : "代班长(" + bean.getUser_info().getReal_name() + ")");
            img_head_left.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), 0);
            itemView.findViewById(R.id.layout_left).setOnClickListener(onClickListener);
            img_head_left.setOnClickListener(onClickListener);
        }
    }

    View.OnClickListener onClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()){
                case R.id.layout_right:
                case R.id.layout_left:
                    if (null != itemClickInterFace) {
                        itemClickInterFace.itemClick(position);
                    }
                    break;
                case R.id.img_head_left:
                case R.id.img_head_right:
                    itemClickInterFace.toUserInfo(position);
                    break;
            }

        }
    };

    /**
     * 中间时间显示
     *
     * @param position
     * @param list
     */
    public void setShowCenterDate(int position, List<AccountModifyBean> list) {
        if (position != 0) {
            if (list.get(position).getCreate_time().equals(list.get(position - 1).getCreate_time())) {
                rea_center.setVisibility(View.GONE);
            } else {
                rea_center.setVisibility(View.VISIBLE);
                tv_center_text.setText(list.get(position).getCreate_time());
            }
        } else {
            rea_center.setVisibility(View.VISIBLE);
            tv_center_text.setText(list.get(position).getCreate_time());
        }
    }
}

