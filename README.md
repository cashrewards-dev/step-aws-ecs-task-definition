# step-aws-ecs-task-definition
Wercker Step to register task definition in aws ecs

## wecker.yml

```
deploy:
    steps:
    - steven-rho/aws-ecs-task-definition:
        name: sample task definition step
        key: $STEP_AWS_ACCESS_KEY_ID
        secret: $STEP_AWS_SECRET_ACCESS_KEY
        region: $STEP_AWS_DEFAULT_REGION
        task-definition-name: my-task-definition
        container-memory: 512
        container_command: "[\"/usr/bin/php\",\"/var/www/laravel/artisan\"]"
        task_definition_template: ecs_task_definition.json.template

```

