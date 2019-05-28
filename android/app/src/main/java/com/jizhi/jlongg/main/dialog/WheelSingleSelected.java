package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.bean.WorkType;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.util.List;


/**
 * WheelView 单个选择
 *
 * @author Xuj
 * @date 2016年9月26日 10:59:58
 */
public class WheelSingleSelected extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
    /* wheelView */
    private WheelView wheelView;
    /* wheelView 适配器 */
    private WheelContentTextAdapter wheelViewAdapter;
    /* wheelView 数据 */
    private List<WorkType> list;
    /* wheelView 数据 */
    private List<CityInfoMode> cityList;
    /* 上下文 */
    private Activity context;
    /* wheelView 选中回调 */
    private CallBackSingleWheelListener listener;
    /* popwindow */
    private View popView;
    private int currItemIndex;

    public WheelSingleSelected(Activity context, String title, List<WorkType> list) {
        super(context);
        this.context = context;
        this.list = list;
        setPopView();
        initView(title);
    }


    public void setSelecteWheelView(int item) {
        wheelView.setCurrentItem(item);
        wheelViewAdapter.setCurrentIndex(item);
    }

    public WheelSingleSelected(Activity context, String title, List<CityInfoMode> cityList,int currItemIndex) {
        super(context);
        this.context = context;
        this.cityList = cityList;
        this.currItemIndex = currItemIndex;
        setPopView();
        initView(title);
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.layout_wheelview_single_selected, null);
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


    private void initView(String title) {
        wheelView = (WheelView) popView.findViewById(R.id.wheel_project_type);
        TextView tv_context = (TextView) popView.findViewById(R.id.tv_context);
        tv_context.setText(title);
        wheelViewAdapter = new WheelContentTextAdapter(context, 0);
        wheelView.setVisibleItems(5);
        wheelView.setViewAdapter(wheelViewAdapter);
        wheelView.setCurrentItem(currItemIndex);
        wheelView.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                changeScrollColor(wheel);
            }
        });
        wheelView.addScrollingListener(new OnWheelScrollListener() {
            @Override
            public void onScrollingStarted(WheelView wheel) {

            }

            @Override
            public void onScrollingFinished(WheelView wheel) {
                changeScrollColor(wheel);
            }
        });
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
    }


    public void update() {
        wheelViewAdapter.setCurrentIndex(wheelView.getCurrentItem());
    }


    private void changeScrollColor(WheelView wheel) {
        String currentText = (String) wheelViewAdapter.getItemText(wheel.getCurrentItem());
        wheelViewAdapter.setTextViewSize(currentText, wheelViewAdapter);
    }

    public void setListener(CallBackSingleWheelListener listener) {
        this.listener = listener;
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }


    private class WheelContentTextAdapter extends AbstractWheelTextAdapter {

        protected WheelContentTextAdapter(Context context, int currentItem) {
            super(context, R.layout.item_birth_year, NO_RESOURCE, currentItem);
            setItemTextResource(R.id.tempValue);
        }

        @Override
        public View getItem(int index, View cachedView, ViewGroup parent) {
            View view = super.getItem(index, cachedView, parent);
            return view;
        }

        @Override
        public int getItemsCount() {
            if (list != null) {
                return list.size();
            } else {
                return cityList.size();
            }
        }

        @Override
        protected CharSequence getItemText(int index) {
            if (list != null) {
                return list.get(index).getWorkName();
            } else {
                return cityList.get(index).getCity_name();
            }
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                if (listener != null) {
                    int position = wheelView.getCurrentItem();
                    listener.onSelected(wheelViewAdapter.getItemText(position).toString(), position);
                }
                break;
        }
        dismiss();
    }


}