# کپڑے کا حساب — Android ایپ

یہ پروجیکٹ Capacitor کے ذریعے Android ایپ بناتا ہے۔ اس وقت ایپ کا بنیادی ورژن اردو/انگریزی، مال، فروخت، ادھار، اخراجات، خلاصہ اور دستی بیک اپ فراہم کرتا ہے۔

## APK اور AAB

- **APK:** Android فون پر انسٹال کرکے آزمائش کے لیے۔
- **AAB:** Google Play Console پر نئی ایپ/اپڈیٹ اپلوڈ کرنے کے لیے۔
- دونوں فائلیں کامیاب Build کے بعد `dist/` فولڈر میں بنتی ہیں۔
- `kapra-hisab-release.zip` میں دونوں فائلیں شامل ہوتی ہیں۔

## کمپیوٹر پر Build

ضروری چیزیں: Node.js 22، JDK 21، Android Studio اور Android SDK۔

1. اس فولڈر کو کمپیوٹر پر Extract کریں۔
2. Android Studio اور Android SDK نصب کریں۔
3. `ANDROID_HOME` میں Android SDK کا راستہ مقرر کریں۔
4. ٹرمینل/Command Prompt میں اس فولڈر کے اندر جائیں۔
5. `build.sh` چلائیں۔ Windows پر Git Bash استعمال کریں۔
6. Release signing key کا پاس ورڈ درج کریں۔
7. کامیابی پر `kapra-hisab-release.zip` حاصل ہوگی۔

## GitHub Actions کے ذریعے Build

1. ZIP کو Extract کرکے تمام فائلیں اپنی GitHub repository میں اپلوڈ کریں۔
2. Repository کی Settings → Secrets and variables → Actions میں `KS_PASS` نام کا secret بنائیں۔ اس میں signing key کا مضبوط پاس ورڈ رکھیں۔
3. Actions میں **APK اور AAB بنائیں** workflow کھولیں اور **Run workflow** دبائیں۔
4. کامیاب Build کے بعد `kapra-hisab-APK-AAB` نامی Artifact ڈاؤن لوڈ کریں۔ اس ZIP میں APK اور AAB دونوں ہوں گی۔
5. پہلی Build میں بننے والی `kapra-hisab-signing-key-PRIVATE` artifact سے `.jks` فائل محفوظ کریں۔ اسے کسی کے ساتھ شیئر نہ کریں۔
6. اگلی Builds کے لیے اسی key کو Base64 میں تبدیل کرکے `KS_B64` secret میں رکھیں، اور `KS_PASS` برقرار رکھیں۔ ہمیشہ وہی signing key استعمال کریں۔

## بہت ضروری: Signing Key

`.jks` فائل اور اس کا پاس ورڈ محفوظ رکھیں۔ گم ہونے کی صورت میں عام طور پر اسی ایپ کی آئندہ اپڈیٹس دستخط کرنا مشکل/ناممکن ہو سکتا ہے۔ اسے عام ZIP یا عوامی repository میں شامل نہ کریں۔

## Play Store سے پہلے

Play Console میں موجودہ Target API، Data safety، Privacy policy، App access، content rating، store listing، screenshots، icon، اور testing/verification تقاضے چیک کریں۔ Play Console کی شرائط وقت کے ساتھ بدل سکتی ہیں؛ Build کامیاب ہونا Play Store منظوری کی ضمانت نہیں۔

## موجودہ حدود

یہ ابھی ابتدائی کاروباری ورژن ہے۔ مکمل دکان کے استعمال سے پہلے فروخت کی واپسی، لین دین کی ترمیم/حذف، رسید/پرنٹ، صارفین/سپلائرز کا مکمل کھاتہ، ڈیٹا ایکسپورٹ، خودکار بیک اپ، اور مزید جانچ شامل/مکمل کرنا باقی ہے۔
