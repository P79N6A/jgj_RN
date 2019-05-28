package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;

import java.util.List;

public abstract class AllAccountRecycleViewHolder extends RecyclerView.ViewHolder {
    protected NewAllAccountAdapter.AllAccountListener allAccountListener;
    //    protected int position;
    protected Activity activity;
    protected List<AccountAllWorkBean> list;

    public AllAccountRecycleViewHolder(View itemView) {
        super(itemView);
    }

    public abstract void bindHolder(int position, List<AccountAllWorkBean> list);

    /**
     * 点击事件
     */
    View.OnClickListener onClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.rea_role:
                    //选择记账对象
                    allAccountListener.selectRole(getAdapterPosition());
                    break;
                case R.id.rea_date://选择记账日期
                    allAccountListener.selectDate(getAdapterPosition());
                    break;
                case R.id.rea_project://选择项目
                    allAccountListener.selectProject(getAdapterPosition());
                    break;
                case R.id.rea_remark://设置备注
                    allAccountListener.selectRemark(getAdapterPosition());
                    break;
                case R.id.rea_add_sub_projrct://添加分项
                    allAccountListener.addSubProject(getAdapterPosition());
                    break;
                case R.id.rea_sub_name://选择分项
                    allAccountListener.selectSubProject(getAdapterPosition());
                    break;
                case R.id.tv_delete_sub://删除分项
                    allAccountListener.deleteSubProject(getAdapterPosition());
                    break;
                case R.id.lin_company://选择单位
                    allAccountListener.selectCompany(getAdapterPosition());
                    break;

            }
        }
    };

}
