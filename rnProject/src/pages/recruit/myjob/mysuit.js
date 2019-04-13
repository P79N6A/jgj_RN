/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-22 14:06:54 
 * @Module:发布招工-可能合适你的人
 * @Last Modified time: 2019-03-22 14:06:54 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
    Platform,
    TextInput,
    ScrollView,
    FlatList,
    RefreshControl,
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../../component/listitem'
import Footer from '../../../component/listfooter'

export default class musuit extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [
                { key: 0, name: '余明' },
                { key: 1, name: '王银' },
                { key: 2, name: '陈夫' },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>可能合适你的人</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigation={this.props.navigation} />}//头布局
                    renderItem={({item}) => <List data={item} navigation={this.props.navigation}/>}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
            </View>
        )
    }
    // 获取数据事件
    _getHotList() {
        this.state.isLoadMore = true
        fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
            .then((response) => response.json())
            .then((responseJson) => {
                console.log(responseJson)
                if (this.page === 1) {
                    console.log("重新加载")
                    this.setState({
                        isLoadMore: false,
                        dataSource: responseJson.list
                    })
                } else {
                    console.log("加载更多")
                    this.setState({
                        isLoadMore: false,
                        // 数据源刷新 add
                        dataSource: this.state.dataSource.concat(responseJson.list)
                    })
                    if (this.page <= 3) {
                        this.setState({
                            showFoot: 1
                        })
                    } else if (this.page > 3) {
                        this.setState({
                            showFoot: 2
                        })
                    }
                }


            })
            .catch((error) => {
                console.error(error);
            });
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            // this._getHotList()
        }
    };
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            // this._getHotList()
        }
    }

}
// 空布局
class Empty extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View style={{ height: '100%', }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={{ textAlign: 'center' }}>没有其他匹配的数据</Text>
            </View>
        )
    }
}
// 头布局
class Header extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View>
                <View style={{
                    backgroundColor: '#fdf1e0', height: 50,
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginBottom: 10
                }}>
                    <Text style={{ color: '#f18215', fontSize: 13.2 }}>
                        如何防范骗子？
                    </Text>
                </View>
                <TouchableOpacity onPress={() => this.props.navigation.navigate('Fbjobdetails')} style={styles.information}>
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
                        <View style={{ marginBottom: 6.5, marginTop: 6.5, flexDirection: 'row' }}>
                            <Text style={{ fontSize: 14, color: '#000', marginTop: 3.2 }}>待遇：</Text>
                            <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                    <Text style={{ fontSize: 12, color: '#333' }}>包吃不包住</Text>
                                </View>
                            </View>
                        </View>
                    </View>
                </TouchableOpacity>
                <Text style={{ color: '#999', fontSize: 13.2, textAlign: 'center', marginBottom: 11 }}>以下是根据你所天条件匹配的帮手</Text>
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
            <TouchableOpacity activeOpacity={0.5} onPress={() => this.props.navigation.navigate('Preview')}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{
                                backgroundColor: 'rgb(114, 102, 202)', flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                borderRadius: 4.4, width: 49, height: 49, marginRight: 20
                            }}>
                                <Text style={{ color: '#fff', fontSize: 17.6 }}>{item.name}</Text>
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.name}</Text>
                                        <Image style={{ height: 20, width: 25, marginLeft: 10 }} source={require('../../../assets/recruit/sm.png')}></Image>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                    <Icon name="place" size={15} color="#BFBFBF" />
                                        <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>广元</Text>
                                    </View>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>汉族  中级工（中工）</Text>
                                    <Icon style={{marginRight: 5}} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>
                        <View style={{ flexDirection: 'row', flexWarp: 'warp', marginTop: 3 }}>
                            <View style={{
                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee', paddingLeft: 4.4, paddingRight: 4.4,
                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                            }}>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>机械操作</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}
const styles = StyleSheet.create({
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
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
})