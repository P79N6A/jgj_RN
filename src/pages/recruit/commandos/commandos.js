/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-25 15:30:06 
 * @Module:突击队
 * @Last Modified time: 2019-03-25 15:30:06 
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
    Modal,
    Animated
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../../component/listitem'
import Empty from '../../../component/listempty'
import Footer from '../../../component/listfooter'
import * as _ from "lodash";

export default class recruit extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
        this.isFresh=false
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [
                { key: 0 },
                { key: 1 },
                { key: 2 },
                { key: 3 },
                { key: 4 },
                { key: 5 },
                { key: 6 },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            fixeds: true,//控制发布招工按钮的固定定位变量
            scrollheight: 0,//滚动页面初始高度
            navigate: '',
            ofModel: false,//实名认证弹框提醒
            moveValue: new Animated.Value(1),
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    componentWillMount() {
        this.setState({
            navigate: this.props.navigation//页面跳转需要
        })
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
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>突击队</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header alertFun={this.alertFun.bind(this)} navigate={this.state.navigate} />}//头布局
                    renderItem={({item}) => <List data={item} navigate={this.state.navigate}/>}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.state.navigate} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onScrollEndDrag={() => this.onScrollEndDrag.bind(this)}//一个子view滚动结束拖拽时触发
                    onContentSizeChange={()=>this.onContentSizeChange}
                />

                {/* 我要招突击队 */}
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
                            <Icon name="plus" size={20} color="#fff" />
                            <Text style={{ fontSize: 16.5, color: '#fff', marginLeft: 3 }}>我要找突击队</Text>
                        </View>
                    </TouchableOpacity>
                </Animated.View>

                {/* 认证提醒弹框 */}
                <Modal visible={this.state.ofModel}
                    animationType="none"//没有动画效果
                    transparent={true}//透明蒙层
                    onRequestClose={() => this.alertFun()}//回调会在用户按下 Android 设备上的后退按键触发
                    style={{ height: '100%' }}
                >
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => this.alertFun()}
                        style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                    </TouchableOpacity>
                    <View style={{
                        backgroundColor: '#fff', width: 298, height: 192, borderRadius: 7.7,
                        position: 'absolute', top: '50%', left: '50%', marginLeft: -149, marginTop: -96
                    }}>
                        <View style={{ width: '100%', height: 143, padding: 16.5, flexDirection: 'row', alignItems: 'center' }}>
                            <Text style={{ color: '#3d4145', fontSize: 18.7, lineHeight: 25 }}>进行下一步操作之前，需先完成实名认证</Text>
                        </View>
                        <View style={{
                            backgroundColor: '#fafafa', borderTopWidth: 1, borderTopColor: '#ebebeb', flex: 1, flexDirection: 'row',
                            alignItems: 'center', justifyContent: 'center', borderBottomLeftRadius: 7.7, borderBottomRightRadius: 7.7
                        }}>
                            <TouchableOpacity>
                                <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>马上去实名认证</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Modal>
            </View>
        );
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
    // 空布局
    _createEmptyView() {
        return (
            <View>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>

                </View>
                <Text style={{
                    color: '#999',
                    fontSize: 15,
                    textAlign: 'center',
                }}>暂时没有找突击队的信息</Text>
            </View>
        );
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
    //点击突击队认证弹框实名认证
    alertFun() {
        this.setState({
            ofModel: !this.state.ofModel
        })
    }
}
// 头部布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View>
                <View style={{ backgroundColor: '#fff', paddingTop: 16.5, paddingBottom: 16.5, flexDirection: 'row' }}>
                    <TouchableOpacity
                        onPress={() => this.props.alertFun()}
                        style={{ width: '50%' }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                            <Image style={{ width: 45, height: 45 }} source={require('../../../assets/recruit/commando-attest.png')}></Image>
                        </View>
                        <Text style={{ color: '#333', fontSize: 13.2, textAlign: 'center', marginTop: 6.6 }}>突击队认证</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={() => this.props.navigate.navigate('Qualitycom')}
                        style={{ width: '50%' }}>
                        <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                            <Image style={{ width: 45, height: 45 }} source={require('../../../assets/recruit/commando-search.png')}></Image>
                        </View>
                        <Text style={{ color: '#333', fontSize: 13.2, textAlign: 'center', marginTop: 6.6 }}>优质突击队</Text>
                    </TouchableOpacity>
                </View>

                {/* 招突击队 */}
                <View style={styles.recom}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000' }}>招突击队</Text>
                        <Image style={{ width: 8, height: 14, marginLeft: 5 }}
                            source={require('../../../assets/recruit/arrow.png')}></Image>
                    </View>
                    <TouchableOpacity
                        onPress={() => this.props.navigate.navigate('Tjdaddress', {
                            callback: (() => {
                                this.setState({})
                            })
                        })}
                        style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: 'rgb(65, 147, 223)', fontSize: 15 }}>选择城市</Text>
                        <Icon style={{ marginLeft: 3, marginTop: 2 }} name="r-arrow" size={15} color="#4193DF" />
                    </TouchableOpacity>
                </View>

            </View>
        )
    }
}
// item布局
class List extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        const item = this.props.data
        return(
            <TouchableOpacity onPress={() => this.props.navigate.navigate('Jobdetails')} style={styles.information}>
                <View style={styles.head}>
                    <View style={styles.headl}>
                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                            marginRight: 7, backgroundColor: '#4886ed', paddingLeft: 2, paddingRight: 2, paddingTop: 1,
                            paddingBottom: 1, borderRadius: 3
                        }}>
                            <Text style={{ color: '#fff', fontSize: 12 }}>突击队</Text>
                        </View>
                        <Text style={{ fontSize: 16, color: '#000' }}>成都市招木工</Text>
                        <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={require('../../../assets/recruit/jobverified.png')}></Image>
                    </View>
                    <View style={styles.headr}><Text>土建</Text></View>
                </View>
                <View style={styles.main}>
                    <View style={{ height: 41, flexDirection: 'row', alignItems: 'center', height: 35 }}>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>开工时间：</Text>
                            <Text style={{ color: '#EB4E4C', fontSize: 14 }}>2019-03-13</Text>
                        </View>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>工钱：</Text>
                            <Text style={{ color: '#EB4E4C', fontSize: 14 }}>100</Text>
                            <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>元/人/天</Text>
                        </View>
                    </View>
                    <View style={{ height: 41, flexDirection: 'row', alignItems: 'center', height: 35 }}>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>人数：</Text>
                            <Text style={{ color: '#EB4E4C', fontSize: 14 }}>30</Text>
                            <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>人</Text>
                        </View>
                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 14 }}>用工天数：</Text>
                            <Text style={{ color: '#EB4E4C', fontSize: 14 }}>1</Text>
                            <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>天</Text>
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
    container: {
        flex: 1,
        backgroundColor: '#fff'
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
        height: 39,
        backgroundColor: '#ebebeb'
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