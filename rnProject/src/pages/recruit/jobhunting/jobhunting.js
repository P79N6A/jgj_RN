/*
 * @Author: stl
 * @Date: 2019-03-13 11:01:59 
 * @Mpdule 找工作
 * @Last Modified time: 2019-03-13 11:01:59 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ListView, ActivityIndicator, RefreshControl, FlatList } from 'react-native';
import Address from '../../../component/selectaddress'
import Typeselects from '../../../component/typeselects'
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../../component/listitem'
import Empty from '../../../component/listempty'
import Header from '../../../component/listheader'
import Footer from '../../../component/listfooter'

export default class counter extends Component {
    constructor(props) {
        super(props)
        this.state = {
            navigate: '',
            selects: 'list',//address,type,works
            clicktypeNum: -1,
            isAddress: false,//是否选择全国选项
            isType: false,
            isWorks: false,
            clickaddressoneNum: -1,
            clickaddresstwoNum: -1,
            clickaddressthreeNum: -1,
            selected: [],//选择的工种
            type: [
                { key: 0, name: '全部工种' },
                { key: 1, name: '我的工种' },
                { key: 2, name: '木工' },
                { key: 3, name: '水电工' },
                { key: 4, name: '钢筋工' },
            ],
            addressone: [
                { key: 0, name: '北京市' },
                { key: 1, name: '天津市' },
                { key: 2, name: '河北省' },
                { key: 3, name: '山西省' },
                { key: 4, name: '内蒙古自治区' },
                { key: 5, name: '辽宁区' },
                { key: 6, name: '吉林省' },
                { key: 7, name: '上海市' },
                { key: 8, name: '江苏省' },
                { key: 9, name: '浙江省' },
                { key: 10, name: '安徽省' },
                { key: 11, name: '福建省' },
                { key: 12, name: '江西省' },
                { key: 13, name: '山东省' },
                { key: 14, name: '河南省' },
                { key: 15, name: '湖北省' },
                { key: 16, name: '湖南省' },
                { key: 17, name: '广东省' },
                { key: 18, name: '广西壮族自治区' },
                { key: 19, name: '海南省' },
                { key: 20, name: '重庆市' },
            ],
            addresstwo: [
                { key: 0, name: '山东省' },
                { key: 1, name: '济南市' },
                { key: 2, name: '青岛市' },
                { key: 3, name: '淄博市' },
                { key: 4, name: '枣庄市' },
                { key: 5, name: '东营市' },
                { key: 6, name: '烟台市' },
                { key: 7, name: '潍坊市' },
                { key: 8, name: '济宁市' },
                { key: 9, name: '泰安市' },
                { key: 10, name: '威海市' },
                { key: 11, name: '日照市' },
                { key: 12, name: '莱芜市' },
                { key: 13, name: '临沂市' },
                { key: 14, name: '德州市' },
                { key: 15, name: '聊城市' },
                { key: 16, name: '滨州市' },
                { key: 17, name: '菏泽市' },
            ],
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    //选择地址
    addressfun() {
        let _this = this
        this.setState({
            isAddress: !this.state.isAddress,
            isType: false,
            isWorks: false
        }, () => {
            if (_this.state.isAddress) {
                _this.setState({
                    selects: 'address'
                })
            } else {
                _this.setState({
                    selects: 'list'
                })
            }
        })
    }
    // 选择工种
    typefun() {
        let _this = this
        this.setState({
            isType: !this.state.isType,
            isAddress: false,
            isWorks: false
        }, () => {
            if (_this.state.isType) {
                _this.setState({
                    selects: 'type'
                })
            } else {
                _this.setState({
                    selects: 'list'
                })
            }
        })
    }
    // 选择工程类别
    worksfun() {
        let _this = this
        this.setState({
            isWorks: !this.state.isWorks,
            isType: false,
            isAddress: false
        }, () => {
            if (_this.state.isWorks) {
                _this.setState({
                    selects: 'works'
                })
            } else {
                _this.setState({
                    selects: 'list'
                })
            }
        })
    }
    // 选择工种
    clicktype(e) {
        GLOBAL.zgzworktype = [e]
        this.setState({
            selects: 'list',
            isType: false,
        })
        let arr = []
        GLOBAL.zgzworktype.map((item, index) => {
            arr.push(item)
        })
        this.setState({
            selected: arr
        })
    }
    // 选择城市
    clickaddress(obj) {
        this.setState({
            selects: 'list',
            clickaddressoneNum: obj.a,
            clickaddresstwoNum: obj.b,
            isAddress: false
        })
        this.state.addressone.map((item, key) => {
            if (item.key == obj.a) {
                GLOBAL.zgzaddress.zgzoneName = item.name
            }
        })
        this.state.addresstwo.map((item, key) => {
            if (item.key == obj.b) {
                GLOBAL.zgzaddress.zgztwoName = item.name
            }
        })
        GLOBAL.zgzaddress.zgzone = obj.a
        GLOBAL.zgzaddress.zgztwo = obj.b
        this.setState({})
    }
    // 选择工程类别列表选项
    clickWorks(clickworkNum) {//接收已选择的工程类别key值，下次在进入传入此key值会有选中的样式效果
        this.setState({
            selects: 'list',
            clickworkNum: clickworkNum,
            isWorks: !this.state.isWorks
        })
    }
    componentWillMount() {
        this.setState({
            navigate: this.props.navigation//页面跳转需要
        })
    }
    render() {
        let obj = {}
        obj.type = '找工作单选工种'
        let objAddress = {}
        objAddress.addressone = this.state.addressone
        objAddress.addresstwo = this.state.addresstwo
        objAddress.onenum = this.state.clickaddressoneNum
        objAddress.twonum = this.state.clickaddresstwoNum
        objAddress.jb = 'zgzaddress'
        return (
            <View style={styles.containermain}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>找工作</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                        onPress={() => this.props.navigation.navigate('Authen')}>
                        <Icon style={{ marginRight: 3 }} name="certification" size={20} color="#eb4e4e" />
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>去认证</Text>
                    </TouchableOpacity>
                </View>
                {/* 完善 */}
                <View style={{
                    height: 47,
                    width: '100%',
                    flexDirection: 'row',
                    alignItems: 'center',
                    paddingLeft: 10,
                    backgroundColor: '#fdf1e0'
                }}>
                    <Text style={{
                        color: '#f18215',
                        fontSize: 12
                    }}>完善找活名片，让招工方主动联系你</Text>
                    <View style={{
                        width: 56,
                        height: 26,
                        marginLeft: 20,
                        borderWidth: 1,
                        borderColor: '#f18215',
                        borderRadius: 4,
                        flexDirection: 'row',
                        alignItems: 'center',
                        justifyContent: 'center',
                        backgroundColor: 'white'
                    }}>
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Mycard')} style={{
                            color: '#f18215',
                            fontSize: 13
                        }}>
                            <Text>去完善</Text>
                        </TouchableOpacity>
                    </View>
                </View>
                {/* 选择栏 */}
                <View style={{ marginBottom: -.5, backgroundColor: '#fafafa', borderTopColor: '#dbdbdb', borderTopWidth: 1, height: 44, width: '100%', flexDirection: 'row', zIndex: 1000 }}>
                    <TouchableOpacity onPress={() => { this.addressfun() }} style={{ width: '33.33%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'address' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'address' ? 0 : 1, }}>
                        <Text style={{ color: '#666', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzaddress.zgztwoName}</Text>
                        {
                            this.state.selects == 'address' ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#999999" />
                                )
                        }
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => { this.typefun() }} style={{ width: '33.33%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'type' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'type' ? 0 : 1 }}>
                        <Text style={{ color: '#666', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzworktype}</Text>
                        {
                            this.state.selects == 'type' ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }} name="rd-arrow" size={13} color="#999999" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#999999" />
                                )
                        }
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => { this.worksfun() }} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, backgroundColor: '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: 1 }}>
                        {
                            this.state.selects == 'works' ? (
                                <Icon style={{ marginRight: 3 }} name="success" size={14} color="#eb4e4e" />
                            ) : (
                                    <Image style={{ width: 16, height: 16, marginRight: 3 }} source={require('../../../assets/recruit/yuan.png')}></Image>
                                )
                        }
                        <Text style={{ color: '#666', fontSize: 13, marginRight: 3 }}>只看实名信息</Text>
                    </TouchableOpacity>
                </View>
                {
                    this.state.selects == 'address' ? (
                        <Address clickaddress={this.clickaddress.bind(this)} objAddress={objAddress} />
                    ) : (
                            this.state.selects == 'type' ? (
                                <Typeselects
                                    obj={obj}
                                    type={this.state.type}
                                    selected={this.state.selected}
                                    clicktype={this.clicktype.bind(this)}
                                />
                            ) : (
                                    <List navigate={this.state.navigate} />
                                )
                        )
                }
            </View>
        );
    }
}
// 工作列表数据
class List extends React.Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.state = {
            // 列表数据结构
            dataSource: [
                { key: 0 },
                { key: 1 },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
        }
    }
    render() {
        return (
            <View style={{ flex: 1 }}>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.props.navigate} />}//头布局
                    renderItem={({ item }) => <Lists data={item} navigate={this.props.navigate} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.props.navigate} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
            </View>
        )
    }
    // 获取数据列表
    _getHotList() {
        this.state.isLoadMore = true
        // fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
        //     .then((response) => response.json())
        //     .then((responseJson) => {
        //         console.log(responseJson)
        //         if (this.page === 1) {
        //             console.log("重新加载")
        //             this.setState({
        //                 isLoadMore: false,
        //                 dataSource: responseJson.list
        //             })
        //         } else {
        //             console.log("加载更多")
        //             this.setState({
        //                 isLoadMore: false,
        //                 // 数据源刷新 add
        //                 dataSource: this.state.dataSource.concat(responseJson.list)
        //             })
        //             if (this.page <= 3) {
        //                 this.setState({
        //                     showFoot: 1
        //                 })
        //             } else if (this.page > 3) {
        //                 this.setState({
        //                     showFoot: 2
        //                 })
        //             }
        //         }


        //     })
        //     .catch((error) => {
        //         console.error(error);
        //     });
    }

    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this._getHotList()
        }
    };

    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            this._getHotList()
        }
    }
}
// item布局
class Lists extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const { item } = this.props
        return (
            < TouchableOpacity onPress={() => this.props.navigate.navigate('Jobdetails')
            } style={styles.information} >
                <View style={styles.head}>
                    <View style={styles.headl}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginRight: 7, backgroundColor: '#eb7a4e', paddingLeft: 2, paddingRight: 2, paddingTop: 1, paddingBottom: 1, borderRadius: 3 }}><Text style={{ color: '#fff', fontSize: 12 }}>点工</Text></View>
                        <Text style={{ fontSize: 16, color: '#000' }}>成都市招木工</Text>
                    </View>
                    <View style={styles.headr}><Text>土建</Text></View>
                </View>
                <View style={styles.main}>
                    <View style={{ height: 41, flexDirection: 'row', alignItems: 'center' }}>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>人数：</Text>
                            <Text style={{ color: '#EB4E4C', fontSize: 14 }}>30</Text>
                            <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>人</Text>
                        </View>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>工资：</Text>
                            <Text style={{ color: '#EB4E4C', fontSize: 14 }}>280~300</Text>
                            <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>元/天</Text>
                        </View>
                    </View>
                    <View style={{ flexDirection: "row" }}>
                        <View style={{ flex: 1 }}>
                            <Text style={{ color: "#999", fontSize: 14, lineHeight: 20 }}>长期走活，点工九小时，加班另算，中途生活费预支，每月10号结上月百分十80...每十天生活费500...少数名族</Text>
                        </View>
                        <View style={{ flexDirection: 'row', justifyContent: "center", alignItems: 'center' }}>
                            <Icon name="r-arrow" size={12} color="#000" />
                        </View>
                    </View>
                    <View style={{ marginBottom: 6.5, marginTop: 6.5, flexDirection: 'row' }}>
                        <Text style={{ fontSize: 14, color: '#000', marginTop: 3.2 }}>待遇：</Text>
                        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>包吃不包住</Text>
                            </View>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>买保险</Text>
                            </View>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>按时发钱</Text>
                            </View>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>280</Text>
                            </View>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>9小时工作制</Text>
                            </View>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>干活踏实的</Text>
                            </View>
                            <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                <Text style={{ fontSize: 12, color: '#333' }}>听旨</Text>
                            </View>
                        </View>
                    </View>
                </View>
                <View style={styles.foot}>
                    <Text style={{ color: '#999', fontSize: 12 }}>1小时前/64公里</Text>
                </View>
            </TouchableOpacity>
        )
    }
}

const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        backgroundColor: '#ebebeb',
        alignItems: 'center',
    },
    information: {
        paddingLeft: 15,
        paddingRight: 15,
        marginBottom: 15,
        backgroundColor: 'white',

    },
    head: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "space-between",
        height: 38,
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
    main: {
        borderTopWidth: .5,
        borderTopColor: '#999',
        borderBottomWidth: .5,
        borderBottomColor: '#999',
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
})