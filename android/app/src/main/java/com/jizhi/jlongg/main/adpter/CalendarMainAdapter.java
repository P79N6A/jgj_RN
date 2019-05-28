package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.ScreenUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.HorizotalItemBean;

import java.util.List;


/**
 * 功能:日历首页数据
 * 时间:2018年12月13日14:59:36
 * 作者:xuj
 */
public class CalendarMainAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<HorizotalItemBean> list;
    /**
     * 上下文
     */
    private Context context;
    /**
     * 1.当屏高度无法显示下方功能按钮第一排的1/2以上,且点击下方功能<=5 次时加入提示“ 滑动页面，还有更多功能哦～ ”;
     * 2.向下滑动页面时 提示消失，且到关闭重新打开app前都不再提示
     */
    private ScrollGuideListener listener;
    /**
     * 模块加载完毕的标识
     */
    private boolean loadedMenuLayoutFinish;


    public CalendarMainAdapter(Context context, List<HorizotalItemBean> list) {
        super();
        this.list = list;
        this.context = context;
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public HorizotalItemBean getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        final HorizotalItemBean bean = getItem(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_calendar_main, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.menu.setText(bean.getMenu());
        if (bean.getMenuDrawable() != null) {
            bean.getMenuDrawable().setBounds(0, 0, bean.getMenuDrawable().getIntrinsicWidth(), bean.getMenuDrawable().getIntrinsicHeight());
            holder.menu.setCompoundDrawables(null, bean.getMenuDrawable(), null, null);
        }
        Utils.setBackGround(convertView, bean.isClick() ? context.getResources().getDrawable(R.drawable.draw_listview_selector_white_gray)
                : context.getResources().getDrawable(R.color.white));
        if (!TextUtils.isEmpty(bean.getValue())) {
            holder.value.setVisibility(View.VISIBLE);
            holder.value.setText(bean.getValue());
            holder.value.setTextColor(bean.getValueColor());
        } else {
            holder.value.setText("");
            holder.value.setVisibility(View.INVISIBLE);
        }
        if (bean.isShow_little_red_dot()) {
            holder.redTips.setVisibility(View.GONE);
            holder.redDot.setVisibility(View.VISIBLE);
        } else {
            holder.redDot.setVisibility(View.GONE);
            if (!TextUtils.isEmpty(bean.getRed_tips())) {
                holder.redTips.setVisibility(View.VISIBLE);
                holder.redTips.setText(bean.getRed_tips());
            } else {
                holder.redTips.setVisibility(View.GONE);
            }
        }
        if (position == 0 && !loadedMenuLayoutFinish) {
            loadedMenuLayoutFinish = true;
            if (listener == null) {
                return convertView;
            }
            final View finalConvertView = convertView;
            convertView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                public void onGlobalLayout() {
                    if (finalConvertView.getHeight() == 0 || finalConvertView.getWidth() == 0) {
                        return;
                    }
                    //2.向下滑动页面时 提示消失，且到关闭重新打开app前都不再提示
                    int[] location = new int[2];
                    finalConvertView.getLocationOnScreen(location);
                    //1.当屏高度无法显示下方功能按钮第一排的1/2以上,且点击下方功能<=5 次时加入提示“ 滑动页面，还有更多功能哦～ ”;
                    if (location[1] > ScreenUtils.getScreenHeight(context.getApplicationContext()) - finalConvertView.getHeight() / 2) {
                        listener.loadMenuFinish(true);
                    } else {
                        listener.loadMenuFinish(false);
                    }
                    if (Build.VERSION.SDK_INT >= 16) {
                        finalConvertView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    } else {
                        finalConvertView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    }
                }
            });
        }
        return convertView;
    }


    public List<HorizotalItemBean> getList() {
        return list;
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            menu = (TextView) convertView.findViewById(R.id.menu);
            value = (TextView) convertView.findViewById(R.id.value);
            redTips = (TextView) convertView.findViewById(R.id.red_tips);
            redDot = convertView.findViewById(R.id.red_dot);
        }

        /**
         * 菜单名称
         */
        TextView menu;
        /**
         * 菜单值
         */
        TextView value;
        /**
         * 红色提示框
         */
        TextView redTips;
        /**
         * 小红点
         */
        View redDot;
    }

    public void setList(List<HorizotalItemBean> list) {
        this.list = list;
    }

    /**
     * 1.当屏高度无法显示下方功能按钮第一排的1/2以上,且点击下方功能<=5 次时加入提示“ 滑动页面，还有更多功能哦～ ”;
     * 2.向下滑动页面时 提示消失，且到关闭重新打开app前都不再提示
     */
    public interface ScrollGuideListener {
        public void loadMenuFinish(boolean isShowScrollGuide);
    }

    public ScrollGuideListener getListener() {
        return listener;
    }

    public void setListener(ScrollGuideListener listener) {
        this.listener = listener;
    }
}
