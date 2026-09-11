# Terraform

## Genel Bakış

Bu bölüm, **Microsoft Azure** ve **Amazon Web Services (AWS)** üzerindeki bulut altyapısını Infrastructure as Code yaklaşımıyla yönetmek için **Terraform** kullanımını belgelemektedir.

Terraform yapılandırmaları; lab ortamlarında kullanılan altyapı, ağ, güvenlik, kimlik, izleme, yedekleme ve diğer bulut kaynaklarını kapsamaktadır.

Terraform içeriği tek bir sayfaya sığmayacak kadar geniş olduğu için dokümantasyon **iki ayrı sayfaya** bölünmüştür.

---

## Dokümantasyon

### Azure Terraform

İlk sayfa, **Azure ortamındaki Terraform uygulamasını** kapsamaktadır. Yapılandırma dosyaları, oluşturulan altyapı kaynakları ve deployment yapısı burada açıklanmaktadır.

➡️ **[Azure Terraform Dokümantasyonu](az/readme.tr.md)**

### AWS Terraform

İkinci sayfa, **AWS ortamındaki Terraform uygulamasını** kapsamaktadır. Terraform yapılandırması ve yönetilen AWS altyapısı burada açıklanmaktadır.

➡️ **[AWS Terraform Dokümantasyonu](aws/readme.tr.md)**

---

## Neden Terraform?

Terraform, bulut altyapısını kod kullanarak tutarlı ve tekrarlanabilir şekilde tanımlamayı ve yönetmeyi sağlar.

Kaynakları bulut konsolları üzerinden manuel olarak oluşturmak yerine altyapı Terraform configuration dosyalarında tanımlanabilir ve kontrollü bir workflow üzerinden deploy edilebilir.

Bu projede Terraform, birden fazla bulut platformunda pratik **Infrastructure as Code (IaC)** becerilerini göstermek amacıyla kullanılmaktadır.
