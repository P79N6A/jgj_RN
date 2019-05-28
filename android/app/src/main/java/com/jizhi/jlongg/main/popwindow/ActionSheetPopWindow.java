package com.jizhi.jlongg.main.popwindow;

import android.app.Activity;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.BackGroundUtil;


/**
 * Created by SCY on 2017/9/4 14:40.
 */

public class ActionSheetPopWindow {
    private Activity activity;
    private PopupWindow popupWindow;
    private View parent;
    private TextView work_over_day_pop;
    private TextView work_over_hour_pop;
    private TextView cancel_pop;
    private ActionSheetPopClickListener onclickListener;

    public ActionSheetPopWindow(Activity activity, View parent) {
        this.activity = activity;
        this.parent=parent;
        initPopWindow();
    }

    private void initPopWindow(){
        View layout = View.inflate(activity, R.layout.action_sheet_pop,null);
        work_over_day_pop = layout.findViewById(R.id.work_over_day_pop);
        work_over_hour_pop = layout.findViewById(R.id.work_over_hour_pop);
        cancel_pop = layout.findViewById(R.id.cancel_pop);

        popupWindow = new PopupWindow(layout, ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT,true);
        popupWindow.setContentView(layout);
        popupWindow.setFocusable(true);
        popupWindow.setAnimationStyle(R.style.ActionSheetDialogAnimation);
        popupWindow.setBackgroundDrawable(new ColorDrawable(0xb0000000));
        popupWindow.setOutsideTouchable(true);

        work_over_day_pop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onclickListener!=null){
                    onclickListener.onClickWorkOverDay(v);
                    hide();
                }else {
                    hide();
                }
            }
        });

        work_over_hour_pop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onclickListener!=null){
                    onclickListener.onClickWorkOverHour(v);
                    hide();
                }else {
                    hide();
                }
            }
        });

        popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                BackGroundUtil.backgroundAlpha(activity, 1F);
            }
        });
        cancel_pop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hide();
            }
        });
    }

    public void hide(){
        if (popupWindow!=null&&!(activity).isFinishing()){
            popupWindow.dismiss();
        }
    }
    public void show(){
        if (popupWindow!=null&&!(activity).isFinishing()) {
            popupWindow.showAtLocation(parent, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
            BackGroundUtil.backgroundAlpha(activity, 0.5F);
        }
    }

    public interface ActionSheetPopClickListener{
        void onClickWorkOverDay(View view);
        void onClickWorkOverHour(View view);
    }
    public void setOnActionSheetPopClickListener(ActionSheetPopClickListener onclickListener){
        this.onclickListener=onclickListener;
    }
}
