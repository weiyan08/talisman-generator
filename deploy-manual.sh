scp /root/.openclaw/workspace/talisman-generator/index.html root@106.14.237.27:/var/www/subproject/
ssh root@106.14.237.27 'chmod 644 /var/www/subproject/index.html && nginx -s reload'
