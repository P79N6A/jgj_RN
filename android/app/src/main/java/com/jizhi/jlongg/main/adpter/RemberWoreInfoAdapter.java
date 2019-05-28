package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.res.Resources;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RemberWorkInfo;

import java.util.List;

/**
 * huchangsheng：Administrator on 2016/2/23 14:01
 */
public class RemberWoreInfoAdapter extends BaseAdapter {
    private List<RemberWorkInfo> workdayChild;
    private LayoutInflater inflater;
    private RememberWorkerInfosActivity activity;
    private RememberCheckBoxChangeListener boxChangeListener;
    private Resources res;
    private int currentRole;


    public void setWorkdayChild(List<RemberWorkInfo> workdayChild) {
        this.workdayChild = workdayChild;
        notifyDataSetChanged();
    }

    public RemberWoreInfoAdapter(RememberWorkerInfosActivity activity, List<RemberWorkInfo> workdayChild, RememberCheckBoxChangeListener boxChangeListener) {
        super();
        this.workdayChild = workdayChild;
        this.activity = activity;
        inflater = LayoutInflater.from(activity);
        this.boxChangeListener = boxChangeListener;
        res = activity.getResources();
        currentRole = Integer.parseInt(UclientApplication.getRoler(activity));
    }

    @Override
    public int getCount() {
        return workdayChild == null ? 0 : workdayChild.size();
    }

    @Override
    public Object getItem(int position) {
        return workdayChild.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        return convertView;
    }


    class ChildHolder {
        TextView tv_name;
        TextView tv_proname;
        TextView tv_worktype;
        TextView tv_overtime;
        TextView tv_amounts;
        ImageView amounts_diff;
        TextView tv_date;
        TextView tv_lunar;
        ListView listview;
        ImageView cb_del;
        //        ImageView cb_;
        View img_line;
        LinearLayout layout_right;
        LinearLayout lin_times;
        RelativeLayout lin_date;
        /**
         * 角色图片
         */
        ImageView img_role;
    }

    public interface RememberCheckBoxChangeListener {
        public void getSelectLength(int length);

        public void itemClicListener(int position);
    }

}
