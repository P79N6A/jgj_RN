/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 18:20:32 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 14:20:34
 * Module:招聘信息详情填写
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    TouchableOpacity,
    TextInput,
    ScrollView,
    DeviceEventEmitter,
    DatePickerAndroid,
    Button,
    Platform,
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import DateTimePicker from "react-native-modal-datetime-picker";
import Icon from "react-native-vector-icons/iconfont";
import Loading from '../../component/loading'
import fetchFun from '../../fetch/fetch'
import AlertUser from '../../component/alertuser'
import Rolealert from '../../component/rolealert'

export default class releasedetail extends Component {
    constructor(props) {
        super(props)
        this.state = {
            dgorbg: true,//点工、包工
            rxoryx: true,//计薪方式（日薪）
            dj: '元/平方米',//单价单位

            openAlert: false,//加载弹框
            warning: '请输入所需人数',

            pid: '0',//项目id，修改项目的时候传
            peopleNum: '',//所需人数
            describe: '',//项目描述
            presetDate: new Date(2019, 3, 4),//开工时间
            presetText: '',//突击队开工时间
            money: '',
            max_money: '',
            total_scale: '',//工程规模
            welfareArr: [],//福利待遇
            selectWelfare: [],//选择的福利待遇
            addWelfareInput: '',
            unitMoney: '',//包工的单价
            pro_work_name: '',//项目名称
            company_name: '',//施工单位名称
            work_day: '1',//突击队用工天数
            work_hour: '8',//突击队工作时长
            payType: 'd',//结算方式
            projectUnit: '3',//工程规模单位

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: 'fbzg',//实名or认证、突击
            isDateTimePickerVisible: false,
            // ---------------------------------------

            orbottomalert: false,//单价选择弹框
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    //进行创建时间日期选择器
    async showPicker(stateKey, options) {
        console.log('showpicker')
        try {
            var newState = {};
            const { action, year, month, day } = await DatePickerAndroid.open({ date: new Date() });
            if (action === DatePickerAndroid.dismissedAction) {
                newState[stateKey + 'Text'] = 'dismissed';
            } else {
                var date = new Date(year, month, day);
                newState[stateKey + 'Text'] = date.toLocaleDateString();//选择的时间
                // newState[stateKey + 'Date'] = date;
            }
            // alert(date)
            // alert(date.toLocaleDateString())
            this.setState({
                // presetText: date.toLocaleDateString().split('/').join('-')
                presetText: date.toLocaleDateString()
            });
        } catch ({ code, message }) {
            console.warn(`Error in example '${stateKey}': `, message);
        }
    }
    componentDidMount() {

        // 发布招工选择：班组-总包,人数栏消失
        if (GLOBAL.fbzgType.fbzgTypeName == '总包') {
            this.setState({
                peopleNum: '1'
            })
        }
        // let { item } = this.props.navigation.state.params
        // 修改招工信息
        if (this.props.navigation.getParam('edit')) {
            console.log('修改招工信息', this.props.navigation.getParam('item'))
            GLOBAL.fbzgAddress.detailAddress = this.props.navigation.getParam('item')?this.props.navigation.getParam('item').pro_address:'',//详细地址
                this.setState({
                    dgorbg: this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '点工' ? true : false,//点工-包工
                    rxoryx: this.props.navigation.getParam('item').classes[0].balance_way == '天' ? true : false,//日薪-月薪
                    payType: this.props.navigation.getParam('item').classes[0].balance_way == '天' ? 'd' : 'm',
                    // dj: this.props.navigation.getParam('item').classes[0].balance_way + '',//单位
                    dj: this.props.navigation.getParam('item').classes[0].balance_way + '',//单位
                    unitMoney: Number(this.props.navigation.getParam('item').classes[0].unitMoney) != 0 ? this.props.navigation.getParam('item').classes[0].unitMoney + '' : '',//单价
                    total_scale: Number(this.props.navigation.getParam('item').classes[0].total_scale) != 0 ? this.props.navigation.getParam('item').classes[0].total_scale + '' : '',//工程规模
                    money: Number(this.props.navigation.getParam('item').classes[0].money) != 0 ? this.props.navigation.getParam('item').classes[0].money + '' : '',//总价
                    max_money: this.props.navigation.getParam('item').classes[0].hasOwnProperty('max_money') ? this.props.navigation.getParam('item').classes[0].max_money + '' : '',
                    peopleNum: Number(this.props.navigation.getParam('item').classes[0].person_count) != 0 ? this.props.navigation.getParam('item').classes[0].person_count + '' : '',//所需人数
                    selectWelfare: this.props.navigation.getParam('item').welfare,//待遇
                    pro_work_name: this.props.navigation.getParam('item').pro_work_name,//项目名称
                    company_name: this.props.navigation.getParam('item').company_name,//施工单位名称
                    describe: this.props.navigation.getParam('item').pro_description,//项目描述
                    presetText: this.props.navigation.getParam('item').classes[0].work_begin,//开工时间
                    work_day: Number(this.props.navigation.getParam('item').classes[0].work_day) != 0 ? this.props.navigation.getParam('item').classes[0].work_day : '',//用工天数
                    work_hour: Number(this.props.navigation.getParam('item').classes[0].work_hour) != 0 ? this.props.navigation.getParam('item').classes[0].work_hour : '',//突击队工作时长
                    pro_type: this.props.navigation.getParam('item').classes[0].pro_type.type_id
                })
        }
        // 获取福利选项
        this.WelfareFun()
    }
    // 获取福利选项
    WelfareFun() {
        fetchFun.load({
            url: 'jlcfg/classlist',
            data: {
                class_id: '31'
            },
            success: (res) => {
                console.log('---获取福利待遇---', res)
                let arr = this.state.welfareArr
                res.map((v, i) => {
                    arr.push(v.name)
                })
                this.setState({
                    welfareArr: arr
                }, () => {
                    if (this.props.navigation.getParam('item')) {
                        this.updateWelfare()
                    }
                })
            }
        });
    }
    updateWelfare() {
        // 福利待遇
        let arr = this.state.welfareArr
        this.state.selectWelfare.map((v, i) => {
            // #20477
            if (!arr.includes(v) && v.length > 0) {
                arr.push(v)
            }
        })
        this.setState({
            welfareArr: arr
        })
    }

    showDateTimePicker = () => {
        this.setState({ isDateTimePickerVisible: true });
    };

    hideDateTimePicker = () => {
        this.setState({ isDateTimePickerVisible: false });
    };

    handleDatePicked = date => {
        console.log("A date has been picked: ", date.toString());
        let month = ''
        let arr = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        arr.map((v, i) => {
            if (v == date.toString().split(' ')[1]) {
                if (i + 1 < 10) {
                    month = '0' + (i + 1)
                } else {
                    month = i + 1
                }
            }
        })

        this.setState({
            // presetText: date.toLocaleDateString().split('/').join('-')
            presetText: `${date.toString().split(' ')[3]}-${month}-${date.toString().split(' ')[2]}`
        });
        this.hideDateTimePicker();
    };

    render() {
        return (
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
                {/* 导航条 */}
                {
                    this.props.navigation.getParam('type') ? (
                        <View style={{
                            height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                            flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '15%' }}
                                onPress={() => {
                                    this.props.navigation.goBack();
                                    GLOBAL.fbzgAddress.detailAddress = '请选择所在地'
                                }}>
                                <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                                <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                            </TouchableOpacity>
                            <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                                <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                                    {this.props.navigation.getParam('type')}({this.props.navigation.getParam('fbzgTypeName') == '其它工种' ? this.props.navigation.getParam('fbzgTypeNameOther') : this.props.navigation.getParam('fbzgTypeName')})
                                </Text>
                            </View>
                            <TouchableOpacity activeOpacity={.7}
                                style={{ width: '15%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                            </TouchableOpacity>
                        </View>
                    ) : (
                            this.props.navigation.getParam('item') ? (
                                <View style={{
                                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                                }}>
                                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '15%' }}
                                        onPress={() => this.props.navigation.goBack()}>
                                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                                    </TouchableOpacity>
                                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                                            {this.props.navigation.getParam('item').role_type == 1 ? '招工人' : (
                                                this.props.navigation.getParam('item').role_type == 2 ? '招班组长' : '招突击队'
                                            )}(
                                            {this.props.navigation.getParam('item').classes[0].work_type.type_name}
                                            )
                                    </Text>
                                    </View>
                                    <TouchableOpacity activeOpacity={.7}
                                        style={{ width: '15%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                                    </TouchableOpacity>
                                </View>
                            ) : false
                        )
                }

                <ScrollView style={{ marginBottom: 50 }} keyboardDismissMode={'on-drag'}>
                    {
                        this.props.navigation.getParam('type') ? (
                            this.props.navigation.getParam('type') == '招突击队' ? false : (
                                GLOBAL.fbzgType.fbzgTypeName == '总包' || (this.props.navigation.getParam('item') && this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '总包') ? (
                                    <View style={{ marginTop: 10 }}></View>
                                ) : (
                                        <View>
                                            {/* 用工类型 */}
                                            <View style={{
                                                paddingLeft: 13, paddingRight: 13, marginTop: 11, marginBottom: 11, backgroundColor: '#fff', paddingTop: 17, paddingBottom: 17,
                                                flexDirection: 'row', height: 50, alignItems: 'center'
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>用工类型</Text>
                                                <View style={{ flexDirection: 'row' }}>
                                                    {/* 点工 */}
                                                    <TouchableOpacity activeOpacity={.7} onPress={() => this.dgFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
                                                        {
                                                            this.state.dgorbg ? (
                                                                <View style={{
                                                                    borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                }}>
                                                                    <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                </View>
                                                            ) : (
                                                                    <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                )
                                                        }
                                                        <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>点工</Text>
                                                    </TouchableOpacity>
                                                    {/* 包工 */}
                                                    <TouchableOpacity activeOpacity={.7} onPress={() => this.bgFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                        {
                                                            !this.state.dgorbg ? (
                                                                <View style={{
                                                                    borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                }}>
                                                                    <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                </View>
                                                            ) : (
                                                                    <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                )
                                                        }
                                                        <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>包工</Text>
                                                    </TouchableOpacity>
                                                </View>
                                            </View>

                                            {/* 计薪方式 */}
                                            {
                                                this.state.dgorbg ? (
                                                    <View style={{
                                                        paddingLeft: 13, paddingRight: 13, backgroundColor: '#fff',
                                                        flexDirection: 'row', height: 50, alignItems: 'center', borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                                                    }}>
                                                        <View style={{ borderBottomWidth: 1, borderBottomColor: '#ebebeb', flex: 1, flexDirection: 'row', paddingTop: 17, paddingBottom: 17, }}>
                                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>计薪方式</Text>
                                                            <View style={{ flexDirection: 'row' }}>
                                                                {/* 日薪 */}
                                                                <TouchableOpacity activeOpacity={.7} onPress={() => this.rxFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
                                                                    {
                                                                        this.state.rxoryx ? (
                                                                            <View style={{
                                                                                borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                            }}>
                                                                                <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                            </View>
                                                                        ) : (
                                                                                <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                            )
                                                                    }
                                                                    <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>日薪</Text>
                                                                </TouchableOpacity>
                                                                {/* 月薪 */}
                                                                <TouchableOpacity activeOpacity={.7} onPress={() => this.yxFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                                    {
                                                                        !this.state.rxoryx ? (
                                                                            <View style={{
                                                                                borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                            }}>
                                                                                <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                            </View>
                                                                        ) : (
                                                                                <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                            )
                                                                    }
                                                                    <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>月薪</Text>
                                                                </TouchableOpacity>
                                                            </View>
                                                        </View>
                                                    </View>
                                                ) : false
                                            }
                                        </View>
                                    )
                            )
                        ) : (
                                this.props.navigation.getParam('item') ? (
                                    this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '突击队' ? false : (
                                        this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '总包' ? (
                                            <View style={{ marginTop: 10 }}></View>
                                        ) : (
                                                <View>
                                                    {/* 用工类型 */}
                                                    <View style={{
                                                        paddingLeft: 13, paddingRight: 13, marginTop: 11, marginBottom: 11, backgroundColor: '#fff', paddingTop: 17, paddingBottom: 17,
                                                        flexDirection: 'row', height: 50, alignItems: 'center'
                                                    }}>
                                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>用工类型</Text>
                                                        <View style={{ flexDirection: 'row' }}>
                                                            {/* 点工 */}
                                                            <TouchableOpacity activeOpacity={.7} onPress={() => this.dgFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
                                                                {
                                                                    this.state.dgorbg ? (
                                                                        <View style={{
                                                                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                        }}>
                                                                            <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                        </View>
                                                                    ) : (
                                                                            <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                        )
                                                                }
                                                                <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>点工</Text>
                                                            </TouchableOpacity>
                                                            {/* 包工 */}
                                                            <TouchableOpacity activeOpacity={.7} onPress={() => this.bgFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                                {
                                                                    !this.state.dgorbg ? (
                                                                        <View style={{
                                                                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                        }}>
                                                                            <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                        </View>
                                                                    ) : (
                                                                            <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                        )
                                                                }
                                                                <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>包工</Text>
                                                            </TouchableOpacity>
                                                        </View>
                                                    </View>

                                                    {/* 计薪方式 */}
                                                    {
                                                        this.state.dgorbg ? (
                                                            <View style={{
                                                                paddingLeft: 13, paddingRight: 13, backgroundColor: '#fff',
                                                                flexDirection: 'row', height: 50, alignItems: 'center', borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                                                            }}>
                                                                <View style={{ borderBottomWidth: 1, borderBottomColor: '#ebebeb', flex: 1, flexDirection: 'row', paddingTop: 17, paddingBottom: 17, }}>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>计薪方式</Text>
                                                                    <View style={{ flexDirection: 'row' }}>
                                                                        {/* 日薪 */}
                                                                        <TouchableOpacity activeOpacity={.7} onPress={() => this.rxFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
                                                                            {
                                                                                this.state.rxoryx ? (
                                                                                    <View style={{
                                                                                        borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                                    }}>
                                                                                        <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                                    )
                                                                            }
                                                                            <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>日薪</Text>
                                                                        </TouchableOpacity>
                                                                        {/* 月薪 */}
                                                                        <TouchableOpacity activeOpacity={.7} onPress={() => this.yxFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                                            {
                                                                                !this.state.rxoryx ? (
                                                                                    <View style={{
                                                                                        borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                                                    }}>
                                                                                        <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                                                                    )
                                                                            }
                                                                            <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>月薪</Text>
                                                                        </TouchableOpacity>
                                                                    </View>
                                                                </View>
                                                            </View>
                                                        ) : false
                                                    }
                                                </View>
                                            )
                                    )
                                ) : false
                            )
                    }

                    {/* 点工or包工变化内容 */}
                    {
                        this.props.navigation.getParam('type') ? (
                            this.props.navigation.getParam('type') == '招突击队' ? (
                                <View style={{ paddingLeft: 11, paddingRight: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff', marginTop: 10 }}>
                                    {/* 所需人数 */}
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                    }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数</Text>
                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                                            <TextInput style={{
                                                paddingLeft: 10, width: 120, 
                                                color: 'red', textAlign: 'right', fontSize: 15.4
                                            }}
                                                placeholder='输入招工人数'
                                                placeholderTextColor='#cccccc'
                                                maxLength={4}
                                                keyboardType={'numeric'}
                                                onChangeText={this.peopleNumFun.bind(this)}
                                                value={this.state.peopleNum}

                                                multiline={true}
                                            // keyboardType = {'default'} 
                                            >
                                            </TextInput>
                                            <Text style={{ color: '#000', fontSize: 15.4, }}>人</Text>
                                        </View>
                                    </View>

                                    {/* 开工时间 */}
                                    <CustomButton
                                        presetText={this.state.presetText}
                                        onPress={this.showDateTimePicker} />


                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                                    }}>
                                        <DateTimePicker
                                            isVisible={this.state.isDateTimePickerVisible}
                                            onConfirm={this.handleDatePicked}
                                            onCancel={this.hideDateTimePicker}
                                            cancelTextIOS='取消'
                                            confirmTextIOS='确认'
                                            titleIOS='选择时间'
                                            minimumDate={new Date()}
                                        />
                                    </View>

                                    {/* 用工天数 */}
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                    }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>用工天数</Text>
                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                            <TextInput style={{
                                                paddingLeft: 10, width: 100, 
                                                color: 'red', textAlign: 'right', fontSize: 15.4
                                            }}
                                                placeholder='输入用工天数'
                                                placeholderTextColor='#cccccc'
                                                maxLength={2}
                                                onChangeText={this.work_dayFun.bind(this)}
                                                keyboardType={'numeric'}
                                                value={this.state.work_day}
                                            >
                                            </TextInput>
                                            <Text style={{ color: '#000', fontSize: 15.4, }}>天</Text>
                                        </View>
                                    </View>

                                    {/* 工作时长 */}
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                    }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工作时长</Text>
                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                            <TextInput style={{
                                                paddingLeft: 10, width: 100,  color: 'red', textAlign: 'right', fontSize: 15.4
                                            }}
                                                placeholder='输入工作时长'
                                                placeholderTextColor='#cccccc'
                                                maxLength={2}
                                                onChangeText={this.work_hourFun.bind(this)}
                                                keyboardType={'numeric'}
                                                value={this.state.work_hour}
                                            >
                                            </TextInput>
                                            <Text style={{ color: '#000', fontSize: 15.4, }}>小时/天</Text>
                                        </View>
                                    </View>

                                    {/* waning */}
                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right', marginTop: 5, marginBottom: -5 }}>较高的工价更容易招到想要的人哦~</Text>

                                    {/* 工钱 */}
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工钱</Text>
                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                            <TextInput style={{
                                                paddingLeft: 10, width: 200,  color: 'red', textAlign: 'right', fontSize: 15.4
                                            }}
                                                placeholder='不填表示联系时说明'
                                                placeholderTextColor='#cccccc'
                                                maxLength={6}
                                                onChangeText={this.moneyFun.bind(this)}
                                                value={this.state.money}
                                                keyboardType={'numeric'}
                                            >
                                            </TextInput>
                                            <Text style={{ color: '#000', fontSize: 15.4, }}>元/人/天</Text>
                                        </View>
                                    </View>



                                </View>
                            ) : (
                                GLOBAL.fbzgType.fbzgTypeName == '总包' || (this.props.navigation.getParam('item') && this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '总包') ? (
                                        // 包工内容
                                        <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>
                                            {/* waning */}
                                            <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易招到想要的人哦~</Text>

                                            {/* 单价 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>单价</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 100,  color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='输入单价'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={9}
                                                        onChangeText={this.unitMoneyFun.bind(this)}
                                                        keyboardType={'numeric'}
                                                        value={this.state.unitMoney}
                                                    >
                                                    </TextInput>
                                                    <TouchableOpacity activeOpacity={.7}
                                                        activeOpacity={1}
                                                        onPress={() => this.djSelectFun()}
                                                        style={{ flexDirection: "row", alignItems: 'center' }}
                                                    >
                                                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>
                                                            {this.state.dj}
                                                        </Text>
                                                        <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                    </TouchableOpacity>
                                                    {/* <ModalDropdown
                                                        textStyle={{ color: '#3d4145', fontSize: 15.4 }}
                                                        dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, }}
                                                        onSelect={(value, index) => this.djselectFun(index)}
                                                        defaultValue={this.state.dj} options={['元/平方米', '元/米', '元/立方米', '元/栋', '元/根', '元/点位']} >
                                                        <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                                            <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj}</Text>
                                                            <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                        </View>
                                                    </ModalDropdown> */}
                                                </View>
                                            </View>

                                            {/* 工程规模 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工程规模</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 120,
                                                        color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='输入工程规模'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={9}
                                                        onChangeText={this.total_scaleFun.bind(this)}
                                                        keyboardType={'numeric'}
                                                        value={this.state.total_scale}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj.replace('元/', '')}</Text>
                                                </View>
                                            </View>

                                            {/* 总价 */}
                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>总价</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 100, 
                                                        color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='输入总价'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={9}
                                                        onChangeText={this.moneyFun.bind(this)}
                                                        keyboardType={'numeric'}
                                                        value={this.state.money}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>元</Text>
                                                </View>
                                            </View>

                                        </View>

                                    ) : (

                                            this.state.dgorbg ? (
                                                // 点工内容
                                                <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>

                                                    {/* waning */}
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易招到想要的人哦~</Text>

                                                    {/* 工资标准 */}
                                                    <View style={{
                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                    }}>
                                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工资标准</Text>
                                                        <View style={{ flexDirection: "row", alignItems: 'center', justifyContent: 'flex-end', }}>
                                                            <TextInput style={{
                                                                paddingLeft: 10, 
                                                                color: 'red', width: 80, paddingRight: 0, textAlign: 'right', fontSize: 15.4
                                                            }}
                                                                placeholder='最低'
                                                                placeholderTextColor='#cccccc'
                                                                maxLength={6}
                                                                onChangeText={this.moneyFun.bind(this)}
                                                                keyboardType={'numeric'}
                                                                value={this.state.money}
                                                            >
                                                            </TextInput>
                                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15, marginLeft: 10 }}>至</Text>
                                                            <TextInput style={{
                                                                paddingLeft: 10,  color: 'red',
                                                                width: 80, paddingRight: 0, textAlign: 'right', fontSize: 15.4
                                                            }}
                                                                placeholder='最高'
                                                                placeholderTextColor='#cccccc'
                                                                maxLength={6}
                                                                onChangeText={this.max_moneyFun.bind(this)}
                                                                keyboardType={'numeric'}
                                                                value={this.state.max_money}
                                                            >
                                                            </TextInput>
                                                            <Text style={{ color: '#000', fontSize: 15.4, marginLeft: 10 }}>
                                                                元/{this.state.rxoryx ? '天' : '月'}
                                                            </Text>
                                                        </View>
                                                    </View>

                                                    {/* 所需人数 */}
                                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', flex: 1, height: 50 }}>
                                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数</Text>
                                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                                                            <TextInput style={{
                                                                paddingLeft: 10, width: 120, 
                                                                color: 'red', textAlign: 'right', fontSize: 15.4
                                                            }}
                                                                placeholder='输入招工人数'
                                                                placeholderTextColor='#cccccc'
                                                                maxLength={4}
                                                                keyboardType={'numeric'}
                                                                onChangeText={this.peopleNumFun.bind(this)}
                                                                value={this.state.peopleNum}
                                                            >
                                                            </TextInput>
                                                            <Text style={{ color: '#000', fontSize: 15.4, }}>人</Text>
                                                        </View>
                                                    </View>

                                                </View>
                                            ) : (
                                                    // 包工内容
                                                    <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>
                                                        {/* waning */}
                                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易招到想要的人哦~</Text>

                                                        {/* 单价 */}
                                                        <View style={{
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                            borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                        }}>
                                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>单价</Text>
                                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                                <TextInput style={{
                                                                    paddingLeft: 10, width: 100,  color: 'red', textAlign: 'right', fontSize: 15.4
                                                                }}
                                                                    placeholder='输入单价'
                                                                    placeholderTextColor='#cccccc'
                                                                    maxLength={9}
                                                                    onChangeText={this.unitMoneyFun.bind(this)}
                                                                    keyboardType={'numeric'}
                                                                    value={this.state.unitMoney}
                                                                >
                                                                </TextInput>
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    activeOpacity={1}
                                                                    onPress={() => this.djSelectFun()}
                                                                    style={{ flexDirection: "row", alignItems: 'center' }}
                                                                >
                                                                    <Text style={{ color: '#3d4145', fontSize: 15.4 }}>
                                                                        {this.state.dj}
                                                                    </Text>
                                                                    <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                                </TouchableOpacity>
                                                                {/* <ModalDropdown
                                                                    textStyle={{ color: '#3d4145', fontSize: 15.4, flexDirection: "row", alignItems: 'center' }}
                                                                    dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, }}
                                                                    onSelect={(value, index) => this.djselectFun(index)}
                                                                    defaultValue={this.state.dj} options={['元/平方米', '元/米', '元/立方米', '元/栋', '元/根', '元/点位']} >
                                                                    <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                                                        <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj}</Text>
                                                                        <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                                    </View>
                                                                </ModalDropdown> */}
                                                            </View>
                                                        </View>

                                                        {/* 工程规模 */}
                                                        <View style={{
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                            borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                        }}>
                                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工程规模</Text>
                                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                                <TextInput style={{
                                                                    paddingLeft: 10, width: 120, 
                                                                    color: 'red', textAlign: 'right', fontSize: 15.4
                                                                }}
                                                                    placeholder='输入工程规模'
                                                                    placeholderTextColor='#cccccc'
                                                                    maxLength={9}
                                                                    onChangeText={this.total_scaleFun.bind(this)}
                                                                    value={this.state.total_scale}
                                                                    keyboardType={'numeric'}
                                                                >
                                                                </TextInput>
                                                                <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj.replace('元/', '')}</Text>
                                                            </View>
                                                        </View>

                                                        {/* 总价 */}
                                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>总价</Text>
                                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                                <TextInput style={{
                                                                    paddingLeft: 10, width: 100, 
                                                                    color: 'red', textAlign: 'right', fontSize: 15.4
                                                                }}
                                                                    placeholder='输入总价'
                                                                    placeholderTextColor='#cccccc'
                                                                    maxLength={9}
                                                                    keyboardType={'numeric'}
                                                                    onChangeText={this.moneyFun.bind(this)}
                                                                    value={this.state.money}
                                                                >
                                                                </TextInput>
                                                                <Text style={{ color: '#000', fontSize: 15.4, }}>元</Text>
                                                            </View>
                                                        </View>

                                                    </View>
                                                )
                                        )
                                )
                        ) : (
                                this.props.navigation.getParam('item') ? (
                                    this.props.navigation.getParam('item').role_type != 1 && this.props.navigation.getParam('item').role_type != 2 ? (
                                        <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff', marginTop: 10 }}>
                                            {/* 所需人数 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 120, 
                                                        color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='输入招工人数'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={4}
                                                        keyboardType={'numeric'}
                                                        onChangeText={this.peopleNumFun.bind(this)}
                                                        value={this.state.peopleNum}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>人</Text>
                                                </View>
                                            </View>

                                            {/* 开工时间 */}
                                            {/* <CustomButton
                                                presetText={this.state.presetText}
                                                onPress={this.showPicker.bind(this, 'preset', { date: this.state.presetDate })} /> */}
                                            {/* 开工时间 */}
                                            <CustomButton
                                                presetText={this.state.presetText}
                                                onPress={this.showDateTimePicker} />


                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                            }}>
                                                <DateTimePicker
                                                    isVisible={this.state.isDateTimePickerVisible}
                                                    onConfirm={this.handleDatePicked}
                                                    onCancel={this.hideDateTimePicker}
                                                    cancelTextIOS='取消'
                                                    confirmTextIOS='确认'
                                                    titleIOS='选择时间'
                                                    minimumDate={new Date()}
                                                />
                                            </View>

                                            {/* 用工天数 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>用工天数</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 100, 
                                                        color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='输入用工天数'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={2}
                                                        onChangeText={this.work_dayFun.bind(this)}
                                                        keyboardType={'numeric'}
                                                        value={this.state.work_day}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>天</Text>
                                                </View>
                                            </View>

                                            {/* 工作时长 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工作时长</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 100,  color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='输入工作时长'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={2}
                                                        onChangeText={this.work_hourFun.bind(this)}
                                                        keyboardType={'numeric'}
                                                        value={this.state.work_hour}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>小时/天</Text>
                                                </View>
                                            </View>

                                            {/* waning */}
                                            <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right', marginTop: 5, marginBottom: -5 }}>较高的工价更容易招到想要的人哦~</Text>

                                            {/* 工钱 */}
                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工钱</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, width: 200,  color: 'red', textAlign: 'right', fontSize: 15.4
                                                    }}
                                                        placeholder='不填表示联系时说明'
                                                        placeholderTextColor='#cccccc'
                                                        maxLength={6}
                                                        onChangeText={this.moneyFun.bind(this)}
                                                        value={this.state.money}
                                                        keyboardType={'numeric'}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>元/人/天</Text>
                                                </View>
                                            </View>



                                        </View>
                                    ) : (
                                            this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '总包' ? (
                                                // 包工内容
                                                <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>
                                                    {/* waning */}
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易招到想要的人哦~</Text>

                                                    {/* 单价 */}
                                                    <View style={{
                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                    }}>
                                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>单价</Text>
                                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                            <TextInput style={{
                                                                paddingLeft: 10, width: 100,  color: 'red', textAlign: 'right', fontSize: 15.4
                                                            }}
                                                                placeholder='输入单价'
                                                                placeholderTextColor='#cccccc'
                                                                maxLength={9}
                                                                onChangeText={this.unitMoneyFun.bind(this)}
                                                                keyboardType={'numeric'}
                                                                value={this.state.unitMoney}
                                                            >
                                                            </TextInput>
                                                            <TouchableOpacity activeOpacity={.7}
                                                                activeOpacity={1}
                                                                onPress={() => this.djSelectFun()}
                                                                style={{ flexDirection: "row", alignItems: 'center' }}
                                                            >
                                                                <Text style={{ color: '#3d4145', fontSize: 15.4 }}>
                                                                    {this.state.dj}
                                                                </Text>
                                                                <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                            </TouchableOpacity>
                                                            {/* <ModalDropdown
                                                                textStyle={{ color: '#3d4145', fontSize: 15.4, flexDirection: "row", alignItems: 'center' }}
                                                                dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, }}
                                                                onSelect={(value, index) => this.djselectFun(index)}
                                                                defaultValue={this.state.dj} options={['元/平方米', '元/米', '元/立方米', '元/栋', '元/根', '元/点位']} >
                                                                <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj}</Text>
                                                                    <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                                </View>
                                                            </ModalDropdown> */}
                                                        </View>
                                                    </View>

                                                    {/* 工程规模 */}
                                                    <View style={{
                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                        borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                    }}>
                                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工程规模</Text>
                                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                            <TextInput style={{
                                                                paddingLeft: 10, width: 120, 
                                                                color: 'red', textAlign: 'right', fontSize: 15.4
                                                            }}
                                                                placeholder='输入工程规模'
                                                                placeholderTextColor='#cccccc'
                                                                maxLength={9}
                                                                onChangeText={this.total_scaleFun.bind(this)}
                                                                keyboardType={'numeric'}
                                                                value={this.state.total_scale}
                                                            >
                                                            </TextInput>
                                                            <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj.replace('元/', '')}</Text>
                                                        </View>
                                                    </View>

                                                    {/* 总价 */}
                                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>总价</Text>
                                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                            <TextInput style={{
                                                                paddingLeft: 10, width: 100, 
                                                                color: 'red', textAlign: 'right', fontSize: 15.4
                                                            }}
                                                                placeholder='输入总价'
                                                                placeholderTextColor='#cccccc'
                                                                maxLength={9}
                                                                onChangeText={this.moneyFun.bind(this)}
                                                                keyboardType={'numeric'}
                                                                value={this.state.money}
                                                            >
                                                            </TextInput>
                                                            <Text style={{ color: '#000', fontSize: 15.4, }}>元</Text>
                                                        </View>
                                                    </View>

                                                </View>

                                            ) : (

                                                    this.state.dgorbg ? (
                                                        // 点工内容
                                                        <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>

                                                            {/* waning */}
                                                            <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易招到想要的人哦~</Text>

                                                            {/* 工资标准 */}
                                                            <View style={{
                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                            }}>
                                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工资标准</Text>
                                                                <View style={{ flexDirection: "row", alignItems: 'center', justifyContent: 'flex-end' }}>
                                                                    <TextInput style={{
                                                                        paddingLeft: 10,  color: 'red',
                                                                        width: 80, paddingRight: 0, textAlign: 'right', fontSize: 15.4
                                                                    }}
                                                                        placeholder='最低'
                                                                        placeholderTextColor='#cccccc'
                                                                        maxLength={6}
                                                                        onChangeText={this.moneyFun.bind(this)}
                                                                        keyboardType={'numeric'}
                                                                        value={this.state.money}
                                                                    >
                                                                    </TextInput>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15, marginLeft: 10 }}>至</Text>
                                                                    <TextInput style={{
                                                                        paddingLeft: 10,  color: 'red',
                                                                        width: 80, paddingRight: 0, textAlign: 'right', fontSize: 15.4
                                                                    }}
                                                                        placeholder='最高'
                                                                        placeholderTextColor='#cccccc'
                                                                        maxLength={6}
                                                                        onChangeText={this.max_moneyFun.bind(this)}
                                                                        keyboardType={'numeric'}
                                                                        value={this.state.max_money}
                                                                    >
                                                                    </TextInput>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, marginLeft: 10 }}>
                                                                        元/{this.state.rxoryx ? '天' : '月'}
                                                                    </Text>
                                                                </View>
                                                            </View>

                                                            {/* 所需人数 */}
                                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数</Text>
                                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end', flex: 1 }}>
                                                                    <TextInput style={{
                                                                        paddingLeft: 10, width: 120, 
                                                                        color: 'red', textAlign: 'right', fontSize: 15.4
                                                                    }}
                                                                        placeholder='输入招工人数'
                                                                        placeholderTextColor='#cccccc'
                                                                        maxLength={4}
                                                                        keyboardType={'numeric'}
                                                                        onChangeText={this.peopleNumFun.bind(this)}
                                                                        value={this.state.peopleNum}
                                                                    >
                                                                    </TextInput>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>人</Text>
                                                                </View>
                                                            </View>

                                                        </View>
                                                    ) : (
                                                            // 包工内容
                                                            <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>
                                                                {/* waning */}
                                                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易招到想要的人哦~</Text>

                                                                {/* 单价 */}
                                                                <View style={{
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                                }}>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>单价</Text>
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                                        <TextInput style={{
                                                                            paddingLeft: 10, width: 100, color: 'red', textAlign: 'right', fontSize: 15.4
                                                                        }}
                                                                            placeholder='输入单价'
                                                                            placeholderTextColor='#cccccc'
                                                                            maxLength={9}
                                                                            onChangeText={this.unitMoneyFun.bind(this)}
                                                                            keyboardType={'numeric'}
                                                                            value={this.state.unitMoney}
                                                                        >
                                                                        </TextInput>
                                                                        <TouchableOpacity activeOpacity={.7}
                                                                            activeOpacity={1}
                                                                            onPress={() => this.djSelectFun()}
                                                                            style={{ flexDirection: "row", alignItems: 'center' }}
                                                                        >
                                                                            <Text style={{ color: '#3d4145', fontSize: 15.4 }}>
                                                                                {this.state.dj}
                                                                            </Text>
                                                                            <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                                        </TouchableOpacity>
                                                                        {/* <ModalDropdown
                                                                            textStyle={{ color: '#3d4145', fontSize: 15.4, flexDirection: "row", alignItems: 'center' }}
                                                                            dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, }}
                                                                            onSelect={(value, index) => this.djselectFun(index)}
                                                                            defaultValue={this.state.dj} options={['元/平方米', '元/米', '元/立方米', '元/栋', '元/根', '元/点位']} >
                                                                            <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                                                                <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj}</Text>
                                                                                <Icon style={{ marginLeft: 5, transform: [{ rotateX: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                                                                            </View>
                                                                        </ModalDropdown> */}
                                                                    </View>
                                                                </View>

                                                                {/* 工程规模 */}
                                                                <View style={{
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                                                                }}>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工程规模</Text>
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                                        <TextInput style={{
                                                                            paddingLeft: 10, width: 120, 
                                                                            color: 'red', textAlign: 'right', fontSize: 15.4
                                                                        }}
                                                                            placeholder='输入工程规模'
                                                                            placeholderTextColor='#cccccc'
                                                                            maxLength={9}
                                                                            onChangeText={this.total_scaleFun.bind(this)}
                                                                            value={this.state.total_scale}
                                                                            keyboardType={'numeric'}
                                                                        >
                                                                        </TextInput>
                                                                        <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj.replace('元/', '')}</Text>
                                                                    </View>
                                                                </View>

                                                                {/* 总价 */}
                                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50 }}>
                                                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>总价</Text>
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                                        <TextInput style={{
                                                                            paddingLeft: 10, width: 100, 
                                                                            color: 'red', textAlign: 'right', fontSize: 15.4
                                                                        }}
                                                                            placeholder='输入总价'
                                                                            placeholderTextColor='#cccccc'
                                                                            maxLength={9}
                                                                            keyboardType={'numeric'}
                                                                            onChangeText={this.moneyFun.bind(this)}
                                                                            value={this.state.money}
                                                                        >
                                                                        </TextInput>
                                                                        <Text style={{ color: '#000', fontSize: 15.4, }}>元</Text>
                                                                    </View>
                                                                </View>

                                                            </View>
                                                        )
                                                )
                                        )
                                ) : false
                            )
                    }

                    {/* 选择待遇 */}
                    <View style={{ paddingLeft: 13, paddingRight: 13, paddingTop: 15, paddingBottom: 15, marginBottom: 11, backgroundColor: '#fff' }}>
                        <View style={{ flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>选择待遇</Text>
                            <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 3 }}>(点击标签即可选中)</Text>
                        </View>
                        {/* 待遇选项 */}
                        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                            {
                                this.state.welfareArr.map((v, index) => {
                                    return (
                                        <TouchableOpacity activeOpacity={.7}
                                            onPress={() => this.selectWelFun(v)}
                                            key={index}
                                            style={{
                                                paddingLeft: 6.6, paddingRight: 6.6,
                                                paddingTop: 3.3, paddingBottom: 3.3, marginTop: 6.6,
                                                marginRight: 5.5,
                                                backgroundColor: this.state.selectWelfare.indexOf(v) > -1 ? '#eb4e4e' : '#e6e6e6',
                                                borderRadius: 3.3,
                                                flexDirection: 'row'
                                            }}>
                                            <Text style={{ color: this.state.selectWelfare.indexOf(v) > -1 ? '#fff' : '#3d4145', fontSize: 13.2 }}>{v}</Text>
                                            {
                                                this.state.selectWelfare.indexOf(v) > -1 ? (
                                                    <Icon style={{ marginLeft: 5 }} name="success" size={16} color="#fff" />
                                                ) : false
                                            }
                                        </TouchableOpacity>
                                    )
                                })
                            }
                        </View>
                        {/* 添加待遇 */}
                        <View style={{ flexDirection: "row", alignItems: 'center', justifyContent: 'space-between', marginTop: 15, height: 50 }}>
                            <TextInput style={{
                                borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                marginTop: 5, color: '#000000', flex: 1, marginRight: 10, fontSize: 15.4
                            }}
                                placeholder='输入你能提供的待遇(最多8个字)'
                                placeholderTextColor='#cccccc'
                                maxLength={8}
                                onChangeText={this.addWelfare.bind(this)}
                                value={this.state.addWelfareInput}
                            >
                            </TextInput>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => this.addWelfareFun()}
                                style={{
                                    backgroundColor: '#eb4e4e', width: 88, height: 38, flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'center', borderRadius: 3, marginTop: 2
                                }}>
                                <Text style={{ color: '#fff', fontSize: 15.4 }}>添加</Text>
                            </TouchableOpacity>
                        </View>
                    </View>

                    {/* 项目名称、施工单位 */}
                    <View style={{ paddingLeft: 11, paddingRight: 11, backgroundColor: '#fff' }}>
                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb', height: 50
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>项目名称：</Text>
                            <TextInput style={{
                                paddingLeft: 10,
                                flex: 1,
                                
                                color: '#000000',
                                textAlign: 'right',
                                fontSize: 15.4,
                            }}
                                placeholder='输入招工项目的名称(最多15个字)'
                                placeholderTextColor='#cccccc'
                                maxLength={15}
                                value={this.state.pro_work_name}
                                onChangeText={this.pro_work_nameFun.bind(this)}

                                multiline={true}
                                keyboardType={'default'}
                            >
                            </TextInput>
                        </View>
                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            // borderBottomWidth: 1,
                             borderBottomColor: '#ebebeb', height: 50
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>施工单位：</Text>
                            <TextInput style={{
                                paddingLeft: 10,
                                flex: 1,
                                
                                color: '#000000',
                                textAlign: 'right',
                                fontSize: 15.4
                            }}
                                placeholder='输入施工单位的名称(最多15个字)'
                                placeholderTextColor='#cccccc'
                                maxLength={15}
                                value={this.state.company_name}
                                onChangeText={this.company_nameFun.bind(this)}

                                multiline={true}
                                keyboardType={'default'}

                            >
                            </TextInput>
                        </View>
                    </View>

                    {/* 项目所在地 */}
                    <Text style={{ marginLeft: 13.2, marginRight: 13.2, marginTop: 8.8, marginBottom: 8.8, color: '#3d4145', fontSize: 15.4 }}>
                        项目所在地：{this.props.navigation.getParam('fbzgAddressOneName')} {this.props.navigation.getParam('fbzgAddressTwoName')}
                    </Text>

                    {/* 详细地址 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.addressFun()}
                        style={{
                            paddingLeft: 11, paddingRight: 11, backgroundColor: '#fff', flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'space-between', marginBottom: 10, height: 50
                        }}>
                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>详细地址：</Text>
                        <View style={{ flexDirection: "row", alignItems: 'center' }}>
                            {
                                GLOBAL.fbzgAddress.detailAddress == '请选择所在地' ? (
                                    <Text style={{ color: '#cccccc', fontSize: 15.4 }}>{GLOBAL.fbzgAddress.detailAddress}</Text>
                                ) : (
                                        <Text style={{ color: '#000000', fontSize: 15.4 }}>{GLOBAL.fbzgAddress.detailAddress}</Text>
                                    )
                            }
                            <Icon style={{ marginLeft: 10 }} name="r-arrow" size={12} color="#000" />
                        </View>
                    </TouchableOpacity>

                    {/* 项目描述 */}
                    <View style={{ backgroundColor: '#fff', paddingLeft: 13, paddingRight: 13, paddingTop: 15.4, paddingBottom: 15.4 }}>
                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>项目描述</Text>
                        <TextInput multiline={true}
                            placeholder='填写具体的项目介绍，例如项目所需时长、工资发放方式等，能让找活方更多地了解工作详情。'
                            placeholderTextColor='#cccccc'
                            style={{
                                height: 88, padding: 5, margin: 0, fontSize: 15, marginTop: 10, marginLeft: -5, fontSize: 15.4
                            }}
                            textAlignVertical='top'
                            value={this.state.describe}
                            onChangeText={this.describeFun.bind(this)}
                        ></TextInput>
                    </View>

                    <Text style={{ color: '#999', fontSize: 15.4, marginTop: 11, marginBottom: 50, textAlign: 'center' }}>你的招工信息会在平台展示50天</Text>

                </ScrollView>

                {/* 加载弹框组件 */}
                <Loading
                    closeAlertFun={this.closeAlertFun.bind(this)}
                    openAlertFun={this.openAlertFun.bind(this)}
                    openAlert={this.state.openAlert}
                    icon='warning'
                    font={this.state.warning} />

                {/* 底部按钮 */}
                <View style={{ padding: 11, backgroundColor: '#fafafa', position: 'absolute', bottom: 0, width: '100%', borderTopWidth: .5, borderTopColor: '#cccccc' }}>
                    {
                        this.props.navigation.getParam('item') ? (
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => this.btn()}
                                style={{ borderRadius: 4.4, backgroundColor: '#eb4e4e', height: 44, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                <Text style={{ fontSize: 18.7, color: '#fff' }}>保存</Text>
                            </TouchableOpacity>
                        ) : (
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.btn()}
                                    style={{ borderRadius: 4.4, backgroundColor: '#eb4e4e', height: 44, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                    <Text style={{ fontSize: 18.7, color: '#fff' }}>立即发布</Text>
                                </TouchableOpacity>
                            )
                    }
                </View>

                {/* 弹框 */}
                <AlertUser  ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />

                {/* 单价选择组件 */}
                <Rolealert
                    name='dj'
                    valueDefau={this.state.dj}
                    orbottomalert={this.state.orbottomalert}
                    closeModal={this.closeModal.bind(this)}
                    selectFun={this.selectFun.bind(this)}
                />

            </View>
        )
    }
    // 单价选择，打开弹框
    djSelectFun() {
        this.setState({
            orbottomalert: !this.state.orbottomalert
        })
    }
    // 单价选择组件弹框关闭事件
    closeModal() {
        this.setState({
            orbottomalert: !this.state.orbottomalert
        })
    }
    // 确定
    selectFun(e) {
        this.setState({
            orbottomalert: !this.state.orbottomalert,
            dj: e.name,
            projectUnit: e.key
        })
    }
    // 加载弹框控制
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    // 计时自动关闭加载框
    closeAlertFun(){
        this.setState({
            openAlert: false
        })
    }
    //选择点工
    dgFun() {
        this.setState({
            dgorbg: true,
            peopleNum: '',
        })
    }
    //选择包工
    bgFun() {
        this.setState({
            dgorbg: false,
            peopleNum: '0',
            dj: '元/平方米',
        })
    }
    // 选择日薪
    rxFun() {
        this.setState({
            rxoryx: true,
            payType: 'd'
        })
    }
    // 选择月薪
    yxFun() {
        this.setState({
            rxoryx: false,
            payType: 'm'
        })
    }
    // 选择单价单位
    djselectFun(e) {
        this.setState({
            dj: e
        })
    }
    // 所需人数
    peopleNumFun(e) {
        this.setState({
            peopleNum: e.replace(/[^\d]/g, '')
        })
    }
    // 选择项目具体地址
    addressFun() {
        this.props.navigation.navigate('Myrecruit_address', {
            callback: (() => {
                this.setState({})
            }),
            fbzgAddressTwoName: this.props.navigation.getParam('type') ? this.props.navigation.getParam('fbzgAddressTwoName') : (
                this.props.navigation.getParam('item') ? this.props.navigation.getParam('item').city_name : false
            )
        })
    }
    // 项目描述
    describeFun(e) {
        this.setState({
            describe: e
        })
    }
    moneyFun(e) {
        this.setState({
            money: this.downTwo(e)
        })
    }
    max_moneyFun(e) {
        this.setState({
            max_money: this.downTwo(e)
        })
    }
    // 工程规模
    total_scaleFun(e) {
        this.setState({
            total_scale: this.downTwo(e)
        })
    }
    // 选择待遇
    selectWelFun(e) {
        if (this.state.selectWelfare.indexOf(e) > -1) {
            let arr = this.state.selectWelfare
            var index = arr.indexOf(e);
            arr.splice(index, 1);
            this.setState({
                selectWelfare: arr
            })
        } else {
            let arr = this.state.selectWelfare
            arr.push(e)
            this.setState({
                selectWelfare: arr
            })
        }
    }
    addWelfare(e) {
        this.setState({
            addWelfareInput: e
        })
    }
    // 添加待遇
    addWelfareFun() {
        if (this.state.addWelfareInput.replace(/(^\s*)|(\s*$)/g, "") !== '') {
            let arrAll = this.state.welfareArr
            arrAll.push(this.state.addWelfareInput.replace(/(^\s*)|(\s*$)/g, ""))
            let arr = this.state.selectWelfare
            arr.push(this.state.addWelfareInput.replace(/(^\s*)|(\s*$)/g, ""))
            this.setState({
                welfareArr: arrAll,
                addWelfareInput: arr,
                addWelfareInput: ''
            })
        }
    }
    // 包工-单价
    unitMoneyFun(e) {
        this.setState({
            unitMoney: this.downTwo(e)
        })
    }
    // 两位小数正则
    downTwo(e) {
        let newText = (e != '' && e.substr(0, 1) == '.') ? '' : e;
        newText = newText.replace(/^0+[0-9]+/g, "0"); //不能以0开头输入
        newText = newText.replace(/[^\d.]/g, ""); //清除"数字"和"."以外的字符
        newText = newText.replace(/\.{2,}/g, "."); //只保留第一个, 清除多余的
        newText = newText.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
        // newText = newText.replace(/^(\-)*(\d+)\.(\d\d).*$/, '$1$2.$3'); //只能输入两个小数
        return (newText)
    }
    // 项目名称
    pro_work_nameFun(e) {
        this.setState({
            pro_work_name: e
        })
    }
    // 施工单位名称
    company_nameFun(e) {
        this.setState({
            company_name: e
        })
    }
    // 突击队用工天数
    work_dayFun(e) {
        this.setState({
            work_day: e.replace(/[^\d]+/, '')
        })
    }
    // 突击队工作时长
    work_hourFun(e) {
        this.setState({
            work_hour: e.replace(/[^\d]+/, '')
        })
    }
    alertFunr() {
        this.setState({
            ifOpenAlert: false
        })
    }
    // 立即发布按钮
    btn() {
        if (!this.props.navigation.getParam('edit')) {//发布招工
            console.log('发布')
            let btn = true
            if (this.state.peopleNum == '') {
                btn = false
                this.setState({
                    warning: '请输入所需人数',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            // openAlert: false
                        })
                    }, 2000)
                })
            } else if (GLOBAL.fbzgAddress.detailAddress == '请选择所在地') {
                btn = false
                this.setState({
                    warning: '请填写详细地址',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            // openAlert: false
                        })
                    }, 2000)
                })
            } else if (this.state.describe == '') {
                btn = false
                this.setState({
                    warning: '请填写项目描述',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            // openAlert: false
                        })
                    }, 2000)
                })
            }
            if (btn == true) {
                fetchFun.load({
                    url: 'jlforemanwork/pubproject',

                    data: {
                        kind: 'recruit',
                        pid: this.state.pid,//项目id，修改项目的时候传
                        role_type: this.props.navigation.getParam('type') == '招工人' ? '1' : this.props.navigation.getParam('type') == '招班组' ? '2' : '3',//	招工角色
                        pro_address: GLOBAL.fbzgAddress.detailAddress,//详细地址
                        county_no: GLOBAL.fbzgAddress.fbzgAddressTwoNum,//城市区县代码一定是县区级的城市编码 app端传
                        cooperate_type: this.props.navigation.getParam('type') == '招突击队' ? '4' : (this.props.navigation.getParam('fbzgTypeName') == '总包' ? '3' : this.state.dgorbg ? '1' : '2'),//1点工，2包工，3总包 ,4突击队
                        person_count: this.state.peopleNum,//找工人数
                        // balance_way: (this.props.navigation.getParam('type') == '招突击队' ? '4' : this.state.dgorbg ? '1' : '2') == '1' ? this.state.payType : this.state.projectUnit,//找工单位
                        balance_way: this.props.navigation.getParam('type') == '招突击队' ? '3' : (this.props.navigation.getParam('fbzgTypeName') == '总包' ? this.state.projectUnit : (this.state.dgorbg ? this.state.payType : this.state.projectUnit)),
                        money: this.state.money,//点工代表单价、包工和总包代表总价
                        max_money: this.state.max_money,
                        work_type: GLOBAL.fbzgType.fbzgTypeNum,//所需工种
                        work_name: this.props.navigation.getParam('fbzgTypeNameOther'),//当工种为其它时的工种名称
                        pro_type: GLOBAL.fbzgProject.fbzgProjectNum,//工程类别
                        pro_name: this.props.navigation.getParam('fbzgProjectNameOther'),//当工程类别为其它时的名称
                        total_scale: this.state.total_scale,//总规模
                        pro_description: this.state.describe,//项目描述
                        pro_location: `${GLOBAL.detailLngnLat.lng}` + ',' + `${GLOBAL.detailLngnLat.lat}`,//经纬度
                        welfare: this.state.selectWelfare.join(','),//福利
                        unitMoney: this.state.unitMoney,//单价，包工有效
                        pro_work_name: this.state.pro_work_name,//项目名称
                        company_name: this.state.company_name,//施工单位名称
                        work_begin: this.state.presetText ? this.state.presetText.split('/').join('-') : '',//突击队开工时间
                        work_day: this.state.work_day,//突击队工天
                        work_hour: this.state.work_hour,//突击队每日工时
                    },
                    success: (res) => {
                        console.log('---发布招工---', res)
                        GLOBAL.pid = res.pid
                        if (this.props.navigation.getParam('type') == '招突击队') {
                            GLOBAL.fbzgType.fbzgTypeNum = ''
                            GLOBAL.fbzgProject.fbzgProjectNum = ''
                        }
                        GLOBAL.payType = this.state.payType
                        GLOBAL.dj = this.state.dj

                        // 清空发布招工选项页数据
                        GLOBAL.fbzgType.fbzgTypeName = '选择工种'
                        GLOBAL.fbzgProject.fbzgProjectName = '选择工程类别'
                        // GLOBAL.fbzgAddress.detailAddress = '请选择所在地'
                        this.setState({})

                        if (this.props.navigation.getParam('type') != '招突击队') {
                            // 弹窗
                            if (GLOBAL.userinfo.verified != 3) {
                                this.setState({
                                    ifOpenAlert: !this.state.ifOpenAlert,
                                })
                            }
                            this.props.navigation.navigate('Myrecruit_suit', { type: this.props.navigation.getParam('type') == '招工人' ? 1 : 2 })
                        } else {
                            // console.log(GLOBAL.userinfo.verified)
                            if (GLOBAL.userinfo.verified != 3) {
                                DeviceEventEmitter.emit("EventTypeAlert", param)
                            }
                            this.props.navigation.navigate('Recruit_homepage')
                        }
                    }
                });
            }
        } else {//修改招工信息
            console.log('修改')
            let btn = true,
                item = this.props.navigation.getParam('item')
            // #20785
            if (this.state.peopleNum == '' && item.classes[0].cooperate_type.type_name == '点工') {
                btn = false
                this.setState({
                    warning: '请输入所需人数',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            // openAlert: false
                        })
                    }, 2000)
                })
            } else if (this.state.describe == '') {
                btn = false
                this.setState({
                    warning: '请填写项目描述',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            // openAlert: false
                        })
                    }, 2000)
                })
            }
            if (btn == true) {
                fetchFun.load({
                    url: 'jlforemanwork/pubproject',
                    data: {
                        kind: 'recruit',
                        pid: this.props.navigation.getParam('item').pid,//项目id，修改项目的时候传
                        role_type: this.props.navigation.getParam('item').role_type,//	招工角色
                        pro_address: GLOBAL.fbzgAddress.detailAddress,//详细地址
                        county_no: this.props.navigation.getParam('item').city_no,//城市区县代码一定是县区级的城市编码 app端传
                        cooperate_type: this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '突击队' ? '4' : this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '总包' ? '3' : this.state.dgorbg ? '1' : '2',//1点工，2包工，3总包 ,4突击队
                        person_count: this.state.peopleNum,//找工人数
                        // balance_way: (this.props.navigation.getParam('item').role_type == 3 ? '4' : this.state.dgorbg ? '1' : '2') == '1' ? this.state.payType : this.state.projectUnit,//找工单位
                        balance_way: this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '突击队' ? '3' : (this.props.navigation.getParam('item').classes[0].cooperate_type.type_name == '总包' ? this.state.projectUnit : (this.state.dgorbg ? this.state.payType : this.state.projectUnit)),
                        money: this.state.money,//点工代表单价、包工和总包代表总价
                        max_money: this.state.max_money,
                        work_type: this.props.navigation.getParam('item').classes[0].work_type.type_id,//所需工种
                        work_name: this.props.navigation.getParam('item').classes[0].work_type.type_name,//当工种为其它时的工种名称
                        pro_type: this.props.navigation.getParam('item').classes[0].pro_type.type_id,//工程类别
                        pro_name: this.props.navigation.getParam('item').classes[0].pro_type.type_name,//当工程类别为其它时的名称
                        total_scale: this.state.total_scale,//总规模
                        pro_description: this.state.describe,//项目描述
                        pro_location: this.props.navigation.getParam('item').pro_location.join(','),//经纬度
                        // welfare: this.props.navigation.getParam('item').welfare.join(','),//福利
                        welfare: this.state.selectWelfare.join(','),//福利
                        unitMoney: this.state.unitMoney,//单价，包工有效
                        pro_work_name: this.state.pro_work_name,//项目名称
                        company_name: this.state.company_name,//施工单位名称
                        work_begin: this.state.presetText ? this.state.presetText.split('/').join('-') : '',//突击队开工时间
                        work_day: this.state.work_day,//突击队工天
                        work_hour: this.state.work_hour,//突击队每日工时
                    },
                    success: (res) => {
                        console.log('---修改招工---', res)
                        // this.props.navigation.navigate('Myhistory')
                        // DeviceEventEmitter.emit("hiringrecordaList")

                        GLOBAL.pid = this.props.navigation.getParam('item').pid

                        GLOBAL.payType = this.state.payType
                        GLOBAL.dj = this.state.dj

                        // 清空发布招工选项页数据
                        GLOBAL.fbzgType.fbzgTypeName = '选择工种'
                        GLOBAL.fbzgProject.fbzgProjectName = '选择工程类别'
                        // GLOBAL.fbzgAddress.detailAddress = '请选择所在地'
                        this.setState({})

                        if (this.props.navigation.getParam('item').role_type != 3) {
                            // 弹窗
                            // this.setState({
                            //     ifOpenAlert: !this.state.ifOpenAlert,
                            // })
                            this.props.navigation.navigate('Myrecruit_suit', { type: this.props.navigation.getParam('item').role_type })
                        } else {
                            // DeviceEventEmitter.emit("EventTypeAlert", param)
							this.props.navigation.navigate('Myhistory')
							// #20901
                            if (this.props.navigation.state.params.callback) {
                                this.props.navigation.state.params.callback()
                            }
                        }
                    }
                });
            }
        }
    }
}

//封装一个日期组件
class CustomButton extends React.Component {
    render() {
        return (
            <TouchableOpacity activeOpacity={.7}
                onPress={this.props.onPress}
                style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 50

                }}>
                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>开工时间</Text>
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                    {
                        this.props.presetText == '' ? (
                            <Text style={{ fontSize: 15.4, color: '#cccccc', marginRight: 7 }}>选择开工时间</Text>
                        ) : (
                                <Text style={{ fontSize: 15.4, color: '#eb4e4e', marginRight: 7 }}>{this.props.presetText}</Text>
                            )
                    }
                    <Icon name="d-arrow" size={15} color="rgb(168,168,168)" />
                </View>
            </TouchableOpacity>

        );
    }
}


