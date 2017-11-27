#!/bin/sh

###################################
# INPUT
#
#echo $STEP_AWS_ACCESS_KEY_ID
#echo $STEP_AWS_SECRET_ACCESS_KEY
#echo $STEP_AWS_DEFAULT_REGION
#
# FOR AWS TASK DEFINITION
#
#echo $STEP_TASK_DEFINITION_NAME
#echo $STEP_CONTAINER_MEMORY
#echo $STEP_DOCKER_COMMAND
#echo $STEP_TASK_DEFINITION_TEMPLATE
#echo $STEP_DIR

STEP_AWS_PROFILE=wercker-step-aws-ecs

aws configure set aws_access_key_id ${STEP_AWS_ACCESS_KEY_ID} --profile ${STEP_AWS_PROFILE}
aws configure set aws_secret_access_key ${STEP_AWS_SECRET_ACCESS_KEY} --profile ${STEP_AWS_PROFILE}
if [ -n "${STEP_AWS_DEFAULT_REGION}" ]; then
  aws configure set region ${STEP_AWS_DEFAULT_REGION} --profile ${STEP_AWS_PROFILE}
fi

#########
#
# FROM https://github.com/wercker/step-bash-template
#
#
TARGET_FILE=$(dirname $STEP_TASK_DEFINITION_TEMPLATE)/ecs_task_definition.json

warn "Templating $STEP_TASK_DEFINITION_TEMPLATE -> $TARGET_FILE"

if [ -e /dev/urandom ]; then
    RANDO=$(LANG=C tr -cd 0-9 </dev/urandom | head -c 12)
else
    RANDO=2344263247
fi

source "$STEP_DIR/src/template.sh" "$STEP_TASK_DEFINITION_TEMPLATE" > "$TARGET_FILE" 2>$RANDO

if [ ! -z "$STEP_BASH_TEMPLATE_ERROR_ON_EMPTY" ]; then
  if [ -s $RANDO ]; then
    cat $RANDO
    rm -f $RANDO
    exit 1
  fi
fi
rm -f $RANDO

cat $TARGET_FILE

warn "Register Task definition : $TARGET_FILE"
aws ecs register-task-definition \
      --profile ${STEP_AWS_PROFILE} \
      --cli-input-json file://$TARGET_FILE
