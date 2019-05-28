package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddFriendSendCodectivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogAuthType;
import com.jizhi.jlongg.main.dialog.DialogVerified;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:人脉推荐适配器
 * 时间:2018年1月18日10:06:38
 * 作者:xuj
 */
public class VeinRecommendationAdapter extends BaseAdapter {
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 列表数据
     */
    private List<UserInfo> list;
    /**
     * 当前点击
     */
    private int clickItem = -1;
    /**
     * 是否还有更多数据
     */
    private boolean isMoreData = true;
    /**
     * 当前登录人已实例名认证
     */
    private boolean isVerified;

    public VeinRecommendationAdapter(Activity context, List<UserInfo> list) {
        this.list = list;
        this.activity = context;
        inflater = LayoutInflater.from(context);
    }


    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public UserInfo getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup arg2) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.vein_recommendation_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(position, convertView, holder);
        return convertView;
    }

    private void bindData(final int position, View convertView, ViewHolder holder) {
        final UserInfo bean = getItem(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.realName.setText(bean.getReal_name());
        if (TextUtils.isEmpty(bean.getSignature())) {
            holder.signature.setText(bean.getComment());
            holder.comment.setVisibility(View.INVISIBLE);
        } else {
            holder.comment.setText(bean.getComment());
            holder.signature.setText(bean.getSignature());
            holder.comment.setVisibility(View.VISIBLE);
        }
        if (bean.isSendAddFriend()) {
            holder.addIconText.setText("已发送");
            holder.addIcon.setVisibility(View.GONE);
        } else {
            holder.addIconText.setText("好友");
            holder.addIcon.setVisibility(View.VISIBLE);
        }
        //已实名 需要显示
        holder.verifiedImage.setVisibility(bean.getVerified() == 3 ? View.VISIBLE : View.GONE);
        //已认证
        holder.authTypeImage.setVisibility(bean.getAuth_type() == 2 || bean.getAuth_type() == 1 ? View.VISIBLE : View.GONE);

        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.addFriend: //添加好友
                        if (bean.isSendAddFriend()) { //如果是已发送状态则按钮不能点击
                            return;
                        }
                        clickItem = position;
                        AddFriendSendCodectivity.actionStart(activity, bean.getUid());
                        break;
                    case R.id.rootView: //用户头像
                        ChatUserInfoActivity.actionStart(activity, bean.getUid());
                        break;
                    case R.id.verified_image://已实名
                        new DialogVerified(activity, isVerified).show();
                        break;
                    case R.id.auth_type_image://已认证
                        new DialogAuthType(activity, bean.getAuth_type()).show();
                        break;
                }
            }
        };
        convertView.setOnClickListener(onClickListener);
        holder.addFriend.setOnClickListener(onClickListener);
        holder.authTypeImage.setOnClickListener(onClickListener);
        holder.verifiedImage.setOnClickListener(onClickListener);
        holder.scrollFootLayout.setVisibility(position == getCount() - 1 && !isMoreData ? View.VISIBLE : View.GONE);
        holder.itemDiver.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
            realName = (TextView) convertView.findViewById(R.id.realName);
            comment = (TextView) convertView.findViewById(R.id.comment);
            telephone = (TextView) convertView.findViewById(R.id.telephone);
            signature = (TextView) convertView.findViewById(R.id.signature);
            addFriend = convertView.findViewById(R.id.addFriend);
            addIcon = convertView.findViewById(R.id.addIcon);
            addIconText = (TextView) convertView.findViewById(R.id.addIconText);
            scrollFootLayout = convertView.findViewById(R.id.scrollFootLayout);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            verifiedImage = convertView.findViewById(R.id.verified_image);
            authTypeImage = convertView.findViewById(R.id.auth_type_image);
        }

        /**
         * 推荐者头像
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
        /**
         * 推荐者名称
         */
        TextView realName;
        /**
         * 推荐者电话
         */
        TextView telephone;
        /**
         * 签名信息
         */
        TextView signature;
        /**
         * 当有个性签名时 需要将内容显示在名称后面
         */
        TextView comment;
        /**
         * 添加好友
         */
        View addFriend;
        /**
         * 添加好友左边的加号按钮
         */
        View addIcon;
        /**
         * 添加好友文本
         */
        TextView addIconText;
        /**
         * 如果ListView滚动到底部需要显示的布局
         */
        View scrollFootLayout;
        /**
         * 底部分割线
         */
        View itemDiver;
        /**
         * 已实名图标
         */
        ImageView verifiedImage;
        /**
         * 已认证图标
         */
        ImageView authTypeImage;
    }

    public void updateList(List<UserInfo> list) {
        this.list = list;
    }

    public void addList(List<UserInfo> list) {
        this.list.addAll(list);
    }

    public List<UserInfo> getList() {
        return list;
    }

    public void setList(List<UserInfo> list) {
        this.list = list;
    }

    public int getClickItem() {
        return clickItem;
    }

    public void setClickItem(int clickItem) {
        this.clickItem = clickItem;
    }

    public boolean isMoreData() {
        return isMoreData;
    }

    public void setMoreData(boolean moreData) {
        isMoreData = moreData;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }
}
