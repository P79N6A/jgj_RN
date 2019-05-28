package com.jizhi.jlongg.main.popwindow;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
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

import java.util.List;


/**
 * 单选框
 *
 * @author Xuj
 * @date 2017年6月8日17:12:09
 */
public class TitleSingleSelectedPopWindow extends PopupWindowExpand implements View.OnClickListener {

    /**
     * 列表数据
     */
    private List<SingleSelected> list;
    /**
     * 单选回调
     */
    private TitleSingleSelectedListener listener;


    public TitleSingleSelectedPopWindow(Activity activity, List<SingleSelected> list, String title, int res,
                                        TitleSingleSelectedListener listener) {
        super(activity);
        this.activity = activity;
        this.list = list;
        this.listener = listener;
        setPopView();
        initView(title, res);
        setAlpha(true);
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.popwindow_title_single_selected, null);
        setContentView(popView);
        setPopParameter();
        cancelAnimation();
//        setTopToBottomAnimation();
    }


    public void cancelAnimation() {
        setAnimationStyle(-1);
    }

    private void initView(String title, int res) {
        ListView listView = (ListView) popView.findViewById(R.id.listView);
        listView.setAdapter(new TitleSingleSelectedAdapter(activity, list));
        TextView titleText = (TextView) popView.findViewById(R.id.title);
        ImageView titleImage = (ImageView) popView.findViewById(R.id.titleImage);

        TextView rightTitle = (TextView) popView.findViewById(R.id.right_title);
        rightTitle.setText(R.string.more);

//        ImageView rightImage = (ImageView) popView.findViewById(R.id.rightImage);
//        rightImage.setImageResource(R.drawable.red_dots);
        titleText.setText(title);
//        rightImage.setVisibility(View.VISIBLE);
        titleImage.setVisibility(View.VISIBLE);
        titleImage.setImageResource(res);
        titleImage.setOnClickListener(this);
        titleText.setOnClickListener(this);
        rightTitle.setOnClickListener(this);
//        rightImage.setOnClickListener(this);
        popView.findViewById(R.id.returnText).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        if (listener == null) {
            return;
        }
        dismiss();
        switch (v.getId()) {
            case R.id.right_title: //右边按钮弹框
                listener.clickRightImage();
                break;
            case R.id.returnText: //返回按钮
                dismiss();
                activity.finish();
                break;
        }
    }

    /**
     * 功能:单选适配器
     * 时间:2017年6月8日17:50:47
     * 作者:xuj
     */
    public class TitleSingleSelectedAdapter extends BaseAdapter {
        /**
         * 列表数据
         */
        private List<SingleSelected> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;


        public TitleSingleSelectedAdapter(Context context, List<SingleSelected> list) {
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
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_selected_single, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position);
            return convertView;
        }


        private void bindData(ViewHolder holder, final int position) {
            SingleSelected bean = list.get(position);
            holder.name.setText(bean.getName());
            holder.name.setTextColor(bean.getTextColor());
            holder.name.setTextSize(bean.getTextSize() == 0 ? 16 : bean.getTextSize());
            holder.selectedIcon.setVisibility(bean.isShowSelectedIcon() ? View.VISIBLE : View.GONE);
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

            public ViewHolder(View convertView) {
                name = (TextView) convertView.findViewById(R.id.name);
                selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
                line = convertView.findViewById(R.id.itemDiver);
                item = convertView.findViewById(R.id.item);
                background = convertView.findViewById(R.id.background);
            }
        }
    }

    public interface TitleSingleSelectedListener {
        public void getSingleSelcted(SingleSelected bean);

        public void clickRightImage();
    }

}