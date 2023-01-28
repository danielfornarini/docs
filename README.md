## Test with Rails + Angular, mònade way

Rails project setup:

```bash
rails new sample --skip-git --database=postgresql -T -A --skip-action-mailbox --api
mv sample api
```

Gems:

- RSpec
- database cleaner
- solipsist
- active_model_serializers

### Angular

```bash
ng new -g -s -t --routing sample
mv sample frontend
cd frontend
ng add @angular-eslint/schematics
```

## Features highlighted

- HTTP Interceptor and store
- Cognito authentication
- JSON Parser and form handling
- Rails error handling for forms, using with-errors
- A sample setup with tailwind
- A full flow with ActionCable and Angular to create a chat
- Icons
- Automatic generation of DTO and models from swagger: https://github.com/swagger-api/swagger-codegen/tree/master/modules/swagger-codegen/src/main/resources/typescript-angular
- Modal
- Spinners
- Better swagger
- A DataTable with search, sorting and pagination
- Improve code generation with swagger

## TODO Features

- Improve tailwind setup
- A single page updated with a nested object with ActionCable
- CI
- Terraform
- ESLint per change detection OnPush
