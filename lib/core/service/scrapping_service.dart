import 'package:http/http.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

import '../config/app_config.dart';
import '../utils/methodes.dart';
import 'http_service.dart';

class ScrappingService {
  static final ScrappingService _instance = ScrappingService();
  ScrappingService get instance => _instance;
  bool getByCollection = false;
  String baseUrl = AppConfig().instance.baseUrl;

//* get Collections
  static Future<Map<String, dynamic>> getCollections() async {
    logger('start scrapping');
    Map<String, dynamic> data = {};
    try {
      if (await checkConnectionStatus()) {
        data.addAll({'connectionStatus': true, 'body': []});
      } else {
        data.addAll({'connectionStatus': false});
        return data;
      }
      Response response = await HttpService.getRequest(_instance.baseUrl);
      data.addAll({'statusCode': response.statusCode});
      if (response.statusCode != 200 && response.statusCode != 201) {
        data.addAll({
          'error': {'status': true, 'body': response.body}
        });
        return data;
      }
      String html = response.body;
      BeautifulSoup bs = BeautifulSoup(html);
      List<Bs4Element>? collections =
          bs.find('div', class_: 'list--Tabsui')?.findAll('a');
      collections?.forEach((element) {
        String? href = element.attributes['href'];
        String? name = element.text;
        data['body'].add({'href': href, 'name': name});
      });
      data.addAll({
        'error': {'status': false}
      });
    } catch (e) {
      logger('finish scrapping');
      data.addAll({
        'statusCode': e.hashCode,
        'error': {'status': true, 'body': e}
      });
    }

    logger('finish scrapping');
    return data;
  }

  //* get Items
  static Future<Map<String, dynamic>> getItems(
      {bool? newItems, int? pageNum}) async {
    logger('start scrapping');
    Map<String, dynamic> data = {};
    try {
      if (await checkConnectionStatus()) {
        data.addAll({'connectionStatus': true, 'body': <dynamic>{}});
      } else {
        data.addAll({'connectionStatus': false});
        return data;
      }
      String apiUrl = newItems == true
          ? (_instance.getByCollection == false
              ? '${_instance.baseUrl}/page/$pageNum/'
              : '${_instance.baseUrl}?page_no=$pageNum')
          : _instance.baseUrl;
      Response response = await HttpService.getRequest(apiUrl);
      data.addAll({'statusCode': response.statusCode});
      if (response.statusCode != 200 && response.statusCode != 201) {
        data.addAll({
          'error': {'status': true, 'body': response.body}
        });
        return data;
      }
      String html = response.body;
      BeautifulSoup bs = BeautifulSoup(html);
      List<Bs4Element>? items = bs
          .find('div', class_: 'Grid--WecimaPosts')
          ?.findAll('div', class_: 'Thumb--GridItem');

      items?.forEach((item) {
        String? href = item.find('a')?.attributes['href'];
        String? title = item.find('a')?.attributes['title'];
        String? year = item.find('span', class_: 'year')?.text.trim();
        //< get Image Url
        RegExp regExp = RegExp(r'url\(([^)]+)\)');
        String? getImageUrl = item
            .find('span', class_: 'BG--GridItem')
            ?.attributes['data-lazy-style'];
        Match? match = regExp.firstMatch(getImageUrl ?? '');
        String? imageUrl = match?.group(1);
        //>
        String? episode = item
            .find('div', class_: 'Episode--number')
            ?.find('span')
            ?.text
            .trim();
        if (episode != null) {
          data['body'].add({
            'title': title,
            'imageUrl': imageUrl,
            'episode': episode,
            'year': year,
            'href': href,
            'isFilm': false,
          });
        } else {
          data['body'].add({
            'title': title,
            'imageUrl': imageUrl,
            'year': year,
            'href': href,
            'isFilm': true,
          });
        }
      });

      data.addAll({
        'error': {'status': false}
      });
    } catch (e) {
      data.addAll({
        'statusCode': e.hashCode,
        'error': {'status': true, 'body': e}
      });
    }
    logger('finish scrapping');
    return data;
  }

//* get item details
  static Future<Map<String, dynamic>> getItemDetails(String href) async {
    logger('start scrapping');
    Map<String, dynamic> data = {};
    try {
      if (await checkConnectionStatus()) {
        data.addAll({'connectionStatus': true, 'body': {}});
      } else {
        data.addAll({'connectionStatus': false});
        return data;
      }
      Response? response = await HttpService.getRequest(href);
      data.addAll({'statusCode': response.statusCode});
      if (response.statusCode != 200 && response.statusCode != 201) {
        data.addAll({
          'error': {'status': true, 'body': response.body}
        });
        return data;
      }
      String html = response.body;
      BeautifulSoup bs = BeautifulSoup(html);
      String? title = bs
          .find('a', class_: 'unline', attrs: {'href': href})
          ?.find('span')
          ?.text
          .trim();
      String? year = bs
          .find('div', class_: 'Title--Content--Single-begin')
          ?.find('h1', attrs: {'dir': 'auto', 'itemprop': 'name'})
          ?.find('a', class_: 'unline')
          ?.text
          .trim();
      //< get Image Url
      RegExp regExp = RegExp(r'url\(([^)]+)\)');
      String? getImageUrl = bs
          .find('wecima', class_: 'separated--top')
          ?.attributes['data-lazy-style'];
      Match? match = regExp.firstMatch(getImageUrl ?? '');
      String? imageUrl = match?.group(1);
      //>

      //< find details
      List<Bs4Element>? allDetails =
          bs.find('ul', class_: 'Terms--Content--Single-begin')?.findAll('li');
      List<Bs4Element> detailsList = [];
      Map<String?, String?> m = {};
      allDetails?.forEach((detail) {
        detailsList.add(detail);
      });
      for (int i = 0; i < detailsList.length; i++) {
        m.addAll({
          detailsList[i].find('span')?.text:
              detailsList[i].find('p')?.text.trim()
        });
      }
      String? arabicName =
          m.containsKey('الإسم بالعربي') ? m['الإسم بالعربي'] : m['المسلسل'];
      String? quality = m.containsKey('الجودة') ? m['الجودة'] : null;
      String? type = m['النوع'];
      String? duration = m.containsKey('المدة') ? m['المدة'] : null;
      String? alsoKnownAs =
          m.containsKey('معروف ايضاََ بـ') ? m['معروف ايضاََ بـ'] : null;
      String? classification = m.containsKey('التصنيف') ? m['التصنيف'] : null;
      //>

      String? storyMovie =
          bs.find('div', class_: 'StoryMovieContent')?.text.trim();
      String? iframe = bs.find('iframe')?.attributes['data-lazy-src'];
      data['body'].addAll({
        'title': title,
        'imageUrl': imageUrl,
        'year': year,
        'arabicName': arabicName,
        'quality': quality,
        'type': type,
        'alsoKnownAs': alsoKnownAs,
        'classification': classification,
        'duration': duration,
        'storyMovie': storyMovie,
        'iframe': iframe,
      });
      //< find seasions
      List<Bs4Element>? seasionsList = bs
          .find('div', class_: 'List--Seasons--Episodes')
          ?.findAll('a', class_: 'hoverable activable');
      List seasions = [];
      if (seasionsList != null) {
        for (int i = 0; i < seasionsList.length; i++) {
          seasions.add({
            seasionsList[i].text: {'href': seasionsList[i].attributes['href']}
          });
        }
      }
      data['body'].addAll({'seasions': seasions});
      //>

      //< find episodes
      List<Bs4Element>? episodesList = bs
          .find('div', class_: 'Episodes--Seasons--Episodes')
          ?.findAll('a', class_: 'hoverable activable');
      List? episodes;
      if (episodesList != null) {
        for (int i = 0; i < episodesList.length; i++) {
          // ignore: dead_code
          episodes?.add({
            episodesList[i].text: {'href': episodesList[i].attributes['href']}
          });
        }
        data['body'].addAll({'episodes': episodes, 'isFilm': false});
      } else {
        data['body'].addAll({'episodes': episodes, 'isFilm': true});
      }
      //>
      data['body'].addAll({
        'error': {'status': false}
      });
    } catch (e) {
      data['body'].addAll({
        'statusCode': e.hashCode,
        'error': {'status': true, 'body': e}
      });
    }
    logger('finish scrapping');
    return data;
  }
}
