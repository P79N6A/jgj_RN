package com.jizhi.jlongg.main.adpter;

import android.content.res.Resources;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.view.ContextMenu;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.TranslateAnimation;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.AccountWorkRember;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;

/**
 * CName:新日志适配器2.3.2
 * User: hcs
 * Date: 2017-10--290
 * Time: 11:02
 */
public class RemberWoreInfosAdapter extends BaseAdapter {
    private List<AccountWorkRember> workday;
    private LayoutInflater inflater;
    private RememberWorkerInfosActivity activity;
    private RememberCheckBoxChangeListener boxChangeListener;
    private Resources res;
    private String role;
    /**
     * 是否禁止点击
     */
    private boolean unClickItem;

    public RemberWoreInfosAdapter(RememberWorkerInfosActivity activity, List<AccountWorkRember> workday, String role, RememberCheckBoxChangeListener boxChangeListener) {
        super();
        this.workday = workday;
        this.activity = activity;
        this.role = role;
        inflater = LayoutInflater.from(activity);
        this.boxChangeListener = boxChangeListener;
        res = activity.getResources();
    }

    public List<AccountWorkRember> getWorkday() {
        return workday;
    }

    public void setWorkday(List<AccountWorkRember> workday) {
        this.workday = workday;
        notifyDataSetChanged();
    }

    public void setUnClickItem(boolean unClickItem) {
        this.unClickItem = unClickItem;
    }

    @Override
    public Object getItem(int position) {
        return workday.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final AccountWorkRember workInfo = workday.get(position);
        if (convertView == null) {
            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_rememberinfo_child_new, null);
            childHolder.tv_name = convertView.findViewById(R.id.tv_name);
            childHolder.tv_worktime = convertView.findViewById(R.id.tv_worktime);
            childHolder.tv_overtime = convertView.findViewById(R.id.tv_overtime);
            childHolder.tv_amounts = convertView.findViewById(R.id.tv_amounts);
            childHolder.tv_pro_name = convertView.findViewById(R.id.tv_pro_name);
            childHolder.tv_billname = convertView.findViewById(R.id.tv_billname);
            childHolder.cb_del = convertView.findViewById(R.id.cb_del);
            childHolder.img_type = convertView.findViewById(R.id.img_type);
            childHolder.rea_del = convertView.findViewById(R.id.rea_del);
            childHolder.rea_draver1 = convertView.findViewById(R.id.rea_draver1);
            childHolder.tv_date = convertView.findViewById(R.id.tv_date);
            childHolder.rea_driver10 = convertView.findViewById(R.id.rea_driver10);
            childHolder.rea_top = convertView.findViewById(R.id.rea_top);
            childHolder.img_remark = convertView.findViewById(R.id.img_remark);
//            childHolder.linear = convertView.findViewById(R.id.linear);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        if (workday.size() == 1 || workday.size() - 1 == position) {
            childHolder.rea_draver1.setVisibility(View.GONE);
        } else {
            childHolder.rea_draver1.setVisibility(View.VISIBLE);
        }
        convertView.findViewById(R.id.img_arrow).setVisibility(unClickItem ? View.INVISIBLE : View.VISIBLE);
        childHolder.rea_driver10.setVisibility(View.VISIBLE);
        childHolder.tv_date.setText(workInfo.getDate() + " (" + workInfo.getDate_turn() + ")");
        childHolder.tv_name.setText(NameUtil.setName(workInfo.getWorker_name()));
        childHolder.tv_pro_name.setText(NameUtil.setRemark(workInfo.getProname(), 10));
        childHolder.tv_billname.setText("班组长：" + NameUtil.setName(workInfo.getForeman_name()));
        if (workInfo.getAccounts_type() == 1 || workInfo.getAccounts_type() == 5) { // 1:点工 5.包工记工天
            childHolder.tv_worktime.setText(AccountUtil.getAccountShowTypeString(activity, true, false, true, Float.parseFloat(workInfo.getManhour()), workInfo.getWorking_hours()));
            childHolder.tv_overtime.setText(AccountUtil.getAccountShowTypeString(activity, true, false, false, Float.parseFloat(workInfo.getOvertime()), workInfo.getOvertime_hours()));
            childHolder.tv_amounts.setTextColor(res.getColor(R.color.app_color));
            childHolder.tv_amounts.setText(workInfo.getAmounts() + "");
            childHolder.tv_overtime.setVisibility(View.VISIBLE);

        } else if (workInfo.getAccounts_type() == 2) { //2:包工
            childHolder.tv_worktime.setText(workInfo.getContractor_type() == 1 ? "包工(承包)" : "包工(分包)");
            childHolder.tv_billname.setText(workInfo.getContractor_type() == 1 && role.equals(Constance.ROLETYPE_FM) ? "承包对象：" + NameUtil.setName(workInfo.getForeman_name()) : "班组长：" + NameUtil.setName(workInfo.getForeman_name()));
            childHolder.tv_amounts.setTextColor(ContextCompat.getColor(activity, workInfo.getContractor_type() == 1 && role.equals(Constance.ROLETYPE_FM) ? R.color.green : R.color.color_eb4e4e));


            childHolder.tv_overtime.setVisibility(View.GONE);
            childHolder.tv_amounts.setText(workInfo.getAmounts());
        } else if (workInfo.getAccounts_type() == 3) {//  3:借支
            childHolder.tv_worktime.setText("借支");
//            childHolder.linear.setPadding(0,0,0,0);
//            childHolder.linear.setGravity(Gravity.CENTER_VERTICAL);
            childHolder.tv_overtime.setVisibility(View.GONE);
            childHolder.tv_amounts.setTextColor(res.getColor(R.color.green));
            childHolder.tv_amounts.setText(workInfo.getAmounts());
        } else if (workInfo.getAccounts_type() == 4) {//   4:结算
            childHolder.tv_worktime.setText("结算");
//            childHolder.linear.setPadding(0,0,0,0);
//            childHolder.linear.setGravity(Gravity.CENTER_VERTICAL);
            childHolder.tv_overtime.setVisibility(View.GONE);
            childHolder.tv_amounts.setTextColor(res.getColor(R.color.green));
            childHolder.tv_amounts.setText(workInfo.getAmounts());
        }
        if (workInfo.isShowCb()) {
            if (!workInfo.isShowAnim()) {
                TranslateAnimation animation = new TranslateAnimation(-78, 0, 0, 0);
                animation.setDuration(500);//设置动画持续时间
                animation.setRepeatCount(0);//设置重复次数
                childHolder.cb_del.startAnimation(animation);
                workInfo.setShowAnim(true);
            }
            childHolder.rea_del.setVisibility(View.VISIBLE);
            if (workInfo.isSelected()) {
                childHolder.cb_del.setImageResource(R.drawable.checkbox_pressed);
            } else {
                childHolder.cb_del.setImageResource(R.drawable.checkbox_normal);
            }

        } else {
            childHolder.rea_del.setVisibility(View.GONE);
        }
        if (workInfo.getAccounts_type() == 1) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                childHolder.img_type.setVisibility(View.VISIBLE);
                childHolder.img_type.setBackground(ContextCompat.getDrawable(activity, R.drawable.hour_worker_flag));
            } else {
                childHolder.img_type.setBackgroundResource(R.drawable.hour_worker_flag);
            }
        } else if (workInfo.getAccounts_type() == 5) {
            childHolder.img_type.setVisibility(View.VISIBLE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                childHolder.img_type.setBackground(ContextCompat.getDrawable(activity, R.drawable.constar_flag));
            } else {
                childHolder.img_type.setBackgroundResource(R.drawable.constar_flag);
            }
        } else {
            childHolder.img_type.setVisibility(View.GONE);
        }
        if (workInfo.getIs_notes() == 1) {
            childHolder.img_remark.setVisibility(View.VISIBLE);
        } else {
            childHolder.img_remark.setVisibility(View.GONE);
        }
        convertView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
            @Override
            public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                //在上下文菜单选项中添加选项内容
                //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                menu.add(0, 1, 0, "修改");
                menu.add(1, 2, 1, "删除");
            }
        });
        convertView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if (!workInfo.isShowCb()) {
                    boxChangeListener.itemLongClicListener(position);

                }
                return false;
            }
        });
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                boolean isSelectAll = activity.isDelete();

                if (workInfo.isShowCb()) {
                    //删除存在差帐就返回
//                    int diff = workInfo.getAmounts_diff();
//                    if (diff != 0) {
//                        return;
//                    }
                    workInfo.setSelected(!workInfo.isSelected());
                    if (workInfo.isSelected()) {
                        childHolder.cb_del.setImageResource(R.drawable.checkbox_pressed);
                    } else {
                        childHolder.cb_del.setImageResource(R.drawable.checkbox_normal);
                    }
                    int length = 0;
//                    int size = workday.get(position).getList().size();
                    int size = workday.size();
                    for (int i = 0; i < size; i++) {
//                        if (workInfo.isSelected() && workInfo.getAmounts_diff() == 0) {
//                            length += 1;
//                        }
                        if (workInfo.isSelected()) {
                            length += 1;
                        }
                    }
                    boxChangeListener.getSelectLength(length);
                } else {
                    boxChangeListener.itemClicListener(position);
                }
            }
        });
        if (position != 0) {
            if (workInfo.getDate().equals(workday.get(position - 1).getDate())) {
                childHolder.rea_top.setVisibility(View.GONE);
            } else {
                childHolder.rea_top.setVisibility(View.VISIBLE);
            }
        } else {
            childHolder.rea_top.setVisibility(View.VISIBLE);
        }
        return convertView;
    }

    @Override
    public int getCount() {
        return workday.size();
    }

    class ChildHolder {
        TextView tv_name;
        TextView tv_worktime;
        TextView tv_overtime;
        TextView tv_amounts;
        TextView tv_pro_name;
        TextView tv_billname;
        ImageView cb_del;
        ImageView img_type;
        ImageView img_remark;
        RelativeLayout rea_del;
        RelativeLayout rea_draver1;
        LinearLayout rea_top;
        TextView tv_date;
        RelativeLayout rea_driver10;
        LinearLayout linear;
    }

    public interface RememberCheckBoxChangeListener {
        void getSelectLength(int length);

        void itemClicListener(int positonint);

        void itemLongClicListener(int positonint);
    }

}
