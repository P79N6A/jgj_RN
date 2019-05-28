package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkerDay;
import com.jizhi.jlongg.main.util.AccountUtil;

import java.util.List;

/**
 * 记工清单详情adapter
 *
 * @author Xuj
 * @version 1.0.4
 * @time 2016年2月29日 15:25:46
 */
public class ListDetailAdapter extends BaseAdapter {
    private List<WorkerDay> list;
    private LayoutInflater inflater;
    private Resources res;

    public ListDetailAdapter(Context context, List<WorkerDay> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.res = context.getResources();
    }


    public void setList(List<WorkerDay> list) {
        this.list = list;
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


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_list_detail, null);
            holder.date_txt = (TextView) convertView.findViewById(R.id.date_txt);
            holder.date_turn = (TextView) convertView.findViewById(R.id.date_turn);
            holder.manhour = (TextView) convertView.findViewById(R.id.manhour);
            holder.overtime = (TextView) convertView.findViewById(R.id.overtime);
            holder.amounts = (TextView) convertView.findViewById(R.id.amounts);
            holder.amounts_diff = (ImageView) convertView.findViewById(R.id.amounts_diff);
            holder.point = (ImageView) convertView.findViewById(R.id.point);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        WorkerDay bean = list.get(position);
        holder.date_txt.setText(bean.getDate_txt());
        holder.date_turn.setText(bean.getDate_turn());
        if (bean.getAccounts_type().getCode() == Integer.parseInt(AccountUtil.CONSTRACTOR)) { //包工
            holder.overtime.setVisibility(View.GONE);
            holder.manhour.setText("包工");
            holder.manhour.setTextSize(13);
        } else if (bean.getAccounts_type().getCode() == Integer.parseInt(AccountUtil.BORROWING)) { //借支
            holder.overtime.setVisibility(View.GONE);
            holder.manhour.setText("借支");
            holder.manhour.setTextSize(13);
        } else { //点工
            holder.manhour.setText(bean.getManhour());
            if (TextUtils.isEmpty(bean.getOvertime())) {
                holder.manhour.setTextSize(13);
                holder.overtime.setVisibility(View.GONE);
            } else {
                holder.manhour.setTextSize(12);
                holder.overtime.setText(bean.getOvertime());
                holder.overtime.setVisibility(View.VISIBLE);
            }
        }
        if (bean.getAccounts_type().getCode() == Integer.parseInt(AccountUtil.BORROWING)) {
            holder.amounts.setTextColor(res.getColor(R.color.green_7ec568));
            holder.amounts.setText("¥-" + Utils.m2(bean.getAmounts()));
        } else {
            holder.amounts.setTextColor(res.getColor(R.color.red_f75a23));
            holder.amounts.setText("¥" + Utils.m2(bean.getAmounts()));
        }
        int diff = bean.getModify_marking();
        if (diff == 2) { //等待自己确认
            holder.amounts_diff.setVisibility(View.VISIBLE);
            holder.amounts_diff.setImageResource(R.drawable.yellow_waring);
            holder.point.setVisibility(View.GONE);
        } else if (diff == 3) { //等待对方修改
            holder.amounts_diff.setVisibility(View.VISIBLE);
            holder.amounts_diff.setImageResource(R.drawable.blue_waring);
            holder.point.setVisibility(View.GONE);
        } else {
            holder.amounts_diff.setVisibility(View.GONE);
            holder.point.setVisibility(View.VISIBLE);
        }
        return convertView;
    }

    class ViewHolder {
        /**
         * 金额
         */
        TextView amounts;
        /**
         * 是否有差账
         */
        ImageView amounts_diff;
        /**
         * 日期
         */
        TextView date_txt;
        /**
         * 正常工作时长（点工项目才返回）
         */
        TextView manhour;
        /**
         * 加班时间
         */
        TextView overtime;
        /**
         * 农历
         */
        TextView date_turn;
        /**
         * 箭头
         */
        ImageView point;

    }


}
