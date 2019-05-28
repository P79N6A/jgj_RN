import React from 'react'
import PropTypes from 'prop-types'
import { Modal, TouchableOpacity, View, Text } from 'react-native'

export default class extends React.Component{
	static propTypes = {
		visible: PropTypes.bool,
		cancelFn: PropTypes.func,
		sureFn: PropTypes.func
	}
	static defaultProps = {
		visible:false,
		cancelFn:()=>{},
		sureFn:()=>{}
	}

	onRequest = () => {
		cancelFn()
	}

	render(){
		let { visible, cancelFn, sureFn } = this.props
		
		return (
			<Modal
        	    visible={visible}
        	    animationType="none"
        	    transparent={true}
        	    onRequestClose={this.onRequest}
        	    style={{ height: '100%' }}
        	>
				<InfoTips
					content={'进行下一步操作之前，需要请你完善个人资料'}
					cancelFn={cancelFn}
					sureFn={sureFn}
				/>
        	</Modal>
		)
	}
}

function InfoTips({ content, cancelFn, sureFn }){
	return (
		<TouchableOpacity activeOpacity={.7}
            onPress={() => cancelFn()}
            style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}
        >
            <View style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                <View style={{ padding: 16.5 }}>
                    <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                        { content }
					</Text>
                </View>
                <View
                    style={{
                        flexDirection: 'row', alignItems: 'center',
                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                    }}
                >
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => sureFn()}
                        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}
                    >
                        <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>去完善资料</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </TouchableOpacity>
	)
}