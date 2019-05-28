package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.check.CheckProjectActivity;
import com.jizhi.jlongg.main.bean.CheckListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;

import java.util.List;

import static com.jizhi.jlongg.R.id.tv_state;


/**
 * CName:质量，安全检查列表页Adapter 2.3.0
 * User: hcs
 * Date: 2017-07-18
 * Time: 09:452
 */
public class CheckInspLanAdapter extends BaseAdapter {
    private List<CheckListBean> list;
    private LayoutInflater inflater;
    private GroupDiscussionInfo gnInfo;
    private Context context;
    private String plan_id;

    public CheckInspLanAdapter(Context context, List<CheckListBean> list, GroupDiscussionInfo gnInfo, String plan_id) {
        this.list = list;
        this.context = context;
        this.gnInfo = gnInfo;
        this.plan_id = plan_id;
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
            convertView = inflater.inflate(R.layout.item_insplan_check_list, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_state = (TextView) convertView.findViewById(R.id.tv_state);
            holder.tv_time = (TextView) convertView.findViewById(R.id.tv_time);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(checkListBean.getPro_name());

        //   state;//状态  //0：未检查 1：待整改 2：不用检查 3：完成
        if (checkListBean.getStatus() == 0) {
            //0：未检查
            holder.tv_state.setText("未检查");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_999999));
        } else if (checkListBean.getStatus() == 1) {
            //1：待整改
            holder.tv_state.setText("待整改");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_eb4e4e));
            holder.tv_time.setText(checkListBean.getUpdate_time() + "  检查人：" + checkListBean.getReal_name());
        } else if (checkListBean.getStatus() == 2) {
            // 2：不用检查
            holder.tv_state.setText("不用检查");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_999999));
            holder.tv_time.setText(checkListBean.getUpdate_time() + "  检查人：" + checkListBean.getReal_name());
        } else if (checkListBean.getStatus() == 3) {
            //3：完成
            holder.tv_state.setText("通过");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_83c76e));

        }
        if (checkListBean.getStatus() == 0) {
            holder.tv_time.setVisibility(View.GONE);
        } else {
            holder.tv_time.setText(checkListBean.getUpdate_time() + "  检查人：" + checkListBean.getReal_name());
            holder.tv_time.setVisibility(View.VISIBLE);
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CheckProjectActivity.actionStart((Activity) context, gnInfo, plan_id,checkListBean.getPro_id());
            }
        });
        return convertView;
    }

    class ViewHolder {
        //执行人
        TextView tv_name;
        //当前状态
        TextView tv_state;
        //执行时间
        TextView tv_time;
        ImageView img_view;
    }
}
