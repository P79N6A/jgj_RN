/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 17:51:45 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 16:23:26
 * Module:找工人-列表
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    StatusBar,
    Platform,
    FlatList,
    RefreshControl,
    DeviceEventEmitter,
    NativeModules
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
// import Empty from '../../component/listempty'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import AlertUser from '../../component/alertuser'
import Thelabel from '../../component/thelabel'
import * as _ from "lodash";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.pagesize = 10
        this.isFresh=false
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

            ifFetchMore: false,
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    // componentWillUnmount() {
    //     this.subscription.remove();
    // }
    componentDidMount() {
        this.getlist()
        // DeviceEventEmitter.addListener("EventType", (param) => {
        //     this.getlist()
        // })
    }
    // 获取列表数据
    getlist(e) {
        fetchFun.load({
            url: 'jlforemanwork/findhelper',
            noLoading: true,//不显示自定义加载框
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                cityno: GLOBAL.cityno,//如果不传，默认是成都
                role_type: GLOBAL.lookworker ? '1' : '2',//查找的角色，1工人，2班组
                work_type: GLOBAL.work_type,//工种
                pro_type: 0,//工程类别
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---找工人列表---', res)
                this.setState({
                    dataSource: e == 'refresh' ? res : this.state.dataSource.concat(res),
                    ifFetchMore: true,
                    ifLoadingMore: res.length < 10 ? false : true,//隐藏正在加载效果
                    // overList:res.length<10 && !(this.state.dataSource.length==0 && res.length==0)?true:false
                }, () => {
                    this.setState({
                        overList: this.state.dataSource.length == 0 ? false : (this.state.ifLoadingMore ? false : true)
                    })
                })
            }
        });
    }
    render() {
        return (
            <View style={styles.main}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => { this.props.navigation.state.params.callback(), this.props.navigation.goBack() }}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>

                        {
                            this.props.navigation.getParam('tjswitch') ? (
                                <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                                    找{GLOBAL.lookworkerSwitch ? '工人' : '班组'}({GLOBAL.zgrType.zgrTypeNameSwitch})
                                    </Text>
                            ) : (
                                    <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                                        找{GLOBAL.lookworker ? '工人' : '班组'}({GLOBAL.zgrType.zgrTypeName})
                                    </Text>
                                )
                        }

                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* title */}
                {
                    this.state.dataSource.length > 0 ? (
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginTop: 7.7, marginBottom: 7.7 }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>以下是 </Text>
                            {/* {
                                this.props.navigation.getParam('tjswitch') ? false : (
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>{GLOBAL.zgrAddress.zgrAddressOneName}</Text>
                                )
                            } */}
                            {
                                this.props.navigation.getParam('tjswitch') ? (
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>{GLOBAL.zgrAddress.zgrAddressTwoNumSwitch}</Text>
                                ) : (
                                        <Text style={{ color: '#000', fontSize: 15.4 }}>{GLOBAL.zgrAddress.zgrAddressTwoName}</Text>
                                    )
                            }
                            <Text style={{ color: '#999', fontSize: 15.4 }}> 的{
                                this.props.navigation.getParam('tjswitch') ? (
                                    <Text>
                                        {GLOBAL.lookworkerSwitch ? '工人' : '班组'}
                                    </Text>
                                ) : (
                                        <Text>
                                            {GLOBAL.lookworker ? '工人' : '班组'}
                                        </Text>
                                    )
                            } </Text>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => this.zgrAddress()}
                                style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>切换城市</Text>
                                <Icon name="refresh" size={15} color="#EB4E4E" />
                            </TouchableOpacity>
                        </View>
                    ) : false
                }

                <View style={{ flex: 1, paddingBottom: 60 }}>
                    {/* 列表组件 */}
                    <ListItem
                        data={this.state.dataSource}
                        ListHeaderComponent={() => <Header />}//头布局
                        renderItem={({ item }) => <List data={item} navigation={this.props.navigation}
                            alertFun={this.alertFun.bind(this)} />}//item显示的布局
                        ListFooterComponent={() => <Footer ifLoadingMore={this.state.ifLoadingMore} overList={this.state.overList} />}//尾布局
                        ListEmptyComponent={() => <Empty navigation={this.props.navigation} zgrAddress={this.zgrAddress.bind(this)} ifLoadingMore={this.state.ifLoadingMore} />}// 空布局
                        onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多
                        onRefresh={() => this._onRefresh()}//下拉刷新相关
                        onContentSizeChange={()=>this.onContentSizeChange}
                    />
                    {/* 底部按钮 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.tofbzgjob()}
                        style={{ backgroundColor: '#fafafa', height: 66, padding: 11, position: 'absolute', bottom: 0, width: '100%', height: 66, borderTopWidth: .5, borderTopColor: '#cccccc' }}>
                        <View style={{ backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 4.4, height: 44 }}>
                            <Text style={{ color: '#fff', fontSize: 18.7 }}>发布招工 让别人来找我</Text>
                        </View>
                    </TouchableOpacity>
                </View>

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
    //选择项目所在地
    zgrAddress() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {
            this.props.navigation.navigate('Address', {
                name: '找工人项目所在地',
                callback: (() => {
                    this.page = 1
                    this.getlist(refresh = 'refresh')
                })
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/cities',
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                    os: GLOBAL.os,
                    token: GLOBAL.userinfo.token,
                    ver: GLOBAL.ver,
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取城市列表-省---', res)
                    GLOBAL.AddressOne = res
                    this.setState({}, () => {
                        this.props.navigation.navigate('Address', {
                            name: '找工人项目所在地',
                            callback: (() => {
                                this.page = 1
                                this.getlist(refresh = 'refresh')
                            })
                        })
                    })
                }
            });
        }
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this.getlist(refresh = 'refresh')
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
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
                    this.getlist()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }
    // 发布招工按钮
    tofbzgjob() {
        if (GLOBAL.userinfo.is_info == 0) {
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
                param: 'wszl'
            })
        }
        else {
            this.props.navigation.navigate('Myrecruit', { name: 'lookingworker' })
        }

    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const item = this.props.data
        return (
            <TouchableOpacity activeOpacity={.7}
                activeOpacity={0.5}
                onPress={() => this.toMy(item)}
            >
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ marginRight: 15 }}>
                                <ImageCom
                                    style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                    fontSize='17.6'
                                    userPic={item.head_pic}
                                    userName={item.real_name}
                                />
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>

                                        {
                                            item.verified == 3 ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFun('user-sm')}>
                                                    <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                                        source={{ uri: `${GLOBAL.server}public/imgs/icon/verified.png` }} ></Image>
                                                </TouchableOpacity>
                                            ) : false
                                        }
                                        {/* <Thelabel name = 'user' verified={item.verified} /> */}

                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                        <Icon name="place" size={15} color="#BFBFBF" />
                                        <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>
                                            {item.current_addr}
                                        </Text>
                                    </View>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11 }}>
                                            {item.nationality}族
                                        </Text>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                            工龄
                                        </Text>
                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, }}>
                                            {item.work_year}
                                        </Text>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11, marginLeft: 3 }}>
                                            年
                                        </Text>
                                        {
                                            this.props.navigation.getParam('role_type') == '2' ? (
                                                <View style={{ flexDirection: 'row' }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                                        队伍
                                                    </Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, }}>
                                                        {item.person_count}
                                                    </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11, marginLeft: 3 }}>
                                                        人
                                                    </Text>
                                                </View>
                                            ) : false
                                        }
                                        {
                                            item.work_level.map((v, index) => {
                                                return (
                                                    <Text key={index} style={{ color: '#666', fontSize: 13.2 }}>
                                                        {v}
                                                    </Text>
                                                )
                                            })
                                        }

                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            {
                                item.pro_type.map((v, index) => {
                                    return (
                                        <View
                                            key={index}
                                            style={{
                                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee',
                                                paddingLeft: 4.4, paddingRight: 4.4,
                                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row',
                                                alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                            }}>
                                            <Text style={{ color: '#666', fontSize: 13.2 }}>{v}</Text>
                                        </View>
                                    )
                                })
                            }

                        </View>

                        {
                            item.introduce !== '' ? (
                                <View style={{ marginTop: 6.6 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }} numberOfLines={1}>
                                        {item.introduce}
                                    </Text>
                                </View>
                            ) : false
                        }

                        {
                            item.friendcount > 0 && this.props.navigation.getParam('role_type') == '2' || item.experience_num > 0 && this.props.navigation.getParam('role_type') == '2' ? (
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    marginTop: 6.6, paddingTop: 11, borderTopWidth: 1, borderTopColor: '#ebebeb'
                                }}>
                                    {
                                        item.friendcount > 0 ? (
                                            <View style={{ flexDirection: 'row' }}>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>你有 </Text>
                                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, lineHeight: 19.8 }}>{item.friendcount}</Text>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}> 个朋友认识他</Text>
                                            </View>
                                        ) : false
                                    }
                                    {
                                        item.experience_num > 0 ? (
                                            <View style={{ flexDirection: 'row' }}>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>他有 </Text>
                                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, lineHeight: 19.8 }}>{item.experience_num}</Text>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}> 条项目经验</Text>
                                            </View>
                                        ) : false
                                    }
                                </View>
                            ) : false
                        }
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    //跳转到个人名片
    toMy(item) {
        this.props.navigation.navigate('Personal_preview', { uid: item.uid, fromTo: 'yzlw', role_type: this.props.navigation.getParam('role_type') })
    }
}
// 空布局
class Empty extends React.Component {
    render() {
        return (
            !this.props.ifLoadingMore ? (
                <View style={{ flex: 1 }}>
                    <View style={{ marginBottom: 21, marginTop: 130, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{ width: 80, height: 46 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/book.png` }}></Image>
                    </View>
                    <Text style={{ color: '#999', fontSize: 15, textAlign: 'center', }}>没有找到相关工人或班组</Text>

                    <View style={{ flexDirection: "row", alignItems: "center", justifyContent: 'center' }}>
                        <Text style={{ color: '#999', fontSize: 15, textAlign: 'center', }}>建议你</Text>
                        <TouchableOpacity activeOpacity={.7} onPress={() => this.props.zgrAddress()}>
                            <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', }}>换个城市</Text>
                        </TouchableOpacity>
                        <Text style={{ color: '#999', fontSize: 15, textAlign: 'center', }}>试试</Text>
                    </View>
                </View>
            ) : false
        )
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1,
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
})