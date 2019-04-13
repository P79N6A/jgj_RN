/*
 * @Author: stl
 * @Date: 2019-03-19 08:41:43 
 * @Module:新增项目经验
 * @Last Modified time: 2019-03-19 08:41:43 
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, DatePickerAndroid, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            presetText: '请选择完工时间',
            presetDate: new Date(2019, 3, 4),//完工时间
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    //进行创建时间日期选择器
    async showPicker(stateKey, options) {
        try {
            var newState = {};
            const { action, year, month, day } = await DatePickerAndroid.open(options);
            if (action === DatePickerAndroid.dismissedAction) {
                newState[stateKey + 'Text'] = 'dismissed';
            } else {
                var date = new Date(year, month, day);
                newState[stateKey + 'Text'] = date.toLocaleDateString();//选择的时间
                newState[stateKey + 'Date'] = date;
            }
            this.setState(newState);
            GLOBAL.birthday = date.toLocaleDateString()//赋值给全局变量
            this.refreshFun()//手动刷新
        } catch ({ code, message }) {
            console.warn(`Error in example '${stateKey}': `, message);
        }
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
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>新增项目经验</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 项目名称 */}
                <View style={styles.vie}>
                    <Text style={styles.tex}>项目名称</Text>
                    <TextInput style={styles.input} placeholder='请输入项目名称'></TextInput>
                </View>
                {/* 完工时间 */}
                <View style={styles.vie}>
                    <Text style={styles.tex}>完工时间</Text>
                    <CustomButton text={this.state.presetText}
                        onPress={this.showPicker.bind(this, 'preset', { date: this.state.presetDate })} />
                </View>
                {/* 所在地区 */}
                <TouchableOpacity onPress={() => this.props.navigation.navigate('Addproress', {
                    callback: (() => {
                        this.setState({})
                    })
                })}
                    style={styles.vie}>
                    <Text style={styles.tex}>所在地区</Text>
                    <View style={styles.right}>
                        <Text style={styles.font}>{GLOBAL.qwoneName} {GLOBAL.qwtwoName}</Text>
                        <Icon name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 经历描述 */}
                <View style={styles.vielast}>
                    <Text style={{ color: '#000', fontSize: 17.6, }}>经历描述</Text>
                    <TextInput multiline={true}
                        textAlignVertical='top'
                        style={{ fontSize: 15.5, textAlign: 'left', padding: 0, marginTop: 8, marginBottom: 8, height: 110 }}
                        placeholder='主要描述在项目中的工作情况'></TextInput>
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
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginTop: 14, marginBottom: 10 }}>
                            <Image style={{ width: 22, height: 22 }} source={require('../../assets/personal/add.png')}></Image>
                        </View>
                        <Text style={{ color: '#999', fontSize: 15, textAlign: 'center' }}>添加图片</Text>
                    </View>
                </View>
                {/* 底部固定按钮 */}
                <View style={{ height: 64, backgroundColor: '#fff', flexDirection: 'row', justifyContent: 'space-between', padding: 10, position: 'absolute', bottom: 0, width: '100%' }}>
                    <View style={{ borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, width: 157, paddingTop: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>保存并继续添加</Text>
                    </View>
                    <View style={{ backgroundColor: '#eb4e4e', borderRadius: 4, width: 200, paddingTop: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#fff', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>保存</Text>
                    </View>
                </View>
            </View>
        )
    }
}
//封装一个日期组件
class CustomButton extends React.Component {
    render() {
        return (
            <TouchableOpacity style={styles.lanmulast} onPress={this.props.onPress}>
                <View style={styles.right}>
                    <Text style={styles.font}>{this.props.text}</Text>
                </View>
            </TouchableOpacity>

        );
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    vie: {
        marginTop: 11,
        padding: 11,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: '#fff',
    },
    vielast: {
        marginTop: 11,
        padding: 11,
        backgroundColor: '#fff',
    },
    tex: {
        color: '#000',
        fontSize: 17.6,
    },
    input: {
        fontSize: 15.5,
        width: 150,
        padding: 0,
        textAlign: 'right',
    },
    font: {
        color: '#000',
        fontSize: 15,
        marginRight: 10,
    },
    right: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    img: {
        width: 8,
        height: 12,
    },
})