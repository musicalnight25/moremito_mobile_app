#!/usr/bin/env python3
"""
Comprehensive translation of all (zh) placeholders in app_translations.dart
Uses a complete English-to-Chinese mapping
"""

import re

# Complete translation dictionary
TRANSLATIONS = {
    "Activity Tracking Summary (all links)": "活动跟踪摘要（所有链接）",
    "Add your delivery address to get started": "添加您的送货地址以开始",
    "Allow Others to Request MoreMito Info from Me": "允许他人向我请求MoreMito信息",
    "Below is the history of the MoreMito Cash you have received.": "以下是您已收到的MoreMito现金历史记录。",
    "Below is the history of the MoreMito Cash you have transferred.": "以下是您已转账的MoreMito现金历史记录。",
    "Browse audio, video, and document files.": "浏览音频、视频和文档文件。",
    "Check your internet connection.": "检查您的互联网连接。",
    "Describe your issue (order no., username, etc.)": "描述您的问题（订单号、用户名等）",
    "Enable/Disable app push notifications": "启用或禁用应用推送通知",
    "Enter a note (max 500 characters)": "输入备注（最多500个字符）",
    "Enter a username and tap Search.": "输入用户名并点击搜索。",
    "Exciting features are on the way! Stay tuned for updates and new enhancements.": "令人兴奋的功能即将推出！敬请关注更新和新增强功能。",
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
    "Password is required. Please enter your password.": "需要密码。请输入您的密码。",
    "Password must be at least 6 characters": "密码必须至少6个字符",
    "Please allow contacts permission": "请允许联系人权限",
    "Please answer all questions before submitting.": "提交前请回答所有问题。",
    "Please check your credentials.": "请检查您的凭证。",
    "Please check your keyword or try again your browsing keyword": "请检查您的关键字或重试您的浏览关键字",
    "Please grant": "请在设置中授予",
    "permission in the settings.": "权限。",
    "Please select Country and State": "请选择国家和州",
    "Reports shared with you by other users.": "其他用户与您共享的报告。",
    "Request Payouts And Make Transfers": "请求支付和进行转账",
    "Review the selected user and optionally add a note before sharing.": "在分享前查看选定的用户，并可选择添加备注。",
    "Send/View messages with support team": "与支持团队发送和查看消息",
    "Session expired. Please log in again.": "会话已过期。请重新登录。",
    "Something went wrong. Please try again.": "出现问题。请重试。",
    "Thanks for sharing via": "感谢通过分享",
    "These cards show total recipients and total activity": "这些卡片显示总收件人和总活动",
    "This app is currently in Beta, which means some features may be incomplete, under testing, or subject to change. You may experience occasional issues or variations. We appreciate your feedback as we work to improve the app.": "此应用目前处于测试版。某些功能可能不完整、正在测试或可能会改变。您可能会遇到偶然的问题或变化。感谢您的反馈，帮助我们改进应用。",
    "To continue, please take a moment to complete a brief survey. Your feedback helps us improve your experience!": "要继续，请花费片刻完成一份短问卷。您的反馈帮助我们改进您的体验！",
    "Total Activities :": "总活动：",
    "Unable to submit survey. Try again later.": "无法提交调查。请稍后重试。",
    "Use aliases (my Welcome Tag info) for name, email, and phone number": "使用别名（我的欢迎标签信息）作为姓名、电子邮件和电话号码",
    "Username is required. Please enter your username.": "需要用户名。请输入您的用户名。",
    "Users I Have Shared Reports With": "我已共享报告的用户",
    "Welcome tag updated successfully": "欢迎标签更新成功",
    "Write a message for the recipient": "为收件人写一条消息",
    "Your new password must be different from previously used passwords.": "您的新密码必须与以前使用的密码不同。",
    "Your survey has been submitted.": "您的调查已提交。",
    "MoreMito": "MoreMito",
    "Success 🎉": "成功 🎉",
    "Required": "必须",
    "Please fill in all fields": "请填写所有字段",
    "Mismatch": "不匹配",
    "Weak Password": "密码太弱",
    "Success": "成功",
    "Password updated successfully": "密码更新成功",
    "Error": "错误",
    "Permission Required": "需要权限",
    "Login Failed": "登録失败",
    "Profile updated successfully": "个人资料更新成功",
    "All notifications marked as read": "所有通知标记为已读",
    "Shop Moremito": "购物MoreMito",
    "Incomplete Survey": "未完成的调查",
    "Submission failed, try again.": "提交失败，请重试。",
    "Ticket created successfully.": "工单创建成功。",
    "Ticket reopened": "工单重新打开",
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
    "Username is required. Please enter your username.": "需要用户名。请输入您的用户名。",
    "Remember me": "记住我",
    "Enter username": "输入用户名",
    "Enter password": "输入密码",
    "Username*": "用户名*",
    "Password*": "密码*",
    "Login": "登录",
    "Start Survey": "开始调查",
    "Answer Required": "需要答案",
    "Please answer first.": "请先回答。",
    "Select an answer first.": "请先选择答案。",
    "Survey": "调查",
    "MoreMito Library": "MoreMito库",
    "Search Audios, Videos & Docs": "搜索音频、视频和文档",
    "Files": "文件",
    "Categories": "分类",
    "No Contacts Found": "未找到联系人",
    "Search contacts...": "搜索联系人...",
    "Select Contact": "选择联系人",
    "Audio": "音频",
    "Playing audio file.": "正在播放音频文件。",
    "Please enter recipient name": "请输入收件人姓名",
    "Failed to generate link": "生成链接失败",
    "Share": "分享",
    "•  ": "•  ",
    "e.g. John Doe": "例如约翰·多",
    "Enter recipient name": "输入收件人姓名",
    "Message": "消息",
    "Select an Option": "选择选项",
    "Choose from Contacts": "从联系人中选择",
    "Enter Name Manually": "手动输入名称",
    "Generate Link To Share": "生成分享链接",
    "Generate a Link": "生成链接",
    "Subcategories": "子类别",
    "No sent history found": "未找到发送历史记录",
    "Date Transferred": "转账日期",
    "Sent To": "发送给",
    "Amount": "金额",
    "No transfer history found": "未找到转账历史记录",
    "MoreMito Cash Received By You": "您收到的MoreMito现金",
    "Total Received: ": "收到总额: ",
}

def main():
    filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    count = 0
    # For each translation, replace the placeholder
    for english, chinese in TRANSLATIONS.items():
        # Create the pattern to find: "english": "english (zh)"
        # Then replace with: "english": "chinese"
        pattern = f'"{english}": "{english} \\(zh\\)"'
        replacement = f'"{english}": "{chinese}"'
        
        if pattern in content or f'"{english}": "{english} (zh)"' in content:
            # Try exact match first
            old = f'"{english}": "{english} (zh)"'
            new = f'"{english}": "{chinese}"'
            if old in content:
                content = content.replace(old, new)
                count += 1
                print(f'✓ {english}')
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'\n✅ Replaced {count} translations!')

if __name__ == '__main__':
    main()
