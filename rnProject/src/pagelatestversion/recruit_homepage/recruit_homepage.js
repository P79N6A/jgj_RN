/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 14:58:26 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-11 14:42:39
 * Module:找活招工首页
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Image, Animated, LayoutAnimation, AsyncStorage } from 'react-native';
import Address from '../../component/selectaddress'
import Typeselects from '../../component/typeselects'
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Empty from '../../component/listempty'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import Geolocation from 'Geolocation';
import AlertUser from '../../component/alertuser'

export default class counter extends Component {
    constructor(props) {
        super(props)
        this.state = {
            selectsAddress: false,//address,type,works
            selectsType: false,
            selectsVerified: false,//是否筛选实名信息

            fixeds: true,//控制发布招工按钮的固定定位变量
            moveValue: new Animated.Value(1),
            marginBottom: 0,

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });

    // ---------------城市------------------
    //选择地址菜单(获取城市列表)
    addressfun() {
        if (this.state.selectsAddress) {
            this.setState({
                selectsAddress: false
            })
        } else {
            let _this = this
            fetchFun.load({
                url: 'jlcfg/cities',
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                    os: GLOBAL.os,
                    token: GLOBAL.userinfo.token,
                    ver: GLOBAL.ver,
                },
                success: (res) => {
                    console.log('---获取城市列表-省---', res)
                    if (res.state == 1) {
                        this.setState({
                            selectsAddress: true
                        }, () => {
                            GLOBAL.AddressOne = res.values
                            this.setState({})
                        })
                    }
                }
            });
        }
    }
    //关闭城市组件
    offAddress() {
        this.setState({
            selectsAddress: false,
        })
    }

    // ---------------工种-----------------
    // 选择工种菜单(获取工种列表)
    typefun() {
        if (this.state.selectsType) {
            this.setState({
                selectsType: false
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/classlist',
                data: {
                    class_id: 1,//1:工种 2：项目类型3：熟练度 31：福利 40：举报信息类型
                    // os: GLOBAL.os,
                    // token: GLOBAL.userinfo.token,
                    // ver: GLOBAL.ver,
                },
                success: (res) => {
                    console.log('---获取工种列表---', res)
                    if (res.state == 1) {
                        this.setState({
                            selectsType: true
                        }, () => {
                            GLOBAL.typeArr = res.values
                            this.setState({})
                        })
                    }
                }
            });
        }
    }
    // 关闭工种组件
    offType() {
        this.setState({
            selectsType: false,
        })
    }

    // ---------------实名-----------------
    // 选择是否实名信息
    verifiedFun() {
        this.setState({
            selectsVerified: !this.state.selectsVerified
        })
    }

    render() {
        let { moveValue } = this.state

        return (
            <View style={styles.containermain}>

                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }
                }>
                    <View style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, width: '25%' }} >
                    </View>
                    < View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', marginRight: 3 }}>找工作</Text>
                        < TouchableOpacity onPress={() => this.props.navigation.navigate('Recruit_doubt')}>
                            <Icon name="question-circle" size={19} color="#999" />
                        </TouchableOpacity>
                    </View>
                    < TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                        onPress={() => this.props.navigation.navigate('Recruit_cheat')}>
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>防骗指南</Text>
                    </TouchableOpacity>
                </View>

                {/* 菜单 */}
                <View style={
                    {
                        backgroundColor: 'white',
                        paddingBottom: this.state.fixeds ? 15 : 0,
                        marginBottom: this.state.fixeds ? 10 : 0,
                        height: this.state.fixeds ? 104 : 0,
                    }
                } >
                    <View style={styles.bot}>
                        <TouchableOpacity
                            style={styles.munuss}
                            onPress={() => this.props.navigation.navigate('Lookingworker')}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/search.png')} ></Image>
                            < Text style={styles.menufont} >找工人</Text>
                        </TouchableOpacity>
                        < TouchableOpacity
                            onPress={() => this.props.navigation.navigate('Workteam')}
                            style={styles.munuss} >
                            <Image style={styles.menuimg} source={require('../../assets/recruit/labor.png')} ></Image>
                            < Text style={styles.menufont} >工人/班组</Text>
                        </TouchableOpacity>
                        < TouchableOpacity
                            onPress={() => this.props.navigation.navigate('Recruit_play')}
                            style={styles.munuss} >
                            <Image style={styles.menuimg} source={require('../../assets/recruit/service.png')} ></Image>
                            < Text style={styles.menufont} >招聘服务</Text>
                        </TouchableOpacity>
                        < TouchableOpacity
                            style={styles.munuss}
                            onPress={() => this.props.navigation.navigate('Myhistory')}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/my-job.png')} ></Image>
                            < Text style={styles.menufont} >我的招聘</Text>
                        </TouchableOpacity>
                    </View>
                </View>

                {/* 轻松找活、立即认证 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Recruit_authen')}
                    style={{
                        backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 23, paddingRight: 29,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                    }}>
                    <Text style={{ fontSize: 13, color: '#FF6600' }}>轻松找活！完成认证，让用工方主动来找你</Text>
                    < Text style={{ fontSize: 13, color: '#FF6600' }}>立即认证</Text>
                </TouchableOpacity>

                {/* 选择栏 */}
                <View style={{ marginBottom: -.5, backgroundColor: '#fafafa', borderTopColor: '#dbdbdb', borderTopWidth: 1, height: 44, width: '100%', flexDirection: 'row', zIndex: 1000 }}>
                    <TouchableOpacity
                        onPress={() => { this.addressfun() }}
                        style={{ width: '33.33%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'address' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'address' ? 0 : 1, }}>
                        <Text style={{ color: '#666', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzAddress.zgzAddressTwoName}</Text>
                        {
                            !this.state.selectsAddress ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }
                                } name="rd-arrow" size={13} color="#999999" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#999999" />
                                )
                        }
                    </TouchableOpacity>
                    < TouchableOpacity
                        onPress={() => { () => this.typefun() }}
                        style={{ width: '33.33%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'type' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'type' ? 0 : 1 }}>
                        <Text style={{ color: '#666', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzType.zgzTypeName}</Text>
                        {
                            !this.state.selectsType ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }
                                } name="rd-arrow" size={13} color="#999999" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#999999" />
                                )
                        }
                    </TouchableOpacity>
                    < TouchableOpacity
                        onPress={() => { this.verifiedFun() }}
                        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, backgroundColor: '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: 1 }}>
                        {
                            this.state.selectsVerified ? (
                                <Icon style={{ marginRight: 3 }} name="success" size={14} color="#eb4e4e" />
                            ) : (
                                    <Image style={{ width: 16, height: 16, marginRight: 3 }} source={require('../../assets/recruit/yuan.png')} ></Image>
                                )
                        }
                        <Text style={{ color: '#666', fontSize: 13, marginRight: 3 }}>只看实名信息</Text>
                    </TouchableOpacity>
                </View>
                {
                    this.state.selectsAddress ? (
                        <Address
                            offAddress={this.offAddress.bind(this)}
                            addressType='找工作' />
                    ) : (
                            this.state.selectsType ? (
                                <Typeselects
                                    offType={this.offType.bind(this)}
                                    addressType='找工作'
                                />
                            ) : (
                                    <List navigate={this.props.navigation}
                                        selectsVerified={this.state.selectsVerified}
                                        fixedsupdateF={this.fixedsupdateF.bind(this)}
                                        fixedsupdateT={this.fixedsupdateT.bind(this)}
                                        alertFun={this.alertFun.bind(this)} />
                                )
                        )
                }

                <Animated.View                 // 使用专门的可动画化的View组件
                    style={
                        {
                            bottom: moveValue.interpolate({
                                inputRange: [0, 1],
                                outputRange: [0, 120]
                            }),
                        }
                    }
                >
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Myrecruit')}
                        style={{
                            position: 'absolute', marginLeft: -72,
                        }}
                    >
                        <View
                            style={
                                {
                                    backgroundColor: '#ec5e5e', flexDirection: 'row', alignItems: 'center',
                                    justifyContent: "center", borderRadius: 176.6, width: 143.5, height: 50,
                                    // 设置阴影
                                    elevation: 3,
                                    shadowOffset: { width: 3, height: 3 },
                                    shadowColor: 'black',
                                    shadowOpacity: 1,
                                    shadowRadius: 2
                                }
                            }>
                            {/*<Icon name="" size={} color="" />*/}
                            < Icon style={{ marginLeft: 5 }} name="plus" size={20} color="#fff" />
                            <Text style={{ fontSize: 16.5, color: '#fff', marginLeft: 10 }}>发布招工</Text>
                        </View>
                    </TouchableOpacity>
                </Animated.View>

                {/* 弹框 */}
                <AlertUser ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />
            </View>
        );
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
    // 动画函数
    adimatedFun() {
        this.toValue = this.state.fixeds ? 1 : 0
        Animated.timing(
            this.state.moveValue,  // 初始化从0开始
            {
                toValue: this.toValue, // 目标值
                duration: 300,         // 时间间隔
            }
        ).start()
    }
    fixedsupdateF() {
        this.setState({
            fixeds: false
        }, () => {
            this.adimatedFun()
        })
    }
    fixedsupdateT() {
        this.setState({
            fixeds: true
        }, () => {
            this.adimatedFun()
        })
    }
}

// 工作列表数据
class List extends React.Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.state = {
            // 列表数据结构
            dataSource: [],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            scrollheight: 0,//滚动页面初始高度
        }
    }
    componentWillReceiveProps(nextProps) {//父组件是否实名改变，这里重新获取列表数据
        this.setState({
            selectsVerified: nextProps.selectsVerified
        }, () => {
            this.getList()
        })
    }
    componentWillMount() {
        this.timeDiffer()//获取服务器时间差
        this.setState({
            navigate: this.props.navigation,//页面跳转需要
            selectsVerified: this.props.selectsVerified
        }, () => {
            this.getList()
        })
        this.getPosition();
    }
    //获取服务器时间差
    timeDiffer() {
        fetchFun.load({
            url: 'v2/signup/userstatus',
            data: {
                // timestamp:'1554189847',
                // sign:'7778b7fa0b86ddbe60fb0ed8a6544527dc337aa8'
            },
            success: (res) => {
                if (res.state == 1) {
                    GLOBAL.timeDifference = res.values.serverTime * 1000 - Date.parse(new Date())
                    this.setState({})
                    console.log('---服务器时间---', res)
                }
            }
        });
    }
    //获取列表数据方法
    getList() {
        fetchFun.load({
            url: 'jlforemanwork/findjobactive',
            data: {
                // os: GLOBAL.os,
                // token: GLOBAL.userinfo.token,
                // ver: GLOBAL.ver,//版本号
                pg: '1',//分页页码
                pagesize: '10',//分页每页显示条数
                city_no: GLOBAL.zgzAddress.zgzAddressTwoNum,//城市
                is_all_area: GLOBAL.zgzAddress.zgzAddressTwoNum ? '0' : '1',//如果看全国的数据传1
                work_type: GLOBAL.zgzType.zgzTypeNum,//工种
                is_verified: this.state.selectsVerified ? '1' : '0',//是否实名:1已实名,0未实名
                // timestamp = parseInt((Date.parse(new Date()) + props.userInfo.timeDifference) / 1000),//时间戳
                // pro_type: '-1',//工程类别(默认)
                // role_type: '1',//当前角色(默认)
                // contacted: '0',//是否查看已联系列表
                // client_type: 'person',//平台类型 person 个人端 manage 管理端
                // sign: 'df0ea3b032b382a3f443e349cadf712e76cf8dd9',//签名字符串
            },
            success: (res) => {
                if (res.state == 1) {
                    this.setState({
                        dataSource: res.values.data_list
                    })
                    console.log('---招工列表---', res.values.data_list)
                }
            }
        });
    }
    /** 获取地理位置（经纬度） */
    getPosition() {
        //获取经纬度
        Geolocation.getCurrentPosition(
            location => {
                var result = "\n经度：" + location.coords.longitude +
                    "\n纬度：" + location.coords.latitude +
                    alert(result);
            },
            error => {
                alert("获取位置失败：" + error)
            }
        )
    }
    render() {
        return (
            <View style={{ flex: 1, width: '100%' }
            }>
                {/* 列表组件 */}
                < ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.props.navigate} />} // 头布局
                    renderItem={({ item }) => <Lists data={item} navigate={this.props.navigate} alertFun={this.props.alertFun.bind(this)} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.props.navigate} />}// 尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onScrollEndDrag={() => this.onScrollEndDrag.bind(this)}//一个子view滚动结束拖拽时触发
                />
            </View>
        )
    }
    // 一个子view滚动结束拖拽时触发
    onScrollEndDrag(e) {
        if (e.nativeEvent.contentOffset.y > this.state.scrollheight) {//向下滚动，按钮隐藏
            this.setState({
                scrollheight: e.nativeEvent.contentOffset.y,
            }, () => {
                this.props.fixedsupdateF()
            })
        } else {//向上滚动，按钮显示
            this.setState({
                scrollheight: e.nativeEvent.contentOffset.y,
            }, () => {
                this.props.fixedsupdateT()
            })
        }
    }
    // 获取数据列表
    _getHotList() {
        this.state.isLoadMore = true
        // fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
        //     .then((response) =>response.json())
        //     .then((responseJson) =>{
        //         console.log(responseJson)
        //         if (this.page === 1) {
        //             console.log("重新加载")
        //             this.setState({
        //                 isLoadMore: false,
        //                 dataSource: responseJson.list
        //             })
        //         } else {
        //             console.log("加载更多")
        //             this.setState({
        //                 isLoadMore: false,
        //                 // 数据源刷新 add
        //                 dataSource: this.state.dataSource.concat(responseJson.list)
        //             })
        //             if (this.page<= 3) {
        //                 this.setState({
        //                     showFoot: 1
        //                 })
        //             } else if (this.page >3) {
        //                 this.setState({
        //                     showFoot: 2
        //                 })
        //             }
        //         }


        //     })
        //     .catch((error) =>{
        //         console.error(error);
        //     });
    }

    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this._getHotList()
        }
    };

    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            this._getHotList()
        }
    }
}

// item布局
class Lists extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const item = this.props.data
        return (
            <TouchableOpacity
                onPress={() => this.listItemClick(item)
                }
                style={styles.information} >
                <View style={styles.head}>
                    <View style={styles.headl}>
                        <View style={
                            {
                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                marginRight: 7, backgroundColor: '#eb7a4e', paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                paddingBottom: 1, borderRadius: 8
                            }
                        }><Text style={{ color: '#fff', fontSize: 12 }}>{item.classes[0].cooperate_type.type_name}</Text></View >
                        {/* <Text style={{ fontSize: 16, color: '#000' }}>{item.pro_title}</Text> */}
                        <Text style={{ fontSize: 16, color: '#000' }}>
                            {item.pro_title ? (item.pro_title.length > 10 ? item.pro_title.substr(0, 10) + "..." : item.pro_title) : ""}
                        </Text>

                        {
                            item.is_verified == 1 ? (
                                <TouchableOpacity
                                    onPress={() => this.props.alertFun('sm')}>
                                    <Image style={{ width: 51, height: 18, marginLeft: 8 }}
                                        source={require('../../assets/recruit/jobverified.png')} ></Image>
                                </TouchableOpacity>
                            ) : false
                            // (
                            // <Icon style={{ marginLeft: 8 }} name="certification" size={19} color="#eb4e4e" />
                            // )
                        }
                    </View>
                    < View style={styles.headr} ><Text>{item.classes[0].pro_type.type_name}</Text></View >
                </View>
                < View style={styles.main} >
                    <View style={{ height: 41, flexDirection: 'row', alignItems: 'center' }}>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>人数：</Text>
                            < Text style={{ color: '#EB4E4C', fontSize: 14 }}>{item.classes[0].person_count}</Text>
                            < Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>人</Text>
                        </View>
                        < View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>工资：</Text>
                            {
                                item.classes[0].max_money ? (
                                    <Text style={{ color: '#EB4E4C', fontSize: 14 }
                                    }>{item.classes[0].money}~{item.classes[0].max_money}</Text>
                                ) : (<Text style={{ color: '#EB4E4C', fontSize: 14 }}>{item.classes[0].money}</Text>)
                            }
                            <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>元/天</Text>
                        </View>
                    </View>
                    < View style={{ flexDirection: "row" }}>
                        <View style={{ flex: 1 }}>
                            <Text style={{ color: "#999", fontSize: 14, lineHeight: 20 }}>
                                {item.pro_description}
                            </Text>
                        </View>
                        < View style={{ flexDirection: 'row', justifyContent: "center", alignItems: 'center' }}>
                            <Icon name="r-arrow" size={12} color="#000" />
                        </View>
                    </View>

                    {
                        item.welfare && item.welfare.length > 0 ? (
                            < View style={{ marginBottom: 6.5, marginTop: 6.5, flexDirection: 'row' }}>
                                <Text style={{ fontSize: 14, color: '#000', marginTop: 3.2 }}>待遇：</Text>
                                < View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                    {
                                        item.welfare.map((item, index) => {
                                            return (
                                                <View key={index} style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }
                                                }>
                                                    <Text style={{ fontSize: 12, color: '#333' }} >{item}</Text>
                                                </View>
                                            )
                                        })
                                    }
                                </View>
                            </View>
                        ) : (
                                <View style={{ marginBottom: 5 }}></View>
                            )
                    }

                </View>
                < View style={styles.foot} >
                    <Text style={{ color: '#999', fontSize: 12 }}>
                        {item.create_time_txt} / 64公里
               </Text>
                </View>
            </TouchableOpacity>
        )
    }
    listItemClick(item) {
        this.props.navigate.navigate('Recruit_jobdetails', { pid: item.pid })
    }
}

const styles = StyleSheet.create({
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
        borderTopColor: '#999',
        borderBottomWidth: .5,
        borderBottomColor: '#999',
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
        paddingLeft: 20,
        paddingRight: 20,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'center',
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
        borderTopColor: '#999',
        borderBottomWidth: .5,
        borderBottomColor: '#999',
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-start'
    },
})