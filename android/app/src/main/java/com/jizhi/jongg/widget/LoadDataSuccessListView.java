package com.jizhi.jongg.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * 之前有个需求要实现这么一个功能，进入到一个有listview的页面，然后自动定位到某个item.listview有提供一个api就是setSelection来实现跳转到某个ITEM，
 * 开始以为这个实现挺简单的，但是尝试了之后发现直接setSelection没有起作用。后来查了下资料发现，这个方法只有在listvie完成数据加载之后调用才会生效。
 * 网上大部分文章提供的解决方法是，把setSelection的调用放在postdelay里面延迟几百毫秒执行，这个的确有效，但是这个延迟的时间不好确定，
 * 有时候数据加载得很慢的情况下，这个方法还是会失效的。 这时我想到了一 listview有一个transcripmode的属性。
 * 这个属性设置为alwayscroll之后会自动滑到底部，这个属性每次都能滑动成功，我就想listview内部肯定有对这个做处理。
 * 然后就顺着这个属性看了下listview的源码，发现里面有个datachanged的属性。表示数据加载完成，数据加载完成之后会调用一个叫做handlechange的方法。
 * if (dataChanged) {
 * handleDataChanged();
 * }
 * 　　看到这，我就想到这个办法，自定义一个listview重写里面的handledatachanded方法，在里面加一个回调，然后将setSelection这个方法放在这个回调里面去执行。测试了一下，发现这个方法果然能保证setSelection百分百生效。下面附上自定义的listview代码。
 */


public class LoadDataSuccessListView extends ListView {

    DataChangedListener dataChangedListener;

    public LoadDataSuccessListView(Context context) {
        super(context);
    }

    public LoadDataSuccessListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public LoadDataSuccessListView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void handleDataChanged() {
        super.handleDataChanged();
        if (dataChangedListener != null) {
            dataChangedListener.onSuccess();
        }
    }

    public void setDataChangedListener(DataChangedListener dataChangedListener) {
        this.dataChangedListener = dataChangedListener;
    }

    public interface DataChangedListener {
        public void onSuccess();
    }


}
