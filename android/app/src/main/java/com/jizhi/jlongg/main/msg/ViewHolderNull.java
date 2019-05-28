package com.jizhi.jlongg.main.msg;

import android.view.View;

import com.jizhi.jlongg.main.bean.MessageBean;

import java.util.List;

public class ViewHolderNull extends MessageRecycleViewHolder {


    public ViewHolderNull(View itemView) {
        super(itemView);
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
    }

}
