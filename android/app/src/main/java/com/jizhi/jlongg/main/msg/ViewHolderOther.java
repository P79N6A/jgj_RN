package com.jizhi.jlongg.main.msg;

import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.QuickJoinGroupChatActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;

public class ViewHolderOther extends MessageRecycleViewHolder {


    public ViewHolderOther(View itemView) {
        super(itemView);
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(final MessageBean message) {
        String date = message.getSend_time() == 0 ? "" : Utils.simpleForDate(message.getSend_time());
        ((TextView) itemView.findViewById(R.id.message_content)).setText("当前版本暂不支持查看此消息，请升级为最新版本查看。");
        ((TextView) itemView.findViewById(R.id.message_type_and_date)).setText("活动消息 " + date);
        ((ImageView) itemView.findViewById(R.id.message_type_icon)).setImageResource(R.drawable.activity_message_chat_state);


    }
}
