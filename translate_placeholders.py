#!/usr/bin/env python3
"""
Translate all placeholder Chinese translations in app_translations.dart
Replaces patterns like "Text (zh)" with actual Chinese translations
"""

import re
from typing import Dict, Tuple

# Comprehensive English to Chinese translation mapping
translations: Dict[str, str] = {
    # General terms
    "MoreMito": "MoreMito",
    "Success 🎉": "成功 🎉",
    "Thanks for sharing via $platform": "感谢通过$platform分享",
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
    "To continue, please take a moment to complete a brief survey. Your feedback helps us improve your experience!": "要继续，请花费片刻完成一份短问卷。您的反馈帮助我们改进您的体验！",
    "Start Survey": "开始调查",
    "Answer Required": "需要答案",
    "Please answer first.": "请先回答。",
    "Select an answer first.": "请先选择答案。",
    "Survey": "调查",
    "MoreMito Library": "MoreMito库",
    "Browse audio, video, and document files.": "浏览音频、视频和文档文件。",
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
    "Write a message for the recipient": "为收件人写一条消息",
    "Enter recipient name": "输入收件人姓名",
    "Message": "消息",
    "Select an Option": "选择选项",
    "Choose from Contacts": "从联系人中选择",
    "Enter Name Manually": "手动输入名称",
    "Generate Link To Share": "生成分享链接",
    "Generate a Link": "生成链接",
    "Subcategories": "子类别",
    "No sent history found": "未找到发送历史记录",
    "MoreMito Cash Transfer History": "MoreMito现金转账历史",
    "Below is the history of the MoreMito Cash you have transferred.": "以下是您已转账的MoreMito现金历史记录。",
    "MoreMito Cash Transferred By You": "您转账的MoreMito现金",
    "Total Sent: ": "发送总额: ",
    "MoreMito Cash Sent To Others": "发给他人的MoreMito现金",
    "Date Transferred": "转账日期",
    "Sent To": "发送给",
    "Amount": "金额",
    "No transfer history found": "未找到转账历史记录",
    "Below is the history of the MoreMito Cash you have received.": "以下是您已收到的MoreMito现金历史记录。",
}

def read_file(filepath: str) -> str:
    """Read the entire file"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

def write_file(filepath: str, content: str) -> None:
    """Write content to file"""
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def get_english_key_and_placeholder(line: str) -> Tuple[str, str, str]:
    """
    Extract English key and placeholder from lines like:
    "Key": "Key (zh)"
    Returns (full_line, english_key, placeholder_value)
    """
    # Match pattern like: "some text": "some text (zh)"
    match = re.search(r'"([^"]+)":\s*"([^"]*\s*\(zh\))"', line)
    if match:
        return line, match.group(1), match.group(2)
    return None, None, None

def main():
    filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'
    content = read_file(filepath)
    
    # Count replacements
    replacements_made = 0
    lines = content.split('\n')
    
    for i, line in enumerate(lines):
        full_line, english_key, placeholder = get_english_key_and_placeholder(line)
        
        if english_key and english_key in translations:
            chinese_value = translations[english_key]
            # Replace the placeholder with actual Chinese translation
            new_line = line.replace(placeholder, f'"{chinese_value}"')
            lines[i] = new_line
            replacements_made += 1
            print(f"✓ Translated: {english_key} -> {chinese_value}")
    
    # Write back
    new_content = '\n'.join(lines)
    write_file(filepath, new_content)
    print(f"\n✅ Replaced {replacements_made} translations!")

if __name__ == '__main__':
    main()
