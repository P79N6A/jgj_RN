package com.jizhi.jlongg.main.activity;

import android.content.res.Resources;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ReportAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.Report;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 举报
 * @author Xuj
 * @time 2015年12月1日 18:05:43
 * @Version 1.0
 */
public class ReportActivity extends BaseActivity implements View.OnClickListener{

	private String TAG = getClass().getName();

	private List<Report> list;

	private ListView listView;

	private EditText other;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.report);
		SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.report));
		listView = (ListView)findViewById(R.id.listView);
		other = (EditText) findViewById(R.id.other);
		final ImageView select_image = (ImageView) findViewById(R.id.select_image);
		final TextView other_title = (TextView) findViewById(R.id.other_title);
		final Resources res = getResources();
		findViewById(R.id.converview).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				int flag = select_image.getVisibility();
				if (flag == View.GONE) {
					other_title.setTextColor(getResources().getColor(R.color.app_color));
					select_image.setVisibility(View.VISIBLE);
					other.setVisibility(View.VISIBLE);
					other.setFocusable(true);
					other.setFocusableInTouchMode(true);
					other.requestFocus();
				} else {
					other_title.setTextColor(res.getColor(R.color.gray_333333));
					select_image.setVisibility(View.GONE);
					other.setVisibility(View.GONE);
				}
			}
		});
		getReportList();
	}

	/**
	 * 获取举报信息
	 * @return
	 */
	private List<Report> getReportData(){
//		list = new ArrayList<Report>();
//		Report report = new Report("电话虚假!","如空号、无人接听");
//		Report report1 = new Report("职位信息虚假","如职位、待遇等");
//		Report report2 = new Report("职介收费","如利用各种理由向你索取费用等");
//		Report report3 = new Report("涉黄违法","如招嫖信息、枪支弹药等信息");
//		Report report4 = new Report("其他");
//		list.add(report);
//		list.add(report1);
//		list.add(report2);
//		list.add(report3);
//		list.add(report4);
		return list;
	}
//
//
	public RequestParams params(boolean isSubmit){
		RequestParams params = RequestParamsToken.getExpandRequestParams(this);
		if(isSubmit){ //提交所需参数
			params.addBodyParameter("mstype","recruit");
			params.addBodyParameter("key",getIntent().getIntExtra(Constance.PID,0)+"");
			StringBuffer sb = new StringBuffer();
			int i = 0;
			for(Report report:list){
				if(report.isSeleted()){
					if(i == 0){
						sb.append(report.getCode());
					}else{
						sb.append(","+report.getCode());
					}
					i+=1;
				}
			}
			params.addBodyParameter("value", sb.toString());
			if(other.getVisibility() == View.VISIBLE && !TextUtils.isEmpty(other.getText().toString())){
				params.addBodyParameter("other",other.getText().toString());
			}
		}else{
			params.addBodyParameter("class_id", "40");
		}
		return params;
	}



	/**
	 * 提交举报信息
	 */
	public void submitReport(){
		HttpUtils http = SingsHttpUtils.getHttp();
		http.send(HttpRequest.HttpMethod.POST,NetWorkRequest.ADD_REPORT,params(true),
				new RequestCallBackExpand<String>() {
					@Override
					public void onSuccess(ResponseInfo<String> responseInfo) {
						LUtils.e(TAG, responseInfo.result);
						try{
							Gson gson = new Gson();
							BaseNetBean status = gson.fromJson(responseInfo.result,BaseNetBean.class);
							if(status.getState()!=0){
								CommonMethod.makeNoticeShort(ReportActivity.this, getString(R.string.submit_success),CommonMethod.SUCCESS);
								finish();
							}else{
								CommonMethod.makeNoticeShort(ReportActivity.this, status.getErrmsg(),CommonMethod.ERROR);
							}
						}catch(Exception e){
							e.printStackTrace();
							CommonMethod.makeNoticeShort(ReportActivity.this, getString(R.string.service_err),CommonMethod.ERROR);
						}finally{
							closeDialog();
						}
					}
				});
	}

	@Override
	public void onClick(View v) {
		boolean isAccess = false;
		for(Report report:list){
			if(report.isSeleted()){
				isAccess = true;
				break;
			}
		}
		if(other.getVisibility() == View.VISIBLE && TextUtils.isEmpty(other.getText().toString())){
			CommonMethod.makeNoticeShort(ReportActivity.this,"请输入其他的举报内容!",CommonMethod.ERROR);
			return;
		}else if(other.getVisibility() == View.VISIBLE && !TextUtils.isEmpty(other.getText().toString())){
			isAccess = true;
		}
		if(!isAccess){
			CommonMethod.makeNoticeShort(ReportActivity.this,"请勾选你想举报的内容!",CommonMethod.ERROR);
			return;
		}
		submitReport();
	}


	/**
	 * 获取举报信息
	 */
	public void getReportList() {
		HttpUtils http = SingsHttpUtils.getHttp();
		http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CLASSLIST,params(false), new RequestCallBackExpand<String>() {
					@Override
					public void onSuccess(ResponseInfo<String> responseInfo) {
						LUtils.e(TAG, responseInfo.result);
						try{
							CommonListJson<Report> status = CommonListJson.fromJson(responseInfo.result, Report.class);
							if (status.getState() != 0) {
								if (status.getValues() != null && status.getValues().size() > 0){
									list = status.getValues();
									ReportAdapter adapter = new ReportAdapter(ReportActivity.this,list,null,listView);
									listView.setAdapter(adapter);
								}
							} else {
								DataUtil.showErrOrMsg(ReportActivity.this, status.getErrno(), status.getErrmsg());
								finish();
							}
						}catch(Exception e){
							e.printStackTrace();
							CommonMethod.makeNoticeShort(ReportActivity.this,getString(R.string.service_err),CommonMethod.ERROR);
						}finally{
							closeDialog();
						}
					}
				});
	}

}
