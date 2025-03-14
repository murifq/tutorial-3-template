**Tutorial 4**


Fitur

**1. Double Jump**

Pemain dapat melompat hingga dua kali sebelum menyentuh tanah kembali. Logika lompatan adalah sebagai berikut:

* Jika pemain berada di tanah, jump_count direset ke 0.

* Ketika pemain menekan "ui_up" dan belum melebihi batas max_jumps, pemain melompat dengan mengatur velocity.y ke jump_speed.

* jump_count bertambah setiap kali melompat.

* Animasi diperbarui ke "jump".

**2. Dashing**

Pemain dapat melakukan dash ke arah mana pun menggunakan mekanisme double-tap:

* Jika pemain mengetuk "ui_left" atau "ui_right" dua kali dalam waktu dash_input_time, dash akan diaktifkan.

* Kecepatan dash ditentukan oleh dash_speed dan berlangsung selama dash_duration detik.

* Cooldown (dash_cooldown) mencegah dash terus-menerus.

* Pemain mempertahankan arah dash yang sama hingga durasinya berakhir.

**3. Crouching**

Pemain dapat merunduk saat berada di tanah menggunakan "ui_down":

* Fungsi crouch() mengubah bentuk collision ke keadaan crouching dan memperbarui posisi.

* Kecepatan gerakan berkurang menjadi crouch_speed.

* Animasi diperbarui ke "crouch".

* Jika pemain melepaskan "ui_down", fungsi stand() mengembalikan bentuk collision ke posisi berdiri dan mereset animasi.

**4. Animasi (polishing)**

Fungsi update_animation(state) memperbarui animasi AnimatedSprite2D berdasarkan status pergerakan pemain.

**Sumber**
* Daril
* ChatGPT

**Tutorial 5**

Saya menambahkan karakter enemy baru bertipe CharacterBody2D. Saya juga mencari assets karakter baru, lalu meng-animasikannya sesuai dengan tutorial. Saya juga menambahkan audio player untuk menyetel background music, dan mengganti music yang dimainkan sesuai dengan jarak antara player dan enemy (merupakan fitur polishing). Lalu, setiap kali player menyerang enemy, maka akan diplay soundeffect suara menyerang. 

Assets:
* https://kenney.nl/assets/toon-characters-1

Audio Assets:
* https://freesound.org/people/guillermochicasonido/sounds/691652/
* https://freesound.org/people/guillermochicasonido/sounds/691651/
* https://kenney.nl/assets/rpg-audio
