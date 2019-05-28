package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.RecordItem;
import com.jizhi.jlongg.main.util.DecimalInputFilter;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AccountEditAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<AccountBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;

    private Context context;
    private AccountOnItemValueClickLitener accountOnItemValueClickLitener;
    //记账类型，角色
    private String account_type;
    int index = -1;
    /*记账数据*/
    private String WorkerName;

    public void setWorkerName(String WorkerName) {
        this.WorkerName = WorkerName;
    }

    public AccountEditAdapter(Context context, List<AccountBean> list, String account_type, AccountOnItemValueClickLitener accountOnItemValueClickLitener) {
        super();

        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
        this.context = context;
        this.account_type = account_type;
        this.accountOnItemValueClickLitener = accountOnItemValueClickLitener;
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

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_account_edit, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        AccountBean bean = list.get(position);
        Utils.setBackGround(holder.img_icon, bean.getIcon_drawable());
        //10dp分割线
        if (bean.isShowLine10()) {
            holder.view_10px.setVisibility(View.VISIBLE);
        } else {
            holder.view_10px.setVisibility(View.GONE);
        }
        //右侧箭头
        if (bean.isShowArrow()) {
            holder.img_arrow.setVisibility(View.VISIBLE);
        } else {
            holder.img_arrow.setVisibility(View.GONE);
        }
        holder.tv_content.setTextColor(ContextCompat.getColor(context, bean.getText_color()));
        holder.ed_text.setTextColor(ContextCompat.getColor(context, bean.getText_color()));

        holder.tv_name.setText(bean.getLeft_text());
        if (bean.getItem_type().equals(RecordItem.SUBENTRY_NAME)) {
            holder.tv_content.setVisibility(View.GONE);
            holder.ed_text.setVisibility(View.VISIBLE);
            holder.ed_text.setTag(position);
            holder.ed_text.setText(bean.getRight_value());
            setFocusEdit(holder.ed_text, position);
            holder.ed_text.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
            setEditTextLength(holder.ed_text, "0，6");
            setEditTextChange(holder, bean.getItem_type());
        } else if (bean.getItem_type().equals(RecordItem.UNIT_PRICE)) {
            holder.tv_content.setVisibility(View.GONE);
            holder.ed_text.setVisibility(View.VISIBLE);
            holder.ed_text.setTag(position);
            holder.ed_text.setText(bean.getRight_value());
            setFocusEdit(holder.ed_text, position);
            setEditTextDecimalNumberLength(holder.ed_text, 2);
            setEditTextLength(holder.ed_text, "0，6");
            setEditTextChange(holder, bean.getItem_type());
        } else if (bean.getItem_type().equals(RecordItem.SALARY_MONEY)) {
            holder.tv_content.setVisibility(View.GONE);
            holder.ed_text.setVisibility(View.VISIBLE);
            holder.ed_text.setTag(position);
            holder.ed_text.setText(bean.getRight_value());
            setFocusEdit(holder.ed_text, position);
            setEditTextChange(holder, bean.getItem_type());
            setEditTextLength(holder.ed_text, "0，6");
            setEditTextDecimalNumberLength(holder.ed_text, 2);
        } else if (bean.getItem_type().equals(AccountBean.SUM_MONEY)) {
            //借支金额
            holder.tv_content.setVisibility(View.GONE);
            holder.ed_text.setVisibility(View.VISIBLE);
            holder.ed_text.setTag(position);
            LUtils.e("--------------getRight_value-------------" + bean.getRight_value());
            if (!TextUtils.isEmpty(bean.getRight_value())) {
                holder.ed_text.setText(Utils.m2(Double.parseDouble(bean.getRight_value())));
            }
            setFocusEdit(holder.ed_text, position);
            setEditTextChange(holder, bean.getItem_type());
            setEditTextLength(holder.ed_text, "0，6");
            setEditTextDecimalNumberLength(holder.ed_text, 2);
        } else if (bean.getItem_type().equals(RecordItem.P_S_TIME) || bean.getItem_type().equals(RecordItem.P_E_TIME)) {
            holder.tv_content.setVisibility(View.VISIBLE);
            holder.ed_text.setVisibility(View.GONE);
            if (TextUtils.isEmpty(bean.getRight_value())) {
                holder.tv_content.setText("请选择");
                holder.tv_content.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
            } else {
                holder.tv_content.setText(bean.getRight_value());
                holder.tv_content.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            }

        } else if (bean.getItem_type().equals(AccountBean.SELECTED_ROLE)) {
            //借支金额
            holder.tv_content.setVisibility(View.VISIBLE);
            holder.ed_text.setVisibility(View.GONE);
            holder.tv_content.setText(TextUtils.isEmpty(WorkerName) ? "" : WorkerName);
        } else {
            holder.ed_text.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
            holder.tv_content.setVisibility(View.VISIBLE);
            holder.ed_text.setVisibility(View.GONE);
            holder.tv_content.setText(bean.getRight_value());
        }
        if (bean.getItem_type().equals(RecordItem.ALL_MONEY)) {
            //点工工钱加粗
            holder.tv_content.getPaint().setFakeBoldText(true);
        } else if (bean.getItem_type().equals(RecordItem.SUM_MONEY)) {
            //SUM_MONEY 借支金额加粗
            holder.ed_text.getPaint().setFakeBoldText(true);
        } else {
            holder.ed_text.getPaint().setFakeBoldText(false);
            holder.tv_content.getPaint().setFakeBoldText(false);
        }

        if(bean.getItem_type().equals(AccountBean.SELECTED_PROJECT)){
            LUtils.e(bean.getRight_value()+",,,,,,,getRight_value,,,,,,,,,,,");
        }
    }

    public List<AccountBean> getList() {
        return list;
    }

    public void setList(List<AccountBean> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            img_icon = (ImageView) convertView.findViewById(R.id.img_icon);
            tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            rea_content = (RelativeLayout) convertView.findViewById(R.id.rea_content);
            ed_text = (EditText) convertView.findViewById(R.id.ed_text);
            img_arrow = (ImageView) convertView.findViewById(R.id.img_arrow);
            view_1px = (ImageView) convertView.findViewById(R.id.view_1px);
            view_10px = (ImageView) convertView.findViewById(R.id.view_10px);
        }

        /* 图标 */
        ImageView img_icon;
        /* 名称*/
        TextView tv_name;
        /* 内容 */
        TextView tv_content;
        ImageView img_arrow;
        EditText ed_text;

        RelativeLayout rea_content;
        ImageView view_1px;
        ImageView view_10px;
    }

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
//        LUtils.e("------setSelection-----------" + editText.getText().length());
        // 焦点移到最后
        editText.setSelection(editText.getText().length());

    }


    /**
     * 设置edittext最大长度
     *
     * @param editText
     * @param length_range
     */
    public void setEditTextLength(EditText editText, String length_range) {
        if (!TextUtils.isEmpty(length_range) && length_range.length() > 1 && length_range.contains(",")) {
            String[] strings = length_range.split(",");
            if (strings.length == 2) {
                editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(Integer.parseInt(strings[1]))});
            } else {
                editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(1000)});
            }
        } else {
            editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(1000)});
        }

    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param decimal_place
     */
    public void setEditTextDecimalNumberLength(EditText editText, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(7, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }

    }

    public void setEditTextChange(final ViewHolder viewHolder, final String item_type) {
        viewHolder.ed_text.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                int pos = (int) viewHolder.ed_text.getTag();
                accountOnItemValueClickLitener.onAccountItemvalue(pos, s.toString());
            }
        });
    }

    public interface AccountOnItemValueClickLitener {
        void onAccountItemvalue(int position, String str);
    }
}
