/**
 * Mesafeli Satış Sözleşmesi (6502 sayılı Tüketicinin Korunması Hakkında Kanun)
 * Son Güncelleme: 24 Ekim 2025
 */

export interface DistanceSalesContractData {
  contractNumber: string;
  date: string;
  userName: string;
  userEmail: string;
  userPhone: string;
  userAddress: string;
  planName: string;
  planPeriod: string;
  amount: number;
  currency: string;
  paymentMethod: string;
  transactionId: string;
}

export const generateDistanceSalesContract = (data: DistanceSalesContractData) => ({
  title: "MESAFELİ SATIŞ SÖZLEŞMESİ",
  contractNumber: data.contractNumber,
  date: data.date,
  sections: [
    {
      id: "1",
      title: "MADDE 1 - TARAFLAR",
      content: `**1.1. SATICI BİLGİLERİ:**

Ünvanı: Diligent Computer System & Digital Commerce
Telefon: +905359216894
E-posta: info@davetim.app

**1.2. ALICI BİLGİLERİ:**

Ad Soyad: ${data.userName}
E-posta: ${data.userEmail}
Telefon: ${data.userPhone}`
    },
    {
      id: "2",
      title: "MADDE 2 - SÖZLEŞMENİN KONUSU",
      content: `İşbu Sözleşme'nin konusu, ALICI'nın SATICI'ya ait davetim.app internet sitesi üzerinden elektronik ortamda siparişini yaptığı aşağıda nitelikleri ve satış fiyatı belirtilen hizmetin satışı ve teslimi ile ilgili olarak 6502 sayılı Tüketicinin Korunması Hakkında Kanun ve Mesafeli Sözleşmeler Yönetmeliği hükümleri gereğince tarafların hak ve yükümlülüklerinin saptanmasıdır.`
    },
    {
      id: "3",
      title: "MADDE 3 - HİZMET BİLGİLERİ",
      content: `**Hizmet Adı:** ${data.planName} Plan
**Abonelik Süresi:** ${data.planPeriod}
**Toplam Ücret:** ${data.amount} ${data.currency} (KDV Dahil)
**Ödeme Şekli:** ${data.paymentMethod}
**İşlem No:** ${data.transactionId}
**Teslimat Şekli:** Elektronik ortamda anında
**Hizmet Başlangıç:** Ödeme onayı sonrası anında

**Hizmet Kapsamı:**
${getServiceFeatures(data.planName)}

**Önemli Notlar:**
• Bu bir dijital hizmet satışıdır
• Hizmet, ödeme onayı sonrası anında aktif hale gelir
• Kullanım süresi boyunca erişim sağlanır
• Tek seferlik ödemedir, otomatik yenileme yoktur
• Dönem bitiminde manuel yenileme gerekir`
    },
    {
      id: "4",
      title: "MADDE 4 - GENEL HÜKÜMLER",
      content: `ALICI, davetim.app internet sitesinde sözleşme konusu hizmetin temel nitelikleri, satış fiyatı ve ödeme şekli ile teslimat ile ilgili ön bilgileri okuyup bilgi sahibi olduğunu ve elektronik ortamda gerekli teyidi verdiğini beyan eder.

ALICI'nın platform üzerinde işbu sözleşmeyi elektronik ortamda onaylaması, mesafeli satış sözleşmesi kurulmadan önce, SATICI tarafından ALICI'ya verilmesi gereken adresi, siparişi verilen ürünlere/hizmetlere ait temel özellikleri, vergiler dahil ücret bilgilerini doğru ve eksiksiz olarak edindiğini ve bu bilgileri elektronik ortamda teyit ettiğini kabul, beyan ve taahhüt eder.`
    },
    {
      id: "5",
      title: "MADDE 5 - CAYMA HAKKI",
      content: `**5.1. Cayma Hakkı Süresi:**
ALICI, sözleşme tarihinden itibaren 3 (üç) gün içinde hiçbir gerekçe göstermeksizin ve cezai şart ödemeksizin cayma hakkına sahiptir. (6502 sayılı Tüketicinin Korunması Hakkında Kanun, Madde 47)

**5.2. Cayma Hakkının Kullanılması:**
Cayma hakkının kullanılması için bu süre içinde SATICI'ya yazılı olarak veya kalıcı veri saklayıcısı (e-posta, platform hesap ayarları vb.) ile bildirimde bulunulması gerekmektedir.

**5.3. Cayma Hakkı Bildirimi:**
• E-posta: info@davetim.app
• Telefon: +905359216894
• Platform: Hesap Ayarları > Abonelik Yönetimi > İptal Et

**5.4. Cayma Hakkının Sonuçları:**
Cayma hakkının kullanılması durumunda:
• Ödenen tutar 10 (on) iş günü içinde ALICI'ya tam olarak iade edilir
• Hizmet erişimi derhal sonlandırılır ve hesap FREE plana düşürülür
• Kredi kartına iadeler, banka tarafından hesaba yansıtılır (2-4 hafta sürebilir)
• Kullanım yapılmış olsa bile 3 gün içinde cayma hakkı kullanılabilir

**5.5. Dijital Hizmet Özelliği:**
6502 sayılı Kanun'un 15. maddesi gereğince dijital içerik sunumuna başlanmış olması cayma hakkını kısıtlayabilir. Ancak:
• 3 günlük yasal cayma süresi her durumda korunur
• ALICI, kullanım yapmış olsa bile 3 gün içinde cayma hakkını kullanabilir
• Cayma durumunda ödenen tutar tam olarak iade edilir`
    },
    {
      id: "6",
      title: "MADDE 6 - SATICI'NIN HAK VE YÜKÜMLÜLÜKLERİ",
      content: `**6.1. Satıcı Yükümlülükleri:**
• Hizmeti, sözleşmede belirtilen niteliklere uygun olarak sunmak
• Platform güvenliğini ve veri gizliliğini sağlamak
• Teknik destek hizmeti vermek
• ALICI'nın haklarını korumak
• Yasal mevzuata uymak

**6.2. Satıcı Hakları:**
• Hizmet koşullarını değiştirme (önceden bildirerek)
• Kötüye kullanım durumunda hesabı askıya alma
• Yasal yükümlülükler için gerekli bilgileri sakla ma
• Ödeme tahsil etme`
    },
    {
      id: "7",
      title: "MADDE 7 - ALICI'NIN HAK VE YÜKÜMLÜLÜKLERİ",
      content: `**7.1. Alıcı Yükümlülükleri:**
• Sözleşme bedelini ödemek
• Kullanım koşullarına uymak
• Hesap güvenliğini sağlamak
• Doğru ve güncel bilgiler vermek
• Hizmeti yasalara uygun kullanmak

**7.2. Alıcı Hakları:**
• Cayma hakkı (3 gün)
• Kişisel verilerin korunmasını isteme
• Teknik destek alma
• Hizmetin kesintisiz sunumunu talep etme
• Şikayet ve itiraz hakkı`
    },
    {
      id: "8",
      title: "MADDE 8 - ÖDEME VE TESLİMAT",
      content: `**8.1. Ödeme:**
ALICI, sözleşme konusu hizmet bedelini, belirtilen ödeme yöntemi ile ödemeyi kabul ve taahhüt eder.

**8.2. Teslimat:**
Hizmet, ödeme onayı sonrasında elektronik ortamda anında teslim edilir. Kullanıcı hesabı, abonelik süresi boyunca aktif kalır.

**8.3. Ödeme Sorunları:**
Kredi kartı ile ödeme yapılması halinde, kartın kullanıma uygun olmaması veya banka tarafından işlemin onaylanmaması durumunda, SATICI'nın hizmeti sunma yükümlülüğü doğmaz.`
    },
    {
      id: "9",
      title: "MADDE 9 - ÖDEME GÜVENLİĞİ",
      content: `ALICI, bu sözleşmedeki ödeme işlemlerinde kullanacağı kredi kartının kendi adına düzenlenmiş olduğunu, hukuka aykırı kartın kullanımından kaynaklanan zararlar konusunda sorumlu olduğunu kabul, beyan ve taahhüt eder.

Kredi kartı bilgileri, PCI DSS standartlarına uygun şekilde, güvenli ödeme altyapısı (İyzico) üzerinden işlenir. SATICI, kredi kartı bilgilerini saklamaz.`
    },
    {
      id: "10",
      title: "MADDE 10 - UYUŞMAZLIKLARIN ÇÖZÜMÜ",
      content: `İşbu Sözleşme'den kaynaklanan uyuşmazlıklarda;

**Tüketici Hakem Heyetleri:**
• 2023 yılı için: 93.380 TL'ye kadar
• İl ve İlçe Tüketici Hakem Heyetleri başvurulabilir

**Tüketici Mahkemeleri:**
• ALICI'nın veya SATICI'nın yerleşim yerindeki Tüketici Mahkemeleri yetkilidir

**Başvuru Süreleri:**
• Hizmetin teslim tarihinden itibaren 3 (üç) yıl içinde
• Cayma hakkı: 3 (üç) gün içinde`
    },
    {
      id: "11",
      title: "MADDE 11 - KİŞİSEL VERİLERİN KORUNMASI",
      content: `ALICI'ya ait kişisel veriler, 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") ve ilgili mevzuat hükümlerine uygun olarak işlenmektedir. Detaylı bilgi için Gizlilik Politikası'na bakınız.

ALICI, kişisel verilerinin işlenmesine açık rıza göstermektedir.`
    },
    {
      id: "12",
      title: "MADDE 12 - YÜRÜRLÜKİ ONAY",
      content: `ALICI, işbu sözleşmeyi elektronik ortamda onaylamakla, sözleşme konusu hizmetin türü, miktarı, marka/modeli, satış bedeli, ödeme şekli, teslimat koşulları ve cayma hakkı ile ilgili tüm ön bilgileri okuduğunu, anladığını ve sözleşme ile bağlı olduğunu kabul, beyan ve taahhüt eder.

**Sözleşme Tarihi:** ${data.date}
**Sözleşme No:** ${data.contractNumber}
**Onay Yöntemi:** Elektronik (Ödeme onayı ile)

İşbu sözleşme 14 (on dört) maddeden ibaret olup, taraflarca elektronik ortamda onaylanmış ve yürürlüğe girmiştir.

**SATICI:**
Diligent Computer System & Digital Commerce

**ALICI:**
${data.userName}
${data.userEmail}`
    }
  ]
});

function getServiceFeatures(planName: string): string {
  const features: Record<string, string> = {
    "FREE": `• 1 adet dijital davetiye (tek kullanım)
• 5 temel şablona erişim
• PDF/PNG indirme ve link paylaşımı
• RSVP takibi (50 misafir)
• 5 MB depolama, watermark'lı yayın`,
    
    "PRO": `• Aylık 3 dijital davetiye
• PRO seviyesi şablonlar
• Görsel yükleme ve renk özelleştirme
• Sosyal medya paylaşımı + Excel export
• Sınırsız RSVP ve 100 MB depolama`,
    
    "PREMIUM": `• Sınırsız dijital davetiye
• Premium şablonlar ve PRO özellikleri
• QR medya yükleme (3 ay / yıllıkta 12 ay)
• 24/7 öncelikli destek
• Watermark'sız yayın ve 500 MB depolama`
  };

  return features[planName.toUpperCase()] || features["FREE"];
}

