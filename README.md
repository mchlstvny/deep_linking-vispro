> ReadME Step 11 ada di folder `deep_link_demo`.<br>

## Step 13: Wrap-Up Summary

Deep linking menghubungkan navigasi Flutter dengan **intent filter Android**, sehingga aplikasi bisa dibuka dari luar menggunakan URL atau scheme tertentu. Contoh penggunaan praktisnya adalah ketika membuka aplikasi dari **notifikasi, link yang dibagikan, atau redirect dari proses autentikasi** (aplikasi langsung menampilkan halaman yang sesuai tanpa harus melalui layar awal). Tantangan yang saya temukan adalah untuk memastikan **intent filter di AndroidManifest.xml** dan parsing link di Flutter sesuai format, karena jika tidak tepat, navigasi tidak akan terjadi. Solusinya adalah memeriksa manifest dan menyesuaikan parsing di `_handleIncomingLink()`, menggunakan package `app_links` yang kompatibel dengan Flutter versi terbaru, serta memastikan **AppBar dan body Text** ditampilkan dengan benar di halaman detail agar link yang diterima terlihat pengguna.

