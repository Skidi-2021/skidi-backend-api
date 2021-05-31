# Rails Deployment

* Login Via SSH ( skidi-backend )
* Install Ruby versi 3.0.0
* Install NGINX WebServer and Passenger
* Configure sites-enabled
* Restrict Gem for including RDOC while installing plugin
* Install Gem Bundler 
* Install Postgresql
* Create skidi-backend folder inside skidi-backend user
---
### Login Via SSH

Untuk Login via SSH, buka putty ( untuk windows ) atau gunakan terminal pada linux. Untuk windows masukkan:

Username: skidi-backend <br/>
IP Host: SKIDI_IP_EXTERNAL <br/>
Password: YOUR_PASSWORD

Pastikan user yang tertera ketika berhasil login SSH di Terminal adalah skidi-backend

---

### Install Ruby V.3.0.0

Install depedency yang dibutuhkan

``` bash
# Adding Node.js repository
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Adding Yarn repository
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo add-apt-repository ppa:chris-lea/redis-server

# Refresh our packages list with the new repositories
sudo apt-get update

# Install our dependencies for compiiling Ruby along with Node.js and Yarn
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev dirmngr gnupg apt-transport-https ca-certificates redis-server redis-tools nodejs yarn
```

Install Ruby via Rbenv

``` bash
# Installing Rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Adding All Ruby Versions to Rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# Adding Environment Variable to Rbenv
git clone https://github.com/rbenv/rbenv-vars.git ~/.rbenv/plugins/rbenv-vars

exec $SHELL

rbenv install 3.0.0
rbenv global 3.0.0
ruby -v
```
---

### Install NGINX and Passenger
Instalasi Nginx untuk menerima HTTP Request. Dan Passenger sebagai WebServer yang di integrasikan dengan NGINX.

``` bash
# Adding Repository to APT
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list'

sudo apt-get update

# Installing
sudo apt-get install -y nginx-extras libnginx-mod-http-passenger

# Configure Nginx to Receive Passanger Integration
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

sudo ls /etc/nginx/conf.d/mod-http-passenger.conf
```

Setelah itu, buka file mod-http-passenger.conf dengan editor nano

``` bash
sudo nano /etc/nginx/conf.d/mod-http-passenger.conf
```
Lalu ubah keseluruhan baris `passenger_ruby` dengan baris berikut:

```
passenger_ruby /home/skidi-backend/.rbenv/shims/ruby;
```
Simpan file tersebut dengan klik `ctrl + x` lalu klik `y`. Setelah itu masukkan perintah berikut:

``` bash
sudo service nginx start
```
---

### Configure sites-enabled

File configurasi di sites-enabled adalah file yang memberitahu HTTP Server Nginx suatu website ditempatkan dan diarahkan pada Directory yang tepat, serta menggunakan domain sesuai dengan yang telah ditetapkan.

``` bash
sudo rm /etc/nginx/sites-enabled/default

sudo nano /etc/nginx/sites-enabled/skidi-backend
```

Pada editor nano, masukkan konfigurasi berikut:

``` nginx
server {
  listen 80;
  listen [::]:80;

  # Kalau punya domain, server_name bisa diganti dengan domain yang sesuai
  # Misalnya: server_name backend.skidi-skindisease.id;
  server_name _;
  root /home/skidi-backend/skidi-backend/current/public;

  passenger_enabled on;
  passenger_app_env production;

  location /cable {
    passenger_app_group_name myapp_websocket;
    passenger_force_max_concurrent_requests_per_process 0;
  }

  # Allow uploads up to 100MB in size
  client_max_body_size 100m;

  location ~ ^/(assets|packs) {
    expires max;
    gzip_static on;
  }
}
```

Simpan file tersebut dengan klik `ctrl + x` lalu klik `y`. Setelah itu masukkan perintah berikut:

``` bash
sudo service nginx reload
```
---

### Restrict Gem for Including RDoc

Merestrict Rdoc agar penginstalan Gem berjalan tidak terlalu lama. Juga menghemat memori dan penyimpanan

``` bash
echo 'gem: --no-document' > .gemrc
```
---

### Installing Bundler

Bundler adalah Packet Manager yang dapat membantu mengorganisir Gem-gem di Aplikasi Rails. Bundler dan Rails sejatinya adalah sebuah Gem (Plugin/Library) untuk bahasa pemrograman Ruby. Sama seperti Pip untuk Python atau NPM / Yarn pada Nodejs.

``` bash
# Install Bundler
gem install bundler

bundle -v
```
---

### Installing Postgresql

``` bash
# Install Postgresql
sudo apt-get install postgresql postgresql-contrib libpq-dev

# Login to postgres user
sudo su - postgres

# Createuser Role to Postgresql
createuser --pwprompt skidi-backend

# Createdb Database to Postgresql for rails skidi-backend
createdb -O skidi-backend skidi_backend_db_production

exit
```
Pastikan konfigurasi untuk DB kita yaitu:

```
user: skidi-backend
pass: [SKIDI-DB-PRODUCTION-B21CAP0401]
host: localhost
db: skidi_backend_db_production
```
---

### Create skidi-backend folder

``` bash
cd

mkdir skidi-backend

# Creating Environment Variable
nano skidi-backend/.rbenv-vars
```

Lalu masukkan konfigurasi berikut:

``` bash
# Postgres
DB_USERNAME=skidi-backend
DB_PASSWORD=[SKIDI-DB-PRODUCTION-B21CAP0401]
DB_NAME=skidi_backend_db_production

# Rails Secrets
RAILS_MASTER_KEY=129389f21d698dd224438ddda9461b56
SECRET_KEY_BASE=5e76111f8bfdadf99e608028745745f4d90545e94729c8d4094e63bf1c7e31cb987da4d9d1266cb70ec8a0acdc3656889644b0b01e09711a7fb550b884d8127d
```

Update selanjutnya menyusul. Happy Hacking!