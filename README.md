# ZkNodeDumper

ZkNodeDumper - simple tool to dump content of zookeeper node to STDOUT

## Requirements

- Net::ZooKeeper
- Config::Tiny

## Config file

Config file contains definition od servers

[default]
hosts = zookeeper-1.example.com,zookeeper-2.example.com
port = 2181

## Usage

perl zkNodeDumper.pl -config=config.cfg -node=/service/myservice
