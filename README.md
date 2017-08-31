# ACLer

## Synopsis

Used for proofing network ACLs. This script can be used to test inter-network connectivity by placing two instances in two different networks. The script will run through all 65535 TCP ports and determine if they are assessible between the networks.
Aimed at having a minum number of dependencies.

## Usage
```
./acler.rb server 
./acler.rb client
```

## Motivation
The motivation was simply to test Rubys networking functionality, but also to assist in segmentation testing.

## Example
Standard scan against single a /29 with verbose output on:
```
[Ruby/ACLer] $ ./acler.rb server
Starting Server...
Got connection on port: 5666
-----------------------------------
[Ruby/ACLer] $ ./acler.rb client
Starting Client, please ensure the server is running first...
Connected on port: 5666
```
The script will output the STDOUT with the number of connected ports, then once complete it will output to a text file with the port and reason.
