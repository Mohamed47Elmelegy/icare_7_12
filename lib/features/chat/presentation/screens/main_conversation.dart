import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/chat/data/models/chat_model.dart';
import 'package:icare/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:icare/features/chat/presentation/bloc/chat_event.dart';
import 'package:icare/features/chat/presentation/bloc/chat_state.dart';
import 'package:icare/features/chat/presentation/widgets/chat_widgets.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';


class ConversationScreen extends StatefulWidget {
  final String receiverID;
  final String receiverName;
  final String chatRoomID;
  final bool? updateSeen ;
  final String? lastMsg ;
  final String? spec ;
  const ConversationScreen({super.key,required this.receiverID,required this.receiverName,
    required this.chatRoomID,this.updateSeen=false,this.lastMsg="", this.spec=""});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageEditingController =  TextEditingController();
  late ChatBloc chatBloc;
  String lastDate = "";
  String lastActive = "";

  @override
  void didChangeDependencies() {
    chatBloc =  ChatBloc.get(context);
    chatBloc.add(FetchAllChatLitEvent(roomID: widget.chatRoomID));
    // if(widget.updateSeen!)chatBloc.add(UpdateChatSeenEvent(roomID: widget.chatRoomID,roomData: {'lastMsg':"${widget.lastMsg} msg seen:${Util.getUserID()}"}));
    // Timer(const Duration(seconds: 2),()async{
    //   if(chatBloc.chats!=null && await chatBloc.chats!.length!=0){
    //     chatBloc.chats!.forEach((element) {
    //       lastDate = element.docs.first['time'].toString().split(" ").first.trim();
    //     });
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       setState(() {
    //         lastDate = lastDate;
    //       });
    //     });
    //   }
    // });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DMUtil.getWC(),
        elevation: 1,
        leading: BackArrowButton(color: DMUtil.getPC(),),
        title: CustomText(
          text: widget.receiverName,
          color: DMUtil.getDC(),
          fontSize: AppStyle.average.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5,),
          CustomText(
            text: lastDate,
            color: Colors.black54,
            fontSize: AppStyle.verySmall.sp - 2,
          ),
          Expanded(
            child: BlocBuilder<ChatBloc,ChatState>(
              builder: (ctx,state){
                var bloc = ChatBloc.get(ctx);
                return StreamBuilder<QuerySnapshot>(
                  stream: bloc.chats,
                  builder: (context, snapshot){
                    return snapshot.hasData ?  ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index){
                          QueryDocumentSnapshot<Object?> data = snapshot.data!.docs[index] ;
                          return MessageTile(
                            message: data['message'],
                            senderName: data['senderName'],
                            sendByMe: data['senderID']==Util.getUserID(),
                            timeShow: Util.formatTimeToHMPMorAM(DateTime.parse(data['time']))+(Util.isToday(DateTime.parse(data['time']))?'':"/${Util.formatToDayMonth(DateTime.parse(data['time']))}"),
                          );
                        }):const SizedBox();
                  },
                );
              },
            )
          ),
          const Divider(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(15.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(width: 1,color: Colors.grey.withOpacity(0.4))
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: DMUtil.getPC(), fontSize: AppStyle.small.sp),
                          decoration: InputDecoration(
                              hintText: translate("app_bar.type_here"),
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      )),
                  const SizedBox(width: 16,),
                  GestureDetector(
                    onTap: ()=> _sendMsg(),
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10,top: 8,bottom: 8,right: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  DMUtil.getPC2(),
                                  DMUtil.getPC(),
                                ]
                            )
                        ),
                        child: const Icon(Icons.send,color: Colors.white,)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  _sendMsg()async{
    if(messageEditingController.text.trim().isEmpty)return;
    chatBloc.add(SendNewMsgEvent(roomID: widget.chatRoomID ,
        model: MessageModel(text: messageEditingController.text.trim(),
          senderID: Util.getUserID(),
          receiverID: widget.receiverID,
          receiverName: widget.receiverName,
          senderName: Util.getName(),
        ),catID: null,msg: "${Util.getName()}: ${messageEditingController.text.trim()}"),);
    messageEditingController.text = "";
  }


}
