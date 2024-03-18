### Overview

This is a web app API for sharing YouTube videos using Ruby on Rails with PostgreSQL and Redis, all running in Docker.

### Features

1. User registration and login.
2. Sharing YouTube videos.
3. Viewing a list of shared videos (no need to display up/down votes).
4. Real-time notifications for new video shares: When a user shares a new video, other logged-in users could receive a real-time notification about the newly shared video.

### Prerequisites:

Please ensure you are using Docker Compose V2. This project relies on the `docker compose` command, not the previous `docker-compose` standalone program.

https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command

Check your docker compose version with:

```
% docker compose version
Docker Compose version v2.24.6-desktop.1
```

### Installation & Configuration:

Cloning the repository:

```
git clone git@github.com:lamhh26/funny_videos_be.git

# Or

git clone https://github.com/lamhh26/funny_videos_be.git
```

Configuring settings and installing:

```
cp .env.example .env
docker compose build

# Create a docker network
docker network create -d bridge app_network
```

### Database Setup

```
docker compose run --rm web rails db:setup

```

### Running the Application

#### Running the development server
```
docker compose up -d
```
After that you can see the app at http://localhost:3000.

#### Running tests

With test suites of `models`, `requests`, `sidekiq`, we can run as below:
```
docker compose run --rm web rspec --exclude-pattern "spec/system/**/*_spec.rb"
```

With test suites of the intergration test in `system` folder, we use the libraries `capybara` and `selenium-webdriver`

Change `.env` file like below:
```
PGHOST=db
PGUSER=postgres
PGPASSWORD=postgres
REDIS_URL=redis://redis:6379
CROSS_ORIGIN_DOMAIN=frontend:3001
CAPYBARA_APP_HOST=http://frontend:3001
```

Stop the running containers if have any

```
docker compose down
```

We also need to run the frontend application. At [frontend repo](https://github.com/lamhh26/funny_videos_be) run these commands:
```
# Create .env file if it doesn't exist
cp .env.example .env

# Change the file content to the following
REACT_APP_API_BASE_URL=http://backend:3000
REACT_APP_WEBSOCKET_URL=ws://backend:3000/cable

# Build a image from Dockerfile
docker build -f Dockerfile.dev -t funny-videos-fe .

# Run the frontend app
docker run -p 3001:3001 --name frontend --network app_network --rm -d funny-videos-fe
```

Run `rspec` command to execute integration test suites
```
docker compose run --rm --name backend web rspec spec/system/videos_spec.rb
```

### Usage

Refer [this](https://github.com/lamhh26/funny_videos_fe/blob/main/README.md#usage)

### Troubleshooting

Because when executing `docker compose run` and `docker run` we specify fixed container names so the error like `The container name "[CONTAINER_NAME]" is already in use by container ` may occur. Then we need to stop and delete the previously existing container.

```
docker stop [CONTAINER_NAME]
docker rm [CONTAINER_NAME]
```

We are using `selenium` to do integration testing, currently we are using `seleniarm/standalone-chromium` docker image, which is compatible with `arm64` platform (for M series Mac). For other platforms such as `amd64`, you need to switch to using `selenium/standalone-chrome` image.

```
chrome:
  image: selenium/standalone-chrome
  container_name: chrome
  ports:
    - 4444:4444
    - 7900:7900
    - 5900:5900
```
