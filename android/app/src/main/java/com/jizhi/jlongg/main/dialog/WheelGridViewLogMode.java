package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.GridView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.LogModeAdapter;
import com.jizhi.jlongg.main.bean.LogGroupBean;
import com.jizhi.jlongg.main.util.BackGroundUtil;

import java.util.List;

/**
 * 上班时常、加班时常
 *
 * @author Xuj
 * @date 2015年8月5日 15:45:27
 */
public class WheelGridViewLogMode extends PopupWindow implements View.OnClickListener, LogModeAdapter.GridViewItemListener, PopupWindow.OnDismissListener {
    /* 列表数据 */
    private List<LogGroupBean> list;
    /* 上下文 */
    private Activity activity;
    /* wheelView 选中回调 */
    private WorkTimeListener listener;
    /* 列表适配器 */
    private LogModeAdapter workTimeAdapter;
    /* popwindow */
    private View popView;

    public WheelGridViewLogMode(Activity activity, List<LogGroupBean> list, String title) {
        super(activity);
        this.activity = activity;
        this.list = list;
        setPopView();
        initView(title);
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.layout_wheelview_gridview_log_mode, null);
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
        GridView gridView = (GridView) popView.findViewById(R.id.gv_wy);
        Button btnConfirm = (Button) popView.findViewById(R.id.btn_confirm);
        TextView content = (TextView) popView.findViewById(R.id.tv_context);
        popView.findViewById(R.id.btn_cancel).setVisibility(View.GONE);
        if (list.size() <= 6) {
            popView.findViewById(R.id.tv_white).setVisibility(View.VISIBLE);
        } else {
            popView.findViewById(R.id.tv_white).setVisibility(View.GONE);
        }
        workTimeAdapter = new LogModeAdapter(activity, list, this);
        //如果是才选择点工时间进行工的计算
        if (!title.equals("选择单位")) {
            workTimeAdapter.setAccountTime(true);
        }
        gridView.setAdapter(workTimeAdapter);
        btnConfirm.setOnClickListener(this);
        btnConfirm.setText("关闭");
        content.setText(title);
    }


    @Override
    public void itemClick(int position, String str) {
        if (null != list && list.size() > 0) {
            int size = list.size();
            for (int i = 0; i < size; i++) {
            }
            workTimeAdapter.notifyDataSetChanged();
        }
        listener.workTimeClick(list.get(position).getCat_name(), position, str);
        dismiss();
    }

    @Override
    public void onDismiss() {
        BackGroundUtil.backgroundAlpha(activity, 1.0F);
    }


    @Override
    public void onClick(View v) {
        dismiss();
    }

    public WorkTimeListener getListener() {
        return listener;
    }

    public void setListener(WorkTimeListener listener) {
        this.listener = listener;
    }

    public interface WorkTimeListener {
        public void workTimeClick(String scrollContent, int postion, String str);
    }
}