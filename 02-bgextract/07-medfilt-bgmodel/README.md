zamanda median filtre uygulama temelli bgmodel-bgextract çalışması

## Rapor

önce elimizde renkli [video](http://gps-tsc.upc.es/imatge/_jl/Tracking/challenge.avi) vardı,

![giriş video](https://github.com/19bal/shadow/raw/master/img/surveillance.gif)

sonra zamanda yürüyen median filtre yardımıyla [bgmodeli](http://cloud.github.com/downloads/19bal/shadow/bg_model.png) elde ettik, bunu kullanarak basit eşiklemeyle bw görüntüler elde edildi,

![bw](https://github.com/19bal/shadow/raw/master/img/bw.gif)

bw görüntülerdeki insan dışı bileşenler temizlendikten sonrasında silüet elde edildi,

![siluet](https://github.com/19bal/shadow/raw/master/img/siluet.gif)

silüetlerden soldaki alınıp 64x64 alana hapsedilince de,

![64x64](https://github.com/19bal/shadow/raw/master/img/64x64.gif)

Şimdi sırada [8-iwashita10-shadow-separation](https://github.com/19bal/shadow/tree/master/8-iwashita10-shadow-separation/) çalışması yardımıyla shadow un body den ayrılması kaldı.
