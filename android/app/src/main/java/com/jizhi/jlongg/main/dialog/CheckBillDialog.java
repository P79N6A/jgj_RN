package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.AccountAllEditActivty;
import com.jizhi.jlongg.account.AccountEditActivity;
import com.jizhi.jlongg.account.AccountWagesEditActivty;
import com.jizhi.jlongg.main.adpter.CheckBillAdapter;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.CheckBillAllAccount;
import com.jizhi.jlongg.main.bean.CheckBillInfo;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;

import java.util.ArrayList;
import java.util.List;

/**
 * 核对账单
 *
 * @author llong
 * @version 1.0
 * @time 2016-2-3 下午25032
 */
public class CheckBillDialog extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {

    private Activity context;
    /**
     * 工种类型
     */
    private String accountType;
    /**
     * 流水详情
     */
    private DiffBill diffBill;
    /**
     * 复制账单回调
     */
    private MpoorinfoCLickListener mpoorinfoCLickListener;

    private View popView;
    //记账id
    private int account_id;
    //角色
    private String role_type;
    //true,待确认记账
    private boolean isRecoedWork;

    private AgencyGroupUser agencyGroupUser;


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.layout_checkbill, null);
        setContentView(popView);
        //设置SelectPicPopupWindow弹出窗体的宽
        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        //设置SelectPicPopupWindow弹出窗体的高
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体可点击
        setFocusable(true);
        //设置SelectPicPopupWindow弹出窗体动画效果
        setAnimationStyle(R.style.ActionSheetDialogAnimation);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0xb0000000);
        //设置SelectPicPopupWindow弹出窗体的背景
        setOnDismissListener(this);
        setBackgroundDrawable(dw);
        setOutsideTouchable(true);
    }

    public CheckBillDialog(Activity context, String accountType, DiffBill diffBill, MpoorinfoCLickListener mpoorinfoCLickListener) {
        super(context);
        this.context = context;
        this.accountType = accountType;
        this.diffBill = diffBill;
        this.mpoorinfoCLickListener = mpoorinfoCLickListener;
        setPopView();
        initValue();
    }

    public CheckBillDialog(Activity context, String accountType, DiffBill diffBill, int account_id, String role_type, AgencyGroupUser agencyGroupUser, MpoorinfoCLickListener mpoorinfoCLickListener, boolean isRecoedWork) {
        super(context);
        this.context = context;
        this.accountType = accountType;
        this.diffBill = diffBill;
        this.account_id = account_id;
        this.role_type = role_type;
        this.agencyGroupUser = agencyGroupUser;
        this.mpoorinfoCLickListener = mpoorinfoCLickListener;
        this.isRecoedWork = isRecoedWork;
        setPopView();
        initValue();
    }

    public CheckBillDialog(Activity context, String accountType, DiffBill diffBill, int account_id, String role_type,
                           MpoorinfoCLickListener mpoorinfoCLickListener, boolean isRecoedWork) {
        super(context);
        this.context = context;
        this.accountType = accountType;
        this.diffBill = diffBill;
        this.account_id = account_id;
        this.role_type = role_type;

        this.mpoorinfoCLickListener = mpoorinfoCLickListener;
        this.isRecoedWork = isRecoedWork;
        setPopView();
        initValue();
    }


    public void setValue(String origin, DiffBill diffBill) {
        this.accountType = origin;
        this.diffBill = diffBill;
        initValue();
    }

    public void setValue(String origin, DiffBill diffBill, int account_id, String role_type) {
        this.accountType = origin;
        this.diffBill = diffBill;
        this.account_id = account_id;
        this.role_type = role_type;
        initValue();
    }


    private void initValue() {
        //日期
        ((TextView) popView.findViewById(R.id.tv_date)).setText(diffBill.getDate());
        //标题
        TextView titleText = popView.findViewById(R.id.title);
        String text = diffBill.getDescribe();
        if (text.contains(diffBill.getSecond_name_mark())) {
            String[] strArray = text.split(diffBill.getSecond_name_mark());
            if (null != strArray && strArray.length == 2) {
                titleText.setText(Html.fromHtml(strArray[0] + "<font color='#eb4e4e'> " + diffBill.getSecond_name_mark() + " </font>" + strArray[1]));
            } else if (null != strArray && strArray.length == 1) {
                titleText.setText(Html.fromHtml("<font color='#eb4e4e'> " + diffBill.getSecond_name_mark() + " </font>" + strArray[0]));
            } else {
                titleText.setText(text);
            }
        } else {
            titleText.setText(text);
        }
        //工人工头名字信息
        List<CheckBillInfo> list = new ArrayList<>();
        list.add(new CheckBillInfo(null, diffBill.getSecond_name(), diffBill.getMain_name(), CheckBillAdapter.HEAD));


        boolean isHourWorker = false;
        String title = null;
        switch (accountType) {
            case AccountUtil.HOUR_WORKER: //点工
                title = "点工";
                isHourWorker = true;
                create_hourwork(list);
                break;
            case AccountUtil.CONSTRACTOR_CHECK: //考勤点工
                title = "包工记工天";
                isHourWorker = true;
                create_hourwork(list);
                break;
            case AccountUtil.CONSTRACTOR: //包工
                title = "包工";
                create_constractor(list);
                break;
            case AccountUtil.BORROWING: //借支
                title = "借支";
                create_borrowing(list);
                break;
            case AccountUtil.SALARY_BALANCE: //结算
                title = "结算";
                create_wagesing(list, role_type);
                break;
        }
        //3.4.1.左右显示内容交换位置  自己的数据显示在右边
        CheckBillAdapter adapter = new CheckBillAdapter(context, list, isHourWorker, diffBill, accountType, this, title);
        ListView listView = popView.findViewById(R.id.listview);
        listView.setAdapter(adapter);
        popView.findViewById(R.id.cancel).setOnClickListener(this);
        popView.findViewById(R.id.tv_agree).setOnClickListener(this);
        popView.findViewById(R.id.tv_change).setOnClickListener(this);
        //3.1.0--->结算类型同意他的记工修改为同意
        if (accountType.equals(AccountUtil.SALARY_BALANCE)) {
            ((Button) popView.findViewById(R.id.tv_agree)).setText("同意");
        }
    }


    /**
     * 点工
     */
    public void create_hourwork(List<CheckBillInfo> list) {
        double second_w_h_tpl = diffBill.getSecond_w_h_tpl(); //记账对象记账模板正常工作时长
        double second_o_h_tpl = diffBill.getSecond_o_h_tpl(); //记账对象记账模板加班工作时长
        int main_hour_type = diffBill.getMain_hour_type();
        int second_hour_type = diffBill.getSecond_hour_type();
        Salary otherTpl = new Salary(); //记账对象薪资模板
        otherTpl.setW_h_tpl(second_w_h_tpl);
        otherTpl.setO_h_tpl(second_o_h_tpl);
        CheckBillInfo bean1 = new CheckBillInfo("上班", CheckBillAdapter.SALARY);
//        CheckBillInfo bean2 = new CheckBillInfo("加班", CheckBillAdapter.CONTENT);
        CheckBillInfo bean3 = new CheckBillInfo("工资", CheckBillAdapter.SALARY);
        //左边
        if (diffBill.getSecond_line() == 1 || diffBill.getSecond_line() == 2) {
            bean1.setW_h_tpl_my(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean1.setO_h_tpl_my(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean1.setO_h_tpl_my(diffBill.getSecond_line() == 1 ? "-" : "-");

            bean3.setW_h_tpl_my(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean3.setO_h_tpl_my(diffBill.getSecond_line() == 1 ? "-" : "-");
        } else {
            bean1.setW_h_tpl_my(diffBill.getSecond_manhour() == 0 ? "休息" : Utils.deleteZero(diffBill.getSecond_manhour() + "") + "小时");
            bean1.setO_h_tpl_my(diffBill.getSecond_overtime() == 0 ? "无加班" : Utils.deleteZero(diffBill.getSecond_overtime() + "") + "小时");
            //bean3.setW_h_tpl_my(Utils.deleteZero(diffBill.getSecond_w_h_tpl() + "") + "小时算1个工");
            //bean3.setO_h_tpl_my(Utils.deleteZero(diffBill.getSecond_o_h_tpl() + "") + "小时算1个工");
            if (second_hour_type==1){
                bean3.setW_h_tpl_my(Utils.deleteZero(diffBill.getSecond_w_h_tpl() + "") + "小时算1个工");
                bean3.setO_h_tpl_my(Utils.m2(diffBill.getSecond_o_s_tpl()) + "元/小时");
            }else {
                bean3.setW_h_tpl_my(Utils.deleteZero(diffBill.getSecond_w_h_tpl() + "") + "小时算1个工");
                bean3.setO_h_tpl_my(Utils.deleteZero(diffBill.getSecond_o_h_tpl() + "") + "小时算1个工");
            }
        }
        //右边
        if (diffBill.getMain_line() == 1 || diffBill.getMain_line() == 2) {
            bean1.setW_h_tpl_other(diffBill.getMain_line() == 1 ? "-" : "-");
            bean1.setO_h_tpl_other(diffBill.getMain_line() == 1 ? "-" : "-");

            bean3.setW_h_tpl_other(diffBill.getMain_line() == 1 ? "-" : "-");
            bean3.setO_h_tpl_other(diffBill.getMain_line() == 1 ? "-" : "-");
        } else {
            bean1.setW_h_tpl_other(diffBill.getMain_manhour() == 0 ? "休息" : Utils.deleteZero(diffBill.getMain_manhour() + "") + "小时");
            bean1.setO_h_tpl_other(diffBill.getMain_overtime() == 0 ? "无加班" : Utils.deleteZero(diffBill.getMain_overtime() + "") + "小时");
            if (main_hour_type==1){
                bean3.setW_h_tpl_other(Utils.deleteZero(diffBill.getMain_w_h_tpl() + "") + "小时算1个工");
                bean3.setO_h_tpl_other(Utils.m2(diffBill.getMain_o_s_tpl()) + "元/小时");
            }else {
                bean3.setW_h_tpl_other(Utils.deleteZero(diffBill.getMain_w_h_tpl() + "") + "小时算1个工");
                bean3.setO_h_tpl_other(Utils.deleteZero(diffBill.getMain_o_h_tpl() + "") + "小时算1个工");
            }
        }

        //工资标准
        list.add(bean1);
//        list.add(bean2);
        //模版对象
        bean3.setSalary(true);
        list.add(bean3);
    }

    /**
     * 包工
     */
    public void create_constractor(List<CheckBillInfo> list) {
//        CheckBillInfo bean1, bean2;
        String main_set_amount = Utils.m2(diffBill.getMain_set_amount()) + ""; //我的总价
        String second_set_amount = Utils.m2(diffBill.getSecond_set_amount()) + ""; //对方总价
        String main_set_unitprice = Utils.m2(diffBill.getMain_set_unitprice()) + ""; //我的单价
        String second_set_unitprice = Utils.m2(diffBill.getSecond_set_unitprice()) + ""; //对方单价
        String main_set_quantities = Utils.m2(diffBill.getMain_set_quantities()) + ""; //我的数量
        String second_set_quantities = Utils.m2(diffBill.getSecond_set_quantities()) + ""; //对方数量

        CheckBillInfo bean1 = new CheckBillInfo("工钱", CheckBillAdapter.CONTENT);
        CheckBillAllAccount workDetail = new CheckBillAllAccount();

        //左边
        if (diffBill.getSecond_line() == 1) {
            bean1.setFieldLeft("-");
            workDetail.setUnitprice_my("-");
            workDetail.setQuantities_my("-");
        } else if (diffBill.getSecond_line() == 2) {
            bean1.setFieldLeft("-");
            workDetail.setUnitprice_my("-");
            workDetail.setQuantities_my("-");
        } else {
            bean1.setFieldLeft(second_set_amount);
            workDetail.setUnitprice_my(second_set_unitprice);
            workDetail.setQuantities_my(second_set_quantities);
        }
        //右边
        if (diffBill.getMain_line() == 1) {
            bean1.setFieldRight("-");
            workDetail.setUnitprice_other("-");
            workDetail.setQuantities_other("-");
        } else if (diffBill.getMain_line() == 2) {
            bean1.setFieldRight("-");
            workDetail.setUnitprice_other("-");
            workDetail.setQuantities_other("-");
        } else {
            bean1.setFieldRight(main_set_amount);
            workDetail.setUnitprice_other(main_set_unitprice);
            workDetail.setQuantities_other(main_set_quantities);
        }


        CheckBillInfo bean2 = new CheckBillInfo(workDetail, CheckBillAdapter.SALARY);
        list.add(bean1);
        list.add(bean2);


    }

    /**
     * 借支
     */
    public void create_borrowing(List<CheckBillInfo> list) {
        String main_set_amount = Utils.m2(diffBill.getMain_set_amount()); //我的总价
        String second_set_amount = Utils.m2(diffBill.getSecond_set_amount()); //对方总价
        CheckBillInfo bean1 = new CheckBillInfo("金额", CheckBillAdapter.CONTENT);
        //右边
        if (diffBill.getMain_line() == 1 || diffBill.getMain_line() == 2) {
            bean1.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");

        } else {
            bean1.setFieldRight(main_set_amount);
        }
        //左边
        if (diffBill.getSecond_line() == 1 || diffBill.getSecond_line() == 2) {
            bean1.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
        } else {
            bean1.setFieldLeft(second_set_amount);
        }
        list.add(bean1);
    }

    /**
     * 借支
     */
    public void create_wagesing(List<CheckBillInfo> list, String role_type) {
        String main_set_amount = Utils.m2(diffBill.getMain_set_amount()); //我的结算金额
        String main_pay_amount = Utils.m2(diffBill.getMain_pay_amount()); //我的结算的支付金额
        String main_subsidy_amount = Utils.m2(diffBill.getMain_subsidy_amount()); //我的结算补贴金额
        String main_reward_amount = Utils.m2(diffBill.getMain_reward_amount()); //我的结算奖励金额
        String main_penalty_amount = Utils.m2(diffBill.getMain_penalty_amount()); //我的结算的惩罚金额
        String main_deduct_amount = Utils.m2(diffBill.getMain_deduct_amount()); //我的结算的抹零金额

        String second_set_amount = Utils.m2(diffBill.getSecond_set_amount()); //对方结算金额
        String second_pay_amount = Utils.m2(diffBill.getSecond_pay_amount()); //对方结算的支付金额
        String second_subsidy_amount = Utils.m2(diffBill.getSecond_subsidy_amount()); //对方结算的补贴金额
        String second_reward_amount = Utils.m2(diffBill.getSecond_reward_amount()); //对方结算的奖励金额
        String second_penalty_amount = Utils.m2(diffBill.getSecond_penalty_amount()); //对方结算的惩罚金额
        String second_deduct_amount = Utils.m2(diffBill.getSecond_deduct_amount()); //对方结算的抹零金额
        CheckBillInfo bean1 = new CheckBillInfo("本次结算金额", CheckBillAdapter.CONTENT);
        CheckBillInfo bean2 = new CheckBillInfo(role_type.equals(Constance.ROLETYPE_FM) ? "本次实付金额" : "本次实收金额", CheckBillAdapter.CONTENT_WAGE);
        CheckBillInfo bean3 = new CheckBillInfo("补贴金额", CheckBillAdapter.CONTENT_WAGE);
        CheckBillInfo bean4 = new CheckBillInfo("奖励金额", CheckBillAdapter.CONTENT_WAGE);
        CheckBillInfo bean5 = new CheckBillInfo("罚款金额", CheckBillAdapter.CONTENT_WAGE);
        CheckBillInfo bean6 = new CheckBillInfo("抹零金额", CheckBillAdapter.CONTENT_WAGE);
        //左边
        if (diffBill.getSecond_line() == 1 || diffBill.getSecond_line() == 2) {
            bean1.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean2.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean3.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean4.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean5.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
            bean6.setFieldLeft(diffBill.getSecond_line() == 1 ? "-" : "-");
        } else {
            bean1.setFieldLeft(second_set_amount);
            bean2.setFieldLeft(second_pay_amount);
            bean3.setFieldLeft(second_subsidy_amount);
            bean4.setFieldLeft(second_reward_amount);
            bean5.setFieldLeft(second_penalty_amount);
            bean6.setFieldLeft(second_deduct_amount);
        }
        //右边
        if (diffBill.getMain_line() == 1 || diffBill.getMain_line() == 2) {
            bean1.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");
            bean2.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");
            bean3.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");
            bean4.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");
            bean5.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");
            bean6.setFieldRight(diffBill.getMain_line() == 1 ? "-" : "-");
        } else {
            bean1.setFieldRight(main_set_amount);
            bean2.setFieldRight(main_pay_amount);
            bean3.setFieldRight(main_subsidy_amount);
            bean4.setFieldRight(main_reward_amount);
            bean5.setFieldRight(main_penalty_amount);
            bean6.setFieldRight(main_deduct_amount);
        }
        bean1.setBold(true);
        list.add(bean1);
        list.add(bean2);
        list.add(bean3);
        list.add(bean4);
        list.add(bean5);
        list.add(bean6);
    }

    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_agree:
                dismiss();
                mpoorinfoCLickListener.mpporClick(diffBill, accountType, popView.findViewById(R.id.tv_agree));
                break;
            case R.id.cancel:
                dismiss();
                break;
            case R.id.tv_change:
                if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
                    //代班传工头角色
                    role_type = Constance.ROLETYPE_FM;
                }
                if (accountType.equals(AccountUtil.SALARY_BALANCE)) {
                    //结算
                    AccountWagesEditActivty.actionStart(context, null, accountType, account_id, role_type, isRecoedWork, agencyGroupUser);
                } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {
                    //包工
                    AccountAllEditActivty.actionStart(context, null, accountType, account_id, role_type, isRecoedWork, agencyGroupUser);
                } else {
                    //包工点工借支
                    AccountEditActivity.actionStart(context, null, accountType, account_id, role_type, isRecoedWork, agencyGroupUser);
                }
                dismiss();
                break;
        }
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }

    public interface MpoorinfoCLickListener {
        void mpporClick(DiffBill bean, String type, View agreeBtn);

    }

    public interface ShowPoorClickListener {
        void showPoorClick(DiffBill diffBill);
    }
}
