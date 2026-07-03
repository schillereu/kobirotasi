# Form ve Alan Adi Kurulum Notu

Bu proje su anda GitHub Pages uzerinde ucretsiz yayinda:

```text
https://schillereu.github.io/kobirotasi/
```

## Form Servisi

`ihtiyac-analizi.html` formu Netlify Forms uyumlu hale getirildi.

- Form adi: `ihtiyac-analizi`
- HTML uzerinde `data-netlify="true"` ve `form-name` alanlari var.
- Netlify'ye deploy edildiginde form kayitlari Netlify paneline duser.
- GitHub Pages uzerinde calisirken form kullanicinin cihazinda ozet olusturur ve `tesekkur.html` sayfasina yonlendirir.

Netlify Forms'un calismasi icin:

1. Netlify hesabi ac.
2. GitHub reposunu Netlify'ye bagla.
3. Build ayari gerekmiyor; publish klasoru `.` olmali.
4. Netlify panelinde Forms bolumunden form detection'i etkinlestir.
5. Siteyi tekrar deploy et.

## Alan Adi

Ozel alan adi icin alan adina sahip olmak gerekir. Ucretsiz yayin secenekleri:

- GitHub Pages: `https://schillereu.github.io/kobirotasi/`
- Netlify alt alani: `https://secilecek-ad.netlify.app`

Satin alinmis bir domain varsa, ornek:

```text
www.kobirotasi.com
```

su komutla GitHub Pages tarafina eklenebilir:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\set-custom-domain.ps1 -Domain www.kobirotasi.com
```

Sonra domain panelinde `www` icin CNAME kaydi GitHub Pages hedefine yonlendirilir:

```text
schillereu.github.io
```

Alan adi satinalinmadan veya DNS paneline erisim olmadan bu adim tamamlanamaz.
