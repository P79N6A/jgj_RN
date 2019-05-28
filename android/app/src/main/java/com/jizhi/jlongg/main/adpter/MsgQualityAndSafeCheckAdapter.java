package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.qualityandsafe.MsgQualityAndSafeCheckListActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * CName:质量，安全检查列表页Adapter 2.3.0
 * User: hcs
 * Date: 2017-07-18
 * Time: 09:452
 */
public class MsgQualityAndSafeCheckAdapter extends BaseAdapter {
    private List<QualityAndsafeCheckMsgBean> list;
    private LayoutInflater inflater;
    private Context context;
    private GroupDiscussionInfo gnInfo;

    public MsgQualityAndSafeCheckAdapter(Context context, List<QualityAndsafeCheckMsgBean> list, GroupDiscussionInfo gnInfo) {
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.gnInfo = gnInfo;
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
        final QualityAndsafeCheckMsgBean msgEntity = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message_quality_and_safe_check, null);
            holder.img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_inspect_name = (TextView) convertView.findViewById(R.id.tv_inspect_name);
            holder.tv_child_inspect_name = (TextView) convertView.findViewById(R.id.tv_child_inspect_name);
            holder.tv_pass = (TextView) convertView.findViewById(R.id.tv_pass);
            holder.tv_finish = (TextView) convertView.findViewById(R.id.tv_finish);
            holder.tv_userinfo = (TextView) convertView.findViewById(R.id.tv_userinfo);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.img_head.setView(msgEntity.getSend_user_info().getHead_pic(), msgEntity.getSend_user_info().getReal_name(), 0);
        holder.tv_name.setText(NameUtil.setName(msgEntity.getSend_user_info().getReal_name()));
        holder.tv_date.setText(msgEntity.getCreate_time());
        if (msgEntity.getUser_info() != null && !TextUtils.isEmpty(msgEntity.getUser_info().getReal_name())) {
            holder.tv_userinfo.setText(Html.fromHtml("由<font color='#4990e2'>" + NameUtil.setName(msgEntity.getUser_info().getReal_name()) + "</font>执行"));
        } else {
            holder.tv_userinfo.setText("");
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MsgQualityAndSafeCheckListActivity.actionStart((Activity) context, msgEntity, gnInfo.getAll_pro_name());
            }
        });
        holder.tv_inspect_name.setText(msgEntity.getInspect_name());
        holder.tv_child_inspect_name.setText(msgEntity.getChild_inspect_name());
        holder.tv_pass.setText("通过率" + msgEntity.getPass() + "%");
        if (msgEntity.getFinish().equals("100")) {
            holder.tv_finish.setTextColor(context.getResources().getColor(R.color.color_999999));
        } else {
            holder.tv_finish.setTextColor(context.getResources().getColor(R.color.color_ff0000));
        }
        holder.tv_finish.setText("完成率" + msgEntity.getFinish() + "%");
        return convertView;
    }

    class ViewHolder {
        RoundeImageHashCodeTextLayout img_head;
        TextView tv_name;
        TextView tv_date;
        TextView tv_inspect_name;
        TextView tv_child_inspect_name;
        TextView tv_pass;
        TextView tv_finish;
        TextView tv_userinfo;
    }
}
