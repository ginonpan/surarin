#!/usr/bin/env bash

export HUBOT_SLACK_TOKEN=xoxb-17487744021-573904032327-zH6eO8850KuA0v0DuJpS6Ry1
export HUBOT_SLACK_TEAM=andbiz
export HUBOT_SLACK_BOTNAME=surarin

export HUBOT_DIR=~/workspace/surarin
export PATH=${HUBOT_DIR}/node_modules/.bin:$PATH

if [ ! -d ${HUBOT_DIR}/log ]; then
  mkdir ${HUBOT_DIR}/log
fi

forever start -l ${HUBOT_DIR}/log/surarin.log -c coffee -a hubot --adapter slack -r ${HUBOT_DIR}/scripts
