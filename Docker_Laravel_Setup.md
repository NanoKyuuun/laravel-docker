
# Docker Laravel Setup

Ini adalah panduan untuk menjalankan aplikasi Laravel menggunakan Docker. Dengan menggunakan file `docker-compose.yml` dan `Dockerfile`, kamu dapat mengatur lingkungan pengembangan Laravel dengan cepat tanpa perlu menginstal PHP, MySQL, Composer, atau Node.js secara manual di sistem host kamu.

## Prasyarat

- Docker dan Docker Compose harus terpasang di sistem kamu.
  - Untuk instalasi Docker: [Install Docker](https://docs.docker.com/get-docker/)
  - Untuk instalasi Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Struktur Folder

Berikut adalah struktur folder yang digunakan dalam proyek ini:

```
/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .env
├── public/
├── storage/
└── app/
```

- **Dockerfile**: File konfigurasi untuk membangun image Docker yang berisi PHP, Composer, dan dependensi lainnya.
- **docker-compose.yml**: File konfigurasi untuk mengatur layanan Docker seperti PHP, MySQL, phpMyAdmin, Composer, dan Node.js.
- **.dockerignore**: Menyaring file dan folder yang tidak perlu dimasukkan ke dalam Docker image.
- **public/**: Folder yang berisi file publik untuk aplikasi Laravel.
- **storage/**: Folder tempat Laravel menyimpan file log, cache, dan file yang diupload.

## Menjalankan Laravel dengan Docker

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi Laravel menggunakan Docker:

### 1. **Clone atau Salin Proyek**

Jika kamu belum memiliki proyek Laravel, clone atau buat proyek Laravel terlebih dahulu:

```bash
composer create-project --prefer-dist laravel/laravel laravel-docker
cd laravel-docker
```

Kemudian salin file `Dockerfile`, `docker-compose.yml`, dan `.dockerignore` ke dalam folder proyek Laravel kamu.

### 2. **Konfigurasi `.env`**

Pastikan file `.env` kamu sudah dikonfigurasi dengan benar untuk menghubungkan Laravel dengan database MySQL yang ada di dalam Docker. Sesuaikan dengan konfigurasi berikut:

```dotenv
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laraveluser
DB_PASSWORD=laravelpassword
```

- **DB_HOST=db**: Mengarah ke layanan `db` yang didefinisikan dalam `docker-compose.yml`.

### 3. **Menjalankan Docker Compose**

Setelah memastikan bahwa semua file dan konfigurasi sudah siap, jalankan perintah berikut untuk membangun dan menjalankan layanan Docker:

```bash
docker-compose up --build
```

Perintah ini akan melakukan build ulang image Docker dan menjalankan semua kontainer (PHP, MySQL, phpMyAdmin, Composer, dan Node.js).

### 4. **Akses Aplikasi Laravel**

Setelah Docker selesai membangun dan menjalankan kontainer, kamu bisa mengakses aplikasi Laravel di browser dengan membuka URL berikut:

```
http://localhost:8000
```

Aplikasi Laravel akan berjalan di port 8000 di host lokal kamu.

### 5. **Akses phpMyAdmin**

Untuk mengelola database MySQL melalui antarmuka grafis, kamu bisa mengakses phpMyAdmin di URL berikut:

```
http://localhost:8081
```

Login menggunakan username `root` dan password `root`.

### 6. **Migrasi Database**

Jika kamu perlu menjalankan migrasi database untuk aplikasi Laravel, masuk ke dalam kontainer `app` dan jalankan perintah Artisan:

```bash
docker-compose exec app bash
php artisan migrate
```

Perintah ini akan membuat tabel-tabel yang diperlukan di database MySQL.

### 7. **Menjalankan Node.js**

Jika aplikasi Laravel kamu menggunakan Node.js untuk pengelolaan frontend, kamu bisa menginstal dependensi dan menjalankan build dengan perintah berikut:

```bash
docker-compose exec node sh
npm install
npm run dev
```

### 8. **Memeriksa Log Kontainer**

Jika ada masalah atau kesalahan, kamu bisa memeriksa log dari masing-masing kontainer:

```bash
docker-compose logs app
docker-compose logs db
docker-compose logs phpmyadmin
docker-compose logs node
```

### 9. **Membersihkan Kontainer dan Volume**

Jika kamu ingin membersihkan kontainer, volume, dan jaringan yang telah dibuat oleh Docker Compose, jalankan perintah berikut:

```bash
docker-compose down --volumes --remove-orphans
```

### 10. **Pengaturan File `.dockerignore`**

File `.dockerignore` digunakan untuk mengecualikan file dan folder yang tidak perlu disalin ke dalam Docker image. Ini akan mengurangi ukuran image dan meningkatkan keamanan proyek kamu.

Contoh file `.dockerignore` telah disediakan dan akan mengecualikan file seperti:

- `vendor/` dan `node_modules/` (karena dependensi akan diinstal di dalam kontainer).
- `.env`, `.git`, dan folder lainnya yang tidak perlu ada dalam image Docker.

### 11. **Menggunakan Volume untuk Penyimpanan Data**

Docker Compose sudah mengonfigurasi volume untuk database MySQL, yang berarti data akan disimpan di luar kontainer dan dapat bertahan meskipun kontainer dihentikan atau dihapus. Volume untuk database disimpan dalam `mysql_data` yang didefinisikan di bagian `volumes` dari file `docker-compose.yml`.

## Masalah Umum dan Solusi

1. **Masalah Koneksi Database**:
   - Pastikan database sudah berjalan dan konfigurasi di file `.env` sudah benar.
   - Periksa log kontainer `db` dengan `docker-compose logs db` untuk melihat apakah ada masalah dengan MySQL.

2. **Masalah Storage di Laravel**:
   - Jika ada masalah dengan folder `public/storage`, pastikan kamu menjalankan perintah `php artisan storage:link` di dalam kontainer `app` untuk membuat symbolic link yang diperlukan.

Dengan mengikuti panduan ini, kamu dapat dengan mudah menjalankan aplikasi Laravel menggunakan Docker. Jika ada masalah lebih lanjut, periksa log kontainer atau berikan detail kesalahan untuk bantuan lebih lanjut.

Happy coding! 🚀
