import 'package:flutter/material.dart';
import 'package:jeevana/view/components/textField.dart';

class ChatScreen extends StatefulWidget {
   ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
final TextEditingController _chatVal = TextEditingController();

List chatList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("CHAT"),
        centerTitle: true,
        // titleSpacing: MediaQuery.of(context).size.width/4,
        // leading: Container(),
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
      ),
      bottomNavigationBar: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width/1.2,
              child: TextFieldLogin(
                enabled: true,
                OnTap: (){},
                OnChange: (password){
                  print(_chatVal.text);
                  print(password);
                },
                Controller: _chatVal,
                hinttext: 'Message',obscured: true,icon: Icon(Icons.keyboard,),),
            ),
            ElevatedButton(onPressed: (){
              // setState(() {
                chatList.add(_chatVal.text);
                print(chatList);
              // });
            }, child: Text("Send"),style: ElevatedButton.styleFrom(padding: EdgeInsets.only(top: 20,bottom: 20),),)
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/1.5,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: chatList.length,
                itemBuilder: (BuildContext context,int index){
                return SizedBox();
               // return MyChatTile(chatText: chatList.map((e) => chatList[e]),);
            }),
          )

        ],
      ),
    );
  }
}
class MyChatTile extends StatelessWidget {
  String chatText = '';
   MyChatTile({Key? key,required this.chatText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.centerRight,
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Text(chatText!,style: TextStyle(fontSize: 16),)
    );
  }
}

