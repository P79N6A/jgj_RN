import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Platform,
    Image, ScrollView, TextInput, AsyncStorage,
    NativeModules
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../fetch/fetch'

export default class selectaddress extends Component {
    constructor(props) {
        super(props)
        this.state = {
            oneName: '选择城市',//选择一级菜单名字
            twoArr: [],//点击一级菜单请求的二级数据
            searchAddress: [],//搜索到的地址
        }
    }
    componentWillMount() {
        if (this.props.addressType == '找工作') {
            this.setState({
                oneName: GLOBAL.zgzAddress.zgzAddressOneName,
                twoArr: GLOBAL.AddressTwo
            })
        } else if (this.props.addressType == '找工人项目所在地') {
            this.setState({
                oneName: GLOBAL.zgrAddress.zgrAddressOneName,
                twoArr: GLOBAL.AddressTwo
            })
            if (GLOBAL.zgrAddress.zgrAddressTwoName != '') {
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
                        this.setState({
                            twoArr: res,
                        })
                    }
                });
            }
        }
        else if (this.props.addressType == '发布招工项目所在地') {
            this.setState({
                oneName: GLOBAL.fbzgAddress.fbzgAddressOneName,
                twoArr: GLOBAL.AddressTwo
            })
            if (GLOBAL.fbzgAddress.fbzgAddressTwoName != '') {
                let code = ''
                GLOBAL.AddressOne.map((v, i) => {
                    if (v.city_name == GLOBAL.fbzgAddress.fbzgAddressOneName) {
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
                        this.setState({
                            twoArr: res,
                        })
                    }
                });
            }
        }

    }
    //地址列表一级点击事件
    clickOne(code, name) {
        if (this.props.addressType == '找工作') {
            GLOBAL.zgzAddress.zgzAddressOneNum = code
            this.setState({
                oneName: name
            })
        } else if (this.props.addressType == '找工人项目所在地') {
            GLOBAL.zgrAddress.zgrAddressOneNum = code
            this.setState({
                oneName: name
            })
        } else if (this.props.addressType == '发布招工项目所在地') {
            GLOBAL.fbzgAddress.fbzgAddressOneNum = code
            this.setState({
                oneName: name
            })
        }
        fetchFun.load({
            url: 'jlcfg/cities',
            data: {
                level: '2',//城市级别 1：省 2 市 3县
                citycode: code,//城市编码
                // os:GLOBAL.os,
                // token:GLOBAL.userinfo.token,
                // ver:GLOBAL.ver,
            },
            success: (res) => {
                console.log('---获取城市列表-市---', res)
                let arr = [{
                    city_code: code,
                    city_name: name
                }]
                if (res[0].city_name != name && this.props.addressType == '找工作') {
                    this.setState({
                        twoArr: arr.concat(res),
                    })
                } else {
                    this.setState({
                        twoArr: res,
                    })
                }
            }
        });
    }
    //地址列表二级点击事件
    clickTwo(code, name) {
        if (this.props.addressType == '找工作') {
            GLOBAL.zgzAddress.national = false
            GLOBAL.zgzAddress.zgzAddressOneName = this.state.oneName

            GLOBAL.zgzAddress.zgzAddressTwoName = name
            GLOBAL.zgzAddress.zgzAddressTwoNum = code
            
        } else if (this.props.addressType == '找工人项目所在地') {
            GLOBAL.zgzAddress.national = false
            GLOBAL.zgrAddress.zgrAddressOneName = this.state.oneName

            GLOBAL.zgrAddress.zgrAddressTwoName = name
            GLOBAL.zgrAddress.zgrAddressTwoNum = code
        } else if (this.props.addressType == '发布招工项目所在地') {
            GLOBAL.zgzAddress.national = false
            GLOBAL.fbzgAddress.fbzgAddressOneName = this.state.oneName

            GLOBAL.fbzgAddress.fbzgAddressTwoName = name
            GLOBAL.fbzgAddress.fbzgAddressTwoNum = code
        }

        GLOBAL.AddressTwo = this.state.twoArr
        this.setState({})
        this.props.offAddress()
        // console.log(GLOBAL.zgzAddress.zgzAddressTwoNum)
    }
    // 选择全国
    clickNational() {
        GLOBAL.zgzAddress.national = true
        GLOBAL.zgzAddress.zgzAddressTwoName = '全国'
        GLOBAL.zgzAddress.zgzAddressTwoNum = ''
        GLOBAL.zgzAddress.zgzAddressOneName = '选择城市'
        this.setState({})
        this.props.offAddress()
    }
    // 搜索框
    inputFun(e) {
        this.getsearch(e)
    }
    // 搜索框获取数据
    getsearch(e) {
        fetchFun.load({
            url: 'jlcfg/citiessearch',
            data: {
                level: '1',
                searchtext: e
            },
            success: (res) => {
                console.log('---搜索到的地址---', res)
                this.setState({
                    searchAddress: res,
                })
            }
        });
    }
    // 选择搜索地址
    searchFun(v) {
        GLOBAL.zgzAddress.zgzAddressTwoName = v.city_name
        GLOBAL.zgzAddress.zgzAddressTwoNum = v.city_code
        GLOBAL.AddressOne.map((value, index) => {
            if (value.city_code == v.parent_id) {
                GLOBAL.zgzAddress.zgzAddressOneName = value.city_name
                fetchFun.load({
                    url: 'jlcfg/cities',
                    data: {
                        level: '2',//城市级别 1：省 2 市 3县
                        citycode: v.parent_id,//城市编码
                    },
                    success: (res) => {
                        console.log('---获取城市列表-市---', res)
                        GLOBAL.AddressTwo = res
                    }
                });
            }
        })
        this.setState({})
        this.props.offAddress()
    }
    render() {
        return (
            <View style={styles.containermain}>
                <View >
                    <View style={{ height: this.props.addressType == '找工作' ? 30 : 0 }}></View>
                    <View style={{ position: 'absolute', zIndex: 1000, width: '100%', }}>
                        {/* 搜索地址 */}
                        {
                            this.props.addressType == '找工作' ? (
                                <View style={{
                                    backgroundColor: 'white',
                                }}>
                                    {/* <View style={{height:50}}></View> */}
                                    <View
                                    // style={{width:'100%',position:'absolute',zIndex:1000}}
                                    >
                                        <View style={{
                                            marginLeft: 10, marginRight: 10, marginTop: 5, marginBottom: 5,
                                            borderRadius: 6,
                                        }}>
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', backgroundColor: "#eee",
                                                borderRadius: 6, height: 32,
                                            }}>
                                                <Icon style={{ marginLeft: 5 }} name="search" size={20} color="#999999" />
                                                <TextInput
                                                    onChangeText={this.inputFun.bind(this)}
                                                    style={{ fontSize: 12, padding: 2, flex: 1, marginLeft: Platform.OS == 'ios' ? 10 : 0 }}
                                                    placeholder={'请输入城市的中文名称或拼音首字母'}>
                                                </TextInput>
                                            </View>

                                            {/* 搜索匹配内容 */}
                                            <ScrollView>
                                                {
                                                    this.state.searchAddress && this.state.searchAddress.length > 0 ? (
                                                        this.state.searchAddress.map((v, index) => {
                                                            return (
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    onPress={() => this.searchFun(v)}
                                                                    key={index}
                                                                    style={{
                                                                        backgroundColor: '#fff',
                                                                        color: '#666', fontSize: 18.7, lineHeight: 28,
                                                                        borderRadius: 6,
                                                                    }}>
                                                                    <Text
                                                                        style={{
                                                                            marginLeft: 16.5,
                                                                            marginRight: 16.5, marginTop: 8.8, marginBottom: 8.8,
                                                                        }}>
                                                                        {v.city_name}
                                                                    </Text>
                                                                </TouchableOpacity>
                                                            )
                                                        })
                                                    ) : false
                                                }
                                            </ScrollView>
                                        </View>

                                    </View>



                                </View>) : false
                        }
                    </View>
                    <View>
                        {
                            this.props.addressType == '找工作' ? (
                                // 直接选择
                                <View style={{ paddingLeft: 15, paddingRight: 15, paddingBottom: 5, paddingTop: 20, borderBottomColor: '#dbdbdb', borderBottomWidth: 1 }}>
                                    <Text style={{ color: '#ccc', fontSize: 12, flexDirection: 'row', alignItems: 'center' }}>直接选择</Text>
                                </View>
                            ) : false
                        }
                        {/* 地址选择 */}
                        <View style={{ flexDirection: 'row', marginBottom:this.props.addressType == '找工作'?180:0 }}>
                            <ScrollView style={{ flex: 1 }}>
                                {/* 全国 */}
                                {
                                    this.props.national ? (
                                        <TouchableOpacity activeOpacity={.7} onPress={() => this.clickNational()} style={{
                                            height: 46,
                                            backgroundColor: 'white',
                                            borderBottomWidth: .5,
                                            borderBottomColor: '#dbdbdb',
                                            borderRightWidth: .5,
                                            borderRightColor: '#dbdbdb',
                                            paddingLeft: 16,
                                            paddingRight: 16,
                                            flexDirection: 'row',
                                            alignItems: 'center',
                                            justifyContent: "space-between"
                                        }}>
                                            <Text style={{ fontSize: 15, color: '#666' }}>全国</Text>
                                        </TouchableOpacity>
                                    ) : false
                                }
                                {
                                    GLOBAL.AddressOne.map((item, key) => {
                                        return (
                                            <TouchableOpacity activeOpacity={.7} key={key} onPress={() => this.clickOne(item.city_code, item.city_name)} style={{
                                                height: 46,
                                                backgroundColor: this.state.oneName == item.city_name ? "#dbdbdb" : 'white',
                                                borderBottomWidth: .5,
                                                borderBottomColor: '#dbdbdb',
                                                borderRightWidth: .5,
                                                borderRightColor: '#dbdbdb',
                                                paddingLeft: 16,
                                                paddingRight: 16,
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                justifyContent: "space-between"
                                            }}>
                                                <Text style={{ fontSize: 15, color: '#666' }}>{item.city_name}</Text>
                                            </TouchableOpacity>
                                        )
                                    })
                                }
                            </ScrollView>

                            {/* 二级地址菜单 */}
                            {
                                this.state.oneName !== '选择城市' ? (
                                    <ScrollView style={{ flex: 1 }}>
                                        {
                                            this.props.addressType == '找工作' ? (
                                                this.state.twoArr.map((item, key) => {
                                                    return (
                                                        <TouchableOpacity activeOpacity={.7} key={key} onPress={() => this.clickTwo(item.city_code, item.city_name)} style={{
                                                            height: 46,
                                                            backgroundColor: GLOBAL.zgzAddress.zgzAddressTwoName == item.city_name ? "#dbdbdb" : 'white',
                                                            borderBottomWidth: .5,
                                                            borderBottomColor: '#dbdbdb',
                                                            borderRightWidth: .5,
                                                            borderRightColor: '#dbdbdb',
                                                            paddingLeft: 16,
                                                            paddingRight: 16,
                                                            flexDirection: 'row',
                                                            alignItems: 'center',
                                                            justifyContent: "space-between"
                                                        }}>
                                                            <Text style={{ fontSize: 15, color: '#666' }}>{item.city_name}</Text>
                                                        </TouchableOpacity>
                                                    )
                                                })
                                            ) : (
                                                    this.props.addressType == '找工人项目所在地' ? (
                                                        this.state.twoArr.map((item, key) => {
                                                            return (
                                                                <TouchableOpacity activeOpacity={.7} key={key} onPress={() => this.clickTwo(item.city_code, item.city_name)} style={{
                                                                    height: 46,
                                                                    backgroundColor: GLOBAL.zgrAddress.zgrAddressTwoName == item.city_name ? "#dbdbdb" : 'white',
                                                                    borderBottomWidth: .5,
                                                                    borderBottomColor: '#dbdbdb',
                                                                    borderRightWidth: .5,
                                                                    borderRightColor: '#dbdbdb',
                                                                    paddingLeft: 16,
                                                                    paddingRight: 16,
                                                                    flexDirection: 'row',
                                                                    alignItems: 'center',
                                                                    justifyContent: "space-between"
                                                                }}>
                                                                    <Text style={{ fontSize: 15, color: '#666' }}>{item.city_name}</Text>
                                                                </TouchableOpacity>
                                                            )
                                                        })
                                                    ) : this.props.addressType == '发布招工项目所在地' ? (
                                                        this.state.twoArr.map((item, key) => {
                                                            return (
                                                                <TouchableOpacity activeOpacity={.7} key={key} onPress={() => this.clickTwo(item.city_code, item.city_name)} style={{
                                                                    height: 46,
                                                                    backgroundColor: GLOBAL.fbzgAddress.fbzgAddressTwoName == item.city_name ? "#dbdbdb" : 'white',
                                                                    borderBottomWidth: .5,
                                                                    borderBottomColor: '#dbdbdb',
                                                                    borderRightWidth: .5,
                                                                    borderRightColor: '#dbdbdb',
                                                                    paddingLeft: 16,
                                                                    paddingRight: 16,
                                                                    flexDirection: 'row',
                                                                    alignItems: 'center',
                                                                    justifyContent: "space-between"
                                                                }}>
                                                                    <Text style={{ fontSize: 15, color: '#666' }}>{item.city_name}</Text>
                                                                </TouchableOpacity>
                                                            )
                                                        })
                                                    ) : false
                                                )
                                        }
                                    </ScrollView>
                                ) : (
                                        <View style={{ width: 0 }}></View>
                                    )
                            }

                            {/* 三级地址菜单 */}
                            {/* {
                        this.state.clickaddresstwoNum >= 0 && this.props.objAddress.jb == 'jxaddress' ? (
                            <ScrollView>
                                {
                                    this.state.addressthree.map((item, key) => {
                                        return (
                                            <TouchableOpacity activeOpacity={.7} key={key} onPress={() => this.clicklithree(item.city_code)} style={{
                                                height: 46,
                                                backgroundColor: this.state.clickaddressthreeNum == item.city_code ? "#dbdbdb" : 'white',
                                                borderBottomWidth: .5,
                                                borderBottomColor: '#999',
                                                paddingLeft: 16,
                                                paddingRight: 16,
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                justifyContent: "space-between"
                                            }}>
                                                <Text style={{ fontSize: 15, color: '#666' }}>{item.city_name}</Text>
                                            </TouchableOpacity>
                                        )
                                    })
                                }
                            </ScrollView>
                        ) : (
                                <View style={{ width: 0 }}></View>
                            )
                    } */}
                        </View>

                    </View>
                </View>


            </View>
        )
    }
}
const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        width: '100%',
        backgroundColor: 'white',
    },
})