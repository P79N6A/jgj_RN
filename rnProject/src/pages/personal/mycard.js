/*
 * @Author: stl
 * @Date: 2019-03-14 14:50:52 
 * @Module: 我的找活名片
 * @Last Modified time: 2019-03-14 14:50:52 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid } from 'react-native';
import BottomAlert from '../../component/bottomalert'
import Icon from "react-native-vector-icons/Ionicons";

export default class mycard extends Component {
    constructor(props) {
        super(props)
        this.state = {
            orbottomalert: false,//底部弹窗是否打开
            worktype: '未开工正在找工作',
            ifzwjs: true,//自我介绍是否有内容
            zwjs: '自我介绍内容自我介绍内容自我介绍内容自我介绍内容自我介绍内容',
            ifxmjy: true,//项目经验是否有内容
            ifzyjn: true,//职业技能是否有内容
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>我的找活名片</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <ScrollView>
                    {/* 名片完善度 */}
                    <View style={{ marginTop: 10, padding: 10, flexDirection: 'row', justifyContent: 'space-between', backgroundColor: '#fff' }}>
                        <View>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={styles.font}>名片完善度：</Text>
                                <ProgressBarAndroid
                                    style={{ marginRight: 5, width: 128 }}
                                    styleAttr="Horizontal"
                                    indeterminate={false}
                                    progress={0.25}
                                    color='red'
                                />
                                <Text style={{ color: '#000', fontSize: 12.5 }}>25%</Text>
                            </View>
                            <View><Text style={{ color: '#666', fontSize: 12 }}>名片越完善，找活越容易</Text></View>
                        </View>
                        {/* 谁看过我 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Readme')}>
                            <Text style={{ color: '#000', fontSize: 16, textAlign: 'center' }}>0</Text>
                            <Text style={{ color: '#000', fontSize: 13, textAlign: 'center' }}>谁看过我</Text>
                        </TouchableOpacity>
                    </View>
                    {/* 我的工作状态 */}
                    <View style={{ marginTop: 10, padding: 10, flexDirection: 'row', justifyContent: 'space-between', backgroundColor: '#fff' }}>
                        <View><Text style={styles.font}>我的工作状态：</Text></View>
                        <TouchableOpacity onPress={() => this.selectwork()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Text style={{ color: '#eb4e4e', fontWeight: '700', fontSize: 15 }}>{this.state.worktype}</Text>
                            <Icon style={{marginLeft: 10}} name="r-arrow" size={12} color="#000" />
                        </TouchableOpacity>
                    </View>
                    {/* 个人信息 */}
                    <View style={{ marginTop: 10, paddingLeft: 10, paddingRight: 10, paddingTop: 22, backgroundColor: '#fff' }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row' }}>
                                {/* 头像 */}
                                <View style={{ width: 68, height: 68, borderRadius: 2, borderWidth: 1, borderColor: '#eee', marginRight: 20, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                    <Image style={{ width: 66, height: 66 }} source={require('../../assets/recruit/header.png')}></Image>
                                </View>
                                {/* 姓名 */}
                                <View style={{ paddingTop: 5 }}>
                                    <Text style={{ color: '#030303', fontSize: 19, marginBottom: 10 }}>姓名</Text>
                                    <Text style={{ color: '#666', fontSize: 15 }}>男  0岁</Text>
                                </View>
                            </View>
                            <TouchableOpacity onPress={() => this.props.navigation.navigate('Basic')} style={{
                                borderColor: 'rgb(235, 78, 78)',
                                borderWidth: 1,
                                borderRadius: 4,
                                height: 25,
                                flexDirection: 'row',
                                alignItems: 'center',
                                justifyContent: 'center',
                                paddingLeft: 10,
                                paddingRight: 10,
                                paddingTop: 2,
                                paddingBottom: 2
                            }}>
                                <Text style={styles.fontred}>编辑</Text>
                            </TouchableOpacity>
                        </View>
                        {/* 基本信息 */}
                        <View style={{ paddingTop: 18, paddingBottom: 18, backgroundColor: '#fff' }}>
                            <View style={{ height: 27 }}>
                                <Text style={styles.font}>工        龄：23年</Text>
                            </View>
                            <View style={{ height: 27 }}>
                                <Text style={styles.font}>家        乡：四川省 成都市</Text>
                            </View>
                            <View style={{ height: 27, marginBottom: 21 }}>
                                <Text style={styles.font}>期望工作地：</Text>
                            </View>
                            <View style={{ height: 24, marginBottom: 10 }}>
                                <Text style={{ color: '#666', fontSize: 16 }}>我是工人：</Text>
                            </View>
                            {/* 工程类别 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>工程类别：</Text>
                                <Text style={styles.fontrs}>消防 | 土建</Text>
                            </View>
                            {/* 工种 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>工        种：</Text>
                                <Text style={styles.fontrs}>木工 | 架子工 | 钢筋工 | 小工 杂工 | 制模工中</Text>
                            </View>

                            <View style={{ height: 27 }}>
                                <Text style={styles.font}>熟  练  度：高级工(大工)</Text>
                            </View>
                        </View>
                    </View>
                    {/* 自我介绍 */}
                    <View style={styles.tit}>
                        <Text style={styles.titfont}>自我介绍</Text>
                        {
                            this.state.ifzwjs ? (
                                <TouchableOpacity onPress={() => this.props.navigation.navigate('Selfintrod')} style={styles.btns}>
                                    <Text style={styles.btnfont}>编辑</Text>
                                </TouchableOpacity>
                            ) : (
                                    <View></View>
                                )
                        }
                    </View>
                    {
                        this.state.ifzwjs ? (
                            <View style={styles.whites}>
                                <Text style={styles.font}>{this.state.zwjs}</Text>
                            </View>
                        ) : (
                                <View style={styles.white}>
                                    <Text style={styles.jsfont}>完善自我介绍能让招工方充分了解你或你的队伍</Text>
                                    <View style={styles.btnw}>
                                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Selfintrod')} style={styles.btn}>
                                            <Text style={styles.btnfont}>去完善</Text>
                                        </TouchableOpacity>
                                    </View>
                                </View>
                            )
                    }
                    {/* 项目经验 */}
                    <View style={styles.tit}>
                        <Text style={styles.titfont}>项目经验</Text>
                        {
                            this.state.ifxmjy ? (
                                <TouchableOpacity onPress={() => this.props.navigation.navigate('Addproject')} style={styles.btns}>
                                    <Text style={styles.btnfont}>添加</Text>
                                </TouchableOpacity>
                            ) : (
                                    <View></View>
                                )
                        }
                    </View>
                    {
                        this.state.ifxmjy ? (
                            <View style={styles.whitesxm}>
                                <Text style={{ color: '#000', fontSize: 16.5 }}>项目名称</Text>
                                <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 5.5, marginBottom: 11 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginRight: 22 }}>2019.03</Text>
                                    <Text style={{ color: '#999', fontSize: 13.2 }}>四川省  成都市</Text>
                                </View>
                                <View style={{ flexWrap: 'wrap', flexDirection: 'row' }}>
                                    <Image style={{ width: 105, height: 105, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../assets/personal/img.jpg')}></Image>
                                </View>
                                <View style={{ paddingLeft: 11, paddingRight: 11, paddingTop: 16, paddingBottom: 16, marginBottom: 27, backgroundColor: '#ebebeb' }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>经历描述</Text>
                                </View>
                                <View style={{ flexDirection: 'row', justifyContent: "center" }}>
                                    <TouchableOpacity
                                        onPress={() => this.props.navigation.navigate('Proexper')}
                                        style={{
                                            width: 133, height: 30, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                            borderColor: 'rgb(153, 153, 153)', borderWidth: 1, borderRadius: 2.2
                                        }}>
                                        <Text style={{ color: '#000', fontSize: 15.4 }}>更多项目经验</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        ) : (
                                <View style={styles.white}>
                                    <Text style={styles.jsfont}>添加项目经验可提升招工方对你的信任程度</Text>
                                    <View style={styles.btnw}>
                                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Addproject')} style={styles.btn}>
                                            <Text style={styles.btnfont}>添加项目经验</Text>
                                        </TouchableOpacity>
                                    </View>
                                </View>
                            )
                    }
                    {/* 职业技能 */}
                    <View style={styles.tit}>
                        <Text style={styles.titfont}>职业技能</Text>
                        {
                            this.state.ifzyjn ? (
                                <TouchableOpacity onPress={() => this.props.navigation.navigate('Vocationskill')} style={styles.btns}>
                                    <Text style={styles.btnfont}>编辑</Text>
                                </TouchableOpacity>
                            ) : (
                                    <View></View>
                                )
                        }
                    </View>

                    {
                        this.state.ifzyjn ? (
                            <View style={styles.whitelasts}>
                                <Text style={{ color: '#000', fontSize: 16.5, marginBottom: 15 }}>技能1 | 新技能2</Text>
                                <View style={{ flexWrap: 'wrap', flexDirection: 'row' }}>
                                    <Image style={{ width: 105, height: 105, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../assets/personal/img.jpg')}></Image>
                                </View>
                            </View>
                        ) : (
                                <View style={styles.whitelast}>
                                    <Text style={styles.jsfont}>添加职业技能，用实力证明的的能力！</Text>
                                    <View style={styles.btnw}>
                                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Vocationskill')} style={styles.btn}>
                                            <Text style={styles.btnfont}>添加职业技能</Text>
                                        </TouchableOpacity>
                                    </View>
                                </View>
                            )
                    }
                </ScrollView>
                {/* 底部固定按钮 */}
                <View style={{ height: 64, backgroundColor: '#fff', flexDirection: 'row', justifyContent: 'space-between', padding: 10, position: 'absolute', bottom: 0, width: '100%' }}>
                    <View style={{ borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, width: 157, paddingTop: 3 }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>刷新名片</Text>
                        <Text style={{ color: '#666', fontSize: 12, textAlign: 'center', lineHeight: 15 }}>让名片显示位置更靠前</Text>
                    </View>
                    <TouchableOpacity onPress={() => this.props.navigation.navigate('Preview')} style={{ backgroundColor: '#eb4e4e', borderRadius: 4, width: 200, paddingTop: 3 }}>
                        <Text style={{ color: '#fff', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>预览/分享名片</Text>
                        <Text style={{ color: '#fff', fontSize: 12, textAlign: 'center', lineHeight: 15 }}>找活成功率提升10倍</Text>
                    </TouchableOpacity>
                </View>
                {/* 底部modal弹框选择工作状态 */}
                <BottomAlert orbottomalert={this.state.orbottomalert} selectwork={this.selectwork.bind(this)} />
            </View>
        )
    }
    //选择工作状态按钮
    selectwork(e) {
        if (e) {
            this.setState({
                orbottomalert: !this.state.orbottomalert,
                worktype: e
            })
        } else {
            this.setState({
                orbottomalert: !this.state.orbottomalert
            })
        }
    }
}
const styles = StyleSheet.create({
    btns: {
        width: 50,
        height: 25,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 1,
        borderColor: '#eb4e4e',
        borderRadius: 4.4,
    },
    btnfont: {
        color: '#eb4e4e',
        fontSize: 13.2,
    },
    main: {
        backgroundColor: '#ebebeb',
        flex: 1,
    },
    font: {
        color: '#000',
        fontSize: 16,
        fontWeight: '400'
    },
    fontred: {
        color: '#eb4e4e',
        fontSize: 12,
    },
    tit: {
        height: 45,
        padding: 10,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    titfont: {
        color: "#000",
        fontSize: 16,
        fontWeight: '700',
    },
    white: {
        backgroundColor: '#fff',
        paddingTop: 32,
        paddingBottom: 32,
    },
    whites: {
        backgroundColor: '#fff',
        paddingLeft: 13,
        paddingRight: 13,
        paddingTop: 16,
        paddingBottom: 16
    },
    whitesxm: {
        backgroundColor: '#fff',
        paddingLeft: 11,
        paddingRight: 11,
        paddingTop: 22,
        paddingBottom: 22
    },
    whitelast: {
        backgroundColor: '#fff',
        paddingTop: 32,
        paddingBottom: 32,
        marginBottom: 90,
    },
    whitelasts: {
        backgroundColor: '#fff',
        paddingTop: 16,
        paddingBottom: 16,
        paddingLeft: 11,
        paddingRight: 11,
        marginBottom: 90,
    },
    jsfont: {
        color: '#999',
        fontSize: 13.8,
        textAlign: 'center'
    },
    btnw: {
        flexDirection: 'row',
        justifyContent: 'center',
    },
    btn: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        borderColor: 'rgb(235, 78, 78)',
        borderWidth: 1,
        borderRadius: 2,
        width: 126,
        height: 30,
        marginTop: 10,
    },
    btnfont: {
        color: '#eb4e4e',
        fontSize: 15,
    },
    lanmu: {
        marginTop: 4.5,
        marginBottom: 4.5,
        flexDirection: 'row',
        alignItems: 'flex-start',

    },
    fontl: {
        color: "#000",
        fontSize: 15.4
    },
    fontr: {
        color: "#000",
        fontSize: 15.4
    },
    fontrs: {
        color: "#000",
        fontSize: 15.4,
        flexWrap: 'wrap',
        width: 280,
    },
})