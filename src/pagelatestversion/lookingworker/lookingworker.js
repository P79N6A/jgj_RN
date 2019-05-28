/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 17:40:41 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-17 14:35:59
 * Module:找工人
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    NativeModules,
    DeviceEventEmitter,
    Platform,
    BackHandler,
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import Loading from '../../component/loading'

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.pagesize = 10
        this.state = {
            lookworker: true,//找工人还是找班组，true为找工人
            historyArr: [],//搜索记录

            openAlert: false,//加载弹框
            warning: '请选择所需工种',
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentDidMount() {
        console.log(GLOBAL.userinfo)
        // 底部导航控制
        this.bottomTab()
        this.history()//搜索历史记录

        // 获取原生经纬度
        this.getLocation()

        // android返回start==================================
        BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
    }
    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
    }
    onBackButtonPressAndroid = () => {
        if (this.props.navigation.isFocused()) {
            if (this.lastBackPressed && this.lastBackPressed + 2000 >= Date.now()) {
                //最近2秒内按过back键，可以退出应用。
                return false;
            }
            this.lastBackPressed = Date.now();
            this.props.navigation.goBack(), DeviceEventEmitter.emit("EventType", param)
            return true;
        }
    }
    // android返回end====================================================

    // 获取原生经纬度
    getLocation() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.getLocation('', (result) => {
                this.setState({
                    pos: result ? result.split(',') : [0, 0]
                }, () => {
                    this.cityName()
                })
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.getLocation('', (result) => {
                // this.setState({
                //     pos: result ? result.split(',') : [0, 0]
                // }, () => {
                //     this.cityName()
                // })
                let arr = [JSON.parse(result).lat, JSON.parse(result).lng];
                if (result) {
                    this.setState({
                        pos: arr
                    }, () => {
                        this.cityName()
                    })
                }
            })
        }
    }
    // 根据经纬度获取城市名称
    cityName() {
        var longitude = this.state.pos[0];
        var latitude = this.state.pos[1];
        fetchFun.load({
            url: `https://api.map.baidu.com/geocoder/v2/?output=json&ak=${GLOBAL.baiduKey}&location=${longitude},${latitude}`,
            completeUrl: true,//是否是完整URL
            type: 'GET',
            data: {
            },
            success: (res) => {
                console.log('---定位地址---', res, res.result.addressComponent.province, res.result.addressComponent.city)
                GLOBAL.zgrAddress.zgrAddressOneName = res.result.addressComponent.province
                GLOBAL.zgrAddress.zgrAddressTwoName = res.result.addressComponent.city
                this.setState({}, () => {
                    // 获取省
                    this.getProvince()
                })
            }
        });
    }
    // 获取省
    getProvince() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {
            this.getCity()//获取市
        } else {
            fetchFun.load({
                url: 'jlcfg/cities',
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取城市列表-省---', res)
                    GLOBAL.AddressOne = res
                    this.setState({}, () => {
                        this.getCity()//获取市
                    })
                }
            });
        }
    }
    // 获取市
    getCity() {
        let code = ''
        GLOBAL.AddressOne.map((v, i) => {
            if (v.city_name == GLOBAL.zgrAddress.zgrAddressOneName) {
                code = v.city_code
            }
        })
        fetchFun.load({
            url: 'jlcfg/cities',
            data: {
                level: '2',//城市级别 1：省 2 市 3县
                citycode: code,//城市编码
            },
            success: (res) => {
                console.log('---获取城市列表-市---', res)
                GLOBAL.AddressTwo = res
                this.setState({})
            }
        });
    }
    bottomTab() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({ state: "hide" });//调用原生方法
        }
    }
    // 搜索历史记录
    history() {
        fetchFun.load({
            url: 'jlforemanwork/findhelperhistory',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---搜索历史记录---', res)
                this.setState({
                    historyArr: res
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
                        onPress={() => { this.props.navigation.goBack(), DeviceEventEmitter.emit("EventType", param) }}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>找工人</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 找工人/招工组 */}
                <View style={styles.bg}>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.selectFunworker()}
                        style={{ width: '50%', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        {
                            this.state.lookworker ? (
                                <Icon name="xuanzeyixuan" size={18} color="#eb4e4e" />
                            ) : (
                                    <Icon name="weixuanze" size={18} color="#666666" />
                                )
                        }
                        <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '400', marginLeft: 11 }}>找工人</Text>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.selectFunworkerNo()}
                        style={{ width: '50%', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        {
                            !this.state.lookworker ? (
                                <Icon name="xuanzeyixuan" size={18} color="#eb4e4e" />
                            ) : (
                                    <Icon name="weixuanze" size={18} color="#666666" />
                                )
                        }
                        <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '400', marginLeft: 11 }}>找班组</Text>
                    </TouchableOpacity>
                </View>
                {/* 所需工种 */}
                <TouchableOpacity activeOpacity={.7} onPress={() => this.zgrTypework()} style={styles.bgs}>
                    <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '400' }}>所需工种</Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: GLOBAL.zgrType.zgrTypeName == '选择工种' ? '#999' : "#000", fontSize: 15.4 }}>{GLOBAL.zgrType.zgrTypeName} </Text>
                        <Icon style={{ marginLeft: 7 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 项目所在地 */}
                <TouchableOpacity activeOpacity={.7} onPress={() => this.zgrAddress()} style={styles.bgs}>
                    <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '400' }}>项目所在地</Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: GLOBAL.zgrAddress.zgrAddressOneName == '选择城市' ? '#999' : "#000", fontSize: 15.4 }}>{GLOBAL.zgrAddress.zgrAddressOneName} {GLOBAL.zgrAddress.zgrAddressTwoName}</Text>
                        <Icon style={{ marginLeft: 7 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 立即去搜索 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.btn()}
                    style={{
                        marginTop: 33, marginBottom: 33, marginLeft: 11, marginRight: 11,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: '#eb4e4e',
                        paddingTop: 11, paddingBottom: 11, borderRadius: 5.5
                    }}>
                    <Text style={{ color: '#fff', fontSize: 17.6 }}>立即去搜索</Text>
                </TouchableOpacity>
                {/* 搜索过的历史 */}
                <View style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 11, marginRight: 11 }}>
                    <Text style={{ fontSize: 15.4, color: '#000' }}>你搜索过的历史</Text>
                    <Text style={{ fontSize: 13.2, color: '#666' }}>（点击搜索记录可以快速找人）</Text>
                </View>
                {/* 历史内容 */}
                <View style={{
                    paddingTop: 5.5, paddingLeft: 11, paddingRight: 11,
                    flexWrap: 'wrap', flexDirection: 'row'
                }}>
                    {
                        this.state.historyArr.map((v, index) => {
                            return (
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.historyBtn(v)}
                                    key={index} style={{
                                        marginTop: 13, marginRight: 11, backgroundColor: '#fff',
                                        paddingLeft: 11, paddingRight: 11, paddingTop: 3.3, paddingBottom: 3.3,
                                        borderRadius: 17.6, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                    }}>
                                    <Text style={{ color: '#666', fontSize: 15.4 }}>{v.role_type == 1 ? '找工人' : '找班组'}-{v.work_type.type_name}</Text>
                                </TouchableOpacity>
                            )
                        })
                    }
                </View>

                {/* 加载弹框组件 */}
                <Loading
                closeAlertFun={this.closeAlertFun.bind(this)}
                    openAlertFun={this.openAlertFun.bind(this)}
                    openAlert={this.state.openAlert}
                    icon='warning'
                    font={this.state.warning} />
            </View>
        )
    }
    // 加载弹框控制
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    closeAlertFun(){
        this.setState({
            openAlert:false
        })
    }
    //找工人
    selectFunworker() {
        GLOBAL.lookworker = true
        if (GLOBAL.zgrType.zgrTypeName == '总包') {
            GLOBAL.zgrType.zgrTypeName = '选择工种'
        }
        this.setState({
            lookworker: true
        })
    }
    // 找班组
    selectFunworkerNo() {
        GLOBAL.lookworker = false
        this.setState({
            lookworker: false
        })
    }
    // 选择工种
    zgrTypework() {
        if (GLOBAL.typeArr && GLOBAL.typeArr.length > 0) {
            this.props.navigation.navigate('Typeworker', {
                name: '找工人工种',
                zgrBz: GLOBAL.lookworker ? false : 'bz',
                callback: (() => {
                    this.setState({})
                })
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/classlist',
                data: {
                    class_id: 1,//1:工种 2：项目类型3：熟练度 31：福利 40：举报信息类型
                    os: GLOBAL.os,
                    token: GLOBAL.userinfo.token,
                    ver: GLOBAL.ver,
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取工种列表---', res)
                    GLOBAL.typeArr = res
                    this.setState({}, () => {
                        this.props.navigation.navigate('Typeworker', {
                            name: '找工人工种',
                            zgrBz: GLOBAL.lookworker ? false : 'bz',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            });
        }
    }
    //选择项目所在地
    zgrAddress() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {//省数据已缓存
            this.setState({}, () => {
                this.props.navigation.navigate('Address', {
                    name: '找工人项目所在地',
                    callback: (() => {
                        this.setState({})
                    })
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
                                this.setState({})
                            })
                        })
                    })
                }
            });
        }
    }
    // 搜索按钮
    btn() {
        if (GLOBAL.zgrType.zgrTypeName == '选择工种') {
            this.setState({
                openAlert: !this.state.openAlert
            }, () => {
                setTimeout(() => {
                    this.setState({
                        // openAlert: false
                    })
                }, 2000)
            })
        } else if (GLOBAL.zgrAddress.zgrAddressOneName == '选择城市') {
            this.setState({
                warning: '请选择项目所在地',
                openAlert: !this.state.openAlert,
            }, () => {
                setTimeout(() => {
                    this.setState({
                        // openAlert: false
                    })
                }, 2000)
            })
        } else {
            let work_type, cityno
            if (GLOBAL.zgrType.zgrTypeName != '总包') {
                GLOBAL.typeArr.map((v, index) => {
                    if (v.name == GLOBAL.zgrType.zgrTypeName) {
                        work_type = v.code
                    }
                })
            } else {
                work_type = 0
            }
            console.log(GLOBAL.AddressTwo)
            GLOBAL.AddressTwo.map((v, index) => {
                if (v.city_name == GLOBAL.zgrAddress.zgrAddressTwoName) {
                    cityno = v.city_code
                }
            })
            GLOBAL.cityno = cityno
            GLOBAL.work_type = work_type
            this.setState({})

            this.props.navigation.navigate('Lookingworker_list', {
                callback: (() => {
                    this.setState({}), this.history()
                }),
                role_type: this.state.lookworker ? 1 : 2
            })
        }
    }
    // 点击搜索历史进行搜索
    historyBtn(e) {
        // this.props.navigation.navigate('Lookingworker_list', { work_type: e.work_type.type_id, cityno: e.cityno, role_type: e.role_type })
        GLOBAL.zgrType.zgrTypeNameSwitch = e.work_type.type_name
        GLOBAL.zgrAddress.zgrAddressTwoNumSwitch = e.city_name

        GLOBAL.cityno = e.cityno
        GLOBAL.work_type = e.work_type.type_id
        GLOBAL.lookworkerSwitch = e.role_type == '1' ? true : false

        GLOBAL.zgrType.zgrTypeName = e.work_type.type_name//工种名称
        GLOBAL.zgrType.zgrTypeNum = e.work_type.type_id//工种id
        GLOBAL.lookworker = (Number(e.role_type)==1)?true:false//工人还是班组

        this.setState({}, () => {
            this.props.navigation.navigate('Lookingworker_list', {
                tjswitch: true, callback: (() => {
                    this.setState({}), this.history()
                }),
                role_type: e.role_type
            })
        })
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
    bg: {
        marginTop: 11,
        paddingTop: 22,
        paddingBottom: 22,
        backgroundColor: '#fff',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    bgs: {
        marginTop: 11,
        paddingTop: 11,
        paddingBottom: 11,
        paddingLeft: 22,
        paddingRight: 22,
        backgroundColor: '#fff',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
})
