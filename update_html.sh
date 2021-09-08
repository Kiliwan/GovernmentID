# !/bin/sh

# Server 1
rsync -rave 'ssh -i idblockchain.pem' expressjs-server/ ubuntu@3.17.138.33:/var/www/html/server/
# Server 2
#rsync -rave 'ssh -i idblockchain.pem' expressjs-server/ ubuntu@18.190.25.49:/var/www/html/server/
# Server 3
#rsync -rave 'ssh -i idblockchain.pem' expressjs-server/ ubuntu@3.19.228.201:/var/www/html/server/
# Server 4
#rsync -rave 'ssh -i idblockchain.pem' expressjs-server/ ubuntu@18.217.125.153:/var/www/html/server/

echo 'HTML should have been updated'
