package com.jizhi.jlongg.main.popwindow;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BatchAccountDetail;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.util.List;

/**
 * 单人多天记账
 *
 * @author Xuj
 * @date 2017年2月14日11:03:12
 */
public class WheelViewBatchAccountSinglePerson extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
    /**
     * 上下文
     */
    private Activity context;

    private View popView;
    /**
     * 上班时常滑动view,加班时常滑动view
     */
    private WheelView normalTimeWheel, overallTimeWheel;
    /**
     * wheelView 正常上班滑动适配器
     */
    private WheelNormalTimeAdapter normalAdapter;
    /**
     * wheelView 加班时长滑动适配器
     */
    private WheelOverTimeAdapter overTimeAdapter;
    /**
     * 上班时长数据
     */
    private List<WorkTime> normalTimeList = DataUtil.getNormalTimeListNewVersion(24);
    /**
     * 加班时长数据
     */
    private List<WorkTime> overTimeList = DataUtil.getOverTimeListNewVersion(24);
    /**
     * 选中回调
     */
    private SelecteSinglePersonModulListener listener;
    /**
     * 用户的信息
     */
    private BatchAccountDetail membersAttribute;

    private TextView salaryText;
//    /**
//     * 设置标准来源，如果选择了记账的人，则是api拉取上一笔工模板from==1
//     * 如果本地进行设置，但是未保存当前这笔记工，这表示本地进行设置from==0
//     */
//    private int from = -1;

    /**
     * 批量记账构造函数
     *
     * @param context
     * @param membersAttribute 成员属性
     * @param title            设置标题
     */
    public WheelViewBatchAccountSinglePerson(Activity context, BatchAccountDetail membersAttribute, String title) {
        super(context);
        this.context = context;
        this.membersAttribute = membersAttribute;
        setPopView(title);
    }

    public SelecteSinglePersonModulListener getListener() {
        return listener;
    }

    public void setListener(SelecteSinglePersonModulListener listener) {
        this.listener = listener;
    }

    private void setPopView(String title) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.batch_account_single_person_popwindow, null);
        normalTimeWheel = (WheelView) popView.findViewById(R.id.normalTimeWheel);
        overallTimeWheel = (WheelView) popView.findViewById(R.id.overallTimeWheel);

        setClick();
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
        setBackgroundDrawable(dw);
        setOnDismissListener(this);
        setOutsideTouchable(true);


        TextView titleText = (TextView) popView.findViewById(R.id.title);
        salaryText = (TextView) popView.findViewById(R.id.setSalaryText);

        if (membersAttribute != null && membersAttribute.getMsg() != null && !TextUtils.isEmpty(membersAttribute.getMsg().getAccounts_type())) { //薪资模板不为空
            ImageView accountTypeIcon = (ImageView) popView.findViewById(R.id.accountTypeIcon);
            TextView salaryAccountType = popView.findViewById(R.id.salaryAccountType);
            //记账类型 1表示点工 5表示包包工记工天
            String accountType = membersAttribute.getMsg().getAccounts_type();
            Salary tpl = accountType.equals(AccountUtil.HOUR_WORKER) ? membersAttribute.getTpl() : membersAttribute.getUnit_quan_tpl();
            String normalWork = RecordUtils.cancelIntergerZeroFloat(tpl.getW_h_tpl());//上班时长
            String overTimeWork = RecordUtils.cancelIntergerZeroFloat(tpl.getO_h_tpl());//加班时长
            if (accountType.equals(AccountUtil.HOUR_WORKER)) { //点工
                salaryAccountType.setText("工资标准");
                if (membersAttribute.getTpl().getHour_type() == 1) {//按小时算加班
                    salaryOfHour(membersAttribute.getTpl());
                } else {//按工天算加班
                    salaryOfDay(membersAttribute.getTpl());
                }
            } else if (accountType.equals(AccountUtil.CONSTRACTOR_CHECK)) { //包工记工天
                salaryAccountType.setText("考勤模板");
                salaryText.setText(normalWork + "小时(上班)/" + (overTimeWork + "小时(加班)"));
            }
            accountTypeIcon.setImageResource(accountType.equals(AccountUtil.HOUR_WORKER) ? R.drawable.hour_worker_flag : R.drawable.constar_flag);
        }
        titleText.setText(title);
        setWheelViewData();
    }

    /**
     * 4.0.2工资标准，按工天显示样式
     *
     * @param tplMode
     */
    private void salaryOfDay(Salary tplMode) {
        StringBuilder salaryBuilder = new StringBuilder();
        if (tplMode.getW_h_tpl() != 0) {
            salaryBuilder.append("上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工");
        }
        if (tplMode.getO_h_tpl() != 0) {
            salaryBuilder.append("\n加班" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时算一个工");
        }
        if (tplMode.getS_tpl() != 0) {
            salaryBuilder.append("\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)");
        }
        if (tplMode.getS_tpl() != 0 && tplMode.getO_h_tpl() != 0) {
            salaryBuilder.append("\n" + Utils.m2(tplMode.getS_tpl() / tplMode.getO_h_tpl()) + "元/小时(加班)");
        }
        salaryText.setText(salaryBuilder.toString());
    }

    /**
     * 4.0.2工资标准，按小时显示样式
     *
     * @param tplMode //     * @param fromNet 设置标准来源，如果选择了记账的人，则是api拉取上一笔工模板from==1
     *                //     *                如果本地进行设置，但是未保存当前这笔记工，这表示本地进行设置from==0
     */
    private void salaryOfHour(Salary tplMode) {
        StringBuilder salaryBuilder = new StringBuilder();
        if (tplMode.getW_h_tpl() != 0) {
            salaryBuilder.append("上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工");
        }
        if (tplMode.getS_tpl() != 0) {
            salaryBuilder.append("\n" + Utils.m2(tplMode.getS_tpl()) + "元/个工(上班)");
        }
        //如果overtime_salary_tpl不为空，则本地已经重新设置过加班的薪资模板
        if (!TextUtils.isEmpty(tplMode.getOvertime_salary_tpl())) {
            salaryBuilder.append("\n" + (Utils.m2(Double.parseDouble(tplMode.getOvertime_salary_tpl())) + "") + "元/小时(加班)");
            membersAttribute.getTpl().setO_s_tpl(Double.parseDouble(tplMode.getOvertime_salary_tpl()));
        } else {
            if (tplMode.getO_s_tpl() != 0) {
                salaryBuilder.append("\n" + (Utils.m2(tplMode.getO_s_tpl()) + "元/小时(加班)"));
            }
        }
        salaryText.setText(salaryBuilder.toString());
    }

    private void setWheelViewData() {
        int[] items = getWheelViewSelected();

        normalAdapter = new WheelNormalTimeAdapter(context, items[0]);
        overTimeAdapter = new WheelOverTimeAdapter(context, items[1]);

        normalTimeWheel.setViewAdapter(normalAdapter);
        overallTimeWheel.setViewAdapter(overTimeAdapter);

        normalTimeWheel.setCurrentItem(items[0]);
        overallTimeWheel.setCurrentItem(items[1]);

        normalTimeWheel.setVisibleItems(5);
        overallTimeWheel.setVisibleItems(5);
    }


    /**
     * 获取滚动view
     *
     * @return int[0] 表示上班时长的下标
     * int[1] 表示加班时长的下标
     */
    private int[] getWheelViewSelected() {
        int[] items = new int[2];
        int size = normalTimeList.size();
        for (int i = 0; i < size; i++) {
            if (normalTimeList.get(i).getWorkTimes() == membersAttribute.getChoose_tpl().getChoose_w_h_tpl()) {
                items[0] = i;
            }
        }
        size = overTimeList.size();
        for (int i = 0; i < size; i++) {
            if (overTimeList.get(i).getWorkTimes() == membersAttribute.getChoose_tpl().getChoose_o_h_tpl()) {
                items[1] = i;
            }
        }
        return items;
    }


    private void setClick() {
        normalTimeWheel.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                String currentText = (String) normalAdapter.getItemText(wheel.getCurrentItem());
                normalAdapter.setTextViewSize(currentText, normalAdapter);
            }
        });
        normalTimeWheel.addScrollingListener(new OnWheelScrollListener() {
            @Override
            public void onScrollingStarted(WheelView wheel) {
            }

            @Override
            public void onScrollingFinished(WheelView wheel) {
                String currentText = (String) normalAdapter.getItemText(wheel.getCurrentItem());
                normalAdapter.setTextViewSize(currentText, normalAdapter);
            }
        });

        overallTimeWheel.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                String currentText = (String) overTimeAdapter.getItemText(wheel.getCurrentItem());
                overTimeAdapter.setTextViewSize(currentText, overTimeAdapter);
            }
        });
        overallTimeWheel.addScrollingListener(new OnWheelScrollListener() {
            @Override
            public void onScrollingStarted(WheelView wheel) {
            }

            @Override
            public void onScrollingFinished(WheelView wheel) {
                String currentText = (String) overTimeAdapter.getItemText(wheel.getCurrentItem());
                overTimeAdapter.setTextViewSize(currentText, overTimeAdapter);
            }
        });
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        popView.findViewById(R.id.btn_delete).setOnClickListener(this);
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.setSalaryLayout).setOnClickListener(this);
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }


    private class WheelNormalTimeAdapter extends AbstractWheelTextAdapter {

        private Salary tpl = membersAttribute.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? membersAttribute.getTpl() : membersAttribute.getUnit_quan_tpl();

        protected WheelNormalTimeAdapter(Context context, int mCurrentItem) {
            super(context, R.layout.item_wheelview, NO_RESOURCE, mCurrentItem);
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public View getItem(int index, View cachedView, ViewGroup parent) {
            View view = super.getItem(index, cachedView, parent);
            return view;
        }

        @Override
        public int getItemsCount() {
            return normalTimeList.size();
        }

        @Override
        protected CharSequence getItemText(int index) {
            WorkTime workTime = normalTimeList.get(index);
            if (workTime.getWorkTimes() == tpl.getW_h_tpl()) {
                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(1个工)";
            } else if (workTime.getWorkTimes() == tpl.getW_h_tpl() / 2f) {
                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(半个工)";
            } else {
                if (workTime.isRest()) { //是否是休息
                    return workTime.getWorkName();
                } else {
                    return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
                }
            }
        }
    }

    private class WheelOverTimeAdapter extends AbstractWheelTextAdapter {

        Salary tpl = membersAttribute.getMsg().getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? membersAttribute.getTpl() : membersAttribute.getUnit_quan_tpl();

        protected WheelOverTimeAdapter(Context context, int mCurrentItem) {
            super(context, R.layout.item_wheelview, NO_RESOURCE, mCurrentItem);
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public View getItem(int index, View cachedView, ViewGroup parent) {
            View view = super.getItem(index, cachedView, parent);
            return view;
        }

        @Override
        public int getItemsCount() {
            return overTimeList.size();
        }

        @Override
        protected CharSequence getItemText(int index) {
            WorkTime workTime = overTimeList.get(index);
            if (workTime.getWorkTimes() == tpl.getO_h_tpl()) {
                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(1个工)";
            } else if (workTime.getWorkTimes() == tpl.getO_h_tpl() / 2f) {
                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(半个工)";
            } else {
                if (workTime.isRest()) { //是否是休息
                    return workTime.getWorkName();
                } else {
                    return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
                }
            }
        }
    }


    @Override
    public void onClick(View v) {
        if (listener == null) {
            return;
        }
        switch (v.getId()) {
            case R.id.setSalaryLayout://设置薪资模板
                dismiss();
                listener.setAccountedSalary(membersAttribute);
                break;
            case R.id.btn_confirm: //确定按钮
                dismiss();
                listener.selectedSinglePersonTime(normalTimeList.get(normalTimeWheel.getCurrentItem()), overTimeList.get(overallTimeWheel.getCurrentItem()));
                break;
            case R.id.btn_delete: //删除按钮
                listener.delete(membersAttribute);
                break;
            case R.id.btn_cancel: //取消按钮
                dismiss();
                break;

        }
    }

    public interface SelecteSinglePersonModulListener {

        public void delete(BatchAccountDetail batchAccountDetail);

        public void selectedSinglePersonTime(WorkTime normalTime, WorkTime overTime);

        public void setAccountedSalary(BatchAccountDetail bean);

    }

}