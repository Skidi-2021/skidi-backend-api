File README ini membantu dalam proses deploying ke Server, serta beberapa pemberitahuan terkait sistem.
Silahkan clone repository ini dan buat branch baru jika ingin berkontribusi atau sekedar test dan integrasi dengan modul lain di komputer lokal.

----

# SKIDI BACKEND SYSTEM

## Sistem ini menggunakan Rails dan Ruby Ver 3.0.0

*Untuk menginstal Ruby dan Rails di komputer local, silahkan ikuti panduan berikut ini (pengguna linux)*

### INSTALASI RUBY 3.0.0

```
sudo apt update
sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
---
cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL
---
rbenv install 3.0.0
rbenv global 3.0.0
ruby -v
```

### INSTALASI RAILS

```
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install nodejs yarn
---
echo "gem: --no-document" > .gemrc
gem install bundler
gem install rails
rbenv rehash
```

Untuk pengguna Windows, sangat disarankan menginstall Ruby dan Rails di **Windows Subsystem for Linux (WSL)**. Silahkan update ke Windows 10 versi terbaru, dan aktifkan WSL V2.

Setelah mengaktifkan WSL V2, pergi ke Windows Store dan install Ubuntu. Jika sudah selesai, lakukan tahapan yang diberikan bagi pengguna Linux.

## INSTALASI POSTGRESQL

```bash
sudo apt install postgresql-11 libpq-dev

sudo -u postgres createuser USERNAME_KALIAN -s

# Setup password
sudo -u postgres psql

\password USERNAME_KALIAN
```

## KONFIGURASI LANJUTAN

Buka terminal dan masukkan perintah berikut:

``` bash
git clone https://github.com/Skidi-2021/skidi-backend-api.git

cd skidi-backend-api

rails bundler
rails db:create
rails db:migrate
```