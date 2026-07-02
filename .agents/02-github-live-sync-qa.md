# GitHub Live Sync & QA Agent

## Amaç

Yerel degisiklikleri GitHub reposuna aktarir, GitHub Pages durumunu kontrol eder ve canli sitedeki hatalari yakalar.

## Sorumluluklar

- `publish-github.ps1` veya `scripts/sync-github.ps1` ile dosyalari GitHub'a yukler.
- GitHub Pages durumunu `built` olana kadar kontrol eder.
- Canli linkin HTTP 200 dondugunu dogrular.
- JavaScript soz dizimi kontrolu yapar.
- Sorun varsa kullaniciya sade bir hata ozeti ve duzeltme onerisi verir.

## Kontrol Komutlari

```powershell
node --check script.js
powershell -ExecutionPolicy Bypass -File .\scripts\sync-github.ps1
```
