#!/usr/bin/env python3
"""
Final bulk translation of remaining (zh) entries
Uses simple line-by-line replacement for robustness
"""

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

# Comprehensive mapping of remaining untranslated keys
remaining_translations = {
    # Payout/Commission related
    "Requested Amount": "请求金额",
    "Approved Amount": "批准金额",
    "Pending Commission": "待定佣金",
    "My Commission": "我的佣金",
    "Payout History": "支付历史",
    "See My Payout History": "查看支付历史",
    "Total Amount": "总金额",
    "Refunded": "已退款",
    "No records found": "未找到记录",
    "Search by Order No.": "按订单号搜索",
    "No compensation history found": "未找到补偿历史",
    "No orders found": "未找到订单",
    "Order Details": "订单详情",
    "No compensation records found": "未找到补偿记录",
    
    # Network/Activity
    "Activities Shared With Me": "与我共享的活动",
    "Total Activities": "总活动",
    "Total Shared": "总共享",
    "Shared Reports": "共享报告",
    "You Don't Have Any Shared Report Yet!": "您还没有共享报告！",
    "Decline": "拒绝",
    "Decline Report": "拒绝报告",
    "Activity": "活动",
    "Last Activity :": "最后活动：",
    
    # Addresses and locations
    "Add New Address": "添加新地址",
    "Billing Address": "账单地址",
    "City": "城市",
    "Edit address": "编辑地址",
    
    # Tickets/Support
    "Create Support Ticket": "创建支持工单",
    "Enter subject": "输入主题",
    "Enter comment": "输入评论",
    "Enter internal notes": "输入内部备注",
    "Invalid username or password.": "用户名或密码无效。",
    
    # Orders/Products
    "Downline Order Details": "下线订单详情",
    "Downline Orders": "下线订单",
    "Flyers": "传单",
    "Default": "默认",
    "Different User": "不同用户",
    
    # Zoom calls
    "Grief Relief Zoom Call": "悲伤救济Zoom通话",
    "Grief Relief Zoom Call Screen": "悲伤救济Zoom通话屏幕",
    "Call": "呼叫",
    
    # Notifications/Announcements
    "All Notifications": "所有通知",
    "Announcement Details": "公告详情",
    "Announcement Notifications": "公告通知",
    "Announcements": "公告",
    "Call Announcement": "呼叫公告",
    "Important updates and reminders": "重要更新和提醒",
    "Messages about promotions and information sent by us": "我们发送的促销和信息消息",
    
    # General UI
    "Access Denied!": "拒绝访问！",
    "Account": "账户",
    "Account Information": "账户信息",
    "Actions": "操作",
    "About": "关于",
    "Back": "返回",
    "Back to Home": "返回首页",
    "BETA VERSION": "测试版本",
    "Cancel": "取消",
    "Change Password": "更改密码",
    "Change Role": "更改角色",
    "Check your network": "检查网络",
    "Choose": "选择",
    "Click to View": "点击查看",
    "Comments": "评论",
    "Add Comment": "添加评论",
    "Confirm Exit": "确认退出",
    "Confirm Logout": "确认注销",
    "Confirm Password": "确认密码",
    "Connection Error:": "连接错误：",
    "Contact Person": "联系人",
    "Contacted": "已联系",
    "Copy Token": "复制令牌",
    "All": "全部",
    "Help": "帮助",
    "FCM Token": "FCM令牌",
    
    # Menu items
    "Menu": "菜单",
    "Dashboard": "仪表板",
    "Home": "首页",
    "Settings": "设置",
    "Notifications": "通知",
    "Privacy Policy": "隐私政策",
    "Terms & Conditions": "条款和条件",
    
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
    
    # Remaining general
    "Lead Details": "线索详情",
    "Loading": "加载中",
    "Name": "名称",
    "Email": "电子邮件",
    "Phone": "电话",
    "Mobile": "移动电话",
    "Zip Code": "邮政编码",
    "Items": "项目",
    "Item": "项目",
    "Audios, Videos & Docs": "音频、视频和文档",
    "Report Details": "报告详情",
    "Link Report": "链接报告",
    "Total Recipients": "总收件人",
}

def main():
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    count = 0
    modified_lines = []
    
    for line in lines:
        modified = False
        for english_key, chinese_value in remaining_translations.items():
            # Check if this line contains a (zh) placeholder for this key
            if f'"{english_key}": "{english_key} (zh)"' in line:
                line = line.replace(
                    f'"{english_key}": "{english_key} (zh)"',
                    f'"{english_key}": "{chinese_value}"'
                )
                modified = True
                count += 1
                print(f'✓ {english_key}')
                break
        
        modified_lines.append(line)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(modified_lines)
    
    print(f'\n✅ Translated {count} entries!')

if __name__ == '__main__':
    main()
