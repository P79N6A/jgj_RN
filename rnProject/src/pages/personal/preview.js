/*
 * @Author: stl
 * @Date: 2019-03-19 09:44:51 
 * @Module:名片预览
 * @Last Modified time: 2019-03-19 09:44:51 
 */
import React, { Component } from 'react';
import {
    ActivityIndicator,
    FlatList,
    Image,
    RefreshControl,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    Platform,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'

export default class readme extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
        //状态
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
        }
    }

    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });

    render() {
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>我的找活名片</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} />}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
            </View>
        );
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
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={{
                    color: '#999',
                    fontSize: 15,
                    textAlign: 'center',
                }}>数据为空</Text>
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
        return (
            <View style={{ height: '100%', backgroundColor: '#fff' }}>
                {/* 背景盒子 */}
                <LinearGradient colors={['#2e16b2', '#fff',]} style={styles.bg}>
                    <View style={{
                        marginLeft: 11, marginRight: 11, marginTop: 22, marginBottom: 22,
                        borderRadius: 11, backgroundColor: '#fff', position: 'relative'
                    }}>
                        {/* 收藏 */}
                        <View style={{
                            backgroundColor: 'rgb(229, 229, 229)',
                            width: 88, height: 38, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                            borderBottomLeftRadius: 24.8, borderTopRightRadius: 8.8, position: 'absolute', right: 0, top: 0
                        }}>
                            <Icon name="heart" size={22} color="#999999" />
                            <Text style={{ color: '#999', fontSize: 14.3, fontWeight: '700', marginLeft: 5.5 }}>收藏</Text>
                        </View>
                        {/* 基本信息 */}
                        <View style={{ paddingLeft: 22, paddingRight: 22, paddingBottom: 22, paddingTop: 22, flexDirection: 'row', alignItems: 'center' }}>
                            <View style={{ marginRight: 40 }}>
                                <View style={{
                                    width: 66, height: 66, backgroundColor: 'rgb(223, 94, 94)', borderRadius: 4.5, marginBottom: 6.6,
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                }}>
                                    <Text style={{ fontSize: 19.8, color: '#fff' }}>桃林</Text>
                                </View>
                                <Text style={{ fontSize: 18.7, color: '#000', fontWeight: '700', textAlign: 'center' }}>沈桃林</Text>
                            </View>
                            <View>
                                <Text style={{ fontSize: 18.7, color: '#000', fontWeight: '700', textAlign: 'left', height: 24, marginBottom: 10 }}>男  汉族</Text>
                                <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>未开工正在找工作</Text>
                            </View>
                        </View>
                        {/* 个人情况 */}
                        <View style={{ paddingLeft: 22, paddingRight: 22, paddingBottom: 22 }}>
                            {/* 工龄 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>工        龄：</Text>
                                <Text style={styles.fontr}>23年</Text>
                            </View>
                            {/* 家乡 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>家        乡：</Text>
                                <Text style={styles.fontr}>四川省  成都市</Text>
                            </View>
                            {/* 期望工作地 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>期望工作地：</Text>
                                <Text style={styles.fontr}>山西省  长治市</Text>
                            </View>
                            {/* 所在城市 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>所在城市：</Text>
                                <Text style={styles.fontr}>成都市</Text>
                            </View>

                            {/* 我是班组长 */}
                            <Text style={{ color: "#000", fontSize: 15.4, marginTop: 22, marginBottom: 11 }}>我是班组长:</Text>
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
                            {/* 熟练度 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>队伍人数：</Text>
                                <Text style={styles.fontrs}>5人</Text>
                            </View>

                            {/* 我是工人 */}
                            <Text style={{ color: "#000", fontSize: 15.4, marginTop: 22, marginBottom: 11 }}>我是工人:</Text>
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
                            {/* 熟练度 */}
                            <View style={styles.lanmu}>
                                <Text style={styles.fontl}>熟  练  度：</Text>
                                <Text style={styles.fontrs}>学徒工（小工）</Text>
                            </View>
                        </View>
                    </View>
                </LinearGradient>
                {/* 自我介绍 */}
                <View style={styles.tit}>
                    <View style={styles.a}></View>
                    <View style={styles.b}></View>
                    <Text style={styles.titfont}>自我介绍</Text>
                    <View style={styles.a}></View>
                    <View style={styles.b}></View>
                </View>
                <View style={styles.viewfont}>
                    <Text style={styles.font}>这里是自我介绍内容这里是自我介绍内容这里是自我介绍内容这里是自我介绍内容</Text>
                </View>
                {/* 职业技能 */}
                <View style={styles.tit}>
                    <View style={styles.a}></View>
                    <View style={styles.b}></View>
                    <Text style={styles.titfont}>职业技能</Text>
                    <View style={styles.a}></View>
                    <View style={styles.b}></View>
                </View>
                <View style={styles.viewfont}>
                    <Text style={styles.font}>这里是自我介绍内容这里是自我介绍内容这里是自我介绍内容这里是自我介绍内容</Text>
                </View>
                {/* 项目经验 */}
                <View style={styles.tit}>
                    <View style={styles.a}></View>
                    <View style={styles.b}></View>
                    <Text style={styles.titfont}>项目经验</Text>
                    <View style={styles.a}></View>
                    <View style={styles.b}></View>
                </View>
                {/* 具体项目经验内容 */}
                <View style={{ padding: 26 }}>
                    {/* 项目a */}
                    <View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Image style={{ width: 14, height: 14, marginRight: 14 }} source={require('../../assets/personal/sj.png')}></Image>
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>2019-03</Text>
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>四川省  成都市</Text>
                        </View>
                        <View style={{ borderLeftWidth: 2, borderLeftColor: 'rgb(245,245,245)', marginTop: 7, marginBottom: 7, paddingLeft: 17, marginLeft: 7 }}>
                            <Text style={{ color: '#333', fontSize: 17.6, height: 26, marginTop: 5.5, marginBottom: 5.5, marginLeft: 5 }}>项目名称</Text>
                            <Text style={{ color: '#999', fontSize: 15.4, height: 22, marginBottom: 15.5, marginLeft: 5 }}>介绍项目情况</Text>
                            <View style={{ flexWrap: 'wrap', marginLeft: 5.2, marginTop: 5.2, flexDirection: 'row', marginBottom: 20 }}>
                                <Image style={{ width: 114, height: 114 }} source={require('../../assets/personal/img.jpg')}></Image>
                                {/* <Image style={{width:114,height:114}} source={require('../../assets/personal/img.jpg')}></Image>
                                <Image style={{width:114,height:114}} source={require('../../assets/personal/img.jpg')}></Image>
                                <Image style={{width:114,height:114}} source={require('../../assets/personal/img.jpg')}></Image> */}
                            </View>
                        </View>
                    </View>
                    {/* 项目b */}
                    <View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Image style={{ width: 14, height: 14, marginRight: 14 }} source={require('../../assets/personal/sj.png')}></Image>
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>2019-03</Text>
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>四川省  成都市</Text>
                        </View>
                        <View style={{ borderLeftWidth: 2, borderLeftColor: 'rgb(245,245,245)', marginTop: 7, marginBottom: 7, paddingLeft: 17, marginLeft: 7 }}>
                            <Text style={{ color: '#333', fontSize: 17.6, height: 26, marginTop: 5.5, marginBottom: 5.5, marginLeft: 5 }}>项目名称</Text>
                            <Text style={{ color: '#999', fontSize: 15.4, height: 22, marginBottom: 15.5, marginLeft: 5 }}>介绍项目情况</Text>
                            <View style={{ flexWrap: 'wrap', marginLeft: 5.2, marginTop: 5.2, flexDirection: 'row', marginBottom: 20 }}>
                                <Image style={{ width: 114, height: 114 }} source={require('../../assets/personal/img.jpg')}></Image>
                                <Image style={{ width: 114, height: 114 }} source={require('../../assets/personal/img.jpg')}></Image>
                                <Image style={{ width: 114, height: 114 }} source={require('../../assets/personal/img.jpg')}></Image>
                                <Image style={{ width: 114, height: 114 }} source={require('../../assets/personal/img.jpg')}></Image>
                            </View>
                        </View>
                    </View>
                    {/* 没有更多了 */}
                    <View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <View style={{ width: 14, height: 14, marginRight: 14, backgroundColor: 'rgb(245,245,245)', borderRadius: 14 }}></View>
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>没有更多了</Text>
                        </View>
                    </View>
                </View>

                {/* 公告 */}
                <View style={{ paddingTop: 11, paddingBottom: 11, backgroundColor: '#ebebeb' }}>
                    <View style={{ padding: 11, backgroundColor: "#fdf1e0", flexDirection: 'row', alignItems: "flex-start" }}>
                        <View style={{
                            width: 30, height: 19, backgroundColor: "rgb(255, 104, 3)", borderRadius: 2.2,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginRight: 5.5, marginTop: 3
                        }}><Text style={{
                            color: '#fff',
                            fontSize: 13
                        }}>公告</Text></View>
                        <View >
                            <View style={{ flexDirection: "row", alignItems: "center", marginBottom: 5 }}>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>加客服微信号</Text>
                                <Text style={{ color: '#4193df', fontSize: 15.4 }}>g9188008</Text>
                                <View style={{
                                    borderWidth: 0.5, borderColor: '#999', borderRadius: 2.2,
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                    paddingLeft: 4, paddingRight: 4, marginLeft: 3
                                }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>点击复制</Text>
                                </View>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>，拉你进工友群</Text>
                            </View>
                            <View style={{ flexDirection: "row", alignItems: "center" }}>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>关注“吉工家”微信公众号接收新工作提醒 </Text>
                                <Text style={{ color: '#4193df', fontSize: 15.4 }}>如何关注</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    bg: {
        backgroundColor: 'rgb(85,65,190)'
    },
    lanmu: {
        marginTop: 4.5,
        marginBottom: 4.5,
        flexDirection: 'row',
        alignItems: 'flex-start',

    },
    fontl: {
        color: "#999",
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
    tit: {
        marginLeft: 22,
        marginRight: 22,
        marginTop: 11,
        marginBottom: 4.5,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titfont: {
        color: '#000',
        fontSize: 18.7,
        fontWeight: '700',
        marginLeft: 11,
        marginRight: 11,
    },
    a: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#fa6ba2',
        transform: [{ rotate: '15deg' }]
    },
    b: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#efbb59',
        transform: [{ rotate: '15deg' }]
    },
    viewfont: {
        paddingLeft: 22,
        paddingRight: 22,
        paddingTop: 11,
        paddingBottom: 11,
        flexDirection: 'row',
        justifyContent: "center",
        flexWrap: 'wrap',
    },
    font: {
        color: '#000',
        fontSize: 15.4,
    },
});