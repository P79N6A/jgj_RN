//package com.jizhi.jlongg.main.adpter;
//
//import android.annotation.TargetApi;
//import android.content.Intent;
//import android.os.Build;
//import android.text.Html;
//import android.text.TextUtils;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.BaseAdapter;
//import android.widget.ImageView;
//import android.widget.ListView;
//import android.widget.TextView;
//
//import com.hcs.uclient.utils.StrUtil;
//import com.hcs.uclient.utils.TimesUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
//import com.jizhi.jlongg.main.activity.BaseActivity;
//import com.jizhi.jlongg.main.activity.NewMessageDetailActivity;
//import com.jizhi.jlongg.main.activity.SyncRecordToMeActivity;
//import com.jizhi.jlongg.main.activity.X5WebViewActivity;
//import com.jizhi.jlongg.main.bean.NewMessage;
//import com.jizhi.jlongg.main.listener.NoticeOperateListener;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.ProductUtil;
//import com.jizhi.jlongg.main.util.WebSocketConstance;
//import com.jizhi.jlongg.network.NetWorkRequest;
//
//import java.util.List;
//
///**
// * 功能:新消息适配器
// * 时间:2016年8月26日 11:05:29
// * 作者:xuj
// */
//public class NewMessageAdapter extends BaseAdapter {
//
//    /**
//     * 项目快过期时系统消息,以及优质班组长，审核认证信息
//     */
//    private int EXPIRE_AUDIT = 0;
//    /**
//     * 公共的信息
//     */
//    private int COMMON = 1;
//    /**
//     * 同步
//     */
//    private int SYNC = 2;
//    /**
//     * 上下文
//     */
//    private BaseActivity context;
//    /**
//     * xml解析器
//     */
//    private LayoutInflater inflater;
//    /**
//     * 列表数据
//     */
//    private List<NewMessage> list;
//    /**
//     * listView
//     */
//    private ListView listView;
//    /**
//     * 点击下标
//     */
//    private int clickPosition;
//    /**
//     * 回调
//     */
//    private NoticeOperateListener listener;
//
//    /**
//     * 更新单个数据
//     */
//    public void updateSingleView() {
//        View view = listView.getChildAt(clickPosition);
//        getView(clickPosition, view, listView);
//    }
//
//    public void updateList(List<NewMessage> list) {
//        this.list = list;
//        notifyDataSetChanged();
//    }
//
//    public void addList(List<NewMessage> list) {
//        this.list.addAll(0, list);
//        notifyDataSetChanged();
//    }
//
//
//    public NewMessageAdapter(BaseActivity context, List<NewMessage> list, ListView listView, NoticeOperateListener listener) {
//        inflater = LayoutInflater.from(context);
//        this.context = context;
//        this.list = list;
//        this.listView = listView;
//        this.listener = listener;
//    }
//
//    @Override
//    public int getViewTypeCount() {
//        return 3;
//    }
//
//    @Override
//    public int getItemViewType(int position) {
//        NewMessage message = list.get(position);
//        String classType = message.getClass_type();
//        if (classType.equals(WebSocketConstance.SYSTEM__MESSAGE_SYNCED_GROUP) ||
//                classType.equals(WebSocketConstance.SYSTEM_MESSAGE_SYNCED_GROUP_TO_GROUP) ||
//                classType.equals(WebSocketConstance.SYNC_PROJECT) ||
//                classType.equals(WebSocketConstance.SYSTEM__MESSAGE_SYNCED_PROJECT)
//                ) {
//            return SYNC;
//        } else {
//            return classType.equals(WebSocketConstance.ACTION_CLOUD_EXPIRE_NOTICE)
//                    || classType.equals(WebSocketConstance.ACTION_SERVICE_EXPIRE_NOTICE)
//                    || classType.equals(WebSocketConstance.ACTION_CLOUD_LACK)
//                    || classType.equals(WebSocketConstance.SYSTEM_MESSAGE_WORK_LEADER_CERTIFY)
//                    || classType.equals(WebSocketConstance.SYSTEM__MESSAGE_SUPERIOR_WORK_LEADER)
//                    ? EXPIRE_AUDIT : COMMON;
//        }
//    }
//
//    @Override
//    public int getCount() {
//        return list == null ? 0 : list.size();
//    }
//
//    @Override
//    public Object getItem(int position) {
//        return list.get(position);
//    }
//
//    @Override
//    public long getItemId(int position) {
//        return position;
//    }
//
//    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
//    @Override
//    public View getView(final int position, View convertView, ViewGroup parent) {
//        int type = getItemViewType(position);
//        ViewHolder holder = null;
//        if (convertView == null) {
//            if (type == COMMON) {
//                convertView = inflater.inflate(R.layout.item_notice_push_common, parent, false);
//            } else if (type == EXPIRE_AUDIT) { //过期
//                convertView = inflater.inflate(R.layout.item_notice_push_expire, parent, false);
//            } else if (type == SYNC) { //同步
//                convertView = inflater.inflate(R.layout.item_notice_push_sync, parent, false);
//            }
//            holder = new ViewHolder(convertView, type);
//            convertView.setTag(holder);
//        } else {
//            holder = (ViewHolder) convertView.getTag();
//        }
//        if (type == COMMON) {
//            bindData(holder, position);
//        } else if (type == EXPIRE_AUDIT) { //过期
//            bingExpireData(holder, position);
//        } else if (type == SYNC) { //同步
//            bingSyncData(holder, position);
//        }
//        return convertView;
//    }
//
//    public void bingSyncData(ViewHolder holder, final int position) {
//        final NewMessage bean = list.get(position);
//        final String classType = bean.getClass_type();
//        holder.title.setText(bean.getTitle()); //设置标题
//        holder.date.setText(bean.getDate()); //设置时间
//        holder.renewIcon.setImageResource(R.drawable.record_sync);
//        switch (classType) {
//            case WebSocketConstance.SYSTEM_MESSAGE_SYNCED_GROUP_TO_GROUP: //记工同步请求
//                holder.message.setText(bean.getUser_name() + "（班组长）向你请求同步记工记账数据");
//                if (bean.getSync_state() == 0) { //同步还未进行
//                    holder.redBtnLeft.setVisibility(View.VISIBLE);
//                    holder.redBtnRight.setVisibility(View.VISIBLE);
//                    holder.redBtnLeft.setText("同步");
//                    holder.redBtnRight.setText("拒绝");
//                    holder.synStateIcon.setVisibility(View.GONE);
//                } else if (bean.getSync_state() == 1) { //已同步成功
//                    holder.synStateIcon.setVisibility(View.VISIBLE);
//                    holder.synStateIcon.setImageResource(R.drawable.ytb_icon);
//                    holder.redBtnLeft.setVisibility(View.GONE);
//                    holder.redBtnRight.setVisibility(View.GONE);
//                } else if (bean.getSync_state() == 2) { //同步拒绝
//                    holder.synStateIcon.setVisibility(View.VISIBLE);
//                    holder.synStateIcon.setImageResource(R.drawable.yjj_icon);
//                    holder.redBtnLeft.setVisibility(View.GONE);
//                    holder.redBtnRight.setVisibility(View.GONE);
//                }
//                break;
//            case WebSocketConstance.SYNC_PROJECT: //要求同步项目  这个是以前的类型
//                holder.message.setText(bean.getUser_name() + "（项目部）向你请求同步记工数据");
//                if (bean.getSync_state() == 0) { //同步还未进行
//                    holder.synStateIcon.setVisibility(View.GONE);
//                    holder.redBtnLeft.setVisibility(View.VISIBLE);
//                    holder.redBtnRight.setVisibility(View.VISIBLE);
//                    holder.redBtnLeft.setText("同步");
//                    holder.redBtnRight.setText("拒绝");
//                } else if (bean.getSync_state() == 1) { //已同步成功
//                    holder.synStateIcon.setVisibility(View.VISIBLE);
//                    holder.synStateIcon.setImageResource(R.drawable.ytb_icon);
//                    holder.redBtnLeft.setVisibility(View.GONE);
//                    holder.redBtnRight.setVisibility(View.GONE);
//                } else if (bean.getSync_state() == 2) { //同步拒绝
//                    holder.synStateIcon.setVisibility(View.VISIBLE);
//                    holder.synStateIcon.setImageResource(R.drawable.yjj_icon);
//                    holder.redBtnLeft.setVisibility(View.GONE);
//                    holder.redBtnRight.setVisibility(View.GONE);
//                }
//                break;
//            case WebSocketConstance.SYSTEM__MESSAGE_SYNCED_GROUP: //跳转至“同步给我的记工”页面
//                holder.synStateIcon.setVisibility(View.GONE);
//                holder.message.setText(bean.getUser_name() + "向你同步了记工记账数据");
//                holder.redBtnLeft.setVisibility(View.GONE);
//                holder.redBtnRight.setVisibility(View.VISIBLE);
//                holder.redBtnRight.setText("查看");
//                break;
//            case WebSocketConstance.SYSTEM__MESSAGE_SYNCED_PROJECT: //同步记工类型点击“查看”，跳转至“记工报表”页面
//                holder.synStateIcon.setVisibility(View.GONE);
//                holder.message.setText(bean.getUser_name() + "向你同步了记工数据");
//                holder.redBtnLeft.setVisibility(View.GONE);
//                holder.redBtnRight.setVisibility(View.VISIBLE);
//                holder.redBtnRight.setText("查看");
//                break;
//        }
//        View.OnClickListener onClickListener = new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                if (listener == null) {
//                    return;
//                }
//                clickPosition = position;
//                switch (view.getId()) {
//                    case R.id.removeIcon: //移除按钮
//                        listener.remove(bean);
//                        break;
//                    case R.id.redBtnRight: //拒绝同步
//                        if (classType.equals(WebSocketConstance.SYSTEM_MESSAGE_SYNCED_GROUP_TO_GROUP)) {//记工同步请求
//                            listener.refuse(bean, 1); //拒绝同步
//                        } else if (classType.equals(WebSocketConstance.SYNC_PROJECT)) { //同步项目请求
//                            listener.refuse(bean, 2); //拒绝同步
//                        } else if (classType.equals(WebSocketConstance.SYSTEM__MESSAGE_SYNCED_GROUP)) {//跳转至“同步给我的记工”页面
//                            SyncRecordToMeActivity.actionStart(context);
//                        } else if (classType.equals(WebSocketConstance.SYSTEM__MESSAGE_SYNCED_PROJECT)) { //同步记工类型点击“查看”，跳转至“记工报表”页面
//                            X5WebViewActivity.actionStart(context, NetWorkRequest.STATISTICSCHARTS + "?" + "talk_view=1&team_id=" + bean.getTeam_id());
//                        }
//                        break;
//                    case R.id.redBtnLeft: //同意同步
////                        if (classType.equals(WebSocketConstance.SYSTEM_MESSAGE_SYNCED_GROUP_TO_GROUP)) {//记工同步请求
////                            AddSyncActivity.actionStart(context, "1", bean.getTarget_uid(), bean.getUser_name(), null);
////                        } else if (classType.equals(WebSocketConstance.SYNC_PROJECT)) { //同步项目请求
////                            AddSyncActivity.actionStart(context, "2", bean.getTarget_uid(), bean.getUser_name(), null);
////                        }
//                        break;
//                }
//            }
//        };
//        holder.removeIcon.setOnClickListener(onClickListener);
//        holder.redBtnRight.setOnClickListener(onClickListener);
//        holder.redBtnLeft.setOnClickListener(onClickListener);
//    }
//
//    public void bingExpireData(ViewHolder holder, final int position) {
//        final NewMessage bean = list.get(position);
//        holder.title.setText(bean.getTitle()); //设置标题
//        holder.date.setText(bean.getDate()); //设置时间
//        if (!TextUtils.isEmpty(bean.getInfo())) {
//            holder.message.setText(StrUtil.ToDBC(StrUtil.StringFilter(bean.getInfo()))); //设置过期提示
//        }
//        final String classType = bean.getClass_type();
//        switch (classType) {
//            case WebSocketConstance.ACTION_CLOUD_LACK: //云盘扩容
//                holder.redBtnRight.setVisibility(bean.getIsPay() == ProductUtil.PAID ? View.GONE : View.VISIBLE);
//                holder.redBtnRight.setText("立即扩容");
//                holder.renewIcon.setImageResource(R.drawable.app_store);
//                break;
//            case WebSocketConstance.ACTION_CLOUD_EXPIRE_NOTICE: //云盘过期通知
//                holder.redBtnRight.setVisibility(bean.getIsPay() == ProductUtil.PAID ? View.GONE : View.VISIBLE);
//                holder.redBtnRight.setText("立即续期");
//                holder.renewIcon.setImageResource(R.drawable.app_store);
//                break;
//            case WebSocketConstance.ACTION_SERVICE_EXPIRE_NOTICE://高级版过期通知
//                holder.redBtnRight.setVisibility(bean.getIsPay() == ProductUtil.PAID ? View.GONE : View.VISIBLE);
//                holder.redBtnRight.setText("立即续期");
//                holder.renewIcon.setImageResource(R.drawable.app_store);
//                break;
//            case WebSocketConstance.SYSTEM_MESSAGE_WORK_LEADER_CERTIFY: //班组长认证
//                holder.redBtnRight.setVisibility(View.VISIBLE);
//                holder.redBtnRight.setText("查看详情");
//                holder.renewIcon.setImageResource(R.drawable.audit_crefirition);
//                break;
//            case WebSocketConstance.SYSTEM__MESSAGE_SUPERIOR_WORK_LEADER: //优质班组长
//                holder.redBtnRight.setVisibility(View.GONE);
//                holder.renewIcon.setImageResource(R.drawable.quality_recommendation);
//                break;
//        }
//        View.OnClickListener onClickListener = new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                if (listener == null) {
//                    return;
//                }
//                clickPosition = position;
//                switch (view.getId()) {
//                    case R.id.removeIcon: //移除按钮
//                        listener.remove(bean);
//                        break;
//                    case R.id.redBtnRight: //续期按钮
//                        if (classType.equals(WebSocketConstance.SYSTEM_MESSAGE_WORK_LEADER_CERTIFY)) {
//                            listener.audit(bean);
//                        } else if (classType.equals(WebSocketConstance.ACTION_CLOUD_LACK)
//                                || classType.equals(WebSocketConstance.SYSTEM_MESSAGE_WORK_LEADER_CERTIFY)
//                                || classType.equals(WebSocketConstance.ACTION_SERVICE_EXPIRE_NOTICE)
//                                ) {
//                            listener.renew(bean);
//                        }
//                        break;
//                }
//            }
//        };
//        holder.removeIcon.setOnClickListener(onClickListener);
//        holder.redBtnRight.setOnClickListener(onClickListener);
//    }
//
//    public void bindData(ViewHolder holder, final int position) {
//        final String type = list.get(position).getClass_type();
//        final NewMessage bean = list.get(position);
//        loadHead(bean, holder);
//        holder.title.setText(bean.getTitle()); //设置标题
//        holder.date.setText(TimesUtils.getYYYYMMDDTime().equals(bean.getDate()) ? "今天" : bean.getDate()); //设置时间
//        holder.date.setText(bean.getDate());
//        String team_or_group_desc = null; //当前列表数据是讨论组还是班组
//        String team_or_group_value = null; //读取讨论组还是班组值
//        if (type.equals(WebSocketConstance.NEW_BILLING)) { //新账单
//            holder.redBtn.setText("加入班组");
//            holder.grayBtn.setVisibility(View.GONE);
//            holder.redBtn.setVisibility(View.VISIBLE);
//            holder.synStateIcon.setVisibility(View.GONE);
//            holder.newText.setVisibility(View.VISIBLE);
//        } else if (type.equals(WebSocketConstance.JOIN_SUCCESS)) {
//            holder.redBtn.setVisibility(View.GONE);
//            holder.grayBtn.setVisibility(View.GONE);
//            holder.synStateIcon.setImageResource(R.drawable.yjr);
//            holder.synStateIcon.setVisibility(View.VISIBLE);
//            holder.newText.setVisibility(View.GONE);
//        } else if (type.equals(WebSocketConstance.SYNCCREATETEAM)) {
//            holder.redBtn.setVisibility(View.GONE);
//            holder.grayBtn.setVisibility(View.GONE);
//            holder.newText.setVisibility(View.VISIBLE);
//        } else if (type.equals(WebSocketConstance.JOIN_TEAM) || type.equals(WebSocketConstance.JOIN_GROUP)) {
//            holder.grayBtn.setText("进入");
//            holder.redBtn.setVisibility(View.GONE);
//            holder.grayBtn.setVisibility(View.VISIBLE);
//            holder.synStateIcon.setVisibility(View.GONE);
//            holder.newText.setVisibility(View.GONE);
//        } else {
//            holder.redBtn.setVisibility(View.GONE);
//            holder.grayBtn.setVisibility(View.GONE);
//            holder.synStateIcon.setVisibility(View.GONE);
//            holder.newText.setVisibility(View.GONE);
//        }
//        if (type.equals(WebSocketConstance.REMOVE_GROUP_MEMBER) || type.equals(WebSocketConstance.CLOSE_GROUP) || type.equals(WebSocketConstance.JOIN_GROUP) || type.equals(WebSocketConstance.REOPEN_GROUP)) {
//            team_or_group_desc = "班组&nbsp;:&nbsp;";
//            team_or_group_value = bean.getGroup_name();
//        } else {
//            team_or_group_desc = "项目组&nbsp;:&nbsp;";
//            team_or_group_value = bean.getTeam_name();
//        }
//        StringBuffer sb = new StringBuffer();
//        if (type.equals(WebSocketConstance.REMOVE_GROUP_MEMBER) || type.equals(WebSocketConstance.REMOVE_TEAM_MEMBER)) { //移除讨论组、班组
//            sb.append(colorLight("你被&nbsp;&nbsp;") + colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;移出&nbsp;&nbsp;") + colorDark(team_or_group_desc + team_or_group_value));
//        } else if (type.equals(WebSocketConstance.CLOSE_TEAM) || type.equals(WebSocketConstance.CLOSE_GROUP)) { //关闭讨论组、班组
//            sb.append(colorDark(team_or_group_desc + team_or_group_value) + colorLight("&nbsp;&nbsp;被&nbsp;&nbsp;") + colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;关闭"));
//        } else if (type.equals(WebSocketConstance.JOIN_GROUP) || type.equals(WebSocketConstance.JOIN_TEAM)) { //加入讨论组、班组
//            sb.append(colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;将你加入&nbsp;&nbsp;") + colorDark(team_or_group_desc + team_or_group_value));
//        } else if (type.equals(WebSocketConstance.REOPEN_TEAM) || type.equals(WebSocketConstance.REOPEN_GROUP)) { //重新打开
//            sb.append(colorDark(team_or_group_desc + team_or_group_value) + colorLight("&nbsp;&nbsp;被&nbsp;&nbsp;") + colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;重新打开"));
//        } else if (type.equals(WebSocketConstance.NEW_BILLING) || type.equals(WebSocketConstance.JOIN_SUCCESS)) { //新记账
//            sb.append(colorLight("有新工友&nbsp;&nbsp;") + colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;对你记了一笔账"));
//        } else if (type.equals(WebSocketConstance.ACTION_REFUSE_SYNCH)) { //被拒绝同步项目给发起人
//            sb.append(colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;要求你同步项目组情况"));
//        } else if (type.equals(WebSocketConstance.SYNCCREATETEAM)) { //新创建的同步项目
//            sb.append(colorDark(bean.getUser_name()) + colorLight("&nbsp;&nbsp;对你同步了项目数据系统为你自动创建了<br></br>") + colorDark("项目:&nbsp;&nbsp;" + bean.getTeam_name()));
//        } else {
//            sb.append("未知的系统类型");
//        }
//        holder.message.setText(Html.fromHtml(sb.toString()));
//        View.OnClickListener onClickListener = new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                switch (v.getId()) {
//                    case R.id.redBtn:
//                        if (type.equals(WebSocketConstance.NEW_BILLING)) { //同步项目、加入记账人
//                            clickPosition = position;
//                            Intent intent = new Intent(context, NewMessageDetailActivity.class);
//                            intent.putExtra(Constance.BEAN_CONSTANCE, bean);
//                            intent.putExtra(Constance.ADDTYPE, type);
//                            context.startActivityForResult(intent, Constance.REQUEST);
//                        }
//                        break;
//                    case R.id.grayBtn:
//                        if (type.equals(WebSocketConstance.JOIN_TEAM) || type.equals(WebSocketConstance.JOIN_GROUP) ||
//                                type.equals(WebSocketConstance.CLOSE_GROUP) || type.equals(WebSocketConstance.CLOSE_TEAM)) { //进入按钮
//                            if (listener != null) {
//                                listener.into(bean); //进入
//                            }
//                        }
//                        break;
//                    case R.id.removeIcon:
//                        if (listener != null) {
//                            listener.remove(bean);
//                        }
//                        break;
//                }
//            }
//        };
//        holder.removeIcon.setVisibility(View.VISIBLE);
//        holder.removeIcon.setOnClickListener(onClickListener);
//        holder.redBtn.setOnClickListener(onClickListener);
//        holder.grayBtn.setOnClickListener(onClickListener);
//    }
//
//
//    private void loadHead(NewMessage bean, ViewHolder holder) {
//        holder.teamHeads.setImagesData(bean.getMembers_head_pic());
//    }
//
//
//    public class ViewHolder {
//        /**
//         * 标题
//         */
//        private TextView title;
//        /**
//         * 消息内容
//         */
//        private TextView message;
//        /**
//         * 时间
//         */
//        private TextView date;
//        /**
//         * 红色按钮
//         */
//        private TextView redBtn;
//        /**
//         * 灰色按钮
//         */
//        private TextView grayBtn;
//        /**
//         * 删除图标
//         */
//        private ImageView removeIcon;
//        /**
//         * 同步账单图标
//         */
//        private ImageView synStateIcon;
//        /**
//         * 讨论组聊天头像
//         */
//        private NineGroupChatGridImageView teamHeads;
//        /**
//         * 新记账人
//         */
//        private TextView newText;
//        /**
//         * 过期提示按钮
//         */
//        private TextView redBtnRight;
//        /**
//         * 过期提示按钮
//         */
//        private TextView redBtnLeft;
//        /**
//         * 过期，认证提示图标
//         */
//        private ImageView renewIcon;
//
//        public ViewHolder(View view, int type) {
//            title = (TextView) view.findViewById(R.id.title);
//            date = (TextView) view.findViewById(R.id.date);
//            message = (TextView) view.findViewById(R.id.message);
//            removeIcon = (ImageView) view.findViewById(R.id.removeIcon);
//            if (type == COMMON) {
//                redBtn = (TextView) view.findViewById(R.id.redBtn);
//                grayBtn = (TextView) view.findViewById(R.id.grayBtn);
//                synStateIcon = (ImageView) view.findViewById(R.id.syn_state_icon);
//                teamHeads = (NineGroupChatGridImageView) view.findViewById(R.id.teamHeads);
//                newText = (TextView) view.findViewById(R.id.newText);
//            } else if (type == EXPIRE_AUDIT) {
//                redBtnRight = (TextView) view.findViewById(R.id.redBtnRight);
//                renewIcon = (ImageView) view.findViewById(R.id.renewIcon);
//            } else if (type == SYNC) {
//                synStateIcon = (ImageView) view.findViewById(R.id.syn_state_icon);
//                redBtnLeft = (TextView) view.findViewById(R.id.redBtnLeft);
//                redBtnRight = (TextView) view.findViewById(R.id.redBtnRight);
//                renewIcon = (ImageView) view.findViewById(R.id.renewIcon);
//            }
//        }
//    }
//
//
//
//
//    public List<NewMessage> getList() {
//        return list;
//    }
//
//    public int getClickPosition() {
//        return clickPosition;
//    }
//
//
//}
