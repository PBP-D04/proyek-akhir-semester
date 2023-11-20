# Proyek Akhir Semester D04

## Nama Aplikasi: Bookphoria

## Anggota Kelompok
| Nama | NPM | GitHub | E-mail |
| :--------------: | :--------: | :-: | :-: |
| Chelsea Angelica | 2206025722 | teticeci | chelseangelika@gmail.com
| Isa Citra Buana | 2206081465 | isaui | isadestroyed17@gmail.com
| Jocelyn Nathanie Arwin | 2206082171 | jnathanie | jocelyn.nathanie@ui.ac.id
| Mahartha Gemilang | 2206819211 | CyberSleeper | mahartha.gemilang@gmail.com
| Sheryl Ivana W. | 2206824943 |

---

## Cerita dan Manfaat Aplikasi
Aplikasi “Bookphoria” berangkat dari kesadaran untuk meningkatkan pentingnya literasi bagi masyarakat Indonesia yang semakin menurun setiap tahunnya.  Untuk mampu menyampaikan gagasan dengan baik, seseorang harus membudayakan literasi agar gagasan yang disampaikan berlandaskan pada data dan fakta. Aplikasi ini akan memuat beragam pilihan buku dari berbagai penulis yang dilengkapi dengan ulasan serta fitur download e-book (bila tersedia). Kini, Bookphoria sudah dapat diakses melalui website maupun mobile.

## Daftar Modul
- **Account (Gilang)**<br>
Aplikasi Django ini mengatur autentikasi pengguna. Selain itu, juga memungkinkan untuk penggantian password dan pengeditan profil pengguna. Tidak hanya itu, di account, pengguna, dalam hal ini user, dapat melihat riwayat buku yang mereka sukai dan buku yang mereka review. Guest tidak dapat mengakses diarahkan langsung ke halaman login. Admin dapat mengakses halaman ini tetapi tidak memiliki fitur riwayat.

- **Homepage (Isa)**<br>
Aplikasi Django ini berfungsi untuk menampilkan halaman utama antarmuka dataset buku dalam web ini. pada antarmuka tersebut juga disediakan fitur sorting, filter, dan search. Selain itu, juga terdapat opsi untuk fitur carousel-slider untuk buku-buku yang direkomendasikan. Fitur sorting didasarkan pada pilihan paling banyak diulas, paling banyak disukai, terbaru, dan terlama. Sementara itu, fitur filter berupa pemfilteran berdasarkan kategori buku. 

- **Dashboard App (Sheryl)**<br>
Aplikasi Django ini berfungsi untuk menyediakan layanan DML atau lebih dikenal fitur CRUD (Create, Read, Update, Delete). Objek yang dapat di-CRUD adalah buku. Buku yang dapat di-CRUD oleh pengguna tergantung pada otorisasi penggunanya. User hanya bisa melakukan CRUD terhadap buku yang dimilikinya atau dengan kata lain di-filter berdasarkan foreign key yang merujuk pada primary key dari setiap User. Admin tidak dapat melakukan CRUD secara penuh, hanya dapat melakukan perintah DELETE dan READ. Untuk admin, tidak ada batasan filter. Sementara itu, guest tidak dapat mengakses page ini dan akan langsung diarahkan ke halaman login.

- **Review App (Chelsea)**<br>
Aplikasi Django ini menyediakan fitur ulasan user terhadap buku. Ulasan tersebut berupa bintang, komentar (opsional), dan foto buku(opsional). Bintang pada ulasan ini memiliki range dari satu hingga lima. Hanya pengguna bertipe User yang dapat melakukan review terhadap buku. Guest yang mencoba membuat review akan diarahkan ke halaman login. Admin tidak memiliki akses untuk membuat review.

- **Detail Book App (Jocelyn)**<br>
Aplikasi Django ini berfungsi untuk memuat informasi detail mengenai suatu buku atau e-book. Terdapat juga fitur download dalam bentuk PDF (opsional) dan love button untuk menyukai buku. Pada aplikasi ini juga terdapat forum diskusi yang bersifat anonim. Dengan begitu, para pengguna dapat berdiskusi mengenai karya yang sedang dibahas. Selain itu, templat dari Review App untuk buku tersebut akan diletakkan di bagian bawah dari templat aplikasi ini.

## Role Pengguna Aplikasi
- **Guest**<br>
Pengguna yang mengakses web bookphoria tanpa autentikasi

- **User**<br>
Pengguna yang dapat membuat dan mereview buku

- **Admin**<br>
Pengguna yang dapat melakukan manipulasi berupa delete terhadap buku yang dianggap melakukan pelanggaran

## Alur Integrasi dengan Web Service
Kami akan menggunakan beberapa *endpoint* dari tugas tengah semester kami sebagai *web service*. Beberapa di antaranya adalah
- `login/ [name='login']`
- `register/ [name='register']`
- `logout/ [name='logout']`
- `review_list/ [name='review_list']`
- `likes/<int:product_id>/ [name='like_book']`
- `create/ [name='create_profile']`
- `view/ [name='view_profile']`
- `edit_profile/ [name='edit_profile']`
- `edit_profile_data_json/ [name='edit_data_json']`
- `edit_profilejson/ [name='edit_profilejson']`
- `[name='home']`
- `get-books/ [name='get-books']`
- `all-books/ [name='all-books-page']`
- `search-books/<str:category>/<str:search_text>/ [name='search-page']`
- `search-books-json/<str:category>/<str:search_text> [name='search-books-json']`
- `get-categories/ [name='get-categories']`
- `advanced-search-json/ [name='advanced-search']`
- `profile/`
- `detail/`
- `review/`

## Sumber Dataset
- [Google Books API](https://developers.google.com/books/)

## Templat Berita Acara
https://docs.google.com/spreadsheets/d/10ad2B1ybmxXWBpfjTxqleewd1b0HjrJye9OweprG-To/edit?usp=sharing