package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.util.AccountUtil;

import java.util.List;

public class ViewHolderAllAccountFotter extends AllAccountRecycleViewHolder {
    public ViewHolderAllAccountFotter(View itemView, Activity activity, NewAllAccountAdapter.AllAccountListener allAccountListener) {

        super(itemView);
        this.activity = activity;
        this.allAccountListener = allAccountListener;
    }

    @Override
    public void bindHolder(int positions, List<AccountAllWorkBean> list) {
        this.list=list;
        ((TextView) itemView.findViewById(R.id.tv_remark)).setText(AccountUtil.getAccountRemark(list.get(getAdapterPosition()).getRemark(), list.get(getAdapterPosition()).getImageItems(), activity));
        itemView.findViewById(R.id.rea_remark).setOnClickListener(onClickListener);
        itemView.findViewById(R.id.rea_add_sub_projrct).setOnClickListener(onClickListener);


    }


}
