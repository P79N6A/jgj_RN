package com.jizhi.jlongg.main.adpter.check;

/**
 * Created by Administrator on 2017/12/8 0008.
 */

import android.app.Activity;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CheckPoint;

import java.util.List;

/**
 * CName:新建检查内容适配器
 * User: xuj
 * Date: 2017年11月17日10:16:38
 * Time: 10:01:41
 */
public class CreateCheckContentAdapter extends BaseAdapter {
    /**
     * EditText 触摸的下标,重新获取焦点时 使用
     */
    public int editTouchIndex = -1;
    /**
     * 显示输入检查点信息
     */
    private int SHOW_INPUT_CHECK_CONTENT = 0;
    /**
     * 显示检查内容
     */
    private int SHOW_CHECK_CONTENT = 1;
    /**
     * 显示默认页
     */
    private int SHOW_EMPTY_CONTENT = 2;
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * 列表数据
     */
    private List<CheckPoint> list;
    /**
     * 默认数据页的高度
     */
    private int listViewHeadHeight;


    @Override
    public int getItemViewType(int position) {
        if (list == null || list.size() == 0) {
            return SHOW_EMPTY_CONTENT;
        }
        CheckPoint checkContent = list.get(position);
        if (checkContent.isAddCheckContent()) {
            return SHOW_INPUT_CHECK_CONTENT;
        } else {
            return SHOW_CHECK_CONTENT;
        }
    }

    @Override
    public int getViewTypeCount() {
        return 3;
    }

    public CreateCheckContentAdapter(Activity context, List<CheckPoint> list) {
        this.list = list;
        this.activity = context;
    }

    public int getCount() {
        if (getItemViewType(0) == SHOW_EMPTY_CONTENT) {
            return 1;
        }
        return list.size();
    }

    public CheckPoint getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
        int itemType = getItemViewType(position);
        if (itemType == SHOW_EMPTY_CONTENT) {  //无数据时展示的页面
            convertView = LayoutInflater.from(activity).inflate(R.layout.default_check, parent, false);
            if (listViewHeadHeight != 0) {
                TextView defaultDesc = (TextView) convertView.findViewById(R.id.defaultDesc);
                defaultDesc.setText(R.string.no_check_point);
                AbsListView.LayoutParams params = (AbsListView.LayoutParams) defaultDesc.getLayoutParams();
                params.height = parent.getHeight() - listViewHeadHeight;
                defaultDesc.setLayoutParams(params);
            }
            return convertView;
        }
        ViewHolder holder = null;
        if (convertView == null) {
            if (itemType == SHOW_INPUT_CHECK_CONTENT) { //输入检查点
                convertView = LayoutInflater.from(activity).inflate(R.layout.item_input_check_content, parent, false);
                holder = new ViewHolder(convertView, itemType);
                convertView.setTag(holder);
            } else if (itemType == SHOW_CHECK_CONTENT) { //检查点内容
                convertView = LayoutInflater.from(activity).inflate(R.layout.item_check_content_or_check_point, parent, false);
                holder = new ViewHolder(convertView, itemType);
                convertView.setTag(holder);
            }
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(position, convertView, holder);
        return convertView;
    }

    private void bindData(final int position, View convertView, final ViewHolder holder) {
        final CheckPoint bean = getItem(position);
        if (bean.isAddCheckContent()) { //添加检查内容
            holder.inputCheckContentEdit.setTag(position);
            setFocusEdit(holder.inputCheckContentEdit, position);
            setEditTextChange(holder.inputCheckContentEdit, position);
            holder.inputCheckContentEdit.setText(list.get(position).getDot_name());
        } else { //显示展示内容
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.checkContent.getLayoutParams();
            int peddingTopBottom = (int) activity.getResources().getDimension(R.dimen.check_padding);
            params.topMargin = peddingTopBottom;
            params.bottomMargin = peddingTopBottom;
            holder.checkContent.setLayoutParams(params);
            holder.checkContent.setText(bean.getDot_name());
        }
        holder.deleteCheckContentIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                list.remove(position);
                notifyDataSetChanged();
            }
        });
        holder.divierLine.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
    }

    class ViewHolder {

        public ViewHolder(View convertView, int type) {
            if (type == SHOW_INPUT_CHECK_CONTENT) {
                inputCheckContentEdit = (EditText) convertView.findViewById(R.id.inputCheckContentEdit);
            } else {
                checkContent = (TextView) convertView.findViewById(R.id.checkContent);
            }
            deleteCheckContentIcon = convertView.findViewById(R.id.deleteCheckContentIcon);
            divierLine = convertView.findViewById(R.id.divierLine);
        }

        /**
         * 删除检查内容图标
         */
        View deleteCheckContentIcon;
        /**
         * 检查内容名称
         */
        TextView checkContent;
        /**
         * 输入的检查内容
         */
        EditText inputCheckContentEdit;
        /**
         * 分割线
         */
        View divierLine;
    }

    public List<CheckPoint> getList() {
        return list;
    }

    public void setList(List<CheckPoint> list) {
        this.list = list;
    }

    /**
     * 解决liview中edittext弹出键盘焦点失去问题
     *
     * @param editText
     * @param position
     */
    private void setFocusEdit(final EditText editText, final int position) {
        if (editText == null) {
            return;
        }
        editText.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    // 在TOUCH的UP事件中，要保存当前的行下标，因为弹出软键盘后，整个画面会被重画
                    // 在getView方法的最后，要根据index和当前的行下标手动为EditText设置焦点
                    editTouchIndex = position;
                }
                return false;
            }
        });
        editText.clearFocus();
        // 如果当前的行下标和点击事件中保存的index一致，手动为EditText设置焦点。
        if (editTouchIndex != -1 && editTouchIndex == position) {
            editText.requestFocus();
        }
    }

    private void setEditTextChange(final EditText editText, final int position) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                Integer tag = (Integer) editText.getTag();
                if (tag == position) {
//                        editText.setSelection(editText.getText().length());// 焦点移到最后
                    list.get(position).setDot_name(s.toString());
                }
            }
        });
    }

    public int getListViewHeadHeight() {
        return listViewHeadHeight;
    }

    public void setListViewHeadHeight(int listViewHeadHeight) {
        this.listViewHeadHeight = listViewHeadHeight;
    }


}
