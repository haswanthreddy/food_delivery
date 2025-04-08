## Requirements

- postgresql@17
- rails 8
- ruby 3.4.1
- postgis (brew install postgis)


## Setup

clone the repo
install gems
```
bundle install
```
create db
```
rails db:create
```
migrations
```
rails db:migrate
```
solid cache install
```
rails solid_cache:install 
```
solid queue install
```
rails solid_queue:install
```
Load solid cache schema
```
bin/rails db:schema:load DATABASE=cache
```
Load solid queue schema
```
bin/rails db:schema:load DATABASE=queue
```
start solid cache in development mode
```
bin/rails dev:cache
```
start solid queue in development mode
```

```
## Confirmations

to check if DB's are created check storage or the below command,
```
bin/rails runner 'puts ActiveRecord::Base.configurations.configs_for(env_name: "development").map(&:name)'
```
should return the below result
```
primary
cache
queue
```
check the tables inside cache and queue if required


## System Design

![alt text](image.png)

