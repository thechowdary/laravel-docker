# laravel-docker
Use docker for laravel

Steps to do:

Step 1: 
- Clone this repo: ```git clone https://github.com/thechowdary/laravel-docker/```
- You can change the port number in docker-compose.yml, default set to 8003 in the nginx configuration in this file.

Step 2: 
- Download laravel to the same location. If it's a new laravel application, use the link: https://github.com/laravel/laravel
- You may need to set the same port number in composer.json file, that was there in step 1.
- Also don't forget to set .env file, you may need to copy from .env.example to .env, if its a new laravel application.

Step 3: docker-compose build

Step 4: docker-compose up -d

Step 5: `docker-compose exec app ls -l`

Step 6: `docker-compose exec app rm -rf vendor composer.lock`

Step 7: `docker-compose exec app composer install`

Step 8: `docker-compose exec app php artisan key:generate`
