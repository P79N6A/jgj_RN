package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;

import org.w3c.dom.Text;

import java.util.List;

/**
 * 提示信息
 */
public class ViewHolderFindWork extends MessageRecycleViewHolder {

    private TextView tv_pro_name_right, tv_type_work_right, tv_type_right,
            tv_money_right, tv_pro_name_left, tv_type_work_left, tv_type_left, tv_money_left;
    private RelativeLayout send_left,send_right;
    public ViewHolderFindWork(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
        super(itemView);
        this.activity = activity;
        this.isSignChat = isSignChat;
        this.messageBroadCastListener = messageBroadCastListener;
        initAlickItemView();
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }

    private void initItemView() {
        tv_pro_name_right = itemView.findViewById(R.id.tv_pro_name_right);
        tv_type_work_right = itemView.findViewById(R.id.tv_type_work_right);
        tv_type_right = itemView.findViewById(R.id.tv_type_right);
        tv_money_right = itemView.findViewById(R.id.tv_money_right);
        tv_pro_name_left = itemView.findViewById(R.id.tv_pro_name_left);
        tv_type_work_left = itemView.findViewById(R.id.tv_type_work_left);
        tv_type_left = itemView.findViewById(R.id.tv_type_left);
        tv_money_left = itemView.findViewById(R.id.tv_money_left);
        send_left = itemView.findViewById(R.id.send_left);
        send_right = itemView.findViewById(R.id.send_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        setItemAlickData(message);
        if (!TextUtils.isEmpty(message.getMsg_text_other())) {
            PersonWorkInfoBean info = new Gson().fromJson(message.getMsg_text_other(), PersonWorkInfoBean.class);
            if (!NewMessageUtils.isMySendMessage(message)) {
                send_left.setOnClickListener(onClickListener);
                img_head_left.setOnClickListener(onClickListener);
                showFindjob(info,tv_pro_name_left,tv_type_work_left,tv_type_left,tv_money_left);

            } else {
                img_head_right.setOnClickListener(onClickListener);
                send_right.setOnClickListener(onClickListener);
                showFindjob(info,tv_pro_name_right,tv_type_work_right,tv_type_right,tv_money_right);

            }
            ((ImageButton)itemView.findViewById(R.id.img_sendfail)).setOnClickListener(onClickListener);
        }
    }

    private void showFindjob(PersonWorkInfoBean info, TextView tv_pro_name, TextView tv_type_work,TextView tv_type,
                             TextView tv_money) {

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
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "~" + Integer.parseInt(max_money) + "</font> " + balance_way));

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
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> " + balance_way));

                } else {
                    tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "~" + Integer.parseInt(max_money) + "</font> " + balance_way));

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
                    s=s+"<font color='#666666'>工钱:&nbsp;</font><font color=\"#d7252c\">" + money + "~" + Integer.parseInt(max_money) + "</font> " + "<font color='#666666'>"+balance_way+"</font>"  ;

                }
            }
            tv_type.setText(Html.fromHtml(s));
            Utils.setBackGround((tv_type_work), ContextCompat.getDrawable(activity, R.drawable.bg_og_3a92ff_3radius));
        } else {
            Utils.setBackGround((tv_type_work), ContextCompat.getDrawable(activity, R.drawable.bg_og_3a92ff_3radius));
            //类型 工资标准or总规模
            tv_type.setText("总规模");
            String total_scale = info.getClasses().getTotal_scale();
            String balance_way = info.getClasses().getBalance_way();
            if (total_scale.equals("0") || total_scale.equals("0.0")) {
                tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + "面议" + "</font> "));
            } else {
                tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + total_scale + "</font> " + balance_way));
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
}
