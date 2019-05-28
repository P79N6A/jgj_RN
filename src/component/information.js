import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Platform,
    Image, ScrollView, NativeModules,
    DeviceEventEmitter
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import LinearGradient from 'react-native-linear-gradient';


export default class Information extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }

    render() {
        let item = this.props.item
        return (
            <View>
                {/* 待遇 */}
                {
                    item.welfare && item.welfare.length > 0 && item.welfare[0] ? (
                        < View style={{ flexDirection: 'row', marginBottom: 5 }}>
                            < View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                {
                                    item.welfare.map((item, index) => {
                                        return (
                                            <View key={index} style={{
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                justifyContent: 'center',
                                            }
                                            }>
                                                {
                                                    index != 0 ? (
                                                        <View style={{
                                                            width: 1, height: 10, backgroundColor: '#666666',
                                                            marginLeft: 6, marginRight: 6
                                                        }}></View>
                                                    ) : false
                                                }
                                                <Text style={{ fontSize: 12, color: '#333' }} >{item}</Text>
                                            </View>
                                        )
                                    })
                                }
                            </View>
                        </View>
                    ) : false
                }

                < View>
                    {
                        item.classes ? (
                            item.classes[0].cooperate_type ? (
                                item.classes[0].cooperate_type.type_name ? (
                                    item.classes[0].cooperate_type.type_name == '突击队' ? (
                                        <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                            {/* 开工时间 */}
                                            {
                                                item.classes ? (
                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>开工时间：</Text>
                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                            {item.classes[0].work_begin ? item.classes[0].work_begin : '面议'}
                                                        </Text>
                                                    </View>
                                                ) : false
                                            }

                                            {/* 工资 */}
                                            {
                                                item.classes ? (
                                                    item.classes[0].max_money && Number(item.classes[0].max_money) != 0 ? (
                                                        < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>工资：</Text>

                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                {item.classes[0].money}~{item.classes[0].max_money}
                                                            </Text>

                                                            <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                        </View>
                                                    ) : (
                                                            < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>工资：</Text>

                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                    {item.classes[0].money && Number(item.classes[0].money) != 0 ? item.classes[0].money : '面议'}
                                                                </Text>

                                                                {
                                                                    item.classes[0].money && Number(item.classes[0].money) != 0 ? (
                                                                        <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/人/天</Text>
                                                                    ) : false
                                                                }
                                                            </View>
                                                        )
                                                ) : false
                                            }

                                            {/* 用工天数 */}
                                            {
                                                item.classes ? (
                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>用工天数：</Text>
                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                            {item.classes[0].work_day && Number(item.classes[0].work_day) != 0 ? item.classes[0].work_day : '面议'}
                                                        </Text>

                                                        {
                                                            item.classes[0].work_day && Number(item.classes[0].work_day) != 0 ? (
                                                                <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>天</Text>
                                                            ) : false
                                                        }
                                                    </View>
                                                ) : false
                                            }

                                            {/* 人数 */}
                                            {
                                                item.classes ? (
                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>人数：</Text>
                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                            {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? item.classes[0].person_count : '若干'}
                                                        </Text>
                                                        <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>
                                                            {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? '人' : false}
                                                        </Text>
                                                    </View>
                                                ) : false
                                            }
                                        </View>
                                    ) : (
                                            item.classes[0].cooperate_type.type_name == '点工' ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                    {/* 人数 */}
                                                    {
                                                        item.classes ? (
                                                            item.classes[0].person_count ? (
                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>人数：</Text>
                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                        {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? item.classes[0].person_count : '若干'}
                                                                    </Text>
                                                                    < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>
                                                                        {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? '人' : false}
                                                                    </Text>
                                                                </View>
                                                            ) : false
                                                        ) : false
                                                    }

                                                    {/* 工资 */}
                                                    {
                                                        item.classes ? (
                                                            item.classes[0].max_money ? (
                                                                < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>工资：</Text>

                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                        {item.classes[0].money}~{item.classes[0].max_money}
                                                                    </Text>

                                                                    <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                </View>
                                                            ) : (
                                                                    < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>工资：</Text>

                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                            {item.classes[0].money && Number(item.classes[0].money) != 0 ? item.classes[0].money : '面议'}
                                                                        </Text>

                                                                        {
                                                                            item.classes[0].money && Number(item.classes[0].money) != 0 ? (

                                                                                <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                            ) : false
                                                                        }
                                                                    </View>
                                                                )
                                                        ) : false
                                                    }
                                                </View>
                                            ) : (
                                                    item.classes[0].cooperate_type.type_name == '包工' ? (
                                                        // 总价、规模
                                                        Number(item.classes[0].money) && !Number(item.classes[0].unitMoney) ? (
                                                            <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                {/* 总价 */}
                                                                {
                                                                    item.classes ? (
                                                                        item.classes[0].money && item.classes[0].money != '0' ? (
                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                    {item.classes[0].money}
                                                                                </Text>
                                                                                < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                            </View>
                                                                        ) : (
                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                        面议
                                                    </Text>
                                                                                </View>
                                                                            )
                                                                    ) : false
                                                                }
                                                                {/* 规模 */}
                                                                {
                                                                    item.classes ? (
                                                                        item.classes[0].total_scale ? (
                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                    {item.classes[0].total_scale}
                                                                                </Text>

                                                                                <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                            </View>
                                                                        ) : (
                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                        面议
                                                    </Text>

                                                                                </View>
                                                                            )
                                                                    ) : false
                                                                }
                                                            </View>
                                                        ) : (
                                                                // 单价、总价、规模
                                                                Number(item.classes[0].unitMoney) && Number(item.classes[0].money) ? (
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                        {/* 单价 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].unitMoney ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].unitMoney}
                                                                                        </Text>
                                                                                        < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                        </Text>
                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }

                                                                        {/* 总价 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].money && item.classes[0].money != '0' ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].money}
                                                                                        </Text>
                                                                                        < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                        </Text>
                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }

                                                                        {/* 规模 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].total_scale ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].total_scale}
                                                                                        </Text>

                                                                                        <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                        </Text>

                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }
                                                                    </View>
                                                                ) : (
                                                                        // 单价、规模
                                                                        <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                            {/* 单价 */}
                                                                            {
                                                                                item.classes ? (
                                                                                    Number(item.classes[0].unitMoney) ? (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                {item.classes[0].unitMoney}
                                                                                            </Text>
                                                                                            < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                        </View>
                                                                                    ) : (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    面议
                                                            </Text>
                                                                                            </View>
                                                                                        )
                                                                                ) : false
                                                                            }
                                                                            {/* 规模 */}
                                                                            {
                                                                                item.classes ? (
                                                                                    Number(item.classes[0].total_scale) ? (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                {item.classes[0].total_scale}
                                                                                            </Text>

                                                                                            <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                        </View>
                                                                                    ) : (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    面议
                                                            </Text>

                                                                                            </View>
                                                                                        )
                                                                                ) : false
                                                                            }
                                                                        </View>
                                                                    )
                                                            )
                                                    ) : (
                                                            item.classes[0].cooperate_type.type_name == '总包' ? (
                                                                // 总价、规模
                                                        Number(item.classes[0].money) && !Number(item.classes[0].unitMoney) ? (
                                                            <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                {/* 总价 */}
                                                                {
                                                                    item.classes ? (
                                                                        item.classes[0].money && item.classes[0].money != '0' ? (
                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                    {item.classes[0].money}
                                                                                </Text>
                                                                                < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                            </View>
                                                                        ) : (
                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                        面议
                                                    </Text>
                                                                                </View>
                                                                            )
                                                                    ) : false
                                                                }
                                                                {/* 规模 */}
                                                                {
                                                                    item.classes ? (
                                                                        item.classes[0].total_scale ? (
                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                    {item.classes[0].total_scale}
                                                                                </Text>

                                                                                <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                            </View>
                                                                        ) : (
                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                        面议
                                                    </Text>

                                                                                </View>
                                                                            )
                                                                    ) : false
                                                                }
                                                            </View>
                                                        ) : (
                                                                // 单价、总价、规模
                                                                Number(item.classes[0].unitMoney) && Number(item.classes[0].money) ? (
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                        {/* 单价 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].unitMoney ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].unitMoney}
                                                                                        </Text>
                                                                                        < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                        </Text>
                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }

                                                                        {/* 总价 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].money && item.classes[0].money != '0' ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].money}
                                                                                        </Text>
                                                                                        < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                        </Text>
                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }

                                                                        {/* 规模 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].total_scale ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].total_scale}
                                                                                        </Text>

                                                                                        <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                        </Text>

                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }
                                                                    </View>
                                                                ) : (
                                                                        // 单价、规模
                                                                        <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                            {/* 单价 */}
                                                                            {
                                                                                item.classes ? (
                                                                                    Number(item.classes[0].unitMoney) ? (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                {item.classes[0].unitMoney}
                                                                                            </Text>
                                                                                            < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                        </View>
                                                                                    ) : (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    面议
                                                            </Text>
                                                                                            </View>
                                                                                        )
                                                                                ) : false
                                                                            }
                                                                            {/* 规模 */}
                                                                            {
                                                                                item.classes ? (
                                                                                    Number(item.classes[0].total_scale) ? (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                {item.classes[0].total_scale}
                                                                                            </Text>

                                                                                            <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                        </View>
                                                                                    ) : (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    面议
                                                            </Text>

                                                                                            </View>
                                                                                        )
                                                                                ) : false
                                                                            }
                                                                        </View>
                                                                    )
                                                            )
                                                                  ) : false
                                                        )
                                                )
                                        )
                                ) : false
                            ) : false
                        ) : false
                    }

                    {/* 项目描述 */}
                    {
                        this.props.msNo ? false : (
                            <View style={{ flexDirection: "row", marginTop: 5 }}>
                                <View style={{ flex: 1 }}>
                                    {
                                        item.pro_description ? (
                                            <Text style={{ color: "#666", fontSize: 14 }} numberOfLines={1}>
                                                {item.pro_description}
                                            </Text>
                                        ) : false
                                    }
                                </View>
                            </View>
                        )
                    }

                </View>
            </View>

        )
    }

}

const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        backgroundColor: '#ebebeb',
        alignItems: 'center',
    },

    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 14,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },

    top: {
        flexDirection: 'row'
    },
    bot: {
        flexDirection: 'row',
        marginTop: 22
    },
    munuss: {
        width: '25%',
        height: 70,
    },
    munussb: {
        width: '25%',
        height: 70,
        paddingLeft: 20,
        paddingRight: 20,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'center',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb'
    },
    menuimg: {
        width: 42,
        height: 42,
        marginBottom: 7.5,
    },
    menufont: {
        fontSize: 13,
        color: '#000',
    },
    information: {
        paddingLeft: 15,
        paddingRight: 15,
        paddingTop: 14.5,
        paddingBottom: 10,
        paddingBottom: 14.5,
        marginBottom: 10,
        backgroundColor: 'white',
    },
    head: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "space-between",
        flexDirection: 'row',
        marginBottom: 10,
    },
    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 12,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },
    foot: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginTop: 25
    },
})











