#!/usr/bin/env python3
"""
Fix syntax errors and complete all Chinese translations in app_translations.dart
Handles both single-line and multiline entries, including malformed double quotes
"""

import re

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

# Complete translation mapping
translations = {
    "MoreMito": "MoreMito",
    "Success 🎉": "成功 🎉",
    "Thanks for sharing via \$platform": "感谢通过\$platform分享",
    "Required": "必须",
    "Please fill in all fields": "请填写所有字段",
    "Mismatch": "不匹配",
    "New password and confirm password do not match": "新密码和确认密码不匹配",
    "Weak Password": "密码太弱",
    "Password must be at least 6 characters": "密码必须至少6个字符",
    "Success": "成功",
    "Password updated successfully": "密码更新成功",
    "Error": "错误",
    "Something went wrong. Please try again.": "出现问题。请重试。",
    "Permission Required": "需要权限",
    "Please allow contacts permission": "请允许联系人权限",
    "Login Failed": "登录失败",
    "Please check your credentials.": "请检查您的凭证。",
    "Profile updated successfully": "个人资料更新成功",
    "All notifications marked as read": "所有通知标记为已读",
    "Shop Moremito": "购物MoreMito",
    "Incomplete Survey": "未完成的调查",
    "Please answer all questions before submitting.": "提交前请回答所有问题。",
    "Your survey has been submitted.": "您的调查已提交。",
    "Submission failed, try again.": "提交失败，请重试。",
    "Unable to submit survey. Try again later.": "无法提交调查。请稍后重试。",
    "Ticket created successfully.": "工单创建成功。",
    "Ticket reopened": "工单重新打开",
    "Welcome tag updated successfully": "欢迎标签更新成功",
    "My Address Screen": "我的地址屏幕",
    "My Address": "我的地址",
    "Link copied to clipboard": "链接已复制到剪贴板",
    "LINK URL": "链接网址",
    "COPY": "复制",
    "My Deep Links": "我的深层链接",
    "No Deep Links Generated": "未生成深层链接",
    "My Network Screen": "我的网络屏幕",
    "My Recurring Order Screen": "我的定期订单屏幕",
    "My Recurring Order": "我的定期订单",
    "My Referral Orders Screen": "我的推荐订单屏幕",
    "My Referral Orders": "我的推荐订单",
    "Date": "日期",
    "Order No.": "订单号",
    "Rank": "等级",
    "No rank history found": "未找到等级历史",
    "My Rank History": "我的等级历史",
    "Current Rank": "当前等级",
    "Highest Rank": "最高等级",
    "Penny for your thoughts?": "请分享您的想法？",
    "Close": "关闭",
    "Username is required. Please enter your username.": "用户名是必需的。请输入您的用户名。",
    "Password is required. Please enter your password.": "密码是必需的。请输入您的密码。",
    "Remember me": "记住我",
    "Enter username": "输入用户名",
    "Enter password": "输入密码",
    "Username*": "用户名*",
    "Password*": "密码*",
    "Login": "登录",
    "To continue, please take a moment to complete a brief survey. Your feedback helps us improve your experience!": "要继续，请完成一份短问卷。您的反馈帮助我们改进体验！",
    "Start Survey": "开始调查",
    "Answer Required": "需要答案",
    "Please answer first.": "请先回答。",
    "Select an answer first.": "请先选择答案。",
    "Survey": "调查",
    "MoreMito Library": "MoreMito库",
    "Browse audio, video, and document files.": "浏览音频、视频和文档。",
    "Search Audios, Videos & Docs": "搜索音频、视频和文档",
    "Files": "文件",
    "Categories": "分类",
    "No Contacts Found": "未找到联系人",
    "Search contacts...": "搜索联系人...",
    "Select Contact": "选择联系人",
    "Audio": "音频",
    "Playing audio file.": "正在播放音频。",
    "Please enter recipient name": "请输入收件人名称",
    "Failed to generate link": "生成链接失败",
    "Share": "分享",
    "•  ": "•  ",
    "e.g. John Doe": "例如约翰·多",
    "Write a message for the recipient": "为收件人写一条消息",
    "Enter recipient name": "输入收件人名称",
    "Message": "消息",
    "Select an Option": "选择选项",
    "Choose from Contacts": "从联系人中选择",
    "Enter Name Manually": "手动输入名称",
    "Generate Link To Share": "生成分享链接",
    "Generate a Link": "生成链接",
    "Subcategories": "子类别",
    "No sent history found": "未找到发送历史",
    "MoreMito Cash Transfer History": "MoreMito转账历史",
    "Below is the history of the MoreMito Cash you have transferred.": "下面是您转账的MoreMito历史。",
    "MoreMito Cash Transferred By You": "您转账的MoreMito",
    "Total Sent: ": "发送总额：",
    "MoreMito Cash Sent To Others": "发给他人的MoreMito",
    "Date Transferred": "转账日期",
    "Sent To": "发送给",
    "Amount": "金额",
    "No transfer history found": "未找到转账历史",
    "Below is the history of the MoreMito Cash you have received.": "下面是您收到的MoreMito历史。",
    "Activity Tracking Summary (all links)": "活动跟踪摘要（所有链接）",
    "Add your delivery address to get started": "添加送货地址以开始",
    "Allow Others to Request MoreMito Info from Me": "允许他人向我请求MoreMito信息",
    "Check your internet connection.": "检查您的互联网连接。",
    "Describe your issue (order no., username, etc.)": "描述您的问题(订单号、用户名等)",
    "Enable/Disable app push notifications": "启用或禁用应用通知",
    "Enter a note (max 500 characters)": "输入备注（最多500个字符）",
    "Enter a username and tap Search.": "输入用户名并点击搜索。",
    "Exciting features are on the way! Stay tuned for updates and new enhancements.": "令人兴奋的功能即将推出！敬请关注更新。",
    "Important updates and reminders": "重要更新和提醒",
    "Looks like the share wasn't completed. No worries! You can try again whenever you": "分享似乎未完成。不用担心！您可以随时重试",
    "Manage how you receive alerts and updates": "管理您如何接收警报和更新",
    "Manage users who can see your shared link activity report.": "管理能查看您共享链接报告的用户。",
    "Messages about promotions and information sent by us": "我们发送的关于促销和信息",
    "MoreMito Cash Transferred To You": "转账给您的MoreMito",
    "My Mito Info Shared Links Activity Tracking": "我的Mito信息共享链接跟踪",
    "No activities shared with you yet.": "目前没有与您共享的活动。",
    "Note: Changing your address here does not change your address on already created recurring orders.": "注意：更改地址不会影响已创建的定期订单。",
    "Note: Changing your address here does not update existing recurring orders. Please update those manually in the Orders tab.": "注意：更改地址不会更新现有定期订单。请在订单选项卡中手动更新。",
    "Please grant": "请授予",
    "permission in the settings.": "权限。",
    "Please select Country and State": "请选择国家和州",
    "Reports shared with you by other users.": "其他用户与您共享的报告。",
    "Request Payouts And Make Transfers": "请求支付并进行转账",
    "Review the selected user and optionally add a note before sharing.": "在分享前查看选定的用户，可选择添加备注。",
    "Send/View messages with support team": "与支持团队发送和查看消息",
    "Session expired. Please log in again.": "会话已过期。请重新登录。",
    "These cards show total recipients and total activity": "这些卡片显示总收件人和总活动",
    "This app is currently in Beta, which means some features may be incomplete, under testing, or subject to change. You may experience occasional issues or variations. We appreciate your feedback as we work to improve the app.": "此应用目前处于测试版。某些功能可能不完整或正在测试中。感谢您的反馈。",
    "Total Activities :": "总活动：",
    "Use aliases (my Welcome Tag info) for name, email, and phone number": "使用别名(我的欢迎标签信息)作为名称、电子邮件和电话号码",
    "Username is required. Please enter your username.": "需要用户名。请输入您的用户名。",
    "Users I Have Shared Reports With": "我已共享报告的用户",
    "Your new password must be different from previously used passwords.": "新密码必须与以前使用的密码不同。",
    "MoreMito Cash Received By You": "您收到的MoreMito",
}

def main():
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # First, fix all double-quote syntax errors: ""text"" -> "text"
    content = re.sub(r'": ""([^"]*?)""', r'": "\1"', content)
    
    # Fix multiline (zh) placeholders
    #Pattern: "key": \n  "...  (zh)" -> "key": "chinese"
    count = 0
    for english_key, chinese_value in translations.items():
        # Escape special characters for regex
        escaped_key = re.escape(english_key)
        
        # Pattern 1: single-line with (zh) placeholder
        pattern1 = f'"{escaped_key}": "{escaped_key} \\(zh\\)"'
        replacement = f'"{english_key}": "{chinese_value}"'
        if pattern1 in content:
            content = content.replace(pattern1, replacement)
            count += 1
        
        # Pattern 2: multiline with (zh) placeholder on next line
        # This finds patterns where the value is on the next line
        pattern2 = f'"{escaped_key}":\\s*"([^"]*\\(zh\\))"'
        if re.search(pattern2, content):
            content = re.sub(pattern2, f'"{english_key}": "{chinese_value}"', content)
            count += 1
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'✅ Fixed syntax errors and replaced {count} translations!')

if __name__ == '__main__':
    main()
