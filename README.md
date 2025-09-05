# Weather App (Flutter)

## 1. نظرة عامة
تطبيق Flutter بسيط/متوسّط التعقيد لعرض حالة الطقس (على الأرجح بالاعتماد على اختيار مدينة من واجهة تحتوي على قائمة/بحث) باستخدام إدارة حالة بنمط BLoC (مجلد cubit)، واستخدام Dio للاتصال بالإنترنت، مع فصل (نسبي) بين:
- Models (تحويل JSON ⇄ Dart)
- Services (التعامل مع API / الشبكة)
- Cubit (إدارة الحالة والتدفق المنطقي)
- Views (الصفحات)
- Widgets (مكوّنات واجهة قابلة لإعادة الاستخدام)

## 2. الهدف
تقديم واجهة تسمح للمستخدم باختيار مدينة (غالباً عبر dropdown_search) وجلب بيانات الطقس من خدمة خارجية (قد تكون OpenWeatherMap أو ما شابه) ثم عرض:
- اسم الموقع / المدينة
- درجة الحرارة
- وصف الحالة الجوية
- أيقونة الطقس (محمّلة من assets/images/ أو من رابط خارجي)
(التفاصيل الدقيقة تعتمد على ما في ملفات models والخدمة).

## 3. الحزم المستخدمة (من pubspec.yaml)
(السطر يشير لوجود الحزمة – بعض الحزم بدون رقم نسخة، أي ستأخذ آخر نسخة متاحة وقت تشغيل `flutter pub get`)

| الحزمة | الدور |
|--------|-------|
| flutter (SDK) | الأساس |
| dio | عميل HTTP متقدّم (دعم Interceptors / Timeouts / Cancel Tokens) |
| flutter_bloc | تكامل Widgets مع BLoC/Cubit (BlocBuilder / BlocProvider / BlocListener) |
| bloc | نواة إدارة الحالة (Cubit / Bloc / States) |
| dropdown_search | مكوّن واجهة لاختيار عنصر من قائمة مع بحث (غالباً لاختيار مدينة) |
| cupertino_icons | أيقونات iOS قياسية |
| flutter_test (dev) | الاختبارات |
| flutter_lints (dev) | قواعد تنظيم الكود (Linting) |

ملاحظة: عدم وجود geolocator أو location يعني أن التطبيق غالباً لا يلتقط الموقع الجغرافي تلقائياً حالياً، ويركّز على اختيار المستخدم للمدينة يدوياً.

## 4. الأصول (Assets)
تعريف في pubspec:
```
assets:
  - assets/images/
```
هذا يعني أن مجلد `assets/images/` يحتوي أيقونات أو صور (قد تكون رموز الطقس، شعارات، خلفيات).

## 5. هيكل المجلدات داخل lib/
```
lib/
  main.dart
  cubit/
  models/
  services/
  views/
  widgets/
```

وصف تفصيلي:
- main.dart: نقطة الدخول – تهيئة التطبيق، MaterialApp، التزويد (Provide) بالـ Cubit(s).
- cubit/: ملفات إدارة الحالة (مثال متوقّع: weather_cubit.dart ، weather_state.dart).
- models/: تمثيل بيانات الطقس (WeatherModel) مع دوال fromJson/toJson.
- services/: استدعاءات الشبكة (WeatherService) وقد يحتوي ملف تكوين Dio أو فئة API Client.
- views/: الشاشات الرئيسية (HomeView / SearchView ... إلخ).
- widgets/: مكونات UI صغيرة (بطاقة طقس، حقل بحث، عنصر عرض تفاصيل).

## 6. تدفّق العمل (Workflow)
1. تشغيل التطبيق → بناء MaterialApp.
2. تفعيل BlocProvider لتمرير WeatherCubit إلى الشجرة.
3. الواجهة الرئيسية (View) تحتوي:
   - DropdownSearch (لمدينة أو دولة).
   - زر "Fetch" أو يجلب آلي عند اختيار عنصر.
4. عند اختيار مدينة:
   - استدعاء weatherCubit.getWeather(cityName).
5. الـ Cubit يستدعي Service:
   - service.fetchWeather(cityName) → تنفيذ طلب GET عبر Dio.
6. النتيجة:
   - نجاح: JSON → Model → إصدار حالة Loaded.
   - فشل: إصدار حالة Error (رسالة).
7. الواجهة تعيد البناء عبر BlocBuilder:
   - Loading: مؤشر دوران.
   - Loaded: عرض القيم.
   - Error: رسالة + زر إعادة المحاولة.

## 7. إدارة الحالة (Cubit) (شكل متوقّع)
الحالات النموذجية:
- WeatherInitial
- WeatherLoading
- WeatherLoaded(WeatherModel data)
- WeatherError(String message)

مخطط مبسط:
```
getWeather(city):
  emit(WeatherLoading)
  try:
     model = await service.fetchWeather(city)
     emit(WeatherLoaded(model))
  catch(e):
     emit(WeatherError(parseMessage(e)))
```

## 8. طبقة الخدمات (services)
وظائف متوقعة:
- تهيئة Dio: BaseOptions (baseUrl, connectTimeout, receiveTimeout)
- دالة fetchWeather(String city):
  - بناء endpoint (مثال: /weather?q=CityName&appid=API_KEY&units=metric)
  - تنفيذ GET
  - التحقق من statusCode
  - إعادة model

(إن وُجدت Interceptor: تسجيل الطلب/الرد، التعامل مع الأخطاء).

## 9. النماذج (models)
نموذج WeatherModel (متوقّع حقول):
- String cityName
- double temperature
- String description
- double windSpeed
- int humidity
- String icon

fromJson(Map) و toJson() لتسهيل التخزين أو الاختبارات.

## 10. الواجهات (views)
أمثلة محتملة:
- HomeView:
  - عنوان / شعار
  - DropdownSearch لاختيار المدينة
  - BlocBuilder<WeatherCubit, WeatherState> لعرض:
    - Spinner أثناء التحميل
    - تفاصيل الطقس
    - رسالة خطأ
- (إن وُجد) DetailsView أو نفس الصفحة تعرض كل شيء.

## 11. المكوّنات (widgets)
أمثلة متوقعة:
- WeatherCard: تعرض الأيقونة + درجة الحرارة + الوصف.
- WeatherDetailsRow: عناصر (Wind / Humidity / ...).
- ErrorWidget مخصّص: رسالة + زر Retry.

## 12. معالجة الأخطاء
أخطاء محتملة:
- انقطاع اتصال (DioErrorType.connectionTimeout / badResponse)
- اسم مدينة غير صحيح (404)
- مشاكل Parsing

الاستراتيجية:
- تحويل الخطأ إلى رسالة ودّية (مثال: "حدث خطأ أثناء جلب البيانات، حاول لاحقاً").

## 13. الاختبارات (غير مذكورة في repo لكن ممكنة)
- اختبار Model.fromJson.
- اختبار Cubit (تحويل الحالات).
- اختبار Service (باستخدام DioAdapter أو Mock).

## 14. بناء المشروع وتشغيله
أوامر:
```
flutter pub get
flutter run
```
لإصدار (Release):
```
flutter build apk --release
```

## 15. تحسينات مستقبلية مقترحة
- إضافة geolocator لجلب الموقع الحالي.
- تخزين آخر نتيجة محلياً (SharedPreferences).
- دعم الوضع الليلي (ThemeMode.system).
- فصل طبقة Repository لسهولة الاستبدال.
- توحيد الأخطاء في كائن Failure بدلاً من نصوص مباشرة.
- دعم لغات متعددة (intl + arb).

## 16. ملخص تقني سريع
- إدارة حالة: Cubit (جزء من BLoC)
- شبكة: Dio
- اختيار مدينة: dropdown_search
- بنية بسيطة (ليست Clean Architecture كاملة ولكن قابلة للتوسع)
- موارد صور في assets/images/
- لا توجد حالياً مكتبات تحديد موقع أو تخزين محلي في pubspec.

## 17. مثال شكلي (Pseudo / نموذج تعليمي) للكود (قابل للتعديل)

محتوى تقريبي لمساعدة الفهم (ليس بالضرورة مطابقاً 1:1 لما في المستودع):

```dart
// services/weather_service.dart
import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherService {
  final Dio dio;
  WeatherService(this.dio);

  Future<WeatherModel> fetchWeather(String city) async {
    final response = await dio.get('/weather', queryParameters: {
      'q': city,
      'appid': 'YOUR_API_KEY',
      'units': 'metric',
    });
    return WeatherModel.fromJson(response.data);
  }
}
```

```dart
// models/weather_model.dart
class WeatherModel {
  final String cityName;
  final double temp;
  final String description;
  final String icon;
  final int humidity;
  final double wind;

  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.wind,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temp: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      wind: (json['wind']['speed'] as num).toDouble(),
    );
  }
}
```

```dart
// cubit/weather_state.dart
abstract class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final WeatherModel data;
  WeatherLoaded(this.data);
}
class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
}
```

```dart
// cubit/weather_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService service;
  WeatherCubit(this.service) : super(WeatherInitial());

  Future<void> getWeather(String city) async {
    emit(WeatherLoading());
    try {
      final model = await service.fetchWeather(city);
      emit(WeatherLoaded(model));
    } catch (e) {
      emit(WeatherError('فشل جلب الطقس'));
    }
  }
}
```

```dart
// views/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: Column(
        children: [
          DropdownSearch<String>(
            items: const ['Cairo','London','Paris','Berlin'],
            onChanged: (city) {
              if (city != null) {
                context.read<WeatherCubit>().getWeather(city);
              }
            },
            selectedItem: 'Cairo',
          ),
          Expanded(
            child: BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherLoaded) {
                  final w = state.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(w.cityName, style: const TextStyle(fontSize: 28)),
                      Text('${w.temp}°C', style: const TextStyle(fontSize: 50)),
                      Text(w.description),
                      Text('Humidity: ${w.humidity}%'),
                      Text('Wind: ${w.wind} m/s'),
                    ],
                  );
                } else if (state is WeatherError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('اختر مدينة لعرض الطقس'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

```dart
// main.dart (شكل تقريبي)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'cubit/weather_cubit.dart';
import 'services/weather_service.dart';
import 'views/home_view.dart';

void main() {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'));
  final service = WeatherService(dio);
  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final WeatherService service;
  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      home: BlocProvider(
        create: (_) => WeatherCubit(service),
        child: const HomeView(),
      ),
    );
  }
}
```

## 18. نقاط قوة
- استخدام dio (أفضل من http في مشاريع قابلة للتوسّع لاحقاً).
- فصل منطقي للمجلدات (models / services / cubit / views / widgets).
- اعتماد إدارة حالة قياسية (bloc/cubit).

## 19. فرص تحسين
- إضافة طبقة repository للفصل بين service و cubit.
- إضافة معالجة تفصيلية للأخطاء (تفريق network / not found / timeout).
- استخراج مفاتيح API خارج الكود (dart-define أو env).
- كتابة اختبارات لوظائف fetchWeather و Cubit transitions.

## 20. خلاصة
المشروع حالياً مصمم كبنية مبسطة وواضحة، يسهل على أي مطوّر قراءته وتوسيعه بإضافة (Geolocation / Cache / Forecast). مستوي الفصل كافٍ لبناء ميزات إضافية بسرعة.
