package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.View;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.adpter.GridViewHorztalShowHeadAdater;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.liaoinstan.springview.utils.DensityUtil;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.ArrayList;

/**
 * 功能:消息转发 弹出框
 * 时间:2019年3月26日16:01:41
 * 作者:xuj
 */
public class ForwardMessageDialog extends Dialog implements View.OnClickListener {


    /**
     * 留言输入框
     */
    private EditText wordsEdit;
    /**
     * 获取留言回调输入框
     */
    private ForwardMessageListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(true);
    }

    /**
     * @param context
     * @param forwardMessageType 转发的消息类型
     * @param mForwardName       被转发者名称
     * @param mForwardPicPath    被转发者头像
     * @param mForwardContent    转发的内容  如果是图片则直接是图片的路径，如果是文本则直接是文本内容，如果是链接则是链接的内容
     * @param isSingleChAT       true表示单聊头像
     * @param isForwadItemInfo   true表示转发列表的图片
     * @param listener           点击确定后的回调
     */
    public ForwardMessageDialog(Context context, String forwardMessageType, String mForwardName,
                                ArrayList<String> mForwardPicPath, String mForwardContent, boolean isSingleChAT, boolean isForwadItemInfo, ForwardMessageListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        setContentView(R.layout.dialog_forward_message);
        initView(forwardMessageType, mForwardContent, isForwadItemInfo);
        initSingleForwardView(mForwardPicPath, mForwardName, isSingleChAT);
        commendAttribute(false);
    }

    /**
     * @param context
     * @param forwardMessageType 转发的消息类型
     * @param list               头像信息
     * @param mForwardContent    转发的内容  如果是图片则直接是图片的路径，如果是文本则直接是文本内容，如果是链接则是链接的内容
     * @param isForwadItemInfo   true表示转发列表的图片
     * @param listener           点击确定后的回调
     */
    public ForwardMessageDialog(Context context, String forwardMessageType, ArrayList<GroupDiscussionInfo> list,
                                String mForwardContent, boolean isForwadItemInfo, ForwardMessageListener listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        setContentView(R.layout.dialog_forward_message);
        initView(forwardMessageType, mForwardContent, isForwadItemInfo);
        initMultipartForwardView(list);
        commendAttribute(false);
    }

    private void initView(String forwardMessageType, String mForwardContent, boolean isForwadItemInfo) {
        wordsEdit = (EditText) findViewById(R.id.words_edit);
        TextView forwardContent = findViewById(R.id.forward_text);
        ImageView forwardThumbnail = findViewById(R.id.forward_thumbnail);
        switch (forwardMessageType) {
            case MessageType.MSG_TEXT_STRING: //文本
                forwardContent.setText(mForwardContent);
                forwardContent.setVisibility(View.VISIBLE);
                forwardThumbnail.setVisibility(View.GONE);
                break;
            case MessageType.MSG_PIC_STRING: //图片消息
                forwardContent.setVisibility(View.GONE);
                forwardThumbnail.setVisibility(View.VISIBLE);
                if (isForwadItemInfo) { //加载本地图片路径
                    ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + mForwardContent, forwardThumbnail, UtilImageLoader.getAdvertiseOptions(getContext()));
                } else {//加载分享的图片路径
                    ImageLoader.getInstance().displayImage("file://" + mForwardContent, forwardThumbnail, UtilImageLoader.getLocalPicOptions());
                }
                break;
            case MessageType.MSG_POSTCARD_STRING: //名片
                forwardContent.setText("[找活名片]" + mForwardContent);
                forwardContent.setVisibility(View.VISIBLE);
                forwardThumbnail.setVisibility(View.GONE);
                break;
            case MessageType.MSG_LINK_STRING: //链接地址
                forwardContent.setText("[链接]" + mForwardContent);
                forwardContent.setVisibility(View.VISIBLE);
                forwardThumbnail.setVisibility(View.GONE);
                break;
        }
        //转发消息弹框 留言输入框应该要显示3行内容
        int textHeight = getTextHeight(wordsEdit.getHint().toString());
        wordsEdit.setMaxHeight(textHeight * 3 + DensityUtil.dp2px(15));
    }

    public int getTextHeight(String str) {//计算文字宽度
        Paint paint = new Paint();
        paint.setTextSize(wordsEdit.getTextSize());
        Rect rect = new Rect();
        paint.getTextBounds(str, 0, str.length(), rect);
        return rect.height();
    }


    /**
     * 初始化批量发送设置头像
     */
    public void initMultipartForwardView(ArrayList<GroupDiscussionInfo> list) {
        findViewById(R.id.leftBtn).setOnClickListener(this);
        TextView rightBtn = findViewById(R.id.rightBtn);
        rightBtn.setText("发送(" + (list != null && !list.isEmpty() ? list.size() : 0) + ")");
        rightBtn.setOnClickListener(this);
        TextView forwardTips = findViewById(R.id.forward_tips);
        GridView memberHeadGridView = findViewById(R.id.multipart_member_head_gridview);
        memberHeadGridView.setVisibility(View.VISIBLE);
        findViewById(R.id.single_forward_layout).setVisibility(View.GONE);
        forwardTips.setText("分别发送给:");
        memberHeadGridView.setAdapter(new GridViewHorztalShowHeadAdater(getContext(), list));
    }

    /**
     * 初始化单条发送设置头像
     */
    public void initSingleForwardView(ArrayList<String> mForwardPicPath, String mForwardName, boolean isSingleChat) {
        findViewById(R.id.leftBtn).setOnClickListener(this);
        TextView rightBtn = findViewById(R.id.rightBtn);
        rightBtn.setText("发送");
        rightBtn.setOnClickListener(this);
        findViewById(R.id.multipart_member_head_gridview).setVisibility(View.GONE);
        findViewById(R.id.single_forward_layout).setVisibility(View.VISIBLE);
        NineGroupChatGridImageView groupChatGridImageView = findViewById(R.id.team_heads);
        RoundeImageHashCodeTextLayout forwardIcon = findViewById(R.id.forward_icon);
        if (isSingleChat) { //单聊
            groupChatGridImageView.setVisibility(View.GONE);
            forwardIcon.setVisibility(View.VISIBLE);
            //设置被转发者头像
            forwardIcon.setView(mForwardPicPath != null && mForwardPicPath.size() > 0 ? mForwardPicPath.get(0) : "", mForwardName, 0);
        } else { //群聊
            groupChatGridImageView.setVisibility(View.VISIBLE);
            forwardIcon.setVisibility(View.GONE);
            groupChatGridImageView.setImagesData(mForwardPicPath);
        }
        TextView forwardTips = findViewById(R.id.forward_tips);
        TextView forwardName = findViewById(R.id.forward_name);
        forwardTips.setText("发送给:");
        //设置被转发者名称
        forwardName.setText(mForwardName);


    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rightBtn://确认按钮
                dismiss();
                if (listener != null) {
                    listener.sendMsg(wordsEdit.getText().toString());
                }
                break;
            case R.id.leftBtn: //取消按钮
                dismiss();
                break;
        }
    }

    public interface ForwardMessageListener {
        //获取留言信息
        public void sendMsg(String workds);
    }
}
