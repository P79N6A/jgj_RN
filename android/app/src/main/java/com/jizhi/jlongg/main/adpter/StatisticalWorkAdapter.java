package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Paint;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.util.AccountUtil;

import java.util.List;

/**
 * 功能:记工统计适配器
 * 时间:2018年1月4日11:16:20
 * 作者:xuj
 */
public class StatisticalWorkAdapter extends BaseAdapter {
    /**
     * 记工统计
     */
    private List<StatisticalWork> list;
    /**
     * context
     */
    private Context context;
    /**
     * 是否显示日期,是否显示名称,是否显示未结工资
     */
    private boolean isShowDate, isShowName;
    /**
     * 显示金额布局的宽度
     */
    private int amountWidth;
    /**
     * 列表上已选的记工筛选条件
     * 如果选择了两个以上的两件 则显示全部的记工信息
     * 如果只选择了单条记工数据 则只显示当条记工数据
     */
    private String accountIds;
    /**
     * 是否显示分割线
     */
    private boolean isShowLine;


    private void calculateWidth(List<StatisticalWork> list) {
        if (list != null && list.size() > 0) {
            float allWidth = 0;
            Paint mPaint = new Paint();
            mPaint.setTextSize(DensityUtils.sp2px(context, 12)); //设置字体的大小
            for (StatisticalWork statisticalWork : list) {
                String littlerAmounts = statisticalWork.getWork_type().getAmounts(); //获取点工金额
                String contractOneAmounts = statisticalWork.getContract_type_one().getAmounts(); //获取包工(承包)金额
                String expendAmounts = statisticalWork.getExpend_type().getAmounts(); //获取借支金额
                String balanceAmount = statisticalWork.getBalance_type().getAmounts(); //获取结算金额
                String unBalanceAmount = statisticalWork.getBalance_amount(); //获取未结金额
                if (!TextUtils.isEmpty(littlerAmounts)) { //获取点工金额
                    float width = mPaint.measureText(littlerAmounts);
                    if (width > allWidth) {
                        allWidth = width;
                    }
                }
                if (!TextUtils.isEmpty(contractOneAmounts)) { //获取包工(承包)金额
                    float width = mPaint.measureText(contractOneAmounts);
                    if (width > allWidth) {
                        allWidth = width;
                    }
                }
                if (UclientApplication.isForemanRoler(context)) {
                    String contractTwoAmounts = statisticalWork.getContract_type_two().getAmounts(); //获取包工(分包)金额
                    if (!TextUtils.isEmpty(contractTwoAmounts)) { //获取包工(分包)金额
                        float width = mPaint.measureText(contractTwoAmounts);
                        if (width > allWidth) {
                            allWidth = width;
                        }
                    }
                }
                if (!TextUtils.isEmpty(expendAmounts)) { //获取借支金额
                    float width = mPaint.measureText(expendAmounts);
                    if (width > allWidth) {
                        allWidth = width;
                    }
                }
                if (!TextUtils.isEmpty(balanceAmount)) { //获取结算金额
                    float width = mPaint.measureText(balanceAmount);
                    if (width > allWidth) {
                        allWidth = width;
                    }
                }
                if (!TextUtils.isEmpty(unBalanceAmount)) { //获取未结金额
                    float width = mPaint.measureText(unBalanceAmount);
                    if (width > allWidth) {
                        allWidth = width;
                    }
                }
            }
            amountWidth = (int) Math.ceil((allWidth));
            amountWidth += DensityUtils.dp2px(context, 2); //为了保证能装下在加3dp
        }
    }


    public StatisticalWorkAdapter(Context context, List<StatisticalWork> list, boolean isShowDate, boolean isShowName, boolean isShowLine) {
        this.list = list;
        this.context = context;
        this.isShowDate = isShowDate;
        this.isShowName = isShowName;
        this.isShowLine = isShowLine;
        calculateWidth(list);
    }


    public void updateListView(List<StatisticalWork> list) {
        this.list = list;
        calculateWidth(list);
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public StatisticalWork getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.statistical_work_item, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        StatisticalWork statisticalWork = getItem(position);
        if (isShowDate) {
            holder.date.setText(statisticalWork.getDate());
        }
        if (isShowName) {
            holder.name.setText(statisticalWork.getTarget_name());
        }
        boolean isForeman = UclientApplication.isForemanRoler(context);
        if (!TextUtils.isEmpty(accountIds)) {
            String[] accounIds = accountIds.split(",");
            if (accounIds.length == 1) {
                //如果筛选条件只选择了某一项记工数据 则只填充那一项数据
                switch (accounIds[0]) {
                    case AccountUtil.HOUR_WORKER: //点工

                        holder.manhour.setVisibility(View.VISIBLE);
                        holder.overTime.setVisibility(View.VISIBLE);
                        holder.contractorWorkCount.setVisibility(View.GONE); //隐藏包工笔数
                        holder.borrowCount.setVisibility(View.GONE); //隐藏借支笔数
                        holder.balanceCount.setVisibility(View.GONE); //隐藏结算笔数

                        holder.littleWorkAmount.setVisibility(View.VISIBLE);
                        holder.contractorWorkTwoAmount.setVisibility(View.GONE);//隐藏包工分包金额
                        holder.contractorWorkOneAmount.setVisibility(View.GONE); //隐藏包工承包金额
                        holder.borrowAmount.setVisibility(View.GONE); //隐藏借支金额
                        holder.balanceAmount.setVisibility(View.GONE); //隐藏未结金额

                        holder.littleWorkText.setVisibility(View.VISIBLE);
                        holder.contractorWorkOneText.setVisibility(View.GONE);
                        holder.contractorWorkTwoText.setVisibility(View.GONE);
                        holder.borrowText.setVisibility(View.GONE);
                        holder.balanceText.setVisibility(View.GONE);

                        holder.contracotrDay.setVisibility(View.GONE);
                        break;
                    case AccountUtil.CONSTRACTOR: //包工
                        holder.manhour.setVisibility(View.GONE);
                        holder.overTime.setVisibility(View.GONE);
                        holder.contractorWorkCount.setVisibility(View.VISIBLE);
                        holder.borrowCount.setVisibility(View.GONE); //隐藏借支笔数
                        holder.balanceCount.setVisibility(View.GONE); //隐藏结算笔数

                        holder.littleWorkAmount.setVisibility(View.GONE);
                        //班组长角色：包工（分包）算收入金额红色显示，包工（承包）算支出绿色显示
                        //4、工人角色：工人只有包工（承包），算收入红色显示
                        if (isForeman) {
                            holder.contractorWorkOneAmount.setVisibility(View.VISIBLE);
                            holder.contractorWorkTwoAmount.setVisibility(View.VISIBLE);

                            holder.contractorWorkOneText.setVisibility(View.VISIBLE);
                            holder.contractorWorkTwoText.setVisibility(View.VISIBLE);
                        } else {
                            holder.contractorWorkOneAmount.setVisibility(View.VISIBLE);
                            holder.contractorWorkTwoAmount.setVisibility(View.GONE);

                            holder.contractorWorkOneText.setVisibility(View.VISIBLE);
                            holder.contractorWorkTwoText.setVisibility(View.GONE);
                        }

                        holder.borrowAmount.setVisibility(View.GONE); //隐藏借支金额
                        holder.balanceAmount.setVisibility(View.GONE); //隐藏结算金额

                        holder.littleWorkText.setVisibility(View.GONE);

                        holder.borrowText.setVisibility(View.GONE);
                        holder.balanceText.setVisibility(View.GONE);
                        holder.contracotrDay.setVisibility(View.GONE);
                        break;
                    case AccountUtil.BORROWING: //借支
                        holder.manhour.setVisibility(View.GONE);
                        holder.overTime.setVisibility(View.GONE);
                        holder.contractorWorkCount.setVisibility(View.GONE); //隐藏包工笔数
                        holder.borrowCount.setVisibility(View.VISIBLE);
                        holder.balanceCount.setVisibility(View.GONE); //隐藏结算笔数

                        holder.littleWorkAmount.setVisibility(View.GONE);
                        holder.contractorWorkTwoAmount.setVisibility(View.GONE);//隐藏包工分包金额
                        holder.contractorWorkOneAmount.setVisibility(View.GONE); //隐藏包工承包金额
                        holder.borrowAmount.setVisibility(View.VISIBLE);
                        holder.balanceAmount.setVisibility(View.GONE); //隐藏结算金额

                        holder.littleWorkText.setVisibility(View.GONE);
                        holder.contractorWorkOneText.setVisibility(View.GONE);
                        holder.contractorWorkTwoText.setVisibility(View.GONE);
                        holder.borrowText.setVisibility(View.VISIBLE);
                        holder.balanceText.setVisibility(View.GONE);
                        holder.contracotrDay.setVisibility(View.GONE);
                        break;
                    case AccountUtil.SALARY_BALANCE: //结算
                        holder.manhour.setVisibility(View.GONE);
                        holder.overTime.setVisibility(View.GONE);
                        holder.contractorWorkCount.setVisibility(View.GONE); //隐藏包工笔数
                        holder.borrowCount.setVisibility(View.GONE); //隐藏借支笔数
                        holder.balanceCount.setVisibility(View.VISIBLE); //隐藏结算笔数

                        holder.littleWorkAmount.setVisibility(View.GONE);
                        holder.contractorWorkTwoAmount.setVisibility(View.GONE);//隐藏包工分包金额
                        holder.contractorWorkOneAmount.setVisibility(View.GONE); //隐藏包工承包金额
                        holder.borrowAmount.setVisibility(View.GONE); //隐藏借支金额
                        holder.balanceAmount.setVisibility(View.VISIBLE); //隐藏结算金额

                        holder.littleWorkText.setVisibility(View.GONE);
                        holder.contractorWorkOneText.setVisibility(View.GONE);
                        holder.contractorWorkTwoText.setVisibility(View.GONE);
                        holder.borrowText.setVisibility(View.GONE);
                        holder.balanceText.setVisibility(View.VISIBLE);
                        holder.contracotrDay.setVisibility(View.GONE);
                        break;
                    case AccountUtil.CONSTRACTOR_CHECK: //包工记工天
                        holder.manhour.setVisibility(View.VISIBLE);
                        holder.overTime.setVisibility(View.VISIBLE);
                        holder.contractorWorkCount.setVisibility(View.GONE); //隐藏包工笔数
                        holder.borrowCount.setVisibility(View.GONE); //隐藏借支笔数
                        holder.balanceCount.setVisibility(View.GONE); //隐藏结算笔数

                        holder.littleWorkAmount.setVisibility(View.GONE);
                        holder.contractorWorkTwoAmount.setVisibility(View.GONE);//隐藏包工分包金额
                        holder.contractorWorkOneAmount.setVisibility(View.GONE); //隐藏包工承包金额
                        holder.borrowAmount.setVisibility(View.GONE); //隐藏借支金额
                        holder.balanceAmount.setVisibility(View.GONE); //隐藏未结金额

                        holder.littleWorkText.setVisibility(View.GONE);
                        holder.contractorWorkOneText.setVisibility(View.GONE);
                        holder.contractorWorkTwoText.setVisibility(View.GONE);
                        holder.borrowText.setVisibility(View.GONE);
                        holder.balanceText.setVisibility(View.GONE);

                        holder.contracotrDay.setVisibility(View.VISIBLE);
                        break;
                }
            } else {
                showAllView(holder, isForeman);
            }
        } else {
            showAllView(holder, isForeman);
        }


        if (holder.manhour.getVisibility() == View.VISIBLE) {
            holder.manhour.setText(AccountUtil.getAccountShowTypeString(context, true, true, true, statisticalWork.getWork_type().getManhour(), statisticalWork.getWork_type().getWorking_hours()));
        }
        if (holder.overTime.getVisibility() == View.VISIBLE) {
            holder.overTime.setText(AccountUtil.getAccountShowTypeString(context, true, true, false, statisticalWork.getWork_type().getOvertime(), statisticalWork.getWork_type().getOvertime_hours()));
        }
        if (holder.contractorWorkCount.getVisibility() == View.VISIBLE) {
            holder.contractorWorkCount.setText(String.format(context.getString(R.string.contractor_params), (int) statisticalWork.getContract_type().getTotal())); //设置包工 笔数
        }
        if (holder.borrowCount.getVisibility() == View.VISIBLE) {
            holder.borrowCount.setText(String.format(context.getString(R.string.borrow_params), (int) statisticalWork.getExpend_type().getTotal())); //设置借支笔数
        }
        if (holder.balanceCount.getVisibility() == View.VISIBLE) {
            holder.balanceCount.setText(String.format(context.getString(R.string.balance_params), (int) statisticalWork.getBalance_type().getTotal())); //设置结算笔数
        }
        if (holder.littleWorkAmount.getVisibility() == View.VISIBLE) {
            holder.littleWorkAmount.setText(statisticalWork.getWork_type().getAmounts()); //设置点工金额
        }
        if (holder.contractorWorkTwoAmount.getVisibility() == View.VISIBLE) {
            // 班组长角色：包工（分包）算收入金额红色显示，包工（承包）算支出绿色显示
            // 4、工人角色：工人只有包工（承包），算收入红色显示
            holder.contractorWorkTwoAmount.setText(statisticalWork.getContract_type_two().getAmounts()); //设置包工承包金额
        }
        if (holder.contractorWorkOneAmount.getVisibility() == View.VISIBLE) {
            holder.contractorWorkOneAmount.setText(statisticalWork.getContract_type_one().getAmounts()); //设置包工分包金额
            holder.contractorWorkOneAmount.setTextColor(ContextCompat.getColor(context, isForeman ? R.color.borrow_color : R.color.color_eb4e4e));
        }
        if (holder.borrowAmount.getVisibility() == View.VISIBLE) {
            holder.borrowAmount.setText(statisticalWork.getExpend_type().getAmounts()); //设置借支金额
        }
        if (holder.balanceAmount.getVisibility() == View.VISIBLE) {
            holder.balanceAmount.setText(statisticalWork.getBalance_type().getAmounts());//设置结算金额
        }

        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.amountLayout.getLayoutParams();
        params.width = amountWidth;
        holder.amountLayout.setLayoutParams(params);
        if (isShowLine) {
            holder.line.setVisibility(position == 0 ? View.GONE : View.VISIBLE);
            holder.backgroundLine.setVisibility(View.GONE);
        } else {
            holder.line.setVisibility(View.GONE);
            holder.backgroundLine.setVisibility(View.VISIBLE);
        }
    }

    public void showAllView(ViewHolder holder, boolean isForeman) {
        holder.manhour.setVisibility(View.VISIBLE);
        holder.overTime.setVisibility(View.VISIBLE);
        holder.borrowCount.setVisibility(View.VISIBLE);
        holder.balanceCount.setVisibility(View.VISIBLE);


        //班组长角色：包工（分包）算收入金额红色显示，包工（承包）算支出绿色显示
        //4、工人角色：工人只有包工（承包），算收入红色显示
        if (isForeman) {
            holder.contractorWorkTwoText.setVisibility(View.VISIBLE);
            holder.contractorWorkOneText.setVisibility(View.VISIBLE);

            holder.contractorWorkTwoAmount.setVisibility(View.VISIBLE);
            holder.contractorWorkOneAmount.setVisibility(View.VISIBLE);
            holder.contractorWorkCount.setVisibility(View.INVISIBLE);
        } else {
            holder.contractorWorkTwoText.setVisibility(View.GONE);
            holder.contractorWorkOneText.setVisibility(View.VISIBLE);

            holder.contractorWorkTwoAmount.setVisibility(View.GONE);
            holder.contractorWorkOneAmount.setVisibility(View.VISIBLE);
            holder.contractorWorkCount.setVisibility(View.GONE);
        }

        holder.littleWorkText.setVisibility(View.VISIBLE);
        holder.littleWorkAmount.setVisibility(View.VISIBLE);

        holder.borrowText.setVisibility(View.VISIBLE);
        holder.borrowAmount.setVisibility(View.VISIBLE);

        holder.balanceText.setVisibility(View.VISIBLE);
        holder.balanceAmount.setVisibility(View.VISIBLE);
        holder.contracotrDay.setVisibility(View.GONE);
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            date = (TextView) view.findViewById(R.id.date);
            backgroundLine = view.findViewById(R.id.divierLine);
            line = view.findViewById(R.id.line);

            name = (TextView) view.findViewById(R.id.name);
            manhour = (TextView) view.findViewById(R.id.manhour);
            overTime = (TextView) view.findViewById(R.id.overTime);
            contractorWorkCount = (TextView) view.findViewById(R.id.contractorWorkCount);
            borrowCount = (TextView) view.findViewById(R.id.borrowCount);
            balanceCount = (TextView) view.findViewById(R.id.balanceCount);

            amountLayout = view.findViewById(R.id.amountLayout);


            littleWorkAmount = (TextView) view.findViewById(R.id.littleWorkAmount);
            contractorWorkOneAmount = view.findViewById(R.id.contractorWorkOneAmount);
            contractorWorkTwoAmount = view.findViewById(R.id.contractorWorkTwoAmount);

            borrowAmount = (TextView) view.findViewById(R.id.borrowAmount);
            balanceAmount = (TextView) view.findViewById(R.id.balanceAmount);

            contracotrDay = view.findViewById(R.id.contracotr_day);

            name.setVisibility(isShowName ? View.VISIBLE : View.GONE);
            date.setVisibility(isShowDate ? View.VISIBLE : View.GONE);


            littleWorkText = view.findViewById(R.id.littleWorkText);
            contractorWorkTwoText = view.findViewById(R.id.contractorWorkTwoText);
            contractorWorkOneText = view.findViewById(R.id.contractorWorkOneText);

            borrowText = view.findViewById(R.id.borrowText);
            balanceText = view.findViewById(R.id.balanceText);

        }


        /**
         * 日期
         */
        private TextView date;
        /**
         * 分割线
         */
        private View backgroundLine;
        /**
         * 分割线
         */
        private View line;
        /**
         * 工头、班组长名称
         */
        private TextView name;
        /**
         * 上班合计
         */
        private TextView manhour;
        /**
         * 加班合计
         */
        private TextView overTime;
        /**
         * 包工笔数
         */
        private TextView contractorWorkCount;
        /**
         * 借支笔数
         */
        private TextView borrowCount;
        /**
         * 结算笔数
         */
        private TextView balanceCount;
        /**
         * 点工金额
         */
        private TextView littleWorkAmount;
        /**
         * 包工分包金额
         */
        private TextView contractorWorkTwoAmount;
        /**
         * 包工承包金额
         */
        private TextView contractorWorkOneAmount;
        /**
         * 借支金额
         */
        private TextView borrowAmount;
        /**
         * 结算金额
         */
        private TextView balanceAmount;
        /**
         * 包工记工天金额
         */
        private TextView contracotrDay;
        /**
         * 金额布局 主要是做动态计算宽度的
         */
        private View amountLayout;
        /**
         * 点工 文本描述
         */
        private View littleWorkText;
        /**
         * 包工分包描述
         */
        private View contractorWorkTwoText;
        /**
         * 包工承包描述
         */
        private View contractorWorkOneText;
        /**
         * 借支 文本描述
         */
        private View borrowText;
        /**
         * 结算 文本描述
         */
        private View balanceText;
    }


    public List<StatisticalWork> getList() {
        return list;
    }

    public void setList(List<StatisticalWork> list) {
        this.list = list;
    }


    public String getAccountIds() {
        return accountIds;
    }

    public void setAccountIds(String accountIds) {
        this.accountIds = accountIds;
    }
}
