package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.check.CheckInspectioPlanActivity;
import com.jizhi.jlongg.main.bean.CheckListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;

import java.util.List;

/**
 * CName:质量，安全检查列表Adapter 2.3.4
 * User: hcs
 * Date: 2017-07-18
 * Time: 11:18
 */

public class MsgCheckListAdapter extends BaseAdapter {
    private List<CheckListBean> list;
    private LayoutInflater inflater;
    private GroupDiscussionInfo gnInfo;
    private Context context;

    public MsgCheckListAdapter(Context context, List<CheckListBean> list, GroupDiscussionInfo gnInfo) {
        this.list = list;
        this.context = context;
        this.gnInfo = gnInfo;
        inflater = LayoutInflater.from(context);
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

    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final CheckListBean checkListBean = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message_quality_and_safe_check_list, null);
            holder.rb_name =  convertView.findViewById(R.id.rb_name);
            holder.tv_time =  convertView.findViewById(R.id.tv_time);
            holder.tv_name =  convertView.findViewById(R.id.tv_name);
            holder.tv_project = convertView.findViewById(R.id.tv_project);
            holder.tv_level =  convertView.findViewById(R.id.tv_level);
            holder.tv_state = convertView.findViewById(R.id.tv_state);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.rb_name.setText(checkListBean.getPlan_name());
        holder.tv_time.setText(Html.fromHtml("执行时间：<font color='#333333'>" + checkListBean.getExecute_time() + "</font>"));
        holder.tv_name.setText(Html.fromHtml("执行人：<font color='#333333'>" + checkListBean.getExecute_name() + "</font>"));
        holder.tv_project.setText(Html.fromHtml("检查项：<font color='#333333'>" + checkListBean.getPro_num() + "</font><font color='#333333'>项检查</font>"));
        holder.tv_level.setText("通过率" + checkListBean.getPass_percent() + "%");
        if (checkListBean.getExecute_percent().equals("0")) {
            holder.tv_state.setText("未开始");
            Utils.setBackGround(holder.tv_state, context.getResources().getDrawable(R.drawable.bg_999999_3radius));
        } else if (checkListBean.getExecute_percent().equals("100")) {
            holder.tv_state.setText("已完成");
            Utils.setBackGround(holder.tv_state, context.getResources().getDrawable(R.drawable.bg_83c76e_3radius));
        } else {
            holder.tv_state.setText("进行中" + checkListBean.getExecute_percent() + "%");
            Utils.setBackGround(holder.tv_state, context.getResources().getDrawable(R.drawable.draw_bg_f9a00f_3radius));
        }
        // 进行中draw_bg_f9a00f_3radius  未开始bg_999999_3radius  已完成bg_83c76e_3radius
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CheckInspectioPlanActivity.actionStart((Activity) context, gnInfo, checkListBean.getPlan_id());
            }
        });
        return convertView;
    }

    class ViewHolder {
        //计划名称
        RadioButton rb_name;
        //执行时间
        TextView tv_time;
        //执行人
        TextView tv_name;
        //检查项
        TextView tv_project;
        //通过率
        TextView tv_level;
        //当前状态
        TextView tv_state;
    }
}
