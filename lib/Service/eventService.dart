import 'package:cycle_app/Model/UserModel.dart';
import 'package:cycle_app/Service/userService.dart';
import 'package:cycle_app/main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../globals.dart';

  Future<String> postEvent(name,description,startDateTime,endDateTime) async {
    UserService userService = getIt.get<UserService>();
    var url = base_url + '/events';
    var groupUrl = base_url + '/groups';
    var body = {
        "name":name,
        "description":description,
        "start_date_time":startDateTime,
        "end_date_time":endDateTime,
        "host":'${userService.userValue.id}',
        "completed":'0',
    };
    try{
        final response = await http.post(url, body: body,headers: {"Authorization":"Bearer "+userService.tokenValue});
        if(response.statusCode == 200){
            return "event successfuly posted.";
        }else{
            return "couldn't post event";
        }
    }catch (e){
        print(e);
        return "couldn't post the event.";
    }
    return "couldn't post event";
  }

  Future<http.Response> getMyEvents() async{
      UserService userService = getIt.get<UserService>();
      http.Response response = await http.get('$base_url/events/host/${userService.userValue.id}',headers: {"Authorization":"Bearer "+userService.tokenValue});
      return response;
  }
  Future<http.Response> getAllEvents() async{
      UserService userService = getIt.get<UserService>();
      http.Response response = await http.get('$base_url/events',headers: {"Authorization":"Bearer "+userService.tokenValue});
      return response;
  }
  Future<String> deleteEvent(id)async{
      UserService userService = getIt.get<UserService>();
      http.Response response = await http.delete('$base_url/events/$id',headers: {"Authorization":"Bearer "+userService.tokenValue});
      print(response.body);
      if(response.statusCode==200){
          return "successfully deleted the event.";
      }else{
          return "couldn't delete the event.";
      }
  }
  Future<String> participateInEvent(id,{participated:false})async{
    UserService userService = getIt.get<UserService>();
      if(!participated){
        http.Response response = await http.post('$base_url/events/$id/${userService.userValue.id}',headers: {"Authorization":"Bearer "+userService.tokenValue});
        print("participate response: "+response.body);
        if(response.statusCode==200){
            return "successfully participated in the event.";
        }else{
            return "couldn't participate in the event.";
        }
      }else{
        http.Response response = await http.delete('$base_url/events/$id/${userService.userValue.id}',headers: {"Authorization":"Bearer "+userService.tokenValue});
        print("participate response: "+response.body);
        if(response.statusCode==200){
            return "successfully removed participation.";
        }else{
            return "couldn't remove participation.";
        }
      }
  }
  