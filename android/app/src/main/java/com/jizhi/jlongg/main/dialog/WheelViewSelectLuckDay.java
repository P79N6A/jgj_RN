package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.HuangliBaseInfoService;
import com.jizhi.jlongg.main.bean.Other;
import com.jizhi.jlongg.main.listener.SelectedLuckyDayListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * 选吉日对话框
 */
public class WheelViewSelectLuckDay extends PopupWindow implements OnClickListener, OnWheelChangedListener, OnWheelScrollListener, PopupWindow.OnDismissListener {
    /* wheelView */
    private WheelView mViewLeft;
    /* wheelView */
    private WheelView mViewRight;
    private List<Other> listLeft, listRight;
    private Activity context;
    private MyArrayWheelAdapter adapterLeft, adapteRight;
    /* 标题 */
    private String title;
    /* 数据回调 */
    private SelectedLuckyDayListener luckyDayListener;

    private View popView;


    public void update() {
        adapterLeft.setCurrentIndex(mViewLeft.getCurrentItem());
        adapteRight.setCurrentIndex(mViewRight.getCurrentItem());
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.huangli_yiji, null);
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

    public WheelViewSelectLuckDay(Activity context, String title, SelectedLuckyDayListener luckyDayListener) {
        super(context);
        this.context = context;
        this.title = title;
        this.luckyDayListener = luckyDayListener;
        setPopView();
        getListLeft();
        setUpViews();
        initData();
    }

    public void getListLeft() {
        listLeft = new ArrayList<>();
        Other Other1 = new Other();
        Other1.setName("宜");
        listLeft.add(Other1);
        Other1 = new Other();
        Other1.setName("忌");
        listLeft.add(Other1);
        listRight = HuangliBaseInfoService.getInstance(context.getApplicationContext()).selectInfoJixong();
    }


    private void initData() {
        adapterLeft = new MyArrayWheelAdapter(context, listLeft, 0, true);
        mViewLeft.setViewAdapter(adapterLeft);
        mViewLeft.setCurrentItem(0);
        mViewLeft.setVisibleItems(7);

        adapteRight = new MyArrayWheelAdapter(context, listRight, 0, false);
        mViewRight.setViewAdapter(adapteRight);
        mViewRight.setCurrentItem(0);
        mViewRight.setVisibleItems(7);
        setUpListener();
    }


    private void setUpViews() {
        mViewLeft = (WheelView) popView.findViewById(R.id.id_province);
        mViewRight = (WheelView) popView.findViewById(R.id.id_city);
        TextView tv_context = (TextView) popView.findViewById(R.id.tv_context);
        tv_context.setText(title);
    }

    private void setUpListener() {
        mViewLeft.addChangingListener(this);
        mViewRight.addChangingListener(this);
        mViewLeft.addScrollingListener(this);
        mViewRight.addScrollingListener(this);
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
    }


    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        if (wheel == mViewLeft) {
            String currentText = (String) adapterLeft.getItemText(mViewLeft.getCurrentItem());
            adapterLeft.setTextViewSize(currentText, adapterLeft);
        } else if (wheel == mViewRight) {
            String currentText = (String) adapteRight.getItemText(mViewRight.getCurrentItem());
            adapteRight.setTextViewSize(currentText, adapteRight);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                int leftCurr = mViewLeft.getCurrentItem();
                int rightCurr = mViewRight.getCurrentItem();
                luckyDayListener.selectedLuckyDayClick(listLeft.get(leftCurr).getName(), listRight.get(rightCurr).getName(), leftCurr, rightCurr);
                break;
        }
        dismiss();
    }

    @Override
    public void onScrollingStarted(WheelView wheel) {

    }

    @Override
    public void onScrollingFinished(WheelView wheel) {
        if (wheel == mViewLeft) {
            String currentText = (String) adapterLeft.getItemText(mViewLeft.getCurrentItem());
            adapterLeft.setTextViewSize(currentText, adapterLeft);
        } else if (wheel == mViewRight) {
            String currentText = (String) adapteRight.getItemText(mViewRight.getCurrentItem());
            adapteRight.setTextViewSize(currentText, adapteRight);
        }
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }


    public class MyArrayWheelAdapter extends AbstractWheelTextAdapter {

        private List<Other> list;
        private boolean isLeft;

        public MyArrayWheelAdapter(Context context, List<Other> list, int currentItem, boolean isLeft) {
            super(context, R.layout.item_birth_year, NO_RESOURCE, currentItem);
            this.list = list;
            this.isLeft = isLeft;
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public CharSequence getItemText(int index) {
            if (index >= 0 && index < list.size()) {
                String item = "";
                if (isLeft) {
                    item = list.get(index).getName();
                } else {
                    item = list.get(index).getName() + ":" + list.get(index).getContent();
                }
                if (item instanceof CharSequence) {
                    return item;
                }
                return item.toString();
            }
            return null;
        }

        @Override
        public int getItemsCount() {
            return list.size();
        }
    }
}
