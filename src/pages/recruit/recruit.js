/*
 * @Author: stl
 * @Date: 2019-03-12 10:10:52 
 * @Module：招聘，找活招工
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,
    Platform,
    FlatList,
    RefreshControl,
    Animated,
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import ListItem from '../../component/listitem'
import Empty from '../../component/listempty'
import * as _ from "lodash";

export default class recruit extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1;
        this.isFresh=false
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            navigate: '',
            fixeds: true,//控制发布招工按钮的固定定位变量
            scrollheight: 0,//滚动页面初始高度
            moveValue: new Animated.Value(1),
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        // headerTitle: <View style={{ flexDirection: 'row', alignItems: 'center', position: "absolute", left: '50%', marginLeft: -45 }}>
        //     <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>找活招工</Text>
        //     <TouchableOpacity onPress={() => navigation.navigate('Cheat')}>
        //         
        //     </TouchableOpacity>
        // </View>,//导航栏标题
        // headerTitleStyle: {//导航栏文字样式
        //     flex: 1,
        //     textAlign: 'center',//标题居中
        //     color: '#3d4145',
        //     fontSize: 18,
        //     fontWeight: '400',
        // },
        // headerTitleContainerStyle: {//保证标题居中
        //     left: Platform.OS === 'ios' ? 70 : 56,
        //     right: Platform.OS === 'ios' ? 70 : 56,
        // },
        // headerStyle: {
        //     backgroundColor: '#fafafa',//设置导航栏背景色
        //     height: 44,//导航栏高度
        // },
        // headerRight: <TouchableOpacity onPress={() => navigation.navigate('Doubt')}>
        //     <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>防骗指南</Text>
        // </TouchableOpacity>,
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        this.setState({
            navigate: this.props.navigation//页面跳转需要
        })
        fetchFun.load({
            url: 'jlforemanwork/findjobactive',
            data: {
                os: 'W',
                token: '5a28a5acab61acb713ff44d51d129f34',
                ver: '4.0.1',
                client_type: 'person',
                timestamp: '1553764979',
                sign: 'df0ea3b032b382a3f443e349cadf712e76cf8dd9',
                pg: '1',
                pagesize: '10',
                city_no: '510107',
                contacted: '0',
                is_all_area: '1',
                work_type: '-1',
                role_type: '1',
                pro_type: '-1',
                is_verified: '1'
            },
            success: (res) => {
                this.setState({
                    dataSource: res.data_list
                })
                console.log(res.data_list)
            }
        });
    }
    render() {
        let { moveValue } = this.state

        let toValue = moveValue.interpolate({
            inputRange: [0, 1],
            outputRange: [0, 120]
        })
        return (
            <View style={styles.container}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, width: '25%' }} >
                    </View>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', marginRight: 3 }}>找活招工</Text>
                        <TouchableOpacity onPress={() => this.props.navigation.navigate('Doubt')}>
                            <Icon name="question-circle" size={19} color="#999" />
                        </TouchableOpacity>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                        onPress={() => this.props.navigation.navigate('Cheat')}>
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>防骗指南</Text>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.state.navigate} />}//头布局
                    renderItem={({ item }) => <List data={item} navigate={this.state.navigate} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.state.navigate} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onScrollEndDrag={() => this.onScrollEndDrag.bind(this)}//一个子view滚动结束拖拽时触发
                    onContentSizeChange={()=>this.onContentSizeChange}
                />
                {/* 发布招工 */}
                <Animated.View                 // 使用专门的可动画化的View组件
                    style={{
                        bottom: toValue,
                    }}
                >
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Releasement')}
                        // onPress={()=>this.pressView()}
                        style={{
                            position: 'absolute', left: '50%', marginLeft: -72,
                        }}
                    >
                        <View
                            style={{
                                backgroundColor: '#ec5e5e', flexDirection: 'row', alignItems: 'center',
                                justifyContent: "center", borderRadius: 176.6, width: 143.5, height: 50,
                                // 设置阴影
                                elevation: 3,
                                shadowOffset: { width: 3, height: 3 },
                                shadowColor: 'black',
                                shadowOpacity: 1,
                                shadowRadius: 2
                            }}>
                            {/* <Icon name="" size={} color="" /> */}
                            <Icon style={{ marginLeft: 5 }} name="plus" size={20} color="#fff" />
                            <Text style={{ fontSize: 16.5, color: '#fff', marginLeft: 10 }}>发布招工</Text>
                        </View>
                    </TouchableOpacity>
                </Animated.View>
            </View>
        );
    }
    // 动画函数
    adimatedFun() {
        this.toValue = this.state.fixeds ? 1 : 0
        Animated.timing(
            this.state.moveValue,  // 初始化从0开始
            {
                toValue: this.toValue, // 目标值
                duration: 300,         // 时间间隔
            }
        ).start()
    }
    // 一个子view滚动结束拖拽时触发
    onScrollEndDrag(e) {
        if (e.nativeEvent.contentOffset.y > this.state.scrollheight) {//向下滚动，按钮隐藏
            this.setState({
                scrollheight: e.nativeEvent.contentOffset.y,
                fixeds: false
            }, () => {
                this.adimatedFun()
            })
        } else {//向上滚动，按钮显示
            this.setState({
                scrollheight: e.nativeEvent.contentOffset.y,
                fixeds: true
            }, () => {
                this.adimatedFun()
            })
        }
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
    onContentSizeChange=()=>{
        this.isFresh=true;
    }
    // 加载更多
    _onLoadMore() {
        if (this.isFresh) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh=false;
                    this._getHotList()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }

}
// 头部布局-菜单
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View style={styles.menubg}>
                {/* 菜单 */}
                <View style={styles.menu} >
                    <View style={styles.top}>
                        <TouchableOpacity style={styles.munuss} onPress={() => this.props.navigate.navigate('Jobhunting')}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/menutest.png')}></Image>
                            <Text style={styles.menufont}>找工作</Text>
                        </TouchableOpacity>
                        <TouchableOpacity style={styles.munussb} onPress={() => this.props.navigate.navigate('Mycard')}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/business-card.png')}></Image>
                            <Text style={styles.menufont}>我的名片</Text>
                        </TouchableOpacity>
                        <TouchableOpacity style={styles.munuss} onPress={() => this.props.navigate.navigate('Lookworker')}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/search.png')}></Image>
                            <Text style={styles.menufont}>找工人</Text>
                        </TouchableOpacity>
                        <TouchableOpacity style={styles.munuss} onPress={() => this.props.navigate.navigate('Myjob')}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/my-job.png')}></Image>
                            <Text style={styles.menufont}>我的招工</Text>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.bot}>
                        <TouchableOpacity
                            onPress={() => this.props.navigate.navigate('Hiringrecord')}
                            style={styles.munuss}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/recode.png')}></Image>
                            <Text style={styles.menufont}>招聘记录</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => this.props.navigate.navigate('Commandos')}
                            style={styles.munuss}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/commando.png')}></Image>
                            <Text style={styles.menufont}>突击队</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => this.props.navigate.navigate('Workershift')}
                            style={styles.munuss}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/labor.png')}></Image>
                            <Text style={styles.menufont}>工人/班组</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => this.props.navigate.navigate('Recruitplan')}
                            style={styles.munuss}>
                            <Image style={styles.menuimg} source={require('../../assets/recruit/service.png')}></Image>
                            <Text style={styles.menufont}>招聘套餐</Text>
                        </TouchableOpacity>
                    </View>
                </View>
                {/* 推荐 */}
                <View style={styles.recom}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Icon style={{ marginRight: 3 }} name="praise" size={19} color="#eb4e4e" />
                        <Text style={{ fontSize: 17, color: '#000' }}>为你推荐</Text>
                        <Image style={{ width: 8, height: 14, marginLeft: 5 }} source={require('../../assets/recruit/arrow.png')}></Image>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: 'rgb(65, 147, 223)', fontSize: 15 }}>我未开工正在找工作</Text>
                        <Icon style={{ marginLeft: 3, marginTop: 2 }} name="r-arrow" size={15} color="#4193DF" />
                    </View>
                </View>
            </View>
        )
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const item = this.props.data
        console.log(item)
        return (
            <TouchableOpacity onPress={() => this.props.navigate.navigate('Jobdetails')} style={styles.information}>
                <View style={styles.head}>
                    <View style={styles.headl}>
                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                            marginRight: 7, backgroundColor: '#eb7a4e', paddingLeft: 2, paddingRight: 2, paddingTop: 1,
                            paddingBottom: 1, borderRadius: 3
                        }}><Text style={{ color: '#fff', fontSize: 12 }}>{item.classes[0].cooperate_type.type_name}</Text></View>
                        <Text style={{ fontSize: 16, color: '#000' }}>{item.pro_title}</Text>
                        <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={require('../../assets/recruit/jobverified.png')}></Image>
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
                            {
                                item.welfare.map((item,index)=>{
                                    return(
                                        <View key={index} style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                            <Text style={{ fontSize: 12, color: '#333' }}>{item}</Text>
                                        </View>
                                    )
                                })
                            }
                        </View>
                    </View>
                </View>
                <View style={styles.foot}>
                    <Text style={{ color: '#999', fontSize: 12 }}>{item.create_time_txt}/64公里</Text>
                </View>
            </TouchableOpacity>
        )
    }
}
//尾部布局
class Footer extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <TouchableOpacity onPress={() => this.props.navigate.navigate('Jobhunting')} style={{ flexDirection: 'row', justifyContent: 'center', marginBottom: 96 }}>
                <View style={{ width: 186, height: 30, marginTop: 20, borderWidth: 1, borderColor: '#666', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 20 }}>
                    <Text style={{ fontSize: 15, color: '#000' }}>点击查看更多工作信息
                    <Icon style={{ marginLeft: 3 }} name="r-arrow" size={12} color="#000" />
                    </Text>
                </View>
            </TouchableOpacity>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ebebeb'
    },
    menubg: {
        height: 233,
    },
    menu: {
        height: 192,
        backgroundColor: 'white',
        paddingTop: 15,
        paddingBottom: 15,
    },
    recom: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingLeft: 10,
        paddingRight: 10,
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
        paddingLeft: 20,
        paddingRight: 20,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'center',
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
});