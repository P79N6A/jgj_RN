package com.jizhi.jlongg.main.adpter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Color;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.StringUtil;

import java.util.List;

public class ViewHolderAllAccountCenter extends AllAccountRecycleViewHolder {
    //单价，数量
    private EditText ed_sub_price, ed_count;
    //编号
    TextView tv_num;
    //分项名称,分项名称左边编号,单位
    TextView tv_sub_name, tv_sub_name_left, tv_company;
    //分项工钱
    TextView tv_salary_price;
    private String role;
    public AlphaAnimation animator;
    private boolean startAnim=false;
    public ViewHolderAllAccountCenter(View itemView, Activity activity, NewAllAccountAdapter.AllAccountListener allAccountListener, String role) {
        super(itemView);
        this.activity = activity;
        this.role = role;
        this.allAccountListener = allAccountListener;
        initItemView();
    }

    public void initItemView() {
        ed_sub_price = itemView.findViewById(R.id.ed_sub_price);
        ed_count = itemView.findViewById(R.id.ed_count);
        tv_num = itemView.findViewById(R.id.tv_num);
        tv_sub_name = itemView.findViewById(R.id.tv_sub_name);
        tv_sub_name_left = itemView.findViewById(R.id.tv_sub_name_left);
        tv_company = itemView.findViewById(R.id.tv_company);
        tv_salary_price = itemView.findViewById(R.id.tv_salary_price);
        setEditTextDecimalNumberLength(ed_sub_price, 7, 2);
        setEditTextDecimalNumberLength(ed_count, 7, 2);
    }
    /**
     * @version 4.0.2
     * @desc: 记工记账，未选择工人/班组长时，点击日期等信息时，
     *        未选择的项标红闪动提醒（之前的气泡提示去掉，其他必填项未填写，点击保存时，也标红闪动提醒）
     * @param left 左边单项名称
     * @param hint 中间填写的信息
     */
    private void FlashingHints(final TextView left, final EditText hint, final ViewGroup item){

        if (startAnim) {
            left.setTextColor(activity.getResources().getColor(R.color.color_eb4e4e));
            hint.setHintTextColor(activity.getResources().getColor(R.color.color_eb4e4e));
            item.setBackgroundColor(Color.parseColor("#FFE7E7"));
            if (animator==null) {
                animator = new AlphaAnimation(1.0F, 0.1F);
            }
            animator.setRepeatCount(Animation.INFINITE);
            animator.setDuration(1000);
            animator.setRepeatMode(Animation.REVERSE);
            left.startAnimation(animator);
            hint.startAnimation(animator);
            animator.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {
                    LUtils.e("===start");
                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    LUtils.e("===end");
                    left.setTextColor(activity.getResources().getColor(R.color.color_333333));
                    hint.setHintTextColor(activity.getResources().getColor(R.color.color_999999));
                    item.setBackgroundColor(activity.getResources().getColor(R.color.white));
                    startAnim = false;
                }

                @Override
                public void onAnimationRepeat(Animation animation) {
                    LUtils.e("===repeat" + animation.getRepeatCount());
                }
            });
        }else {
            if (animator!=null){
                left.setTextColor(activity.getResources().getColor(R.color.color_333333));
                hint.setHintTextColor(activity.getResources().getColor(R.color.color_999999));
                item.setBackgroundColor(activity.getResources().getColor(R.color.white));
                startAnim = false;
                animator.cancel();
            }
        }
    }

    public void startFlashTips(boolean start){
        startAnim=start;

    }
    @SuppressLint("ClickableViewAccessibility")
    @Override
    public void bindHolder(final int positions, final List<AccountAllWorkBean> lists) {
//        if (position >= list.size()) {
//            return;
//        }
//        this.position = getAdapterPosition();
        this.list = lists;
        itemView.findViewById(R.id.rea_sub_name).setOnClickListener(onClickListener);
        itemView.findViewById(R.id.tv_delete_sub).setOnClickListener(onClickListener);
        itemView.findViewById(R.id.lin_company).setOnClickListener(onClickListener);

        itemView.findViewById(R.id.rea_top).setVisibility(list.size() > 3 ? View.VISIBLE : View.GONE);
        itemView.findViewById(R.id.rea_top_10px).setVisibility(list.size() <= 3 ? View.VISIBLE : View.GONE);
        tv_num.setText(list.size() <= 3 ? "#1" : "#" + (getAdapterPosition()));
        tv_sub_name_left.setText(list.size() <= 3 ? "分项名称" : "分项名称" + (getAdapterPosition()));
        tv_sub_name.setText(null != list.get(getAdapterPosition()).getSub_pro_name() ? list.get(getAdapterPosition()).getSub_pro_name() : "");
        tv_company.setText(null != list.get(getAdapterPosition()).getUnits() ? list.get(getAdapterPosition()).getUnits() : "");
        tv_salary_price.setText(list.get(getAdapterPosition()).getPrice());
        itemView.findViewById(R.id.rea_count_left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (TextUtils.isEmpty(list.get(0).getRoleName())) {
                    if (allAccountListener!=null) {
                            allAccountListener.inputNum();
                        }
//                    if (role.equals(Constance.ROLETYPE_FM) && list.get(0).getContractor_type() == 1) {
//                        CommonMethod.makeNoticeShort(activity, "请先选择承包对象", CommonMethod.ERROR);
//                    } else {
//                        CommonMethod.makeNoticeShort(activity, activity.getString(R.string.please_select_record_object), CommonMethod.ERROR);
//                    }

                }else {
                    Utils.showSoftInputFromWindow(activity, ed_count);
                }
            }
        });
        itemView.findViewById(R.id.all_account_r).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (TextUtils.isEmpty(list.get(0).getRoleName())) {
                    if (allAccountListener != null) {
                        allAccountListener.inputPrice();
                    }
                }else {
                    Utils.showSoftInputFromWindow(activity, ed_sub_price);
                }
            }
        });
//        ed_sub_price.setFocusable(false);
//        ed_sub_price.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//
//                if (TextUtils.isEmpty(list.get(0).getRoleName())) {
//
//                    if (role.equals(Constance.ROLETYPE_FM) && list.get(0).getContractor_type() == 1) {
//                        //CommonMethod.makeNoticeShort(activity, "请先选择承包对象", CommonMethod.ERROR);
//                    } else {
//                        //CommonMethod.makeNoticeShort(activity, activity.getString(R.string.please_select_record_object), CommonMethod.ERROR);
//                    }
//                    return true;
//
//                } else {
//                    return false;
//                }
//            }
//        });
//
//        ed_count.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//
//                if (TextUtils.isEmpty(list.get(0).getRoleName())) {
//
//                    if (role.equals(Constance.ROLETYPE_FM) && list.get(0).getContractor_type() == 1) {
//                        //CommonMethod.makeNoticeShort(activity, "请先选择承包对象", CommonMethod.ERROR);
//
//                    } else {
//                        //CommonMethod.makeNoticeShort(activity, activity.getString(R.string.please_select_record_object), CommonMethod.ERROR);
//                    }
//                    return true;
//
//                } else {
//                    return false;
//                }
//            }
//        });
        //第一步：将EditText之前设置的TextWatcher移除。
        if (ed_sub_price.getTag() != null && ed_sub_price.getTag() instanceof TextWatcher) {
            ed_sub_price.removeTextChangedListener((TextWatcher) ed_sub_price.getTag());
        }
        if (ed_count.getTag() != null && ed_count.getTag() instanceof TextWatcher) {
            ed_count.removeTextChangedListener((TextWatcher) ed_count.getTag());
        }
        //第二步：为EditText设置显示内容。
        ed_sub_price.setText(TextUtils.isEmpty(list.get(getAdapterPosition()).getSet_unitprice()) ? "" : list.get(getAdapterPosition()).getSet_unitprice() + "");
        ed_count.setText(TextUtils.isEmpty(list.get(getAdapterPosition()).getSub_count()) ? "" : list.get(getAdapterPosition()).getSub_count() + "");
//        ed_sub_price.setSelection(TextUtils.isEmpty(list.get(position).getSet_unitprice()) ? 0 : list.get(position).getSet_unitprice().length());
//        ed_count.setSelection(TextUtils.isEmpty(list.get(position).getSub_count()) ? 0 : list.get(position).getSub_count().length());
        //第三步：对EditText设置监听。
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                list.get(getAdapterPosition()).setSet_unitprice(s.toString().trim());
                caluMonny(getAdapterPosition());
                if (!TextUtils.isEmpty(s)){
                    if (animator != null) {
                        ((TextView) itemView.findViewById(R.id.account_left_text)).setTextColor(activity.getResources().getColor(R.color.color_333333));
                        ed_sub_price.setHintTextColor(activity.getResources().getColor(R.color.color_999999));
                        ((RelativeLayout) itemView.findViewById(R.id.all_account_r)).setBackgroundColor(activity.getResources().getColor(R.color.white));
                        startAnim = false;
                        animator.cancel();

                    }
                }

            }
        };
        TextWatcher textWatcher1 = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
//                if(position==lists.size()){
//                    return;
//                }
                list.get(getAdapterPosition()).setSub_count(s.toString().trim());
                caluMonny(getAdapterPosition());
            }
        };
        ed_sub_price.addTextChangedListener(textWatcher);
        ed_count.addTextChangedListener(textWatcher1);
        //第四步：为EditText设置tag，将TextWatcher添加到tag中去
        ed_sub_price.setTag(textWatcher);
        ed_count.setTag(textWatcher);
        if (!TextUtils.isEmpty(list.get(0).getRoleName())) {
            FlashingHints((TextView) itemView.findViewById(R.id.account_left_text)
                    , ed_sub_price, (RelativeLayout) itemView.findViewById(R.id.all_account_r));
        }
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param length        小数点前面位数
     * @param decimal_place 小数点后面位数
     */
    public void setEditTextDecimalNumberLength(EditText editText, int length, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(length, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }
    }


    /**
     * 计算总价
     *
     * @param position
     * @return
     */
    private void caluMonny(int position) {
        String sub_count = list.get(position).getSub_count();
        String sub_price = list.get(position).getSet_unitprice();
        if (TextUtils.isEmpty(sub_count) || TextUtils.isEmpty(sub_price)) {
            list.get(position).setPrice("");
            return;
        }
        if (list.get(position).getSub_count().endsWith(".") || list.get(position).getSet_unitprice().endsWith(".")) {
            list.get(position).setPrice("");

            return;
        }
        list.get(position).setPrice(Utils.m2(Double.parseDouble(sub_count) * Double.parseDouble(sub_price)));
        tv_salary_price.setText(list.get(position).getPrice());

    }
}
