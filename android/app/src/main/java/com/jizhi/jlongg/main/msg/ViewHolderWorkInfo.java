package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 4。0。1临时展示的找工作或者名片信息
 */
public class ViewHolderWorkInfo extends MessageRecycleViewHolder {
    /**
     * 名片layout
     */
    private RelativeLayout post_card_layout;

    /**
     * 找工作layout
     */
    private RelativeLayout lin_findjob;

    /**
     * 立即认证layout
     */
    private LinearLayout lin_verify;
    /**
     * 名片头像
     */
    private RoundeImageHashCodeTextLayout img_head_postcard;
    /**
     * 名片，名字
     */
    private TextView name;
    /**
     * 名片认证
     */
    private ImageView auth, verify;

    /**
     * 工种民族信息
     */
    private TextView text_workscale, text_workType;

    private RadioButton rb_verify;

    /**
     * 找工作信息
     */
    private TextView tv_pro_name, tv_type_work, tv_type, tv_money;

    public ViewHolderWorkInfo(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
        super(itemView);
        this.activity = activity;
        this.isSignChat = isSignChat;
        this.messageBroadCastListener = messageBroadCastListener;
        initAlickItemView();
        initItemView();
    }

    private void initItemView() {
        post_card_layout = itemView.findViewById(R.id.post_card_layout);
        lin_findjob = itemView.findViewById(R.id.lin_findjob);
        lin_verify = itemView.findViewById(R.id.lin_verify);
        img_head_postcard = itemView.findViewById(R.id.img_head_postcard);
        name = itemView.findViewById(R.id.name);
        auth = itemView.findViewById(R.id.auth);
        auth = itemView.findViewById(R.id.auth);
        verify = itemView.findViewById(R.id.verify);
        text_workscale = itemView.findViewById(R.id.text_workscale);
        text_workType = itemView.findViewById(R.id.text_workType);
        rb_verify = itemView.findViewById(R.id.rb_verify);
        tv_pro_name = itemView.findViewById(R.id.tv_pro_name);
        tv_type_work = itemView.findViewById(R.id.tv_type_work);
        tv_type = itemView.findViewById(R.id.tv_type);
        tv_money = itemView.findViewById(R.id.tv_money);
        itemView.findViewById(R.id.btn_send_postcard).setOnClickListener(onClickListener);
        itemView.findViewById(R.id.btn_send_findjob).setOnClickListener(onClickListener);
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        if (!TextUtils.isEmpty(message.getMsg_text_other())) {
            LUtils.e("名片" + message.getMsg_text_other());
            PersonWorkInfoBean info = new Gson().fromJson(message.getMsg_text_other(), PersonWorkInfoBean.class);

            LUtils.e(info.getClick_type() + "-----getMsg_text_other-----" + message.getMsg_text_other());
            /**********************************************
             * click_type  1.显示名片 2.显示找工作信息
             * verified==3  实名
             *  group_verified==1 || person_verified==1 认证
             ******************************************/
            /**
             * 1.显示名片
             */
            if (info.getClick_type() == 1) {
                showPostCard(info);

            } else if (info.getClick_type() == 2) {
                showFindjob(info);
            } else {
                post_card_layout.setVisibility(View.GONE);
                lin_findjob.setVisibility(View.GONE);
            }
            if (NonEmpty(info.getVerified()) &&
                    Integer.parseInt(info.getVerified()) == 3) {
                lin_verify.setVisibility(View.GONE);
            } else {
                lin_verify.setVisibility(View.VISIBLE);
                itemView.findViewById(R.id.rb_verify).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        X5WebViewActivity.actionStart(activity, NetWorkRequest.IDCARD);
                    }
                });
            }

        }
    }

    private void showFindjob(PersonWorkInfoBean info) {
        //2.显示找工作信息
        post_card_layout.setVisibility(View.GONE);
        lin_findjob.setVisibility(View.VISIBLE);
        if (NonEmpty(info.getPro_title())) {
            tv_pro_name.setText(info.getPro_title());
        }
        String type_name = info.getClasses().getCooperate_type().getType_name();
        int type_id = info.getClasses().getCooperate_type().getType_id();
        if (NonEmpty(type_name)) {
            tv_type_work.setText(type_name);
        }
        if (type_id == 1) {
            //类型 工资标准or总规模
            tv_type.setText("工资标准");
            String money = getMoney(info.getClasses().getMoney()).replace(".00", "");
            String balance_way = " 元/" + info.getClasses().getBalance_way();
            if (money.equals("面议")) {
                tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> "));
            } else {
                String max_money = info.getClasses().getMax_money();
                if (TextUtils.isEmpty(max_money) || max_money.equals("0")) {
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> " + balance_way + ""));

                } else {
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + " ~ " + Integer.parseInt(max_money) + "</font> " + balance_way + ""));

                }
            }
            Utils.setBackGround((tv_type_work), ContextCompat.getDrawable(activity, R.drawable.bg_og_eb7a4e_3radius));
        } else if (type_id == 2) {
            tv_type.setText("总规模");
            String money = getMoney(Float.valueOf(info.getClasses().getTotal_scale())).replace(".00", "");
            String balance_way =  info.getClasses().getBalance_way();
            if (money.equals("面议")) {
                tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> "));
            } else {
                String max_money = info.getClasses().getMax_money();
                if (TextUtils.isEmpty(max_money) || max_money.equals("0")) {
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> " + balance_way + ""));

                } else {
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + " ~ " + Integer.parseInt(max_money) + "</font> " + balance_way + ""));

                }
            }
            Utils.setBackGround((tv_type_work), ContextCompat.getDrawable(activity, R.drawable.bg_og_d7252c_2radius));
        }else if (type_id==4){
            String s="";
            if (NonEmpty(info.getClasses().getWork_begin())){
                s = "<font color='#666666'>开工时间:&nbsp;</font>"+"<font color='#d7252c'>"+info.getClasses().getWork_begin()+"</font><br/>";
            }
            String money = getMoney(info.getClasses().getMoney()).replace(".00", "");
            String balance_way = " 元/人/" + info.getClasses().getBalance_way();
            if (money.equals("面议")) {
                s=s+"<font color='#666666'>工钱:&nbsp;</font><font color=\"#d7252c\">" + money + "</font> ";
            } else {
                String max_money = info.getClasses().getMax_money();
                if (TextUtils.isEmpty(max_money) || max_money.equals("0")) {
                    s=s+"<font color='#666666'>工钱:&nbsp;</font><font color=\"#d7252c\">" + money + "</font> " + "<font color='#666666'>"+balance_way+"</font>" ;

                } else {
                    s=s+"<font color='#666666'>工钱:&nbsp;</font><font color=\"#d7252c\">" + money + " ~ " + Integer.parseInt(max_money) + "</font> " + "<font color='#666666'>"+balance_way+"</font>"  ;

                }
            }
            tv_type.setText(Html.fromHtml(s));
            Utils.setBackGround((tv_type_work), ContextCompat.getDrawable(activity, R.drawable.bg_og_3a92ff_3radius));
        }
        else {
            Utils.setBackGround((tv_type_work), ContextCompat.getDrawable(activity, R.drawable.bg_og_3a92ff_3radius));
            //类型 工资标准or总规模
            tv_type.setText("总规模");
            String total_scale = info.getClasses().getTotal_scale();
            String balance_way = info.getClasses().getBalance_way();
            if (total_scale.equals("0") || total_scale.equals("0.0")) {
                tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + "面议" + "</font> "));
            } else {
                tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + total_scale + "</font> " + balance_way + ""));
            }
        }
    }

    private boolean NonEmpty(String s) {
        return !TextUtils.isEmpty(s);
    }

    /**
     * 设置金额
     *
     * @param moneyValue
     */
    private String getMoney(float moneyValue) {
        if (moneyValue == 0) {
            return "面议";
        } else if (moneyValue > 0 && moneyValue < 10000) {
            return Utils.m2(((double) moneyValue));
        } else {
            return Utils.m2((double) (moneyValue / 10000)) + "万";
        }
    }

    private void showPostCard(PersonWorkInfoBean info) {
        post_card_layout.setVisibility(View.VISIBLE);
        lin_findjob.setVisibility(View.GONE);
        img_head_postcard.setView(info.getHead_pic(), info.getReal_name(), 0);
        name.setText(info.getReal_name());
        //乌兹别克族 工龄 20 年 队伍 150 人
        String s = "";
        if (NonEmpty(info.getNationality())&&!info.getNationality().equals("族")) {
            s = "<font color='#666666'>" + info.getNationality() + "</font>";
        }
        if (NonEmpty(info.getWork_year())&&!info.getWork_year().equals("0")) {
            s = s + "&nbsp;<font color='#666666'>工龄&nbsp;</font><font color='#EB4E4E'>" + info.getWork_year() + "&nbsp;</font><font color='#666666'>年</font>";
        }
        if (NonEmpty(info.getScale()) && !info.getScale().equals("0")) {
            s = s + "&nbsp;<font color='#666666'>队伍&nbsp;</font>" + "<font color='#EB4E4E'>" + info.getScale() + "&nbsp;</font>" + "<font color='#666666'>人</font>";
        }
        text_workscale.setText(Html.fromHtml(s));

        //合并后的工种
        List<String> work_type = MessageUtils.getWork_type(info);
        StringBuffer buffer = new StringBuffer();
        if (null != work_type && !work_type.isEmpty()) {
            text_workType.setVisibility(View.VISIBLE);
            for (int i = 0; i < work_type.size(); i++) {
                buffer.append(work_type.get(i));
                if (i < work_type.size() - 1) {
                    buffer.append(" | ");
                }
            }
            text_workType.setText(buffer);
        } else {
            text_workType.setVisibility(View.GONE);
        }

        if (NonEmpty(info.getVerified()) &&
                Integer.parseInt(info.getVerified()) == 3) {
            LUtils.e("-------显示名片了-----" + info.getVerified());
            auth.setVisibility(View.VISIBLE);
        } else {
            LUtils.e("-------隐藏名片了-----" + info.getVerified());
            auth.setVisibility(View.INVISIBLE);
        }
        if (NonEmpty(info.getGroup_verified()) &&
                Integer.parseInt(info.getGroup_verified()) == 1 ||
                NonEmpty(info.getPerson_verified()) &&
                        Integer.parseInt(info.getPerson_verified()) == 1) {
            LUtils.e("-------显示认证了-----");
            verify.setVisibility(View.VISIBLE);
        } else {
            LUtils.e("--------隐藏认证了-----");
            verify.setVisibility(View.INVISIBLE);
        }
    }
}
