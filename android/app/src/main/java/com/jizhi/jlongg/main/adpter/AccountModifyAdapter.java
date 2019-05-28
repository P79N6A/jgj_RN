package com.jizhi.jlongg.main.adpter;


import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountModifyBean;

import java.util.List;

/**
 * CName:记工变更适配器
 * User: hcs
 * Date: 2018-8-3
 * Time: 14:44
 */
public class AccountModifyAdapter extends RecyclerView.Adapter<AccountModefyRecycleViewHolder> {
    private LayoutInflater mInflater;
    private Activity activity;
    private List<AccountModifyBean> list;
    private ItemClickInterFace itemClickInterFace;

    public AccountModifyAdapter(Activity activity, List<AccountModifyBean> list, ItemClickInterFace itemClickInterFace) {
        mInflater = LayoutInflater.from(activity);
        this.activity = activity;
        this.itemClickInterFace = itemClickInterFace;
        this.list = list;
    }


    @Override
    public int getItemCount() {
        return list.size();
    }

    @Override
    public int getItemViewType(int position) {
        return list.get(position).getType();

    }

    @Override
    public AccountModefyRecycleViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        AccountModefyRecycleViewHolder vh = null;
        switch (viewType) {
            case 1:
                //新增
                vh = new ViewHolderAccountModifyAdd(mInflater.inflate(R.layout.item_account_modify_add, parent, false), activity, itemClickInterFace);
                break;
            case 2:
                //修改删除点工，包工记工天
                vh = new ViewHolderAccountModifyHour(mInflater.inflate(R.layout.item_account_modify_hour, parent, false), activity, itemClickInterFace);
                break;
            case 3:
                //修改删除借支结算
                vh = new ViewHolderAccountModifyBorrow(mInflater.inflate(R.layout.item_account_modify_borrow, parent, false), activity, itemClickInterFace);
                break;
            default:
                break;
        }
        return vh;
    }

    @Override
    public void onBindViewHolder(AccountModefyRecycleViewHolder holder, int position) {
        holder.bindHolder(position, list);
    }

    public interface ItemClickInterFace {
        void itemClick(int positon);

        void toUserInfo(int positon);

        void toRememberActivity(int group_postion, int child_positon);
    }
}

