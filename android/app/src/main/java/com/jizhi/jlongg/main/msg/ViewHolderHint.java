package com.jizhi.jlongg.main.msg;

import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;

import java.util.List;
/**
 * 提示信息
 */
public class ViewHolderHint extends MessageRecycleViewHolder {


    public ViewHolderHint(View itemView) {
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
    public void setItemData(MessageBean message) {
        if (!TextUtils.isEmpty(message.getMsg_text())) {
            if (message.getMsg_type().equals(MessageType.MSG_RECALL_STRING) || message.getMsg_type().equals(MessageType.MSG_SIGNIN_STRING)) {
                //处理撤回显示的内容
                if (!NewMessageUtils.isMySendMessage(message)) {
                    ((TextView) itemView.findViewById(R.id.tv_text)).setText(message.getUser_info().getReal_name() + message.getMsg_text());
                } else {
                    ((TextView) itemView.findViewById(R.id.tv_text)).setText("你" + message.getMsg_text());
                }
            } else {
                ((TextView) itemView.findViewById(R.id.tv_text)).setText(message.getMsg_text());

            }


            itemView.findViewById(R.id.rea_center).setVisibility(View.VISIBLE);
        } else {
            itemView.findViewById(R.id.rea_center).setVisibility(View.GONE);
        }
    }
}
