const form = document.getElementById('assessmentForm');
const result = document.getElementById('assessmentResult');

const categoryMap = {
    crm: {
        title: "CRM ile basla",
        text: "Musteri ve satis takibi daginiksa ilk rota CRM olmali. Once basit bir pipeline kur, sonra teklif ve takip adimlarini olc.",
        link: "index.html#blog",
        cta: "CRM araclarini incele"
    },
    accounting: {
        title: "Muhasebe akisini duzenle",
        text: "Fatura ve rapor gecikiyorsa once muhasebe kategorisine odaklan. Gelir, gider ve fatura surecini tek panelde toplamayi hedefle.",
        link: "index.html#blog",
        cta: "Muhasebe araclarini incele"
    },
    marketing: {
        title: "Pazarlama ritmi kur",
        text: "Takip ve tekrar eden talep eksikse e-posta ve sosyal medya planlama araclariyla basla. Ilk hedef haftalik yayin ritmi.",
        link: "index.html#blog",
        cta: "Pazarlama araclarini incele"
    },
    support: {
        title: "Destegi tek gelen kutusuna tasi",
        text: "Musteri sorulari kanallara dagiliyorsa destek araci en hizli kazanci verir. Once e-posta destek kanalini merkeze al.",
        link: "index.html#blog",
        cta: "Destek araclarini incele"
    }
};

function buildAdvice(problem, team, budget) {
    const base = categoryMap[problem];
    const teamAdvice = {
        starter: "Baslangicta ucretsiz plan ve tek ekip sorumlusu yeterli.",
        growing: "Buyuyen ekip icin roller, bildirim kurallari ve haftalik rapor ekle.",
        scale: "Yetki, entegrasyon ve raporlama ozelliklerini bastan kontrol et."
    }[team];
    const budgetAdvice = {
        free: "Once ucretsiz planla dene; 14 gunluk kullanimdan sonra karar ver.",
        balanced: "Fiyat/performans icin aylik maliyet ve zaman kazancini birlikte degerlendir.",
        premium: "Profesyonel destek ve veri tasima hizmeti sunan planlari one al."
    }[budget];

    return { ...base, teamAdvice, budgetAdvice };
}

if (form && result) {
    form.addEventListener('submit', (event) => {
        event.preventDefault();
        const data = new FormData(form);
        const advice = buildAdvice(data.get('problem'), data.get('team'), data.get('budget'));

        result.innerHTML = `
            <p class="eyebrow">Onerilen rota</p>
            <h2>${advice.title}</h2>
            <p>${advice.text}</p>
            <ul class="result-list">
                <li>${advice.teamAdvice}</li>
                <li>${advice.budgetAdvice}</li>
                <li>Ilk hafta sadece bir sureci sisteme tasi; tum isletmeyi ayni anda donusturmeye calisma.</li>
            </ul>
            <a class="primary-link" href="${advice.link}">${advice.cta}</a>
        `;
    });
}
