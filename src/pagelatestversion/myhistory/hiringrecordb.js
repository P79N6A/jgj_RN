/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-08 15:52:06 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-17 14:43:07
 * Module:我的找活
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
    NativeModules,
    DeviceEventEmitter,
    BackHandler
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import LinearGradient from 'react-native-linear-gradient'
import { getFlatternDistance } from '../../utils/distance'
import { NavigationEvents } from 'react-navigation'
import AlertUser from '../../component/alertuser'
import Information from '../../component/information'
import * as _ from "lodash";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        this.isFresh=false
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
            pos: [],

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------

            ifFetchMore:false,
            ifLoadingMore:true,//是否显示加载更多加载框
            overList:false,//没有可以加载的数据
        }
        this.getList = this.getList.bind(this)
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    componentDidMount() {
        this.getList()//我的找活数据
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.getLocation('', (result) => {
                this.setState({
                    pos: result ? result.split(',') : [0, 0]
                })
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.getLocation('', (result) => {
                this.setState({
                    pos: result ? result.split(',') : [0, 0]
                })
            })
        }
    }
    // 我的找活数据
    getList(e) {
		e == 'refresh' && (this.page = 1) //#20816
        let { dataSource } = this.state
        fetchFun.load({
            url: 'jlforemanwork/findjobactive',
            noLoading:true,//不显示自定义加载框
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                contacted: '1',//是否查看已联系列表
                role_type: GLOBAL.userinfo.role//当前角色
            },
            success: (res) => {
                console.log('---我的找活数据---', res)
                this.setState({
                    dataSource: e == 'refresh' ? res.data_list : dataSource.concat(res.data_list),
                    ifFetchMore:true,
                    ifLoadingMore:res.data_list.length<10?false:true,//隐藏正在加载效果
                    overList:res.data_list.length<10 && !(this.state.dataSource.length==0 && res.data_list.length==0)?true:false
                })
            }
        });
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1, }}>
                <NavigationEvents onDidFocus={payload => { console.log(123); this.getList('refresh') }} />
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header data={this.state.dataSource} getList={this.getList} />}//头布局
                    renderItem={({ item }) => <List data={item} position={this.state.pos} alertFun={this.alertFun.bind(this)} getList={this.getList} navigation={this.props.navigation} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigation={this.props.navigation} ifLoadingMore = {this.state.ifLoadingMore} overList={this.state.overList} />}//尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore = {this.state.ifLoadingMore} />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={()=>this.onContentSizeChange}
                />
                {/* 弹框 */}
                <AlertUser gows={this.gows.bind(this)} ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />

            </View>
        )
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this.getList(refresh = 'refresh')
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
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
                    this.isFresh=false;
                    this.getList()
                }
            })
        }
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
}
// 头部布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            showModal: false
        }
    }
    clearContact() {
        fetchFun.load({
            newApi: true,
            url: 'workday/Clear-findjob-record',
            data: {},
            success: (res) => {
                this.props.getList('refresh')
            }
        })
    }
    toggleModal() {
        this.setState({
            showModal: !this.state.showModal
        })
    }
    render() {
        return (
            <>
                {this.props.data.length > 0 ?
                    <View style={{ backgroundColor: '#ebebeb', height: 36, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <View style={{ height: 36, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                            <Text style={{ fontSize: 13, color: '#999' }}>以下是你联系过的工作</Text>
                            <Text onPress={() => this.toggleModal()} style={{ fontSize: 15, color: '#4193DF', marginLeft: 6 }}>[清空]</Text>
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
                                        <Text>您确定要清空所有找活记录吗？</Text>
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
                                            onPress={() => this.clearContact()}
                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>确定</Text>
                                        </TouchableOpacity>
                                    </View>
                                </View>
                            </TouchableOpacity>
                        </Modal>
                    </View> :
                    null
                }
            </>
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

        let distance = ''
        const [lat, lng] = this.props.position;
        if (item.pro_location && item.pro_location[0] > 0 && lat > 0) {
            distance = " / " + parseInt(getFlatternDistance(+lat, +lng, item.pro_location[1], item.pro_location[0])) + "公里";
        }

        return (
            <TouchableOpacity activeOpacity={.7}
                onPress={() => this.listItemClick(item)}
                style={{ backgroundColor: '#fff', paddingLeft: 11, paddingRight: 11, marginBottom: 11,paddingTop:15,paddingBottom:5 }}>
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
                                                        ) : false
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
                                item.is_verified == 1 ? (
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
                                                    source={require('../../assets/recruit/jobverified.png')} ></Image>
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
                    

                </View>

                <View style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                    paddingTop: 5.2, paddingBottom: 5.2
                }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: '#666', fontSize: 14, }}>
                            {item.call_time_txt ? item.call_time_txt : (item.create_time_txt + distance)}
                        </Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => { this.toggleModal() }}
                    >
                        <View style={{
                            borderWidth: .5, borderColor: "#666666",
                            paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                            borderRadius: 4
                        }}>
                            <Text style={{ color: '#333333', fontSize: 12 }}>删除</Text>
                        </View>
                    </TouchableOpacity>
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
                                <Text>您确定要删除该联系记录吗？</Text>
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
                                    onPress={() => this.delCollection(item)}
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
                if (res.pid) {
                    this.props.navigation.navigate('Recruit_jobdetails', { pid: item.pid })
                }
            }
        })
    }
    delCollection(data) {
        fetchFun.load({
            newApi: true,
            url: 'workday/del-findjob-record',
            data: {
                pid: data.pid
            },
            success: (res) => {
                this.props.getList('refresh')
                this.toggleModal()
            }
        })
    }
    toggleModal() {
        this.setState({
            showModal: !this.state.showModal
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
            !this.props.ifLoadingMore?(
                <View style={{ flex: 1, }}>
                    <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{ width: 80, height: 46 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/book.png` }}></Image>
                    </View>
                    <Text style={styles.font}>我的找活数据为空</Text>
                </View>
            ):false
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    font: {
        color: '#666',
        fontSize: 15,
        textAlign: 'center',
    },
    containermain: {
        flex: 1,
        backgroundColor: '#ebebeb',
        alignItems: 'center',
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
        height: 38,
    },
    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 14,
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
    main: {
        borderTopWidth: .5,
        borderTopColor: '#666',
        borderBottomWidth: .5,
        borderBottomColor: '#666',
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end'
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
        // paddingTop: 6,
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
    main: {
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
})