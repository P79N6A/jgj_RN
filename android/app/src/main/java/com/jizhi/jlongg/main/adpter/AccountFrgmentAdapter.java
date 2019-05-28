package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
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
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.RecordItem;
import com.jizhi.jlongg.main.util.DecimalInputFilter;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AccountFrgmentAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<RecordItem> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;

    private Context context;
    private AccountOnItemClickLitener accountOnItemClickLitener;


    public void setAccountOnItemClickLitener(AccountOnItemClickLitener accountOnItemClickLitener) {
        this.accountOnItemClickLitener = accountOnItemClickLitener;
    }

    public AccountFrgmentAdapter(Context context, List<RecordItem> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        res = context.getResources();
        this.context = context;
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

    //定义成员变量mTouchItemPosition,用来记录手指触摸的EditText的位置
    private int mTouchItemPosition = -1;

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.account_body, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final RecordItem bean = list.get(position);
        holder.topLine.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
        holder.bottomLine.setVisibility(position == list.size() - 1 ? View.INVISIBLE : View.VISIBLE);
        holder.text.setText(bean.getText());
        if (null != bean.getIcon_drawable() && !bean.getIcon_drawable().equals("null")) {
            holder.img_icon.setVisibility(View.VISIBLE);
            setImageSize(holder, bean.getIcon_drawable(), context, 20);
        } else {
            holder.img_icon.setVisibility(View.VISIBLE);
            setImageSize(holder, context.getResources().getDrawable(R.drawable.bg_gy_f1f1f1_5radius), context, 7);
        }
        if (bean.getItemType().equals(RecordItem.RECORD_REMARK)) {//备注
            holder.value.setSingleLine(true);
            holder.value.setLines(1);
        }
        //单价，内容，分享名称，借支金额  才显示编辑框
        if (bean.getValueType() == RecordItem.TYPE_EDIT) {
            holder.value.setVisibility(View.GONE);
            holder.editText.setVisibility(View.VISIBLE);
            holder.editText.setText(bean.getValue());
            holder.editText.setHint(bean.getHintValue());
            setEditTextDecimalNumberLength(holder.editText, 2);
            if (bean.getItemType().equals(RecordItem.SUBENTRY_NAME)) {//分享名称
                holder.editText.setSingleLine(true);
                holder.editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(6)});
                holder.editText.setLines(1);
            }
            holder.editText.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
//                    //限制只能输入一个小数点
//                    if (holder.editText.getText().toString().indexOf(".") >= 0) {
//                        if (holder.editText.getText().toString().indexOf(".") == 0) {
//                            holder.editText.setText("");
//                        } else if (holder.editText.getText().toString().indexOf(".", holder.editText.getText().toString().indexOf(".") + 1) > 0) {
//                            holder.editText.setText(holder.editText.getText().toString().substring(0, holder.editText.getText().toString().length() - 1));
//                            holder.editText.setSelection(holder.editText.getText().toString().length());
//                        }
//                    }
                }

                @Override
                public void afterTextChanged(Editable s) {
                    String str = s.toString();
                    if (TextUtils.isEmpty(str)) {
                        setImageSize(holder, context.getResources().getDrawable(R.drawable.bg_gy_f1f1f1_5radius), context, 7);
                        accountOnItemClickLitener.EditTextWatchListener(bean.getItemType(), s.toString());
                        return;
                    }
                    accountOnItemClickLitener.EditTextWatchListener(bean.getItemType(), s.toString());
                    if (bean.getItemType().equals(RecordItem.SUBENTRY_NAME)) {//分项名称
                        setImageSize(holder, context.getResources().getDrawable(R.drawable.icon_account_sub_proname), context, 20);
                    } else if (bean.getItemType().equals(RecordItem.UNIT_PRICE)) {//点工单价
                        setImageSize(holder, context.getResources().getDrawable(R.drawable.icon_account_money), context, 20);
                    }
                    //TODO
                    else if (bean.getItemType().equals(RecordItem.COUNT)) {//点工数量
                        setImageSize(holder, context.getResources().getDrawable(R.drawable.icon_account_count), context, 20);
                    } else if (bean.getItemType().equals(RecordItem.SUM_MONEY)) {//借支金额
                        setImageSize(holder, context.getResources().getDrawable(R.drawable.icon_account_money_green), context, 20);
                    }
                    //小数点后面保存length位数
                    int posDot = str.indexOf(".");
                    if (posDot > 0) {
                        if (str.length() - posDot - 1 > 2) {
                            s.delete(posDot + 1 + 2, posDot + 2 + 2);
                        }
                    }


                }
            });
            if (bean.getItemType().equals(RecordItem.SUBENTRY_NAME)) {//分项名称
                holder.editText.setInputType(InputType.TYPE_CLASS_TEXT);
            } else if (bean.getItemType().equals(RecordItem.UNIT_PRICE)) {//包工单价
                holder.editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
            }
            else if (bean.getItemType().equals(RecordItem.SUM_MONEY)) {//借支金额
                holder.editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
            }
            if (mTouchItemPosition == position) {
                holder.editText.requestFocus();
                holder.editText.setSelection(holder.editText.getText().length());
            } else {
                holder.editText.clearFocus();
            }
            holder.editText.setTag(position);
        } else {
            holder.value.setVisibility(View.VISIBLE);
            holder.editText.setVisibility(View.GONE);
            holder.value.setHint(bean.getHintValue());
            holder.value.setText(bean.getValue());
        }
        if (bean.getValueColor() != 0) {
            if (bean.getItemType().equals(RecordItem.SUM_MONEY)) {
                holder.editText.setTextColor(ContextCompat.getColor(context, bean.getValueColor()));
            } else {
                holder.value.setTextColor(ContextCompat.getColor(context, bean.getValueColor()));
            }
        } else {  //如果没有设置颜色则默认为333333
            holder.value.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
        }
        holder.clickIcon.setVisibility(bean.isClick() ? View.VISIBLE : View.INVISIBLE);
        holder.lin_item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null == accountOnItemClickLitener || !bean.isClick()) {
                    return;
                }
                accountOnItemClickLitener.onItemClick(position);
            }
        });
        if (bean.getItemType() == RecordItem.SUM_MONEY) {
            holder.tv_yuan.setVisibility(View.VISIBLE);
            holder.clickIcon.setVisibility(View.GONE);
        } else if (bean.getItemType() == RecordItem.COUNT) {
            if (!TextUtils.isEmpty(bean.getValue())) {
                holder.tv_yuan.setVisibility(View.VISIBLE);
                holder.tv_yuan.setText(bean.getCompany());
                holder.value.setText(bean.getValue());
                LUtils.e(bean.getCompany() + ",,," + bean.getValue());
            } else {
                holder.tv_yuan.setVisibility(View.GONE);
                holder.value.setText("");
            }
        }
        if (position == list.size() - 1) {
            holder.view_bottom.setVisibility(View.VISIBLE);
        } else {
            holder.view_bottom.setVisibility(View.GONE);
        }
    }

    private void setImageSize(ViewHolder holder, Drawable drawable, Context context, int dpVal) {
        Utils.setBackGround(holder.img_icon, drawable);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.img_icon.getLayoutParams();
        params.height = DensityUtils.dp2px(context, dpVal);
        params.width = DensityUtils.dp2px(context, dpVal);
        holder.img_icon.setLayoutParams(params);
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param decimal_place
     */
    public void setEditTextDecimalNumberLength(EditText editText, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(6, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }

    }

    public List<RecordItem> getList() {
        return list;
    }

    public void setList(List<RecordItem> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            img_icon = (ImageView) convertView.findViewById(R.id.img_icon);
            text = (TextView) convertView.findViewById(R.id.text);
            value = (TextView) convertView.findViewById(R.id.value);
            tv_yuan = (TextView) convertView.findViewById(R.id.tv_yuan);
            clickIcon = (ImageView) convertView.findViewById(R.id.clickIcon);
            topLine = convertView.findViewById(R.id.topLine);
            bottomLine = convertView.findViewById(R.id.bottomLine);
            editText = (EditText) convertView.findViewById(R.id.editor);
            lin_item = (LinearLayout) convertView.findViewById(R.id.lin_item);
            view_bottom = (View) convertView.findViewById(R.id.view_bottom);
            editText.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent event) {
                    //注意，此处必须使用getTag的方式，不能将position定义为final，写成mTouchItemPosition = position
                    mTouchItemPosition = (Integer) view.getTag();
                    return false;
                }
            });
        }

        /* 线、背景 */
        ImageView img_icon;
        /* 用户名称*/
        TextView text;
        /* 时间 */
        TextView value;
        /* 图标 */
        ImageView clickIcon;
        /* */
        View topLine, bottomLine;
        /* 编辑框 */
        EditText editText;
        LinearLayout lin_item;
        TextView tv_yuan;
        View view_bottom;
    }

    public interface AccountOnItemClickLitener {
        void onItemClick(int position);

        void EditTextWatchListener(String itemType, String str);
    }
}
