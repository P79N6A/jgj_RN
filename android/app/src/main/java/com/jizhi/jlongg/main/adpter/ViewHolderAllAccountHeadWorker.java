package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.graphics.Color;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.xiao.nicevideoplayer.LogUtil;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class ViewHolderAllAccountHeadWorker extends AllAccountRecycleViewHolder {
    //单选group
    private RadioGroup radioGroup;
    //记账对象，日期，项目
    private TextView tv_role_name, tv_proname, tv_date;
    //记账的年月日
    public int year, month, day;
    public AlphaAnimation animator;
    private boolean startAnim=false;

    public ViewHolderAllAccountHeadWorker(View itemView, Activity activity, NewAllAccountAdapter.AllAccountListener allAccountListener) {
        super(itemView);
        this.activity = activity;
        this.allAccountListener = allAccountListener;
        initItemView();
    }
    /**
     * @version 4.0.2
     * @desc: 记工记账，未选择工人/班组长时，点击日期等信息时，
     *        未选择的项标红闪动提醒（之前的气泡提示去掉，其他必填项未填写，点击保存时，也标红闪动提醒）
     * @param left 左边单项名称
     * @param hint 中间填写的信息
     */
    private void FlashingHints(final TextView left, final TextView hint, final ImageView right_arrow, final ViewGroup item){

        if (startAnim) {
            left.setTextColor(activity.getResources().getColor(R.color.color_eb4e4e));
            hint.setHintTextColor(activity.getResources().getColor(R.color.color_eb4e4e));
            right_arrow.setBackgroundResource(R.drawable.jiantou_red);
            item.setBackgroundColor(Color.parseColor("#FFE7E7"));
            if (animator==null) {
                animator = new AlphaAnimation(1.0F, 0.1F);
            }
            animator.setRepeatCount(Animation.INFINITE);
            animator.setDuration(1000);
            animator.setRepeatMode(Animation.REVERSE);
            left.startAnimation(animator);
            hint.startAnimation(animator);
            right_arrow.startAnimation(animator);
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
                    right_arrow.setBackgroundResource(R.drawable.houtui);
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
                right_arrow.setBackgroundResource(R.drawable.houtui);
                item.setBackgroundColor(activity.getResources().getColor(R.color.white));
                startAnim = false;
                animator.cancel();
            }
        }
    }

    public void startFlashTips(boolean start){
        startAnim=start;
    }
    @Override
    public void bindHolder(int positiosn, List<AccountAllWorkBean> list) {
//        this.position = position;
        this.list = list;
        tv_date.setText(list.get(getAdapterPosition()).getDate());
        tv_role_name.setText(list.get(getAdapterPosition()).getRoleName());
        tv_proname.setText(TextUtils.isEmpty(list.get(getAdapterPosition()).getPro_name()) ? "" : list.get(getAdapterPosition()).getPro_name());

        itemView.findViewById(R.id.img_role_arrow).setVisibility(list.get(getAdapterPosition()).isHintRoleArrow() ? View.GONE : View.VISIBLE);
        tv_role_name.setTextColor(ContextCompat.getColor(activity, list.get(getAdapterPosition()).isHintRoleArrow() ? R.color.color_999999 : R.color.color_333333));
        itemView.findViewById(R.id.rea_role).setClickable(!list.get(getAdapterPosition()).isClickRole());

        itemView.findViewById(R.id.img_pro_arrow).setVisibility(list.get(getAdapterPosition()).isHintProjectArrow() ? View.GONE : View.VISIBLE);
        tv_proname.setTextColor(ContextCompat.getColor(activity, list.get(getAdapterPosition()).isHintProjectArrow() ? R.color.color_999999 : R.color.color_333333));
        itemView.findViewById(R.id.rea_project).setClickable(!list.get(getAdapterPosition()).isClickProject());
        if (list.get(0).isTOMsgFM()) {
            (itemView.findViewById(R.id.rb_account_contract)).setVisibility(View.GONE);
            ((RadioButton) itemView.findViewById(R.id.rb_account_contract)).setChecked((false));
            ((RadioButton) itemView.findViewById(R.id.rb_account_subcontract)).setChecked((true));
        }
        ((RadioButton) itemView.findViewById(R.id.rb_account_contract)).setChecked((list.get(getAdapterPosition()).getContractor_type() == 1 ? true : false));
        ((RadioButton) itemView.findViewById(R.id.rb_account_subcontract)).setChecked((list.get(getAdapterPosition()).getContractor_type() == 2 ? true : false));
        ((TextView) itemView.findViewById(R.id.tv_role_title)).setText((list.get(getAdapterPosition()).getContractor_type() == 1 ? "承包对象" : "工人"));
        ((TextView) itemView.findViewById(R.id.tv_role_name)).setHint((list.get(getAdapterPosition()).getContractor_type() == 1 ? "请选择承包对象" : "请选择工人"));

            FlashingHints((TextView) itemView.findViewById(R.id.tv_role_title)
                    , tv_role_name,(ImageView)itemView.findViewById(R.id.img_role_arrow),
                    (RelativeLayout) itemView.findViewById(R.id.rea_role));

    }

    public void initItemView() {
        radioGroup = itemView.findViewById(R.id.radioGroup);

        tv_role_name = itemView.findViewById(R.id.tv_role_name);
        tv_proname = itemView.findViewById(R.id.tv_proname);
        tv_date = itemView.findViewById(R.id.tv_date);

        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.rb_account_contract:
                        ((TextView) itemView.findViewById(R.id.tv_type_hint)).setText(activity.getString(R.string.account_hint_contract));
                        ((TextView) itemView.findViewById(R.id.tv_role_name)).setHint("请选择承包对象");
                        ((TextView) itemView.findViewById(R.id.tv_role_title)).setText("承包对象");
                        if (list.get(0).getContractor_type() != 1) {
                            allAccountListener.modifyAccountType(1);
                            list.get(0).setContractor_type(1);
                        }
                        LUtils.e("-------setContractor_type-----11-------" + ((RadioButton) itemView.findViewById(R.id.rb_account_contract)).isChecked());
                        break;
                    case R.id.rb_account_subcontract:
                        if (UclientApplication.getUid(activity).equals(String.valueOf(list.get(getAdapterPosition()).getUid()))) {
                            CommonMethod.makeNoticeShort(activity, "自己对自己记账只能选择承包", false);
                            ((RadioButton) itemView.findViewById(R.id.rb_account_contract)).setChecked(true);
                            return;
                        }
                        ((TextView) itemView.findViewById(R.id.tv_type_hint)).setText(activity.getString(R.string.account_hint_subcontract));
                        ((TextView) itemView.findViewById(R.id.tv_role_name)).setHint("请选择工人");
                        ((TextView) itemView.findViewById(R.id.tv_role_title)).setText("工人");
                        if (list.get(0).getContractor_type() != 2) {
                            allAccountListener.modifyAccountType(2);
                            list.get(0).setContractor_type(2);

                        }

                        LUtils.e("-------setContractor_type-----22-------" + ((RadioButton) itemView.findViewById(R.id.rb_account_subcontract)).isChecked());

                        break;
                }
            }
        });
        itemView.findViewById(R.id.rea_role).setOnClickListener(onClickListener);
        itemView.findViewById(R.id.rea_date).setOnClickListener(onClickListener);
        itemView.findViewById(R.id.rea_project).setOnClickListener(onClickListener);
    }

    //设置当前日期（由前一个界面传过来的）
    public void setData(String dataintent) {//dataintent:20150106
        year = Integer.valueOf(dataintent.substring(0, 4));
        month = Integer.valueOf(dataintent.substring(4, 6));
        day = Integer.valueOf(dataintent.substring(6, 8));

    }

    /**
     * 获取今天时间
     * 格式yyyy-mm-dd (今天)
     *
     * @return
     */
    public String getTodayTime() {
        //今天时间
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String todayTime = df.format(new Date()) + " (今天)";
        Calendar c = Calendar.getInstance();
        //  年月日
        year = c.get(Calendar.YEAR);
        month = c.get(Calendar.MONTH) + 1;
        day = c.get(Calendar.DATE);
        return todayTime;
    }

    /**
     * 获取今天时间
     * 格式yyyy-mm-dd (今天)
     *
     * @return
     */
    public String getTodayDate() {
        //今天时间
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String todayTime = df.format(new Date());
        return todayTime;
    }
}
