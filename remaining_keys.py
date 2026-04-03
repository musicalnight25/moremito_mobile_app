#!/usr/bin/env python3
"""
Extract and translate all remaining (zh) keys
"""

import re

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Extract all (zh) placeholders
pattern = r'"([^"]+)":\s*"[^"]*\(zh\)"'
matches = re.findall(pattern, content)

unique_keys = sorted(set(matches))

print(f"Total remaining keys to translate: {len(unique_keys)}\n")

# Manual translations for these remaining keys
more_translations = {
    "Date Received": "收到日期",
    "Sent By": "发送者",
    "No payout history found": "未找到支付历史",
    "Requested Commission History": "请求佣金历史",
    "Total Approved Amount": "总批准金额",
    "Transaction Id": "交易ID",
    "Payment Method": "付款方式",
    "Payment Status": "付款状态",
    "Description": "描述",
    "Go": "前往",
    "Requested Amount": "请求金额",
    "Approved Amount": "批准金额",
    "Pending Commission": "待定佣金",
    "My Commission": "我的佣金",
    "Payout History": "支付历史",
    "See My Payout History": "查看我的支付历史",
    "Total Activities": "总活动",
    "Total Shared": "总共享",
    "Shared Reports": "共享报告",
    "You Don't Have Any Shared Report Yet!": "您还没有任何共享报告！",
    "Today": "今天",
    "Last 7 days": "过去7天",
    "Last 30 days": "过去30天",
    "Last 90 days": "过去90天",
    "Search By Link And Date": "按链接和日期搜索",
    "Select date range": "选择日期范围",
    "Apply": "应用",
    "Filters": "筛选器",
    "By Date": "按日期",
    "From": "从",
    "To": "到",
    "Report Details": "报告详情",
    "Link Report": "链接报告",
    "Total Recipients": "总收件人",
    "Total Count": "总计数",
    "View": "查看",
    "Edit": "编辑",
    "Delete": "删除",
    "Back": "返回",
    "Cancel": "取消",
    "Confirm": "确认",
    "OK": "确定",
    "Save": "保存",
    "Next": "下一步",
    "Previous": "上一步",
    "Loading...": "正在加载...",
    "No data": "无数据",
    "No results": "无结果",
    "Try again": "重试",
    "Contact Support": "联系支持",
    "About": "关于",
    "Privacy Policy": "隐私政策",
    "Terms & Conditions": "条款和条件",
}

# Print translations
for key in unique_keys:
    if key in more_translations:
        print(f'"{key}": "{more_translations[key]}",')
    else:
        # Auto-translate by using English as fallback and marking for manual review
        print(f'# TODO: "{key}": "{key} (Chinese translation needed)",')
