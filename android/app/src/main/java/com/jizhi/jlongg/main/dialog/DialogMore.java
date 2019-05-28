package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.AccountModefyRecycleViewHolder;
import com.jizhi.jlongg.main.adpter.AccountModifyAdapter;
import com.jizhi.jlongg.main.adpter.ViewHolderAccountModifyAdd;
import com.jizhi.jlongg.main.adpter.ViewHolderAccountModifyBorrow;
import com.jizhi.jlongg.main.adpter.ViewHolderAccountModifyHour;
import com.jizhi.jlongg.main.bean.AccountModifyBean;
import com.jizhi.jlongg.main.bean.DialogMoreBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LogModeBean;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class DialogMore extends PopupWindowExpand implements View.OnClickListener {
    private Activity activity;
    private ListView listView;
    private List<DialogMoreBean> list;
    //接触绑定微信服务
    public static final int UNBIND = 0X01;
    //我的个人资料
    public static final int MYINFO = 0X02;
    private DialogMoreInterFace dialogMoreInterFace;


    public DialogMore(Activity activity, List<DialogMoreBean> list, DialogMoreInterFace dialogMoreInterFace) {
        super(activity);
        this.activity = activity;
        this.dialogMoreInterFace=dialogMoreInterFace;
        this.list = list;
        setPopView();
        updateContent();
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_more, null);
        setContentView(popView);
        listView = popView.findViewById(R.id.listView);
        listView.setAdapter(new DialogMoreAdapter(activity));
        setPopParameter();
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (list.get(position).getType()==UNBIND){
                    dialogMoreInterFace.delete();
                    dismiss();
                }else  if (list.get(position).getType()==MYINFO){
                    dialogMoreInterFace.success();
                    dismiss();
                }

            }
        });
    }

    public void updateContent() {
        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_cancel: //取消
                dismiss();
                break;
        }
        dismiss();
    }


    public interface DialogMoreInterFace {
        void delete();
        void success();
    }

    public class DialogMoreAdapter extends BaseAdapter {
        private LayoutInflater mInflater;

        public DialogMoreAdapter(Activity activity) {
            mInflater = LayoutInflater.from(activity);
        }


        @Override
        public int getCount() {
            return list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            convertView = mInflater.inflate(R.layout.item_dialog_more, null);
            ((TextView) convertView.findViewById(R.id.tv_content)).setText(list.get(position).getContext());

            return convertView;
        }
    }

    public static List<DialogMoreBean> getDeleteBean() {
        List<DialogMoreBean> dialogMoreBeans = new ArrayList<>();
        dialogMoreBeans.add(new DialogMoreBean(UNBIND, "解除绑定"));
        return dialogMoreBeans;
    }
    public static List<DialogMoreBean> getUserInfoBean() {
        List<DialogMoreBean> dialogMoreBeans = new ArrayList<>();
        dialogMoreBeans.add(new DialogMoreBean(MYINFO, "我的个人资料"));
        return dialogMoreBeans;
    }
}
