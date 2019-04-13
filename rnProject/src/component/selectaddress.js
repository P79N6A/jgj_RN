import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, TextInput,AsyncStorage } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import fetchFun from '../fetch/fetch'

export default class selectaddress extends Component {
    constructor(props) {
        super(props)
        this.state = {
            issearch: true,//搜索框是否显示
            oneName:'选择城市',//选择一级菜单名字
            twoArr:[],//点击一级菜单请求的二级数据
        }
    }
    componentWillMount(){
        if(this.props.addressType == '找工作'){
            this.setState({
                oneName:GLOBAL.zgzAddress.zgzAddressOneName,
                twoArr:GLOBAL.AddressTwo
            })
        }else if(this.props.addressType == '找工人项目所在地'){
            this.setState({
                oneName:GLOBAL.zgrAddress.zgrAddressOneName,
                twoArr:GLOBAL.AddressTwo
            })
        }
        else if(this.props.addressType == '发布招工项目所在地'){
            this.setState({
                oneName:GLOBAL.fbzgAddress.fbzgAddressOneName,
                twoArr:GLOBAL.AddressTwo
            })
        }
    }
    //地址列表一级点击事件
    clickOne(code,name) {
        if(this.props.addressType == '找工作'){
            GLOBAL.zgzAddress.zgzAddressOneNum = code
            this.setState({
                oneName:name
            })
        }else if(this.props.addressType == '找工人项目所在地'){
            GLOBAL.zgrAddress.zgrAddressOneNum = code
            this.setState({
                oneName:name
            })
        }else if(this.props.addressType == '发布招工项目所在地'){
            GLOBAL.fbzgAddress.fbzgAddressOneNum = code
            this.setState({
                oneName:name
            })
        }
        fetchFun.load({
            url: 'jlcfg/cities',
            data: {
                level:'2',//城市级别 1：省 2 市 3县
                citycode:code,//城市编码
                // os:GLOBAL.os,
                // token:GLOBAL.userinfo.token,
                // ver:GLOBAL.ver,
            },
            success: (res) => {
                console.log('---获取城市列表-市---', res)
                if (res.state == 1) {
                    this.setState({
                        twoArr:res.values,
                    })
                }
            }
        });
    }
    //地址列表二级点击事件
    clickTwo(code,name) {
        if(this.props.addressType == '找工作'){
            GLOBAL.zgzAddress.zgzAddressOneName = this.state.oneName
    
            GLOBAL.zgzAddress.zgzAddressTwoName = name
            GLOBAL.zgzAddress.zgzAddressTwoNum = code
        }else if(this.props.addressType == '找工人项目所在地'){
            GLOBAL.zgrAddress.zgrAddressOneName = this.state.oneName
    
            GLOBAL.zgrAddress.zgrAddressTwoName = name
            GLOBAL.zgrAddress.zgrAddressTwoNum = code
        }else if(this.props.addressType == '发布招工项目所在地'){
            GLOBAL.fbzgAddress.fbzgAddressOneName = this.state.oneName
    
            GLOBAL.fbzgAddress.fbzgAddressTwoName = name
            GLOBAL.fbzgAddress.fbzgAddressTwoNum = code
        }

        GLOBAL.AddressTwo=this.state.twoArr
        this.setState({})
        this.props.offAddress()
    }
    render() {
        return (
            <View style={styles.containermain}>
                {/* 搜索地址 */}
                {
                    this.state.issearch ? (<View style={{
                        backgroundColor: 'white', borderBottomWidth: .6,
                        borderBottomColor: '#999',
                    }}>
                        <View style={{
                            marginLeft: 10, marginRight: 10, marginTop: 5, marginBottom: 5,
                            backgroundColor: "#eee", height: 32, borderRadius: 6, flexDirection: 'row', alignItems: 'center'
                        }}>
                            <Icon style={{ marginLeft: 5 }} name="search" size={20} color="#999999" />
                            <TextInput style={{ fontSize: 12, padding: 2 }} placeholder={'请输入城市的中文名称或拼音首字母'}></TextInput>
                        </View>
                        <View style={{ marginLeft: 15, marginRight: 15, marginTop: 5, marginBottom: 5 }}>
                            <Text style={{ color: '#ccc', fontSize: 12, flexDirection: 'row', alignItems: 'center' }}>直接选择</Text>
                        </View>
                    </View>) :
                        (<View></View>)
                }

                {/* 地址选择 */}
                <View style={{ flexDirection: 'row' }}>
                    <ScrollView style={{ marginBottom: 70 }}>
                        {
                            GLOBAL.AddressOne.map((item, key) => {
                                return (
                                    <TouchableOpacity key={key} onPress={() => this.clickOne(item.city_code,item.city_name)} style={{
                                        height: 46,
                                        backgroundColor: this.state.oneName == item.city_name ? "#dbdbdb" : 'white',
                                        borderBottomWidth: .6,
                                        borderBottomColor: '#999',
                                        borderRightWidth: .4,
                                        borderRightColor: '#999',
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
                            <ScrollView>
                                {
                                    this.props.addressType == '找工作'?(
                                        this.state.twoArr.map((item, key) => {
                                            return (
                                                <TouchableOpacity key={key} onPress={() => this.clickTwo(item.city_code,item.city_name)} style={{
                                                    height: 46,
                                                    backgroundColor: GLOBAL.zgzAddress.zgzAddressTwoName == item.city_name ? "#dbdbdb" : 'white',
                                                    borderBottomWidth: .6,
                                                    borderBottomColor: '#999',
                                                    borderRightWidth: .4,
                                                    borderRightColor: '#999',
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
                                    ):(
                                        this.props.addressType == '找工人项目所在地'?(
                                            this.state.twoArr.map((item, key) => {
                                                return (
                                                    <TouchableOpacity key={key} onPress={() => this.clickTwo(item.city_code,item.city_name)} style={{
                                                        height: 46,
                                                        backgroundColor: GLOBAL.zgrAddress.zgrAddressTwoName == item.city_name ? "#dbdbdb" : 'white',
                                                        borderBottomWidth: .6,
                                                        borderBottomColor: '#999',
                                                        borderRightWidth: .4,
                                                        borderRightColor: '#999',
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
                                        ):this.props.addressType =='发布招工项目所在地'?(
                                            this.state.twoArr.map((item, key) => {
                                                return (
                                                    <TouchableOpacity key={key} onPress={() => this.clickTwo(item.city_code,item.city_name)} style={{
                                                        height: 46,
                                                        backgroundColor: GLOBAL.fbzgAddress.fbzgAddressTwoName == item.city_name ? "#dbdbdb" : 'white',
                                                        borderBottomWidth: .6,
                                                        borderBottomColor: '#999',
                                                        borderRightWidth: .4,
                                                        borderRightColor: '#999',
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
                                        ):false
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
                                            <TouchableOpacity key={key} onPress={() => this.clicklithree(item.city_code)} style={{
                                                height: 46,
                                                backgroundColor: this.state.clickaddressthreeNum == item.city_code ? "#dbdbdb" : 'white',
                                                borderBottomWidth: .6,
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