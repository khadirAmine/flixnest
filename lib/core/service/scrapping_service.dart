import 'package:http/http.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

import '../../data/models/item_details_model.dart';
import '../../data/models/item_model.dart';
import '../config/app_config.dart';
import '../utils/methodes.dart';
import 'http_service.dart';

class ScrappingService {
  static Future<List<ItemModel>?> getItems(
      {bool? newItems, int? pageNum}) async {
    try {
      logger('start scrapping');
      Response? response = await HttpService.getRequest(newItems == true
          ? '${AppConfig().instance.baseUrl}/page/$pageNum/'
          : AppConfig().instance.baseUrl);
      String html = response?.body ?? '';
      BeautifulSoup bs = BeautifulSoup(html);
      List<Bs4Element>? items = bs
          .find('div', class_: 'Grid--WecimaPosts')
          ?.findAll('div', class_: 'Thumb--GridItem');
      List<ItemModel> itemsModel = [];
      if (items != null) {
        for (var item in items) {
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
          itemsModel.add(ItemModel(
              title: title,
              imageUrl: imageUrl,
              episode: episode,
              year: year,
              href: href));
        }
      }
      logger('finish scrapping');
      return itemsModel;
    } catch (e) {
      logger('Error : $e');
    }
    return null;
  }

  static Future<ItemDetailsModel?> getItemDetails(String href) async {
    try {
      logger('start scrapping');
      Response? response = await HttpService.getRequest(href);
      String html = response?.body ?? '';
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
      for (var detail in allDetails!) {
        detailsList.add(detail);
      }
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
      //< find seasions
      List<Bs4Element>? seasionsList = bs
          .find('div', class_: 'List--Seasons--Episodes')
          ?.findAll('a', class_: 'hoverable activable');
      List? seasions = [];
      if (seasionsList != null) {
        for (int i = 0; i < seasionsList.length; i++) {
          seasions.add({
            seasionsList[i].text: {'href': seasionsList[i].attributes['href']}
          });
        }
      }
      //>

      //< find episodes
      List<Bs4Element>? episodesList = bs
          .find('div', class_: 'Episodes--Seasons--Episodes')
          ?.findAll('a', class_: 'hoverable activable');
      List? episodes = [];
      if (episodesList != null) {
        for (int i = 0; i < episodesList.length; i++) {
          episodes.add({
            episodesList[i].text: {'href': episodesList[i].attributes['href']}
          });
        }
      }
      //>
      logger('finish scrapping');
      return ItemDetailsModel(
        title: title,
        imageUrl: imageUrl,
        year: year,
        arabicName: arabicName,
        quality: quality,
        type: type,
        alsoKnownAs: alsoKnownAs,
        classification: classification,
        duration: duration,
        storyMovie: storyMovie,
        iframe: iframe,
        seasions: seasions,
        episodes: episodes,
      );
    } catch (e) {
      logger('Error : $e');
    }
    return null;
  }
}
