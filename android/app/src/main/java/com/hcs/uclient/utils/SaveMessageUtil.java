package com.hcs.uclient.utils;

import android.app.Activity;

public class SaveMessageUtil {
    private Activity activity;

    /**
     * 处理消息的方法是否在执行
     */
//    public static boolean isRunning;
//    private List<MessageInfo> offlineListBean;
//    private List<MessageBean> beanList;
    public SaveMessageUtil(Activity activity) {
        this.activity = activity;
//        offlineListBean = new ArrayList<>();

    }

//    public boolean isRunning() {
//        return isRunning;
//    }

//    /**
//     * 离线消息
//     */
//    public void getMessageList() {
//        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
//        CommonHttpRequest.commonRequest(activity, NetWorkRequest.GET_OFFLINE_MESSAGE_LIST, MessageBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
//            @Override
//            public void onSuccess(final Object object) {
//                List<MessageBean> beanList = (List<MessageBean>) object;
//                if (null != beanList && beanList.size() > 0) {
////                        filterMessage(beanList);
////                    MessageAsyncTask task = new MessageAsyncTask();
////                    task.setBeanList(beanList);
////                    task.execute(beanList);
//                    ThreadPoolManager.getInstance().executeReceiveMessage(beanList);
//                } else {
//                    LUtils.e("--没有处理完把消息丢弃---EEEE-----" + beanList.size());
//                }
//
//            }
//
//            @Override
//            public void onFailure(HttpException error, String msg) {
//            }
//        });
//    }


//    public void filterMessage(List<MessageBean> list) {
//        this.beanList = list;
//        isRunning = true;
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
//            DBMsgUtil.getInstance().saveListMessage(beanList);
//            Intent intent = new Intent(WebSocketConstance.SHOW_GROUP_MESSAGE);
//            Bundle bundle = new Bundle();
//            bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) offlineListBean);
//            intent.putExtras(bundle);
//            LocalBroadcastManager.getInstance(activity).sendBroadcast(intent);
////            MessageUtils.getCallBackOperationMessage(callVBackJson, WebSocketConstance.RECEIVED);
//        }
//        isRunning = false;
//
//
//    }
//
//    Thread thread = new Thread(new Runnable() {
//        @Override
//        public void run() {
//
//        }
//    });
}
