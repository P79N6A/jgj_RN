/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-21 15:38:34 
 * @Module:我的招工
 * @Last Modified time: 2019-03-21 15:38:34 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    StatusBar,
    Platform,
    FlatList,
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../../component/listitem'
import Empty from '../../../component/listempty'
import Footer from '../../../component/listfooter'

export default class myjob extends Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.state = {
            // 列表数据结构
            dataSource: [
                { key: 0 }
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            navigate:''
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        this.setState({
            navigate: this.props.navigation//页面跳转需要
        })
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
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>我的招工</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.state.navigate} />}//头布局
                    renderItem={({item}) => <List data={item} navigate={this.state.navigate}/>}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.state.navigate} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
                {/* 底部按钮 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Releasement')}
                    style={{ backgroundColor: '#fafafa', height: 66, padding: 11, position: 'absolute', bottom: 0, width: '100%', height: 66 }}>
                    <View style={{ backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 4.4, height: 44 }}>
                        <Text style={{ color: '#fff', fontSize: 18.7 }}>发布招工</Text>
                    </View>
                </TouchableOpacity>
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
// 头部布局
class Header extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View style={{ backgroundColor: '#fdf1e0', padding: 6.6 }}>
                <Text style={{ color: '#f18215', fontSize: 13.2, marginLeft: 70 }}>1、经常刷新招工信息能够让你的招工信息更靠前</Text>
                <Text style={{ color: '#f18215', fontSize: 13.2, marginLeft: 70 }}>2、若工人已招满，请及时停止招工</Text>
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
            <TouchableOpacity
            onPress={()=>this.props.navigate.navigate('Fbjobdetails')}
            style={{ backgroundColor: '#fff', paddingLeft: 11, paddingRight: 11, marginBottom: 11 }}>
                <View style={{ paddingTop: 6.6, paddingBottom: 6.6, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <View style={{
                            marginRight: 7, backgroundColor: '#eb7a4e', paddingLeft: 2, paddingRight: 2,
                            paddingTop: 2, paddingBottom: 1, borderRadius: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#fff', fontSize: 12 }}>点工</Text>
                        </View>
                        <Text style={{ color: '#000', fontSize: 17.6 }}>广元市招泥水工</Text>
                    </View>
                    <View style={{
                        backgroundColor: '#eee', paddingLeft: 5.5, paddingRight: 5.5,
                        paddingTop: 2.2, paddingBottom: 2.2, borderRadius: 2.2
                    }}>
                        <Text style={{ color: '#666', fontSize: 13.2 }}>智能及弱电</Text>
                    </View>
                </View>

                <View style={{
                    borderBottomWidth: 1, borderBottomColor: "#ebebeb",
                    borderTopWidth: 1, borderTopColor: '#ebebeb', flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                    paddingTop: 11, paddingBottom: 11
                }}>
                    <View style={{ flex: 1 }}>
                        <View style={{ flexDirection: 'row', flexWarp: 'warp' }}>
                            <View style={{ width: '50%' }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>人数：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>12</Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.2 }}>人</Text>
                                </View>
                            </View>
                            <View style={{ width: '50%' }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>工资：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>12</Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.2 }}>元/天</Text>
                                </View>
                            </View>
                        </View>
                        <Text style={{ color: '#999', fontSize: 15.4, marginTop: 11 }}>内容</Text>
                    </View>
                    <View>
                        <Icon name="r-arrow" size={12} color="#000" />
                    </View>
                </View>

                <View style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                    paddingTop: 5.2, paddingBottom: 5.2
                }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <View style={{ paddingRight: 11, marginRight: 11, borderRightWidth: 1, borderRightColor: "#ebebeb" }}>
                            <Text style={{ color: '#666', fontSize: 13.2 }}>停止招工</Text>
                        </View>
                        <View style={{ paddingRight: 11, marginRight: 11, borderRightWidth: 1, borderRightColor: "#ebebeb" }}>
                            <Text style={{ color: '#666', fontSize: 13.2 }}>刷新</Text>
                        </View>
                        <View style={{ paddingRight: 11, marginRight: 11, borderRightWidth: 1, borderRightColor: "#ebebeb" }}>
                            <Text style={{ color: '#666', fontSize: 13.2 }}>修改</Text>
                        </View>
                        <View style={{ paddingRight: 11, marginRight: 11, borderRightWidth: 1, borderRightColor: "#ebebeb" }}>
                            <Text style={{ color: '#666', fontSize: 13.2 }}>删除</Text>
                        </View>
                    </View>
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Recomtact')}
                        style={{
                            paddingLeft: 11, paddingRight: 11, paddingTop: 3, paddingBottom: 3,
                            borderWidth: 1, borderColor: '#666', borderRadius: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                        <Text style={{ color: '#000', fontSize: 15.4 }}>合适的工人</Text>
                    </TouchableOpacity>
                </View>
            </TouchableOpacity>
        )
    }
}
const styles = StyleSheet.create({
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
})