import 'package:icare/core/utils/small_fun.dart';
import 'package:icare/features/categories/data/models/allergies.dart';
import 'package:icare/features/categories/domain/entities/categories_entity.dart';
import 'package:icare/features/categories/domain/entities/publications_entity.dart';
import 'package:icare/features/categories/domain/entities/slider_entity.dart';
import 'package:icare/features/categories/domain/use_cases/get_all_categories_usecase.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_event.dart';
import 'package:icare/features/categories/presentation/bloc/cateogries_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class CategoriesBloc extends Bloc<CategoriesEvent,CategoriesState>{
  CategoriesEntity? currentCategory;


  GetAllCategoryUseCase getAllCategoryUseCase;
  GetAllAllergiesUseCase getAllAllergiesUseCase;
  GetAllSlidersUseCase getAllSlidersUseCase;
  GetAllPublicationsUseCase getAllPublicationsUseCase;
  CategoriesBloc({
    required this.getAllCategoryUseCase,
    required this.getAllAllergiesUseCase,
    required this.getAllSlidersUseCase,
    required this.getAllPublicationsUseCase,
  }) : super(CategoriesInitialState()) {
    on<FetchAllAllergiesEvent>((event, emit) async{
      await getAllAllergies(emit);
    });

    on<ChangeSliderIndexEvent>((event, emit) {
      changeCurrentSlider(event,emit);
    });


    on<FetchMainSlidersEvent>((event, emit)async{
      await getAllSliders(emit);
    });

    on<ChangeCurrentAllergies>((event, emit) {
      setCurrentAllergies(event, emit);
    });

    on<ChangeBrandIndexEvent>((event, emit) {
      changeCurrentBrandIndex(event, emit);
    });

    on<FetchAllPublicationsEvent>((event, emit)async{
      await getAllPublications(emit);
    });

    on<UpdateVideoControllerEvent>((event, emit){
       updateVideoController(event,emit);
    });

  }
  static CategoriesBloc get(BuildContext context) => BlocProvider.of(context);

  /// slider section
  List<SliderEntity> mainSlider = [];
  List<SliderEntity> anotherSliders = [];
  int currentSliderIndex = 0;
  changeCurrentSlider(event,emit){
    emit(FetchSliderLoadingState());
    currentSliderIndex = event.val;
    emit(FetchSliderSuccessfullyState());
  }

  getAllSliders(emit)async{
    emit(FetchSliderLoadingState());
    try{
     var res = await getAllSlidersUseCase();
     res.fold((l) {
       emit(FetchSliderFailedState());
     },(data) {
       mainSlider = data.where((element) => element.kind == "slider").toList();
       anotherSliders = data.where((element) => element.kind != "slider").toList();
       emit(FetchSliderSuccessfullyState());
     });
    }catch(e){
      debugPrint("getAllSlidersBlocError: $e");
      emit(FetchSliderFailedState());
    }
  }

  filterSliderByLang(List<SliderEntity> sliders){
    if(Util.getLang()=="ar"){
      return sliders.where((element) => element.title.toString().toLowerCase().contains("ar")).toList();
    }else{
      return sliders.where((element) => element.title.toString().toLowerCase().contains("en")).toList();
    }
  }

  List getCurrentCategoryProductList(int catID){
    // int index = categoriesList.indexWhere((element) => catID==element.id);
    // if(index!=-1 && categoriesList[index].productList!=null && categoriesList[index].productList!.isNotEmpty)return categoriesList[index].productList!;
    return [];
  }

  List<CategoriesEntity> activateTransList(List<CategoriesEntity> list){
    if(Util.getLang()=="ar"){
      return list.where((element) => element.isArabic==true).toList();
    }else{
      return list.where((element) => element.isArabic==false).toList();
    }
  }



  /// Allergies section
  List<AllergiesModel> allAllergies = [];
  getAllAllergies(emit)async{
    emit(const FetchCategoriesLoadingState());
    // try{
    var res = await getAllAllergiesUseCase();
    res.fold((l) {
      emit(const FetchCategoriesFailedState());
    },(data) {
      allAllergies = data;
    });
    emit(const FetchCategoriesSuccessfullyState());
    // }catch(e){
    //   debugPrint("getAllAllergiesBlocError: $e");
    //   emit(const FetchCategoriesFailedState());
    // }
  }


  AllergiesModel? currentAllergies;
  setCurrentAllergies(ChangeCurrentAllergies event,emit){
    emit(CategoriesInitialState());
    currentAllergies = event.item;
    emit(ChangeCurrentBrandSuccessState());
  }

  int currentBrandIndex = 0;
  changeCurrentBrandIndex(ChangeBrandIndexEvent event,emit){
    emit(CategoriesInitialState());
    currentBrandIndex = event.index;
    emit(ChangeCurrentBrandSuccessState());
  }


  /// publications
  List<PublicationsEntity> publicationsList = [];
  List<YoutubePlayerController> videoControllerList = [];
  getAllPublications(emit)async{
    emit(FetchPublicationsLoadingState());
    try{
      var res = await getAllPublicationsUseCase();
      res.fold((l) async{
        emit(FetchPublicationsFailedState());
      },(data) {
        for(var i in data){
          if(i.videoUrl.isNotEmpty){
            try {
              String? videoId = YoutubePlayer.convertUrlToId(i.videoUrl);
              if(videoId != null && videoId.isNotEmpty){
                videoControllerList.add(YoutubePlayerController(  
                  initialVideoId: videoId,  
                  flags: const YoutubePlayerFlags(  
                    autoPlay: false,  
                    mute: false,
                    showLiveFullscreenButton: false,
                    enableCaption: false,
                    hideControls: false,
                    controlsVisibleAtStart: false,
                  ),  
                ));
              }
            } catch (e) {
              debugPrint("Error creating YouTube controller for URL ${i.videoUrl}: $e");
            }
          }
        }
        publicationsList = data;
        emit(FetchPublicationsSuccessfullyState());
      });
    }catch(e){
      debugPrint("getAllPublicationsBlocError: $e");
      emit(FetchPublicationsFailedState());
    }
  }

  updateVideoController(UpdateVideoControllerEvent event,emit){
    emit(FetchPublicationsLoadingState());
    int indexV = videoControllerList.indexWhere((element) => element.initialVideoId.trim()==event.videoPlayerController.initialVideoId.trim());
    if(indexV==-1)return;
    videoControllerList[indexV] = event.videoPlayerController;
    emit(FetchPublicationsSuccessfullyState());

  }

}