package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ExperienceImageAdapter.ExperienceClickListener;
import com.jizhi.jlongg.main.bean.WorkType;

import java.util.List;

/**
 * 发布/修改项目adapter
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-15 上午11:16:01
 */
public class ProjectQuoteAdapter extends BaseAdapter {
    private List<WorkType> list;
    private LayoutInflater inflater;
    private Context context;
    private DeleteClickListener clickListener;
    public ExperienceClickListener experienceClickListener;

    public ProjectQuoteAdapter(Context context, List<WorkType> list, ExperienceClickListener experienceClickListener,
                               DeleteClickListener clickListener) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.experienceClickListener = experienceClickListener;
        this.clickListener = clickListener;
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

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        final WorkType workType = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_projectquote_lvs, null);
            holder.rg_work_level = (RadioGroup) convertView.findViewById(R.id.rg_work_level);
            holder.rg_cooperate_range = (RadioGroup) convertView.findViewById(R.id.rg_cooperate_range);
            holder.ed_peoplecount = (EditText) convertView.findViewById(R.id.ed_peoplecount);
            holder.ed_price = (EditText) convertView.findViewById(R.id.ed_price);
            holder.tv_delete = (TextView) convertView.findViewById(R.id.right_title);
            holder.rb_top1 = (RadioButton) convertView.findViewById(R.id.rb_top1);
            holder.rb_top2 = (RadioButton) convertView.findViewById(R.id.rb_top2);
            holder.rb_bottom1 = (RadioButton) convertView.findViewById(R.id.rb_bottom1);
            holder.rb_bottom2 = (RadioButton) convertView.findViewById(R.id.rb_bottom2);
            holder.rea_hour = (RelativeLayout) convertView.findViewById(R.id.rea_hour);
            holder.rea_month = (LinearLayout) convertView.findViewById(R.id.rea_month);
            holder.tv_name = (TextView) convertView.findViewById(R.id.projectprice);
            holder.rb_dayOrMonth = (RadioGroup) convertView.findViewById(R.id.rb_dayOrMonth);
            holder.tv_price = (TextView) convertView.findViewById(R.id.tv_price);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(list.get(position).getWorkName());
        OnCheckedChangeListener checkedChangeListener = new OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    // 点工
                    case R.id.rb_hour:
                        list.get(position).setCooperate_range(1);
                        holder.rea_hour.setVisibility(View.VISIBLE);
                        holder.rea_month.setVisibility(View.GONE);
                        list.get(position).setBalanceway("天");
                        String mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(workType.getMoney() + "元/" + workType.getBalanceway());
                        }
                        break;
                    // 包工
                    case R.id.rb_all:
                        list.get(position).setCooperate_range(2);
                        holder.rea_hour.setVisibility(View.GONE);
                        holder.rea_month.setVisibility(View.VISIBLE);
                        list.get(position).setBalanceway("平方");
                        mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(workType.getMoney() + "元/" + workType.getBalanceway());
                        }
                        break;
                    // 学徒工
                    case R.id.rb_t1:
                        list.get(position).setWorklevel(32);
                        break;
                    // 半熟工
                    case R.id.rb_t2:
                        list.get(position).setWorklevel(33);
                        break;
                    // 熟练工
                    case R.id.rb_t3:
                        list.get(position).setWorklevel(34);
                        break;
                    // 高级工
                    case R.id.rb_t4:
                        list.get(position).setWorklevel(35);
                        break;
                    // 单位天
                    case R.id.rb_day:
                        list.get(position).setBalanceway("天");
                        mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(workType.getMoney() + "元/" + workType.getBalanceway());
                        }
                        break;
                    // 单位月
                    case R.id.rb_month:
                        list.get(position).setBalanceway("月");
                        mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(workType.getMoney() + "元/" + workType.getBalanceway());
                        }
                        break;

                }

            }
        };
        // 点工，包工
        holder.rg_cooperate_range
                .setOnCheckedChangeListener(checkedChangeListener);
        // 熟练度
        holder.rg_work_level.setOnCheckedChangeListener(checkedChangeListener);
        // 包工单位天,月
        holder.rb_dayOrMonth.setOnCheckedChangeListener(checkedChangeListener);

        OnClickListener cListener = new OnClickListener() {

            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    // 单位平方
                    case R.id.rb_top1:
                        holder.rb_top1.setChecked(true);
                        holder.rb_top2.setChecked(false);
                        holder.rb_bottom1.setChecked(false);
                        holder.rb_bottom2.setChecked(false);
                        list.get(position).setBalanceway("平方");
                        String mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(list.get(position).getMoney()
                                    + "元/" + list.get(position).getBalanceway());
                        }
                        break;
                    // 单位立方
                    case R.id.rb_top2:
                        holder.rb_top1.setChecked(false);
                        holder.rb_top2.setChecked(true);
                        holder.rb_bottom1.setChecked(false);
                        holder.rb_bottom2.setChecked(false);
                        list.get(position).setBalanceway("立方");
                        mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(list.get(position).getMoney()
                                    + "元/" + list.get(position).getBalanceway());
                        }
                        break;
                    // 单位米
                    case R.id.rb_bottom1:
                        holder.rb_top1.setChecked(false);
                        holder.rb_top2.setChecked(false);
                        holder.rb_bottom1.setChecked(true);
                        holder.rb_bottom2.setChecked(false);
                        list.get(position).setBalanceway("米");
                        mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(list.get(position).getMoney()
                                    + "元/" + list.get(position).getBalanceway());
                        }
                        break;
                    // 单位吨
                    case R.id.rb_bottom2:
                        holder.rb_top1.setChecked(false);
                        holder.rb_top2.setChecked(false);
                        holder.rb_bottom1.setChecked(false);
                        holder.rb_bottom2.setChecked(true);
                        list.get(position).setBalanceway("吨");
                        mone = list.get(position).getMoney();
                        if (!mone.equals("")) {
                            holder.tv_price.setText(list.get(position).getMoney()
                                    + "元/" + list.get(position).getBalanceway());
                        }
                        break;
                }

            }
        };
        // 包工单位平方
        holder.rb_top1.setOnClickListener(cListener);
        // 包工单位立方
        holder.rb_top2.setOnClickListener(cListener);
        // 包工单位米
        holder.rb_bottom1.setOnClickListener(cListener);
        // 包工单位吨
        holder.rb_bottom2.setOnClickListener(cListener);

        // 设置熟练度
        if (workType.getWorklevel() == 32) {
            holder.rg_work_level.check(R.id.rb_t1);
        } else if (workType.getWorklevel() == 33) {
            holder.rg_work_level.check(R.id.rb_t2);
        } else if (workType.getWorklevel() == 34) {
            holder.rg_work_level.check(R.id.rb_t3);
        } else if (workType.getWorklevel() == 35) {
            holder.rg_work_level.check(R.id.rb_t4);
        }
        // 设置价钱
        if (null != workType.getMoney() && !workType.getMoney().equals("")) {
            holder.tv_price.setText(list.get(position).getMoney() + "元/"
                    + list.get(position).getBalanceway());
        }
//		String pCount = workType.getPerson_count();
        // if (!pCount.equals("") && !pCount.equals("0")) {
//		holder.ed_peoplecount.setText(pCount + "");
        // }
        String pCount = workType.getPerson_count();
        if (null != pCount && !pCount.equals("")) {
            holder.ed_peoplecount.setText(pCount);
        }
        String cMoney = workType.getMoney();
        if (null != cMoney && !cMoney.equals("")) {
            holder.ed_price.setText(cMoney);
        }
        if (workType.getCooperate_range() == 2) {
            // 包工
            holder.rg_cooperate_range.check(R.id.rb_all);
            holder.rea_hour.setVisibility(View.GONE);
            holder.rea_month.setVisibility(View.VISIBLE);

            if (workType.getBalanceway().equals("平方")) {
                // holder.rb_dayOrMonth.check(R.id.rb_day);
                holder.rb_top1.setChecked(true);
                holder.rb_top2.setChecked(false);
                holder.rb_bottom1.setChecked(false);
                holder.rb_bottom2.setChecked(false);
            } else if (workType.getBalanceway().equals("立方")) {
                // holder.rb_dayOrMonth.check(R.id.rb_month);
                holder.rb_top1.setChecked(false);
                holder.rb_top2.setChecked(true);
                holder.rb_bottom1.setChecked(false);
                holder.rb_bottom2.setChecked(false);
            } else if (workType.getBalanceway().equals("米")) {
                // holder.rb_dayOrMonth.check(R.id.rb_day);
                holder.rb_top1.setChecked(false);
                holder.rb_top2.setChecked(false);
                holder.rb_bottom1.setChecked(true);
                holder.rb_bottom2.setChecked(false);

            } else if (workType.getBalanceway().equals("吨")) {
                // holder.rb_dayOrMonth.check(R.id.rb_month);
                holder.rb_top1.setChecked(false);
                holder.rb_top2.setChecked(false);
                holder.rb_bottom1.setChecked(false);
                holder.rb_bottom2.setChecked(true);
            }

        } else if (workType.getCooperate_range() == 1) {
            // 点工
            holder.rg_cooperate_range.check(R.id.rb_hour);
            holder.rea_hour.setVisibility(View.VISIBLE);
            holder.rea_month.setVisibility(View.GONE);

            if (workType.getBalanceway().equals("天")) {
                holder.rb_dayOrMonth.check(R.id.rb_day);

            } else if (workType.getBalanceway().equals("月")) {
                holder.rb_dayOrMonth.check(R.id.rb_month);
            }
        }

        holder.ed_peoplecount.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before,
                                      int count) {
                if (s.toString().equals("0")) {
                    holder.ed_peoplecount.setText("");
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                if (!s.toString().equals("") && !s.toString().equals("0")) {
                    list.get(position).setPerson_count(s.toString());
                }
            }
        });
        holder.ed_price.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before,
                                      int count) {
                if (s.toString().equals("0")) {
                    holder.ed_price.setText("");

                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                if (!s.toString().equals("") && !s.toString().equals("0")) {
                    list.get(position).setMoney(s.toString());
                    holder.tv_price.setText(list.get(position).getMoney()
                            + "元/" + list.get(position).getBalanceway());
                }
            }
        });
        if (list.size() > 1) {
            holder.tv_delete.setVisibility(View.VISIBLE);
        } else {
            holder.tv_delete.setVisibility(View.GONE);
        }
        holder.tv_delete.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                clickListener.deleteClick(position);
            }
        });
        return convertView;
    }

    class ViewHolder {
        // 包工,点工
        RadioGroup rg_cooperate_range;
        // 熟练度
        RadioGroup rg_work_level;
        // 人数
        EditText ed_peoplecount;
        // 价钱
        EditText ed_price;
        // 删除按钮
        TextView tv_delete;
        // 包工单位平方
        RadioButton rb_top1;
        // 包工单位平方
        RadioButton rb_top2;
        // 包工单位立方
        RadioButton rb_bottom1;
        // 包工单位米
        RadioButton rb_bottom2;
        // 包工单位吨
        RadioGroup rb_dayOrMonth;
        // 包工单位天
        RelativeLayout rea_hour;
        // 包工月天
        LinearLayout rea_month;
        // 工种
        TextView tv_name;
        // 总价
        TextView tv_price;
    }

    public interface DeleteClickListener {
        void deleteClick(int pos);
    }

}
