#!/usr/bin/env bash
tail -f $HOME/arkilog/sites/etude${1:-001}/logs/catalina.$(date +%Y-%m-%d).log
