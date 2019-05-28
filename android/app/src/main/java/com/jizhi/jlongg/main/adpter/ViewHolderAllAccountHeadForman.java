package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.graphics.Color;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.ImageView;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class ViewHolderAllAccountHeadForman extends AllAccountRecycleViewHolder {
    //记账对象，日期，项目
    private TextView tv_role_name, tv_proname, tv_date;
    //记账的年月日
    public int year, month, day;
    public AlphaAnimation animator;
    private boolean startAnim=false;
    public ViewHolderAllAccountHeadForman(View itemView, Activity activity, NewAllAccountAdapter.AllAccountListener allAccountListener) {
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
    public void bindHolder(int positions, List<AccountAllWorkBean> list) {
//        this.position = position;
        this.list = list;
        tv_date.setText(list.get(getAdapterPosition()).getDate());
        tv_role_name.setText(list.get(getAdapterPosition()).getRoleName());
        tv_proname.setText(list.get(getAdapterPosition()).getPro_name());


        itemView.findViewById(R.id.img_role_arrow).setVisibility(list.get(getAdapterPosition()).isHintRoleArrow() ? View.GONE : View.VISIBLE);
        tv_role_name.setTextColor(ContextCompat.getColor(activity, list.get(getAdapterPosition()).isHintRoleArrow() ? R.color.color_999999 : R.color.color_333333));
        itemView.findViewById(R.id.rea_role).setClickable(!list.get(getAdapterPosition()).isClickRole());

        itemView.findViewById(R.id.img_pro_arrow).setVisibility(list.get(getAdapterPosition()).isHintProjectArrow() ? View.GONE : View.VISIBLE);
        tv_proname.setTextColor(ContextCompat.getColor(activity, list.get(getAdapterPosition()).isHintProjectArrow() ? R.color.color_999999 : R.color.color_333333));
        itemView.findViewById(R.id.rea_project).setClickable(!list.get(getAdapterPosition()).isClickProject());
        FlashingHints((TextView) itemView.findViewById(R.id.tv_role_title),tv_role_name
                ,(ImageView)itemView.findViewById(R.id.img_role_arrow),(RelativeLayout)itemView.findViewById(R.id.rea_role));
    }

    public void initItemView() {
        tv_role_name = itemView.findViewById(R.id.tv_role_name);
        tv_proname = itemView.findViewById(R.id.tv_proname);
        tv_date = itemView.findViewById(R.id.tv_date);
        ((TextView) itemView.findViewById(R.id.tv_role_title)).setText("班组长");
        ((TextView) itemView.findViewById(R.id.tv_role_name)).setHint("请添加你的班组长/工头");

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
