/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 17:40:41 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-10 11:18:14
 * Module:找工人
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import fetchFun from '../../fetch/fetch'

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.pagesize = 10
        this.state = {
            lookworker: true,//找工人还是找班组，true为找工人
            historyArr: [],//搜索记录
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        this.history()//搜索历史记录
    }
    // 搜索历史记录
    history() {
        fetchFun.load({
            url: 'jlforemanwork/findhelperhistory',
            data: {
                pg: this.page,
                pagesize: this.pagesize
            },
            success: (res) => {
                console.log('---搜索历史记录---', res)
                if (res.state == 1) {
                    this.setState({
                        historyArr: res.values
                    })
                }
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
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>找工人</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 找工人/招工组 */}
                <View style={styles.bg}>
                    <TouchableOpacity
                        onPress={() => this.selectFunworker()}
                        style={{ width: '50%', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        {
                            this.state.lookworker ? (
                                <Icon name="xuanzeyixuan" size={18} color="#eb4e4e" />
                            ) : (
                                    <Icon name="weixuanze" size={18} color="#666666" />
                                )
                        }
                        <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700', marginLeft: 11 }}>找工人</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={() => this.selectFunworkerNo()}
                        style={{ width: '50%', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        {
                            !this.state.lookworker ? (
                                <Icon name="xuanzeyixuan" size={18} color="#eb4e4e" />
                            ) : (
                                    <Icon name="weixuanze" size={18} color="#666666" />
                                )
                        }
                        <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700', marginLeft: 11 }}>找班组</Text>
                    </TouchableOpacity>
                </View>
                {/* 所需工种 */}
                <TouchableOpacity onPress={() => this.zgrTypework()} style={styles.bgs}>
                    <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700' }}>所需工种</Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: "#000", fontSize: 15.4 }}>{GLOBAL.zgrType.zgrTypeName} </Text>
                        <Icon style={{ marginLeft: 7 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 项目所在地 */}
                <TouchableOpacity onPress={() => this.zgrAddress()} style={styles.bgs}>
                    <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700' }}>项目所在地</Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: "#000", fontSize: 15.4 }}>{GLOBAL.zgrAddress.zgrAddressOneName} {GLOBAL.zgrAddress.zgrAddressTwoName}</Text>
                        <Icon style={{ marginLeft: 7 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 立即去搜索 */}
                <TouchableOpacity
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
                                <TouchableOpacity
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
            </View>
        )
    }
    //找工人
    selectFunworker() {
        this.setState({
            lookworker: true
        })
    }
    // 找班组
    selectFunworkerNo() {
        this.setState({
            lookworker: false
        })
    }
    // 选择工种
    zgrTypework() {
        fetchFun.load({
            url: 'jlcfg/classlist',
            data: {
                class_id: 1,//1:工种 2：项目类型3：熟练度 31：福利 40：举报信息类型
                os: GLOBAL.os,
                token: GLOBAL.userinfo.token,
                ver: GLOBAL.ver,
            },
            success: (res) => {
                console.log('---获取工种列表---', res)
                if (res.state == 1) {
                    GLOBAL.typeArr = res.values
                    this.setState({}, () => {
                        this.props.navigation.navigate('Typeworker', {
                            name: '找工人工种',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            }
        });
    }
    //选择项目所在地
    zgrAddress() {
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
                    GLOBAL.AddressOne = res.values
                    this.setState({}, () => {
                        this.props.navigation.navigate('Address', {
                            name: '找工人项目所在地',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            }
        });
    }
    // 搜索按钮
    btn() {
        if (GLOBAL.zgrType.zgrTypeName !== '选择工种' && GLOBAL.zgrAddress.zgrAddressOneName !== '选择城市') {
            let work_type, cityno
            GLOBAL.typeArr.map((v, index) => {
                if (v.name == GLOBAL.zgrType.zgrTypeName) {
                    work_type = v.code
                }
            })
            GLOBAL.AddressTwo.map((v, index) => {
                if (v.city_name == GLOBAL.zgrAddress.zgrAddressTwoName) {
                    cityno = v.city_code
                }
            })
            this.props.navigation.navigate('Lookingworker_list', { work_type: work_type, cityno: cityno, role_type: this.state.lookworker ? '1' : '2' })
        }
    }
    // 点击搜索历史进行搜索
    historyBtn(e) {
        this.props.navigation.navigate('Lookingworker_list', { work_type: e.work_type.type_id, cityno: e.cityno, role_type: e.role_type })
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
