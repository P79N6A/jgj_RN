package com.jizhi.jlongg.main.strategy;

import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.CreateTeamGroupActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Recruit;
import com.jizhi.jlongg.main.bean.RecruitDetail;
import com.jizhi.jlongg.main.util.CalculateDistanceUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jongg.widget.MultipleTextViewGroup;

/**
 * 班组、项目组策略
 *
 * @author Xuj
 * @time 2018年6月19日14:29:38
 * @Version 1.0
 */
public class FindJobStrategy extends MainStrategy {


    /**
     * activity
     */
    private BaseActivity activity;
    /**
     * 第一条数据需要展示的内容
     */
    private View firstItemTips;
    /**
     * 项目标题
     */
    private TextView proTitle;
    /**
     * 项目描述
     */
    private TextView proDescription;
    /**
     * 发布时间描述
     */
    private TextView createTimeTxt;
    /**
     * 单价
     */
    private TextView money;
    /**
     * 单价单位
     */
    private TextView moneyUnit;
    /**
     * 总规模
     */
    private TextView totalScale;
    /**
     * 总规模单位
     */
    private TextView totalScaleUnit;
    /**
     * 工种类型
     */
    private TextView workType;
    /**
     * 项目类型
     */
    private TextView proType;
    /**
     * 金额标题
     */
    private TextView moneyTitle;
    /**
     * 规模标题
     */
    private TextView totalScaleTitle;
    /**
     * 查看更多
     */
    private View searchMoreTxt;
    /**
     * 福利
     */
    private MultipleTextViewGroup welfareWeight;
    /**
     * 待遇布局
     */
    private View welfareLayout;
    /**
     * 找工作 点击按钮的回调
     */
    private FindJobClickBtnListener listener;
    /**
     * 无数据时展示的第一条内容
     */
    private View noDataBottomLayout;


    public FindJobStrategy(BaseActivity activity, FindJobClickBtnListener listener) {
        this.activity = activity;
        this.listener = listener;
    }


    @Override
    public View getView(LayoutInflater inflater) {
        View convertView = inflater.inflate(R.layout.new_work_circle_recruit, null, false);
        setView(convertView);
        return convertView;
    }

    @Override
    void setView(View convertView) {
        noDataBottomLayout = convertView.findViewById(R.id.noDataBottomLayout);
        firstItemTips = convertView.findViewById(R.id.firstTips);
        workType = (TextView) convertView.findViewById(R.id.work_type);
        proType = (TextView) convertView.findViewById(R.id.pro_type);
        proTitle = (TextView) convertView.findViewById(R.id.pro_title);
        proDescription = (TextView) convertView.findViewById(R.id.pro_description);
        createTimeTxt = (TextView) convertView.findViewById(R.id.create_time_txt);
        money = (TextView) convertView.findViewById(R.id.money);
        moneyUnit = (TextView) convertView.findViewById(R.id.money_unit);
        totalScale = (TextView) convertView.findViewById(R.id.total_scale);
        totalScaleUnit = (TextView) convertView.findViewById(R.id.total_scale_unit);
        searchMoreTxt = convertView.findViewById(R.id.search_more_txt);
        moneyTitle = (TextView) convertView.findViewById(R.id.money_title);
        totalScaleTitle = (TextView) convertView.findViewById(R.id.total_scale_title);
        welfareWeight = (MultipleTextViewGroup) convertView.findViewById(R.id.welfare);
        welfareLayout = convertView.findViewById(R.id.welfare_layout);

        TextView desc1 = (TextView) convertView.findViewById(R.id.desc1);
        desc1.setText(Html.fromHtml("<font color='#999999'>点击右上角</font><font color='#eb4e4e'> \"+\" </font><font color='#999999'>按钮即可</font>"));

        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.unLoginScanCodeText: //扫描二维码
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, CaptureActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.unLoginCreateTeam: //创建班组
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, CreateTeamGroupActivity.class)) {
                            return;
                        }
                        break;
                }
            }
        };
        convertView.findViewById(R.id.unLoginCreateTeam).setOnClickListener(onClickListener);
        convertView.findViewById(R.id.unLoginScanCodeText).setOnClickListener(onClickListener);
    }

    @Override
    public void bindData(Object object, View convertView, final int position) {
        Recruit recruit = (Recruit) object;
        if (recruit == null) {
            return;
        }
        noDataBottomLayout.setVisibility(position == 0 && UclientApplication.getRoler(activity.getApplicationContext()).equals(Constance.ROLETYPE_FM) ? View.VISIBLE : View.GONE);
        firstItemTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
        searchMoreTxt.setVisibility(position == 2 ? View.VISIBLE : View.GONE);
        if (recruit.getClasses() != null && recruit.getClasses().size() > 0) {
            RecruitDetail recruitDetail = recruit.getClasses().get(0);
            workType.setText(recruitDetail.getCooperate_type().getType_name());
            proType.setText(recruitDetail.getPro_type().getType_name());
            switch (recruitDetail.getCooperate_type().getType_id()) {
                case 1:
                    Utils.setBackGround(workType, activity.getResources().getDrawable(R.drawable.bg_eb7a4e_3radius));
                    break;
                case 2:
                    Utils.setBackGround(workType, activity.getResources().getDrawable(R.drawable.bg_eb4e4e_3radius));
                    break;
                case 3:
                    Utils.setBackGround(workType, activity.getResources().getDrawable(R.drawable.bg_ebaa4e_3radius));
                    break;
            }
            String[] moneyUnitArray = getMoneyString(recruitDetail);
            if (moneyUnitArray != null && moneyUnitArray.length > 0) { //设置价格
                moneyTitle.setText(moneyUnitArray[0]);
                money.setText(moneyUnitArray[1]);
                if (!TextUtils.isEmpty(moneyUnitArray[2])) {
                    moneyUnit.setVisibility(View.VISIBLE);
                    moneyUnit.setText(moneyUnitArray[2]);
                } else {
                    moneyUnit.setVisibility(View.GONE);
                }
            }

            String[] totalScaleUnitArray = getTotalScaleString(recruitDetail);
            if (totalScaleUnitArray != null && totalScaleUnitArray.length > 0) { //设置价格
                totalScaleTitle.setText(totalScaleUnitArray[0]);
                totalScale.setText(totalScaleUnitArray[1]);
                if (!TextUtils.isEmpty(totalScaleUnitArray[2])) {
                    totalScaleUnit.setVisibility(View.VISIBLE);
                    totalScaleUnit.setText(totalScaleUnitArray[2]);
                } else {
                    totalScaleUnit.setVisibility(View.GONE);
                }
            }
        }
        proTitle.setText(recruit.getPro_title());
        proDescription.setText(recruit.getPro_description());
        double[] proLocaltion = recruit.getPro_location();
        createTimeTxt.setText(recruit.getCreate_time_txt() + "发布/" + CalculateDistanceUtil.DistanceOfTwoPointsString(activity, proLocaltion[1], proLocaltion[0]));
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.searchMore();
                }
            }
        };
        firstItemTips.setOnClickListener(onClickListener);
        searchMoreTxt.setOnClickListener(onClickListener);
        convertView.setOnClickListener(onClickListener);
        if (recruit.getWelfare() != null && recruit.getWelfare().size() > 0) {
            welfareLayout.setVisibility(View.VISIBLE);
            welfareWeight.setTextViews(recruit.getWelfare());
        } else {
            welfareLayout.setVisibility(View.GONE);
        }
    }


    /**
     * 获取单价或总价
     *
     * @return
     */
    public String[] getMoneyString(RecruitDetail recruitDetail) {
        String[] str = new String[3];
        double money = recruitDetail.getMoney();
        //只有包工或者总包才会有工程规模
        if (recruitDetail.getCooperate_type().getType_id() == 3 || (recruitDetail.getCooperate_type().getType_id() == 2 && recruitDetail.getContractor() == 1)) {
            double unitMoney = recruitDetail.getUnitMoney();
            str[0] = unitMoney == 0 && money != 0 ? "总价：" : "单价：";
            if (str[0].equals("总价：")) {
                if (money == 0) {
                    str[1] = "面议";
                } else {
                    if (money > 10000) {
                        str[1] = (Math.ceil(money / 100) / 100) + "万";
                        str[2] = "元";
                    } else {
                        str[1] = money + "";
                        str[2] = "元";
                    }
                }
            } else {
                if (unitMoney == 0) {
                    str[1] = "面议";
                } else {
                    if (unitMoney > 10000) {
                        str[1] = (Math.ceil(unitMoney / 100) / 100) + "万";
                        str[2] = "元/" + recruitDetail.getBalance_way();
                    } else {
                        str[1] = unitMoney + "";
                        str[2] = "元/" + recruitDetail.getBalance_way();
                    }
                }
            }
        } else { //点工
            str[0] = "人数：";
            str[1] = recruitDetail.getPerson_count();
            str[2] = "人";
        }
        return str;
    }

    /**
     * 获取总规模
     *
     * @return
     */
    public String[] getTotalScaleString(RecruitDetail recruitDetail) {
        String[] str = new String[3];
        //工程规模
        double totalScale = recruitDetail.getTotal_scale();
        //只有包工或者总包才会有工程规模
        if (recruitDetail.getCooperate_type().getType_id() == 3 || (recruitDetail.getCooperate_type().getType_id() == 2 && recruitDetail.getContractor() == 1)) {
            str[0] = "规模：";
            if (totalScale == 0) {
                str[1] = "面议";
            } else {
                if (totalScale > 10000) {
                    str[1] = (Math.ceil(totalScale / 100) / 100) + "万";
                    str[2] = recruitDetail.getBalance_way();
                } else {
                    str[1] = totalScale + "";
                    str[2] = recruitDetail.getBalance_way();
                }
            }
        } else { //点工
            double money = recruitDetail.getMoney();
            str[0] = "工资：";
            if (money > 10000) {
                str[1] = (Math.ceil(money / 100) / 100) + "万";
                str[2] = "元/" + recruitDetail.getBalance_way();
            } else {
                str[1] = money + "";
                str[2] = "元/" + recruitDetail.getBalance_way();
            }
        }
        return str;
    }

    /**
     * 找工作 点击按钮的回调
     */
    public interface FindJobClickBtnListener {
        public void searchMore();
    }
}
