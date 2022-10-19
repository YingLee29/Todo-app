# todo-server-rails
TODO list mobile application (Backend - Rails)

1. Create docker image

```shell
docker-compose build
```

2. Start server

```shell
docker-compose up
```

2. Create `config/database.yml` and copy content from `config/database.yml.example`. Change `username` and `password` is `root`

3. Create database and seed data.

```shell
docker-compose run --rm api bundle exec rails db:create db:migrate db:seed
```

4. API list
- GET `http://localhost:4000/api/tasks` - List tasks
- POST `http://localhost:4000/api/tasks` - Create task
- GET `http://localhost:4000/api/tasks/:id` - Show task
- PUT `http://localhost:4000/api/tasks/:id` - Update task
- DELETE `http://localhost:4000/api/tasks/:id` - Delete task
