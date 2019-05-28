package com.jizhi.jlongg.main.popwindow;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.dialog.PopupWindowExpand;
import com.jizhi.jlongg.main.util.AccountUtil;

import java.util.List;


/**
 * 单选框
 *
 * @author Xuj
 * @date 2017年6月8日17:12:09
 */
public class SingleSelectedPopWindow extends PopupWindowExpand {

    /**
     * 列表数据
     */
    private List<SingleSelected> list;
    /**
     * 单选回调
     */
    private SingleSelectedListener listener;
    /**
     * 注销账户标识
     */
    private boolean cancelAccount;


    public SingleSelectedPopWindow(Activity activity, List<SingleSelected> list, SingleSelectedListener listener) {
        super(activity);
        this.activity = activity;
        this.list = list;
        this.listener = listener;
        setPopView();
        initView();
    }

    public SingleSelectedPopWindow(Activity activity, List<SingleSelected> list, SingleSelectedListener listener, boolean setAlpha) {
        super(activity);
        this.activity = activity;
        this.list = list;
        this.listener = listener;
        setPopView();
        initView();
        setAlpha(setAlpha);
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.popwindow_single_selected, null);
        setContentView(popView);
        setPopParameter();
    }

    public void setTopToBottomAnimation() {
        super.setTopToBottomAnimation();
    }

    public void cancelAnimation() {
        setAnimationStyle(-1);
    }

    private void initView() {
        ListView listView = (ListView) popView.findViewById(R.id.listView);
        listView.setAdapter(new SingleSelectedAdapter(activity, list));
    }

    /**
     * 功能:单选适配器
     * 时间:2017年6月8日17:50:47
     * 作者:xuj
     */
    public class SingleSelectedAdapter extends BaseAdapter {
        /**
         * 列表数据
         */
        private List<SingleSelected> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;

        /**
         * 普通文本item
         */
        private final int TEXT_ITEM = 0;
        /**
         * 注销账户,主要是设置里面点进去需要使用 item
         */
        private final int UN_SUB_ACCOUNT_ITEM = 1;
        /**
         * 切换记工显示方式
         */
        private final int CHANGE_ACCOUNT_SHOW_TYPE = 2;

        @Override
        public int getViewTypeCount() {
            return 3;
        }

        @Override
        public int getItemViewType(int position) {
            if (getItem(position).isCancelAccount()) {
                return UN_SUB_ACCOUNT_ITEM;
            } else if (getItem(position).isChange_account_show_type()) {
                return CHANGE_ACCOUNT_SHOW_TYPE;
            } else {
                return TEXT_ITEM;
            }
        }

        public SingleSelectedAdapter(Context context, List<SingleSelected> list) {
            super();
            this.list = list;
            inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public SingleSelected getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder = null;
            int type = getItemViewType(position);
            if (convertView == null) {
                if (type == TEXT_ITEM) {
                    convertView = inflater.inflate(R.layout.item_selected_single, null);
                } else if (type == UN_SUB_ACCOUNT_ITEM) {
                    convertView = inflater.inflate(R.layout.item_cancel_account, null);
                } else if (type == CHANGE_ACCOUNT_SHOW_TYPE) {
                    convertView = inflater.inflate(R.layout.item_change_account_show_type, null);
                }
                holder = new ViewHolder(convertView, type);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, type);
            return convertView;
        }


        private void bindData(ViewHolder holder, final int position, int type) {
            SingleSelected bean = list.get(position);
            if (type == TEXT_ITEM) {
                holder.name.setText(bean.getName());
                holder.name.setTextColor(bean.getTextColor());
                holder.name.setTextSize(bean.getTextSize() == 0 ? 18 : bean.getTextSize());
                holder.selectedIcon.setVisibility(bean.isShowSelectedIcon() ? View.VISIBLE : View.GONE);
                if (TextUtils.isEmpty(bean.getValue())) {
                    holder.value.setVisibility(View.GONE);
                } else {
                    holder.value.setVisibility(View.VISIBLE);
                    holder.value.setText(bean.getValue());
                }
            } else if (type == CHANGE_ACCOUNT_SHOW_TYPE) {
                switch (AccountUtil.getDefaultAccountUnit(activity)) {
                    case AccountUtil.WORK_AS_UNIT:
                        holder.name.setText("上班、加班按工天");
                        break;
                    case AccountUtil.WORK_OF_HOUR:
                        holder.name.setText("上班、加班按小时");
                        break;
                    case AccountUtil.MANHOUR_AS_UNIT_OVERTIME_AS_HOUR:
                        holder.name.setText("上班按工天、加班按小时");
                        break;
                }
            }
            holder.line.setVisibility(bean.isShowBackGround() ? View.GONE : View.VISIBLE);
            holder.background.setVisibility(bean.isShowBackGround() ? View.VISIBLE : View.GONE);
            holder.item.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (listener != null) {
                        listener.getSingleSelcted(list.get(position));
                    }
                    dismiss();
                }
            });
        }

        class ViewHolder {
            /**
             * 菜单名称
             */
            TextView name;
            /**
             * 菜单底部的值
             */
            TextView value;
            /**
             * 选中状态的图标
             */
            ImageView selectedIcon;
            /**
             * 分割线
             */
            View line;
            /**
             * 背景色
             */
            View background;
            /**
             * item
             */
            View item;

            public ViewHolder(View convertView, int type) {
                if (type == TEXT_ITEM) {
                    name = (TextView) convertView.findViewById(R.id.name);
                    value = (TextView) convertView.findViewById(R.id.value);
                    selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
                } else if (type == CHANGE_ACCOUNT_SHOW_TYPE) {
                    name = (TextView) convertView.findViewById(R.id.name);
                }
                line = convertView.findViewById(R.id.itemDiver);
                item = convertView.findViewById(R.id.item);
                background = convertView.findViewById(R.id.background);
            }

        }

    }


    public interface SingleSelectedListener {
        public void getSingleSelcted(SingleSelected bean);
    }

    public boolean isCancelAccount() {
        return cancelAccount;
    }

    public void setCancelAccount(boolean cancelAccount) {
        this.cancelAccount = cancelAccount;
    }
}