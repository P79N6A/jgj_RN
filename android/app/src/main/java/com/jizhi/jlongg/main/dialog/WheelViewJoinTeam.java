package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.util.List;

/**
 * 加入班组滑动wheel
 *
 * @author Xuj
 * @date 2016年9月8日 14:51:15
 */
public class WheelViewJoinTeam extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
    /* 滑动wheelView */
    private WheelView wheelView;
    /* wheelView 适配器 */
    private WheelContentTextAdapter contentTextAdapter;
    /* 上下文 */
    private Activity context;
    /* 加入班组、讨论组回调 */
    private ScrollSelectedProjectListener listener;
    /* wheel列表数据 */
    private List<Project> list;
    /**/
    private View popView;

    public WheelViewJoinTeam(Activity context, List<Project> list, ScrollSelectedProjectListener listener) {
        super(context);
        this.context = context;
        this.list = list;
        this.listener = listener;
        setPopView();
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.wheel_view_join_team, null);
        wheelView = (WheelView) popView.findViewById(R.id.wheel_project_type);
        contentTextAdapter = new WheelContentTextAdapter(context, 0);
        wheelView.setVisibleItems(5);
        wheelView.setViewAdapter(contentTextAdapter);
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
    }


    public void update() {
        contentTextAdapter.setCurrentIndex(wheelView.getCurrentItem());
    }


    private void setClick() {
        wheelView.addScrollingListener(new OnWheelScrollListener() {
            @Override
            public void onScrollingStarted(WheelView wheel) {
            }

            @Override
            public void onScrollingFinished(WheelView wheel) {
                String currentText = (String) contentTextAdapter.getItemText(wheel.getCurrentItem());
                contentTextAdapter.setTextViewSize(currentText, contentTextAdapter);
            }
        });
        wheelView.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                String currentText = (String) contentTextAdapter.getItemText(wheel.getCurrentItem());
                contentTextAdapter.setTextViewSize(currentText, contentTextAdapter);
            }
        });

        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }


    private class WheelContentTextAdapter extends AbstractWheelTextAdapter {
        protected WheelContentTextAdapter(Context context, int currentItem) {
            super(context, R.layout.item_wheelview, NO_RESOURCE, currentItem);
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
            Project bean = list.get(index);
            return bean.getIs_create_group() == 0 ? bean.getPro_name() : bean.getPro_name() + "(已有班组)";
        }
    }


    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btn_confirm) {
            if (listener != null) {
                listener.selected(list.get(wheelView.getCurrentItem()));
            }
        }
        dismiss();
    }


    public interface ScrollSelectedProjectListener {
        public void selected(Project selectedBean);
    }


}