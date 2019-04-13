/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:22:44 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-29 16:40:43
 * Module:招聘套餐
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class recruitplan extends Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    render() {
        return (
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>招聘套餐</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                <View style={{ backgroundColor: '#fff', paddingTop: 16.5, paddingBottom: 16.5, flexDirection: 'row' }}>
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Recruit_joborder')}
                        style={{ width: '50%' }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                            <Icon name="dingdan" size={45} color="#1296DB" />
                        </View>
                        <Text style={{ color: '#333', fontSize: 13.2, textAlign: 'center', marginTop: 6.6 }}>招聘订单</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Recruit_servicewater')}
                        style={{ width: '50%' }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                            <Icon name="profession" size={45} color="#1296DB" />
                        </View>
                        <Text style={{ color: '#333', fontSize: 13.2, textAlign: 'center', marginTop: 6.6 }}>服务流水</Text>
                    </TouchableOpacity>
                </View>

                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Recruit_buyalivecall')}
                    style={{ backgroundColor: '#fff', marginTop: 11, padding: 11 }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                            <Image style={{ width: 66, height: 66 }} 
                            source={require('../../assets/recruit/jobwork.png')}></Image>
                            <View style={{ marginLeft: 11 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>购买</Text>
                                    <Text style={{ color: 'rgb(47, 161, 160)', fontWeight: '700', fontSize: 16.5 }}>找活招工</Text>
                                    <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>电话数</Text>
                                </View>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可直接拨打电话联系项目和工作</Text>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可直接拨打电话联系工人</Text>
                                <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4 }}>
                                    <Text style={{ color: '#eb4e4e', fontWeight: '700', fontSize: 16.5 }}>1.97元/个</Text>
                                    <Text style={{ color: '#666', fontWeight: '700', fontSize: 13.2, marginLeft: 3 }}>起</Text>
                                </View>
                            </View>
                        </View>
                        <View style={{
                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>购买</Text>
                        </View>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 5.5 }}>
                        <Text style={{ color: '#666', fontSize: 15.4 }}>当前剩余数量：</Text>
                        <Text style={{ color: '#000', fontWeight: '700', fontSize: 15.4 }}>2</Text>
                        <Text style={{ color: '#666', fontSize: 15.4 }}>个(每月赠送2个)</Text>
                    </View>
                </TouchableOpacity>

                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Recruit_authen')}
                    style={{ backgroundColor: '#fff', marginTop: 11, padding: 11 }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                            <Image style={{ width: 66, height: 66 }} 
                            source={require('../../assets/recruit/foreman.png')}></Image>
                            <View style={{ marginLeft: 11 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>购买</Text>
                                    <Text style={{ color: 'rgb(242, 85, 108)', fontWeight: '700', fontSize: 16.5 }}>班组长认证</Text>
                                    <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>电话数</Text>
                                </View>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可大大提高你的可信度</Text>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可优先匹配项目</Text>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可获得广告宣传等高级服务</Text>
                                <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4 }}>
                                    <Text style={{ color: '#eb4e4e', fontWeight: '700', fontSize: 16.5 }}>99元/年</Text>
                                </View>
                            </View>
                        </View>
                        <View style={{
                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>查看/购买</Text>
                        </View>
                    </View>
                </TouchableOpacity>

                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Recruit_authen')}
                    style={{ backgroundColor: '#fff', marginTop: 11, padding: 11 }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                            <Image style={{ width: 66, height: 66 }}
                            source={require('../../assets/recruit/worker.png')}></Image>
                            <View style={{ marginLeft: 11 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>购买</Text>
                                    <Text style={{ color: 'rgb(89, 121, 213)', fontWeight: '700', fontSize: 16.5 }}>工人认证</Text>
                                    <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>电话数</Text>
                                </View>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可大大提高你的可信度</Text>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可优先匹配工作</Text>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>·可获得广告宣传等高级服务</Text>
                                <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4 }}>
                                    <Text style={{ color: '#eb4e4e', fontWeight: '700', fontSize: 16.5 }}>99元/年</Text>
                                </View>
                            </View>
                        </View>
                        <View style={{
                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>查看/购买</Text>
                        </View>
                    </View>
                </TouchableOpacity>
            </View>
        )
    }
}