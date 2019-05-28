package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddProjectActivity;
import com.jizhi.jlongg.main.activity.EditorProjectActivity;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.AbstractWheelTextAdapter;

import java.io.Serializable;
import java.util.List;

/**
 * 选择与我相关的项目
 *
 * @author Xuj
 * @date 2015年8月5日 15:45:27
 */
public class WheelViewAboutMyProject extends PopupWindow implements View.OnClickListener, PopupWindow.OnDismissListener {
    /* wheelView */
    private WheelView wheelView;
    /* wheelView 适配器 */
    private WheelContentTextAdapter wheelViewAdapter;
    /* wheelView 数据 */
    private List<Project> list;
    /* 上下文 */
    private Activity context;
    /* wheelView 选中回调 */
    private CallBackSingleWheelListener listener;
    /* popwindow */
    private View popView;
    private int pid;
    private int curr;
    private int currentIndex;


    public WheelViewAboutMyProject(Activity context, List<Project> list, boolean isAddAndEdit) {
        super(context);
        this.context = context;
        this.list = list;
        setPopView();
        initView(isAddAndEdit);
    }

    public WheelViewAboutMyProject(Activity context, List<Project> list, boolean isAddAndEdit, int pid) {
        super(context);
        this.context = context;
        this.list = list;
        this.pid = pid;
        setPopView();
        initView(isAddAndEdit);
    }


    public void setSelecteWheelView(int item) {
        wheelView.setCurrentItem(item);
        wheelViewAdapter.setCurrentIndex(item);
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.addproject_dialog, null);
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


    private void initView(boolean isAddAndEdit) {
        wheelView = (WheelView) popView.findViewById(R.id.wheelView);
        TextView tv_context = (TextView) popView.findViewById(R.id.tv_context);
        tv_context.setText("所在项目");
        wheelViewAdapter = new WheelContentTextAdapter(context, list);
        wheelView.setVisibleItems(5);
        wheelView.setViewAdapter(wheelViewAdapter);
        wheelView.setCurrentItem(currentIndex);
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
        popView.findViewById(R.id.confirm).setOnClickListener(this);
        TextView editor = (TextView) popView.findViewById(R.id.editor);
        LinearLayout add = (LinearLayout) popView.findViewById(R.id.add);
        if (isAddAndEdit) {
            editor.setVisibility(View.VISIBLE);
            add.setVisibility(View.VISIBLE);
            editor.setOnClickListener(this);
            add.setOnClickListener(this);
        } else {
            editor.setVisibility(View.GONE);
            add.setVisibility(View.GONE);
        }

//        if (pid != 0 && list.size() > 0) {
//            for (int i = 0; i < list.size(); i++) {
//                if (list.get(i).getPid() == pid) {
//                    wheelView.setCurrentItem(i);
//                    String currentText = (String) wheelViewAdapter.getItemText(wheelView.getCurrentItem());
//                    wheelViewAdapter.setTextViewSize(currentText, wheelViewAdapter);
//
//                    break;
//                }
//            }
//        }

    }


    public void update() {
        wheelViewAdapter.setCurrentIndex(wheelView.getCurrentItem());
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(context, 1.0F);
    }

    private class WheelContentTextAdapter extends AbstractWheelTextAdapter {
        List<Project> list;

        protected WheelContentTextAdapter(Context context, List<Project> list) {
            super(context, R.layout.item_birth_year, NO_RESOURCE, 0);
            this.list = list;
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
            return list.get(index).getPro_name();
        }

        public List<Project> getList() {
            return list;
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.confirm: //确认按钮
                if (listener != null) {
                    int position = wheelView.getCurrentItem();
                    listener.onSelected(wheelViewAdapter.getItemText(position).toString(), position);
                }
                dismiss();
                break;
            case R.id.add: //添加项目
                Intent intent = new Intent(context, AddProjectActivity.class);
                context.startActivityForResult(intent, Constance.REQUEST_ACCOUNT);
                break;
            case R.id.editor: //编辑项目
                Intent intent1 = new Intent(context, EditorProjectActivity.class);
                intent1.putExtra(Constance.BEAN_ARRAY, (Serializable) wheelViewAdapter.getList());
                context.startActivityForResult(intent1, Constance.REQUEST_ACCOUNT);
                break;
        }

    }

    private void changeScrollColor(WheelView wheel) {
        String currentText = (String) wheelViewAdapter.getItemText(wheel.getCurrentItem());
        wheelViewAdapter.setTextViewSize(currentText, wheelViewAdapter);
    }

    public CallBackSingleWheelListener getListener() {
        return listener;
    }

    public void setListener(CallBackSingleWheelListener listener) {
        this.listener = listener;
    }
}