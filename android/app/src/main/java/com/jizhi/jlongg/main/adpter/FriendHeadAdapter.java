package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.FriendBean;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

public class FriendHeadAdapter extends RecyclerView.Adapter<FriendHeadAdapter.ViewHolder> {
	public interface OnItemClickLitener {
		void onItemClick(View view, int position);
	}

	private OnItemClickLitener mOnItemClickLitener;

	public void setOnItemClickLitener(OnItemClickLitener mOnItemClickLitener) {
		this.mOnItemClickLitener = mOnItemClickLitener;
	}

	private LayoutInflater mInflater;
	private List<FriendBean> list;
	@SuppressWarnings("unused")
	private Context context;


	public FriendHeadAdapter(Context context, List<FriendBean> list,OnItemClickLitener mOnItemClickLitener) {
		mInflater = LayoutInflater.from(context);
		this.list = list;
		this.mOnItemClickLitener = mOnItemClickLitener;
		this.context = context;
	}

	public static class ViewHolder extends RecyclerView.ViewHolder {
		public ViewHolder(View arg0) {
			super(arg0);
		}
		ImageView headpic;
		TextView friendName;
	}

	@Override
	public int getItemCount() {
		return list.size();
	}

	@Override
	public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
		View view = mInflater.inflate(R.layout.know_friend_item, viewGroup,false);
		ViewHolder viewHolder = new ViewHolder(view);
		viewHolder.headpic = (ImageView) view.findViewById(R.id.headpic);
		viewHolder.friendName = (TextView) view.findViewById(R.id.friendName);
		return viewHolder;
	}

	@Override
	public void onBindViewHolder(ViewHolder holder, final int position) {
		final FriendBean bean = list.get(position);
		ImageLoader.getInstance().displayImage(NetWorkRequest.NETURL + bean.getHeadpic(),holder.headpic, UtilImageLoader.getImageOptionsFriendHead());
		holder.friendName.setText(bean.getFriendname());
		if (mOnItemClickLitener != null) {
			holder.headpic.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					mOnItemClickLitener.onItemClick(null, position);
				}
			});
		}
	}

}
