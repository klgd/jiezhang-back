# 洁账服务端
> Rails 提供的洁账小程序后端Api代码

### 洁账小程序代码
https://github.com/yigger/jiezhang

### 版本要求
```
Ruby 2.3.1
Mysql 5.7.1
Rails 5.1.3
```

### 安装
```
// 环境配置
cp config/environments/development.rb.example config/environments/development.rb

// 自定义配置
cp config/settings/development.yml.exmaple config/settings/development.yml

cp config/secrets.yml.example config/secrets.yml

// 创建数据库
bundle exec rake db:create RAILS_ENV=development

// 迁移数据表
bundle exec rake db:migrate RAILS_ENV=development

// 安装依赖
bundle install
```

### 启动
```
// 开发模式下启动项目
bundle exec unicorn_rails -l 0.0.0.0:3000 -D -E development -c config/unicorn.rb

// 生产环境下启动项目
bundle exec unicorn_rails -l 0.0.0.0:3000 -D -E production -c config/unicorn.rb 
```

### Docker运行

+ 复制 Gemfile 和 Gemfile.lock 到 docker 文件夹
+ docker build -t jz -f ./Dockerfile .
+ docker exec -it jz /bin/bash
+ docker-machine 挂载路径问题 https://xiaoyounger.com/article/17

### 可能遇到的问题
```
bundle 过程中, rmagick 安装失败的话可以执行以下语句
sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev


Docker可能存在的问题
1. 挂载目录的问题
2. rails 更改文件不生效的问题
3. 时区相差8小时 /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone
docker run -it --name jz -p 80:3000 -v /ljt:/home/ljt -d jz /bin/bash
bundle exec rails s -p 3000 -b '0.0.0.0'
```
