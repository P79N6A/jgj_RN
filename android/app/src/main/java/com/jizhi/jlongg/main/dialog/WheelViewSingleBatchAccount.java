package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.fragment.worker.SingleBatchAccountFragment;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * 单人多天记账
 *
 * @author Xuj
 * @date 2017年2月14日11:03:12
 */
public class WheelViewSingleBatchAccount extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {

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
     * 上下文
     */
    private Activity context;
    /**
     * 上班时长数据
     */
    private List<WorkTime> normalTimeList;
    /**
     * 加班时长数据
     */
    private List<WorkTime> overTimeList;
    /**
     * 选中的单元格
     */
    private List<SingleBatchAccountFragment.Cell> selecteCells;
    /**
     * 选择确定时的回调
     */
    private SelecteTimeListener listener;
    /**
     * 已选的日期
     */
    private TextView dateText;
    /**
     * 文本备注, 图片备注
     */
    private TextView remarkText, remarkTextIcon;
    /**
     * 所在项目
     */
    private TextView proText;

    public WheelViewSingleBatchAccount(Activity context, List<WorkTime> normalTimeList, List<WorkTime> overTimeList,
                                       List<SingleBatchAccountFragment.Cell> selecteCells, SelecteTimeListener listener,
                                       String proName, String remark, ArrayList<ImageItem> remarkImages,
                                       boolean isClickProject) {
        super(context);
        this.context = context;
        this.normalTimeList = normalTimeList;
        this.overTimeList = overTimeList;
        this.selecteCells = selecteCells;
        this.listener = listener;
        setPopView(proName, remark, remarkImages, isClickProject);
    }

    private void setPopView(String proName, String remark, ArrayList<ImageItem> remarkImages, boolean isClickProject) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.wheel_single_batch_account, null);
        normalTimeWheel = (WheelView) popView.findViewById(R.id.normalTimeWheel);
        overallTimeWheel = (WheelView) popView.findViewById(R.id.overallTimeWheel);
        dateText = (TextView) popView.findViewById(R.id.dateText);
        remarkText = (TextView) popView.findViewById(R.id.remark_text);
        remarkTextIcon = (TextView) popView.findViewById(R.id.remark_text_icon);
        proText = (TextView) popView.findViewById(R.id.proText);


        if (isClickProject) {
            popView.findViewById(R.id.clickProjectIcon).setVisibility(View.VISIBLE);
        } else {
            popView.findViewById(R.id.clickProjectIcon).setVisibility(View.GONE);
        }

        int[] items = getWheelViewSelected();

        normalAdapter = new WheelNormalTimeAdapter(context, items[0]);
        overTimeAdapter = new WheelOverTimeAdapter(context, items[1]);

        normalTimeWheel.setViewAdapter(normalAdapter);
        overallTimeWheel.setViewAdapter(overTimeAdapter);

        normalTimeWheel.setCurrentItem(items[0]);
        overallTimeWheel.setCurrentItem(items[1]);

        normalTimeWheel.setVisibleItems(5);
        overallTimeWheel.setVisibleItems(5);

        proText.setText(proName);
        setRemarkDesc(remark, remarkImages);

        if (selecteCells != null) {
            dateText.setText(Html.fromHtml("<font color='#666666'>将以上选中的</font><font color='#eb4e4e'> " + selecteCells.size() + "天 </font>" +
                    "<font color='#666666'>都按照以下时长记录</font>"));
        }

        setClick(isClickProject);
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
//            if (normalTimeList.get(i).getWorkTimes() == salaryTpl.getW_h_tpl()) {
//                items[0] = i;
//            }
            if (normalTimeList.get(i).getWorkTimes() == 8.0d) {
                items[0] = i;
            }
        }
        size = overTimeList.size();
        for (int i = 0; i < size; i++) {
//            if (overTimeList.get(i).getWorkTimes() == salaryTpl.getChoose_o_h_tpl()) {
//                items[1] = i;
//            }
//            if (overTimeList.get(i).getWorkTimes() == 6.0d) {
//                items[1] = i;
//            }
            items[1] = 0;
        }
        return items;
    }


    private void setClick(boolean isClickProject) {
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
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.multipart_set_remark).setOnClickListener(this);
        if (isClickProject) {
            popView.findViewById(R.id.proLayout).setOnClickListener(this);
        }
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }


    private class WheelNormalTimeAdapter extends AbstractWheelTextAdapter {

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
//            if (workTime.getWorkTimes() == salaryTpl.getW_h_tpl()) {
//                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
////                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(1个工)";
//            } else if (workTime.getWorkTimes() == salaryTpl.getW_h_tpl() / 2f) {
////                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(半个工)";
//                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
//            } else {
//                if (workTime.isRest()) { //是否是休息
//                    return workTime.getWorkName();
//                } else {
//                    return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
//                }
//            }
            if (workTime.isRest()) { //是否是休息
                return workTime.getWorkName();
            } else {
                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
            }
        }
    }

    private class WheelOverTimeAdapter extends AbstractWheelTextAdapter {

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
//            if (workTime.getWorkTimes() == salaryTpl.getO_h_tpl()) {
////                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(1个工)";
//                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
//            } else if (workTime.getWorkTimes() == salaryTpl.getO_h_tpl() / 2f) {
//                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
//// return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName() + "(半个工)";
//            } else {
//                if (workTime.isRest()) { //是否是休息
//                    return workTime.getWorkName();
//                } else {
//                    return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
//                }
//            }
            if (workTime.isRest()) { //是否是休息
                return workTime.getWorkName();
            } else {
                return Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
            }
        }
    }


    @Override
    public void onClick(View v) {
        if (listener == null) {
            return;
        }
        dismiss();
        switch (v.getId()) {
            case R.id.btn_confirm:
                listener.selectedTime(normalTimeList.get(normalTimeWheel.getCurrentItem()),
                        overTimeList.get(overallTimeWheel.getCurrentItem()), selecteCells);
                break;
            case R.id.proLayout://所在项目
                listener.selectedProject();
                break;
            case R.id.multipart_set_remark:  //批量设置备注
                listener.setRemark();
                break;
        }
    }

    public interface SelecteTimeListener {
        public void selectedTime(WorkTime normalTime, WorkTime overTime, List<SingleBatchAccountFragment.Cell> selectedData);

        public void selectedProject();

        public void setRemark();
    }

    public void setRemarkDesc(String remark, ArrayList<ImageItem> remarkImages) {
        if (!TextUtils.isEmpty(remark)) {
            remarkText.setText(remark.length() > 10 ? remark.substring(0, 10) + "..." : remark);
        } else {
            remarkText.setText("");
        }
        remarkTextIcon.setText(remarkImages != null && !remarkImages.isEmpty() ? "[图片]" : "");

        if (TextUtils.isEmpty(remark) && (remarkImages == null || remarkImages.isEmpty())) {
            remarkTextIcon.setHint(R.string.write_remark);
        } else {
            remarkTextIcon.setHint("");
        }
    }


    public void update(List<SingleBatchAccountFragment.Cell> selecteCells, String proName, String remark, ArrayList<ImageItem> remarkImages) {
        normalAdapter.setCurrentIndex(normalTimeWheel.getCurrentItem());
        overTimeAdapter.setCurrentIndex(overallTimeWheel.getCurrentItem());
        this.selecteCells = selecteCells;
        setRemarkDesc(remark, remarkImages);
        proText.setText(proName);
        setSelecteDesc();
    }

    private void setSelecteDesc() {
        if (selecteCells != null && selecteCells.size() > 0) {
            dateText.setText(Html.fromHtml("<font color='#666666'>将以上选中的</font><font color='#eb4e4e'> " + selecteCells.size() + "天 </font>" +
                    "<font color='#666666'>都按照以下时长记录</font>"));
        }
    }


}