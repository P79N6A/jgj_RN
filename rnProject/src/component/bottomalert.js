/*
 * @Author: stl
 * @Date: 2019-03-15 09:41:44 
 * @Module:底部弹框组件
 * @Last Modified time: 2019-03-15 09:41:44 
 */
import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal } from 'react-native'
import Icon from "react-native-vector-icons/Ionicons";
export default class bottomalert extends Component {
    constructor(props) {
        super(props)
        this.state = {
            selectarr: [
                { key: 0, name: '未开工正在找工作' },
                { key: 1, name: '已开工也在找工作' },
                { key: 2, name: '暂时不需要找工作' },
            ]
        }
    }
    render() {
        return (
            <Modal visible={this.props.orbottomalert}
                animationType="slide"//从底部划出
                transparent={true}//透明蒙层
                onRequestClose={() => this.props.selectwork()}//点击返回的回调函数
                style={{ height: '100%' }}
            >
                <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)' }}></View>
                <TouchableOpacity activeOpacity={1} style={{ height: 264, backgroundColor: '#ebebeb' }}>
                    {/* title */}
                    <View style={{ height: 45, backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ fontSize: 15, color: '#fff' }}>请选择你的工作状态</Text>
                    </View>
                    {/* 选项 */}
                    {
                        this.state.selectarr.map((item, key) => {
                            return (
                                <TouchableOpacity onPress={() => this.props.selectwork(item.name)} key={key} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', height: 53, backgroundColor: "#fff", marginBottom: 1 }}>
                                    <Text style={{ fontSize: 17, color: '#333' }}>{item.name}</Text>
                                </TouchableOpacity>
                            )
                        })
                    }
                    {/* 取消按钮 */}
                    <TouchableOpacity onPress={() => this.props.selectwork()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', height: 53, backgroundColor: "#fff", marginTop: 4 }}>
                        <Text style={{ fontSize: 17, color: '#333' }}>取消</Text>
                    </TouchableOpacity>
                </TouchableOpacity>
            </Modal>
        )
    }
}