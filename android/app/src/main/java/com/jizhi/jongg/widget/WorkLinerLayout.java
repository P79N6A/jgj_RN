package com.jizhi.jongg.widget;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkInfomation;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;

import java.util.List;

/**
 * 工种信息
 */
@SuppressLint("NewApi")
public class WorkLinerLayout extends LinearLayout {


    private int margin_top;

    public WorkLinerLayout(Context context) {
        super(context);
    }

    public WorkLinerLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public WorkLinerLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        TypedArray array = context.obtainStyledAttributes(attrs, R.styleable.WorkLinerLayout);
        margin_top = array.getDimensionPixelSize(R.styleable.WorkLinerLayout_worklevel_margin_top, DensityUtils.dp2px(context, 8));
        array.recycle();
    }


    /**
     * @param context
     * @param list    需要填充的数据
     */
    public void createSonView(Context context, List<WorkInfomation> list) {
        try {
            Resources res = context.getResources();
            LayoutInflater inflater = LayoutInflater.from(context);
            if (list != null && list.size() > 0) {
                for (WorkInfomation bean : list) {
                    View convertView = createView(bean.getCooperate_type().getType_id() + "", inflater, res, bean);
                    if (convertView != null) {
                        addView(convertView);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, "工种信息读取出错!", CommonMethod.ERROR);
        }
    }


    /**
     * 点工
     */
    class HourWorkHolder {
        /**
         * 所需人数
         */
        TextView number;
        /**
         * 工种类型
         */
        TextView workType;
        /**
         * 计价单位
         */
        TextView balanceway;
        /**
         * 金额
         */
        TextView money;

        public HourWorkHolder(View view) {
            number = (TextView) view.findViewById(R.id.number); //所需人数
            workType = (TextView) view.findViewById(R.id.workType); //工种类型
            balanceway = (TextView) view.findViewById(R.id.balanceway); //计价单位
            money = (TextView) view.findViewById(R.id.money); //金额
        }
    }

    /**
     * 总包
     */
    class MainContractorHolder {
        /**
         * 规模
         */
        TextView total_scale;
        /**
         * 价格
         */
        TextView money_desc;
        /**
         * 工种类型
         */
        TextView workType;
        /**
         * 计价单位
         */
        TextView balanceway;
        /**
         * 金额
         */
        TextView money;

        public MainContractorHolder(View view) {
            total_scale = (TextView) view.findViewById(R.id.total_scale); //所需人数
            money_desc = (TextView) view.findViewById(R.id.money_desc); //工种类型
            workType = (TextView) view.findViewById(R.id.workType); //工种类型
            balanceway = (TextView) view.findViewById(R.id.balanceway); //计价单位
            money = (TextView) view.findViewById(R.id.money); //金额
        }
    }

    /**
     * 点工Layout
     */
    private View hourWorkerView;
    /**
     * 总包Layout
     */
    private View mainContractorView;

    /**
     * 创建点工Layout
     */
    private View createHourWorkerLayout(LayoutInflater inflater, Resources res, WorkInfomation bean, String type) {
        HourWorkHolder holder = null;
        if (hourWorkerView == null) {
            hourWorkerView = inflater.inflate(R.layout.worktype_hour, null);
            holder = new HourWorkHolder(hourWorkerView);
            hourWorkerView.setTag(holder);
        } else {
            holder = (HourWorkHolder) hourWorkerView.getTag();
        }
        holder.number.setText(bean.getPerson_count());
        holder.workType.setText(bean.getCooperate_type().getType_name());
        setBalanceWay(holder.balanceway, bean.getBalance_way(), true);
        setMoney(holder.money, bean.getMoney());
        switch (type) {
            case AccountUtil.CONSTRACTOR://包工
                Utils.setBackGround(holder.workType, res.getDrawable(R.drawable.bg_rd_eb4e4e_3radius));
                break;
            case AccountUtil.HOUR_WORKER: //点工
                Utils.setBackGround(holder.workType, res.getDrawable(R.drawable.bg_og_eb7a4e_3radius));
                break;
        }
        return hourWorkerView;
    }


    /**
     * 创建总包Layout
     */
    private View createMainContractorLayout(LayoutInflater inflater, Resources res, WorkInfomation bean, String type) {
        MainContractorHolder holder = null;
        if (mainContractorView == null) {
            mainContractorView = inflater.inflate(R.layout.worktype_main, null);
            holder = new MainContractorHolder(mainContractorView);
            mainContractorView.setTag(holder);
        } else {
            holder = (MainContractorHolder) mainContractorView.getTag();
        }
        holder.money_desc.setVisibility(bean.getMoney() == 0 ? View.GONE : View.VISIBLE);
        holder.workType.setText(bean.getCooperate_type().getType_name());
        setScale(holder.total_scale, Integer.parseInt(bean.getTotal_scale()));
        setBalanceWay(holder.balanceway, bean.getBalance_way(), false);
        setMoney(holder.money, bean.getMoney());
        switch (type) {
            case AccountUtil.CONSTRACTOR://包工
                Utils.setBackGround(holder.workType, res.getDrawable(R.drawable.bg_rd_eb4e4e_3radius));
                break;
            case Constance.MAIN_CONTRACTOR: //总包
                Utils.setBackGround(holder.workType, res.getDrawable(R.drawable.yellow_ebaa4e_background));
                break;
        }
        return mainContractorView;
    }


    private View createView(String type, LayoutInflater inflater, Resources res, WorkInfomation bean) {
        View view = null;
        switch (type) {
            case AccountUtil.HOUR_WORKER: //点工
                view = createHourWorkerLayout(inflater, res, bean, type);
                break;
            case AccountUtil.CONSTRACTOR: //包工
                if (bean.getContractor() == 1) { //总包 类型
                    view = createMainContractorLayout(inflater, res, bean, type);
                } else { //点工类型
                    view = createHourWorkerLayout(inflater, res, bean, type);
                }
                break;
            case Constance.MAIN_CONTRACTOR: //总包
                view = createMainContractorLayout(inflater, res, bean, type);
                break;
        }
        return view;
    }

    /**
     * 设置计价单位
     */
    private void setBalanceWay(TextView balancewayText, String balancewayValue, boolean isShowMoney) {
        if (!TextUtils.isEmpty(balancewayValue)) {
            if (isShowMoney) {
                balancewayText.setText("元/" + balancewayValue);
            } else {
                balancewayText.setText(balancewayValue);
            }
        } else {
            balancewayText.setText(null);
        }
    }

    /**
     * 设置金额
     *
     * @param money
     * @param moneyValue
     */
    private void setMoney(TextView money, float moneyValue) {
        if (moneyValue == 0) {
            money.setText("面议");
        } else if (moneyValue > 0 && moneyValue < 10000) {
            money.setText(Utils.m2(((double) moneyValue)));
        } else {
            money.setText(Utils.m2((double) (moneyValue / 10000)) + "万");
        }
    }

    /**
     * 设置规模
     */
    private void setScale(TextView total_scale, float total_scaleValue) {
        if (total_scaleValue == 0) {
            total_scale.setText("较大");
        } else if (total_scaleValue > 0 && total_scaleValue < 10000) {
            total_scale.setText(total_scaleValue + "");
        } else {
            total_scale.setText(Utils.m2((double) (total_scaleValue / 10000)) + "万");
        }
    }
}
