package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 找工作
 */
public class ViewHolderFindJob extends MessageRecycleViewHolder {
    private LinearLayout lin_findjob, lin_findhelper;//找工作布局，招聘(个人信息)布局
    private TextView tv_money;//金额


    public ViewHolderFindJob(View itemView, Activity activity) {
        super(itemView);
        this.activity = activity;
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 获取itemView
     */
    public void initItemView() {
        lin_findjob = itemView.findViewById(R.id.lin_findjob);
        lin_findhelper = itemView.findViewById(R.id.lin_findhelper);
        tv_money = itemView.findViewById(R.id.tv_money);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(final MessageBean message) {
        //有信息
        if (null != message.getMsg_prodetail()) {
            //显示认证信息
            //未实名用户
            if (!TextUtils.isEmpty(message.getMsg_sender()) && !TextUtils.isEmpty(message.getMsg_prodetail().getVerified()) && !message.getMsg_prodetail().getVerified().equals("3")) {
                itemView.findViewById(R.id.lin_verifie).setVisibility(View.VISIBLE);
                if (NewMessageUtils.isMySendMessage(message)) {
                    LUtils.e(message.getMsg_sender() + "---isMySendMessage---AAAA---11------" + NewMessageUtils.isMySendMessage(message));
                    //如果是自己，提示自己去实名认证
                    itemView.findViewById(R.id.rb_verifie).setVisibility(View.VISIBLE);
                    itemView.findViewById(R.id.tv_verifie_type).setVisibility(View.VISIBLE);
                    if (message.getMsg_prodetail().getProdetailactive() != null) {
                        ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText("你还未实名认证，实名认证能提高找工作的成功率");
                    } else if (message.getMsg_prodetail().getSearchuser() != null) {
                        ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText("你还未实名认证，实名认证能提高招工的成功率");
                    } else {
                        ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText("你还未实名认证，实名认证能提高招工的成功率");
                    }
                    itemView.findViewById(R.id.rb_verifie).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            X5WebViewActivity.actionStart(activity, NetWorkRequest.IDCARD);
                        }
                    });
                } else {
                    //显示对方未实名
//                    LUtils.e(new Gson().toJson(message) + "---isMySendMessage---AAAA------22---" + NewMessageUtils.isMySendMessage(message));
                    itemView.findViewById(R.id.tv_verifie_type).setVisibility(View.VISIBLE);
                    if (null != message.getUser_info() && !TextUtils.isEmpty(message.getUser_info().getFull_name())) {
                        ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText(Html.fromHtml("<font color='#FF6600'>" + message.getUser_info().getFull_name() + "</font> 未实名认证"));
                    } else {
                        ((TextView) itemView.findViewById(R.id.tv_verifie_type)).setText(Html.fromHtml("<font color='#FF6600'>他</font> 未实名认证"));

                    }

                    itemView.findViewById(R.id.rb_verifie).setVisibility(View.GONE);
                }
            } else {
                LUtils.e(message.getMsg_sender() + "---isMySendMessage---AAAA-----33----" + NewMessageUtils.isMySendMessage(message));
                itemView.findViewById(R.id.lin_verifie).setVisibility(View.GONE);
            }
            //找工作布局
            if (null != message.getMsg_prodetail() && message.getMsg_prodetail().getProdetailactive() != null) {
                lin_findjob.setVisibility(View.VISIBLE);
                //项目名字
                ((TextView) itemView.findViewById(R.id.tv_pro_name)).setText(message.getMsg_prodetail().getProdetailactive().getPro_title());
                //工种
                ((TextView) itemView.findViewById(R.id.tv_type_work)).setText(message.getMsg_prodetail().getProdetailactive().getClasses().getCooperate_type().getType_name());
                if (message.getMsg_prodetail().getProdetailactive().getClasses().getCooperate_type().getType_id() == 1) {
                    //类型 工资标准or总规模
                    ((TextView) itemView.findViewById(R.id.tv_type)).setText("工资标准");
                    String money = getMoney(message.getMsg_prodetail().getProdetailactive().getClasses().getMoney()).replace(".00", "");
                    String balance_way = " 元/" + message.getMsg_prodetail().getProdetailactive().getClasses().getBalance_way();
                    if (money.equals("面议")) {
                        tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> "));
                    } else {
                        String max_money = message.getMsg_prodetail().getProdetailactive().getClasses().getMax_money();
                        if (TextUtils.isEmpty(max_money) || max_money.equals("0")) {
                            tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> " + balance_way + ""));

                        } else {
                            tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + " ~ " + Integer.parseInt(max_money) + "</font> " + balance_way + ""));

                        }
                    }
                    Utils.setBackGround((itemView.findViewById(R.id.tv_type_work)), ContextCompat.getDrawable(activity, R.drawable.bg_og_eb7a4e_3radius));
                } else if (message.getMsg_prodetail().getProdetailactive().getClasses().getCooperate_type().getType_id() == 2) {
                    Utils.setBackGround((itemView.findViewById(R.id.tv_type_work)), ContextCompat.getDrawable(activity, R.drawable.bg_og_d7252c_4radius));
                } else {
                    Utils.setBackGround((itemView.findViewById(R.id.tv_type_work)), ContextCompat.getDrawable(activity, R.drawable.bg_og_3a92ff_3radius));
                    //类型 工资标准or总规模
                    ((TextView) itemView.findViewById(R.id.tv_type)).setText("总规模");
                    String total_scale = message.getMsg_prodetail().getProdetailactive().getClasses().getTotal_scale();
                    String balance_way = message.getMsg_prodetail().getProdetailactive().getClasses().getBalance_way();
                    if (total_scale.equals("0") || total_scale.equals("0.0")) {
                        tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + "面议" + "</font> "));
                    } else {
                        tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + total_scale + "</font> " + balance_way + ""));
                    }
                }
                lin_findjob.setOnClickListener(new View.OnClickListener() {
                                                   @Override
                                                   public void onClick(View v) {
                                                       if (message.getMsg_prodetail().getProdetailactive() != null && message.getMsg_prodetail().getProdetailactive().getPid() != 0) {
                                                           String url = NetWorkRequest.WORK + "/" + message.getMsg_prodetail().getProdetailactive().getPid();
                                                           X5WebViewActivity.actionStart(activity, url);
                                                       }
                                                   }
                                               }

                );

            } else {
                lin_findjob.setVisibility(View.GONE);

            }
            //招聘(个人信息)布局
            if (null != message.getMsg_prodetail() && message.getMsg_prodetail().getSearchuser() != null) {
                lin_findhelper.setVisibility(View.VISIBLE);
                if (!TextUtils.isEmpty(message.getMsg_prodetail().getSearchuser().getTitle())) {
                    ((TextView) itemView.findViewById(R.id.tv_search_hint)).setText(message.getMsg_prodetail().getSearchuser().getTitle());
                    itemView.findViewById(R.id.tv_search_hint).setVisibility(View.VISIBLE);
                } else {
                    itemView.findViewById(R.id.tv_search_hint).setVisibility(View.GONE);
                }

                ((TextView) itemView.findViewById(R.id.tv_name)).setText(message.getMsg_prodetail().getSearchuser().getRealname());
                if (TextUtils.isEmpty(message.getMsg_prodetail().getSearchuser().getWork_year()) || message.getMsg_prodetail().getSearchuser().getWork_year().equals("null")) {
                    ((TextView) itemView.findViewById(R.id.tv_work_year)).setText(Html.fromHtml("工龄:<font color=\"#d7252c\">" + 0 + "</font>年"));
                } else {
                    ((TextView) itemView.findViewById(R.id.tv_work_year)).setText(Html.fromHtml("工龄:<font color=\"#d7252c\">" + message.getMsg_prodetail().getSearchuser().getWork_year() + "</font>年"));
                }

                ((RoundeImageHashCodeTextLayout) itemView.findViewById(R.id.img_head)).setView(message.getMsg_prodetail().getSearchuser().getHead_pic(), message.getMsg_prodetail().getSearchuser().getRealname(), 0);
                lin_findhelper.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (TextUtils.isEmpty(message.getGroup_id())) {
                            return;
                        }
                        String url = NetWorkRequest.WEBURLS + "job/userinfo?role_type=" + message.getMsg_prodetail().getSearchuser().getRole_type() + "&uid=" + message.getGroup_id();
                        X5WebViewActivity.actionStart(activity, url);
                    }
                });
            } else {
                lin_findhelper.setVisibility(View.GONE);

            }

            if (message.getMsg_prodetail().getProdetailactive() != null && message.getMsg_prodetail().getSearchuser() != null) {
                itemView.findViewById(R.id.view_line).setVisibility(View.VISIBLE);

            } else {
                itemView.findViewById(R.id.view_line).setVisibility(View.INVISIBLE);
            }
        }

        if (message.getMsg_prodetail().getProdetailactive() != null && message.getMsg_prodetail().getSearchuser() != null) {
            itemView.findViewById(R.id.view_line).setVisibility(View.VISIBLE);

        } else {
            itemView.findViewById(R.id.view_line).setVisibility(View.INVISIBLE);
        }
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
