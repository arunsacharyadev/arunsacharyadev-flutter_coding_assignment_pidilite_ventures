import '../models/terms_and_conditions_model.dart' as tacm;
import '../services/network_api_service.dart';

class HomeRepository {
  Future<tacm.TermsAndConditionsModel?> getTAndCDataFromApi() async {
    var res = await NetworkApiService()
        .getApiService(url: 'https://jsonplaceholder.typicode.com/posts');
    tacm.TermsAndConditionsModel? data = tacm.TermsAndConditionsModel.fromJson({
      'details': res,
    });
    return data;
  }
}
