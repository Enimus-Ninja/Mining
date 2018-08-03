#!/bin/sh -ex 
apt-get --assume-yes update 
 
apt-get --assume-yes install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev screen git nano dos2unix sshpass 
  
cd /home/ubuntu 
  
git clone https://github.com/Enimus/xmr-stak.git 
 
cd /home/ubuntu/xmr-stak 
 
cmake -DCUDA_ENABLE=OFF -DHWLOC_ENABLE=OFF -DOpenCL_ENABLE=OFF 
 
make install 
 
cd /home/ubuntu/xmr-stak/bin/ 
 
chmod +x xmr-stak 
 
chown -R ubuntu:ubuntu /home/ubuntu/* 
 
sysctl -w vm.nr_hugepages=128 
 
echo -e "vm.nr_hugepages=128" | tee -a /etc/sysctl.conf 
 
cat > /lib/systemd/system/masaruk-neborak.service  << EOF 
[Unit] 
Description=masaruk-neborak 
After=network.target 
[Service] 
ExecStart=/home/ubuntu/xmr-stak/bin/xmr-stak -c /home/ubuntu/xmr-stak/bin/config.txt --url "pool.masaricoin.com:5555" --user "5oVSmSwE5utZAAx1eU5yrb1j6mZcrKKa9Ha48BYQqP2qQjNKWaxB1xv3Pq2S3CRSosjKJCzF1Q1kwViyYzGW96UGNKa98s9" --pass "enimus@enimus.com" --currency "masari"
User=root 
[Install] 
WantedBy=multi-user.target 
EOF
 
systemctl daemon-reload 
 
systemctl enable masaruk-neborak.service 
 
systemctl start masaruk-neborak.service 
 
systemctl stop masaruk-neborak.service 
 
systemctl restart masaruk-neborak.service 
 
 
