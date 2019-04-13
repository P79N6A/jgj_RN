import React, { Component } from 'react';
import {
    ActivityIndicator,
    FlatList,
    Image,
    RefreshControl,
    StyleSheet,
    Text,
    TouchableOpacity,
    View
} from 'react-native';

export default class App extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
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
        }
    }
    render() {
        return (
            <View style={styles.container}>
                <FlatList
                    style={styles.container}
                    data={this.state.dataSource}
                    //item显示的布局
                    renderItem={({ item }) => this._createListItem(item)}
                    // 空布局
                    ListEmptyComponent={this._createEmptyView}
                    //添加头尾布局
                    // ListHeaderComponent={this._createListHeader}
                    // ListFooterComponent={this._createListFooter.bind(this)}
                    //下拉刷新相关
                    //onRefresh={() => this._onRefresh()}
                    refreshControl={
                        <RefreshControl
                            title={'Loading'}
                            colors={['red']}
                            refreshing={this.state.isRefresh}
                            onRefresh={() => {
                                this._onRefresh();
                            }}
                        />
                    }
                    refreshing={this.state.isRefresh}
                    //加载更多
                    onEndReached={() => this._onLoadMore()}
                    onEndReachedThreshold={0.1}//触底距离调用加载
                    // ItemSeparatorComponent={this._separator}
                    keyExtractor={this._extraUniqueKey}
                />
            </View>
        );
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
    _extraUniqueKey(item, index) {
        return "index" + index + item;
    }
    // 分割线
    _separator() {
        return <View style={{ height: 1, backgroundColor: '#999999' }} />;
    }
    // 创建头部布局
    _createListHeader() {
        return (
            <View style={styles.headView}>
                <Text style={{ color: 'white' }}>
                    头部布局
                </Text>
            </View>
        )
    }
    // 创建尾部布局
    _createListFooter = () => {
        return (
            <View style={styles.footerView}>
                {this.state.showFoot === 1 && <ActivityIndicator />}
                <Text style={{ color: 'red' }}>
                    {this.state.showFoot === 1 ? '正在加载更多数据...' : '没有更多数据了'}
                </Text>
            </View>
        )
    }
    // 创建布局
    _createListItem(item) {
        return (
            <TouchableOpacity activeOpacity={0.5} onPress={() => this._onItemClick(item)}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    // justifyContent: 'center',
                    marginTop: 5,
                    backgroundColor: '#fff',
                    padding: 10
                }}>
                    <Image source={{ uri: item.logo_url }} style={styles.itemImages} />
                    <Text style={{ marginLeft: 6 }}>
                        {item.baike_name}
                    </Text>
                </View>
            </TouchableOpacity>
        );
    }
    // 空布局
    _createEmptyView() {
        return (
            <View style={{ height: '100%', }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={styles.font}>还没有人看过你的名片呢</Text>
                <Text style={styles.font}>每天刷新并分享名片可让更多的人看到</Text>
                <Text style={styles.font}>找活也更快</Text>
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
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            this._getHotList()
        }
    }
    // item点击事件
    _onItemClick(item) {
        alert('点击list数据')
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f5f5f5',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
});