/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-08 15:52:06 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-17 14:42:58
 * Module:我的招工
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,
    Platform,
    FlatList,
    RefreshControl,
    Modal,
    DeviceEventEmitter,
    NativeModules
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import { Toast } from '../../component/toast'
import LinearGradient from 'react-native-linear-gradient'
import AlertUser from '../../component/alertuser'
import { openWebView } from '../../utils'
import { NavigationEvents } from 'react-navigation'
import Information from '../../component/information'
import * as _ from "lodash";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        this.isFresh = false
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------

            ifFetchMore: false,//是否请求完成
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, { trailing: false });
        this.getList = this.getList.bind(this)
    }
    componentDidMount() {
        this.getList()//我的招工数据
        // 事件监听
        DeviceEventEmitter.addListener("hiringrecordaList", () => {
            // 底部导航控制
            // this.getList()
        })
    }
    // 我的招工数据
    getList(e) {
        e == 'refresh' && (this.page = 1) //#20816
        let { dataSource } = this.state
        fetchFun.load({
            url: 'jlforemanwork/getselfproliststandard',
            noLoading: true,//不显示自定义加载框
            data: {
                pg: this.page,
                pagesize: this.pagesize
            },
            success: (res) => {
                console.log('---我的招工数据---', res)
                this.setState({
                    dataSource: e == 'refresh' ? res : dataSource.concat(res),
                    ifFetchMore: true,
                    ifLoadingMore: res.length < 10 ? false : true,//隐藏正在加载效果
                    overList: res.length < 10 && !(this.state.dataSource.length == 0 && res.length == 0) ? true : false
                }, () => {
                    // 名片页面用
                    GLOBAL.getselfproliststandard = [...this.state.dataSource]
                })
                setTimeout(()=>{
                    this.isFresh=true;
                },1000)
            }
        });
    }
    render() {
        let { dataSource } = this.state
        // console.log(dataSource)
        return (
            <View style={{ backgroundColor: '#fff', flex: 1, paddingBottom: 60 }}>
                {/* <NavigationEvents onDidFocus={payload => this.getList('refresh')} /> */}
                {/* 列表组件 */}
                <ListItem
                    hasBtn
                    data={dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} navigation={this.props.navigation} getList={this.getList} alertFun={this.alertFun.bind(this)} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigation={this.props.navigation} ifLoadingMore={this.state.ifLoadingMore} overList={this.state.overList} />}//尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore={this.state.ifLoadingMore} />}// 空布局
                    onEndReached={() => setTimeout(() => { this._onLoadMore() }, 500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={() => this.onContentSizeChange}
                />

                {/* 底部按钮 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.tofbzgjob()}
                    style={{ backgroundColor: '#fafafa', height: 66, padding: 11, position: 'absolute', bottom: 0, width: '100%', height: 66, borderTopWidth: .5, borderTopColor: '#cccccc' }}>
                    <View style={{ backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 4.4, height: 44 }}>
                        <Text style={{ color: '#fff', fontSize: 18.7 }}>发布招工</Text>
                    </View>
                </TouchableOpacity>

                {/* 弹框 */}
                <AlertUser gows={this.gows.bind(this)} ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />

            </View>
        )
    }
    // 跳转到完善资料页面
    gows() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/info?perfect=1');//调用原生方法
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.openWebView('my/info?perfect=1');//调用原生方法
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
            })
        }
    }
    // ----------实名or认证、突击弹框----------
    alertFun(e) {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
            param: e,
        })
    }
    alertFunr() {
        this.setState({
            ifOpenAlert: false
        })
    }
    // --------------------------------------
    // 发布招工按钮
    tofbzgjob() {
        if (GLOBAL.userinfo.is_info == 0) {
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
                param: 'wszl'
            })
        }
        else {
            this.props.navigation.navigate('Myrecruit', { name: 'name' })
        }

    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this.getList(refresh = 'refresh')
        }
    };
    onContentSizeChange = () => {
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }
    // 加载更多
    _onLoadMore() {
        if (this.isFresh) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh = false;
                    this.getList()
                }
            })
        }
    }
}
// 头部布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fdf1e0', padding: 6.6, flexDirection: "row", justifyContent: 'center' }}>
                <View>
                    <Text style={{ color: '#FF6600', fontSize: 13.2, fontWeight: '400' }}>1、经常刷新招工信息能够让你的招工信息更靠前</Text>
                    <Text style={{ color: '#FF6600', fontSize: 13.2, fontWeight: '400' }}>2、若工人已招满，请及时停止招工</Text>
                </View>
            </View>
        )
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            showModal: false
        }
    }
    render() {
        const item = this.props.data
        return (
            <TouchableOpacity activeOpacity={.7}
                onPress={() => this.listItemClick(item)
                }
                style={styles.information} >

                {/* 停止招工标识 */}
                {
                    item.is_closed == 1 ? (
                        <Image style={{ width: 88, height: 66, position: 'absolute', right: 20, top: '30%' }} source={require('../../assets/recruit/stop.png')}></Image>
                    ) : false
                }

                {/* 右箭头-进入详情 */}
                <Icon style={{ position: "absolute", right: 10, top: '50%' }} name="r-arrow" size={12} color="#000" />



                <View style={styles.head}>
                    <View style={styles.headl}>
                        {
                            item.classes ? (
                                item.classes[0].cooperate_type ? (
                                    item.classes[0].cooperate_type.type_name ? (
                                        item.classes[0].cooperate_type.type_name == '突击队' ? (
                                            <LinearGradient colors={['#9c16ca', '#5612BC',]}
                                                start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                style={{
                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                    marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                    paddingBottom: 1, borderRadius: 9
                                                }}>
                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                    {item.classes[0].cooperate_type.type_name}
                                                </Text>
                                            </LinearGradient>
                                        ) : (
                                                item.classes[0].cooperate_type.type_name == '点工' ? (
                                                    <LinearGradient colors={['#f97547', '#F53055',]}
                                                        start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                        style={{
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                            marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                            paddingBottom: 1, borderRadius: 9
                                                        }}>
                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                            {item.classes[0].cooperate_type.type_name}
                                                        </Text>
                                                    </LinearGradient>
                                                ) : (
                                                        item.classes[0].cooperate_type.type_name == '包工' ? (
                                                            <LinearGradient colors={['#4DBDEC', '#1259EA',]}
                                                                start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                style={{
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                    marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                    paddingBottom: 1, borderRadius: 9
                                                                }}>
                                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                    {item.classes[0].cooperate_type.type_name}
                                                                </Text>
                                                            </LinearGradient>
                                                        ) : (
                                                                item.classes[0].cooperate_type.type_name == '总包' ? (
                                                                    <LinearGradient colors={['#f97547', '#F53055',]}
                                                                        start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                        style={{
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                            marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                            paddingBottom: 1, borderRadius: 9
                                                                        }}>
                                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                            {item.classes[0].cooperate_type.type_name}
                                                                        </Text>
                                                                    </LinearGradient>
                                                                ) : false
                                                            )
                                                    )
                                            )
                                    ) : false
                                ) : false
                            ) : false
                        }

                        <View style={{ flexDirection: "row", alignItems: "center", }}>
                            <Text style={{ fontSize: 17, color: '#000', overflow: 'hidden', fontWeight: '400' }}>
                                {item.pro_title ? (item.pro_title.length > 10 ? item.pro_title.substr(0, 8) + "..." : item.pro_title) : ""}
                            </Text>

                            {
                                GLOBAL.userinfo.verified == 3 ? (
                                    item.is_company_auth == '2' ? (
                                        <TouchableOpacity activeOpacity={.7}
                                            onPress={() => this.props.navigation.navigate('Recruit_rzdetailpage')}>
                                            <Image style={{ width: 18, height: 17, marginLeft: 5, marginTop: 2 }}
                                                source={{ uri: `${GLOBAL.server}public/imgs/icon/company_auth.png` }}></Image>
                                        </TouchableOpacity>
                                    ) : (
                                            <TouchableOpacity activeOpacity={.7}
                                                onPress={() => this.props.alertFun('information-sm')}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                                    source={{ uri: `${GLOBAL.server}public/imgs/icon/jobverified.png` }} ></Image>
                                            </TouchableOpacity>
                                        )
                                ) : false
                            }
                        </View>
                    </View>
                    {
                        item.classes ? (
                            item.classes[0].pro_type ? (
                                item.classes[0].pro_type.type_name ? (
                                    < View style={styles.headr} ><Text style={{ fontSize: 12, color: '#666666' }}>{item.classes[0].pro_type.type_name}</Text></View >
                                ) : false
                            ) : false
                        ) : false
                    }
                </View>

                < View style={styles.main} >

                    {/* 字段显示组件 */}
                    <Information item={item} />

                    <View style={{ flex: 1, height: .5, backgroundColor: 'rgba(219,219,219,1)', marginTop: 12 }}>
                    </View>
                    <View style={{
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                        marginTop: 10, marginBottom: 10
                    }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={
                                    () => this.stateProject('handle', {
                                        pid: item.pid,
                                        pwd_id: item.pwd_id,
                                        is_closed: item.is_closed == 1 ? 0 : 1
                                    })
                                }
                            >
                                <View
                                    style={{
                                        borderWidth: .5, borderColor: "#666666",
                                        marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                                        borderRadius: 2
                                    }}
                                >
                                    <Text style={{ color: '#333333', fontSize: 12 }}>{item.is_closed == 1 ? '重新发布' : '停止招工'}</Text>
                                </View>
                            </TouchableOpacity>
                            {item.is_closed == 0 ?
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={
                                        () => this.stateProject('fresh', {
                                            pid: item.pid
                                        })
                                    }
                                >
                                    <View
                                        style={{
                                            borderWidth: .5, borderColor: "#666666",
                                            marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                                            borderRadius: 2
                                        }}
                                    >
                                        <Text style={{ color: '#333333', fontSize: 12 }}>刷新</Text>
                                    </View>
                                </TouchableOpacity> :
                                null
                            }
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => {
                                    this.stateProject('edit', {
                                        // pid: item.pid,
                                        // work_type: item.classes[0].work_type.type_id,
                                        item
                                    })
                                }}
                            >
                                <View
                                    style={{
                                        borderWidth: .5, borderColor: "#666666",
                                        marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                                        borderRadius: 2
                                    }}
                                >
                                    <Text style={{ color: '#333333', fontSize: 12 }}>修改</Text>
                                </View>
                            </TouchableOpacity>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => this.stateProject('remove_confirm', {
                                    pid: item.pid
                                })}
                            >
                                <View
                                    style={{
                                        borderWidth: .5, borderColor: "#666666",
                                        marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                                        borderRadius: 2
                                    }}
                                >
                                    <Text style={{ color: '#333333', fontSize: 12 }}>删除</Text>
                                </View>
                            </TouchableOpacity>
                        </View>
                        {item.role_type != 3 ?
                            <TouchableOpacity activeOpacity={.7}
                                style={{
                                    paddingLeft: 11, paddingTop: 3, paddingBottom: 3,
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                }}
                                onPress={() => this.stateProject('search', item)}
                            >
                                {/* <Icon name="peoples" size={16} color="#EB4E4E" /> */}
                                <Image style={{ width: 20, height: 20, }} source={require('../../assets/recruit/friend.png')} ></Image>
                                <Text style={{ color: '#000', fontSize: 15.4, fontWeight: '400', marginLeft: 6 }}>合适的{item.role_type == 2 ? '班组' : '人'}</Text>
                            </TouchableOpacity> :
                            null
                        }
                    </View>
                </View>

                <Modal
                    visible={this.state.showModal}
                    animationType="none"//从底部划出
                    transparent={true}//透明蒙层
                    onRequestClose={() => this.toggleModal()}//点击返回的回调函数
                    style={{ height: '100%' }}
                >
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.toggleModal()}
                        style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        {/* 弹窗内容 */}
                        <View style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                            <View style={{ padding: 16.5, minHeight: 100, justifyContent: 'center', alignItems: 'center' }}>
                                <Text>确定要删除该招工信息吗？</Text>
                            </View>
                            {/* 按钮 */}
                            <View style={{
                                flexDirection: 'row', alignItems: 'center',
                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                            }}>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.toggleModal()}
                                    style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                    }}>
                                    <Text style={{ color: '#000', fontSize: 16.5 }}>取消</Text>
                                </TouchableOpacity>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.stateProject('remove', {
                                        pid: item.pid
                                    })}
                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>确定</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    </TouchableOpacity>
                </Modal>
            </TouchableOpacity>
        )
    }
    listItemClick(item) {
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            data: {
                pid: item.pid,
                work_type: item.classes[0].work_type.type_id
            },
            success: (res) => {
                // if (res.pid) {
                //     this.props.navigation.navigate('Myrecruit_detailshow', { pid: item.pid, work_type: item.classes[0].work_type.type_id,is_closed:item.is_closed,callback: (() => {
                //         this.props.getList()
                //     }) })
                //     // this.props.navigation.navigate('Recruit_jobdetails', { pid: item.pid })
                // }
                if (res.pid) {
                    this.props.navigation.navigate('Myrecruit_detailshow', {
                        pid: item.pid,
                        work_type: item.classes[0].work_type.type_id,
                        is_closed: item.is_closed,
                        pwd_id: item.pwd_id,
                        callback: (() => {
                            this.props.getList('refresh')
                        })
                    })
                    // this.props.navigation.navigate('Recruit_jobdetails', { pid: item.pid })
                }
            }
        })
    }
    stateProject(type, actData) {
        // if (type != "search") {
        //     if (!isUserInfo(this.props, {perfect: true})) {
        //         return false;
        //     }
        // }
        // const {rPara1} = this.props;
        switch (type) {
            case 'handle':
                fetchFun.load({
                    url: 'jlforemanwork/operateProject',
                    data: {
                        pwd_id: actData.pwd_id,
                        pid: actData.pid,
                        status: actData.is_closed || 0
                    },
                    success: (res) => {
                        Toast.show(actData.is_closed ? '招工已停止' : '招工已重新发布')
                        this.props.getList('refresh')
                    }
                })

                break;
            case 'fresh':
                fetchFun.load({
                    url: 'jlwork/refresh',
                    data: {
                        pid: actData.pid
                    },
                    success: (res) => {
                        Toast.show('刷新成功')
                    }
                })
                break;
            case 'remove':
                this.toggleModal()
                fetchFun.load({
                    url: 'jlforemanwork/sliceproject',
                    data: {
                        pid: actData.pid
                    },
                    success: (res) => {
                        this.props.getList('refresh')
                    }
                })
                break;
            case 'remove_confirm':
                this.toggleModal()
                // this.props.SynData({
                //     isShow: true,
                //     text: '确定要删除该招工信息吗？',
                //     callback: this.StateProject.bind(this, 'remove', actData),
                //     mold: "confirm"
                // }, "SYN_REMINDER");
                break;
            case 'edit':
                // console.log(actData.item)
                let pid = actData.item.pid
                let work_type = actData.item.classes[0].work_type.type_id
                // 兼容下面的GLOBAL参数
                if (pid) {
                    GLOBAL.pid = pid
                    GLOBAL.fbzgType.fbzgTypeNum = work_type
                }
                fetchFun.load({
                    url: 'jlwork/prodetailactive',
                    data: {
                        pid: GLOBAL.pid,
                        work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号
                        kind: 'recruit'
                    },
                    success: (res) => {
                        console.log('---项目详情---', res)
                        this.props.navigation.navigate('Myrecruit_detail', {
                            // work_type: actData.work_type,
                            // pid: actData.pid
                            item: res,
							edit:'edit',
							callback: (() => {
								// #20901
								this.props.getList('refresh')
							})
                        })
                    }
                });
                break;
            case 'search':
                openWebView('job/search', {
                    role_type: actData.role_type,
                    work_type: actData.classes[0].work_type.type_id,
                    work_name: actData.classes[0].work_type.type_name,
                    city_no: actData.city_no,
                    city_name: actData.city_name,
                    pid: actData.pid,
                    isProject: 1
                })
                // this.props.navigation.navigate('Myrecruit_suit', {
                //     role_type: actData.role_type,
                //     work_type: actData.classes[0].work_type.type_id,
                //     work_name: actData.classes[0].work_type.type_name,
                //     city_no: actData.city_no,
                //     city_name: actData.city_name,
                //     pid: actData.pid,
                //     isProject: 1
                // })
                break;
            default:
                return false
        }
    }
    toggleModal() {
        let { showModal } = this.state
        this.setState({
            showModal: !showModal
        })
    }
}
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            !this.props.ifLoadingMore ? (
                <View style={{ flex: 1, }}>
                    <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{ width: 80, height: 46 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/book.png` }}></Image>
                    </View>
                    <Text style={styles.font}>你还没有发布招工信息</Text>
                </View>

            ) : false
        )
    }
}



const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
    containermain: {
        flex: 1,
        backgroundColor: '#ebebeb',
        alignItems: 'center',
    },

    main: {
        // borderTopWidth: .5,
        // borderTopColor: '#999',
        // borderBottomWidth: .5,
        // borderBottomColor: '#999',
    },
    top: {
        flexDirection: 'row'
    },
    bot: {
        flexDirection: 'row',
        marginTop: 22
    },
    munuss: {
        width: '25%',
        height: 70,
    },
    munussb: {
        width: '25%',
        height: 70,
        paddingLeft: 20,
        paddingRight: 20,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'center',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb'
    },
    menuimg: {
        width: 42,
        height: 42,
        marginBottom: 7.5,
    },
    menufont: {
        fontSize: 13,
        color: '#000',
    },
    information: {
        paddingLeft: 15,
        paddingRight: 15,
        marginBottom: 15,
        backgroundColor: 'white',
    },
    head: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "space-between",
        paddingTop: 15,
        paddingBottom: 6,
    },
    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 12,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
})