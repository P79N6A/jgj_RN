package com.jizhi.jlongg.main.popwindow;

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
import com.jizhi.jlongg.main.bean.BatchAccountDetail;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.DataUtil;
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
public class WheelViewBatchAccountMultiPerson extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
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
    private SelecteMultiPersonModulListener listener;
    /**
     * 文本备注, 图片备注
     */
    private TextView remarkText, remarkTextIcon;


    /**
     * 批量记账构造函数
     *
     * @param context  上下文
     * @param listener 选择薪资模板回调
     */
    public WheelViewBatchAccountMultiPerson(Activity context, int multipartMemberCount, String recordTime, String remarkDesc, ArrayList<ImageItem> remarkImages,
                                            SelecteMultiPersonModulListener listener) {
        super(context);
        this.context = context;
        this.listener = listener;
        setPopView(multipartMemberCount, recordTime, remarkDesc, remarkImages);
    }


    private void setPopView(int multipartMemberCount, String recordTime, String remarkDesc, ArrayList<ImageItem> remarkImages) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.batch_account_multi_person_popwindow, null);
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
        TextView selecteMultipartMembersText = (TextView) popView.findViewById(R.id.selecteMultipartMembersText);
        remarkText = (TextView) popView.findViewById(R.id.remark_text);
        remarkTextIcon = (TextView) popView.findViewById(R.id.remark_text_icon);


        setRemarkDesc(remarkDesc, remarkImages);

        selecteMultipartMembersText.setText(Html.fromHtml("<font color='#666666'>将选中的</font><font color='#eb4e4e'> " + multipartMemberCount + " </font>" +
                "<font color='#666666'>个工人，按以下工时记录</font>"));
        titleText.setText(recordTime);
        setWheelViewData();
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
            if (normalTimeList.get(i).getWorkTimes() == 8f) {
                items[0] = i;
            }
        }
        size = overTimeList.size();
        for (int i = 0; i < size; i++) {
            if (overTimeList.get(i).getWorkTimes() == 0) {
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
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.multipart_set_remark).setOnClickListener(this);
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
            return workTime.isRest() ? workTime.getWorkName() : Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
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
            return workTime.isRest() ? workTime.getWorkName() : Utils.subFloat(String.valueOf(workTime.getWorkTimes())) + workTime.getWorkName();
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm: //确认按钮
                dismiss();
                if (listener != null) {
                    listener.selectedMultiPersonTime(normalTimeList.get(normalTimeWheel.getCurrentItem()), overTimeList.get(overallTimeWheel.getCurrentItem()));
                }
                break;
            case R.id.btn_cancel: //取消按钮
                dismiss();
                break;
            case R.id.multipart_set_remark: // 备注信息
                if (listener != null) {
                    listener.setRemark();
                }
                break;
        }

    }

    public interface SelecteMultiPersonModulListener {
        public void selectedMultiPersonTime(WorkTime normalTime, WorkTime overTime);

        public void setAccountedSalary(BatchAccountDetail bean);

        public void setRemark();

    }


}