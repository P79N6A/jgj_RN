package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.WrapGridview;

import java.util.List;

import static com.jizhi.jlongg.R.id.tv_state;

/**
 * CName:质量，安全检查列表页Adapter 2.3.0
 * User: hcs
 * Date: 2017-07-18
 * Time: 09:452
 */
public class CheckHostoryAdapter extends BaseAdapter {
    private List<CheckPlanListBean> list;
    private LayoutInflater inflater;
    private Context context;
    private CheckHistoryItemClick checkHistoryItemClick;

    public CheckHostoryAdapter(Context context, List<CheckPlanListBean> list, CheckHistoryItemClick checkHistoryItemClick) {
        this.list = list;
        this.context = context;
        this.checkHistoryItemClick = checkHistoryItemClick;
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
        final CheckPlanListBean checkPlanListBean = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_check_history, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_state = (TextView) convertView.findViewById(tv_state);
            holder.tv_time = (TextView) convertView.findViewById(R.id.tv_time);
            holder.img_arrow = (ImageView) convertView.findViewById(R.id.img_arrow);
            holder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            holder.ngl_images = (WrapGridview) convertView.findViewById(R.id.ngl_images);
            holder.lin_detail = (LinearLayout) convertView.findViewById(R.id.lin_detail);
            holder.rea_top = (RelativeLayout) convertView.findViewById(R.id.rea_top);
            holder.view_top = convertView.findViewById(R.id.view_top);
            holder.view_bottom = convertView.findViewById(R.id.view_bottom);
            holder.view_center = convertView.findViewById(R.id.view_center);
            holder.last_view = convertView.findViewById(R.id.last_view);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(NameUtil.setName(checkPlanListBean.getUser_info().getReal_name()) + " " + checkPlanListBean.getUser_info().getTelephone());
        holder.tv_time.setText(checkPlanListBean.getUpdate_time());
        if (!TextUtils.isEmpty(checkPlanListBean.getComment())) {
            holder.tv_content.setText(checkPlanListBean.getComment());
            holder.tv_content.setVisibility(View.VISIBLE);
        } else {
            holder.tv_content.setVisibility(View.GONE);
        }
        if (checkPlanListBean.getImgs().size() > 0) {
            CheckHistoryImageAdapter squaredImageAdapter = new CheckHistoryImageAdapter(context, checkPlanListBean.getImgs());
            holder.ngl_images.setAdapter(squaredImageAdapter);
            holder.ngl_images.setVisibility(View.VISIBLE);
        } else {
            holder.ngl_images.setVisibility(View.GONE);
        }
        if (checkPlanListBean.getStatus() == 0) {
            //0：未检查
            holder.tv_state.setText("[未检查]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (checkPlanListBean.getStatus() == 1) {
            //1：待整改
            holder.tv_state.setText("[待整改]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
        } else if (checkPlanListBean.getStatus() == 2) {
            // 2：不用检查
            holder.tv_state.setText("[不用检查]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (checkPlanListBean.getStatus() == 3) {
            //3：通过
            holder.tv_state.setText("[通过]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_83c76e));
        } else {
            holder.tv_state.setText("");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        }
        if (checkPlanListBean.isChild_isExpanded()) {
            Utils.setBackGround(holder.img_arrow, ContextCompat.getDrawable(context, R.drawable.icon_arrow_down));
            if (!TextUtils.isEmpty(checkPlanListBean.getComment()) || checkPlanListBean.getImgs().size() > 0) {
                holder.lin_detail.setVisibility(View.VISIBLE);
            } else {
                holder.lin_detail.setVisibility(View.GONE);
            }

        } else {
            Utils.setBackGround(holder.img_arrow, ContextCompat.getDrawable(context, R.drawable.icon_arrow_up));
            holder.lin_detail.setVisibility(View.GONE);
        }
        holder.rea_top.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkHistoryItemClick.itemClick(position);
            }
        });
        if (list.size() == 1) {
            holder.view_top.setVisibility(View.GONE);
            holder.view_bottom.setVisibility(View.GONE);
            holder.view_center.setVisibility(View.GONE);
            holder.last_view.setVisibility(View.VISIBLE);

        } else if (list.size() > 1 && position == 0) {
            holder.view_top.setVisibility(View.GONE);
            holder.view_bottom.setVisibility(View.VISIBLE);
            holder.view_center.setVisibility(View.VISIBLE);
            holder.last_view.setVisibility(View.GONE);
        } else if (list.size() > 1 && position == list.size() - 1) {
            holder.view_top.setVisibility(View.VISIBLE);
            holder.view_bottom.setVisibility(View.GONE);
            holder.view_center.setVisibility(View.GONE);
            holder.last_view.setVisibility(View.VISIBLE);
        } else {
            holder.view_top.setVisibility(View.VISIBLE);
            holder.view_bottom.setVisibility(View.VISIBLE);
            holder.view_center.setVisibility(View.VISIBLE);
            holder.last_view.setVisibility(View.GONE);
        }
        return convertView;
    }

    class ViewHolder {
        //执行人
        TextView tv_name;
        //当前状态
        TextView tv_state;
        //执行时间
        TextView tv_time;
        ImageView img_arrow;
        //内容布局
        LinearLayout lin_detail;
        //顶部布局
        RelativeLayout rea_top;
        //内容
        TextView tv_content;
        WrapGridview ngl_images;
        View view_top, view_bottom, view_center, last_view;
    }

    public interface CheckHistoryItemClick {
        void itemClick(int position);
    }
}
