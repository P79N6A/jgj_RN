/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 18:20:32 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-11 14:11:25
 * Module:招聘信息详情填写
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    TouchableOpacity,
    TextInput,
    ScrollView,
    DatePickerAndroid,
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import Icon from "react-native-vector-icons/Ionicons";
import Loading from '../../component/loading'
import fetchFun from '../../fetch/fetch'

export default class releasedetail extends Component {
    constructor(props) {
        super(props)
        this.state = {
            dgorbg: true,//点工、包工
            rxoryx: true,//计薪方式（日薪）
            dj: '元/米',//单价单位

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
            welfareArr: ['包吃住', '不包吃住', '包吃不包住', '包住不包吃', '按时发钱', '买保险'],//福利待遇
            selectWelfare: [],//选择的福利待遇
            addWelfareInput:'',
            unitMoney:'',//包工的单价
            pro_work_name:'',//项目名称
            company_name:'',//施工单位名称
            work_day:'',//突击队用工天数
            work_hour:'',//突击队工作时长
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
            this.setState({
                presetText: date.toLocaleDateString()
            });
            this.refreshFun()//手动刷新
        } catch ({ code, message }) {
            console.warn(`Error in example '${stateKey}': `, message);
        }
    }
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>
                            {this.props.navigation.getParam('type')}({this.props.navigation.getParam('fbzgTypeName')=='其它工种'?this.props.navigation.getParam('fbzgTypeNameOther'):this.props.navigation.getParam('fbzgTypeName')})
                        </Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                <ScrollView style={{ marginBottom: 50 }}>
                    {
                        this.props.navigation.getParam('type') == '招突击队' ? false : (
                            <View>
                                {/* 用工类型 */}
                                <View style={{
                                    paddingLeft: 13, paddingRight: 13, marginTop: 11, marginBottom: 11, backgroundColor: '#fff', paddingTop: 17, paddingBottom: 17,
                                    flexDirection: 'row'
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>用工类型</Text>
                                    <View style={{ flexDirection: 'row' }}>
                                        {/* 点工 */}
                                        <TouchableOpacity onPress={() => this.dgFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
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
                                        <TouchableOpacity onPress={() => this.bgFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
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
                                            flexDirection: 'row',
                                        }}>
                                            <View style={{ borderBottomWidth: 1, borderBottomColor: '#ebebeb', flex: 1, flexDirection: 'row', paddingTop: 17, paddingBottom: 17, }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>计薪方式</Text>
                                                <View style={{ flexDirection: 'row' }}>
                                                    {/* 日薪 */}
                                                    <TouchableOpacity onPress={() => this.rxFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
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
                                                    <TouchableOpacity onPress={() => this.yxFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
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
                    }

                    {/* 点工or包工变化内容 */}
                    {
                        this.props.navigation.getParam('type') == '招突击队' ? (
                            <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>
                                {/* 所需人数 */}
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                        <TextInput style={{
                                            paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                        }}
                                            placeholder='输入招工人数'
                                            onChangeText={this.peopleNumFun.bind(this)}
                                        >
                                        </TextInput>
                                        <Text style={{ color: '#000', fontSize: 15.4, }}>人</Text>
                                    </View>
                                </View>

                                {/* 开工时间 */}
                                <CustomButton
                                    presetText={this.state.presetText}
                                    onPress={this.showPicker.bind(this, 'preset', { date: this.state.presetDate })} />

                                {/* 用工天数 */}
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>用工天数</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                        <TextInput style={{
                                            paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                        }}
                                            placeholder='输入用工天数'
                                            onChangeText={this.work_dayFun.bind(this)}
                                        >
                                        </TextInput>
                                        <Text style={{ color: '#000', fontSize: 15.4, }}>天</Text>
                                    </View>
                                </View>

                                {/* 工作时长 */}
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工作时长</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                        <TextInput style={{
                                            paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                        }}
                                            placeholder='输入工作时长'
                                            onChangeText={this.work_hourFun.bind(this)}
                                        >
                                        </TextInput>
                                        <Text style={{ color: '#000', fontSize: 15.4, }}>小时/天</Text>
                                    </View>
                                </View>

                                {/* waning */}
                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right', marginTop: 5, marginBottom: -5 }}>较高的工价更容易找到想要的人哦~</Text>

                                {/* 工钱 */}
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工钱</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                        <TextInput style={{
                                            paddingLeft: 10, height: 38, width: 200, marginTop: 5, color: 'red', textAlign: 'right'
                                        }}
                                            placeholder='不填标识联系时说明'
                                            onChangeText={this.moneyFun.bind(this)}
                                        >
                                        </TextInput>
                                        <Text style={{ color: '#000', fontSize: 15.4, }}>元/人/天</Text>
                                    </View>
                                </View>



                            </View>
                        ) : (
                                this.state.dgorbg ? (
                                    // 点工内容
                                    <View style={{ padding: 11, paddingBottom: 0, marginBottom: 11, backgroundColor: '#fff' }}>

                                        {/* waning */}
                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易找到想要的人哦~</Text>

                                        {/* 工资标准 */}
                                        <View style={{
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                            borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                        }}>
                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工资标准</Text>
                                            <View style={{ flexDirection: "row", alignItems: 'center', justifyContent: 'center' }}>
                                                <TextInput style={{
                                                    paddingLeft: 10, height: 38, marginTop: 5, color: 'red', width: 50, paddingRight: 0, textAlign: 'right'
                                                }}
                                                    placeholder='最低'
                                                    onChangeText={this.moneyFun.bind(this)}
                                                >
                                                </TextInput>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15, marginLeft: 10 }}>至</Text>
                                                <TextInput style={{
                                                    paddingLeft: 10, height: 38, marginTop: 5, color: 'red', width: 50, paddingRight: 0, textAlign: 'right'
                                                }}
                                                    placeholder='最高'
                                                    onChangeText={this.max_moneyFun.bind(this)}
                                                >
                                                </TextInput>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15, marginLeft: 10 }}>
                                                    元/{this.state.rxoryx ? '天' : '月'}
                                                </Text>
                                            </View>
                                        </View>

                                        {/* 所需人数 */}
                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数</Text>
                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                <TextInput style={{
                                                    paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                                }}
                                                    placeholder='输入招工人数'
                                                    onChangeText={this.peopleNumFun.bind(this)}
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
                                            <Text style={{ color: '#eb4e4e', fontSize: 13.2, textAlign: 'right' }}>较高的工价更容易找到想要的人哦~</Text>

                                            {/* 单价 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>单价</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                                    }}
                                                        placeholder='输入单价'
                                                        onChangeText={this.unitMoneyFun.bind(this)}
                                                        >
                                                    </TextInput>
                                                    <ModalDropdown
                                                        textStyle={{ color: '#3d4145', fontSize: 15.4 }}
                                                        dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, }}
                                                        onSelect={(value, index) => this.djselectFun(index)}
                                                        defaultValue={this.state.dj} options={['元/米', '元/吨', '元/平方米', '元/立方米', '元/栋楼']} >
                                                    </ModalDropdown>
                                                    <Icon style={{ marginLeft: 10 }} name="rd-arrow" size={13} color="#999999" />
                                                </View>
                                            </View>

                                            {/* 工程规模 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                            }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工程规模</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                                    }}
                                                        placeholder='输入工程规模'
                                                        onChangeText={this.total_scaleFun.bind(this)}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>{this.state.dj}</Text>
                                                </View>
                                            </View>

                                            {/* 总价 */}
                                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', }}>
                                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>总价</Text>
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                                    <TextInput style={{
                                                        paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red', textAlign: 'right'
                                                    }}
                                                        placeholder='输入总价'
                                                        onChangeText={this.moneyFun.bind(this)}
                                                    >
                                                    </TextInput>
                                                    <Text style={{ color: '#000', fontSize: 15.4, }}>元</Text>
                                                </View>
                                            </View>

                                        </View>
                                    )
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
                                        <TouchableOpacity
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
                        <View style={{ flexDirection: "row", alignItems: 'center', justifyContent: 'space-between', marginTop: 15 }}>
                            <TextInput style={{
                                borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                                height: 38, marginTop: 5, color: 'red', flex: 1, marginRight: 10
                            }}
                                placeholder='输入你能提供的待遇(最多8个字)'
                                onChangeText={this.addWelfare.bind(this)}
                                value = {this.state.addWelfareInput}
                            >
                            </TextInput>
                            <TouchableOpacity
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
                    <View style={{ padding: 11, backgroundColor: '#fff' }}>
                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>项目名称：</Text>
                            <TextInput style={{
                                paddingLeft: 10, height: 38, flex: 1, marginTop: 5, color: 'red', textAlign: 'right'
                            }}
                                placeholder='输入招工项目的名称(最多15个字)'
                                onChangeText={this.pro_work_nameFun.bind(this)}
                                >
                            </TextInput>
                        </View>
                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>施工单位：</Text>
                            <TextInput style={{
                                paddingLeft: 10, height: 38, flex: 1, marginTop: 5, color: 'red', textAlign: 'right'
                            }}
                                placeholder='输入施工单位的名称(最多15个字)'
                                onChangeText={this.company_nameFun.bind(this)}
                                >
                            </TextInput>
                        </View>
                    </View>

                    {/* 项目所在地 */}
                    <Text style={{ marginLeft: 13.2, marginRight: 13.2, marginTop: 8.8, marginBottom: 8.8, color: '#3d4145', fontSize: 15.4 }}>
                        项目所在地：{this.props.navigation.getParam('fbzgAddressOneName')} {this.props.navigation.getParam('fbzgAddressTwoName')}
                    </Text>

                    {/* 详细地址 */}
                    <TouchableOpacity
                        onPress={() => this.addressFun()}
                        style={{
                            padding: 13, backgroundColor: '#fff', flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'space-between', marginBottom: 10
                        }}>
                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>详细地址：</Text>
                        <View style={{ flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>{GLOBAL.fbzgAddress.detailAddress}</Text>
                            <Icon style={{ marginLeft: 10 }} name="r-arrow" size={12} color="#000" />
                        </View>
                    </TouchableOpacity>

                    {/* 项目描述 */}
                    <View style={{ backgroundColor: '#fff', paddingLeft: 13, paddingRight: 13, paddingTop: 15.4, paddingBottom: 15.4 }}>
                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>项目描述</Text>
                        <TextInput multiline={true}
                            placeholder='填写具体的项目介绍，例如项目所需市场、工资发放方式等，能让找活方更多地了解工作详情。'
                            style={{
                                height: 88, padding: 5, margin: 0, fontSize: 15, marginTop: 10
                            }}
                            textAlignVertical='top'
                            onChangeText={this.describeFun.bind(this)}
                        ></TextInput>
                    </View>

                    <Text style={{ color: '#999', fontSize: 15.4, marginTop: 11, marginBottom: 50, textAlign: 'center' }}>你的招工信息会在平台展示50天</Text>

                </ScrollView>

                {/* 加载弹框组件 */}
                <Loading
                    openAlertFun={this.openAlertFun.bind(this)}
                    openAlert={this.state.openAlert}
                    icon='warning'
                    font={this.state.warning} />

                {/* 底部按钮 */}
                <View style={{ padding: 11, backgroundColor: '#fafafa', position: 'absolute', bottom: 0, width: '100%', }}>
                    <TouchableOpacity
                        onPress={() => this.btn()}
                        style={{ borderRadius: 4.4, backgroundColor: '#eb4e4e', height: 44, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ fontSize: 18.7, color: '#fff' }}>立即发布</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    // 加载弹框控制
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
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
        })
    }
    // 选择日薪
    rxFun() {
        this.setState({
            rxoryx: true
        })
    }
    // 选择月薪
    yxFun() {
        this.setState({
            rxoryx: false
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
            peopleNum: e
        })
    }
    // 选择项目具体地址
    addressFun() {
        this.props.navigation.navigate('Myrecruit_address', {
            callback: (() => {
                this.setState({})
            }),
            fbzgAddressTwoName: this.props.navigation.getParam('fbzgAddressTwoName')
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
            money: e
        })
    }
    max_moneyFun(e) {
        this.setState({
            max_money: e
        })
    }
    // 工程规模
    total_scaleFun(e) {
        this.setState({
            total_scale: e
        })
    }
    // 选择待遇
    selectWelFun(e) {
        if(this.state.selectWelfare.indexOf(e)>-1){
            let arr = this.state.selectWelfare
            var index = arr.indexOf(e);
            arr.splice(index, 1);
            this.setState({
                selectWelfare: arr
            })
        }else{
            let arr = this.state.selectWelfare
            arr.push(e)
            this.setState({
                selectWelfare: arr
            })
        }
    }
    addWelfare(e){
        this.setState({
            addWelfareInput:e
        })
    }
    // 添加待遇
    addWelfareFun(){
        let arrAll = this.state.welfareArr
        arrAll.push(this.state.addWelfareInput)
        let arr = this.state.selectWelfare
        arr.push(this.state.addWelfareInput)
        this.setState({
            welfareArr:arrAll,
            addWelfareInput:arr,
            addWelfareInput:''
        })
    }
    // 包工-单价
    unitMoneyFun(e){
        this.setState({
            unitMoney:e
        })
    }
    // 项目名称
    pro_work_nameFun(e){
        this.setState({
            pro_work_name:e
        })
    }
    // 施工单位名称
    company_nameFun(e){
        this.setState({
            company_name:e
        })
    }
    // 突击队用工天数
    work_dayFun(e){
        this.setState({
            work_day:e
        })
    }
    // 突击队工作时长
    work_hourFun(e){
        this.setState({
            work_hour:e
        })
    }
    // 立即发布按钮
    btn() {
        let btn = true
        if (this.state.peopleNum == '') {
            btn = false
            this.setState({
                warning: '请输入所需人数',
                openAlert: !this.state.openAlert,
            }, () => {
                setTimeout(() => {
                    this.setState({
                        openAlert: false
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
                        openAlert: false
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
                        openAlert: false
                    })
                }, 2000)
            })
        }
        if (btn == true) {
            fetchFun.load({
                url: 'jlforemanwork/pubproject',
                data: {
                    pid: this.state.pid,//项目id，修改项目的时候传
                    role_type: GLOBAL.userinfo.role,//	找工角色
                    pro_address: GLOBAL.fbzgAddress.detailAddress,//详细地址
                    county_no: GLOBAL.fbzgAddress.fbzgAddressTwoNum,//城市区县代码一定是县区级的城市编码 app端传
                    cooperate_type: this.props.navigation.getParam('type') == '招突击队' ? '4' : this.state.dgorbg ? '1' : '2',//1点工，2包工，3总包 ,4突击队
                    person_count: this.state.peopleNum,//找工人数
                    balance_way: '3',//找工单位
                    money: this.state.money,//点工代表单价、包工和总包代表总价
                    max_money: this.state.max_money,
                    work_type: GLOBAL.fbzgType.fbzgTypeNum,//所需工种
                    work_name: this.props.navigation.getParam('fbzgTypeNameOther'),//当工种为其它时的工种名称
                    pro_type: GLOBAL.fbzgProject.fbzgProjectNum,//工程类别
                    pro_name: this.props.navigation.getParam('fbzgProjectNameOther'),//当工程类别为其它时的名称
                    total_scale: this.state.total_scale,//总规模
                    pro_description: this.state.describe,//项目描述
                    pro_location: '104.078763,30.397344',//经纬度
                    welfare: this.state.selectWelfare.join(','),//福利
                    unitMoney: this.state.unitMoney,//单价，包工有效
                    pro_work_name: this.state.pro_work_name,//项目名称
                    company_name: this.state.company_name,//施工单位名称
                    work_begin: this.state.presetText,//突击队开工时间
                    work_day: this.state.work_day,//突击队工天
                    work_hour: this.state.work_hour,//突击队每日工时
                },
                success: (res) => {
                    console.log('---发布招工---', res)
                    if (res.state == 1) {
                        GLOBAL.pid = res.values.pid
                        this.setState({})
                        this.props.navigation.navigate('Myrecruit_suit')
                    }
                }
            });
        }
    }
}

//封装一个日期组件
class CustomButton extends React.Component {
    render() {
        return (
            <TouchableOpacity
                onPress={this.props.onPress}
                style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 44,
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                }}>
                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>开工时间</Text>
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                    {
                        this.props.presetText == '' ? (
                            <Text style={{ fontSize: 14, color: 'rgb(168,168,168)', marginRight: 7 }}>选择开工时间</Text>
                        ) : (
                                <Text style={{ fontSize: 14, color: '#333333', marginRight: 7 }}>{this.props.presetText}</Text>
                            )
                    }
                    <Icon name="d-arrow" size={15} color="rgb(168,168,168)" />
                </View>
            </TouchableOpacity>

        );
    }
}
