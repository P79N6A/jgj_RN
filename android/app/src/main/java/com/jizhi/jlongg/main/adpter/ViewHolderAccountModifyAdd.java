package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountModifyBean;

import java.util.List;

public class ViewHolderAccountModifyAdd extends AccountModefyRecycleViewHolder {
    //记账产生时间
    private TextView tv_modify_date_left, tv_modify_date_right;
    private ListView tv_modify_list_left, tv_modify_list_right;
    //    //记账类型
//    private TextView tv_modify_type_left_left,tv_modify_type_left_right;


    public ViewHolderAccountModifyAdd(View itemView, Activity activity, AccountModifyAdapter.ItemClickInterFace itemClickInterFace) {
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
        //左右日期
        tv_modify_date_left = (TextView) itemView.findViewById(R.id.tv_modify_date_left);
        tv_modify_date_right = (TextView) itemView.findViewById(R.id.tv_modify_date_right);
        //左右增加列表
        tv_modify_list_left = (ListView) itemView.findViewById(R.id.tv_modify_list_left);
        tv_modify_list_right = (ListView) itemView.findViewById(R.id.tv_modify_list_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(AccountModifyBean bean) {
        AddInfoAdapter addInfoAdapter = new AddInfoAdapter(activity, bean.getAdd_info());
        if (UclientApplication.getUid(activity).equals(bean.getUser_info().getUid())) {
            rea_layout_right.setVisibility(View.VISIBLE);
            rea_layout_left.setVisibility(View.GONE);
            img_head_right.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), 0);
            tv_modify_date_right.setText(bean.getCreate_time());
            tv_modify_list_right.setAdapter(addInfoAdapter);
            Utils.setListViewHeightBasedOnChildren(tv_modify_list_right);
            tv_modify_list_right.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int i, long id) {
                    itemClickInterFace.toRememberActivity(position, i);
                }
            });

        } else {
            rea_layout_left.setVisibility(View.VISIBLE);
            rea_layout_right.setVisibility(View.GONE);
            img_head_left.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), 0);
            tv_modify_date_left.setText(bean.getCreate_time());
            tv_modify_list_left.setAdapter(addInfoAdapter);
            Utils.setListViewHeightBasedOnChildren(tv_modify_list_left);
            tv_modify_list_left.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int i, long id) {
                    itemClickInterFace.toRememberActivity(position, i);
                }
            });
        }


    }
}

