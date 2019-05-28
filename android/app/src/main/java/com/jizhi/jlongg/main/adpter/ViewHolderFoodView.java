package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.view.View;

import com.jizhi.jlongg.main.bean.AccountModifyBean;

import java.util.List;

public class ViewHolderFoodView extends AccountModefyRecycleViewHolder {


    public ViewHolderFoodView(View itemView, Activity activity) {
        super(itemView);
    }

    @Override
    public void bindHolder(int position, List<AccountModifyBean> list) {
        this.position = position;
    }
}

