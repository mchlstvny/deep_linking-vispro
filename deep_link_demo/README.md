# Step 11: Reflection Questions

## Concept Check

**1. Bedanya route di Flutter sama deep link di Android**  
- **Route Flutter**: Jalur navigasi di dalam aplikasi pakai `Navigator`, cuma berlaku di dalam app itu sendiri.  
- **Deep link Android**: URL (misal: `myapp://details/42`) yang bisa buka aplikasi dari luar, misal dari browser, email, atau aplikasi lain, lewat **intent**.

**2. Kenapa Android membutuhkan intent filter**  
- Intent filter bilang ke Android URL atau scheme apa yang bisa dibuka oleh aplikasi.  
- Kalau tidak ada, Android tidak akan tahu aplikasi mana yang harus dibuka saat deep link diklik.

---

## Technical Understanding

**1. Fungsi paket `app_links`**  
- Paket `app_links` bikin Flutter bisa menangani deep link dari level platform:  
  - `getInitialAppLink()` → untuk link saat aplikasi baru dibuka (cold start).  
  - `uriLinkStream` → untuk link saat aplikasi sedang jalan (foreground).

> **Catatan:** Saya pakai `app_links` karena `uni_links` tidak kompatibel sama Flutter versi terbaru. Fungsinya sama, yaitu menangani deep link baik saat aplikasi baru dibuka maupun saat sudah berjalan.

**2. Apa yang terjadi kalau deep link dibuka saat aplikasi sudah jalan**  
- Link diterima lewat **stream listener (`uriLinkStream`)**, jadi navigasi ke halaman terkait bisa langsung terjadi tanpa perlu restart aplikasi.

---

## Debugging Insight

**Kalau `adb` buka aplikasi tapi tidak navigasi ke halaman detail:**  

1. **Cek AndroidManifest.xml**  
   - Pastikan **scheme** (`myapp`) dan **host/path** sesuai sama yang dipakai di Flutter.  
   - Tanpa intent filter yang benar, aplikasi bisa terbuka tapi Flutter tidak mendapatkan link.

2. **Cek kode Flutter di `_handleIncomingLink()`**  
   - Pastikan parsing `pathSegments` atau `queryParameters` sesuai format URL.  
   - Kalau parsing salah, navigasi ke halaman detail tidak akan jalan.
