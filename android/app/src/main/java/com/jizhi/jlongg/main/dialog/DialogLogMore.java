package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
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

import java.util.List;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class DialogLogMore extends PopupWindowExpand implements View.OnClickListener, DiaLogTitleListener {
    private Activity activity;
    private CustomProgress customProgress;
    private String msg_id, msg_type, pu_inpsid, id_name;
    private MessageEntity messageEntity;
    private GroupDiscussionInfo gnInfo;
    private String desc;
    private DialogTips closeDialog;
    private List<LogModeBean> element_list;
    private List<String> msg_src;
    private UpdateLogInterFace updateLogInterFace;


    public DialogLogMore(Activity activity, String desc, String msg_id, String msg_type,UpdateLogInterFace updateLogInterFace) {
        super(activity);
        this.activity = activity;
        this.desc = desc;
        this.msg_id = msg_id;
        this.msg_type = msg_type;
        this.updateLogInterFace = updateLogInterFace;
        setPopView();
        updateContent();

        LUtils.e("--------------------:" + msg_id + ",,," + msg_type);
    }

    public String getId_name() {
        return id_name;
    }

    public void setId_name(String id_name) {
        this.id_name = id_name;
    }

    public void goneEdit() {
        popView.findViewById(R.id.tv_edit).setVisibility(View.GONE);
        popView.findViewById(R.id.view).setVisibility(View.GONE);
    }

    public List<LogModeBean> getElement_list() {
        return element_list;
    }

    public void setElement_list(List<LogModeBean> element_list) {
        this.element_list = element_list;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public void setMsgData(MessageEntity messageEntity, GroupDiscussionInfo gnInfo) {
        this.messageEntity = messageEntity;
        this.gnInfo = gnInfo;
    }

    public void setPu_inpsid(String pu_inpsid) {
        this.pu_inpsid = pu_inpsid;
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.dialog_log_more, null);
        setContentView(popView);
        setPopParameter();
    }

    public void updateContent() {
        popView.findViewById(R.id.tv_edit).setOnClickListener(this);
        popView.findViewById(R.id.tv_del).setOnClickListener(this);
        popView.findViewById(R.id.tv_cancel).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_edit: //编辑
//                UpdateCustomLogActivity.actionStart(activity, gnInfo, msg_id, element_list, msg_src);
                if(null !=updateLogInterFace){
                    updateLogInterFace.updateLog();
                }

                break;
            case R.id.tv_del: //删除
                if (closeDialog == null) {
                    closeDialog = new DialogTips((BaseActivity) activity, this, desc, DialogTips.CLOSE_TEAM);
                }
                closeDialog.show();
                break;
        }
        dismiss();
    }

    /**
     * 删除质量安全
     */
    protected void delquelityAndSafe() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("msg_id", msg_id);
        params.addBodyParameter("msg_type", msg_type);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELQUALITYANDSAFE,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                                if (bean.getState() != 0) {
                                    activity.setResult(Constance.RESULTCODE_FINISH, activity.getIntent());
                                    activity.finish();
                                } else {
                                    DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                if (null != customProgress) {
                                    customProgress.dismiss();
                                }
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            if (null != customProgress) {
                                customProgress.dismiss();
                            }
                        }
                    });
    }

    /**
     * 删除检查计划
     */
    protected void delInspectQualityList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("pu_inpsid", msg_id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_INSPECRQUALITYLIST,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                                if (bean.getState() != 0) {
                                    activity.setResult(Constance.RESULTCODE_FINISH, activity.getIntent());
                                    activity.finish();
                                } else {
                                    DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                if (null != customProgress) {
                                    customProgress.dismiss();
                                }
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            if (null != customProgress) {
                                customProgress.dismiss();
                            }
                        }
                    });
    }

    /**
     * 删除质量
     */
    protected void delLog() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", pu_inpsid);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_LOG,
                    params, new RequestCallBack<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                                if (bean.getState() != 0) {

                                    activity.setResult(Constance.RESULTCODE_FINISH, activity.getIntent());
                                    activity.finish();
                                } else {
                                    DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                if (null != customProgress) {
                                    customProgress.dismiss();
                                }
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            if (null != customProgress) {
                                customProgress.dismiss();
                            }
                        }
                    });
    }


    public void createCustomDialog() {
        if (customProgress != null) {
        } else {
            customProgress = new CustomProgress(activity);
            customProgress.show(activity, "请稍候…", false);
        }

    }

    @Override
    public void clickAccess(int position) {
        if (msg_type.equals(MessageType.MSG_QUALITY_STRING) || msg_type.equals(MessageType.MSG_SAFE_STRING)) {
            createCustomDialog();
            if (!TextUtils.isEmpty(pu_inpsid)) {
                LUtils.e("----------------------:删除计划");
                //删除质量，安全检查计划
                delInspectQualityList();
            } else {
                //删除质量，安全
                LUtils.e("----------------------:删除质量");
                delquelityAndSafe();
            }
        } else if (msg_type.equals(MessageType.MSG_LOG_STRING)) {
            LUtils.e("----------------------:删除日志");
            //日志删除
            createCustomDialog();
            delLog();
        }

    }

    public interface UpdateLogInterFace {
        void updateLog();
    }
}
