// ignore_for_file: use_build_context_synchronously

import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/core/utils/send_gmail.dart';
import 'package:icare/core/utils/small_fun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/core/styles/my_colors.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';




class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController firstNameTextEditingController = TextEditingController();
  final TextEditingController lastNameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController phoneTextEditingController = TextEditingController();
  final TextEditingController subjectTextEditingController = TextEditingController();
  final TextEditingController contentTextEditingController = TextEditingController();

  bool loading  = false;
  @override
  void initState() {
    dropDownMenu = getDropDownMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GlobalAppBar(
        title: translate("activity_setting.contact_us"),
        leadingIcon:  const BackArrowButton(),
        icon: null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 154.w,
                  child: CustomTextFromField(
                    hintText: translate("signup.first_name"),
                    labelText: translate("signup.first_name"),
                    hasBorder: true,
                    smallPadding: true,
                    cursorColor: kPrimary,
                    radius: 10,
                    textEditingController: firstNameTextEditingController,
                    validator: () {},
                    obscureText: false,
                    isLabelError: false,
                  ),
                ),
                const SizedBox(width: 10,),
                SizedBox(
                  width: 154.w,
                  child: CustomTextFromField(
                    hintText: translate("signup.last_name"),
                    labelText: translate("signup.last_name"),
                    hasBorder: true,
                    smallPadding: true,
                    cursorColor: kPrimary,
                    radius: 10,
                    textEditingController: lastNameTextEditingController,
                    validator: () {},
                    obscureText: false,
                    isLabelError: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 50.h,
              child: CustomTextFromField(
                  hintText: translate("login.email"),
                  labelText: translate("login.email"),
                  radius: 10,
                  textEditingController: emailTextEditingController,
                  textInputType: TextInputType.emailAddress,
                  validator: () {},
                  prefixIcon: null,
                  cursorColor: kPrimary,
                  hasBorder: true,
                  suffixIcon: const SizedBox(),
                  obscureText: false,
                  isLabelError: false),
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                CustomText(text: "+966", fontSize: AppStyle.small.sp,),
                const SizedBox(width: 5,),
                Expanded(
                  // width: 280.w,
                  child: CustomTextFromField(
                    hintText: "502441695",
                    labelText: translate("signup.phone"),
                    hasBorder: true,
                    smallPadding: true,
                    textInputType: TextInputType.phone,
                    cursorColor: DMUtil.getRED(),
                    radius: 10,
                    textEditingController: phoneTextEditingController,
                    validator: () {},
                    obscureText: false,
                    isLabelError: false,
                    borderColor: DMUtil.getDC(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Container(
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1,color: DMUtil.getOpacity()),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child:  DropdownButton(
                isExpanded: true,
                style: TextStyle(color: DMUtil.getD2C(), fontSize: 12.sp,),
                hint: CustomText(
                  text: translate("activity_setting.select_subject"),
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
                onChanged:(val){
                  setState(() {
                    subject = val.toString();
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_down),
                items:  dropDownMenu,
                value: subject,
              ),
            ),
            const SizedBox(height: 20,),
            CustomTextFromField(
                hintText: translate("activity_setting.message_title"),
                labelText: translate("activity_setting.message_title"),
                radius: 10,
                textEditingController: subjectTextEditingController,
                validator: () {},
                prefixIcon: null,
                cursorColor: kPrimary,
                hasBorder: true,
                suffixIcon: const SizedBox(),
                obscureText: false,
                isLabelError: false),
            const SizedBox(height: 20,),
            SizedBox(
              height: 100.h,
              child: CustomTextFromField(
                  hintText: translate("activity_setting.content"),
                  labelText: translate("activity_setting.content"),
                  radius: 10,
                  maxLines: 5,
                  textEditingController: contentTextEditingController,
                  validator: () {},
                  prefixIcon: null,
                  cursorColor: kPrimary,
                  hasBorder: true,
                  suffixIcon: const SizedBox(),
                  obscureText: false,
                  isLabelError: false),
            ),

            const SizedBox(height: 30,),
            MaterialButton(
              onPressed: ()async{
                setState(() {
                  loading = true;
                });
                if(emailTextEditingController.text.trim().isNotEmpty&&
                    firstNameTextEditingController.text.trim().isNotEmpty&&
                    lastNameTextEditingController.text.trim().isNotEmpty&&
                    subjectTextEditingController.text.trim().isNotEmpty&&
                    contentTextEditingController.text.trim().isNotEmpty&&
                    phoneTextEditingController.text.trim().isNotEmpty
                ){
                  String phone = "+966${phoneTextEditingController.text.trim()}";
                  if(validatePhoneInput(phone, context) == false){
                    setState(() {
                      loading = false;
                    });
                    return;
                  }
                  if(!emailTextEditingController.text.trim().contains("@")){
                    setState(() {
                      loading = false;
                    });
                    SnackBarBuilder.showFeedBackMessage(context, translate("toast.email_invalid"), DMUtil.getRED());
                    return;
                  }
                  final res = await SendGmail.sendContactUs(
                      subjectTextEditingController.text.trim(),
                      contentTextEditingController.text.trim(),
                      firstNameTextEditingController.text.trim(),
                      lastNameTextEditingController.text.trim(),
                      phone,
                      emailTextEditingController.text.trim(), subject);
                  setState(() {
                    loading = false;
                  });
                  if(res){
                    emailTextEditingController.text = "";
                    firstNameTextEditingController.text = "";
                    lastNameTextEditingController.text = "";
                    contentTextEditingController.text = "";
                    subjectTextEditingController.text = "";
                    phoneTextEditingController.text = "";
                    SnackBarBuilder.showFeedBackMessage(context, translate("toast.gmail_send"), DMUtil.getGreen());
                  }else{
                    SnackBarBuilder.showFeedBackMessage(context, translate("toast.oops"), Colors.red);
                  }
                }else{
                  setState(() {
                    loading = false;
                  });
                  SnackBarBuilder.showFeedBackMessage(context, translate("toast.field_empty"), Colors.red);
                }
              },
              height: 32.w,
              minWidth: double.infinity,
              color: DMUtil.getRED(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: loading? const CircularProgressIndicator(color: Colors.white,) : CustomText(
                text: translate("button.send").toUpperCase(),
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.w,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  bool validatePhoneInput(String phone,BuildContext context){
    if(phone.isNotEmpty){
      String? txt = Util.validatePhone(phone);
      if(txt!=null){
        SnackBarBuilder.showFeedBackMessage(context, txt, DMUtil.getRED());
        return false;
      }
    }
    return true;
  }

  List<DropdownMenuItem<String>> dropDownMenu = [];
  String subject = translate("activity_setting.feedback");
  List<DropdownMenuItem<String>> getDropDownMenu() {
    List<DropdownMenuItem<String>> itemsMarketKind = [];
    itemsMarketKind.add(DropdownMenuItem(
      value: translate("activity_setting.feedback"),
      child: CustomText(
        text: translate("activity_setting.feedback"),
        fontSize: 12.sp,
        color: Colors.black,
      ),
    ));
    itemsMarketKind.add(DropdownMenuItem(
      value: translate("activity_setting.suggestion"),
      child: CustomText(
        text: translate("activity_setting.suggestion"),
        fontSize: 12.sp,
        color: Colors.black,
      ),
    ));
    return itemsMarketKind;
  }
}

