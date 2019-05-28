package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.content.res.Resources;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.Html;
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
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.RecordItem;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.DecimalInputFilter;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AccountFrgmentWageAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<AccountBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;

    private Context context;
    private AccountOnItemClickLitener accountOnItemClickLitener;


    public void setAccountOnItemClickLitener(AccountOnItemClickLitener accountOnItemClickLitener) {
        this.accountOnItemClickLitener = accountOnItemClickLitener;
    }

    public AccountFrgmentWageAdapter(Context context, List<AccountBean> list) {
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
        final AccountBean bean = list.get(position);
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_account_wages, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        Utils.setBackGround(holder.img_icon, bean.getIcon_drawable());
        holder.tv_title.setText(bean.getLeft_text());
        if (bean.getText_type() == AccountBean.TYPE_TEXT) {
            //显示textview内容
            holder.tv_textview.setHint(bean.getRight_hint());
            //有单位就显示没有就不显示
            if (TextUtils.isEmpty(bean.getCompany())) {
                holder.tv_textview.setText(bean.getRight_value());
            } else {
                holder.tv_textview.setText(bean.getRight_value() + " " + bean.getCompany());
            }
            holder.tv_textview.setTextColor(ContextCompat.getColor(context, bean.getText_color()));
            holder.tv_textview.setVisibility(View.VISIBLE);
            holder.ed_textview.setVisibility(View.GONE);
        } else {
            //显示edittext内容
            holder.ed_textview.setText(bean.getRight_value());
            holder.tv_textview.setVisibility(View.GONE);
            holder.ed_textview.setVisibility(View.VISIBLE);
            holder.ed_textview.setHint(bean.getRight_hint());
            holder.ed_textview.setTextColor(ContextCompat.getColor(context, bean.getText_color()));
        }
        //10dp分割线
        if (bean.isShowLine10()) {
            holder.view_10px.setVisibility(View.VISIBLE);
        } else {
            holder.view_10px.setVisibility(View.GONE);
        }
        //右侧箭头
        if (bean.isShowArrow()) {
            holder.view_right.setVisibility(View.VISIBLE);
        } else {
            holder.view_right.setVisibility(View.GONE);
        }
        //借支部分-------------------
        if (bean.getItem_type().equals(AccountBean.WAGE_S_R_F)) {
            if (bean.isExpanded()) {
                Utils.setBackGround(holder.view_right, ContextCompat.getDrawable(context, R.drawable.account_arrow_up));
                holder.lin_wages_other.setVisibility(View.VISIBLE);
                holder.rea_layout.setVisibility(View.VISIBLE);
                holder.lin_unset.setVisibility(View.GONE);


                //默认补贴奖励罚款为-1是设置为空是为了显示edittexthint为0.00否则就显示输入的内容
                holder.ed_wage_subsidy.setText(bean.getWage_subsidy() == 0.00 ? "" : Utils.m2(bean.getWage_subsidy()));
                holder.ed_wage_reward.setText(bean.getWage_reward() == 0.00 ? "" : Utils.m2(bean.getWage_reward()));
                holder.ed_wage_fine.setText(bean.getWage_fine() == 0.00 ? "" : Utils.m2(bean.getWage_fine()));
            } else {
                Utils.setBackGround(holder.view_right, ContextCompat.getDrawable(context, R.drawable.account_arrow_down));
                holder.rea_layout.setVisibility(View.VISIBLE);
                holder.lin_wages_other.setVisibility(View.GONE);
                holder.lin_unset.setVisibility(View.GONE);
            }
        } else if (bean.getItem_type().equals(AccountBean.WAGE_UNSET)) {
            holder.lin_wages_other.setVisibility(View.GONE);
            holder.lin_unset.setVisibility(View.VISIBLE);
            //你还有%1$s人点工的工资模版未设置金额<
            holder.tv_count.setText(Html.fromHtml("你还有<font color='#eb4e4e'>" + bean.getUn_salary_tpl() + "笔</font>点工的工资标准未设置金额"));
            holder.tv_textview_wage.setText(bean.getBalance_amount() + "");//未结工资数
            holder.rea_layout.setVisibility(View.GONE);
            holder.tv_salary.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    CommonMethod.makeNoticeLong(context, "look", CommonMethod.SUCCESS);
                }
            });
        } else {
            holder.lin_wages_other.setVisibility(View.GONE);
            holder.lin_unset.setVisibility(View.GONE);
            holder.rea_layout.setVisibility(View.VISIBLE);
        }

        if (bean.getText_type() == RecordItem.TYPE_EDIT) {
            if (mTouchItemPosition == position) {
                holder.ed_textview.requestFocus();
                holder.ed_textview.setSelection(holder.ed_textview.getText().length());
            } else {
                holder.ed_textview.clearFocus();
            }
            holder.ed_textview.setTag(position);
            if (bean.getItem_type().equals(AccountBean.SUBENTRY_NAME)) {
                holder.ed_textview.setInputType(InputType.TYPE_CLASS_TEXT);
                holder.ed_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(6)});
            } else if (bean.getItem_type().equals(AccountBean.WAGE_INCOME_MONEY) || bean.getItem_type().equals(AccountBean.WAGE_DEL)) {
                //只能输入7位数字以及2位小数，单行输入
                //本次实收金额，抹零金额
                holder.ed_textview.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                holder.ed_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
                setEditTextDecimalNumberLength(holder.ed_textview, 2);
            } else {
                holder.ed_textview.setInputType(InputType.TYPE_CLASS_TEXT);
                holder.ed_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(6)});
            }
            addTextChangedListener(holder.ed_textview, bean.getItem_type(), 0);
        } else {
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (null == accountOnItemClickLitener || !bean.isClick()) {
                        return;
                    }
                    accountOnItemClickLitener.onItemClick(position);
                }
            });

            if (bean.getItem_type().equals(AccountBean.WAGE_S_R_F)) {
                //补贴 ed_wage_subsidy
                holder.ed_wage_subsidy.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                holder.ed_wage_subsidy.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
                setEditTextDecimalNumberLength(holder.ed_wage_subsidy, 2);
                addTextChangedListener(holder.ed_wage_subsidy, bean.getItem_type(), 1);
                //奖励金额 ed_wage_reward
                holder.ed_wage_reward.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                holder.ed_wage_reward.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
                setEditTextDecimalNumberLength(holder.ed_wage_subsidy, 2);
                addTextChangedListener(holder.ed_wage_subsidy, bean.getItem_type(), 2);
                //罚款金额ed_wage_fine
                holder.ed_wage_fine.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                holder.ed_wage_fine.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
                setEditTextDecimalNumberLength(holder.ed_wage_fine, 2);
                addTextChangedListener(holder.ed_wage_fine, bean.getItem_type(), 3);
            }
        }
        return convertView;
    }

    public void addTextChangedListener(EditText editText, final String item_type, final int type) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                accountOnItemClickLitener.EditTextWatchListener(item_type, s.toString(), type);
            }
        });
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

    public List<AccountBean> getList() {
        return list;
    }

    public void setList(List<AccountBean> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            img_icon = (ImageView) convertView.findViewById(R.id.img_icon);
            view_right = (ImageView) convertView.findViewById(R.id.view_right);
            view_1px = (ImageView) convertView.findViewById(R.id.view_1px);
            view_10px = (ImageView) convertView.findViewById(R.id.view_10px);
            tv_title = (TextView) convertView.findViewById(R.id.tv_title);
            tv_textview = (TextView) convertView.findViewById(R.id.tv_textview);
            tv_count = (TextView) convertView.findViewById(R.id.tv_count);
            ed_textview = (EditText) convertView.findViewById(R.id.ed_content);
            lin_wages_other = (LinearLayout) convertView.findViewById(R.id.lin_wages_other);
            lin_unset = (RelativeLayout) convertView.findViewById(R.id.lin_unset);
            rea_layout = (RelativeLayout) convertView.findViewById(R.id.rea_layout);
            tv_salary = (TextView) convertView.findViewById(R.id.tv_salary);
            tv_textview_wage = (TextView) convertView.findViewById(R.id.tv_textview_wage);
            ed_wage_subsidy = (EditText) convertView.findViewById(R.id.ed_wage_subsidy);
            ed_wage_reward = (EditText) convertView.findViewById(R.id.ed_wage_reward);
            ed_wage_fine = (EditText) convertView.findViewById(R.id.ed_wage_fine);
            ed_textview.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent event) {
                    //注意，此处必须使用getTag的方式，不能将position定义为final，写成mTouchItemPosition = position
                    mTouchItemPosition = (Integer) view.getTag();
                    return false;
                }
            });
        }

        /* 图标 */
        ImageView img_icon;
        /* 左侧文字标题*/
        TextView tv_title;
        /* 右侧文本按钮 */
        TextView tv_textview;
        /* 多少笔点工未设置金额 */
        TextView tv_count;
        /* 查看未设置金额 */
        TextView tv_salary;
        /* 未设置金额 */
        TextView tv_textview_wage;
        /* 右侧编辑框 */
        EditText ed_textview;
        /* 右侧箭头 */
        ImageView view_right;
        ImageView view_1px;
        ImageView view_10px;
        LinearLayout lin_wages_other;
        RelativeLayout lin_unset;
        RelativeLayout rea_layout;
        //补贴奖励罚款金额
        EditText ed_wage_subsidy, ed_wage_reward, ed_wage_fine;
    }

    public interface AccountOnItemClickLitener {
        void onItemClick(int position);

        void EditTextWatchListener(String itemType, String str, int type);
    }
}
