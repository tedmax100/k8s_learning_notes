#!/bin/bash

redis-benchmark -h redis -p 6379 "$@"