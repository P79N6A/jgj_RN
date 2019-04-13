/*
 * @Author: stl
 * @Date: 2019-03-15 09:41:44 
 * @Module:登录提醒
 * @Last Modified time: 2019-03-15 09:41:44 
 */
import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal } from 'react-native'
import Icon from "react-native-vector-icons/Ionicons";
export default class LoginRemind extends Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <Modal visible={this.props.orbottomalert}
                animationType="none"//没有动画效果
                transparent={true}//透明蒙层
                onRequestClose={() => this.props.selectwork()}//回调会在用户按下 Android 设备上的后退按键触发
                style={{ height: '100%' }}
            >
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={() => this.props.selectwork()}
                    style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                </TouchableOpacity>
                <View style={{
                    backgroundColor: '#fff', width: 298, height: 192, borderRadius: 7.7,
                    position: 'absolute', top: '50%', left: '50%', marginLeft: -149, marginTop: -96
                }}>
                    <View style={{ width: '100%', height: 143, padding: 16.5, }}>
                        <View style={{flexDirection:'row',justifyContent:'center',marginBottom:10,marginTop:10}}>
                            <Image style={{width:33,height:33}} source={require('../assets/personal/warning.png')}></Image>
                        </View>
                        <Text style={{textAlign:'center',color:'#999',fontSize:15.4}}>轻松找工作 随手记工天</Text>
                        <Text style={{textAlign:'center',color:'#999',fontSize:15.4}}>就在吉工家APP</Text>
                    </View>
                    <View style={{
                        backgroundColor: '#eb4e4e', borderTopWidth: 1, borderTopColor: '#ebebeb', flex: 1, flexDirection: 'row',
                        alignItems: 'center', justifyContent: 'center', borderBottomLeftRadius: 7.7, borderBottomRightRadius: 7.7
                    }}>
                        <TouchableOpacity>
                            <Text style={{ color: '#fff', fontSize: 18.7}}>马上登录</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </Modal>
        )
    }
}
