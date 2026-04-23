import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/menu/controller/restaurant_menu_controller.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_add_product_model.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Models/common_get_category_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../../../../../Data/response/status.dart';
import '../../../../../../../../Utils/image_url_formater.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/theme/colors.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/custom_image_cropper.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../RestaurantAddProduct/Models/restaurant_get_addon_model.dart' hide Addons;
import '../../../../RestaurantAddProduct/Models/restaurant_get_cuisine_type_model.dart';
import '../../../../menu/model/restaurant_menu_model.dart' as product_model;
import '../../../controller/restaurant_product_controller.dart';
import '../Model/res_single_product_model.dart';

class RestaurantEditMenuController extends GetxController {
  final RestaurantProductController restaurantProductController = Get.put(RestaurantProductController());
  GlobalKey<FormState> publishButtonKey = GlobalKey<FormState>();

  final RestaurantMenuController restaurantMenuController = Get.isRegistered<RestaurantMenuController>() ? Get.find<RestaurantMenuController>() : Get.put(RestaurantMenuController());
  // GlobalKey<FormState> attributeButtonKey = GlobalKey<FormState>();
  GlobalKey<FormState> addOnButtonKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> indexedKey = [];

  // RxBool isRedColor = false.obs;

  // RxBool isSubmit = false.obs;

  RxBool isExtraValidationError = false.obs;
  final ScrollController scrollController = ScrollController();

  // Function to scroll to the top
  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  final GlobalKey titleKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey categoryKey = GlobalKey();
  final GlobalKey regularKey = GlobalKey();
  final GlobalKey saleKey = GlobalKey();
  final GlobalKey cuisineKey = GlobalKey();
  final GlobalKey preparationKey = GlobalKey();

  void scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.02,
      );
    }
  }
  RxList<String> menuSection = ["Breakfast","Lunch","Dinner","Snacks","Desserts","Beverages","Appetizers","Main Course","Sides","All Day"].obs;
  RxString selectedMenuSection = "".obs;


  Rx<TextEditingController> preparationController = TextEditingController().obs;

  Rx<TextEditingController> skuController = TextEditingController().obs;
  Rx<TextEditingController> regularPriceController =
      TextEditingController().obs;
  Rx<TextEditingController> salePriceController = TextEditingController().obs;

  RxString selectedCategoryId = "".obs;
  RxBool isErrorColor = false.obs;
  RxBool activeSalePriceValidation = false.obs;

  Rx<Categories> attributeList = Rx<Categories>(Categories());
  RxBool isAddOn = false.obs;
  RxList<bool> isExtra = RxList<bool>([]);
  RxList<List<GlobalKey>> masterNameKeyList = RxList<List<GlobalKey>>([]);
  RxList<List<GlobalKey>> masterPriceKeyList = RxList<List<GlobalKey>>([]);
  RxList<GlobalKey> addOnControllersKeyList = RxList<GlobalKey>([]);
  RxList<GlobalKey> addOnDropdownKeyList = RxList<GlobalKey>([]);

  final ImagePicker _picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = "".obs;
  RxList<Rx<File?>> additionalImages = RxList<Rx<File?>>.generate(4, (index) => Rx<File?>(null));
  RxList<RxString> additionalImageBase64 = RxList<RxString>.generate(4, (index) => ''.obs);
  XFile? _pickedFile;

  //------------------------------------------crop Image------------------------------------------

  Future<void> cropImage(Rx<File?> image, RxString imageBase64) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            activeControlsWidgetColor: AppColors.primary,
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPresetCustom2x2(),
            statusBarColor: AppColors.primary,
            lockAspectRatio: true,
            aspectRatioPresets: [CropAspectRatioPresetCustom2x2()],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [CropAspectRatioPresetCustom2x2()],
          ),
          WebUiSettings(
            context: Get.context!,
            presentStyle: WebPresentStyle.dialog,
          ),
        ],
      );
      // if (croppedFile != null) {
      //   // Update imageFile to the cropped File
      //   image.value = File(croppedFile.path);
      //   // Convert the cropped image to Base64
      //   imageBase64.value = await convertImageToBase64(imageBase64, image.value!);
      //   if (imageBase64.isNotEmpty) {
      //     print("Base64 Image: --->>>$imageBase64<<<-----");
      //
      //     update();
      //   } else {
      //     print("Failed to convert image to Base64");
      //   }
      // }
      if (croppedFile != null) {
        image.value = File(croppedFile.path);
        final compressedFile = await compressImage(imageFile: image.value!);
        final compressedFileAsFile = File(compressedFile.path);

        final base64String =
            await convertImageToBase64(imageBase64, compressedFileAsFile);
        if (base64String.isNotEmpty) {
          print("Base64 Image: --->>>$base64String<<<-----");
          imageBase64.value = base64String;
        } else {
          print("Failed to convert image to Base64");
        }
      }
    }
  }

  //------------------------------------------compress Image------------------------------------------

  static Future<XFile> compressImage({
    required File imageFile,
    int quality = 25,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    log(imageFile.lengthSync().toString(), name: "Original size");
    try {
      final String targetPath =
          p.join(Directory.systemTemp.path, 'temp.${format.name}');
      final XFile? compressedImage =
          await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: quality,
        format: format,
      );

      if (compressedImage == null) {
        throw ("Failed to compress the image");
      }

      print("Compressed Image: ${compressedImage.path}");
      final compressedFile = File(compressedImage.path);
      log(compressedFile.lengthSync().toString(), name: "Compressed size");
      return compressedImage;
    } catch (e) {
      print("Error during image compression: $e");
      rethrow;
    }
  }

  //------------------------------------------convert Image To Base64------------------------------------------

  Future<String> convertImageToBase64(
      RxString imageBase64, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      imageBase64.value = base64Encode(bytes);
      apiSingleProductData.value.product!.image = imageBase64.value;
      log(imageBase64.value, name: "Base64IMAGE");
      return imageBase64.value;
    } catch (e) {
      print("Error converting image to Base64: $e");
      return '';
    }
  }

  //------------------------------------------pick Image------------------------------------------

  Future<void> pickImage(BuildContext context) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    pt("image.value.path ${image.value?.path}");

    if (pickedImage != null) {
      _pickedFile = pickedImage;
      cropImage(image, imageBase64);
      update();
    }
  }

  //------------------------------------------pick More Image------------------------------------------

  Future<void> pickMoreImage(int index) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _pickedFile = pickedImage;
      cropImage(additionalImages[index], additionalImageBase64[index]);
      update();
    }
  }

  RxString status = ''.obs;

  final api = Repository();

  RxString productId = ''.obs;

  @override
  void onInit() async {
    // await getAddOnApi();
    productId.value = Get.arguments ?? '';
    isAttributesPrefilled.value = false;
    await getSingleProductApi(productId: productId.value);
    getCuisineTypeApi();
    super.onInit();
  }

  //------------------------------------------get Category Api------------------------------------------

  final rxRequestCategoryStatus = ApiStatus.COMPLETED.obs;
  RxString categoryError = ''.obs;
  final apiCategoryData = CommonGetCategoryModel().obs;

  void setRxRequestCategoryStatus(ApiStatus value) =>
      rxRequestCategoryStatus.value = value;

  void categorySetData(CommonGetCategoryModel value) =>
      apiCategoryData.value = value;

  void setCategoryError(String value) => categoryError.value = value;

  Future<void> getCategoryApi(String categoryId) async {
    setRxRequestCategoryStatus(ApiStatus.LOADING);
    final product = apiSingleProductData.value.product!;

    // Clear existing data first
    clearProductSelections();

    api.commonGetCategoryApi().then((value) async {
      categorySetData(value);
      if (apiCategoryData.value.status == true) {
        attributeList.value = apiCategoryData.value.categories!
            .where((map) => map.id.toString() == categoryId)
            .firstOrNull ?? Categories();

        // Initialize structure for new category
        initializeCategoryState();

        // Get add-ons for this category
        final selectedCategory = apiCategoryData.value.categories
            ?.firstWhereOrNull((c) => c.id == product.categoryId);

        if (selectedCategory?.addons != null) {
          setFilteredAddOns(selectedCategory!.addons!);
        }

        // Only prefill data if we're editing and this is the original category
        if (product.categoryId == categoryId) {
          // ✅ Prefill Add-ons
          await prefillAddOns(product);

          // ✅ Prefill options
          if (attributeList.value.options != null &&
              attributeList.value.options!.isNotEmpty) {
            await prefillProductOptions(apiSingleProductData.value.product);
          }

          // ✅ Prefill attributes
          await prefillAttributes(product);
        }

        setRxRequestCategoryStatus(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setCategoryError(error.toString());
      print(error);
      setRxRequestCategoryStatus(ApiStatus.ERROR);
    });
  }

  // Future<void> getCategoryApi(String categoryId) async {
  //   setRxRequestCategoryStatus(ApiStatus.LOADING);
  //   final product = apiSingleProductData.value.product!;
  //   api.commonGetCategoryApi().then((value) async {
  //     categorySetData(value);
  //     if (apiCategoryData.value.status == true) {
  //       log(selectedCategoryId.value.toString(), name: "category select");
  //
  //       if (attributeList.value.options != null &&
  //           attributeList.value.options!.isNotEmpty) {
  //         await prefillProductOptions(apiSingleProductData.value.product);
  //       }
  //
  //       final selectedCategory = apiCategoryData.value.categories
  //           ?.firstWhereOrNull((c) => c.id == product.categoryId);
  //
  //       if (selectedCategory?.addons != null) {
  //         setFilteredAddOns(selectedCategory!.addons!);
  //       }
  //
  //       // ✅ Prefill Add-ons (Now works on first load)
  //       await prefillAddOns(product);
  //
  //       // ✅ Prefill options only after attribute list updates
  //       ever(attributeList, (_) async {
  //         if (attributeList.value.options != null &&
  //             attributeList.value.options!.isNotEmpty) {
  //           await prefillProductOptions(apiSingleProductData.value.product);
  //         }
  //       });
  //
  //       attributeList.value = apiCategoryData.value.categories!
  //           .where((map) => map.id.toString() == categoryId).elementAt(0);
  //       //------------------------------------------------
  //       for (int i = 0; i < attributeList.value.attributes!.length; i++) {
  //         indexedKey.add(GlobalKey<FormState>());
  //         masterNameKeyList.add([]);
  //         masterPriceKeyList.add([]);
  //         bool found = false;
  //         // for (var item in apiSingleProductData.value.product!.extra!) {
  //         //   if (item.titleid == attributeList.value.attributes![i].id) {
  //         //     found = true;
  //         //     break;
  //         //   }
  //         // }
  //
  //       //   if (!found) {
  //       //     apiSingleProductData.value.product?.extra?.insert(
  //       //       i,
  //       //       get_model.Extra(
  //       //           titleid: attributeList.value.attributes?[i].id,
  //       //           item:
  //       //               [get_model.Item(name: "", id: '${i + 1}', price: "")].obs,
  //       //           title: attributeList.value.attributes?[i].name),
  //       //     );
  //       //   }
  //       // }
  //       // for (int i = 0;
  //       //     i < apiSingleProductData.value.product!.extra!.length;
  //       //     i++) {
  //       //   for (int j = 0;
  //       //       j < apiSingleProductData.value.product!.extra![i].item!.length;
  //       //       j++) {
  //       //     masterNameKeyList[i].add(GlobalKey());
  //       //     masterPriceKeyList[i].add(GlobalKey());
  //       //   }
  //       // }
  //
  //       // if (apiSingleProductData.value.product?.extra != null) {
  //       //   for (int i = 0;
  //       //       i < apiSingleProductData.value.product!.extra!.length;
  //       //       i++) {
  //       //     if (apiSingleProductData.value.product!.extra![i].item != null &&
  //       //         apiSingleProductData
  //       //             .value.product!.extra![i].item!.isNotEmpty &&
  //       //         apiSingleProductData.value.product!.extra![i].item![0].name !=
  //       //             "" &&
  //       //         apiSingleProductData.value.product!.extra![i].item![0].price !=
  //       //             "") {
  //       //       isExtra.insert(i, true);
  //       //     } else {
  //       //       isExtra.insert(i, false);
  //       //     }
  //       //     log(isExtra.toString(), name: "extra true");
  //       //   }
  //       }
  //       setRxRequestCategoryStatus(ApiStatus.COMPLETED);
  //     }
  //   }).onError((error, stackError) {
  //     setCategoryError(error.toString());
  //     print(error);
  //     setRxRequestCategoryStatus(ApiStatus.ERROR);
  //   });
  // }

  //------------------------------------------get AddOn Api------------------------------------------
  //
  // RxString selectedAddOnId = "".obs;
  //
  // final rxRequestAddOnStatus = ApiStatus.COMPLETED.obs;
  // RxString addOnError = ''.obs;
  // final apiAddOnData = RestaurantGetAddOnModel().obs;
  //
  // void setRxRequestAddOnStatus(ApiStatus value) =>
  //     rxRequestAddOnStatus.value = value;
  //
  // void addOnSetData(RestaurantGetAddOnModel value) =>
  //     apiAddOnData.value = value;
  //
  // void setAddOnError(String value) => addOnError.value = value;
  //
  // RxList<String> selectedAddons = RxList<String>([]);
  //
  // Future<void> getAddOnApi() async {
  //   setRxRequestAddOnStatus(ApiStatus.LOADING);
  //
  //   api.restaurantGetAddOnApi().then((value) {
  //     addOnSetData(value);
  //
  //     if (apiAddOnData.value.status == true) {
  //       // apiAddOnData.value.addons!.insert(0,Addons(id: "", name: "Choose Addon"));
  //     }
  //     setRxRequestAddOnStatus(ApiStatus.COMPLETED);
  //   }).onError((error, stackError) {
  //     setAddOnError(error.toString());
  //     print(error);
  //     setRxRequestAddOnStatus(ApiStatus.ERROR);
  //   });
  // }

  //------------------------------------------get Cuisine Type Api------------------------------------------

  RxString selectedCuisineType = "".obs;
  final rxRequestCuisineTypeStatus = ApiStatus.COMPLETED.obs;
  RxString cuisineTypeError = ''.obs;
  final apiCuisineTypeData = RestaurantCuisineTypeModel().obs;

  void setRxRequestCuisineTypeStatus(ApiStatus value) =>
      rxRequestCuisineTypeStatus.value = value;

  void cuisineTypeSetData(RestaurantCuisineTypeModel value) =>
      apiCuisineTypeData.value = value;

  void setCuisineTypeError(String value) => cuisineTypeError.value = value;

  Future<void> getCuisineTypeApi() async {
    setRxRequestCuisineTypeStatus(ApiStatus.LOADING);

    api.restaurantGetCuisineTypeApi().then((value) {
      cuisineTypeSetData(value);
      if (apiCuisineTypeData.value.status == true) {
        setRxRequestCuisineTypeStatus(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setCuisineTypeError(error.toString());
      print(error);
      setRxRequestCuisineTypeStatus(ApiStatus.ERROR);
    });
  }

  //------------------------------------------options------------------------------------------
  final selectedOptionIndexes = <int>[].obs;
  final sizeConfigs = <RxList<Map<String, dynamic>>>[].obs;

  bool validateAllOptions() {
    final options = attributeList.value.options ?? [];
    bool hasError = false;

    for (int optionIndex = 0; optionIndex < options.length; optionIndex++) {
      // Skip unselected options
      if (!selectedOptionIndexes.contains(optionIndex)) continue;

      final configs = sizeConfigs[optionIndex];

      for (int configIndex = 0; configIndex < configs.length; configIndex++) {
        final config = configs[configIndex];
        final name = config["name"].text.trim();
        final price = config["price"].text.trim();

        config["nameError"].value = "";
        config["priceError"].value = "";

        if (name.isEmpty) {
          config["nameError"].value = "Please enter title";
          if (!hasError) {
            scrollToField(config["keyName"]);
            hasError = true;
          }
        }
        if (price.isEmpty) {
          config["priceError"].value = "Please enter price";
          if (!hasError) {
            scrollToField(config["keyPrice"]);
            hasError = true;
          }
        }

        // If error found, stop checking further
        if (hasError) break;
      }

      if (hasError) break;
    }

    sizeConfigs.refresh();
    return !hasError; // returns true if all valid
  }

  /// Prefill options from fetched product
  Future<void> prefillProductOptions(Product? product) async {
    final fetchedOptions = product?.options ?? [];
    final allAvailableOptions = attributeList.value.options ?? [];

    pt("🧩 Prefill: fetched=${fetchedOptions.length}, available=${allAvailableOptions.length}");

    selectedOptionIndexes.clear();
    sizeConfigs.clear();

    for (int i = 0; i < allAvailableOptions.length; i++) {
      final option = allAvailableOptions[i];
      final matchedOption = fetchedOptions.firstWhereOrNull(
            (opt) => opt.optionId.toString() == option.id.toString(),
      );

      final configs = <Map<String, dynamic>>[].obs;

      if (matchedOption != null) {
        selectedOptionIndexes.add(i);

        for (var choice in matchedOption.choices ?? []) {
          configs.add({
            "name": TextEditingController(text: choice.name ?? ""),
            "price": TextEditingController(text: choice.price ?? ""),
            "nameError": RxString(""),
            "priceError": RxString(""),
            "keyName": GlobalKey(),
            "keyPrice": GlobalKey(),
          });
        }

        if (configs.isEmpty) configs.add(createNewConfig());
      }

      sizeConfigs.add(configs);
    }

    sizeConfigs.refresh();
    selectedOptionIndexes.refresh();

    pt("✅ Prefilled ${selectedOptionIndexes.length} options with configs");
  }

  /// Creates new blank config
  Map<String, dynamic> createNewConfig() {
    return {
      "name": TextEditingController(),
      "price": TextEditingController(),
      "nameError": RxString(""),
      "priceError": RxString(""),
      "keyName": GlobalKey(),
      "keyPrice": GlobalKey(),
    };
  }

  /// Converts current UI state to JSON for API
  List<Map<String, dynamic>> buildOptionsJson() {
    final List<Map<String, dynamic>> optionsJson = [];

    for (int i = 0; i < selectedOptionIndexes.length; i++) {
      final index = selectedOptionIndexes[i];
      final option = attributeList.value.options?[index];
      final configs = sizeConfigs[index];

      // Convert configs → JSON choices
      final List<Map<String, dynamic>> choices = configs
          .where((cfg) =>
      cfg["name"].text.trim().isNotEmpty &&
          cfg["price"].text.trim().isNotEmpty)
          .map((cfg) => {
        "name": cfg["name"].text.trim(),
        "price": cfg["price"].text.trim(),
      })
          .toList();

      // Skip if no valid choice
      if (choices.isEmpty) continue;

      optionsJson.add({
        "option_id": option?.id.toString(), // ensure it's a string
        "choices": choices,
      });
    }

    final formattedJson = const JsonEncoder.withIndent('  ').convert(optionsJson);
    pt("🧩 Final Options JSON:\n$formattedJson");

    return optionsJson;
  }

  //------------------------------------------addons------------------------------------------
  /// 🔹 Reactive Add-on fields
  RxList<Addons> openedAddOnRows = <Addons>[].obs;
  RxList<String> selectedAddOnIds = <String>[].obs;
  RxList<TextEditingController> addOnPriceControllers = <TextEditingController>[].obs;
  RxList<Map<String, dynamic>> addOnFieldKeys = <Map<String, dynamic>>[].obs;

  RxList<Addons> filteredAddOns = <Addons>[].obs;

  void setFilteredAddOns(List<Addons> addOns) {
    filteredAddOns.assignAll(addOns);
  }

  /// Prefill Add-ons when editing product
  Future<void> prefillAddOns(Product product) async {
    final existingAddOns = product.addOns ?? [];
    final availableAddOns = filteredAddOns;

    openedAddOnRows.clear();
    selectedAddOnIds.clear();
    addOnPriceControllers.clear();
    addOnFieldKeys.clear();

    for (var addon in existingAddOns) {
      final match = availableAddOns.firstWhereOrNull((a) => a.id == addon.id);
      if (match != null) {
        openedAddOnRows.add(Addons(id: match.id, name: match.name));
        selectedAddOnIds.add(match.id!);

        final controller = TextEditingController(text: addon.price ?? "");
        addOnPriceControllers.add(controller);

        addOnFieldKeys.add({
          "dropdownKey": GlobalKey(),
          "priceKey": GlobalKey(),
          "dropdownError": RxString(""),
          "priceError": RxString(""),
        });
      }
    }

    // REMOVE this block — do not add an empty row by default
    /*
  if (openedAddOnRows.isEmpty) {
    openedAddOnRows.add(Addons(id: '', name: ''));
    addOnPriceControllers.add(TextEditingController());
    addOnFieldKeys.add({
      "dropdownKey": GlobalKey(),
      "priceKey": GlobalKey(),
      "dropdownError": RxString(""),
      "priceError": RxString(""),
    });
  }
  */
  }

  bool validateAllAddons() {
    bool hasError = false;

    for (int i = 0; i < openedAddOnRows.length; i++) {
      final keys = addOnFieldKeys[i];
      final selectedIds = selectedAddOnIds;
      final priceControllers = addOnPriceControllers;

      final dropdownId = selectedIds.length > i ? selectedIds[i] : null;
      final price = priceControllers[i].text.trim();

      // Reset previous errors
      keys["dropdownError"].value = "";
      keys["priceError"].value = "";

      // Validate dropdown
      if (dropdownId == null || dropdownId.isEmpty) {
        keys["dropdownError"].value = "Please select add-on";
        if (!hasError) {
          scrollToField(keys["dropdownKey"]);
          hasError = true;
        }
      }

      // Validate price
      if (price.isEmpty) {
        keys["priceError"].value = "Please enter price";
        if (!hasError) {
          scrollToField(keys["priceKey"]);
          hasError = true;
        }
      }

      if (hasError) break; // Stop at first invalid row
    }

    return !hasError; // true if all valid
  }

  List<Map<String, dynamic>> buildAddonsPayload() {
    final List<Map<String, dynamic>> addonsPayload = [];

    for (int i = 0; i < selectedAddOnIds.length; i++) {
      final id = selectedAddOnIds[i];
      final price = addOnPriceControllers[i].text.trim();

      // only include valid items
      if (id.isNotEmpty && price.isNotEmpty) {
        addonsPayload.add({
          "id": id,
          "price": price,
        });
      }
    }

    // 🔹 Print each item for debugging
    print("🧾 ==== Add-ons Payload (${addonsPayload.length}) ====");
    for (var item in addonsPayload) {
      print("➡️ id: ${item['id']} | price: ${item['price']}");
    }

    // 🔹 Print full JSON structure (pretty formatted)
    pt("📦 Full JSON Payload:");
    pt(const JsonEncoder.withIndent('  ').convert(addonsPayload));
    ("🧾 ===============================");

    return addonsPayload;
  }



  //------------------------------------------attributes------------------------------------------
  RxList<String> selectedAttributeIds = <String>[].obs;

  void setSelectedAttributes(List<String> ids) {
    selectedAttributeIds.value = ids;
  }
  final isAttributesPrefilled = false.obs;

  Future<void> prefillAttributes(Product product) async {
    selectedAttributeIds.clear();
    if (product.productAttributes != null && product.productAttributes!.isNotEmpty) {
      selectedAttributeIds.addAll(product.productAttributes!);
    }
    isAttributesPrefilled.value = true;
    print("✅ Prefilled Attributes: ${selectedAttributeIds.toList()}");
  }

  //------------------------------------------get Single Product Api------------------------------------------

  RxString mainUrlImage = "".obs;
  RxList<RxString> additionalImageFromApi = RxList<RxString>.generate(4, (index) => ''.obs);
  final apiSingleProductData = ResSingleProductModel().obs;

  void singleProductSetData(ResSingleProductModel value) =>
      apiSingleProductData.value = value;

  Future<void> getSingleProductApi({required String productId}) async {
    final data = {"product_id": productId};
    setRxRequestCategoryStatus(ApiStatus.LOADING);
    api.getSingleProductsApi(data).then((value) async {
      singleProductSetData(value);
      if (apiSingleProductData.value.status == true) {
        final product = apiSingleProductData.value.product;
        regularPriceController.value.text = product?.regularPrice ?? "";
        salePriceController.value.text = product?.salePrice.toString() ?? "";
        mainUrlImage.value = product!.imageUrl ?? "";
        selectedCategoryId.value = product.categoryId!;
        selectedCuisineType.value = product.cuisineId ?? apiCuisineTypeData.value.cuisine![0].id!;
        status.value = product.status ?? "";
        selectedMenuSection.value = formatMenuSection(product.menuSection);
        preparationController.value.text = product.preparationTime ?? "";
        pt("options ${apiSingleProductData.value.product?.options}");
        pt("prefillAttributes ${apiSingleProductData.value.product?.productAttributes}");
        // setSelectedAttributes(product.productAttributes);
        await prefillAttributes(product);
        // if (product.addOnWithNames != null && product.addOnWithNames!.isNotEmpty) {
        //   selectedAddOnId.value = product.addOnWithNames?[0].id?.value ??
        //       apiAddOnData.value.addons![0].id!;
        //   isAddOn.value = true;
        // }

        // for (int i = 0;
        //     i < apiSingleProductData.value.product!.addOnWithNames!.length;
        //     i++) {
        //   addOnDropdownKeyList.add(GlobalKey());
        //   addOnControllersKeyList.add(GlobalKey());
        // }

        skuController.value.text = product.sku ?? "";

        if (product.addimgUrl != null) {
          pt("Additional images from apis==================================== ${product.addimgUrl}");
          for (int i = 0; i < product.addimgUrl!.length; i++) {
            additionalImageFromApi[i].value =(product.addimgUrl!.isNotEmpty ? product.addimgUrl![i] : '');
          }
        }
        imageBase64.value = product.imageUrl ?? "";
        // imageBase64.value = await convertUrlImageToBase64(product.urlImage ?? '');

        int urlIndex = 0;
        for (var item in product.addimgUrl!) {
          additionalImageBase64[urlIndex].value = item;
          // additionalImageBase64[urlIndex].value = await convertUrlImageToBase64(item);
          urlIndex++;
        }
        selectedCategoryId.value = product.categoryId!;
        await getCategoryApi(product.categoryId!);/*.then((_) async {
          ever(attributeList, (_) async {
            if (attributeList.value.options != null &&
                attributeList.value.options!.isNotEmpty) {
              await prefillProductOptions(apiSingleProductData.value.product);
            }
          });
        });*/


        setRxRequestCategoryStatus(ApiStatus.COMPLETED);
      }
    }).onError((error, stackError) {
      setCategoryError(error.toString());
      print("error>>>>>>>>>>>>> $error");
      setRxRequestCategoryStatus(ApiStatus.ERROR);
    });
  }

  //------------------------------------------edit Product Api------------------------------------------

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final apiData = CommonAddProductModel().obs;

  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;

  void addProductSet(CommonAddProductModel value) => apiData.value = value;

  void setError(String value) => error.value = value;

  Future<void> editProductApi() async {
    final product = apiSingleProductData.value.product;
    final addonsList = buildAddonsPayload();
    final options = buildOptionsJson();

    Map<String, dynamic> dataForSubmit = {
      "product_id": productId.value,
      "title": product?.title ?? "",
      "category_id": product?.categoryId ?? "",
      "regular_price": product?.regularPrice ?? "",
      "sale_price": product?.salePrice ?? "",
      "description": product?.description ?? "",
      "status": product?.status ?? "",
      "cuisine_id": product?.cuisineId ?? "",
      "menu_section": formatToSnakeCase(selectedMenuSection.value),
      "preparation_time": preparationController.value.text,
      if(image.value?.path.isNotEmpty ?? false) "image": imageBase64.value,
      //new images
      "addimg": additionalImageBase64.map((image) =>image.value.contains(".jpg") ||image.value.isEmpty ? null : image.value).toList(),
      //old images
      "data_image": additionalImageBase64.map((image) => image.value.contains(".jpg") ? ImageUrlFormater.extractFilename(image.value): null).toList(),
      if(addonsList.isNotEmpty) "addons": addonsList,
      if(options.isNotEmpty) "options":options,
      if(selectedAttributeIds.isNotEmpty) "product_attributes": selectedAttributeIds
    };
    setRxRequestStatus(ApiStatus.LOADING);

    api.editProductsApi(dataForSubmit).then((value) {
      addProductSet(value);
      if (value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        restaurantMenuController.updateProductInList(
          id: productId.value,
          updatedData: product_model.Products(
            id: productId.value,
            title: product?.title,
            description: product?.description,
            imageUrl: image.value?.path  ?? product?.imageUrl,
            categoryId: product?.categoryId,
            rating: product?.rating,
            categoryName: product?.categoryName,
            status: product?.status,
          ),
        );
        // restaurantMenuController.getProductListApi(isShowLoading: false);
        Utils.showToast(apiData.value.message.toString());
      } else {
        setError(error.toString());
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(
          apiData.value.errors!.first.toString(),
          bgColor: AppColors.red,
        );
      }
    }).
    onError((error, stackError) {
      setError(error.toString());
      Utils.showToast(apiData.value.message.toString());
      log(error.toString(), name: "Edit product error>>>>>>>>>>>");
      setRxRequestStatus(ApiStatus.ERROR);
    });
  }

  String formatToSnakeCase(String input) {
    if (input.isEmpty) return "";
    return input.trim().replaceAll(RegExp(r'\s+'), '_');
  }




  /// Clear all category-related data
  void clearAllCategoryData() {
    // Clear options
    selectedOptionIndexes.clear();
    sizeConfigs.clear();

    // Clear add-ons
    openedAddOnRows.clear();
    selectedAddOnIds.clear();
    addOnPriceControllers.forEach((controller) => controller.dispose());
    addOnPriceControllers.clear();
    addOnFieldKeys.clear();
    filteredAddOns.clear();

    // Clear attributes
    selectedAttributeIds.clear();
    isAttributesPrefilled.value = false;

    // Clear UI keys
    indexedKey.clear();
    masterNameKeyList.clear();
    masterPriceKeyList.value = [];
    addOnControllersKeyList.clear();
    addOnDropdownKeyList.clear();

    // Reset any error flags
    isErrorColor.value = false;
    isExtra.clear();

    // Clear product data
    if (apiSingleProductData.value.product != null) {
      apiSingleProductData.value.product!.options?.clear();
      apiSingleProductData.value.product!.productAttributes?.clear();
      apiSingleProductData.value.product!.addOns?.clear();
    }

    debugPrint("🧹 Cleared all category data");
  }

  /// Initialize state for new category
  void initializeCategoryState() {
    final attributes = attributeList.value.attributes ?? [];

    // Initialize attribute structure if needed
    for (int i = 0; i < attributes.length; i++) {
      indexedKey.add(GlobalKey<FormState>());
      masterNameKeyList.add([]);
      masterPriceKeyList.add([]);
      isExtra.insert(i, false);
    }

    // Initialize options if category has them
    final options = attributeList.value.options ?? [];
    for (int i = 0; i < options.length; i++) {
      sizeConfigs.add(<Map<String, dynamic>>[].obs);
    }

    // Set filtered add-ons from new category
    if (attributeList.value.addons != null) {
      setFilteredAddOns(attributeList.value.addons!);
    }

    debugPrint("✅ Initialized state for category: ${attributeList.value.name}");
  }

  /// Clear product-specific selections (call this when category changes)
  void clearProductSelections() {
    // Clear UI selections
    selectedOptionIndexes.clear();

    // Clear size configs
    sizeConfigs.forEach((configList) {
      configList.forEach((config) {
        config["name"].dispose();
        config["price"].dispose();
      });
      configList.clear();
    });
    sizeConfigs.clear();

    // Reset add-ons
    clearAddOns();

    // Reset attributes
    selectedAttributeIds.clear();
    isAttributesPrefilled.value = false;
  }

  /// Clear add-ons specifically
  void clearAddOns() {
    // Dispose all controllers
    addOnPriceControllers.forEach((controller) => controller.dispose());

    // Clear all lists
    openedAddOnRows.clear();
    selectedAddOnIds.clear();
    addOnPriceControllers.clear();
    addOnFieldKeys.clear();

    // Reset filtered add-ons based on current category
    if (attributeList.value.addons != null) {
      setFilteredAddOns(attributeList.value.addons!);
    }

    debugPrint("🧹 Cleared all add-ons");
  }
  //------------------------------------------convert Url Image To Base64------------------------------------------

  Future<String> convertUrlImageToBase64(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      String base64UrlImage = base64Encode(bytes);
      return base64UrlImage;
    } else {
      throw Exception('Failed to load url base64 image');
    }
  }


  //------------------------------------------Format image data------------------------------------------

  String extractFilename(String url) {
    return url.split('/').last;
  }

  //  Convert API value like "main_course" → "Main Course"
  String formatMenuSection(String? value) {
    if (value == null || value.isEmpty) return "";
    return value
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }


}

// Define a model class for status dropdown items
class StatusDropdownItem {
  final String name;
  final String id;

  StatusDropdownItem({required this.name, required this.id});
}

// Change your items to a list of DropdownItem objects
// final statusItems = [
//   StatusDropdownItem(name: "Active", id: "1"),
//   StatusDropdownItem(name: "Inactive", id: "0"),
// ];

final statusItems = [
  StatusDropdownItem(name: "Active", id: "active"),
  StatusDropdownItem(name: "Inactive", id: "inactive"),
];
