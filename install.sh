echo ""
echo "------------------------------------------------"
echo "Update server                                   "
echo "------------------------------------------------"
echo ""
apt-get update
apt-get upgrade

echo ""
echo "------------------------------------------------"
echo "Fixed locale                                    "
echo "------------------------------------------------"
echo ""
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
dpkg-reconfigure locales

echo ""
echo "-----------------------------------------------"
echo "Install NGINX 								 "
echo "-----------------------------------------------"
echo ""
apt-get -qy install NGINX

echo ""
echo "-----------------------------------------------"
echo "Install certbot 								 "
echo "-----------------------------------------------"
echo ""
add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install -qy python-certbot-nginx

echo ""
echo "-----------------------------------------------"
echo "Install multichain     						 "
echo "-----------------------------------------------"
echo ""
cd /tmp
wget https://www.multichain.com/download/multichain-2.0.3.tar.gz
tar -xvzf multichain-2.0.3.tar.gz
cd multichain-2.0.3
mv multichaind multichain-cli multichain-util /usr/local/bin
cd ~

echo ""
echo "-----------------------------------------------"
echo "Configure firewall     						 "
echo "-----------------------------------------------"
echo ""
ufw allow OpenSSH
ufw allow in 443/tcp comment "https: for certbot"
ufw allow 'Nginx HTTP'
ufw allow in 7000/tcp comment "Multichain peer to peer connections"
ufw allow in 1986/tcp comment "Multichain peer to peer connections"
ufw enable
ufw status

echo ""
echo "-----------------------------------------------"
echo "Installing nodejs     						 "
echo "-----------------------------------------------"
echo ""
curl -sL https://deb.nodesource.com/setup-10.x
apt-get -qy install nodejs

echo "Linking /usr/bin/nodejs to usr/bin/node"
ln -s /usr/bin/nodejs /usr/bin/node
apt-get -qy install libtool pkg-config build-essential autoconf automake

echo ""
echo "-----------------------------------------------"
echo "Done       						             "
echo "-----------------------------------------------"
echo ""
