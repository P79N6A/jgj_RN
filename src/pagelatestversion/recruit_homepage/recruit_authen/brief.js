import React, { useState,useEffect } from 'react'
import { View, Text } from 'react-native'

import fetchFun from '../../../fetch/fetch'

export default function({ detail, manage }){
	const [ brief, setBrief ] = useState(null)
	
	useEffect(()=>{
		const getBrief = () => {
			fetchFun.load({
				url: manage ? 'v2/company/getcompanyprojectinfo' : 'v2/Workinfo/brief',
				data: {
					kind:'recruit'
				},
				success: (res) => {
					if (manage) {
						res.recruitment_times = res.project_numbers;
						res.recruitment_view_times = res.review_numbers;
						res.contact_me_count = res.contact_numbers;
					}
					console.log('brief',res)
					setBrief(res)
				}
			})
		}
		getBrief()
	},[])

	return (
		<>
			<View
				style={{
					paddingTop:8,
					paddingRight:10,
					paddingBottom:8,
					paddingLeft:10,
					backgroundColor:'#ebebeb',
					flex:1,
					flexDirection:'row',
					alignItems: 'center',
					flexBasis:40,
					flexGrow:0
				}}
			>
				<Text>服务详情</Text>
			</View>
			<Text style={{fontSize:14,paddingLeft:10,paddingRight:10,marginTop:14,marginBottom:14}}>
                认证有效期至 {detail.auth_expire_time_format}
                {detail.time_left_day<1 ? '' : '还剩'}
                （<Text style={{color:'#eb4e4e'}}>{detail.time_left_day<1 ? '已过期' : detail.time_left_day}</Text>{detail.time_left_day<1 ? '' : '天'}）
            </Text>
			{brief ?
				<View
					style={{
						paddingLeft:10,
						paddingRight:10,
						color:'#999',
						fontSize:12,
						marginTop:4,
						flex:1,
						flexDirection:'row',
						flexBasis:32,
						flexGrow:0
					}}
				>
            	    <Text style={{width:'50%'}}>
						已发布招工信息：
						<Text style={{width:'50%'}}>{brief.recruitment_times}</Text> 条
					</Text>
            	    <Text style={{width:'50%'}}>
						招工浏览量：<Text style={{color:'#eb4e4e'}}>{brief.recruitment_view_times}</Text>
					</Text>
				</View>:null 
			}
			{brief ?
				<View
					style={{
						paddingLeft:10,
						paddingRight:10,
						paddingBottom:10,
						color:'#999',
						fontSize:12,
						marginTop:4,
						flex:1,
						flexDirection:'row',
						flexBasis:32,
						flexGrow:0
					}}
				>
            	    <Text style={{width:'50%'}}>
						主动与您联系：<Text style={{color:'#eb4e4e'}}>{brief.contact_me_count}</Text> 人
            	    </Text>
            	    <Text style={{width:'50%'}}>
						名片浏览量：<Text style={{color:'#eb4e4e'}}>{brief.look_me_times}</Text>
					</Text>
            	</View>:null
			}
			{/*brief
				? 
				<>
					<View
						style={{
							paddingLeft:10,
							paddingRight:10,
							color:'#999',
							fontSize:12,
							marginTop:4,
							flex:1
						}}
					>
                	    <Text style={{width:'50%'}}>
							已发布招工信息：
							<Text style={{width:'50%'}}>{brief.recruitment_times}</Text> 条
						</Text>
                	    <Text style={{width:'50%'}}>
							招工浏览量：<Text style={{color:'#eb4e4e'}}>{brief.recruitment_view_times}</Text>
						</Text>
					</View>
					<View
						style={{
							paddingLeft:10,
							paddingRight:10,
							color:'#999',
							fontSize:12,
							marginTop:4,
							flex:1
						}}
					>
                	    <Text style={{width:'50%'}}>
							主动与您联系:<Text style={{color:'#eb4e4e'}}>{brief.contact_me_count}</Text> 人
                	    </Text>
                	    <Text style={{width:'50%'}}>
							名片浏览量：<Text style={{color:'#eb4e4e'}}>{brief.look_me_times}</Text>
						</Text>
                	</View>
				</>
                : <Text style={{color:'#999',fontSize:12,marginTop:4}}>工作数据获取中...</Text>
					*/}
		</>
	)
}