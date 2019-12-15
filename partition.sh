#!/bin/bash
cd /app/kafka/kafka-logs && du -ab *|sort -rh|head -1|awk '{print $1}'
