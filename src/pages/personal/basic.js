/*
 * @Author: stl
 * @Date: 2019-03-15 11:23:11 
 * @Module:基本信息
 * @Last Modified time: 2019-03-15 11:23:11 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, DatePickerAndroid, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid } from 'react-native';
import Camerabutton from '../../component/camerabutton'
import Icon from "react-native-vector-icons/iconfont";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            gr: true,//工人菜单收缩控制
            bz: true,//班组长菜单收缩控制
            presetDate: new Date(2019, 3, 4),//生日时间
            presetText: '--',
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
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
            GLOBAL.editbasic.birthday = date.toLocaleDateString()//赋值给全局变量
            this.refreshFun()//手动刷新
        } catch ({ code, message }) {
            console.warn(`Error in example '${stateKey}': `, message);
        }
    }
    render() {
        return (
            <View style={{ flex: 1 }}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>基本信息</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>保存</Text>
                    </TouchableOpacity>
                </View>
                <ScrollView style={styles.main}>

                    {/* 白色背景模块 */}
                    <View style={styles.module}>
                        {/* 头像 */}
                        <Camerabutton />
                        {/* 姓名 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Editname', {
                            callback: (() => {
                                this.setState({})
                            })
                        })}
                            style={styles.lanmu}>
                            {/* 左 */}
                            <View>
                                <Text style={styles.font}>姓名</Text>
                            </View>
                            {/* 右 */}
                            <View style={styles.right}>
                                <Text style={styles.font}>{GLOBAL.editbasic.name}</Text>
                                <Icon name="r-arrow" size={12} color="#000" />
                            </View>
                        </TouchableOpacity>
                        {/* 性别 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Editsex', {
                            callback: (() => {
                                this.setState({})
                            })
                        })} style={styles.lanmu}>
                            {/* 左 */}
                            <View>
                                <Text style={styles.font}>性别</Text>
                            </View>
                            {/* 右 */}
                            <View style={styles.right}>
                                <Text style={styles.font}>{GLOBAL.editbasic.sex}</Text>
                                <Icon name="r-arrow" size={12} color="#000" />
                            </View>
                        </TouchableOpacity>
                        {/* 名族 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Nation', {
                            callback: (() => {
                                this.setState({})
                            })
                        })}
                            style={styles.lanmu}>
                            {/* 左 */}
                            <View>
                                <Text style={styles.font}>名族</Text>
                            </View>
                            {/* 右 */}
                            <View style={styles.right}>
                                <Text style={styles.font}>{GLOBAL.editbasic.nation}</Text>
                                <Icon name="r-arrow" size={12} color="#000" />
                            </View>
                        </TouchableOpacity>
                        {/* 生日 */}
                        <CustomButton text={this.state.presetText}
                            onPress={this.showPicker.bind(this, 'preset', { date: this.state.presetDate })} />
                    </View>

                    <View style={styles.module}>
                        {/* 工龄 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Workingyears', {
                            callback: (() => {
                                this.setState({})
                            })
                        })} style={styles.lanmu}>
                            <View>
                                <Text style={styles.font}>工龄</Text>
                            </View>
                            <View style={styles.right}>
                                <Text style={styles.font}>{GLOBAL.editbasic.workingyears}</Text>
                                <Icon name="r-arrow" size={12} color="#000" />
                            </View>
                        </TouchableOpacity>
                        {/* 家乡 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Hometown', {
                            callback: (() => {
                                this.setState({})
                            })
                        })} style={styles.lanmu}>
                            <View>
                                <Text style={styles.font}>家乡</Text>
                            </View>
                            <View style={styles.right}>
                                <Text style={styles.font}>{GLOBAL.editbasic.jxaddress.jxoneName} {GLOBAL.editbasic.jxaddress.jxtwoName} {GLOBAL.editbasic.jxaddress.jxthreeName}</Text>
                                <Icon name="r-arrow" size={12} color="#000" />
                            </View>
                        </TouchableOpacity>
                        {/* 期望工作地 */}
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Hopeaddress', {
                            callback: (() => {
                                this.setState({})
                            })
                        })} style={styles.lanmulast}>
                            <View>
                                <Text style={styles.font}>期望工作地</Text>
                            </View>
                            <View style={styles.right}>
                                <Text style={styles.font}>{GLOBAL.editbasic.qwaddress.qwoneName} {GLOBAL.editbasic.qwaddress.qwtwoName}</Text>
                                <Icon name="r-arrow" size={12} color="#000" />
                            </View>
                        </TouchableOpacity>
                    </View>
                    {/* 我是工人 */}
                    <View style={styles.shrink}>
                        <TouchableOpacity onPress={() => this.grclick()} style={styles.gr}>
                            <View style={styles.grl}>
                                <Text style={styles.boldfont}>我是工人</Text>
                                <Text style={styles.grayfont}>如果你是班组长，可不填此区域</Text>
                            </View>
                            {
                                this.state.gr ? (
                                    <View style={styles.grr}>
                                        <Text style={styles.fontsiml}>收起</Text>
                                        <Icon style={{transform: [{ rotate: '270deg' }]}} name="r-arrow" size={12} color="#000" />
                                    </View>
                                ) : (
                                        <View style={styles.grr}>
                                            <Text style={styles.fontsiml}>展开</Text>
                                            <Icon style={{transform: [{ rotate: '90deg' }]}} name="r-arrow" size={12} color="#000" />
                                        </View>
                                    )
                            }

                        </TouchableOpacity>

                        {
                            this.state.gr ? (
                                <View>
                                    <TouchableOpacity onPress={() => this.props.navigation.navigate('Workcate', {
                                        callback: (() => {
                                            this.setState({})
                                        })
                                    })} style={styles.leftview}>
                                        <View>
                                            <Text style={styles.font}>工程类别</Text>
                                        </View>
                                        <View style={styles.right}>
                                            {
                                                GLOBAL.editbasic.worktypelb.map((item, index) => {
                                                    return (
                                                        <Text style={styles.font} key={index}>{item}</Text>
                                                    )
                                                })
                                            }
                                            {/* <Text style={styles.font}>土建</Text> */}
                                            <Icon name="r-arrow" size={12} color="#000" />
                                        </View>
                                    </TouchableOpacity>

                                    <TouchableOpacity onPress={() => this.props.navigation.navigate('Typework', {
                                        callback: (() => {
                                            this.setState({})
                                        })
                                    })} style={styles.leftview}>
                                        <View>
                                            <Text style={styles.font}>工种</Text>
                                        </View>
                                        <View style={styles.right}>
                                            {
                                                GLOBAL.editbasic.worktype.map((item, index) => {
                                                    return (
                                                        <Text style={styles.font} key={index}>{item}</Text>
                                                    )
                                                })
                                            }
                                            {/* <Text style={styles.font}>木工</Text> */}
                                            <Icon name="r-arrow" size={12} color="#000" />
                                        </View>
                                    </TouchableOpacity>

                                    <TouchableOpacity onPress={() => this.props.navigation.navigate('Mastery', {
                                        callback: (() => {
                                            this.setState({})
                                        })
                                    })} style={styles.leftviewlast}>
                                        <View>
                                            <Text style={styles.font}>熟练度</Text>
                                        </View>
                                        <View style={styles.right}>
                                            <Text style={styles.font}>{GLOBAL.editbasic.mastery}</Text>
                                            <Icon name="r-arrow" size={12} color="#000" />
                                        </View>
                                    </TouchableOpacity>

                                </View>
                            ) : (
                                    <View></View>
                                )
                        }
                    </View>
                    {/* 我是班组长 */}
                    <View style={styles.shrinklast}>
                        <TouchableOpacity onPress={() => this.bzclick()} style={styles.gr}>
                            <View style={styles.grl}>
                                <Text style={styles.boldfont}>我是班组长</Text>
                                <Text style={styles.grayfont}>如果你是工人，可不填此区域</Text>
                            </View>
                            {
                                this.state.bz ? (
                                    <View style={styles.grr}>
                                        <Text style={styles.fontsiml}>收起</Text>
                                        <Icon style={{transform: [{ rotate: '270deg' }]}} name="r-arrow" size={12} color="#000" />
                                    </View>
                                ) : (
                                        <View style={styles.grr}>
                                            <Text style={styles.fontsiml}>展开</Text>
                                            <Icon style={{transform: [{ rotate: '270deg' }]}} name="r-arrow" size={12} color="#000" />
                                        </View>
                                    )
                            }
                        </TouchableOpacity>
                        {
                            this.state.bz ? (
                                <View>
                                    <TouchableOpacity style={styles.leftview}>
                                        <View>
                                            <Text style={styles.font}>工程类别</Text>
                                        </View>
                                        <View style={styles.right}>
                                            <Text style={styles.font}>土建</Text>
                                            <Icon name="r-arrow" size={12} color="#000" />
                                        </View>
                                    </TouchableOpacity>

                                    <View style={styles.leftview}>
                                        <View>
                                            <Text style={styles.font}>工种</Text>
                                        </View>
                                        <View style={styles.right}>
                                            <Text style={styles.font}>木工</Text>
                                            <Icon name="r-arrow" size={12} color="#000" />
                                        </View>
                                    </View>

                                    <View style={styles.leftviewlast}>
                                        <View>
                                            <Text style={styles.font}>队伍人数</Text>
                                        </View>
                                        <View style={styles.right}>
                                            <Text style={styles.font}>100人</Text>
                                            <Icon name="r-arrow" size={12} color="#000" />
                                        </View>
                                    </View>
                                </View>
                            ) : (
                                    <View></View>
                                )
                        }


                    </View>
                </ScrollView>
            </View>
        )
    }
    // 工人栏收缩
    grclick() {
        this.setState({
            gr: !this.state.gr
        })
    }
    // 班组长栏收缩
    bzclick() {
        this.setState({
            bz: !this.state.bz
        })
    }
    // 手动刷新
    refreshFun() {
        this.setState({})
    }
}
//封装一个日期组件
class CustomButton extends React.Component {
    render() {
        return (
            <TouchableOpacity style={styles.lanmulast} onPress={this.props.onPress}>
                {/* 左 */}
                <View>
                    <Text style={styles.font}>生日</Text>
                </View>
                {/* 右 */}
                <View style={styles.right}>
                    <Text style={styles.font}>{this.props.text}</Text>
                    <Icon name="r-arrow" size={12} color="#000" />
                </View>
            </TouchableOpacity>

        );
    }
}
const styles = StyleSheet.create({
    leftview: {
        marginLeft: 32,
        marginRight: 10,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingTop: 16,
        paddingBottom: 16,
        borderBottomWidth: 1,
        borderBottomColor: '#ebebeb',
    },
    leftviewlast: {
        marginLeft: 32,
        marginRight: 10,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingTop: 16,
        paddingBottom: 16,
    },
    main: {
        backgroundColor: '#ebebeb',
        flex: 1,
    },
    module: {
        backgroundColor: '#fff',
        marginBottom: 10,
        paddingLeft: 10, paddingRight: 10
    },
    lanmu: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingTop: 16,
        paddingBottom: 16,
        borderBottomWidth: 1,
        borderBottomColor: '#ebebeb',
    },
    lanmulast: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingTop: 16,
        paddingBottom: 16,
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
    imgs: {
        width: 8,
        height: 12,
        transform: [{ rotate: '270deg' }]
    },
    imgsk: {
        width: 8,
        height: 12,
        transform: [{ rotate: '90deg' }]
    },
    shrink: {
        backgroundColor: '#fff',
        marginBottom: 10,
    },
    shrinklast: {
        backgroundColor: '#fff',
        marginBottom: 100,
    },
    gr: {
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 7,
        paddingBottom: 7,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        borderBottomWidth: 1,
        borderBottomColor: '#ebebeb',
    },
    grl: {},
    grr: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    boldfont: {
        color: '#000',
        fontSize: 16,
        fontWeight: '400',
    },
    grayfont: {
        color: '#666',
        fontSize: 12.8,
        fontWeight: '400',
    },
    fontsiml: {
        color: "#000",
        fontSize: 12.8,
        marginRight: 10,
    },
})