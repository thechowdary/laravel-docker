# laravel-docker
Use docker for laravel

Steps to do:

Step 1: 
- Clone this repo: ```git clone https://github.com/thechowdary/laravel-docker/```
- `git checkout develop`
- You can change the port number in docker-compose.yml, default set to 8003 in the nginx configuration in this file.
- Set the database details in the .env file

Step 2: Files & Database
- `cd laravel`
- Download laravel to this location. If it's a new laravel application, use `git clone https://github.com/laravel/laravel .`
- You may need to set the same port number in .env file, that was there in step 1.
- Also don't forget to set .env file. you may need to copy from .env.example to .env, if its a new laravel application.
- If it's an old application, Put your exported db's sql file to `docker-compose/mysql` folder by replacing existing sql file.

Step 3: `docker-compose build`

Step 4: `docker-compose up -d`

Step 5: `docker-compose exec app ls -l`

Step 6: `docker-compose exec app rm -rf vendor composer.lock`

Step 7: `docker-compose exec app composer install`

Step 8: 
- `docker-compose exec app php artisan key:generate`
- From the ./laravel/.env file change DB_HOST value to the db container name. In my case, it's `myproject-db`

Step 9: `docker-compose exec app php artisan migrate`

Step 10: Visit http://localhost:8003/ <8003: port_number that was set in the step 1 and step 2>
