#!/usr/bin/env python3
"""
Expand translate_placeholders.py with comprehensive translation dictionary
"""

import re
from typing import Dict

# Read the current dictionary to see what's needed
filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Extract untranslated keys
pattern = r'"([^"]*)":\s*"([^"]*\s*\(zh\))"'
matches = re.findall(pattern, content)

unique_keys = {}
for english_key, placeholder in matches:
    if english_key not in unique_keys:
        unique_keys[english_key] = placeholder

# Manual Chinese translations for all remaining keys
translations = {
    "Activity Tracking Summary (all links)": "活动跟踪摘要（所有链接）",
    "Add your delivery address to get started": "添加您的送货地址以开始",
    "Allow Others to Request MoreMito Info from Me": "允许他人向我请求MoreMito信息",
    "Below is the history of the MoreMito Cash you have received.": "以下是您已收到的MoreMito现金历史记录。",
    "Below is the history of the MoreMito Cash you have transferred.": "以下是您已转账的MoreMito现金历史记录。",
    "Browse audio, video, and document files.": "浏览音频、视频和文档文件。",
    "Check your internet connection.": "检查您的互联网连接。",
    "Describe your issue (order no., username, etc.)": "描述您的问题（订单号、用户名等）",
    "Enable/Disable app push notifications": "启用/禁用应用推送通知",
    "Enter a note (max 500 characters)": "输入备注（最多500个字符）",
    "Enter a username and tap Search.": "输入用户名并点击搜索。",
    "Exciting features are on the way! Stay tuned for updates and new enhancements.": "令人兴奋的功能即将推出！敬请关注更新和新增强。",
    "Important updates and reminders": "重要更新和提醒",
    "Looks like the share wasn't completed. No worries! You can try again whenever you": "看起来分享未完成。不用担心！您可以随时重试",
    "Manage how you receive alerts and updates": "管理您如何接收警报和更新",
    "Manage users who can see your shared link activity report.": "管理可以查看您共享链接活动报告的用户。",
    "Messages about promotions and information sent by us": "我们发送的关于促销和信息的消息",
    "MoreMito Cash Transfer History": "MoreMito现金转账历史",
    "MoreMito Cash Transferred By You": "您转账的MoreMito现金",
    "MoreMito Cash Transferred To You": "转账给您的MoreMito现金",
    "My Mito Info Shared Links Activity Tracking": "我的Mito信息共享链接活动跟踪",
    "New password and confirm password do not match": "新密码和确认密码不匹配",
    "No activities shared with you yet.": "目前还没有与您共享活动。",
    "Note: Changing your address here does not change your address on already created recurring orders.": "注意：在此更改您的地址不会更改已创建的定期订单地址。",
    "Note: Changing your address here does not update existing recurring orders. Please update those manually in the Orders tab.": "注意：在此更改您的地址不会更新现有的定期订单。请在订单选项卡中手动更新。",
    "Order #${data.myOrders.orderId}": "订单 #${data.myOrders.orderId}",
    "Order Number - ${_value(info?.customOrderNumber)}": "订单号 - ${_value(info?.customOrderNumber)}",
    "Order Number : ${order.orderId}": "订单号：${order.orderId}",
    "Password is required. Please enter your password.": "需要密码。请输入您的密码。",
    "Password must be at least 6 characters": "密码必须至少6个字符",
    "Please allow contacts permission": "请允许联系人权限",
    "Please answer all questions before submitting.": "提交前请回答所有问题。",
    "Please check your credentials.": "请检查您的凭证。",
    "Please check your keyword or try again your browsing keyword": "请检查您的关键字或重试您的浏览关键字",
    "Please grant $permission permission in the settings.": "请在设置中授予$permission权限。",
    "Please select Country and State": "请选择国家和州",
    "Reports shared with you by other users.": "其他用户与您共享的报告。",
    "Request Payouts And Make Transfers": "请求支付和进行转账",
    "Review the selected user and optionally add a note before sharing.": "在分享前查看选定的用户，并可选择添加备注。",
    "Send/View messages with support team": "与支持团队发送/查看消息",
    "Session expired. Please log in again.": "会话已过期。请重新登录。",
    "Something went wrong. Please try again.": "出现问题。请重试。",
    "Thanks for sharing via $platform": "感谢通过$platform分享",
    "These cards show total recipients and total activity": "这些卡片显示总收件人和总活动",
    "This app is currently in Beta, which means some features may be incomplete, under testing, or subject to change. You may experience occasional issues or variations. We appreciate your feedback as we work to improve the app.": "此应用目前处于测试版，这意味着某些功能可能不完整、正在测试或可能会改变。您可能会遇到偶然的问题或变化。我们感谢您的反馈，因为我们努力改进应用。",
    "To continue, please take a moment to complete a brief survey. Your feedback helps us improve your experience!": "要继续，请花费片刻完成一份短问卷。您的反馈帮助我们改进您的体验！",
    "Total Activities : ${item.totalInteractions ?? 0}": "总活动：${item.totalInteractions ?? 0}",
    "Unable to submit survey. Try again later.": "无法提交调查。请稍后重试。",
    "Use aliases (my Welcome Tag info) for name, email, and phone number": "使用别名（我的欢迎标签信息）作为姓名、电子邮件和电话号码",
    "Username is required. Please enter your username.": "需要用户名。请输入您的用户名。",
    "Users I Have Shared Reports With": "我已共享报告的用户",
    "Welcome tag updated successfully": "欢迎标签更新成功",
    "Write a message for the recipient": "为收件人写一条消息",
    "Your new password must be different from previously used passwords.": "您的新密码必须与以前使用的密码不同。",
    "Your survey has been submitted.": "您的调查已提交。",
    "${address.address1}, ${address.city}, ${address.stateName}, ${address.countryName} - ${address.zip}": "${address.address1}, ${address.city}, ${address.stateName}, ${address.countryName} - ${address.zip}",
    "${address.firstName} ${address.lastName}": "${address.firstName} ${address.lastName}",
    "${user.name} (${user.userName})": "${user.name} (${user.userName})",
}

print(f"Total translations available: {len(translations)}")
for key in sorted(translations.keys()):
    print(f'✓ {key}')
