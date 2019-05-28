package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkTime;
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
public class WheelAccountTimeSelected extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
    /* wheelView */
    private WheelView wheelView;
    /* wheelView 适配器 */
    private WheelContentTextAdapter wheelViewAdapter;
    /* wheelView 数据 */
    private List<WorkTime> list;
    /* 上下文 */
    private Activity context;
    /* wheelView 选中回调 */
    private CallBackSingleWheelListener listener;
    /* popwindow */
    private View popView;
    private int currItemIndex;
    //休息/无加班 半个工 一个工 快捷按钮
    private Button btn_zero_hour, btn_half_hour, btn_one_hour;
    // 休息/无加班 半个工，一个工下标
    private int half_positon, one_position;
    //当前是否显示的是上班弹窗
    private boolean isWorkTime;

    public void setSelecteWheelView(int item) {
        wheelView.setCurrentItem(item);
        wheelViewAdapter.setCurrentIndex(item);
    }

    public WheelAccountTimeSelected(Activity context, String title, List<WorkTime> cityList, int currItemIndex, boolean isWorkTime,int hour_type) {
        super(context);
        this.context = context;
        this.list = cityList;
        this.currItemIndex = currItemIndex;
        this.isWorkTime = isWorkTime;
        setPopView();
        if (hour_type==1&&!isWorkTime) {
            initView(title, View.GONE);
        }else {
            initView(title,View.VISIBLE);
        }
    }

    public WheelAccountTimeSelected(Activity context, String title, List<WorkTime> cityList, int currItemIndex) {
        super(context);
        this.context = context;
        this.list = cityList;
        this.currItemIndex = currItemIndex;
        setPopView();
        initView(title, View.GONE);
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


    private void initView(String title, int VISIBLE) {
        wheelView = popView.findViewById(R.id.wheel_project_type);
        btn_zero_hour = popView.findViewById(R.id.btn_zero_hour);
        btn_half_hour = popView.findViewById(R.id.btn_half_hour);
        btn_one_hour = popView.findViewById(R.id.btn_one_hour);
        TextView tv_context = popView.findViewById(R.id.tv_context);
        popView.findViewById(R.id.lin_hour_top).setVisibility(VISIBLE);
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


        //3.4.1增加上班时间快捷选项
        //上班显示无加班，加班显示休息
        if (isWorkTime) {
            btn_zero_hour.setText("休息");
        } else {
            btn_zero_hour.setText("无加班");
        }
        for (WorkTime workTime : list) {
            if (workTime.getUnit().contains("半个工")) {
                btn_half_hour.setText(workTime.getWorkName() + "" + workTime.getUnit());
            } else if (workTime.getUnit().contains("1个工")) {
                btn_one_hour.setText(workTime.getWorkName() + "" + workTime.getUnit());

            }
        }
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getUnit().contains("半个工")) {
                btn_half_hour.setText(list.get(i).getUnit().replace("(", "").replace(")", "") + "(" + list.get(i).getWorkName() + ")");
                half_positon = i;
            } else if (list.get(i).getUnit().contains("1个工")) {
                btn_one_hour.setText(list.get(i).getUnit().replace("(", "").replace(")", "") + "(" + list.get(i).getWorkName() + ")");
                one_position = i;

            }
        }
        btn_half_hour.setVisibility(!TextUtils.isEmpty(btn_half_hour.getText().toString()) ? View.VISIBLE : View.GONE);
        btn_zero_hour.setOnClickListener(this);
        btn_half_hour.setOnClickListener(this);
        btn_one_hour.setOnClickListener(this);

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
            return list.size();
        }

        @Override
        protected CharSequence getItemText(int index) {
            String unit = TextUtils.isEmpty(list.get(index).getUnit()) ? "" : list.get(index).getUnit();
            return list.get(index).getWorkName() + "" + unit;
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                if (listener != null) {
                    int position = wheelView.getCurrentItem();
                    listener.onSelected(wheelViewAdapter.getItemText(position).toString(), position);
                    setSelecteWheelView(position);
                }
                break;//btn_zero_hour,btn_half_hour,btn_one_hour
            case R.id.btn_zero_hour:
                //休息/无加班
                listener.onSelected("", 0);
                setSelecteWheelView(0);
                break;
            case R.id.btn_half_hour:
                //半个工
                if (half_positon == 0) {
                    return;
                }
                listener.onSelected("", half_positon);
                setSelecteWheelView(half_positon);
                break;
            case R.id.btn_one_hour:
                //一个工
                if (one_position == 0) {
                    return;
                }
                listener.onSelected("", one_position);
                setSelecteWheelView(one_position);
                break;
        }
        dismiss();
    }


}