package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;

import java.util.List;

public class NewAllAccountAdapter extends RecyclerView.Adapter<AllAccountRecycleViewHolder> {
    private LayoutInflater mInflater;
    private Activity activity;
    private AllAccountListener allAccountListener;
    /* 列表数据 */
    private List<AccountAllWorkBean> list;
    public static final int TYPE_HEADER_WORKER=1;
    public static final int TYPE_HEADER_FORMAN=2;
    public static final int TYPE_FOTTER=3;
    public static final int TYPE_CENTER=4;
    private String role;
    private boolean startAnim=false;
    private int position=-1;

    public NewAllAccountAdapter(Activity activity, List<AccountAllWorkBean> list, AllAccountListener allAccountListener,String role) {
        mInflater = LayoutInflater.from(activity);
        this.activity = activity;
        this.list = list;
        this.role = role;
        this.allAccountListener = allAccountListener;
    }

    public List<AccountAllWorkBean> getList() {
        return list;
    }

    public void setList(List<AccountAllWorkBean> list) {
        this.list = list;

        notifyDataSetChanged();
    }
    public void setLists(List<AccountAllWorkBean> list) {
        this.list = list;
//        notifyDataSetChanged();
    }
    //尝试解决头像闪烁问题
    //要注意，使用上述代码的话，Adapter中的getItemId要重写成如下，如果仍用super.getItemId(position)，数据刷新会出错
    @Override
    public long getItemId(int position) {
//        return super.getItemId(position);
        return position;
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    @Override
    public int getItemViewType(int position) {
        return list.get(position).getType();

    }

    @Override
    public AllAccountRecycleViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        AllAccountRecycleViewHolder vh;
        switch (viewType) {
            case TYPE_HEADER_WORKER:
                //头部布局,工人
                vh = new ViewHolderAllAccountHeadForman(mInflater.inflate(R.layout.layout_head_all_account_worker, parent, false), activity, allAccountListener);
                break;
            case TYPE_HEADER_FORMAN:
                //头部布局，工头
                vh = new ViewHolderAllAccountHeadWorker(mInflater.inflate(R.layout.layout_head_all_account_forman, parent, false), activity, allAccountListener);
                break;
            case TYPE_FOTTER:
                //底部布局
                vh = new ViewHolderAllAccountFotter(mInflater.inflate(R.layout.layout_footer_all_account, parent, false), activity, allAccountListener);
                break;
            case TYPE_CENTER:
                //中间
                vh = new ViewHolderAllAccountCenter(mInflater.inflate(R.layout.item_all_account, parent, false), activity, allAccountListener,role);
                break;

            default:
                //中间
                vh = new ViewHolderAllAccountCenter(mInflater.inflate(R.layout.item_all_account, parent, false), activity, allAccountListener,role);
                break;
        }
        return vh;
    }

    /**
     *
     * @param start 是否开始动画
     * @param position 0 记点工班组长/工人动画 (工人角色)
     *                 1 单价动画  (4.0.2需求讨论后取消)
     *                 2 承包对象   (班组长角色)
     */
    public void startFlashTips(boolean start,int position){
        LUtils.e("====flashTip"+start+","+position);
        startAnim=start;
        this.position=position;
        notifyDataSetChanged();
    }

    @Override
    public void onBindViewHolder(AllAccountRecycleViewHolder holder, int position) {
        if (holder instanceof ViewHolderAllAccountHeadForman){
            if (this.position==0) {
                ((ViewHolderAllAccountHeadForman) holder).startFlashTips(startAnim);
            }
        }else if (holder instanceof ViewHolderAllAccountCenter){
            if (this.position==1) {
                ((ViewHolderAllAccountCenter) holder).startFlashTips(startAnim);
            }
        }else if (holder instanceof ViewHolderAllAccountHeadWorker){
            if (this.position==2) {
                ((ViewHolderAllAccountHeadWorker) holder).startFlashTips(startAnim);
            }
        }
        holder.bindHolder(position, list);
    }

    public interface AllAccountListener {
        //删除分项
        void deleteSubProject(int position);

        //选择分项名称
        void selectSubProject(int position);

        //选择单位
        void selectCompany(int position);

        //选择记账对象
        void selectRole(int position);

        //选择项目
        void selectProject(int position);

        //选择日期
        void selectDate(int position);

        //设置备注
        void selectRemark(int position);

        //添加分项目
        void addSubProject(int position);
        //选择分项名称
        void modifyAccountType(int type);

        void inputPrice();

        void inputNum();
    }
}
