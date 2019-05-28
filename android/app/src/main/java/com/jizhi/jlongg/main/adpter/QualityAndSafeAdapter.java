package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
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
public class QualityAndSafeAdapter extends BaseAdapter {
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


    public QualityAndSafeAdapter(Context context, List<ChatManagerItem> list, SwithBtnListener listener) {
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
                convertView = inflater.inflate(R.layout.item_image_chat_manager, null);
            } else if (type == ChatManagerItem.CHECK_VERSION_ITEM) { //检测版本
                convertView = inflater.inflate(R.layout.item_checkversion_layout, null);
            } else if (type == ChatManagerItem.EDITOR) { //编辑框
                convertView = inflater.inflate(R.layout.item_editor_layout, null);
            } else if (type == ChatManagerItem.PROJECT_CHANGE) { //整改措施
                LUtils.e("---------------type-----------------");
                convertView = inflater.inflate(R.layout.item_quality_safe_changepro, null);
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
        holder.rightImage = (ImageView) convertView.findViewById(R.id.rightImage);
    }


    private void bindData(ViewHolder holder, int position, View convertView) {
        final ChatManagerItem bean = list.get(position);
        if (holder.background != null) {
            holder.background.setVisibility(bean.isShowBackGround() ? View.VISIBLE : View.GONE);
        }
        if (holder.line != null) {
            holder.line.setVisibility(!bean.isShowBackGround() ? View.VISIBLE : View.GONE);
        }
        if (holder.menu != null) {
            holder.menu.setText(bean.getMenu());
        }
        Utils.setBackGround(convertView, bean.isClick() && bean.getItemType() != ChatManagerItem.EDITOR ? context.getResources().getDrawable(R.drawable.draw_listview_selector_white_gray)
                    : context.getResources().getDrawable(R.color.white));
        if (holder.clickIcon != null) {
            holder.clickIcon.setVisibility(bean.isClick() ? View.VISIBLE : View.GONE);
        }
        if (holder.value != null) {
            holder.value.setText(bean.getValue());
            holder.value.setHint(bean.getMenuHint());
//            if (bean.isClick()) {
//                holder.value.setTextColor(bean.getValueColor());
//            } else {
//                holder.value.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
//            }
            holder.value.setTextColor(bean.getValueColor());
        }
        int itemType = bean.getItemType();
        if (itemType == ChatManagerItem.TEXT_ITEM) { //普通文本
            holder.rightImage.setImageResource(bean.getRightImageResources());
            holder.menuValue.setVisibility(!TextUtils.isEmpty(bean.getMenuValue()) ? View.VISIBLE : View.GONE);
            holder.menuValue.setText(bean.getMenuValue());
            holder.valueBottom.setVisibility(View.GONE);
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
        } else if (itemType == ChatManagerItem.PROJECT_CHANGE) {
            holder.editor.setText(bean.getValue());
            setFocusEdit(holder.editor, position);
            setEditTextChange(holder.editor);

//            holder.isNewVersion.setVisibility(bean.isNewVersion() ? View.VISIBLE : View.GONE);
        }

    }

    public void setEditTextChange(final EditText editText) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (listener != null) {
                    listener.setProChange(editText.getText().toString());
                }
//                Integer tag = (Integer) editText.getTag();
//                saveMap.put(tag, s.toString());//在这里根据position去保存文本内容
//                timeClickListener.setEditText(position, saveMap.get(position), isWeather, weatherType);
            }
        });
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
        ImageView rightImage;
        TextView valueBottom;
    }

    int index = -1;

    /**
     * 解决liview中edittext弹出键盘焦点失去问题
     *
     * @param editText
     * @param position
     */
    public void setFocusEdit(EditText editText, final int position) {
        editText.setTag(position);
        editText.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    // 在TOUCH的UP事件中，要保存当前的行下标，因为弹出软键盘后，整个画面会被重画
                    // 在getView方法的最后，要根据index和当前的行下标手动为EditText设置焦点
                    index = position;
                }
                return false;
            }
        });
        editText.clearFocus();
        // 如果当前的行下标和点击事件中保存的index一致，手动为EditText设置焦点。
        if (index != -1 && index == position) {
            editText.requestFocus();
        }
        // 焦点移到最后
        editText.setSelection(editText.getText().length());

    }

    public List<ChatManagerItem> getList() {
        return list;
    }

    public void setList(List<ChatManagerItem> list) {
        this.list = list;
    }


    public interface SwithBtnListener {
        public void toggle(int menuType, boolean toggle);

        public void setProChange(String str);
    }

    public boolean isClose() {
        return isClose;
    }

    public void setClose(boolean close) {
        isClose = close;
    }
}
