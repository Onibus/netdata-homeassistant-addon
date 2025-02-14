#!/usr/bin/env bashio

# Retrieve the default Netdata configuration
/opt/netdata/bin/netdata -d -p 19999 & sleep 2
mkdir -p /etc/netdata
curl -so /etc/netdata/netdata.conf http://localhost:19999/netdata.conf
pkill -9 netdata

# Configure Netdata
TAB=$'\t'

NETDATA_HOSTNAME=$(bashio::config 'hostname')
bashio::log.info "Netdata configuration: set hostname to ${NETDATA_HOSTNAME}"
sed -i "s/${TAB}# hostname = .*/${TAB}hostname = ${NETDATA_HOSTNAME}/" /etc/netdata/netdata.conf

NETDATA_PAGE_CACHE_SIZE=$(bashio::config 'page_cache_size')
bashio::log.info "Netdata configuration: set page_cache_size to ${NETDATA_PAGE_CACHE_SIZE}"
sed -i "s/${TAB}# page cache size = .*/${TAB}page cache size = ${NETDATA_PAGE_CACHE_SIZE}/" /etc/netdata/netdata.conf

NETDATA_DBENGINE_DISK_SPACE=$(bashio::config 'dbengine_disk_space')
bashio::log.info "Netdata configuration: set page_cache_size to ${NETDATA_DBENGINE_DISK_SPACE}"
sed -i "s/${TAB}# dbengine multihost disk space = .*/${TAB}dbengine multihost disk space = ${NETDATA_DBENGINE_DISK_SPACE}/" /etc/netdata/netdata.conf

NETDATA_ENABLE_ALARM=$(bashio::config 'enable_alarm')
if [[ ${NETDATA_ENABLE_ALARM} == "false" ]]
then
    bashio::log.info "Netdata configuration: alarm is ${NETDATA_DISABLE_ALARM}"
    sed -i "s/${TAB}# enabled = .*/${TAB}enabled = no/" /etc/netdata/netdata.conf
fi

NETDATA_ENABLE_LOG=$(bashio::config 'enable_log')
if [[ ${NETDATA_ENABLE_LOG} == "false" ]]
then
    bashio::log.info "Netdata configuration: logging is ${NETDATA_DISABLE_LOG}"
    sed -i "s/${TAB}# debug log = .*/${TAB}debug log = none/" /etc/netdata/netdata.conf
    sed -i "s/${TAB}# error log = .*/${TAB}error log = none/" /etc/netdata/netdata.conf
    sed -i "s/${TAB}# access log = .*/${TAB}access log = none/" /etc/netdata/netdata.conf
fi

NETDATA_CONFIG_PATH=$(bashio::config 'data_path')
bashio::log.info "Netdata configuration: set config path to ${NETDATA_CONFIG_PATH}/config"
sed -i "s/${TAB}# config directory = .*/${TAB}config directory = ${NETDATA_CONFIG_PATH}/config/" /etc/netdata/netdata.conf
bashio::log.info "Netdata configuration: set lib path to ${NETDATA_CONFIG_PATH}/config"
sed -i "s/${TAB}# lib directory = .*/${TAB}lib directory = ${NETDATA_CONFIG_PATH}/lib/" /etc/netdata/netdata.conf