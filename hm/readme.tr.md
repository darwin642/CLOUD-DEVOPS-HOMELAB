# ☁️ Dürüst Değerlendirme — Azure vs AWS vs GCP

> Cloud ve DevOps öğrenme yolculuğum sırasında üzerinde çalıştığım üç cloud platformunun kişisel, uygulamalı karşılaştırması.

Bu sayfa, **Microsoft Azure, Amazon Web Services (AWS) ve Google Cloud Platform (GCP)** ile altyapı oluştururken, yapılandırırken, sorun giderirken ve yönetirken edindiğim deneyimleri belgelemektedir.

Karşılaştırma, teorik benchmark'lar veya pazarlama materyalleri yerine kendi pratik deneyimlerime dayanmaktadır.

> [!WARNING]
> Eğer bu sayfadaysan, ya dokümantasyonumu tamamen okudun ya da buraya yanlışlıkla geldin. Eğer neye baktığını bilmiyorsan lütfen geri dön. Burası sonlandırılmış görüşler sayfasıdır; burada öğrenilecek bir şey yok.

---

# 🎯 Cloud / DevOps Yolunu Neden Seçtim?

Cloud ve **DevOps** yönüne ilerleme kararım hem kariyer fırsatlarından hem de daha büyük altyapılarla çalışma isteğimden kaynaklandı.

Ülkemdeki geleneksel IT fırsatlarının nispeten sınırlı olması nedeniyle klasik IT support alanının ötesine geçmek istedim.

IT geçmişim bana şu konularda bir temel kazandırdı:

* Troubleshooting
* İşletim sistemleri
* Kullanıcı desteği
* Donanım
* Networking
* Teknik problem çözme

Ancak **daha büyük sistemler ve altyapılarla** çalışmak istiyordum.

Bu nedenle şu alanlara yöneldim:

* ☁️ Cloud Infrastructure
* 🌐 Networking
* 🔐 Identity and Access Management
* ⚙️ Automation
* 🧱 Infrastructure as Code
* 📊 Monitoring
* ♻️ High Availability
* 📈 Scalability
* 📦 Containers
* 🔄 DevOps workflows

Amacım yalnızca sertifika toplamak değildi.

Altyapıyı şu şekilde anlayarak öğrenmek istedim:

```text
Build
  ↓
Configure
  ↓
Break
  ↓
Troubleshoot
  ↓
Fix
  ↓
Destroy
  ↓
Rebuild
```

---

# ☁️ Cloud Öğrenimim Nerede Başladı?

Planlı cloud öğrenimim **Microsoft Azure** ile başladı.

Cloud altyapısını **Ağustos 2026'da AZ-104 müfredatı** üzerinden çalışmaya başladım.

AZ-104 müfredatı, cloud administration öğrenimimin yapılandırılmış temeli oldu. Bana şu alanları anlamak için pratik bir çerçeve sağladı:

* Azure Virtual Networks
* Subnets and IP addressing
* Network Security
* Virtual Machines
* Storage
* Identity and RBAC
* Monitoring
* Backup
* High Availability
* Governance
* Security

> **Önemli:** Bu, AZ-104 sertifikasını aldığım anlamına gelmez. AZ-104 müfredatı, başlangıçtaki cloud administration bilgimi geliştirmek için kullandığım yapılandırılmış öğrenme yoluydu.

Bu ilk Azure dönemimde temel teknik öğrenme kaynağım **Microsoft Learn** oldu.

---

## 🗺️ İlk Öğrenme Yol Haritam

Cloud yolculuğumun başında **neyi, hangi sırayla öğrenmem gerektiğini ve teorik bilgiyi pratik deneyime nasıl dönüştüreceğimi** anlamak için yapılandırılmış bir yönteme ihtiyacım vardı.

Aşağıdaki ekran görüntüsü, cloud öğrenme yolculuğumun başındaki öğrenme yol haritamı ve çalışma yaklaşımımı göstermektedir.

![Cloud learning roadmap](startfinish.png)

---

# 🧪 Nasıl Öğrendim?

Öğrenme sürecim ağırlıklı olarak **hands-on ve deney yapmaya dayalıydı**.

Şunları kullandım:

* Microsoft Learn
* Official cloud documentation
* ChatGPT
* Google Gemini
* Microsoft Copilot
* YouTube
* Kendi home lab'larım

AI araçlarını yalnızca yapılandırmaları kopyalamak için değil, **etkileşimli öğrenme yardımcıları** olarak kullandım.

Tipik öğrenme döngüm şöyleydi:

```text
Learn
   │
   ▼
Build
   │
   ▼
Configure
   │
   ▼
Test
   │
   ▼
Break
   │
   ▼
Troubleshoot
   │
   ▼
Fix
   │
   ▼
Destroy
   │
   ▼
Rebuild
   │
   ▼
Document
```

Bilerek altyapılar oluşturdum, yapılandırmaları değiştirdim, problemler oluşturdum, hataları araştırdım, düzelttim, ortamları sildim ve yeniden oluşturdum.

Bu yaklaşım, yalnızca **bir şeyin nasıl çalıştığını değil**, **neden çalıştığını ve çalışmadığında ne olduğunu** anlamama yardımcı oldu.

---

# ☁️ Azure → AWS → GCP

Azure ve AZ-104 müfredatıyla başlangıç seviyesindeki temelimi oluşturduktan sonra öğrenimimi **AWS** ve daha sonra **GCP** ile genişlettim.

Amacım, yaygın altyapı kavramlarının farklı cloud ekosistemlerinde nasıl uygulandığını anlamaktı.

Öğrenme yolum yaklaşık olarak şöyle gelişti:

```text
AZ-104 Curriculum
        │
        ▼
Microsoft Azure
        │
        ▼
AWS
        │
        ▼
GCP
        │
        ▼
Terraform / Infrastructure as Code
        │
        ▼
Docker / DevOps Workflows
```

Platformlar arasında hangi kavramların aynı kaldığını ve aynı problemin farklı platformlarda nasıl ele alındığını görmek istedim.

---

# 🟦 Microsoft Azure

Cloud öğrenimim Azure ile başladı.

Pratik Azure çalışmalarım şunları içeriyordu:

* Virtual Networks
* Subnets
* Network Security Groups
* Virtual Machines
* Routing
* Storage
* Private Endpoints
* Managed Identities
* RBAC
* Monitoring
* Backup
* Azure CLI
* Windows Server
* Hybrid connectivity

Azure aynı zamanda cloud administration konusunda yapılandırılmış bir anlayış geliştirmeye başladığım platform oldu.

---

# 🟧 Amazon Web Services

Azure'dan sonra, eşdeğer altyapı kavramlarını başka büyük bir cloud ekosisteminde anlamak için AWS'ye geçtim.

AWS çalışmalarım şunları içeriyordu:

* VPC
* Public and private subnets
* Internet Gateway
* Route Tables
* EC2
* Application Load Balancer
* Security Groups
* IAM
* Systems Manager
* VPC Endpoints
* CloudWatch
* SNS
* S3
* Backup
* Multi-AZ architecture
* Terraform

AWS ile çalışmak şu kavramları karşılaştırmama olanak sağladı:

* Azure VNets vs AWS VPCs
* Azure RBAC vs AWS IAM
* Azure Load Balancing vs AWS load balancing services

---

# 🟨 Google Cloud Platform

GCP, karşılaştırmayı Azure ve AWS'nin ötesine taşımak için daha sonra eklendi.

GCP çalışmalarım şunları içeriyordu:

* VPC
* Public and private subnets
* Compute Engine
* Global Application Load Balancer
* Managed Instance Groups
* Autoscaling
* Cloud Storage
* Lifecycle Management
* IAM
* Service Accounts
* Cloud DNS
* Private Google Access
* Cloud Monitoring
* Alerting
* Backup and Disaster Recovery
* Private connectivity

Bu çalışmalar networking, compute, identity, load balancing ve monitoring'in cloud ortamında nasıl uygulandığına dair farklı bir bakış açısı kazanmamı sağladı.

---

# ⚖️ Azure vs AWS vs GCP — Pratik Karşılaştırma

Burası bu sayfanın ana ve **acımasız karşılaştırma** bölümüdür.

Amaç **objektif bir sektör sıralaması oluşturmak değildir**.

Bunun yerine platformları, aşağıdaki alanları kullanırken kendi deneyimlerime göre karşılaştırıyorum:

* Console
* CLI tools
* Networking systems
* IAM models
* Monitoring tools
* Documentation
* Troubleshooting workflows

Karşılaştırma şu alanlara odaklanmaktadır:

|  # | Alan                         |
| -: | ---------------------------- |
| 01 | 🖥️ GUI / Console Experience |
| 02 | 🧭 Navigation                |
| 03 | 📚 Documentation             |
| 04 | 💻 CLI Experience            |
| 05 | 🌐 Network Management        |
| 06 | 🔐 IAM & Authorization       |
| 07 | 📊 Monitoring                |
| 08 | 🛠️ Troubleshooting          |
| 09 | 📈 Learning Curve            |
| 10 | 👤 Overall User Experience   |
| 11 | 🤖 AI-Assisted Experience    |

---

# 🖥️ GUI / Console Deneyimi

## 🟦 Azure

**Deneyimim:**

> Şimdiye kadar gördüğüm en iyi UI. Bir ortam oluşturmak için neye ihtiyacın olduğunu doğrudan gösteriyor. Temaları seçebiliyoruz. Herhangi bir ortamı karmaşa yaşamadan seçebiliyoruz. 10/10

## 🟧 AWS

**Deneyimim:**

> Yeni bir entity oluştururken ismi otomatik oluşturmuyor; kendiniz yazsanız bile tekrar isim vermeniz gerekiyor. İsim karmaşası gerçekten var çünkü işleri zorlaştırmak istemediğinizde bile size isim yerine ID numarasını gösteriyor ve bu GUI açısından büyük bir dezavantaj. Ne demek 10 dakika önce oluşturduğum makineyi 100'den fazla makinenin bulunduğu bir listede bulmak zorundayım? Filtre ayarlamak için zaman harcamak istemiyorum. 4/10

## 🟨 GCP

**Deneyimim:**

> Google Pixel'in Android 11 ayarlar menüsü gibi. Google'dan beklenmeyecek derecede sıkıcı. 6/10

### Doğrudan Karşılaştırma

> Çok fazla command line ile uğraşmayı sevmiyorsanız GUI üzerinden yine her işi yapabilirsiniz ancak her tasarım beklenildiği kadar iyi değil. Bu nedenle: Azure → GCP → AWS.

---

# 🧭 Navigation

## 🟦 Azure

**Deneyimim:**

> Çok fazla söylenecek bir şey yok. Basit. Microsoft'un kendi ürünlerine ve geleneklerine önem vermesi güzel; örneğin PowerShell console'u Bash ile birlikte sunması. Tam olarak Bash öğrenmek zorunda değilsiniz. 10/10

## 🟧 AWS

**Deneyimim:**

> Azure kadar basit. 10/10

## 🟨 GCP

**Deneyimim:**

> Ne demek kurduğum bir VM'ye erişmek için API yüklemem gerekiyor? 5/10

### Doğrudan Karşılaştırma

> Açıklamaya gerek yok. Azure = AWS > GCP.

---

# 💻 CLI Deneyimi

## 🟦 Azure

**Deneyimim:**

> Ücretsiz subscription'ım varsa neden "az" bana ait değil? Neden tenant ID ve subscription ID almam gerekiyor? 9/10

## 🟧 AWS

**Deneyimim:**

> Özel bir şey yok. Her şey iyi. 10/10

## 🟨 GCP

**Deneyimim:**

> AWS ile aynı. 10/10

### Doğrudan Karşılaştırma

> Tüm CLI'lar ve console'lar iyi ancak Microsoft, az command line'ın ücretsiz subscription'ı algılamaması sorununu düzeltirse biraz daha iyi olabilir. AWS=GCP>Azure

---

# 🛠️ Troubleshooting

## 🟦 Azure

**Deneyimim:**

> Bir şeyi yanlış yaptığım için işlemi gerçekleştiremedim. Ama error ID ile ne yapmam gerekiyor? 0/10

## 🟧 AWS

**Deneyimim:**

> İyi. Bir şey bozulduğunda hatayı gösteriyor; hatayı bilmeseniz bile Google'da bulabilirsiniz. Ancak bunun araştırılıp kullanıcı dostu bir şekilde sunulması daha iyi olurdu. 8/10

## 🟨 GCP

**Deneyimim:**

> AWS ile aynı. En azından hatayla ilgili bilgi veriyor. 8/10

### Doğrudan Karşılaştırma

> Temel olarak Azure'da, 10 saat önce ne yaptığınızı biliyorsanız daha önce gördüğünüz bir hatayla uğraşmak daha kolay. Ancak aksi durumda, nereye gireceğinizi bilmediğiniz bir Error ID yalnızca boş konuşmadan ibaret. AWS=GCP>Azure

---

# 📈 Learning Curve

## 🟦 Azure

**Deneyimim:**

> Bence Azure en iyi öğrenme platformuna sahip. Microsoft Learn her şeyi sıfır bilgiye sahip biriyle konuşuyormuş gibi açıklıyor ancak çok fazla kelime kullanıyor. Microsoft ayrıca Microsoft Learn'deki her içerik için videolar da sunuyor; kontrol etmeye değer ancak ben video izleyerek veya okuyarak öğrenmiyorum. Ayrıca Azure'da daha detaylı IAM, VM ve security ayarları bulunuyor. 8/10

## 🟧 AWS

**Deneyimim:**

> Kısa açıklamalar. Harika. Dil desteği kötü. Endonezce var ama Rusça, Arapça veya İsveççe yok mu? 6/10

## 🟨 GCP

**Deneyimim:**

> Google'dan bahsediyoruz. Elbette her şey son derece güzel görünüyor. Kafanız karışırsa roadmap'ler bile var. Home lab'ler de bulunuyor. Sorun şu ki text document yok. Lisede okumuyoruz. 9/10

### Doğrudan Karşılaştırma

> GCP yalnızca sesli anlatım gibi (varsa bu kısmı dokümanda değiştireceğim), ancak ne yapmanız gerektiğini anlatıyor. Azure fazla açıklamayı seviyor ve bu beyninizi yakabilir. AWS işleri basit tutuyor. Hızlı öğreniyorsunuz ancak bazı şeyler eksikmiş gibi gelebiliyor. GCP>Azure>AWS

---

# 🤖 AI-Assisted Experience

Bu kategori, cloud platformlarını öğrenirken ve kullanırken AI destekli araçlarla yaşadığım pratik deneyime odaklanmaktadır.

AI sistemlerini şu gibi farklı isteklerle test ettim:

* Troubleshooting istekleri
* Yanıt hızı
* Kullandığım entity'ler hakkındaki bilgi

## 🟦 Azure

**Deneyimim:**

> "SUBSCRIPTION ID DEĞİL, TENANT ID'mi" bilmek istiyorum. Bana ID'lerimi öğrenmek için tıklamam gerektiğini söylemek 50 saniye mi sürdü? 1/10

## 🟧 AWS

**Deneyimim:**

> GUI çoklu dil desteğine sahip değil ancak Amazon Q sahip. Kısa sürede harika bir açıklama yapıyor ancak görsel oluşturma desteği yok (her ne kadar gereksiz olsa da). 9/10

## 🟨 GCP

**Deneyimim:**

> Gemini'nin cloud sürümü istediğim her şeyi yapıyor; normal Gemini olmadığını ve nedenini açıklasa bile. Ne zaman problem yaşasam Gemini yardımcı oluyor ve neyin yanlış olduğunu açıklıyor. İstediğim her şeyi yapıyor. 10/10

### Doğrudan Karşılaştırma

> Microsoft AI yarışında çok geride. Azure için bunu çok geliştireceklerini düşünmüştüm. Diğer AI'lar oldukça kullanışlı. GCP>AWS>Azure

---

# 👤 Genel Kullanıcı Deneyimi

## 🟦 Azure

**Deneyimim:**

> Azure ile çalışmak oldukça güzeldi ve Azure ile başlamış olmamın iyi olduğunu açıkça söyleyebilirim. Bunun nedeni çocukluğumdan beri Windows kullanıyor olmam ve Active Directory'yi zaten biliyor olmam; bu da terimlere ve kullanımlara aşina olmamı sağladı. Azure en detaylı cloud platformuydu. Ancak uygulayıcılar açısından küçük bir sorun var: birçok şey ücretli ve ücretsiz subscription'a dahil değil (örneğin NAT Gateway). Tüm artıları ve eksileriyle buna sağlam bir 6 veriyorum. -4 puanın nedeni entity oluşturma sırasında sorunları bulmak, daha az zone bulunabilirliği, bazen zone'da makine bulunmaması ve Copilot.

## 🟧 AWS

**Deneyimim:**

> Azure kullandığım için AWS'yi öğrenmek benim için oldukça zordu. AWS'ye alıştığımda farkları anlamaya başladım. Örneğin AWS'deki UI daha modern ancak Azure'dan daha karmaşık. Bu cloud'lar arasındaki büyük farklardan biri Zone availability ve zone'lardaki machine availability. Tüm artıları ve eksileriyle AWS'ye 8 veriyorum çünkü entity'lerdeki karmaşıklık GUI kullanıcısının Azure ve GCP'ye kıyasla çok daha fazla zaman harcamasına neden oluyor.

## 🟨 GCP

**Deneyimim:**

> GCP ile ilk etkileşimimde UI berbat olduğu için platformdan vazgeçmek istedim. Android telefon kullanmıyorum. Ayrıca en büyük eksilerden biri, belirli entity adını (örneğin app01) yazdığımda onu bulamaması. Azure ve AWS burada daha avantajlı. Diğer açılardan UI AWS'den daha basit. Regional ve zonal esneklik de Azure ve AWS'den daha iyi; bu konuda GCP rakiplerinden daha iyi. UI nedeniyle buna sağlam bir 9 veriyorum.

---

# 💳💵🤑 Fiyat Karşılaştırması

Bu konuda üç platformdaki Virtual Machine maliyetlerini karşılaştırdım. Çünkü bir sistem öğrenilecekse olumlu ve olumsuz yönleriyle öğrenilmelidir. Bu bölüm, daha iyi cost management için enterprise ve startup maliyetleri hakkında fiyat bilgisi sunmaktadır.

Bazı bilgiler:

Azure fiyatları bölgesel olarak değiştiği için konumumu Frankfurt olarak belirledim.

Farklı özelliklere sahip 3 makine belirledim.

# Makine tablosu:

|    Seviye    |   CPU  |  RAM  |     SSD    |  Azure  |     AWS     |      GCP      |
| :----------: | :----: | :---: | :--------: | :-----: | :---------: | :-----------: |
| **Ekonomik** | 2 vCPU |  8 GB |  64 GB SSD | D2as v5 |  m6i.large  | e2-standard-2 |
|   **Orta**   | 4 vCPU | 16 GB | 128 GB SSD | D4as v5 |  m6i.xlarge | e2-standard-4 |
|  **Pahalı**  | 8 vCPU | 32 GB | 256 GB SSD | D8as v5 | m6i.2xlarge | e2-standard-8 |

Bunlar adil bir fiyat karşılaştırması için aynı kapasite aralığındaki makinelerdir. Kaynak güncelliğini kaybetmiş olabilir.

# Saatlik fiyatlar:

|       Seviye       |     Azure     |      AWS     |         GCP         |
| :----------------: | :-----------: | :----------: | :-----------------: |
|  **2 vCPU / 8 GB** | **~$0.096/h** | **$0.115/h** |    **~$0.067/h**    |
| **4 vCPU / 16 GB** | **~$0.208/h** | **$0.230/h** | **~$0.134–0.173/h** |
| **8 vCPU / 32 GB** | **~$0.416/h** | **$0.460/h** | **~$0.268–0.346/h** |

Aylık fiyatlar (730 saat / 30.41666 gün üzerinden hesaplama):

|       Seviye       |     Azure    |      AWS     |        GCP       |
| :----------------: | :----------: | :----------: | :--------------: |
|  **2 vCPU / 8 GB** |  **~$70/ay** |  **~$84/ay** |    **~$49/ay**   |
| **4 vCPU / 16 GB** | **~$152/ay** | **~$168/ay** |  **~$98–126/ay** |
| **8 vCPU / 32 GB** | **~$304/ay** | **~$336/ay** | **~$196–253/ay** |

Listeye bakıldığında GCP'nin rakiplerine kıyasla daha ucuz hizmetler sunduğu görülüyor.

Azure ve AWS arasındaki yarışta Azure bu konuda öne geçiyor. Bunun nedeni AWS'de her zaman aynı şekilde availability bulunmaması olabilir.

---

# 💥 Başarısızlıklar Üzerinden Öğrenme

Başarısızlık öğrenme sürecimin bilinçli bir parçasıydı.

Her lab ortamını mükemmel durumda tutmaya çalışmadım.

Bunun yerine altyapı yanlış yapılandırıldığında ne olduğunu anlamak istedim.

Örneğin:

* Yanlış firewall kuralları
* Eksik IAM permissions
* Networking problemleri
* DNS sorunları
* Terraform state/configuration uyumsuzlukları
* Yanlış resource dependencies
* Connectivity problemleri

Genel yaklaşımım:

```text
Build
  ↓
Understand
  ↓
Change
  ↓
Break
  ↓
Investigate
  ↓
Troubleshoot
  ↓
Fix
  ↓
Destroy
  ↓
Rebuild
```

Bu bana yalnızca cloud servislerinin tanımlarını ezberleyerek elde edilemeyecek pratik bir deneyim kazandırdı.

---

# 🧠 Felsefe

Bu yolculuğun temel amacı yalnızca daha fazla servis öğrenmek değildi.

Amaç **pratik bir infrastructure mindset** geliştirmekti.

Şunu anlamak istedim:

> **Nasıl çalışıyor?**

Sonra:

> **Neden çalışıyor?**

Ve son olarak:

> **Bozulduğunda ne oluyor?**

Bu nedenle öğrenme sürecim sürekli olarak şunu takip ediyor:

```text
Learn
  ↓
Build
  ↓
Break
  ↓
Troubleshoot
  ↓
Fix
  ↓
Destroy
  ↓
Rebuild
```

Benim için pratik deneyim, **altyapıyla etkileşime girmekten; yalnızca onun hakkında okumaktan değil** geliyor.

---

# 📌 Değerlendirme Kapsamı

Bu sayfa **23 Eylül 2026** tarihine kadar olan kişisel deneyimimi temsil etmektedir.

Karşılaştırma şunlara dayanmaktadır:

* Kendi hands-on lab'larım
* Oluşturduğum cloud altyapıları
* Networking yapılandırmaları
* IAM ve authorization çalışmaları
* CLI kullanımı
* Terraform projeleri
* Troubleshooting deneyimleri
* Documentation
* AI-assisted learning
* Kişisel öğrenme sürecim

> **Bu bir objektif benchmark veya sektör sıralaması değildir.**

Farklı kullanıcılar şu faktörlere bağlı olarak çok farklı deneyimler yaşayabilir:

* Geçmiş
* Workload
* Organizasyon
* Mevcut teknik bilgi
* Tercih edilen araçlar
* Öğrenme yaklaşımı

Bu sayfanın amacı yalnızca **Azure, AWS ve GCP ile ilgili kendi pratik deneyimimi** belgelemektir.

---

# 📚 Kaynaklar

Aşağıdaki kaynaklar öğrenme yolculuğum boyunca ve bu portföyde belgelenen cloud ortamlarını oluşturup troubleshooting yaparken kullanıldı.

## 📖 Resmî Dokümantasyon ve Öğrenme Platformları

| Kaynak                            | Kullanım Amacı                                                                                          |
| --------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **Microsoft Learn**               | Azure ve AZ-104 tabanlı öğrenme sürecindeki temel öğrenme kaynağım                                      |
| **Microsoft Azure Documentation** | Azure servisleri, administration, networking, identity, monitoring ve troubleshooting dokümantasyonu    |
| **AWS Documentation**             | AWS servisleri, architecture, CLI, networking, IAM ve troubleshooting                                   |
| **Google Cloud Documentation**    | GCP servisleri, networking, IAM, Compute Engine, monitoring ve troubleshooting                          |
| **Terraform Documentation**       | Infrastructure as Code kavramları, Terraform configuration, providers, resources, state ve workflow'lar |

## 🤖 AI Destekli Öğrenme

| Araç                  | Kullanım                                                                                                           |
| --------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **ChatGPT**           | Etkileşimli öğrenme, troubleshooting, architecture tartışmaları, Terraform, CLI yardımı ve senaryo tabanlı öğrenme |
| **Google Gemini**     | Alternatif açıklamalar, troubleshooting yaklaşımları ve teknik cross-check                                         |
| **Microsoft Copilot** | Microsoft ekosistemi ve cloud ile ilgili yardım                                                                    |

## 🎥 Video Kaynakları

* Microsoft Azure
* AWS
* Google Cloud Tech
* Microsoft Mechanics
* NetworkChuck
* TechWorld with Nana

## 🧪 Kişisel Hands-On Lab'lar

Karşılaştırma ayrıca kendi hands-on ortamlarıma dayanmaktadır:

* Azure administration ve infrastructure lab'ları
* Windows Server / Active Directory lab'ları
* Azure + on-premises hybrid infrastructure
* AWS infrastructure lab
* GCP infrastructure lab
* Terraform Infrastructure as Code projeleri
* Docker ve containerization çalışmaları

---

## 📝 Son Not

Bu sayfadaki tüm gözlemler ve karşılaştırmalar, bu kaynaklar ve ortamlarla ilgili **kişisel pratik deneyimime** dayanmaktadır.

Bu sayfa öğrenme yolculuğumu, oluşturduğum altyapıları, karşılaştığım problemleri ve her cloud platformunu nasıl deneyimlediğimi belgelemek amacıyla hazırlanmıştır.

Dokümantasyon, bilgi edinmek için kullanılabilir ve başka dokümantasyonlarda, videolarda veya bloglarda kullanılabilir. Sayfalarımdan veya kaynaklarımdan herhangi birini kullanmayı planlıyorsanız, özgürsünüz; ancak bir credit verilmesi, görüntülendiğimi bilmek açısından beni mutlu eder.

Bir hata tespit ettiğim her seferde dokümantasyon yenilenecektir.

* Portföyümü ziyaret ettiğiniz için teşekkürler.

---

**Son güncelleme:** `24 Eylül 2026 12:57 AM GMT +3 İstanbul`
