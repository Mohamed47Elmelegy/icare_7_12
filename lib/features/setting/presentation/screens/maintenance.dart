import 'dart:io';
import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/root_app/bloc/root_bloc.dart';
import 'package:icare/features/root_app/bloc/root_state.dart';
import 'package:icare/features/shared_widgets/align_child_by_row.dart';
import 'package:flutter/material.dart';
import 'package:icare/core/styles/app_style.dart';
import 'package:icare/core/utils/dark_mode_utility.dart';
import 'package:icare/features/shared_widgets/custom_button.dart';
import 'package:icare/features/shared_widgets/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:icare/features/shared_widgets/custom_text_form_field.dart';
import 'package:icare/features/shared_widgets/global_widgets.dart';
import 'package:icare/features/shared_widgets/snackbars_builder.dart';
import 'package:image_picker/image_picker.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final TextEditingController firstNameTextEditingController = TextEditingController();
  final TextEditingController lastNameTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController phoneTextEditingController = TextEditingController();
  final TextEditingController complaintTextEditingController = TextEditingController();
  final TextEditingController warrantyTextEditingController = TextEditingController();
  final TextEditingController serialTextEditingController = TextEditingController();
  final TextEditingController productModuleTextEditingController = TextEditingController();
  int deviceNumber = 1;
  int brandID = 1;
  File? img;
  var border = OutlineInputBorder(
      borderSide: BorderSide(color: DMUtil.getOpacity()),
      borderRadius: const BorderRadius.all(Radius.circular(10))
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DMUtil.getWC(),
      appBar: GlobalAppBar(
        title: translate("drawer.maintaenance_request"),
        leadingIcon: const BackArrowButton(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<RootBloc, RootState>(
          listenWhen: (ctx,state)=> state is MaintenanceSuccessState,
          listener: (ctx,state) {
            if(state is MaintenanceSuccessState){
              firstNameTextEditingController.text = "";
              lastNameTextEditingController.text = "";
              emailTextEditingController.text = "";
              phoneTextEditingController.text = "";
              productModuleTextEditingController.text = "";
              complaintTextEditingController.text = "";
              serialTextEditingController.text = "";
              warrantyTextEditingController.text = "";
              img = null;
              SnackBarBuilder.showFeedBackMessage(context, translate("maintenance.success_msg"), DMUtil.getGreen());
              setState(() {});
            }
          },
          child: BlocBuilder<RootBloc, RootState>(builder: (ctx, state) {
            return CustomButton(
              height: 40.h,
              width: 200.w,
              circular: 10,
              color: DMUtil.getRED(),
              widget: state is MaintenanceLoadingState
                  ? const CircularProgressIndicator(color: Colors.white,)
                  : CustomText(
                text: translate("button.send"),
                color: Colors.white,
                fontSize: AppStyle.average.sp,
              ),
              onPressed: () {
                if(validate()==false)return;
                String phone = "+966${phoneTextEditingController.text.trim()}";
                if(validatePhoneInput(phone, context) == false){
                  return;
                }
                if(!emailTextEditingController.text.trim().contains("@")){
                  SnackBarBuilder.showFeedBackMessage(context, translate("toast.email_invalid"), DMUtil.getRED());
                  return;
                }
              },
            );
          }),
        )
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppStyle.paddingFromH.w, vertical: 12.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: translate("profile.name"),
                        color: DMUtil.getDC(),
                        fontSize: AppStyle.average.sp,
                      ),
                      const SizedBox(height: 5,),
                      SizedBox(
                        width: 160.w,
                        child: CustomTextFromField(
                          hintText: translate("signup.first_name"),
                          labelText: "",
                          hasBorder: true,
                          smallPadding: true,
                          cursorColor: DMUtil.getRED(),
                          radius: 10,
                          textEditingController: firstNameTextEditingController,
                          validator: () {},
                          obscureText: false,
                          isLabelError: false,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: translate("signup.last_name"),
                        color: DMUtil.getDC(),
                        fontSize: AppStyle.average.sp,
                      ),
                      const SizedBox(height: 5,),
                      SizedBox(
                        width: 160.w,
                        child: CustomTextFromField(
                          hintText: translate("signup.last_name"),
                          labelText: "",
                          hasBorder: true,
                          smallPadding: true,
                          cursorColor: DMUtil.getRED(),
                          radius: 10,
                          textEditingController: lastNameTextEditingController,
                          validator: () {},
                          obscureText: false,
                          isLabelError: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12,),
              CustomText(
                text: translate("signup.phone"),
                color: DMUtil.getDC(),
                fontSize: AppStyle.average.sp,
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  CustomText(text: "+966", fontSize: AppStyle.small.sp,),
                  const SizedBox(width: 5,),
                  Expanded(
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
              const SizedBox(height: 12,),
              CustomText(
                text: translate("signup.email"),
                color: DMUtil.getDC(),
                fontSize: AppStyle.average.sp,
              ),
              const SizedBox(height: 5,),
              CustomTextFromField(
                hintText: translate("signup.email"),
                labelText: "",
                hasBorder: true,
                smallPadding: true,
                cursorColor: DMUtil.getRED(),
                radius: 10,
                textInputType: TextInputType.emailAddress,
                textEditingController: emailTextEditingController,
                validator: () {},
                obscureText: false,
                isLabelError: false,
                borderColor: DMUtil.getDC(),
              ),
              const SizedBox(height: 12,),

              CustomText(
                text: translate("maintenance.number_of_maintenance_device"),
                color: DMUtil.getDC(),
                fontSize: AppStyle.average.sp,
              ),
              const SizedBox(height: 5,),
              DropdownButtonFormField(
                icon: Icon(Icons.keyboard_arrow_down,size: 13.w,),
                decoration: InputDecoration(
                  focusedBorder:border,
                  enabledBorder: border,
                  border: border,
                  hintText: translate("maintenance.number_of_maintenance_device"),
                  hintStyle: TextStyle(fontSize: AppStyle.verySmall.sp+2, color: DMUtil.getD2C()),
                  isDense: true,
                ),
                items: <DropdownMenuItem<String>>[
                  for (var i = 0; i < 5; i++)
                    DropdownMenuItem(
                        value: (i + 1).toString(),
                        child: Text((i + 1).toString(),
                            style: TextStyle(color: DMUtil.getD2C())))
                ],
                onChanged: (value) {
                  setState(() {
                    deviceNumber = int.parse(value.toString());
                  });
                },
              ),
              const SizedBox(height: 12,),
              CustomText(
                text: translate("maintenance.warranty"),
                color: DMUtil.getDC(),
                fontSize: AppStyle.average.sp,
              ),
              const SizedBox(height: 5,),
              CustomTextFromField(
                hintText: translate("maintenance.warranty"),
                labelText: "",
                hasBorder: true,
                smallPadding: true,
                cursorColor: DMUtil.getRED(),
                radius: 10,
                textEditingController: warrantyTextEditingController,
                validator: () {},
                obscureText: false,
                isLabelError: false,
              ),
              const SizedBox(height: 12,),
              const SizedBox(height: 12,),
              CustomText(
                text: translate("maintenance.product_module"),
                color: DMUtil.getDC(),
                fontSize: AppStyle.average.sp,
              ),
              const SizedBox(height: 5,),
              CustomTextFromField(
                hintText: translate("maintenance.product_module"),
                labelText: "",
                hasBorder: true,
                smallPadding: true,
                cursorColor: DMUtil.getRED(),
                radius: 10,
                textEditingController: productModuleTextEditingController,
                validator: () {},
                obscureText: false,
                isLabelError: false,
              ),
              const SizedBox(height: 12,),
              CustomText(
                text: translate("maintenance.complaints"),
                color: DMUtil.getDC(),
                fontSize: AppStyle.average.sp,
              ),
              const SizedBox(height: 5,),
              CustomTextFromField(
                hintText: translate("maintenance.complaints"),
                labelText: "",
                height: 80.h,
                hasBorder: true,
                smallPadding: true,
                cursorColor: DMUtil.getRED(),
                radius: 10,
                maxLines: 10,
                textEditingController: complaintTextEditingController,
                validator: () {},
                obscureText: false,
                isLabelError: false,
              ),
              AlignChildRow(
                isStart: false,
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    CustomButton(
                      height: 30.h,
                      width: 220.w,
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText(
                            text: translate("maintenance.upload_image"),
                            color: Colors.white,
                            fontSize: AppStyle.average.sp,
                          ),
                          Icon(Icons.drive_folder_upload_outlined,size: 20.w,),
                        ],
                      ),
                      color: DMUtil.getRED(),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            img = File(image.path);
                          });
                        }
                      },
                    ),
                    if (img != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          img!,
                          height: 80.h,
                          width: 200.w,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ],
          )),
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

  bool validate(){
    if (firstNameTextEditingController.text.trim().isEmpty ||
        lastNameTextEditingController.text.trim().isEmpty ) {
      SnackBarBuilder.showFeedBackMessage(context, translate("toast.field_empty"), DMUtil.getRED());
      return false;
    }
    if (firstNameTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("signup.first_name")}", DMUtil.getRED());
      return false;
    }
    if (lastNameTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("signup.last_name")}", DMUtil.getRED());
      return false;
    }
    if (phoneTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("signup.phone")}", DMUtil.getRED());
      return false;
    }
    if (emailTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("signup.email")}", DMUtil.getRED());
      return false;
    }
    if (warrantyTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("maintenance.warranty")}", DMUtil.getRED());
      return false;
    }
    if(brandID==1){
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("store.brand")}", DMUtil.getRED());
      return false;
    }
    if (serialTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("maintenance.serial")}", DMUtil.getRED());
      return false;
    }
    if (productModuleTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("maintenance.product_module")}", DMUtil.getRED());
      return false;
    }
    if (complaintTextEditingController.text.trim().isEmpty) {
      SnackBarBuilder.showFeedBackMessage(context, "${translate("toast.field_empty")} - ${translate("maintenance.complaints")}", DMUtil.getRED());
      return false;
    }
    if(img == null){
      SnackBarBuilder.showFeedBackMessage(context, translate("toast.img_missing"), DMUtil.getRED());
      return false;
    }
    return true;
  }
}
