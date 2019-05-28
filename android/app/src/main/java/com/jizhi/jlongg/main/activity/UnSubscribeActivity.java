package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.UnSubscribeListener;
import com.jizhi.jlongg.main.adpter.UnSubscribeAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.Subscribe;
import com.jizhi.jlongg.main.bean.UnSubscribe;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogUnSubscribe;
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
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;


/**
 * 功能:注销账户
 * 时间:2018年1月5日10:04:52
 * 作者:xuj
 */
public class UnSubscribeActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 其他注销原因
     */
    private EditText otherEdit;
    /**
     * 注销原因列表
     */
    private List<UnSubscribe> unSubscribeList;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, UnSubscribeActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.unsubscibe);
        setTextTitle(R.string.unsubscribe);
        setImageScale();
        getSubscribeState();
    }


    /**
     * 设置图片显示的缩放比
     */
    private void setImageScale() {
        int screenWidth = DensityUtils.getScreenWidth(getApplicationContext()); //获取屏幕宽度
        int leftRightMargin = DensityUtils.dp2px(getApplicationContext(), 15);
        screenWidth -= leftRightMargin * 2;
        int[] imageInfo = ImageUtils.getImageWidthHeight(getApplicationContext(), R.drawable.un_sub_tips);
        float scale = ((float) (screenWidth)) / imageInfo[0]; //获取缩放比 计算方式为 屏幕的宽度/显示图片的宽度
        ImageView imageView = getImageView(R.id.image);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) imageView.getLayoutParams();
        params.leftMargin = leftRightMargin;
        params.rightMargin = leftRightMargin;
        params.width = (int) (imageInfo[0] * scale);
        params.height = (int) (imageInfo[1] * scale);
        imageView.setLayoutParams(params);
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            itemDiver = convertView.findViewById(R.id.itemDiver);
            unSubscribeReasonText = (TextView) convertView.findViewById(R.id.unSubscribeReasonText);
            selecetdIcon = (ImageView) convertView.findViewById(R.id.selecetdIcon);
        }

        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 注销原因
         */
        TextView unSubscribeReasonText;
        /**
         * 选择状态
         */
        ImageView selecetdIcon;
    }

    /**
     * 获取已选注销原因 code
     */
    private String getSelecteUnSubscribeCodes() {
        List<UnSubscribe> unSubscribeList = this.unSubscribeList;
        if (unSubscribeList == null || unSubscribeList.size() == 0) {
            return null;
        }
        StringBuilder builder = new StringBuilder();
        for (UnSubscribe unSubscribe : unSubscribeList) {
            if (unSubscribe.is_selected()) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? unSubscribe.getCode() : "," + unSubscribe.getCode());
            }
        }
        return builder.toString();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.reqeustUnsubscribe: //申请注销
                final String codes = getSelecteUnSubscribeCodes();
                final String other = otherEdit.getText().toString().trim();
                if (TextUtils.isEmpty(codes) && TextUtils.isEmpty(other)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请反馈你的注销原因", CommonMethod.ERROR);
                    return;
                }
                if (!TextUtils.isEmpty(other) && other.length() < 2) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "至少须填写2个字", CommonMethod.ERROR);
                    return;
                }
                DialogUnSubscribe dialogUnSubscribe = new DialogUnSubscribe(this, new UnSubscribeListener() {
                    @Override
                    public void applyUnSubscribe(String code) { //申请取消账户
                        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                        params.addBodyParameter("vcode", code);
                        params.addBodyParameter("code", codes);
                        if (!TextUtils.isEmpty(other)) {
                            params.addBodyParameter("reason", other); //填写的原因，与code至少要传一个
                        }
                        HttpUtils http = SingsHttpUtils.getHttp();
                        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ACCOUNT_CANCELLATION, params, new RequestCallBackExpand<String>() {
                            @Override
                            public void onSuccess(ResponseInfo<String> responseInfo) {
                                try {
                                    CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                                    if (base.getState() != 0) {
                                        getSubscribeState();
                                    } else {
                                        DataUtil.showErrOrMsg(UnSubscribeActivity.this, base.getErrno(), base.getErrmsg());
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                                } finally {
                                    closeDialog();
                                }
                            }
                        });
                    }
                });
                dialogUnSubscribe.show();
                break;
        }
    }


    /**
     * 获取当前的注销状态
     */
    private void getSubscribeState() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ACCOUNT_STATUS, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Subscribe> base = CommonJson.fromJson(responseInfo.result, Subscribe.class);
                    if (base.getState() != 0) {
                        int status = base.getValues().getStatus();
                        //0没有任何住下操作，1，注销提交，2，注销成功，3注销被拒
                        if (status == 1) {
                            getTextView(R.id.applying).setText(base.getValues().getComment());
                            findViewById(R.id.unSubscribeReasonText).setVisibility(View.GONE);
                            findViewById(R.id.reqeustUnsubscribe).setVisibility(View.GONE);
                            findViewById(R.id.listView).setVisibility(View.GONE);
                            Utils.setBackGround(findViewById(R.id.bottomLayout), getResources().getDrawable(R.color.color_f1f1f1));
                        } else if (status == 0 || status == 3) {
                            getUnSubscribeReason();
                        }
                    } else {
                        DataUtil.showErrOrMsg(UnSubscribeActivity.this, base.getErrno(), base.getErrmsg());
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }


    /**
     * 获取账号注销原因列表
     */
    private void getUnSubscribeReason() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("class_id", "85"); //这里传固定值就行了
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CLASSLIST, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<UnSubscribe> base = CommonListJson.fromJson(responseInfo.result, UnSubscribe.class);
                    if (base.getState() != 0) {
                        unSubscribeList = base.getValues();
                        ListView listView = (ListView) findViewById(R.id.listView);
                        View otherView = getLayoutInflater().inflate(R.layout.other_un_subscribe, null, false);
                        otherEdit = (EditText) otherView.findViewById(R.id.otherEdit);
                        listView.addFooterView(otherView);
                        listView.setAdapter(new UnSubscribeAdapter(UnSubscribeActivity.this, base.getValues()));
                    } else {
                        DataUtil.showErrOrMsg(UnSubscribeActivity.this, base.getErrno(), base.getErrmsg());
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }

}
