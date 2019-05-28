package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.MsgQualityAndSafeCheckListAdapter;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogLogMore;
import com.jizhi.jlongg.main.util.BackGroundUtil;
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
 * CName:质量，安全检查大项列表页 2.3.0
 * User: hcs
 * Date: 2017-07-17
 * Time: 10:40
 */

public class MsgQualityAndSafeCheckListActivity extends BaseActivity {
    private MsgQualityAndSafeCheckListActivity mActivity;
    private ListView listView;
    private QualityAndsafeCheckMsgBean gnInfo;
    private MsgQualityAndSafeCheckListAdapter adapter;
    private List<QualityAndsafeCheckMsgBean> qualityAndsafeCheckMsgBeanList;
    private boolean isBackFlush;//是否需要返回刷新

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quality_and_safe_check_list);
        initView();
        getIntentData();
        getInspectQualityInfo();
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                gnInfo.setInsp_id(qualityAndsafeCheckMsgBeanList.get(position).getInsp_id());
                gnInfo.setInspect_name(qualityAndsafeCheckMsgBeanList.get(position).getInspect_name());
                gnInfo.setPu_inpsid(qualityAndsafeCheckMsgBeanList.get(position).getPu_inpsid());
                gnInfo.setAll_pro_name(getIntent().getStringExtra(Constance.GROUP_NAME));
                MsgQualityAndSafeCheckDetailActivity.actionStart(mActivity, gnInfo);


            }
        });
    }

    //日志更多
    private DialogLogMore dialogLogMore;

    public void initRightImageLog() {
//        ImageView imageView = (ImageView) findViewById(R.id.rightImage);
//        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) imageView.getLayoutParams();
//        params.width = ViewGroup.LayoutParams.WRAP_CONTENT;
//        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
//        imageView.setLayoutParams(params);
//        imageView.setImageResource(R.drawable.red_dots);
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (dialogLogMore == null) {
                    String desc = "你确定要删除该检查计划吗？";
                    dialogLogMore = new DialogLogMore(mActivity, desc, gnInfo.getPu_inpsid(), gnInfo.getMsg_type(),null);
                }
                dialogLogMore.setPu_inpsid(gnInfo.getPu_inpsid());
                dialogLogMore.goneEdit();
                dialogLogMore.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);//这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                BackGroundUtil.backgroundAlpha(mActivity, 0.5f);
            }
        });
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = MsgQualityAndSafeCheckListActivity.this;
        setTextTitleAndRight(R.string.r_check,R.string.more);
        listView =  findViewById(R.id.listview);

    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (QualityAndsafeCheckMsgBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, QualityAndsafeCheckMsgBean info, String group_name) {
        Intent intent = new Intent(context, MsgQualityAndSafeCheckListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.GROUP_NAME, group_name);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 获取检查项目计划详情
     */
    protected void getInspectQualityInfo() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("pu_inpsid", gnInfo.getPu_inpsid());
        params.addBodyParameter("msg_type", gnInfo.getMsg_type());
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_INSPECTQYALITYINFO,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<QualityAndsafeCheckMsgBean> beans = CommonListJson.fromJson(responseInfo.result, QualityAndsafeCheckMsgBean.class);

                                if (beans.getState() != 0) {
                                    qualityAndsafeCheckMsgBeanList = beans.getValues();
                                    adapter = new MsgQualityAndSafeCheckListAdapter(mActivity, qualityAndsafeCheckMsgBeanList);
                                    listView.setAdapter(adapter);
                                    if (qualityAndsafeCheckMsgBeanList.size() > 0 && qualityAndsafeCheckMsgBeanList.get(0).is_privilege() == 1) {
                                        initRightImageLog();
                                    }
                                } else {
                                    DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
                                    finish();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                                mActivity.finish();
                            } finally {
                                closeDialog();
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            closeDialog();
                        }
                    });


    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            isBackFlush = true;
            getInspectQualityInfo();
        }
    }

    @Override
    public void onBackPressed() {
        if (isBackFlush) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onBackPressed();
    }

    @Override
    public void onFinish(View view) {
        if (isBackFlush) {
            setResult(Constance.RESULTCODE_FINISH, getIntent());
        }
        super.onFinish(view);
    }
}
