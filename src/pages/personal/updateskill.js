/*
 * @Author: stl
 * @Date: 2019-03-19 15:07:29 
 * @Module:正在编辑职业技能证书
 * @Last Modified time: 2019-03-19 15:07:29 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            inputValue: ''
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>正在编辑职业技能证书</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <View style={{
                    marginTop: 22,
                    backgroundColor: "#fff",
                    paddingLeft: 10,
                    paddingRight: 10,
                    paddingTop: 15,
                    paddingBottom: 15,
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between'
                }}>
                    <TextInput
                        onChangeText={this.namefun.bind(this)}
                        value={this.state.inputValue}
                        placeholder='请输入职业技能的名称' style={{ height: 16, flex: 1, color: '#000', fontSize: 15, padding: 0, margin: 0 }}></TextInput>
                </View>
                {/* 添加图片 */}
                <View style={{
                    flexWrap: 'wrap', flexDirection: 'row', marginLeft: 11,
                    marginTop: 24,
                }}>
                    <View style={{ position: 'relative' }}>
                        <Image style={{ width: 20, height: 20, position: 'absolute', right: 5, top: -10, zIndex: 100 }}
                            source={require('../../assets/personal/jian.png')}></Image>
                        <Image style={{ width: 80, height: 80, marginRight: 15, marginBottom: 15 }}
                            source={require('../../assets/personal/img.jpg')}></Image>
                    </View>
                    <View style={{
                        backgroundColor: '#fff',

                        height: 80,
                        width: 80,
                        borderWidth: 1,
                        borderColor: 'rgb(204, 204, 204)'
                    }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginTop: 14, marginBottom: 10, }}>
                            <Image style={{ width: 22, height: 22 }} source={require('../../assets/personal/add.png')}></Image>
                        </View>
                        <Text style={{ color: '#999', fontSize: 15, textAlign: 'center' }}>添加图片</Text>
                    </View>
                </View>

                {/* 底部固定按钮 */}
                <View style={{ height: 64, backgroundColor: '#fff', flexDirection: 'row', justifyContent: 'space-between', padding: 10, position: 'absolute', bottom: 0, width: '100%' }}>
                    <View style={{ borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, width: 157, paddingTop: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>删除</Text>
                    </View>
                    <View style={{ backgroundColor: '#eb4e4e', borderRadius: 4, width: 200, paddingTop: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#fff', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>保存</Text>
                    </View>
                </View>
            </View>
        )
    }
    // 姓名输入框事件
    namefun(name) {
        this.setState({
            inputValue: name
        })
    };
    // 清空姓名事件
    clearname() {
        this.setState({
            inputValue: ''
        })
    }
    // 确定修改姓名按钮
    editnameFun() {
        GLOBAL.name = this.state.inputValue
        this.props.navigation.state.params.callback()
        this.props.navigation.goBack()
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
})