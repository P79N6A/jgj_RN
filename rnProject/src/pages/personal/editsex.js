/*
 * @Author: stl
 * @Date: 2019-03-18 11:29:45 
 * @Module：性别
 * @Last Modified time: 2019-03-18 11:29:45 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            sexarr: [
                { key: 0, name: '男' },
                { key: 1, name: '女' },
            ]
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
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
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>性别</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {
                    this.state.sexarr.map((item, key) => {
                        return (
                            <TouchableOpacity key={key} onPress={() => this.clicksex(key)} style={{
                                marginBottom: 1,
                                backgroundColor: "#fff",
                                paddingLeft: 10,
                                paddingRight: 10,
                                paddingTop: 15,
                                paddingBottom: 15,
                                flexDirection: 'row',
                                alignItems: 'center',
                                justifyContent: 'space-between'
                            }}>
                                <Text style={{ color: GLOBAL.editbasic.sex == item.name ? '#eb4e4e' : '#000', fontSize: 15 }}>{item.name}</Text>
                                {
                                    GLOBAL.editbasic.sex == item.name ? (
                                        <Icon name="sure" size={18} color="#eb4e4e" />
                                    ) : (
                                            <View></View>
                                        )
                                }
                            </TouchableOpacity>
                        )
                    })
                }
            </View>
        )
    }
    clicksex(key) {
        if (key == 0) {
            GLOBAL.editbasic.sex = '男'//将性别key值定义进入全局变量
        } else {
            GLOBAL.editbasic.sex = '女'//将性别key值定义进入全局变量
        }
        this.props.navigation.state.params.callback()
        this.props.navigation.navigate('Basic')
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
        paddingTop: 16,
    },
})