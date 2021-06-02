class JwtDenylist < ApplicationRecord
    # Model JwtDenylist digunakan untuk merusak token yang sudah digunakan
    # Dalam artian, token yang sudah digunakan, dimasukkan kedalam table jwt_denylists
    # Dan token-token yang sudah digunakan tersebut tidak akan bisa digunakan kembali

    self.table_name = 'jwt_denylists'
end