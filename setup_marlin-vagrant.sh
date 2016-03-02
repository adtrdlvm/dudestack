#!/bin/bash
# First setup.

# Helpers:
currentfile=`basename $0`
txtbold=$(tput bold)
boldyellow=${txtbold}$(tput setaf 3)
boldgreen=${txtbold}$(tput setaf 2)
boldwhite=${txtbold}$(tput setaf 7)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
green=$(tput setaf 2)
white=$(tput setaf 7)
txtreset=$(tput sgr0)

while true; do
read -p "${boldyellow}Have you installed marlin-vagrant as instructed? (y/n)${txtreset} " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "${red}Please do so. Here: https://github.com/ronilaukkarinen/marlin-vagrant${txtreset}"; exit;;
        * ) echo "${boldwhite}Please answer y or n.${txtreset}";;
    esac
done

echo "${boldyellow}Starting vagrant... (type password if prompted)${txtreset} "
cd ~/Projects/marlin-vagrant && vagrant up --provision

while true; do
read -p "${boldyellow}Have you created a public key for SSH? (y/n)${txtreset} " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) ssh-keygen -t rsa;;
        * ) echo "${boldwhite}Please answer y or n.${txtreset}";;
    esac
done

echo "${boldyellow}Pairing vagrant with your computer...${txtreset} "
cat ~/.ssh/id_rsa.pub | ssh vagrant@10.1.2.4 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' && chmod -Rv 755 ~/.ssh && chmod 400 ~/.ssh/id_rsa

echo "${boldyellow}Bitbucket account username:${txtreset} "
read -e YOUR_BITBUCKET_ACCOUNT_HERE

echo "${boldyellow}Staging server hostname (for example myawesomeserver.com):${txtreset} "
read -e YOUR_STAGING_SERVER_HERE

echo "${boldyellow}Staging server username (for example myusername0123):${txtreset} "
read -e YOUR_STAGING_USERNAME_HERE

echo "${boldyellow}Staging server password:${txtreset} "
read -e YOUR_STAGING_SERVER_PASSWORD_HERE

echo "${boldyellow}Staging server home path without trailing slash (for example /home/myusername0123 or /var/www/somehome):${txtreset} "
read -e YOUR_STAGING_SERVER_HOME_PATH_HERE

echo "${boldyellow}Default MySQL-username (type 'root' if you use marlin-vagrant):${txtreset} "
read -e YOUR_DEFAULT_DATABASE_USERNAME_HERE

echo "${boldyellow}Default MySQL-password (type 'vagrant' if you use marlin-vagrant):${txtreset} "
read -e YOUR_DEFAULT_DATABASE_PASSWORD_HERE

echo "${boldyellow}Default admin username for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE

echo "${boldyellow}Default admin password for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE

echo "${boldyellow}Default admin email for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE

echo "${boldyellow}Generating createscript with your information (requires root):${txtreset} "
sed -e "s;\YOUR_BITBUCKET_ACCOUNT_HERE;$YOUR_BITBUCKET_ACCOUNT_HERE;" -e "s;\YOUR_STAGING_SERVER_HERE;$YOUR_STAGING_SERVER_HERE;" -e "s;\YOUR_STAGING_USERNAME_HERE;$YOUR_STAGING_USERNAME_HERE;" -e "s;\YOUR_STAGING_SERVER_PASSWORD_HERE;$YOUR_STAGING_SERVER_PASSWORD_HERE;" -e "s;\YOUR_STAGING_SERVER_HOME_PATH_HERE;$YOUR_STAGING_SERVER_HOME_PATH_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_USERNAME_HERE;$YOUR_DEFAULT_DATABASE_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_PASSWORD_HERE;$YOUR_DEFAULT_DATABASE_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;" ~/Projects/dudestack/createproject.sh > ~/Projects/dudestack/createproject_generated.sh
sudo mv ~/Projects/dudestack/createproject_generated.sh /usr/local/bin/createproject
sudo chmod +x /usr/local/bin/createproject

echo "${boldgreen}Setup successful. Please run createproject before starting a project."
echo "${red}WARNING! ${boldwhite}Don't trust blindly in your deploy configs, they contain remove commands! Please check them twice before deploying!${txtreset}"
