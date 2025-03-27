# Çok Dilli Hesap Makinesi Yorumlayıcısı

Bu proje, basit hesap makinesi yorumlayıcısının 5 farklı programlama dilindeki (Rust, Ada, Perl, Scheme, Prolog) uygulamalarını içerir. Her bir uygulama, değişken ataması (varsa), temel aritmetik işlemler (toplama, çıkarma, çarpma, bölme), parantezli ifadeler, üs alma ve hata kontrolü gibi özellikleri desteklemektedir.

Her dilin dosya adı ve çalıştırma yönergeleri aşağıda belirtilmiştir:

---

## 1. Rust

- **Dosya Adı:** `Rust.rs`
- **Derleme & Çalıştırma:**
  - Doğrudan derlemek için:
    ```bash
    rustc Rust.rs -o Rust
    ./Rust
    ```
  - Cargo kullanılarak derlenecekse, `src/Rust.rs` olarak yerleştirin ve Cargo.toml'da:
    ```toml
    [[bin]]
    name = "calculator"
    path = "src/Rust.rs"
    ```
    ardından:
    ```bash
    cargo run
    ```

- **Test Örnekleri:**
  - `3 + 5`  → Result: 8  
  - `(1 + 2) * 4`  → Result: 12  
  - `10 / (5 + 2)` → Result: ≈1.42857  
  - `2 ^ 3`  → Result: 8  
  - Değişken ataması (örn. `x = 10` ve ardından `x + 5`) (Eğer destekleniyorsa)

---

## 2. Ada

- **Dosya Adı:** `my_calc.adb`  
  (Ünite adı: `My_Calc` veya `Simple_Calc` gibi; dosya adı olarak "my_calc.adb" kullanılmıştır.)
- **Derleme & Çalıştırma:**
  ```bash
  gnatmake my_calc.adb -o My_Calc
  ./My_Calc
Test Örnekleri:

Basit Aritmetik:
3 + 5 → Result: 8
10 / 2 → Result: 5

Parantezli İfade:
(1 + 2) * 4 → Result: 12.0

Karmaşık İfade:
10 / (5 + 2) → Result: ≈1.4286

Üs Alma:
2 ^ 3 → Result: 8.0

Sıfıra Bölme:
10 / (5 - 5) → Error: Division by zero

Değişken Ataması ve Kullanımı:
x = 10 → x defined with value: 10
x + 5 → Result: 15.0

3. Perl
Dosya Adı: Perl.pl

Çalıştırma:
perl Perl.pl
(Unix/Linux üzerinde çalıştırılabilir hale getirmek için chmod +x Perl.pl komutunu kullanabilirsiniz.)

Test Örnekleri:

3 + 5 → Sonuç: 8

(1 + 2) * 4 → Sonuç: 12

10 / (5 + 2) → Sonuç: ≈1.42857

2 ** 3 → Sonuç: 8

Değişken ataması:
x = 10 → x defined with value: 10
x + 5 → Sonuç: 15

Sıfıra bölme durumunda hata mesajı

4. Scheme
Dosya Adı: Scheme.rkt

Çalıştırma:
racket Scheme.rkt
Test Örnekleri:

(* (+ 1 2) 4) → Sonuç: 12.0

(/ 10 (+ 5 2)) → Sonuç: ≈1.42857

(expt 2 3) → Sonuç: 8.0

((+ 1 2) * 3) şeklinde iç içe ifadeler (uygun s-expression ile) → örneğin, ((+ 1 2) * 3) → Sonuç: 9.0 (veya daha karmaşık ifadeler)

Değişken ataması ve kullanımı (özel REPL yorumlayıcı üzerinden)

Sıfıra bölme durumunda hata mesajı

5. Prolog
Dosya Adı: Prolog.pl

Çalıştırma: Terminalde:

swipl -q -f Prolog.pl
Ardından Prolog REPL açıldığında hesap makinesi yorumlayıcısını başlatmak için:

prolog
?- calculator.
Test Örnekleri:

(1+2)*4. → Result: 12

10/(5+2). → Result: ≈1.42857

2^3. → Result: 8

((1+2)*3)^2. → Result: 81

Değişken ataması (örn. x = 10.) ve kullanım (örn. x+5. → Result: 15)

Sıfıra bölme durumunda hata mesajı
Mehmet Begun 231104084
