package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.URLSpan;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.procloud.LoadCloudPicActivity;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.MyURLSpan;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.BubbleParams;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.jizhi.jongg.widget.SWImageView;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.jizhi.jlongg.R.id.img_head_right;
import static com.jizhi.jlongg.R.id.img_sendfail;
import static com.jizhi.jlongg.R.id.tv_text_left;


/**
 * 消息适配器基类
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-11-25 下午2:41:57
 */

public class MessageBaseAdapter extends BaseAdapter {
    protected boolean isSignChat;
    private String group_id, uid;

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public void setSignChat(boolean signChat) {
        isSignChat = signChat;
    }

    @Override
    public int getCount() {
        return 0;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return null;
    }

    /**
     * 文本布局文件
     */
    protected TextHolder getTextView(View convertView) {
        TextHolder vh_msg_text = new TextHolder();
        //左边
        vh_msg_text.rea_msg_text_left = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_left);
        vh_msg_text.img_head_left = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head_left);
        vh_msg_text.tv_username_left = (TextView) convertView.findViewById(R.id.tv_username_left);
        vh_msg_text.tv_text_left = (TextView) convertView.findViewById(R.id.tv_text_left);
//        vh_msg_text.tv_text_left_mm = (BQMMMessageText) convertView.findViewById(R.id.tv_text_left);
        vh_msg_text.img_sendfail = (ImageView) convertView.findViewById(img_sendfail);

        //右边
        vh_msg_text.rea_msg_text_right = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_right);
        vh_msg_text.tv_unread_right = (TextView) convertView.findViewById(R.id.tv_unread_right);
        vh_msg_text.tv_date_right = (TextView) convertView.findViewById(R.id.tv_date_right);
        vh_msg_text.tv_text_right = (TextView) convertView.findViewById(R.id.tv_text_right);
//        vh_msg_text.tv_text_right_mm = (BQMMMessageText) convertView.findViewById(R.id.tv_text_right);
        vh_msg_text.spinner = (ImageView) convertView.findViewById(R.id.spinner);
        vh_msg_text.img_head_right = (RoundeImageHashCodeTextLayout) convertView.findViewById(img_head_right);
        convertView.setTag(vh_msg_text);
        return vh_msg_text;
    }

    /**
     * 图片布局文件
     */
    protected TextHolder getPictureView(View convertView) {
        TextHolder vh_msg_text = new TextHolder();
        //左边
        vh_msg_text.rea_msg_text_left = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_left);
        vh_msg_text.img_head_left = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head_left);
        vh_msg_text.tv_username_left = (TextView) convertView.findViewById(R.id.tv_username_left);
        vh_msg_text.bimg_left = (SWImageView) convertView.findViewById(R.id.bimg_left);
        //
        vh_msg_text.rea_msg_text_right = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_right);
        vh_msg_text.tv_unread_right = (TextView) convertView.findViewById(R.id.tv_unread_right);
        vh_msg_text.tv_date_right = (TextView) convertView.findViewById(R.id.tv_date_right);
        vh_msg_text.img_head_right = (RoundeImageHashCodeTextLayout) convertView.findViewById(img_head_right);
        vh_msg_text.bimg_right = (SWImageView) convertView.findViewById(R.id.bimg_right);
        vh_msg_text.img_sendfail = (ImageView) convertView.findViewById(img_sendfail);
        convertView.setTag(vh_msg_text);
        return vh_msg_text;
    }

    /**
     * 语音布局文件
     */
    protected TextHolder getVoiceView(View convertView) {
        TextHolder vh_msg_text = new TextHolder();
        //左边
        vh_msg_text.rea_msg_text_left = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_left);
        vh_msg_text.rea_voice_left = (RelativeLayout) convertView.findViewById(R.id.rea_voice_left);
        vh_msg_text.img_head_left = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head_left);
        vh_msg_text.tv_username_left = (TextView) convertView.findViewById(R.id.tv_username_left);
        vh_msg_text.tv_text_left = (TextView) convertView.findViewById(tv_text_left);
        vh_msg_text.voiceAnimationImage_left = (ImageView) convertView.findViewById(R.id.voiceAnimationImage_left);
        vh_msg_text.red_circle = (ImageView) convertView.findViewById(R.id.red_circle);
        //右边
        vh_msg_text.rea_msg_text_right = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_right);
        vh_msg_text.rea_voice_right = (RelativeLayout) convertView.findViewById(R.id.rea_voice_right);
        vh_msg_text.tv_unread_right = (TextView) convertView.findViewById(R.id.tv_unread_right);
        vh_msg_text.tv_date_right = (TextView) convertView.findViewById(R.id.tv_date_right);
        vh_msg_text.tv_text_right = (TextView) convertView.findViewById(R.id.tv_text_right);
        vh_msg_text.voiceAnimationImage_right = (ImageView) convertView.findViewById(R.id.voiceAnimationImage_right);
        vh_msg_text.img_head_right = (RoundeImageHashCodeTextLayout) convertView.findViewById(img_head_right);
        vh_msg_text.img_sendfail = (ImageView) convertView.findViewById(img_sendfail);
        vh_msg_text.spinner = (ImageView) convertView.findViewById(R.id.spinner);
        convertView.setTag(vh_msg_text);
        return vh_msg_text;
    }

    /**
     * 图片布局文件
     */
    protected ImageHolder geNoticeView(View convertView) {
        //左边
        ImageHolder vh_img_holder = new ImageHolder();
        vh_img_holder.rea_msg_text_left = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_left);
        vh_img_holder.img_head_left = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head_left);
        vh_img_holder.tv_username_left = (TextView) convertView.findViewById(R.id.tv_username_left);
        vh_img_holder.tv_text_left = (TextView) convertView.findViewById(R.id.tv_text_left);
        vh_img_holder.img_icon_left = (ImageView) convertView.findViewById(R.id.img_icon_left);
        vh_img_holder.tv_title_top_left = (TextView) convertView.findViewById(R.id.tv_title_top_left);
        vh_img_holder.ngl_images_left = (NineGridMsgImageView) convertView.findViewById(R.id.ngl_images_left);
        vh_img_holder.spinner = (ImageView) convertView.findViewById(R.id.spinner);
        vh_img_holder.rea_bg_left = (RelativeLayout) convertView.findViewById(R.id.rea_bg_left);
        vh_img_holder.img_arrow_left = (ImageView) convertView.findViewById(R.id.img_arrow_left);
        vh_img_holder.tv_hintcontent_left = (TextView) convertView.findViewById(R.id.tv_hintcontent_left);
        //右边
        vh_img_holder.rea_msg_text_right = (RelativeLayout) convertView.findViewById(R.id.rea_msg_text_right);
        vh_img_holder.tv_unread_right = (TextView) convertView.findViewById(R.id.tv_unread_right);
        vh_img_holder.tv_date_right = (TextView) convertView.findViewById(R.id.tv_date_right);
        vh_img_holder.tv_text_right = (TextView) convertView.findViewById(R.id.tv_text_right);
        vh_img_holder.img_icon_right = (ImageView) convertView.findViewById(R.id.img_icon_right);
        vh_img_holder.tv_title_top_right = (TextView) convertView.findViewById(R.id.tv_title_top_right);
        vh_img_holder.ngl_images_right = (NineGridMsgImageView) convertView.findViewById(R.id.ngl_images_right);
        vh_img_holder.rea_bg_right = (RelativeLayout) convertView.findViewById(R.id.rea_bg_right);
        vh_img_holder.img_head_right = (RoundeImageHashCodeTextLayout) convertView.findViewById(img_head_right);
        vh_img_holder.img_sendfail = (ImageView) convertView.findViewById(R.id.img_sendfail);
        vh_img_holder.img_arrow_right = (ImageView) convertView.findViewById(R.id.img_arrow_right);
        vh_img_holder.tv_hintcontent_right = (TextView) convertView.findViewById(R.id.tv_hintcontent_right);
        return vh_img_holder;
    }

    /**
     * 设置找工作找帮手布局
     */
    protected MsgOtherHolder getOtherView(View convertView) {
        MsgOtherHolder vh_other_view = new MsgOtherHolder();
        //左边
        vh_other_view.lin_findjob = (LinearLayout) convertView.findViewById(R.id.lin_findjob);
        vh_other_view.tv_pro_name = (TextView) convertView.findViewById(R.id.tv_pro_name);
        vh_other_view.tv_type_work = (TextView) convertView.findViewById(R.id.tv_type_work);
        vh_other_view.tv_type = (TextView) convertView.findViewById(R.id.tv_type);
        vh_other_view.tv_money = (TextView) convertView.findViewById(R.id.tv_money);
        vh_other_view.view_line = convertView.findViewById(R.id.view_line);

        //右边
        vh_other_view.lin_findhelper = (LinearLayout) convertView.findViewById(R.id.lin_findhelper);
        vh_other_view.tv_search_hint = (TextView) convertView.findViewById(R.id.tv_search_hint);
        vh_other_view.img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
        vh_other_view.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
        vh_other_view.tv_work_year = (TextView) convertView.findViewById(R.id.tv_work_year);
        convertView.setTag(vh_other_view);
        return vh_other_view;
    }

    /**
     * 设置找工作找帮手布局内容
     */
    protected void setMessageOther(MsgOtherHolder vh_other_view, final MessageEntity entity, final Context context) {
        if (entity.getProdetailactive() == null && entity.getProdetailactive() == null) {
            vh_other_view.lin_findjob.setVisibility(View.GONE);
            vh_other_view.lin_findhelper.setVisibility(View.GONE);
            return;
        }
        if (entity.getProdetailactive() != null && entity.getSearchuser() != null) {
            vh_other_view.view_line.setVisibility(View.VISIBLE);
        } else {
            vh_other_view.view_line.setVisibility(View.INVISIBLE);
        }
        if (entity.getProdetailactive() != null) {
            vh_other_view.lin_findjob.setVisibility(View.VISIBLE);
            //找工作
            vh_other_view.tv_pro_name.setText(entity.getProdetailactive().getPro_title());
            vh_other_view.tv_type_work.setText(entity.getProdetailactive().getClasses().getCooperate_type().getType_name());
            if (entity.getProdetailactive().getClasses().getCooperate_type().getType_id() == 1) {
                Utils.setBackGround(vh_other_view.tv_type_work,context.getResources().getDrawable(R.drawable.bg_og_eb7a4e_3radius));
                //点工
                vh_other_view.tv_type.setText("工资标准");
                String money = getMoney(entity.getProdetailactive().getClasses().getMoney());
                String balance_way = " 元/" + entity.getProdetailactive().getClasses().getBalance_way();
                if (money.equals("面议")) {
                    vh_other_view.tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> "));
                } else {
                    vh_other_view.tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + money + "</font> " + balance_way + ""));
                }
            } else if (entity.getProdetailactive().getClasses().getCooperate_type().getType_id() == 4) {
                Utils.setBackGround(vh_other_view.tv_type_work,context.getResources().getDrawable(R.drawable.bg_og_3a92ff_3radius));
                //突击队
                vh_other_view.tv_type.setText("" + Html.fromHtml("开工时间：<font color=\"#eb4e4e\">" + entity.getProdetailactive().getClasses().getWork_begin() + "</font> "));
                String money = getMoney(entity.getProdetailactive().getClasses().getMoney());
                String balance_way = " 元/人/" + entity.getProdetailactive().getClasses().getBalance_way();
                if (money.equals("面议")) {
                    vh_other_view.tv_money.setText(Html.fromHtml("工钱：<font color=\"#d7252c\">" + money + "</font> "));
                } else {
                    vh_other_view.tv_money.setText(Html.fromHtml("工钱：<font color=\"#d7252c\">" + money + "</font> " + balance_way + ""));
                }
            } else {
                Utils.setBackGround(vh_other_view.tv_type_work,context.getResources().getDrawable(R.drawable.bg_og_eb7a4e_3radius));
                vh_other_view.tv_type.setText("总规模");
                String total_scale = entity.getProdetailactive().getClasses().getTotal_scale();
                String balance_way = entity.getProdetailactive().getClasses().getBalance_way();
                if (total_scale.equals("0") || total_scale.equals("0.0")) {
                    vh_other_view.tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + "面议" + "</font> "));
                } else {
                    vh_other_view.tv_money.setText(Html.fromHtml("<font color=\"#d7252c\">" + total_scale + "</font> " + balance_way + ""));
                }
            }

            vh_other_view.lin_findjob.setOnClickListener(new View.OnClickListener() {
                                                             @Override
                                                             public void onClick(View v) {
                                                                 if (entity.getProdetailactive() != null && entity.getProdetailactive().getPid() != 0) {
                                                                     String url = NetWorkRequest.WORK + "/" + entity.getProdetailactive().getPid();
                                                                     Intent intent = new Intent();
                                                                     intent.setClass(context, X5WebViewActivity.class);
                                                                     intent.putExtra("url", url);
                                                                     intent.putExtra("isShowTitle", false);
                                                                     context.startActivity(intent);
                                                                 }
                                                             }
                                                         }

            );
        }
        if (entity.getSearchuser() != null) {
            vh_other_view.lin_findhelper.setVisibility(View.VISIBLE);
            if (!TextUtils.isEmpty(entity.getSearchuser().getTitle())) {
                vh_other_view.tv_search_hint.setText(entity.getSearchuser().getTitle());
                vh_other_view.tv_search_hint.setVisibility(View.VISIBLE);
            } else {
                vh_other_view.tv_search_hint.setVisibility(View.GONE);
            }

            vh_other_view.tv_name.setText(entity.getSearchuser().getRealname());
            if (TextUtils.isEmpty(entity.getSearchuser().getWork_year()) || entity.getSearchuser().getWork_year().equals("null")) {
                vh_other_view.tv_work_year.setText(Html.fromHtml("工龄:<font color=\"#d7252c\">" + 0 + "</font>年"));
            } else {
                vh_other_view.tv_work_year.setText(Html.fromHtml("工龄:<font color=\"#d7252c\">" + entity.getSearchuser().getWork_year() + "</font>年"));
            }

            vh_other_view.img_head.setView(entity.getSearchuser().getHead_pic(), entity.getSearchuser().getRealname(), 0);
//            Picasso.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getSearchuser().getHead_pic()).placeholder(R.drawable.friend_head).error(R.drawable.friend_head).into(vh_other_view.img_head);

            vh_other_view.lin_findhelper.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    LUtils.e("lin_findhelper--" + entity.getGroup_id());
                    if (TextUtils.isEmpty(entity.getGroup_id())) {
                        return;
                    }
                    String url = NetWorkRequest.WEBURLS + "job/userinfo?role_type=" + entity.getSearchuser().getRole_type() + "&uid=" + entity.getGroup_id();
                    Intent intent = new Intent();
                    intent.setClass(context, X5WebViewActivity.class);
                    intent.putExtra("url", url);
                    intent.putExtra("isShowTitle", false);
                    context.startActivity(intent);
                }
            });
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


    /**
     * 设置文字左边内容
     */
    protected void setPictureLeft(final TextHolder vh_msg_text, final MessageEntity entity, final Context context) {
        vh_msg_text.rea_msg_text_left.setVisibility(View.VISIBLE);
        vh_msg_text.rea_msg_text_right.setVisibility(View.GONE);
        if (null != entity.getPic_w_h() && entity.getPic_w_h().size() == 2) {
            RelativeLayout.LayoutParams linearParams = (RelativeLayout.LayoutParams) vh_msg_text.bimg_left.getLayoutParams();
            int width = Integer.parseInt(entity.getPic_w_h().get(0));
            int height = Integer.parseInt(entity.getPic_w_h().get(1));
            List<String> msg_w_h = Utils.getImageWidthAndHeight(width, height);
            linearParams.width = Integer.parseInt(msg_w_h.get(0));
            linearParams.height = Integer.parseInt(msg_w_h.get(1));
            vh_msg_text.bimg_left.setLayoutParams(linearParams);
        }
        vh_msg_text.tv_username_left.setText(entity.getUser_name() + "  " + TimesUtils.getMsgdata(entity.getDate()));
        vh_msg_text.img_head_left.setView(entity.getHead_pic(), entity.getReal_name(), 0);
        vh_msg_text.img_sendfail.setVisibility(View.GONE);
//        vh_msg_text.bimg_left.setProgress(100);

        if (null != entity.getPic_w_h() && entity.getPic_w_h().size() == 2) {
//            LUtils.e(new Gson().toJson(entity.getPic_w_h()) + "---------------" + NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString());
//            int width = Integer.parseInt(entity.getPic_w_h().get(0));
//            if (width == 266) {
//                Glide.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString()).asBitmap().placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(vh_msg_text.bimg_left);
//            } else {
//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString()).asBitmap().placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(vh_msg_text.bimg_left);
//            }
        } else {
//            LUtils.e("---------------" + NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString());
//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString()).asBitmap().placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(vh_msg_text.bimg_left);
        }
//        vh_msg_text.bimg_left.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                List<String> list = MessageUtils.selectMessagePic(entity.getGroup_id());
//                for (int i = 0; i < list.size(); i++) {
//                    if (list.get(i).toString().equals(entity.getMsg_src().get(0))) {
//                        picBrrow(list, i, vh_msg_text.bimg_right, context);
//                    }
//                }
//            }
//        });
        toUserInfo(vh_msg_text.img_head_left, entity.getUid(), context);
    }

    /**
     * 设置文字左边内容
     */
    protected void setPictureRight(final TextHolder vh_msg_text, final MessageEntity entity, final Context context) {
        vh_msg_text.img_head_right.setView(entity.getHead_pic(), entity.getReal_name(), 0);
        vh_msg_text.rea_msg_text_left.setVisibility(View.GONE);
        vh_msg_text.rea_msg_text_right.setVisibility(View.VISIBLE);
        vh_msg_text.tv_date_right.setText(TimesUtils.getMsgdata(entity.getDate()));
        if (null != entity.getPic_w_h() && entity.getPic_w_h().size() == 2) {
            LinearLayout.LayoutParams linearParams = (LinearLayout.LayoutParams) vh_msg_text.bimg_right.getLayoutParams();
            int width = Integer.parseInt(entity.getPic_w_h().get(0));
            int height = Integer.parseInt(entity.getPic_w_h().get(1));
            List<String> msg_w_h = Utils.getImageWidthAndHeight(width, height);
            linearParams.width = Integer.parseInt(msg_w_h.get(0));
            linearParams.height = Integer.parseInt(msg_w_h.get(1));
            linearParams.gravity = Gravity.RIGHT;
            linearParams.gravity = Gravity.RIGHT;
            vh_msg_text.bimg_right.setLayoutParams(linearParams);
        }
        //消息状态 0。成功  1.失败  2.发送中
        if (entity.getMsg_state() == 1) {
            vh_msg_text.img_sendfail.setVisibility(View.VISIBLE);
        } else {
            vh_msg_text.img_sendfail.setVisibility(View.GONE);
        }
    }

//    public void picBrrow(List<String> list, int index, ImageView imageView, Context context) {
//        //imagesize是作为loading时的图片size
//        MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
//        MessageImagePagerActivity.startImagePagerActivity(context, list, index, imageSize);
//    }

    public void setShowPicture(final TextHolder vh_msg_text, final MessageEntity entity, final Context context) {
        BubbleParams mbubbleParams = new BubbleParams();
//        vh_msg_text.bimg_right.setProgress(100);
//        vh_msg_text.bimg_right.setParam(mbubbleParams);
        initRightParam(mbubbleParams);
        LUtils.e("-------------------------" + entity.getMsg_src().get(0).toString());
        if (null != entity.getPic_w_h() && entity.getPic_w_h().size() == 2) {
            int width = Integer.parseInt(entity.getPic_w_h().get(0));
            if (width == 266) {
//                Glide.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString()).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(vh_msg_text.bimg_right);
            } else {
//                Glide.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString()).asBitmap().placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(vh_msg_text.bimg_right);
            }
        } else {
//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getMsg_src().get(0).toString()).asBitmap().placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(vh_msg_text.bimg_right);
        }
    }


    public void showImageView(List<String> list, int index, Context context) {
        //imagesize是作为loading时的图片size
        LUtils.e(new Gson().toJson(list) + ",,,,,,,,图片路径" +
                    ",,,");
        ArrayList<String> arrayList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            arrayList.add(NetWorkRequest.CDNURL + list.get(i));
        }
        LoadCloudPicActivity.actionStart((Activity) context, arrayList, index);
    }

    /**
     * 设置语音左边内容
     */

    protected void setVoiceLeft(TextHolder vh_msg_text, MessageEntity entity, Context context) {
        vh_msg_text.rea_msg_text_left.setVisibility(View.VISIBLE);
        vh_msg_text.rea_msg_text_right.setVisibility(View.GONE);
        vh_msg_text.tv_text_left.setText(entity.getVoice_long() + "\"");
        vh_msg_text.tv_username_left.setText(entity.getUser_name() + "  " + TimesUtils.getMsgdata(entity.getDate()));
        vh_msg_text.img_head_left.setView(entity.getHead_pic(), entity.getReal_name(), 0);
        if (null == entity.getIs_readed_local() || entity.getIs_readed_local().equals("0")) {
            vh_msg_text.red_circle.setVisibility(View.VISIBLE);
        } else {
            vh_msg_text.red_circle.setVisibility(View.GONE);
        }
        //根据时间设置语音长度
//        ScreenUtils.setViewWidthLengthLin(context, vh_msg_text.rea_voice_left, entity.getVoice_long());
    }

    /**
     * 设置语音右边边内容
     */
    protected void setVoiceRight(final TextHolder vh_msg_text, final MessageEntity entity, final Context context) {
        vh_msg_text.img_head_right.setView(entity.getHead_pic(), entity.getReal_name(), 0);
        vh_msg_text.rea_msg_text_left.setVisibility(View.GONE);
        vh_msg_text.rea_msg_text_right.setVisibility(View.VISIBLE);
        vh_msg_text.tv_date_right.setText(TimesUtils.getMsgdata(entity.getDate()));
        vh_msg_text.tv_text_right.setText(entity.getVoice_long() + "\"");
        int under = entity.getUnread_user_num();
        if (isSignChat) {
            vh_msg_text.tv_unread_right.setVisibility(View.GONE);
        } else {
            vh_msg_text.tv_unread_right.setTextColor(context.getResources().getColor(R.color.color_628ae0));
            if (under > 0) {
                vh_msg_text.tv_unread_right.setVisibility(View.VISIBLE);
                vh_msg_text.tv_unread_right.setText(context.getResources().getString(R.string.message_unread, under));
            } else {
                vh_msg_text.tv_unread_right.setVisibility(View.GONE);
            }
        }
        vh_msg_text.tv_unread_right.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startToReadInfoActivity(entity, context);
            }
        });
        //根据时间设置语音长度
        LUtils.e(entity.getMsg_state() + ",,," + entity.getMsg_id());
        if (entity.getMsg_state() == 2) {
            vh_msg_text.spinner.setVisibility(View.VISIBLE);
            vh_msg_text.img_sendfail.setVisibility(View.GONE);
            vh_msg_text.spinner.setBackgroundResource(R.drawable.load_spinner); //将动画资源文件设置为ImageView的背景
            AnimationDrawable anim = (AnimationDrawable) vh_msg_text.spinner.getBackground(); //获取ImageView背景,此时已被编译成AnimationDrawable
            if (!anim.isRunning()) {
                anim.start();  //开始动画
            }
        } else if (entity.getMsg_state() == 0) {
            vh_msg_text.spinner.setVisibility(View.GONE);
            vh_msg_text.img_sendfail.setVisibility(View.GONE);
        } else if (entity.getMsg_state() == 1) {
            vh_msg_text.spinner.setVisibility(View.GONE);
            vh_msg_text.img_sendfail.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 设置文字左边内容
     */

    protected void setTextLeft(TextHolder vh_msg_text, MessageEntity entity, Context context, int position) {
        vh_msg_text.rea_msg_text_left.setVisibility(View.VISIBLE);
        vh_msg_text.rea_msg_text_right.setVisibility(View.GONE);
        vh_msg_text.tv_username_left.setText(entity.getUser_name() + "  " + TimesUtils.getMsgdata(entity.getDate()));
        vh_msg_text.img_head_left.setView(entity.getHead_pic(), entity.getReal_name(), position);
        vh_msg_text.tv_text_left.setText(entity.getMsg_text());
        DataUtil.setHtmlClick(vh_msg_text.tv_text_left, context);
    }

    /**
     * 设置文字右边内容
     */
    protected void setTextRight(TextHolder vh_msg_text, MessageEntity entity, Context context, int positon) {
        vh_msg_text.img_head_right.setView(entity.getHead_pic(), entity.getReal_name(), positon);
        LUtils.e(NetWorkRequest.IP_ADDRESS + entity.getHead_pic());
        vh_msg_text.rea_msg_text_left.setVisibility(View.GONE);
        vh_msg_text.rea_msg_text_right.setVisibility(View.VISIBLE);
        vh_msg_text.tv_date_right.setText(TimesUtils.getMsgdata(entity.getDate()));
        DataUtil.setHtmlClick(vh_msg_text.tv_text_right, context);
        vh_msg_text.tv_text_right.setText(entity.getMsg_text());

        CharSequence text = vh_msg_text.tv_text_right.getText();
        if (text instanceof Spannable) {
            int end = text.length();
            Spannable sp = (Spannable) text;
            URLSpan urls[] = sp.getSpans(0, end, URLSpan.class);
            SpannableStringBuilder style = new SpannableStringBuilder(text);
            style.clearSpans();
            for (URLSpan urlSpan : urls) {
                MyURLSpan myURLSpan = new MyURLSpan(context, urlSpan.getURL());
                style.setSpan(myURLSpan, sp.getSpanStart(urlSpan),
                            sp.getSpanEnd(urlSpan),
                            Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
            }
            vh_msg_text.tv_text_right.setText(style);
        }
        int under = entity.getUnread_user_num();
        if (isSignChat) {
            vh_msg_text.tv_unread_right.setVisibility(View.GONE);
            LUtils.e(group_id + "--------AAAAAAa------------" + uid);
        } else {
            vh_msg_text.tv_unread_right.setTextColor(context.getResources().getColor(R.color.color_628ae0));
            if (under > 0) {
                vh_msg_text.tv_unread_right.setVisibility(View.VISIBLE);
                vh_msg_text.tv_unread_right.setText(context.getResources().getString(R.string.message_unread, under));
            } else {
                vh_msg_text.tv_unread_right.setVisibility(View.GONE);
            }
        }

        //消息状态 0。成功  1.失败  2.发送中
        if (entity.getMsg_state() == 2) {
            vh_msg_text.spinner.setVisibility(View.VISIBLE);
            vh_msg_text.img_sendfail.setVisibility(View.GONE);
            vh_msg_text.spinner.setBackgroundResource(R.drawable.load_spinner); //将动画资源文件设置为ImageView的背景
            AnimationDrawable anim = (AnimationDrawable) vh_msg_text.spinner.getBackground(); //获取ImageView背景,此时已被编译成AnimationDrawable
            if (!anim.isRunning()) {
                anim.start();  //开始动画
            }
        } else if (entity.getMsg_state() == 0) {
            vh_msg_text.spinner.setVisibility(View.GONE);
            vh_msg_text.img_sendfail.setVisibility(View.GONE);
        } else if (entity.getMsg_state() == 1) {
            vh_msg_text.spinner.setVisibility(View.GONE);
            vh_msg_text.img_sendfail.setVisibility(View.VISIBLE);
        }

    }

    /**
     * 设置通知左边内容
     */
    protected void setNoticeLeft(final ImageHolder vh_img_holder, final MessageEntity entity, final Context context) {
        vh_img_holder.rea_msg_text_left.setVisibility(View.VISIBLE);
        vh_img_holder.rea_msg_text_right.setVisibility(View.GONE);
        if (!TextUtils.isEmpty(entity.getMsg_text())) {
            vh_img_holder.tv_text_left.setText(entity.getMsg_text());
            vh_img_holder.tv_text_left.setVisibility(View.VISIBLE);
        } else {
            vh_img_holder.tv_text_left.setVisibility(View.GONE);
        }

        vh_img_holder.tv_username_left.setText(entity.getUser_name() + "  " + TimesUtils.getMsgdata(entity.getDate()));
        vh_img_holder.img_head_left.setView(entity.getHead_pic(), entity.getReal_name(), 0);
        vh_img_holder.ngl_images_left.setAdapter(mAdapter);
        vh_img_holder.ngl_images_left.setImagesData(entity.getMsg_src());
        vh_img_holder.spinner.setVisibility(View.GONE);
        vh_img_holder.img_sendfail.setVisibility(View.GONE);
    }

    /**
     * 设置通知右边内容
     */
    protected void setNoticeRight(final ImageHolder vh_img_holder, final MessageEntity entity, final Context context) {
        vh_img_holder.img_head_right.setView(entity.getHead_pic(), entity.getReal_name(), 0);
        vh_img_holder.rea_msg_text_left.setVisibility(View.GONE);
        vh_img_holder.rea_msg_text_right.setVisibility(View.VISIBLE);
        vh_img_holder.tv_date_right.setText(TimesUtils.getMsgdata(entity.getDate()));
        int under = entity.getUnread_user_num();
        if (isSignChat) {
            vh_img_holder.tv_unread_right.setVisibility(View.GONE);
        } else {
            vh_img_holder.tv_unread_right.setTextColor(context.getResources().getColor(R.color.color_628ae0));
            if (under > 0) {
                vh_img_holder.tv_unread_right.setVisibility(View.VISIBLE);
                vh_img_holder.tv_unread_right.setText(context.getResources().getString(R.string.message_unread, under));
            } else {
                vh_img_holder.tv_unread_right.setVisibility(View.GONE);
            }
        }
        vh_img_holder.ngl_images_right.setAdapter(mAdapter);
        vh_img_holder.ngl_images_right.setImagesData(entity.getMsg_src());
        if (!TextUtils.isEmpty(entity.getMsg_text())) {
            vh_img_holder.tv_text_right.setText(entity.getMsg_text());
            vh_img_holder.tv_text_right.setVisibility(View.VISIBLE);
        } else {
            vh_img_holder.tv_text_right.setVisibility(View.GONE);
        }

        //消息状态 0。成功  1.失败  2.发送中
        if (entity.getMsg_state() == 2) {
            vh_img_holder.spinner.setVisibility(View.VISIBLE);
            vh_img_holder.img_sendfail.setVisibility(View.GONE);
            vh_img_holder.spinner.setBackgroundResource(R.drawable.load_spinner); //将动画资源文件设置为ImageView的背景
            AnimationDrawable anim = (AnimationDrawable) vh_img_holder.spinner.getBackground(); //获取ImageView背景,此时已被编译成AnimationDrawable
            if (!anim.isRunning()) {
                anim.start();  //开始动画
            }
        } else if (entity.getMsg_state() == 0) {
            vh_img_holder.spinner.setVisibility(View.GONE);
            vh_img_holder.img_sendfail.setVisibility(View.GONE);
        } else if (entity.getMsg_state() == 1) {
            vh_img_holder.spinner.setVisibility(View.GONE);
            vh_img_holder.img_sendfail.setVisibility(View.VISIBLE);
        }

    }


    public class TextHolder {
        //左边
        protected RelativeLayout rea_msg_text_left;
        protected RelativeLayout rea_voice_left;
        protected RoundeImageHashCodeTextLayout img_head_left;
        protected TextView tv_username_left;
        protected TextView tv_text_left;
        //        protected BQMMMessageText tv_text_left_mm;
        protected ImageView voiceAnimationImage_left;
        protected ImageView red_circle;
        protected ImageView img_sendfail;
        protected SWImageView bimg_left;
        public TextView tv_detail_bill;

        //右边
        protected RelativeLayout rea_msg_text_right;
        protected RelativeLayout rea_voice_right;
        protected TextView tv_unread_right;
        protected TextView tv_date_right;
        protected TextView tv_text_right;
        //        protected BQMMMessageText tv_text_right_mm;
        protected ImageView voiceAnimationImage_right;
        protected RoundeImageHashCodeTextLayout img_head_right;
        protected SWImageView bimg_right;
        protected ImageView spinner;
    }

    class MsgOtherHolder {
        //找工作布局
        protected LinearLayout lin_findjob;
        //项目名称
        protected TextView tv_pro_name;
        //点工，包工
        protected TextView tv_type_work;
        //工资标准，规模等
        protected TextView tv_type;
        //数量工钱等
        protected TextView tv_money;
        //分割线
        protected View view_line;

        //找帮手布局
        protected LinearLayout lin_findhelper;
        //找帮手搜索内容
        protected TextView tv_search_hint;
        //头像
        protected RoundeImageHashCodeTextLayout img_head;
        //名字
        protected TextView tv_name;
        //工龄
        protected TextView tv_work_year;
    }

    class ImageHolder {
        //左边
        public RelativeLayout rea_msg_text_left;
        public RelativeLayout rea_bg_left;
        public RoundeImageHashCodeTextLayout img_head_left;
        public TextView tv_username_left;
        public TextView tv_text_left;
        public ImageView img_icon_left;
        public ImageView img_arrow_left;
        public TextView tv_hintcontent_left;
        public TextView tv_title_top_left;
        public NineGridMsgImageView ngl_images_left;

        //右边
        public RelativeLayout rea_msg_text_right;
        public RelativeLayout rea_bg_right;
        public TextView tv_unread_right;
        public TextView tv_date_right;
        public TextView tv_text_right;
        public ImageView img_icon_right;
        public TextView tv_title_top_right;
        public NineGridMsgImageView ngl_images_right;
        public ImageView spinner;
        public ImageView img_sendfail;
        public RoundeImageHashCodeTextLayout img_head_right;
        public ImageView img_arrow_right;
        public TextView tv_hintcontent_right;

    }

    /**
     * 长按集合内容
     *
     * @param entity
     * @return
     */
    public List<String> getListStr(MessageEntity entity, Context context) {
        List<String> list = null;
        //所有的长按事件
        if (entity.getMsg_id() == 0) {
            list = Arrays.asList(context.getResources().getStringArray(R.array.messageLongClickSending));
            return list;
        }
        if (entity.getMsg_type().equals(MessageType.MSG_TEXT_STRING)) {
            //根据不同情况显示不同的内容  true，已经发送成功的消息 ，false 1发送失败的
            if (entity.getMsg_state() == 1) {
                list = Arrays.asList(context.getResources().getStringArray(R.array.messageLongClickFail));
            } else {
                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
                    list = new ArrayList<>();
                    list.add("复制");
                } else {
                    list = Arrays.asList(context.getResources().getStringArray(R.array.messageLongClickSucces));
                }

            }

        } else if (entity.getMsg_type().equals(MessageType.MSG_VOICE_STRING) || entity.getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
            //根据不同情况显示不同的内容  true，已经发送成功的消息 ，false 1发送失败的
            if (entity.getMsg_state() == 1) {
                list = new ArrayList<>();
                list.add("重发");
                list.add("删除");
            } else {
                if (!TextUtils.isEmpty(entity.getLocal_id()) && !entity.getLocal_id().equals("null")) {
                    list = new ArrayList<>();
                    list.add("撤回");
                }
            }

        } else {
            //根据不同情况显示不同的内容  true，已经发送成功的消息 ，false 1发送失败的
            if (entity.getMsg_state() == 1) {
                list = new ArrayList<>();
                list.add("重发");
                list.add("删除");
            }

        }

        if (null == list || list.size() == 0) {
            list = new ArrayList<>();
        }
        return list;
    }

    /**
     * 更新消息为已读
     */
    protected void updateReadInfo(String msgId) {
//        WebSocket webSocket = SocketManager.getInstance().getWebSocket();
//        if webSocket!= null) {
//            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
//            msgParmeter.setAction(WebSocketConstance.MSGREAD);
//            msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
//            msgParmeter.setMsg_id(msgId);
//            webSocket.requestServerMessage(msgParmeter);
//        }
    }

    /**
     * 左边图片形状
     *
     * @param bubbleParams
     */
    public void initRightParam(BubbleParams bubbleParams) {
        bubbleParams.bubble_top_right = R.drawable.right_bubble_top_right;
        bubbleParams.bubble_top_left = R.drawable.right_bubble_top_left;
        bubbleParams.bubble_bottom_left = R.drawable.right_bubble_bottom_left;
        bubbleParams.bubble_bottom_right = R.drawable.right_bubble_bottom_right;
        bubbleParams.bubble_left = R.drawable.right_bubble_left;
        bubbleParams.bubble_right = R.drawable.right_bubble_right;
        bubbleParams.bubble_top = R.drawable.right_bubble_topbottom;
        bubbleParams.bubble_bottom = R.drawable.right_bubble_topbottom;

        bubbleParams.border_top_left = R.drawable.right_border_top_left;
        bubbleParams.border_top_right = R.drawable.right_border_top_right;
        bubbleParams.border_bottom_left = R.drawable.right_border_bottom_left;
        bubbleParams.border_bottom_right = R.drawable.right_border_bottom_right;
        bubbleParams.border_left = R.drawable.right_border_left;
        bubbleParams.border_right = R.drawable.right_border_right;
        bubbleParams.border_top = R.drawable.right_border_topbottom;
        bubbleParams.border_bottom = R.drawable.right_border_topbottom;
    }

    /**
     * 查看个人资料
     */
    public void toUserInfo(View view, final String uid, final Context context) {
        if (TextUtils.isEmpty(uid)) {
            return;
        }
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, ChatUserInfoActivity.class);
                intent.putExtra(Constance.UID, uid);
                ((BaseActivity) context).startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
            }
        });
    }

    /**
     * 查看已读未读列表
     *
     * @param entity
     */
    private void startToReadInfoActivity(MessageEntity entity, Context context) {
        if (entity.getUnread_user_num() != 0) {
            Intent intent = new Intent(context, MessageReadInfoListActivity.class);
            intent.putExtra("group_id", entity.getGroup_id());
            intent.putExtra("msg_id", entity.getMsg_id() + "");
            intent.putExtra("class_type", entity.getClass_type());
            context.startActivity(intent);
        }

    }

    private NineGridImageViewAdapter<String> mAdapter = new NineGridImageViewAdapter<String>() {
        @Override
        public void onDisplayImage(Context context, ImageView imageView, String s) {
//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + s).asBitmap().into(imageView);

        }


        @Override
        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
            showImageView(list, index + 1, context);
        }
    };

    public void picBrrow(Context context, List<String> list, int index, ImageView imageView) {
        //imagesize是作为loading时的图片size
        MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
        MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
    }

    /**
     * 设置通知质量等背景
     *
     * @param type
     * @param entity
     * @param vh_img_holder
     * @param context
     */
    public void setNoticeBg(int type, MessageEntity entity, ImageHolder vh_img_holder, Context context) {
//        switch (type) {
//            case MessageType.MSG_SAFE_STRING:
//                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
////                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.selector_messge_safety_left));
//                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.meassge_safety_left_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_left, context.getResources().getDrawable(R.drawable.icon_safety));
//                    vh_img_holder.tv_title_top_left.setText(context.getResources().getString(R.string.messsage_safety));
//                    vh_img_holder.tv_title_top_left.setTextColor(context.getResources().getColor(R.color.color_864bc1));
//                    Utils.setBackGround(vh_img_holder.img_arrow_left, context.getResources().getDrawable(R.drawable.arrow_right_safe));
//                    vh_img_holder.tv_hintcontent_left.setTextColor(context.getResources().getColor(R.color.color_a779d5));
//
//
//                } else {
////                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.selector_messge_safety_right));
//                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.meassge_safety_right_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_right, context.getResources().getDrawable(R.drawable.icon_safety));
//                    vh_img_holder.tv_title_top_right.setText(context.getResources().getString(R.string.messsage_safety));
//                    vh_img_holder.tv_title_top_right.setTextColor(context.getResources().getColor(R.color.color_864bc1));
//                    Utils.setBackGround(vh_img_holder.img_arrow_right, context.getResources().getDrawable(R.drawable.arrow_right_safe));
//                    vh_img_holder.tv_hintcontent_right.setTextColor(context.getResources().getColor(R.color.color_a779d5));
//                }
//                break;
//
//            case MessageType.MSG_QUALITY_STRING:
//                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
////                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.selector_messge_quality_left));
//                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.message_quality_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_left, context.getResources().getDrawable(R.drawable.icon_quality));
//                    vh_img_holder.tv_title_top_left.setText(context.getResources().getString(R.string.messsage_quality));
//                    vh_img_holder.tv_title_top_left.setTextColor(context.getResources().getColor(R.color.color_72b8c4));
//                    Utils.setBackGround(vh_img_holder.img_arrow_left, context.getResources().getDrawable(R.drawable.arrow_right_quality));
//                    vh_img_holder.tv_hintcontent_left.setTextColor(context.getResources().getColor(R.color.color_74bed1));
//                } else {
////                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.selector_messge_quality_right));
//                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.message_quality_right_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_right, context.getResources().getDrawable(R.drawable.icon_quality));
//                    vh_img_holder.tv_title_top_right.setText(context.getResources().getString(R.string.messsage_quality));
//                    vh_img_holder.tv_title_top_right.setTextColor(context.getResources().getColor(R.color.color_72b8c4));
//                    Utils.setBackGround(vh_img_holder.img_arrow_right, context.getResources().getDrawable(R.drawable.arrow_right_quality));
//                    vh_img_holder.tv_hintcontent_right.setTextColor(context.getResources().getColor(R.color.color_74bed1));
//                }
//
//                break;
//            case MessageType.MSG_NOTICE_STRING:
//                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
////                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.selector_messge_inform_left));
//                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.meassge_inform_left_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_left, context.getResources().getDrawable(R.drawable.icon_forme));
//                    vh_img_holder.tv_title_top_left.setText(context.getResources().getString(R.string.messsage_work_inform));
//                    vh_img_holder.tv_title_top_left.setTextColor(context.getResources().getColor(R.color.color_4b70c1));
//                    Utils.setBackGround(vh_img_holder.img_arrow_left, context.getResources().getDrawable(R.drawable.arrow_right_notice));
//                    vh_img_holder.tv_hintcontent_left.setTextColor(context.getResources().getColor(R.color.color_628ae0));
//
//                } else {
////                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.selector_messge_inform_right));
//                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.meassge_inform_right_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_right, context.getResources().getDrawable(R.drawable.icon_forme));
//                    vh_img_holder.tv_title_top_right.setText(context.getResources().getString(R.string.messsage_work_inform));
//                    vh_img_holder.tv_title_top_right.setTextColor(context.getResources().getColor(R.color.color_4b70c1));
//                    Utils.setBackGround(vh_img_holder.img_arrow_right, context.getResources().getDrawable(R.drawable.arrow_right_notice));
//                    vh_img_holder.tv_hintcontent_right.setTextColor(context.getResources().getColor(R.color.color_628ae0));
//                }
//                break;
//            case MessageType.MSG_LOG_STRING:
//                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
////                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.selector_messge_log_left));
//                    Utils.setBackGround(vh_img_holder.rea_bg_left, context.getResources().getDrawable(R.drawable.meassge_log_left_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_left, context.getResources().getDrawable(R.drawable.icon_logs));
//                    vh_img_holder.tv_title_top_left.setText(context.getResources().getString(R.string.messsage_work_log));
//                    vh_img_holder.tv_title_top_left.setTextColor(context.getResources().getColor(R.color.color_5da659));
//                    Utils.setBackGround(vh_img_holder.img_arrow_left, context.getResources().getDrawable(R.drawable.arrow_right_log));
//                    vh_img_holder.tv_hintcontent_left.setTextColor(context.getResources().getColor(R.color.color_85bf82));
//
//                } else {
////                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.selector_messge_log_right));
//                    Utils.setBackGround(vh_img_holder.rea_bg_right, context.getResources().getDrawable(R.drawable.meassge_log_right_bg_normal));
//                    Utils.setBackGround(vh_img_holder.img_icon_right, context.getResources().getDrawable(R.drawable.icon_logs));
//                    vh_img_holder.tv_title_top_right.setText(context.getResources().getString(R.string.messsage_work_log));
//                    vh_img_holder.tv_title_top_right.setTextColor(context.getResources().getColor(R.color.color_5da659));
//                    Utils.setBackGround(vh_img_holder.img_arrow_right, context.getResources().getDrawable(R.drawable.arrow_right_log));
//                    vh_img_holder.tv_hintcontent_right.setTextColor(context.getResources().getColor(R.color.color_85bf82));
//                }
//                break;
//        }

    }
}
