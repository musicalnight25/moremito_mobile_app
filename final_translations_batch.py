#!/usr/bin/env python3
"""
Final batch - complete remaining 11 Chinese translations
"""

filepath = '/Users/dreamworld/Documents/flutter_projects/moremito_mobile_app/lib/utils/app_translations.dart'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

count = 0

# These are multiline entries, so we need to handle them carefully
replacements = [
    ('"\${user.name} (\${user.userName})":\n              "\${user.name} (\${user.userName}) (zh)",',
     '"\${user.name} (\${user.userName})":\n              "\${user.name} (\${user.userName})",'),
    
    ('"Total Activities : \${item.totalInteractions ?? 0}":\n              "Total Activities : \${item.totalInteractions ?? 0} (zh)",',
     '"Total Activities : \${item.totalInteractions ?? 0}":\n              "总活动：\${item.totalInteractions ?? 0}",'),
    
    ('"These cards show total recipients and total activity ":\n              "These cards show total recipients and total activity  (zh)",',
     '"These cards show total recipients and total activity ":\n              "这些卡片显示总收件人和总活动 ",'),
    
    ('"\${address.address1}, \${address.city}, \${address.stateName}, \${address.countryName} - \${address.zip}":\n              "\${address.address1}, \${address.city}, \${address.stateName}, \${address.countryName} - \${address.zip} (zh)",',
     '"\${address.address1}, \${address.city}, \${address.stateName}, \${address.countryName} - \${address.zip}":\n              "\${address.address1}, \${address.city}, \${address.stateName}, \${address.countryName} - \${address.zip}",'),
    
    ('"Order #\${data.myOrders.orderId}":\n              "Order #\${data.myOrders.orderId} (zh)",',
     '"Order #\${data.myOrders.orderId}":\n              "订单 #\${data.myOrders.orderId}",'),
    
    ('"Order Number : \${order.orderId}":\n              "Order Number : \${order.orderId} (zh)",',
     '"Order Number : \${order.orderId}":\n              "订单号：\${order.orderId}",'),
    
    ('"Order Number - \${_value(info?.customOrderNumber)}":\n              "Order Number - \${_value(info?.customOrderNumber)} (zh)",',
     '"Order Number - \${_value(info?.customOrderNumber)}":\n              "订单号 - \${_value(info?.customOrderNumber)}",'),
    
    ('"\${address.firstName} \${address.lastName}":\n              "\${address.firstName} \${address.lastName} (zh)",',
     '"\${address.firstName} \${address.lastName}":\n              "\${address.firstName} \${address.lastName}",'),
    
    ('"Looks like the share wasn\'t completed. No worries! You can try again whenever you":\n              "Looks like the share wasn\'t completed. No worries! You can try again whenever you (zh)",',
     '"Looks like the share wasn\'t completed. No worries! You can try again whenever you":\n              "看起来分享未完成。不用担心！您可以随时重试",'),
    
    ('"Please grant \$permission permission in the settings.":\n              "Please grant \$permission permission in the settings. (zh)",',
     '"Please grant \$permission permission in the settings.":\n              "请在设置中授予\$permission权限。",'),
    
    ('"Please check your keyword or try again your browsing keyword":\n              "Please check your keyword or try again your browsing keyword (zh)",',
     '"Please check your keyword or try again your browsing keyword":\n              "请检查您的关键字或重试您的浏览关键字",'),
]

for old, new in replacements:
    if old in content:
        content = content.replace(old, new)
        count += 1
        print(f'✓ Fixed pattern {count}/11')

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print(f'\n✅ Final translation pass completed - {count} entries fixed!')
