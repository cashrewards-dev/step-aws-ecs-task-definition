#!/bin/bash
set +e
set -o noglob

#
# Headers and Logging
#

error() { printf "✖ %s\n" "$@"
}
warn() { printf "➜ %s\n" "$@"
}

type_exists() {
  if [ $(type -P $1) ]; then
    return 0
  fi
  return 1
}

STEP_PREFIX="WERCKER_AWS_ECS_TASK_DEFINITION"
step_var() {
  echo $(tmp=${STEP_PREFIX}_$1 && echo ${!tmp}) 
}


# Check python is installed
if ! type_exists 'python3'; then
  error "Please install python 3.x"
  exit 1
fi

# Check pip is installed
if ! type_exists 'pip'; then
  error "Please install pip"
  exit 1
fi

# Check env file
# https://github.com/builtinnya/dotenv-shell-loader
#source ${WERCKER_STEP_ROOT}src/dotenv-shell-loader.sh
#dotenv

# Check variables
if [ -z "$(step_var 'KEY')" ]; then
  error "Please set the 'key' variable"
  exit 1
fi

if [ -z "$(step_var 'SECRET')" ]; then
  error "Please set the 'secret' variable"
  exit 1
fi

if [ -z "$(step_var 'REGION')" ]; then
  error "Please set the 'region' variable"
  exit 1
fi

if [ -z "$(step_var 'TASK_DEFINITION_NAME')" ]; then
  error "Please set the 'task-definition-name' variable"
  exit 1
fi

if [ -z "$(step_var 'CONTAINER_MEMORY')" ]; then
  error "Please set the 'container-memory' variable"  
fi

if [ -z "$(step_var 'CONTAINER_COMMAND')" ]; then
  error "Please set the 'container-command' variable"  
fi

if [ -z "$(step_var 'TASK_DEFINITION_TEMPLATE')" ]; then
  error "Please set the 'task-definition-template' variable"  
fi

# INPUT Variables for main.sh

#FOR AWS CONFIGURE
STEP_AWS_ACCESS_KEY_ID=$(step_var 'KEY')
STEP_AWS_SECRET_ACCESS_KEY=$(step_var 'SECRET')
STEP_AWS_DEFAULT_REGION=$(step_var 'REGION')

#FOR AWS TASK DEFINITION
STEP_TASK_DEFINITION_NAME=$(step_var 'TASK_DEFINITION_NAME')
STEP_CONTAINER_MEMORY=$(step_var 'CONTAINER_MEMORY')
STEP_DOCKER_COMMAND=$(step_var 'CONTAINER_COMMAND')
STEP_TASK_DEFINITION_TEMPLATE=$(step_var 'TASK_DEFINITION_TEMPLATE')
STEP_DIR=$WERCKER_STEP_ROOT

source $STEP_DIR/src/main.sh




