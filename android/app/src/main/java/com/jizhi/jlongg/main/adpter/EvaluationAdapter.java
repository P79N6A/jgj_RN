package com.jizhi.jlongg.main.adpter;

import java.util.List;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Evaluation;
import com.jizhi.jongg.widget.MyRattingBar;

/**
 * 评价Adapter
 * @author Xuj
 * @time 2015年11月17日 14:38:27
 */
public class EvaluationAdapter extends BaseAdapter{

	private List<Evaluation> list;
	private LayoutInflater inflater;
	private Context context;
	
	public EvaluationAdapter(Context context, List<Evaluation> list) {
		this.context = context;
		inflater = LayoutInflater.from(context);
		this.list = list;
	}

	@Override
	public int getCount() {
		return list == null ? 0 : list.size();
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
	public View getView(final int position,View convertView, ViewGroup parent) {
		final LeftViewHolder holder;
		Evaluation bean = list.get(position);
		if (convertView == null) {
			holder = new LeftViewHolder();
			convertView = inflater.inflate(R.layout.item_list_evaluate, null);
			holder.realname = (TextView) convertView.findViewById(R.id.realname);
			holder.ctime = (TextView) convertView.findViewById(R.id.ctime);
			holder.content = (TextView) convertView.findViewById(R.id.content);
			holder.store_avg = (MyRattingBar) convertView.findViewById(R.id.store_avg);
			convertView.setTag(holder);
		} else {
			holder = (LeftViewHolder) convertView.getTag();
		}
		if(bean.getHidename() == 1){
			
		}
		int hidename = bean.getHidename();
		if(bean.getHidename() == 1){
			StringBuffer sb = new StringBuffer();
			sb.append(bean.getRealname().substring(0,1));
			for(int i = 0;i<bean.getRealname().length()-1;i++){
				sb.append("*");
			}
			holder.realname.setText(sb.toString());
		}else{
			holder.realname.setText(bean.getRealname());
		}
		holder.ctime.setText(bean.getCtime());
		holder.store_avg.setStarGrade(bean.getStore_avg());
		holder.content.setText(StrUtil.ToDBC(StrUtil.StringFilter(bean.getContent())));
		return convertView;
	}
	
	

	public class LeftViewHolder {
		TextView ctime;
		TextView realname;
		TextView content;
		MyRattingBar store_avg;
	}

}