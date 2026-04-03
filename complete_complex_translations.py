#!/usr/bin/env python3
"""
Complete remaining Chinese translations - complex variable templates
"""

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

remaining_translations = {
    '"\$orderId": "\$orderId (zh)",': '"\$orderId": "\$orderId",',
    '"Subject: \${call.subject ?? ": "Subject: \${call.subject ??  (zh)",': '"Subject: \${call.subject ?? ": "Subject: \${call.subject ?? ",',
    '"SMS requested info ": "SMS requested info  (zh)",': '"SMS requested info ": "短信请求信息 ",',
    '"\${widget.userName}": "\${widget.userName} (zh)",': '"\${widget.userName}": "\${widget.userName}",',
    '"Decline report shared by ": "Decline report shared by  (zh)",': '"Decline report shared by ": "拒绝由以下用户共享的报告 ",',
    '"@\${user.username ?? ": "@\${user.username ??  (zh)",': '"@\${user.username ?? ": "@\${user.username ?? ",',
    '"Order Details for Order No. ": "Order Details for Order No.  (zh)",': '"Order Details for Order No. ": "订单\${orderId}的订单详情 ",',
    '"Quantity: \${p.quantity}": "Quantity: \${p.quantity} (zh)",': '"Quantity: \${p.quantity}": "数量：\${p.quantity}",',
    '"Order Date: \$date (UTC)": "Order Date: \$date (UTC) (zh)",': '"Order Date: \$date (UTC)": "订单日期：\$date (UTC)",',
    '"\${address.firstName} \${address.lastName}": "\${address.firstName} \${address.lastName} (zh)",': '"\${address.firstName} \${address.lastName}": "\${address.firstName} \${address.lastName}",',
    '"#\${ticket.ticketId}": "#\${ticket.ticketId} (zh)",': '"#\${ticket.ticketId}": "#\${ticket.ticketId}",',
    '"\${c.firstName ?? ": "\${c.firstName ??  (zh)",': '"\${c.firstName ?? ": "\${c.firstName ?? ",',
    '"Ticket #\${widget.ticketId}": "Ticket #\${widget.ticketId} (zh)",': '"Ticket #\${widget.ticketId}": "工单 #\${widget.ticketId}",',
    '"Connection Error: \$e": "Connection Error: \$e (zh)",': '"Connection Error: \$e": "连接错误：\$e",',
    '"⚠️ iOS token fetch error: \$e": "⚠️ iOS token fetch error: \$e (zh)",': '"⚠️ iOS token fetch error: \$e": "⚠️ iOS令牌获取错误：\$e",',
    '"Oops! No \${widget.title ?? ": "Oops! No \${widget.title ??  (zh)",': '"Oops! No \${widget.title ?? ": "哎呀！没有\${widget.title ?? ",',
}

def main():
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    count = 0
    for old, new in remaining_translations.items():
        if old in content:
            content = content.replace(old, new)
            count += 1
            print(f'✓ Replaced pattern')
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'\n✅ Completed {count} complex translations!')

if __name__ == '__main__':
    main()
