package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.widget.ImageView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.util.PicSizeUtils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.ref.SoftReference;
import java.util.HashMap;

public class BitmapCache extends Activity {

	public Handler h = new Handler();
	public final String TAG = getClass().getSimpleName();
	private HashMap<String, SoftReference<Bitmap>> imageCache = new HashMap<String, SoftReference<Bitmap>>();

	public void put(String path, Bitmap bmp) {
		if (!TextUtils.isEmpty(path) && bmp != null) {
			imageCache.put(path, new SoftReference<Bitmap>(bmp));
		}
	}

	public void displayBmp(final ImageView iv, final String thumbPath,
			final String sourcePath, final ImageCallback callback) {
		if (TextUtils.isEmpty(thumbPath) && TextUtils.isEmpty(sourcePath)){ //是否有缩略图和 原图路径
			return;
		}
		final String path;
		final boolean isThumbPath;
		if (!TextUtils.isEmpty(thumbPath)){ //如果有缩略图 则使用缩略图
			path = thumbPath;
			isThumbPath = true;
		} else if (!TextUtils.isEmpty(sourcePath)){ //如果没有缩略图,则使用原图
			path = sourcePath;
			isThumbPath = false;
		} else {
			return;
		}
		if (imageCache.containsKey(path)){
			SoftReference<Bitmap> reference = imageCache.get(path);
			Bitmap bmp = reference.get();
			if (bmp != null){
				if (callback != null) {
					callback.imageLoad(iv,bmp,sourcePath);
				}
				Log.d(TAG, "hit cache");
				return;
			}
		}
		iv.setImageBitmap(null);
		new Thread(){
			Bitmap thumb;
			public void run(){
				try {
					if (isThumbPath){
						thumb = BitmapFactory.decodeFile(thumbPath);
						if (thumb == null) {
							thumb = revitionImageSize(sourcePath);						
						}						
					} else {
						thumb = revitionImageSize(sourcePath);											
					}
				} catch (Exception e) {	
					
				}
				if (thumb == null) {
					thumb = AlbumActivity.bimap;
				}
				put(path,thumb);
				if (callback != null) {
					h.post(new Runnable(){
						@Override
						public void run() {
							callback.imageLoad(iv, thumb, sourcePath);
						}
					});
				}
			}
		}.start();
	}

	public Bitmap revitionImageSize(String path) throws IOException {
		BufferedInputStream in = new BufferedInputStream(new FileInputStream(new File(path)));
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true; //不在内存中加载Bitmap
		BitmapFactory.decodeStream(in, null, options);
		in.close();
		int i = 0;
		Bitmap bitmap = null;
		LUtils.e("outWidth:"+options.outWidth,"outHeight:"+options.outHeight+"           "+ (5<<1));
		while (true) {
			if ((options.outWidth >> i <= 256) && (options.outHeight >> i <= 256)) {
				in = new BufferedInputStream(new FileInputStream(new File(path)));
				options.inSampleSize = (int) Math.pow(2.0D,i); //平方数
				options.inJustDecodeBounds = false;
				bitmap = BitmapFactory.decodeStream(in, null, options);
				int degree = PicSizeUtils.getBitmapDegree(path);
				bitmap = PicSizeUtils.rotateBitmapByDegree(bitmap,degree);
				break;
			}
			i += 1;
		}
		in.close();
		return bitmap;
	}

	public interface ImageCallback {
		void imageLoad(ImageView imageView, Bitmap bitmap,
					Object... params);
	}
}
