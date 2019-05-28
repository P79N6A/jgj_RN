package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jongg.widget.SwitchView;

import java.util.List;


/**
 * 功能:单聊、群聊管理
 * 时间:2016-12-26 11:51:22
 * 作者:xuj
 */
public class MsgQualityAndSafeFilterAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<ChatManagerItem> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 开关点击事件 */
    private SwithBtnListener listener;
    /* 上下文 */
    private Context context;
    /* 是否已关闭 */
    private boolean isClose;
    private boolean isCheckFilter;

    public MsgQualityAndSafeFilterAdapter(Context context, List<ChatManagerItem> list, SwithBtnListener listener) {
        super();
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
    }


    public MsgQualityAndSafeFilterAdapter(Context context, List<ChatManagerItem> list, SwithBtnListener listener, boolean isCheckFilter) {
        super();
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
        this.isCheckFilter = isCheckFilter;
    }


    public void updateList(List<ChatManagerItem> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public int getItemViewType(int position) {
        return list.get(position).getItemType();
    }

    @Override
    public int getViewTypeCount() {
        return 6;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int type = list.get(position).getItemType();
        ViewHolder holder = null;
        if (convertView == null) {
            holder = new ViewHolder();
            if (type == ChatManagerItem.TEXT_ITEM) { //普通的文本
                convertView = inflater.inflate(R.layout.item_text_chat_manager, null);
            } else if (type == ChatManagerItem.SWITCH_BTN) { //开关
                convertView = inflater.inflate(R.layout.item_switch_chat_manager, null);
            } else if (type == ChatManagerItem.RIGHT_IMAGE_ITEM) { //图片
                convertView = inflater.inflate(R.layout.item_right_image_text_manager, null);
            } else if (type == ChatManagerItem.CHECK_VERSION_ITEM) { //检测版本
                convertView = inflater.inflate(R.layout.item_checkversion_layout, null);
            } else if (type == ChatManagerItem.EDITOR) { //编辑框
                convertView = inflater.inflate(R.layout.item_editor_layout, null);
            } else if (type == ChatManagerItem.TEXT_HINT) { //提示文本
                convertView = inflater.inflate(R.layout.item_text_filter_manager, null);
            }
            findView(holder, convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    public void findView(ViewHolder holder, View convertView) {
        holder.clickIcon = (ImageView) convertView.findViewById(R.id.clickIcon);
        holder.menu = (TextView) convertView.findViewById(R.id.menu);
        holder.menuValue = (TextView) convertView.findViewById(R.id.menuValue);
        holder.value = (TextView) convertView.findViewById(R.id.value);
        holder.valueBottom = (TextView) convertView.findViewById(R.id.valueBottom);
        holder.line = convertView.findViewById(R.id.itemDiver);
        holder.background = convertView.findViewById(R.id.background);
        holder.switchBtn = (SwitchView) convertView.findViewById(R.id.switchBtn);
        holder.isNewVersion = (ImageView) convertView.findViewById(R.id.newVersionIcon);
        holder.editor = (EditText) convertView.findViewById(R.id.editor);
    }


    private void bindData(ViewHolder holder, int position, View convertView) {

        final ChatManagerItem bean = list.get(position);
        if (bean.getItemType() == ChatManagerItem.TEXT_HINT) {
            holder.value.setText(bean.getMenu());
            return;
        }
        holder.background.setVisibility(bean.isShowBackGround() ? View.VISIBLE : View.GONE);
        holder.line.setVisibility(!bean.isShowBackGround() ? View.VISIBLE : View.GONE);
        holder.valueBottom.setVisibility(View.GONE);
        holder.menu.setText(bean.getMenu());
        Utils.setBackGround(convertView, bean.isClick() && bean.getItemType() != ChatManagerItem.EDITOR ? context.getResources().getDrawable(R.drawable.draw_listview_selector_white_gray)
                    : context.getResources().getDrawable(R.color.white));
        if (holder.clickIcon != null) {
            holder.clickIcon.setVisibility(bean.isClick() ? View.VISIBLE : View.GONE);
        }
        if (holder.value != null) {
            holder.value.setText(bean.getValue());
            holder.value.setHint(bean.getMenuHint());
            if (bean.isClick()) {
                holder.value.setTextColor(bean.getValueColor());
            } else {
                holder.value.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            }
        }
        holder.menuValue.setVisibility(!TextUtils.isEmpty(bean.getMenuValue()) ? View.VISIBLE : View.GONE);
        holder.menuValue.setText(bean.getMenuValue());
        //TODO 此处有空需要优化
        if (isCheckFilter) {
            if (position == 1 || position == 5) {
                holder.line.setVisibility(View.GONE);
            }
        } else {
            if (position == 1 || position == 4 || position == 10) {
                holder.line.setVisibility(View.GONE);
            }
        }

    }


    class ViewHolder {

        /* 菜单名称 */
        TextView menu;
        /* 值 */
        TextView value;
        TextView menuValue;
        TextView valueBottom;
        /* 能否点击的图标 */
        ImageView clickIcon;
        /* 线条和背景 */
        View line, background;
        /* 开关按钮 */
        SwitchView switchBtn;
        /* 是否有新版 */
        ImageView isNewVersion;
        /* 编辑框 */
        EditText editor;
    }

    public List<ChatManagerItem> getList() {
        return list;
    }

    public void setList(List<ChatManagerItem> list) {
        this.list = list;
    }


    public interface SwithBtnListener {
        public void toggle(int menuType, boolean toggle);
    }

    public boolean isClose() {
        return isClose;
    }

    public void setClose(boolean close) {
        isClose = close;
    }
}
