# Documentation Api
---
Token menggunakan JWT dengan algoritma hashing **HS256**

---

## Authorization

| Method | Endpoint | Keterangan | Response |
|--------|----------|------------| -------- |
|  POST  | /api/login(:format) | Login ke API | 200 |
|  POST  | /api/register(:format) | Registrasi User | 200 |
|  PUT   | /api/credential(:format) | Update Email / Password | 200 |
| DELETE | /api/logout | Logout dari aplikasi | 200 |

--------
## Penggunaan API

### Login

```
/api/login
```
Gunakan Form Data untuk mengakses API ini

```bash
curl -X POST localhost:3000/api/login \
-F "email=mega@kodein.id" \
-F "password=(Mega123)
```
Method ini akan mereturn token

```json
{
    "data": {
        "type": "sessions",
        "attributes": {
            "id": 1,
            "email": "mega@kodein.id",
            "token": "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJnaGFuaXlAa29kZWluLmlkIiwianRpIjoiZWU4NTk0Mjg5MWMxMGFkZDkxOTg0YzgwZjJjMjg4MTkiLCJpYXQiOjE2MjI2MDYxMzIsImV4cCI6MTY1NDE0MjEzMn0.G2GmaWOn8c-T3PUGXQFDCsFOWtz8AbWQKSN6DSThIFA"
        }
    },
    "status": 200
}
```

### Logout

```
/api/logout
```
Method ini memerlukan Authorization Bearer di HTTP Header.

```bash
curl -X DELETE localhost:3000/api/logout \
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJnaGFuaXlAa29kZWluLmlkIiwianRpIjoiZWU4NTk0Mjg5MWMxMGFkZDkxOTg0YzgwZjJjMjg4MTkiLCJpYXQiOjE2MjI2MDYxMzIsImV4cCI6MTY1NDE0MjEzMn0.G2GmaWOn8c-T3PUGXQFDCsFOWtz8AbWQKSN6DSThIFA"
```

### Register

Password diwajibkan untuk mengikuti Validasi berikut:
- Minimal 8 karakter
- Karakter harus terdiri minimal 1 Angka, 1 Huruf kapital, dan 1 Karakter Unik

```bash
curl -X POST localhost:3000/api/register \
-F "user[email]=mega@kodein.id" \
-F "user[password]=(Mega123)"
```
Method ini memasukkan data ke Database, dan menghasilkan token.

```json
{
    "data": {
        "type": "registrations",
        "attributes": {
            "id": 8,
            "email": "mega@kodein.id",
            "token": "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OCwiZW1haWwiOiJtZWdhQGtvZGVpbi5pZCIsImp0aSI6IjE1MTQxMjdjZTc2YWE3YzI5ZWE2NTMzZjgwMzM5Yzc0IiwiaWF0IjoxNjIyNTg3NjE5LCJleHAiOjE2MjI1OTQ4MTl9.-YzDJjPQ2kAnHPRdoY3fIBMQqcvlk692t0YYFxyd3Iw"
        }
    },
    "status": 200
}
```

### Update (Email)

Penjelasan untuk update email:

Didalam token JWT sudah tersedia email yang digunakan untuk mengotorisasi user saat pertama kali mendaftar ke sistem.
Untuk merubah email, cukup memasukkan email baru ke URL, lalu sistem akan otomatis mengupdate email lama berdasarkan hasil decode token JWT.

```
/api/credential
```
Method ini memerlukan Authorization Bearer di HTTP Header.

```bash
curl -X PUT localhost:3000/api/credential \
-F "email=mega@kodein.id" \
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6OCwiZW1haWwiOiJtZWdhQGtvZGVpbi5pZCIsImp0aSI6IjE1MTQxMjdjZTc2YWE3YzI5ZWE2NTMzZjgwMzM5Yzc0IiwiaWF0IjoxNjIyNTg3NjE5LCJleHAiOjE2MjI1OTQ4MTl9.-YzDJjPQ2kAnHPRdoY3fIBMQqcvlk692t0YYFxyd3Iw"
```

### Update (Password)

Penjelasan untuk update password:

Password dicocokkan berdasarkan id user yang terdata di sistem. Untuk merubah password, cukup masukkan password baru ke URL beserta token Authorization di Header.
Sistem akan otomatis merubah password berdasarkan email dan id user yang berada di Token tersebut.

```
/api/credential
```
Method ini memerlukan Authorization Bearer di HTTP Header.

```bash
curl -X PUT localhost:3000/api/credential \
-F "password=(Ghaniy1998)" \
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTcsImVtYWlsIjoiYWRtaW5AYWRtaW4uY28uaWQiLCJqdGkiOiI0OTg2ODEyOGQ0Y2Q1ODczNmFlM2E5MTJmNmY2NjhkNCIsImlhdCI6MTYyMDQxNzY3MywiZXhwIjoxNjIwNDI0ODczfQ.V0cWkpoPMmElYEKzH4BfZaGV5Y0in6O_TfYZdAhdVac"
```

## (Authorization) Error Responses

| Action | Response | Keterangan |
| ------ | -------- | ---------- |
| Merubah Password / Email | 401 | Jika token expired, invalid, atau sudah terdaftar di database sebagai denied token |
| Mengakses Resource | 401 | Jika token kosong, expired, invalid, atau sudah terdaftar di database sebagai denied token |
| Merubah Password | 422 | Jika password tidak sesuai validasi (min 6, terdapat huruf kapital, karakter uniq dan angka) |
| Merubah Email | 422 | Jika email tidak seperti layaknya email, atau email sudah terdaftar |
| Merubah Kredensial | 400 | Jika paramater di URL salah |

-----

## Resources

| Method | Endpoint | Keterangan | Response |
| ------ | -------- | ---------- | ------ |
| GET    | /api/users/:id/symptoms | Index data seluruh gejala penyakit yang diderita dari user tertentu | 200 |
| GET    | /api/users/:id/symptoms/:id | Menampilkan rincian salah satu gejala penyakit yang di derita | 200 |
| POST   | /api/users/:id/symptoms/ | Mendapatkan informasi dari penyakit yang diderita dan RS Terdekat | 200 |

---

## Penggunaan API

### (POST) User Symptoms

Untuk mendapatkan overview dari data Symptoms yang dikirim, terlebih dahulu harus memfetch ID User dari Header Authorization.

Gunakan Endpoint berikut dan Masukkan data menggunakan FormData

```
api/users/[id_user]/symptoms
```
Data yang dikirim berupa Nama Penyakit (output dari Kecerdasan Buatan), lalu data lokasi pengguna (Latitude dan Longitude)

Data lokasi terkini pengguna digunakan untuk mencari Poli Kulit / Klinik terdekat (Radius 5KM)

```bash
curl -X POST localhost:3000/api/users/1/symptoms \
-F "symptom_name=Dermatofibroma" \
-F "latitude=-6.2122778" \
-F "longitude=106.9314651" \
-H "Authorization: Bearer YOUR_AUTHORIZATION_TOKEN"
```
Response dari Endpoint tersebut:

```json
{
    "data": {
        "type": "symptom",
        "attributes": {
            "symptom_name": "Dermatofibroma",
            "sources": [
                {
                    "title": "Cara Mengatasi Tumor Jinak Pada Kulit Yang Berulang - Tanya ...",
                    "snippet": "16 Jul 2018 ... Dermatofibroma adalah tumor jinak yang berbentuk bulat, kecil, konsistensinya \nkeras, dan berwarna merah muda-merah tua-hingga kecokelatan ...",
                    "url": "https://www.alodokter.com/komunitas/topic/dermathofibroma"
                },
                ...
                {
                    "title": "Dermatofibrosarkoma Protuberans - Gejala, penyebab dan ...",
                    "snippet": "21 Jan 2019 ... Dermatofibrosarkoma protuberans (DFSP) adalah jenis kanker kulit yang jarang \nterjadi dan bermula dari sel jaringan penghubung di lapisan ...",
                    "url": "https://www.alodokter.com/dermatofibrosarkoma-protuberans"
                },
                {
                    "title": "Penyebab Benjolan Warna Hitam Di Jari Tengah - Tanya Alodokter",
                    "snippet": "19 Okt 2019 ... Benjolan kehitaman pada permukaan kulit mungkin merupakan suatu \ndermatofibroma. Dermatofibroma adalah nodul kulit jinak yang muncul ...",
                    "url": "https://www.alodokter.com/komunitas/topic/benjolan-di-tangan-22"
                }
            ]
        }
    },
    "included": [
        {
            "type": "hospitals",
            "attributes": [
                {
                    "coordinates": {
                        "lat": -6.232076999999999,
                        "lng": 106.9103481
                    },
                    "name": "Poli Penyakit Kulit & Kelamin Rs Duren Sawit",
                    "place_id": "ChIJlUGTkLUI7S0RV0z9GFivCE8",
                    "maps_url": "https://www.google.com/maps/search/?api=1&query=-6.232076999999999,106.9103481&query_place_id=ChIJlUGTkLUI7S0RV0z9GFivCE8"
                },
                ...
                {
                    "coordinates": {
                        "lat": -6.2319263,
                        "lng": 106.9093655
                    },
                    "name": "RSKD Duren Sawit",
                    "place_id": "ChIJN_l697SMaS4RDJN8yUWS6jg",
                    "maps_url": "https://www.google.com/maps/search/?api=1&query=-6.2319263,106.9093655&query_place_id=ChIJN_l697SMaS4RDJN8yUWS6jg"
                }
            ]
        }
    ]
}
```
### (GET) ALL User Symptoms [INDEX]

Endpoint ini digunakan untuk mendapatkan seluruh penyakit penderita yang berhasil direkam oleh System.

Gunakan Endpoint berikut:

```
api/users/[id_user]/symptoms/
```

```json
{
    "data": [
        {
            "id": "1",
            "type": "symptom",
            "attributes": {
                "symptom_name": "Melanoma",
                "author": null,
                "created_at": "2021-06-02T08:28:54.756Z",
                "url": null
            },
            "relationships": {
                "user": {
                    "data": {
                        "id": "1",
                        "type": "user"
                    }
                }
            }
        }
    ]
}
```

### (GET) User Specific Symptom [SHOW]

Untuk mendapatkan salah satu gejala spesifik yang diderita Pengguna, gunakan endpoint berikut:

```
api/users/[id_user]/symptoms/[id_user_symptom]
```

```bash
curl -X GET localhost:3000/api/users/1/symptoms/1 \
-H "Authorization: Bearer YOUR_AUTHORIZATION_TOKEN"
```

Response dari Endpoint tersebut:

```json
{
    "data": {
        "id": "234",
        "type": "symptom",
        "attributes": {
            "symptom_name": "Dermatofibroma",
            "author": "Abdul Hakim Ghaniy",
            "created_at": "2021-06-01T21:59:56.635Z",
            "url": null
        },
        "relationships": {
            "user": {
                "data": {
                    "id": "1",
                    "type": "user"
                }
            }
        }
    },
    "included": [
        {
            "id": "1",
            "type": "user",
            "attributes": {
                "full_name": "Abdul Hakim Ghaniy",
                "birthday": "1998-11-28",
                "gender": "pria",
                "email": "ghaniy@kodein.id"
            }
        }
    ]
}
```

---
## ATTENTION:

Karena komplektisitas yang sudah dibuat antara API Symptom dan User, serta saling ketergantungan antar Entitas, untuk meniadakan Fitur Authentication sepertinya akan memakan waktu kembali. Jadi, untuk mengakses resource tersebut tetap diperlukan Header Authentication (Bearer).

> Untuk mengatasi hal tersebut, tim backend akan membuat terlebih dahulu Real Auth Token menggunakan Email terdaftar. **Token tersebut setelah pemberitahuan ini**.

> Tip yang perlu diperhatikan:
> - Fetch Token Bearer untuk mendapatkan ID User, guna mengakses Resource Symptoms.
> - Token menggunakan JWT HS256 Algorithm
> - Setelah di fetch id nya, bisa menggunakan string interpolation pada Endpoint Symptoms. Contoh di Pemrograman Ruby:

```ruby
require 'jwt'

secret_key = "51b681f9ca1662d32191ad8bf08c60e5360874db59daf55be0fb435cce6f12b844d466a6da217aef95078aafbed48d8b45bf32bfff8ea157a52bd8a8af2b4347"

token = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJnaGFuaXlAa29kZWluLmlkIiwianRpIjoiM2ZiODE1MDVmY2E1N2EyNGI4NjMyYjZiNGZhMmM5Y2QiLCJpYXQiOjE2MjI5NjQ4MDQsImV4cCI6MTY1NDUwMDgwNH0.jSNGusvlRwo3AL8SLWpKwQCaPz5vUo70eElVHe0zSLw"

decode = JWT.decode(token, secret_key)
# [{"id"=>1, "email"=>"ghaniy@kodein.id", "jti"=>"cccb4e87acec8043578721b5bba61dd6", "iat"=>1622611624, "exp"=>1654147624}, {"alg"=>"HS256"}]

post_url = "localhost:3000/api/users/#{decode[0]["id"]}/symptoms"
# localhost:3000/api/users/1/symptoms
```

---
AUTHENTICATION

```yml
secret_key: 51b681f9ca1662d32191ad8bf08c60e5360874db59daf55be0fb435cce6f12b844d466a6da217aef95078aafbed48d8b45bf32bfff8ea157a52bd8a8af2b4347

# TOKEN BERLAKU UNTUK SETAHUN
jwt_token: eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZW1haWwiOiJnaGFuaXlAa29kZWluLmlkIiwianRpIjoiM2ZiODE1MDVmY2E1N2EyNGI4NjMyYjZiNGZhMmM5Y2QiLCJpYXQiOjE2MjI5NjQ4MDQsImV4cCI6MTY1NDUwMDgwNH0.jSNGusvlRwo3AL8SLWpKwQCaPz5vUo70eElVHe0zSLw
email: ghaniy@kodein.id
id: 1
```