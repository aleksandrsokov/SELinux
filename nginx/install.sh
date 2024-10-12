dnf -y install setroubleshoot-server setools-console selinux-policy-mls policycoreutils-newrole nginx
sed -ie 's/:80/:4444/g' /etc/nginx/nginx.conf
sed -i 's/listen       80;/listen       4444;/' /etc/nginx/nginx.conf
systemctl start nginx