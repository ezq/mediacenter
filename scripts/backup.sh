#!/bin/bash

bkp_path="$(pwd)"
pi_user=$(whoami)
host_name=$(hostname -s)

[ -d "${bkp_path}/backups" ] || sudo mkdir -p "${bkp_path}/backups"
sudo chown ${pi_user}:${pi_user} -R "${bkp_path}/backups"

if ls ${bpk_path} | grep -w 'docker-compose.yml' >> /dev/null ; then
  echo "./docker-compose.yml" >list.txt
  echo ".env" >>list.txt
  echo "./services/" >>list.txt
  echo "./volumes/" >>list.txt
  log_file=./backups/log_local.txt
  backup_file="${host_name}-$(date +"%Y-%m-%d_%H-%M").tar.gz"
  echo -e "\e[32m=====================================================================================\e[0m"
  echo -e "\e[36;1m    Creating backup file ... \e[0m"
  sudo tar -czf ./backups/${backup_file} -T list.txt
  rm list.txt
  sudo chown ${pi_user}:${pi_user} ./backups/${host_name}-*.tar.gz
  echo -e "\e[36;1m    Backup file created \e[32;1m $(ls -t1 ${bpk_path}/backups/${host_name}-*.tar.gz | head -1)\e[0m"
  sudo touch ${log_file}
  sudo chown ${pi_user}:${pi_user} ${log_file}
  echo ${backup_file} >>${log_file}

  ls -t1 ./backups/${host_name}-* | tail -n +4 | sudo xargs rm -f
  echo -e "\e[36;1m    Backup files are saved in \e[34;1m${bpk_path}/backups/\e[0m"
  echo -e "\e[36;1m    Only recent 3 backup files are kept\e[0m"

  if dpkg-query -W rclone 2>/dev/null | grep -w 'rclone' > /dev/null && rclone listremotes | grep -w 'gdrive:' &> /dev/null ; then
    echo -e "\e[36;1m    Syncing to Google Drive ... \e[0m"
    rclone sync -P ./backups --include "/${host_name}-*"  gdrive:/${host_name}-backups/ > ./backups/rclone_sync_log
    echo -e "\e[36;1m    Sync with Google Drive \e[32;1mdone\e[0m"
    rclone cleanup gdrive:
    echo -e "\e[32m=====================================================================================\e[0m"
  else
    echo -e "\e[36;1m    \e[34;1mrclone\e[0m\e[36;1m not installed or \e[34;1m(gdrive)\e[0m\e[36;1m not configured \e[32;1monly local backup created\e[0m"
    echo -e "\e[32m=====================================================================================\e[0m"
  fi
else
  echo -e "\e[32m=====================================================================================\e[0m"
  echo -e "                                                             "
  echo -e "            \e[41m    =============================   \e[0m"
  echo -e "            \e[41m     Containers not deployed yet    \e[0m"
  echo -e "            \e[41m          Nothing to backup         \e[0m"
  echo -e "            \e[41m    =============================   \e[0m"
  echo -e "                                                             "
  echo -e "\e[32m=====================================================================================\e[0m"
fi

