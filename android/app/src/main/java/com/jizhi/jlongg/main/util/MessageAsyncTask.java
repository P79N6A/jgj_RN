//package com.jizhi.jlongg.main.util;
//
//import android.content.Intent;
//import android.os.AsyncTask;
//import android.os.Bundle;
//import android.support.v4.content.LocalBroadcastManager;
//import android.text.TextUtils;
//
//import com.google.gson.Gson;
//import com.hcs.uclient.utils.LUtils;
//import com.jizhi.jlongg.main.application.UclientApplication;
//import com.jizhi.jlongg.main.bean.MessageBean;
//import com.jizhi.jlongg.main.bean.MessageInfo;
//import com.jizhi.jlongg.main.message.MessageUtils;
//
//import org.litepal.LitePal;
//
//import java.io.Serializable;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//
//public class MessageAsyncTask extends AsyncTask<List<MessageBean>, Integer, String> {
//    /**
//     * 处理消息的方法是否在执行
//     */
//    public static boolean isRunning;
//    private List<MessageInfo> offlineListBean;
//    private List<MessageBean> beanList;
//
//    public List<MessageBean> getBeanList() {
//        return beanList;
//    }
//
//    public void setBeanList(List<MessageBean> beanList) {
//        this.beanList = beanList;
//    }
//
//    @Override
//    protected void onPreExecute() {
//        // 任务启动，可以在这里显示一个对话框，这里简单处理
//        isRunning = true;
//        if (null == offlineListBean) {
//            offlineListBean = new ArrayList<>();
//        }
//        LUtils.e("---------处理消息开始--------EEEE------" + isRunning);
//    }
//
//    //onPostExecute方法用于在执行完后台任务后更新UI,显示结果
//    @Override
//    protected void onPostExecute(String result) {
//        isRunning = false;
//        LUtils.e("--------处理消息结束--------EEEE---------" + isRunning);
//
//
//    }
//
//    @Override
//    protected String doInBackground(List<MessageBean>... lists) {
//        isRunning = true;
//
//        LUtils.e(beanList.size() + "------------处理消息中---------EEEE--------");
//
//        if (null == beanList || beanList.size() == 0) {
//            return "";
//        }
//        if (offlineListBean.size() > 0) {
//            offlineListBean.clear();
//        }
//        HashMap<String, MessageBean> hashMap = new HashMap<>();
//        for (int i = 0; i < beanList.size(); i++) {
//            beanList.get(i).setMessage_uid(UclientApplication.getUid());
//            beanList.get(i).setUser_info_json(new Gson().toJson(beanList.get(i).getUser_info()));
//            String key = beanList.get(i).getClass_type() + "and" + beanList.get(i).getGroup_id();
//            if (!hashMap.containsKey(key) || beanList.get(i).getMsg_id() > hashMap.get(key).getMsg_id()) {
//                hashMap.put(key, beanList.get(i));
//            }
//        }
//        for (String key : hashMap.keySet()) {
//            MessageBean bean = hashMap.get(key);
//            MessageInfo offBean = new MessageInfo();
//            offBean.setMsg_id(String.valueOf(bean.getMsg_id()));
//            offBean.setClass_type(bean.getClass_type());
//            offBean.setGroup_id(bean.getGroup_id());
//            offlineListBean.add(offBean);
//        }
//        String callVBackJson = new Gson().toJson(offlineListBean);
//        if (!TextUtils.isEmpty(callVBackJson) && offlineListBean.size() > 0) {
//            LitePal.saveAll(beanList);
//            Intent intent = new Intent(WebSocketConstance.SHOW_GROUP_MESSAGE);
//            Bundle bundle = new Bundle();
//            bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) offlineListBean);
//            intent.putExtras(bundle);
//            LocalBroadcastManager.getInstance(UclientApplication.getContext()).sendBroadcast(intent);
//            MessageUtils.getCallBackOperationMessage(callVBackJson, WebSocketConstance.RECEIVED);
//        }
//        isRunning = false;
//        return null;
//    }
//
//
//    @Override
//    protected void onProgressUpdate(Integer... progresses) {
//    }
//
//
//}
