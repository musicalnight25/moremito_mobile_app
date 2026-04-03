#!/usr/bin/env python3
"""
Final comprehensive translation of all 220 remaining (zh) placeholder keys
"""

import re

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

# Comprehensive translation dictionary for all remaining keys
COMPREHENSIVE_TRANSLATIONS = {
    # Financial/Payment terms
    "Date Received": "收到日期",
    "Sent By": "发送者",
    "No payout history found": "未找到支付历史",
    "Requested Commission History": "请求佣金历史",
    "Total Approved Amount": "总批准金额",
    "Transaction Id": "交易ID",
    "Payment Method": "付款方式",
    "Payment Status": "付款状态",
    "Description": "描述",
    "Requested Amount": "请求金额",
    "Approved Amount": "批准金额",
    "Pending Commission": "待定佣金",
    "My Commission": "我的佣金",
    "Payout History": "支付历史",
    "See My Payout History": "查看我的支付历史",
    "Commission Type Summary": "佣金类型摘要",
    "Commission processing date": "佣金处理日期",
    "Commissions Details": "佣金详情",
    "Compensation Spent On Orders": "订单支出补偿",
    "Average Order Amount": "平均订单金额",
    "Avg. Earned / Customer": "平均赚取/客户",
    "Customer Count": "客户数量",
    "Daily Compensation Log": "日补偿日志",
    
    # General UI elements
    "Go": "前往",
    "Back": "返回",
    "Cancel": "取消",
    "Confirm": "确认",
    "OK": "确定",
    "Save": "保存",
    "Edit": "编辑",
    "Delete": "删除",
    "View": "查看",
    "Loading...": "正在加载...",
    "No data": "无数据",
    "No results": "无结果",
    "Try again": "重试",
    "Contact Support": "联系支持",
    "Next": "下一步",
    "Previous": "上一步",
    
    # Account/Profile
    "Account": "账户",
    "Account Information": "账户信息",
    "My Info": "我的信息",
    "Profile": "个人资料",
    "Address": "地址",
    "Add New Address": "添加新地址",
    "Billing Address": "账单地址",
    "Contact Person": "联系人",
    "Country": "国家/地区",
    "Current Password": "当前密码",
    "Change Password": "更改密码",
    "Create new password": "创建新密码",
    "Confirm Password": "确认密码",
    
    # Menu/Navigation
    "Menu": "菜单",
    "Dashboard": "仪表板",
    "Home": "首页",
    "Actions": "操作",
    "About": "关于",
    "Privacy Policy": "隐私政策",
    "Terms & Conditions": "条款和条件",
    "Help": "帮助",
    "Settings": "设置",
    "Notifications": "通知",
    "All Notifications": "所有通知",
    
    # Notifications
    "Announcement Details": "公告详情",
    "Announcement Notifications": "公告通知",
    "Announcements": "公告",
    "Call Announcement": "呼叫公告",
    "Announcement": "公告",
    
    # Activities/Sharing
    "Activities Shared With Me": "与我共享的活动",
    "Total Activities": "总活动",
    "Total Shared": "总共享",
    "Shared Reports": "共享报告",
    "You Don't Have Any Shared Report Yet!": "您还没有任何共享报告！",
    "Activity": "活动",
    
    # Tickets
    "Create Ticket": "创建工单",
    "Ticket": "工单",
    "Call Details": "呼叫详情",
    "Contacted": "已联系",
    "Change Role": "更改角色",
    
    # Content
    "Audios, Videos & Docs": "音频、视频和文档",
    "BETA VERSION": "测试版本",
    "Back to Home": "返回首页",
    "Call": "呼叫",
    "Chat": "聊天",
    "Choose": "选择",
    "Click to View": "点击查看",
    "Comments": "评论",
    "Add Comment": "添加评论",
    "Copy Token": "复制令牌",
    "All": "全部",
    "Access Denied!": "被拒绝访问！",
    
    # Error messages
    "Connection Error:": "连接错误：",
    "Check your network": "检查您的网络",
    "Network Error": "网络错误",
    "Error occurred": "发生错误",
    
    # Search/Filter
    "Search": "搜索",
    "Search By Link And Date": "按链接和日期搜索",
    "Select date range": "选择日期范围",
    "Apply": "应用",
    "Filters": "筛选器",
    "By Date": "按日期",
    "From": "从",
    "To": "到",
    "Today": "今天",
    "Yesterday": "昨天",
    "Last 7 days": "过去7天",
    "Last 30 days": "过去30天",
    "Last 90 days": "过去90天",
    
    # Dialogs
    "Confirm Exit": "确认退出",
    "Confirm Logout": "确认注销",
    "Report Details": "报告详情",
    "Link Report": "链接报告",
    "Total Recipients": "总收件人",
    
    # Additional common terms
    "Name": "名称",
    "Email": "电子邮件",
    "Phone": "电话",
    "Mobile": "移动电话",
    "City": "城市",
    "State": "州",
    "Zip Code": "邮政编码",
    "Items": "项目",
    "Item": "项目",
    "-": "-",
}

def main():
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    count = 0
    not_found = []
    
    for english_key, chinese_value in sorted(COMPREHENSIVE_TRANSLATIONS.items()):
        # Look for pattern: "KEY": "KEY (zh)" - using simple string replacement
        pattern = f'"{english_key}": "{english_key} (zh)"'
        replacement = f'"{english_key}": "{chinese_value}"'
        
        if pattern in content:
            content = content.replace(pattern, replacement, 1)  # Replace only first occurrence
            count += 1
            print(f'✓ {english_key} -> {chinese_value}')
        else:
            not_found.append(english_key)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'\n✅ Replaced {count} translations!')
    if not_found:
        print(f'ℹ️  {len(not_found)} keys not found in file: {not_found[:10]}...')

if __name__ == '__main__':
    main()
