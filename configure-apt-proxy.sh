#!/bin/bash

echo 'Acquire::http::proxy "http://apt-proxy.localdomain:3142";' >/etc/apt/apt.conf.d/02proxy

