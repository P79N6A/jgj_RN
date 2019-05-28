package com.jizhi.jlongg.main.adpter;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
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
import android.view.ViewTreeObserver;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.RecordItem;
import com.jizhi.jlongg.main.util.ButtonUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.NameUtil;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class AccountFrgmentsAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<AccountBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;

    private Context context;
    private AccountOnItemClickLitener accountOnItemClickLitener;
    private boolean startAnim=false;
    private int startAnimPosition=-1;
    private AlphaAnimation animator1;
    /**
     * 确认记工滚动动画
     */
    private AnimatorSet animatorSet;

    public void setAccountOnItemClickLitener(AccountOnItemClickLitener accountOnItemClickLitener) {
        this.accountOnItemClickLitener = accountOnItemClickLitener;
    }

    public AccountFrgmentsAdapter(Context context, List<AccountBean> list) {
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
            convertView = inflater.inflate(R.layout.item_account_textview, null);
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
            if (bean.getItem_type().equals(AccountBean.SELECTED_PROJECT)) {
                holder.tv_textview.setText(NameUtil.setRemark(bean.getRight_value(), 10));
            } else {
                //有单位就显示没有就不显示
                if (TextUtils.isEmpty(bean.getCompany())) {
                    holder.tv_textview.setText(bean.getRight_value());
                } else {
                    holder.tv_textview.setText(bean.getRight_value() + " " + bean.getCompany());
                }
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
            holder.ed_textview.setHintTextColor(res.getColor(R.color.color_999999));
            holder.ed_textview.setTextColor(ContextCompat.getColor(context, bean.getText_color()));
            holder.ed_textview.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {

                    //写你相关操作即可
                    if (TextUtils.isEmpty(list.get(0).getRight_value())) {
                        if (!ButtonUtils.isFastDoubleClick(111)) {
                            //CommonMethod.makeNoticeShort(context, context.getString(R.string.please_select_record_object), CommonMethod.ERROR);
                            startFlashTips(true,getPosion(list, AccountBean.SELECTED_ROLE));
                            return true;
                        }
                        return true;
                    }
                    return false;
                }
            });
        }
        //10dp分割线
        if (bean.isShowLine10()) {
            holder.view_10px.setVisibility(View.VISIBLE);
            holder.view_1px.setVisibility(View.GONE);
        } else {
            holder.view_10px.setVisibility(View.GONE);
            holder.view_1px.setVisibility(View.VISIBLE);
        }
        //右侧箭头
        if (bean.isShowArrow()) {
            holder.view_right.setVisibility(View.VISIBLE);
        } else {
            holder.view_right.setVisibility(View.GONE);
        }
        if (position == list.size() - 1) {
            holder.img_last.setVisibility(View.GONE);
        } else {
            holder.img_last.setVisibility(View.VISIBLE);
        }
        //是否记过工
//        if (!TextUtils.isEmpty(bean.getBill_desc())) {
//            holder.rea_unAccountCountLayout.setVisibility(View.VISIBLE);
//            holder.unAccountCountText.setText(bean.getBill_desc() + "");//已经记过账单
//            startWaitConfirmAnim(holder.confirmIcon);
//        } else {
        holder.rea_unAccountCountLayout.setVisibility(View.GONE);
//            stopWaitConfirmAnim();
//        }


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
                holder.ed_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
            } else if (bean.getItem_type().equals(AccountBean.UNIT_PRICE) || bean.getItem_type().equals(AccountBean.SUM_MONEY)) {
                //只能输入6位数字以及2位小数，单行输入
                holder.ed_textview.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
                holder.ed_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
                setEditTextDecimalNumberLength(holder.ed_textview, 2);

            } else {
                holder.ed_textview.setInputType(InputType.TYPE_CLASS_TEXT);
                holder.ed_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(7)});
            }
            holder.ed_textview.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                }

                @Override
                public void afterTextChanged(Editable s) {
                    if (!TextUtils.isEmpty(s)&&bean.getItem_type().equals(AccountBean.SUM_MONEY)&&startAnim){
                        //FlashingCancel(false);
                        holder.tv_title.setTextColor(res.getColor(R.color.color_333333));
                        holder.ed_textview.setHintTextColor(res.getColor(R.color.color_999999));
                        holder.view_right.setBackgroundResource(R.drawable.houtui);
                        holder.rea_layout.setBackgroundColor(res.getColor(R.color.white));
                        if (animator1!=null) {
                            animator1.cancel();
                        }
                    }
                    accountOnItemClickLitener.EditTextWatchListener(bean.getItem_type(), s.toString());
                }
            });
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
        }
        if (bean.getItem_type().equals(AccountBean.RECORD_REMARK)) {
            holder.tv_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        } else {
            holder.tv_textview.setFilters(new InputFilter[]{new InputFilter.LengthFilter(50)});
        }
        holder.unAccountCountLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                accountOnItemClickLitener.goToRecordWorkConfirm(position);
            }
        });

        if (bean.getItem_type().equals(RecordItem.ALL_MONEY)) {
            //点工工钱加粗
            holder.tv_textview.getPaint().setFakeBoldText(true);
        } else if (bean.getItem_type().equals(RecordItem.SUM_MONEY)) {
            //SUM_MONEY 借支金额加粗
            holder.ed_textview.getPaint().setFakeBoldText(true);
        } else {
            holder.ed_textview.getPaint().setFakeBoldText(false);
            holder.tv_textview.getPaint().setFakeBoldText(false);
        }
        //上班时间没有选项增加提醒
        if (bean.getItem_type() == RecordItem.WORK_TIME && TextUtils.isEmpty(list.get(getPosion(list, AccountBean.WORK_TIME)).getRight_value())) {
            convertView.findViewById(R.id.hout_work_time_hinet).setVisibility(View.VISIBLE);
        } else {
            convertView.findViewById(R.id.hout_work_time_hinet).setVisibility(View.GONE);

        }
        if (position==startAnimPosition) {
            if (bean.getItem_type().equals(AccountBean.SUM_MONEY)) {
                FlashingHints(holder.tv_title, holder.ed_textview, holder.view_right, holder.rea_layout);
            }else {
                FlashingHints(holder.tv_title, holder.tv_textview, holder.view_right, holder.rea_layout);
            }
        }
        return convertView;
    }

    protected int getPosion(List<AccountBean> itemData, String item_type) {
        for (int i = 0; i < itemData.size(); i++) {
            if (TextUtils.equals(item_type, itemData.get(i).getItem_type())) {
                return i;
            }
        }
        return 0;

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

    public List<AccountBean> getList() {
        return list;
    }

    public void setList(List<AccountBean> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            img_icon = convertView.findViewById(R.id.img_icon);
            view_right = convertView.findViewById(R.id.view_right);
            view_1px = convertView.findViewById(R.id.view_1px);
            img_last = convertView.findViewById(R.id.img_last);
            view_10px = convertView.findViewById(R.id.view_10px);
            rea_unAccountCountLayout = convertView.findViewById(R.id.rea_unAccountCountLayout);
            unAccountCountLayout = convertView.findViewById(R.id.unAccountCountLayout);
            tv_title = convertView.findViewById(R.id.tv_title);
            tv_textview = convertView.findViewById(R.id.tv_textview);
            ed_textview = convertView.findViewById(R.id.ed_content);
            unAccountCountText = convertView.findViewById(R.id.unAccountCountText);
            confirmIcon = convertView.findViewById(R.id.confirmIcon);
            rea_layout = convertView.findViewById(R.id.rea_layout);
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
        /* 右侧编辑框 */
        EditText ed_textview;
        /* 右侧箭头 */
        ImageView view_right;
        ImageView view_1px;
        ImageView img_last;
        RelativeLayout view_10px;
        /* 右侧箭头 */
        RelativeLayout rea_unAccountCountLayout;
        LinearLayout unAccountCountLayout;
        /* 记账文字 */
        TextView unAccountCountText;
        /* 箭头 */
        ImageView confirmIcon;

        RelativeLayout rea_layout;
    }

    public interface AccountOnItemClickLitener {
        void onItemClick(int position);

        void EditTextWatchListener(String itemType, String str);

        void goToRecordWorkConfirm(int positon);
    }


    public void startFlashTips(boolean start,int position){
        startAnim=start;
        startAnimPosition=position;
        notifyDataSetChanged();
    }
    /**
     * @version 4.0.2
     * @desc: 记工记账，未选择工人/班组长时，点击日期等信息时，
     *        未选择的项标红闪动提醒（之前的气泡提示去掉，其他必填项未填写，点击保存时，也标红闪动提醒）
     * @param left 左边单项名称
     * @param hint 中间填写的信息
     */
    private void FlashingHints(final TextView left, final TextView hint, final ImageView right_arrow, final ViewGroup item){


        if (startAnim){
            left.setTextColor(res.getColor(R.color.color_eb4e4e));
            hint.setHintTextColor(res.getColor(R.color.color_eb4e4e));
            right_arrow.setBackgroundResource(R.drawable.jiantou_red);
            item.setBackgroundColor(Color.parseColor("#FFE7E7"));
            if (animator1==null) {
                animator1 = new AlphaAnimation(1.0F, 0.1F);
            }
            animator1.setRepeatCount(Animation.INFINITE);
            animator1.setDuration(1000);
            animator1.setRepeatMode(Animation.REVERSE);
            left.startAnimation(animator1);
            hint.startAnimation(animator1);
            right_arrow.startAnimation(animator1);
            animator1.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {
                    LUtils.e("===start");
                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    LUtils.e("===end");
                    left.setTextColor(res.getColor(R.color.color_333333));
                    hint.setHintTextColor(res.getColor(R.color.color_999999));
                    right_arrow.setBackgroundResource(R.drawable.houtui);
                    item.setBackgroundColor(res.getColor(R.color.white));
                    startAnim=false;
                    startAnimPosition=-1;
                }

                @Override
                public void onAnimationRepeat(Animation animation) {
                    LUtils.e("===repeat"+animation.getRepeatCount());
                }
            });
        }else {
            left.setTextColor(res.getColor(R.color.color_333333));
            hint.setHintTextColor(res.getColor(R.color.color_999999));
            right_arrow.setBackgroundResource(R.drawable.houtui);
            item.setBackgroundColor(res.getColor(R.color.white));
            startAnim=false;
            startAnimPosition=-1;
            if(null!=animator1){
                animator1.cancel();
            }

        }
    }

    public void FlashingCancel(boolean start){
        this.startAnim=start;
        notifyDataSetChanged();
    }
    /**
     * 停止待确认动画
     */
    protected void stopWaitConfirmAnim() {
        if (animatorSet != null && animatorSet.isRunning()) {
            animatorSet.cancel();
        }
    }

    /**
     * 开启待确认动画
     */
    protected void startWaitConfirmAnim(ImageView confirmIcon) {
        if (animatorSet != null) {
            if (!animatorSet.isRunning()) {
                LUtils.e("开启动画");
                animatorSet.start();
            }
            return;
        }
        int moveDistance = DensityUtils.dp2px(context, 8); //移动距离
        ObjectAnimator animator1 = ObjectAnimator.ofFloat(confirmIcon, "translationX", 0, -moveDistance);
        ObjectAnimator animator2 = ObjectAnimator.ofFloat(confirmIcon, "alpha", 1.0F, 0.1F);

        animator1.setRepeatCount(Integer.MAX_VALUE);
        animator2.setRepeatCount(Integer.MAX_VALUE);
        animator1.setRepeatMode(android.animation.ObjectAnimator.REVERSE);
        animator2.setRepeatMode(android.animation.ObjectAnimator.REVERSE);

        animatorSet = new AnimatorSet();
        animatorSet.playTogether(animator1);
        animatorSet.playTogether(animator2);
        animatorSet.setDuration(800);
        animatorSet.start();


        animator1.addListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animator) {
            }

            @Override
            public void onAnimationEnd(Animator animator) {

            }

            @Override
            public void onAnimationCancel(Animator animator) {
                LUtils.e("停止动画:");
            }

            @Override
            public void onAnimationRepeat(Animator animator) {

            }
        });

    }
}
