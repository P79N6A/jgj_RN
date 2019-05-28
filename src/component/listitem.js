/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 10:38:31 
 * @Module：列表组件
 * @Last Modified time: 2019-03-29 10:38:31 
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
    
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class App extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
        this.pagesize = 10
        //状态
        this.state = {
            // 下拉刷新
            isRefresh: false,
        }
    }
        
    render() {
        return (
			<View
				style={{
					...styles.container,
					// paddingBottom:this.props.hasBtn?60:0//#20280
				}}
			>

                <FlatList
                    ref={this.props._getRef}
                    style={styles.container}
                    data={this.props.data}
                    //item显示的布局
                    renderItem={this.props.renderItem}
                    // renderItem={({ item }) => this.props.renderItem(item)}
                    // 空布局
                    ListEmptyComponent={this.props.ListEmptyComponent}
                    //添加头尾布局
                    ListHeaderComponent={this.props.ListHeaderComponent}
                    ListFooterComponent={this.props.ListFooterComponent}
                    onContentSizeChange={this.props.onContentSizeChange()}
                    //下拉刷新相关
                    refreshControl={
                        <RefreshControl
                            title={'正在加载'}
                            colors={['red']}
                            refreshing={this.state.isRefresh}
                            onRefresh={() => {
                                this.props.onRefresh();
                            }}
                        />
                    }
                    refreshing={this.state.isRefresh}
                    //加载更多
                    onEndReached={() => this.props.onEndReached()}
                    onEndReachedThreshold={0.1}//触底距离调用加载
                    keyExtractor={this._extraUniqueKey}//key值
                    onScrollEndDrag={this.props.onScrollEndDrag?this.props.onScrollEndDrag():this.function()}//一个子view滚动结束拖拽时触发
                    onScroll={this.props._onScroll}
                    scrollEventThrottle={100}
                />
            </View>
        );
    }

    //key值
    _extraUniqueKey(item, index) {
        return "index" + index;
    }
    // 空函数
    function(){}
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
});