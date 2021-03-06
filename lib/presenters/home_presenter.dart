import 'package:among_tani/model/user.dart';
import 'package:among_tani/contracts/home_contract.dart';
import 'package:among_tani/model/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:among_tani/webservices/api_service.dart';

class HomePresenter implements HomeInteractor{
  HomeView view;
  HomePresenter(this.view);
  RestClient api = RestClient(Dio());
  User u;
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('token')??"undefined");
    return token;
  }
//  @override
//  Future<User> load() async {
////    String jsonString = await rootBundle.loadString(json.decode(u));
////    final jsonData = json.decode(jsonString);
////    User user = User.fromJson(jsonData);
//    print(u);
//  }

  @override
  Future<List<Post>> all() async {
    List<Post> posts = List();
    var token = await getToken();
    token = "Bearer $token";
    await api.all(token).then((it){
      if(it.status == "1"){
        var temps = it.data;
        for(var t in temps){posts.add(Post.fromJson(t));}
      }
    });
    return posts;
  }

  @override
  void destroy() => view = null;
}