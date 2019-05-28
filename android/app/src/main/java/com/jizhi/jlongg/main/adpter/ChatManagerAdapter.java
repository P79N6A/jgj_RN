package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Color;
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
import com.jizhi.jlongg.main.activity.SetActivity;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jongg.widget.SwitchView;

import java.util.List;


/**
 * 功能:单聊、群聊管理
 * 时间:2016-12-26 11:51:22
 * 作者:xuj
 */
public class ChatManagerAdapter extends BaseAdapter {
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


    public ChatManagerAdapter(Context context, List<ChatManagerItem> list, SwithBtnListener listener) {
        super();
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
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
        return 8;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public ChatManagerItem getItem(int position) {
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
                convertView = inflater.inflate(R.layout.item_image_chat_manager, null);
            } else if (type == ChatManagerItem.CHECK_VERSION_ITEM) { //检测版本
                convertView = inflater.inflate(R.layout.item_checkversion_layout, null);
            } else if (type == ChatManagerItem.EDITOR) { //编辑框
                convertView = inflater.inflate(R.layout.item_editor_layout, null);
            }else if (type == ChatManagerItem.RIGHT_IMAGE_AND_ARROW) { //右侧有图片跟箭头
                convertView = inflater.inflate(R.layout.item_right_pic_and_arrow, null);
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
        holder.line = convertView.findViewById(R.id.itemDiver);
        holder.background = convertView.findViewById(R.id.background);
        holder.switchBtn = (SwitchView) convertView.findViewById(R.id.switchBtn);
        holder.isNewVersion = (ImageView) convertView.findViewById(R.id.newVersionIcon);
        holder.editor = (EditText) convertView.findViewById(R.id.editor);
        holder.rightImage = (ImageView) convertView.findViewById(R.id.rightImage);
        holder.valueBottom = (TextView) convertView.findViewById(R.id.valueBottom);
    }


    private void bindData(ViewHolder holder, int position, View convertView) {
        final ChatManagerItem bean = list.get(position);
        holder.background.setVisibility(bean.isShowBackGround() ? View.VISIBLE : View.GONE);
        holder.line.setVisibility(!bean.isShowBackGround() ? View.VISIBLE : View.GONE);
        holder.menu.setText(bean.getMenu());
        if (bean.getMenuDrawable() != null) {
            bean.getMenuDrawable().setBounds(0, 0, bean.getMenuDrawable().getIntrinsicWidth(), bean.getMenuDrawable().getIntrinsicHeight());
            holder.menu.setCompoundDrawables(bean.getMenuDrawable(), null, null, null);
        }
        Utils.setBackGround(convertView, bean.isClick() && bean.getItemType() != ChatManagerItem.EDITOR ? context.getResources().getDrawable(R.drawable.draw_listview_selector_white_gray)
                : context.getResources().getDrawable(R.color.white));
        if (holder.clickIcon != null) {
            holder.clickIcon.setVisibility(bean.isClick() ? View.VISIBLE : View.GONE);
        }
        //处理关联账号布局
        if(bean.getMenuType() == SetActivity.BIND_WX && bean.getItemType()==ChatManagerItem.RIGHT_IMAGE_AND_ARROW){
            convertView.findViewById(R.id.image).setVisibility(bean.isHideRightImage()?View.GONE:View.VISIBLE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                ((ImageView)convertView.findViewById(R.id.image)).setImageDrawable(ContextCompat.getDrawable(context, R.drawable.icon_wechat_logo));

            } else {
                ((ImageView)convertView.findViewById(R.id.image)).setImageResource(R.drawable.icon_wechat_logo);
            }
        }
        if (holder.value != null) {

            //            if (bean.isClick()) {
//                holder.value.setTextColor(bean.getValueColor());
//            } else {
//                holder.value.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
//            }
            if (TextUtils.isEmpty(bean.getValue())) {
                holder.value.setVisibility(View.GONE);
            } else {
                holder.value.setVisibility(View.VISIBLE);
                holder.value.setText(bean.getValue());
                holder.value.setHint(bean.getMenuHint());
                holder.value.setTextColor(bean.getValueColor());
            }
        }
        int itemType = bean.getItemType();
        if (itemType == ChatManagerItem.TEXT_ITEM) { //普通文本
            holder.rightImage.setImageResource(bean.getRightImageResources());
            if (TextUtils.isEmpty(bean.getMenuValue())) {
                holder.menuValue.setVisibility(View.GONE);
            } else {
                holder.menuValue.setText(bean.getMenuValue());
                holder.menuValue.setVisibility(View.VISIBLE);
                holder.menuValue.setTextColor(bean.getMenuValueColor() == 0 ? Color.parseColor("#333333") : bean.getMenuValueColor());
            }
            if (TextUtils.isEmpty(bean.getValueBottom())) {
                holder.valueBottom.setVisibility(View.GONE);
            } else {
                holder.valueBottom.setText(bean.getValueBottom());
                holder.valueBottom.setVisibility(View.VISIBLE);
                holder.valueBottom.setTextColor(bean.getValueBottomColor() == 0 ? Color.parseColor("#333333") : bean.getValueBottomColor());
                holder.valueBottom.setTextSize(bean.getValueBottomSize() == 0 ? 11 : bean.getValueBottomSize());
            }
        } else if (itemType == ChatManagerItem.EDITOR) {
            holder.editor.setHint(bean.getMenuHint());
            holder.editor.setText(bean.getValue());
        } else if (itemType == ChatManagerItem.CHECK_VERSION_ITEM) {
            holder.isNewVersion.setVisibility(bean.isNewVersion() ? View.VISIBLE : View.GONE);
        } else if (itemType == ChatManagerItem.SWITCH_BTN) { //开关Item
            holder.switchBtn.setVisibility(bean.getItemType() == ChatManagerItem.SWITCH_BTN ? View.VISIBLE : View.GONE);
            holder.switchBtn.toggleSwitch(bean.isSwitchState());
            holder.switchBtn.setOnStateChangedListener(new SwitchView.OnStateChangedListener() {
                @Override
                public void toggleToOn(SwitchView view) {
                    if (isClose) {
                        return;
                    }
                    if (listener != null) {
                        listener.toggle(bean.getMenuType(), true);
                    }
                    view.toggleSwitch(false); //
                }

                @Override
                public void toggleToOff(SwitchView view) {
                    if (isClose) {
                        return;
                    }
                    if (listener != null) {
                        listener.toggle(bean.getMenuType(), false);
                    }
                    view.toggleSwitch(true); // or false
                }
            });
        }
    }


    class ViewHolder {

        /* 菜单名称 */
        TextView menu;
        /* 值 */
        TextView value;
        TextView menuValue;
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

        TextView valueBottom;
        ImageView rightImage;
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
