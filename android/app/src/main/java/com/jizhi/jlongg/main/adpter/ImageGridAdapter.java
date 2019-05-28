package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BitmapCache;
import com.jizhi.jlongg.main.activity.BitmapCache.ImageCallback;
import com.jizhi.jlongg.main.bean.ImageItem;

import java.util.LinkedHashMap;
import java.util.List;

public class ImageGridAdapter extends BaseAdapter {
	final String TAG = getClass().getName();
	/** 选中图片的回调函数 */
	private TextCallback textcallback = null;
	Activity activity;
	/** 图片数据 */
	List<ImageItem> dataList;
	/** 图片缓存 */
	BitmapCache cache;
	/** 主页面handler */
	private Handler mHandler;
	/** 已选择的图片总数 */
	private int selectTotal;
	/** 最大能选择的图片数 */
	private int max;

	private LinkedHashMap<String,ImageItem> map;

	ImageCallback callback = new ImageCallback() {
		@Override
		public void imageLoad(ImageView imageView, Bitmap bitmap,Object... params) {
			if (imageView != null && bitmap != null) {
				String url = (String) params[0];
				if (url != null && url.equals(imageView.getTag())) {
					imageView.setImageBitmap(bitmap);
				} else {
					LUtils.e(TAG, "callback bmp not match");
				}
			} else {
				LUtils.e(TAG, "callback bmp null");
			}
		}
	};

	public interface TextCallback{
		void onListen(int count);
	}

	public void setTextCallback(TextCallback listener) {
		textcallback = listener;
	}

	public ImageGridAdapter(Activity act, List<ImageItem> list, Handler mHandler,int max,LinkedHashMap map){
		this.activity = act;
		dataList = list;
		cache = new BitmapCache();
		this.mHandler = mHandler;
		this.max = max;
		this.selectTotal = map.size();
		this.map = map;
	}

	@Override
	public int getCount() {
		return dataList == null ? 0 : dataList.size();
	}

	@Override
	public Object getItem(int position) {
		return null;
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	class Holder {
		private ImageView iv;
		private ImageView selected;
		private TextView text;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		final Holder holder;
		if (convertView == null) {
			holder = new Holder();
			convertView = View.inflate(activity, R.layout.item_image_grid, null);
			holder.iv = (ImageView) convertView.findViewById(R.id.image);
			holder.selected = (ImageView) convertView.findViewById(R.id.isselected);
			holder.text = (TextView) convertView.findViewById(R.id.item_image_grid_text);
			convertView.setTag(holder);
		} else {
			holder = (Holder) convertView.getTag();
		}
		final ImageItem item = dataList.get(position);
		holder.iv.setTag(item.imagePath);
		cache.displayBmp(holder.iv, item.thumbnailPath, item.imagePath,callback);
		if (item.isSelected) {
//			holder.selected.setImageResource(R.drawable.icon_data_select);
//			holder.text.setBackgroundResource(R.drawable.bgd_relatly_line);
		} else {
			holder.selected.setImageResource(-1);
			holder.text.setBackgroundColor(0x00000000);
		}
		holder.iv.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v){
				String path = dataList.get(position).imagePath;
				if (selectTotal < max) {
					item.isSelected = !item.isSelected;
					if (item.isSelected){
//						holder.selected.setImageResource(R.drawable.icon_data_select);
//						holder.text.setBackgroundResource(R.drawable.bgd_relatly_line);
						selectTotal++;
						map.put(item.imageId,item);
					} else if (!item.isSelected){
						holder.selected.setImageResource(-1);
						holder.text.setBackgroundColor(0x00000000);
						selectTotal--;
						map.remove(item.imageId);
					}
					if(textcallback != null){
						textcallback.onListen(selectTotal);
					}
				} else if (selectTotal >= max) {
					if (item.isSelected){
						item.isSelected = !item.isSelected;
						holder.selected.setImageResource(-1);
						holder.text.setBackgroundColor(0x00000000);
						selectTotal--;
						if (textcallback != null){
							textcallback.onListen(selectTotal);
						}
						map.remove(item.imageId);
					} else {
						Message message = Message.obtain(mHandler, 0);
						message.sendToTarget();
					}
				}
			}
		});

		return convertView;
	}
}
