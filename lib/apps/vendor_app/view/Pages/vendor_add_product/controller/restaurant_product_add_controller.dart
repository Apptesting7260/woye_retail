import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:gyaawa/apps/vendor_app/view/Pages/Dashboard/controller/vendor_dashboard_controller.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../Data/Repository/repository.dart';
import '../../../../../../Data/response/status.dart';
import '../../../../../../Utils/snack_bar.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/widgets/vendor_widgets/custom_image_cropper.dart';
import '../../../vendor_common/Models/common_add_product_model.dart';
import '../../../vendor_common/Models/common_get_category_model.dart';
import '../Models/restaurant_get_addon_model.dart' hide Addons;
import '../Models/restaurant_get_cuisine_type_model.dart';

class RestaurantProductAddController extends GetxController {
  final ScrollController scrollController = ScrollController();

  RxList<String> menuSection = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snacks",
    "Desserts",
    "Beverages",
    "Appetizers",
    "Main Course",
    "Sides",
    "All Day"
  ].obs;
  RxString selectedMenuSection = "".obs;
  RxString department = ''.obs;
  RxString category = ''.obs;
  RxString subCategory = ''.obs;
  RxList<String> allVariantAttributes = ["Color", "Storage", "RAM", "Processor"].obs;

  String formatToSnakeCase(String input) {
    if (input.isEmpty) return "";
    return input.trim().replaceAll(RegExp(r'\s+'), '_');
  }

  RxList<VariantModel> variantList = <VariantModel>[].obs;
  void scrollToTop(double position) {
    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }


  RxBool hasVariants = false.obs;

  RxList<String> selectedVariantAttributes = <String>[].obs;

  RxMap<String, RxList<String>> attributeValues = <String, RxList<String>>{}.obs;

  RxMap<String, TextEditingController> valueControllers = <String, TextEditingController>{}.obs;

  TextEditingController customAttrNameController = TextEditingController();
  TextEditingController customAttrValueController = TextEditingController();

  // ✅ Select / Remove Attribute
  void toggleAttribute(String attr) {
    if (selectedVariantAttributes.contains(attr)) {
      selectedVariantAttributes.remove(attr);
      attributeValues.remove(attr);
      valueControllers.remove(attr);
    } else {
      selectedVariantAttributes.add(attr);
      attributeValues[attr] = <String>[].obs;
      valueControllers[attr] = TextEditingController();
    }
  }

  // ✅ Add Value manually
  void addAttributeValue(String attr) {
    String val = valueControllers[attr]?.text.trim() ?? "";
    if (val.isEmpty) return;

    attributeValues[attr]!.add(val);
    valueControllers[attr]!.clear();
  }

  void removeAttributeValue(String attr, String value) {
    attributeValues[attr]?.remove(value);
  }
  TextEditingController basePriceController = TextEditingController();
  TextEditingController baseStockController = TextEditingController();
  // ✅ Custom Attribute (same container me show hoga)

  void addCustomAttribute() {
    final name = customAttrNameController.text.trim();
    final values = customAttrValueController.text.trim().split(',').map((e) => e.trim()).toList();

    if (name.isEmpty || values.isEmpty) return;

    // Sirf custom attributes list me add karo

    // Input fields clear karo
    customAttrNameController.clear();
    customAttrValueController.clear();
  }
  void addCustomAttributeField() {
    customAttributes.add(AttributeModel());
  }
  void removeCustomAttributeField(int index) {
    customAttributes.removeAt(index);
  }
  RxList<AttributeModel> customAttributes = <AttributeModel>[].obs;

  // ✅ Generate Variants
  void generateVariants() {
    variantList.clear();

    if (selectedVariantAttributes.isEmpty) return;

    List<List<String>> allValues = [];

    for (var attr in selectedVariantAttributes) {
      final values = attributeValues[attr];
      if (values == null || values.isEmpty) return;
      allValues.add(values);
    }

    List<Map<String, String>> combinations = [];

    void generate(int index, Map<String, String> current) {
      if (index == selectedVariantAttributes.length) {
        combinations.add(Map.from(current));
        return;
      }

      String attr = selectedVariantAttributes[index];

      for (String val in attributeValues[attr]!) {
        current[attr] = val;
        generate(index + 1, current);
      }
    }

    generate(0, {});

    for (var combo in combinations) {
      variantList.add(
        VariantModel(
          values: combo,
          sku: _generateSKU(combo),
        ),
      );
    }
  }

  String _generateSKU(Map<String, String> values) {
    return values.values.map((e) {String clean = e.trim().toUpperCase();
      if (clean.length >= 3) {return clean.substring(0, 3);} else {return clean;}}).join("-");}

  final GlobalKey titleKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey packageKey = GlobalKey();
  final GlobalKey weightKey = GlobalKey();
  final GlobalKey modelNoKey = GlobalKey();
  final GlobalKey categoryKey = GlobalKey();
  final GlobalKey regularKey = GlobalKey();
  final GlobalKey saleKey = GlobalKey();
  final GlobalKey cuisineKey = GlobalKey();
  final GlobalKey menuSectionKey = GlobalKey();
  final GlobalKey preparationKey = GlobalKey();
  final GlobalKey barcodeKey = GlobalKey();
  final GlobalKey promoKey = GlobalKey();
  final GlobalKey skuKey = GlobalKey();
  final GlobalKey stockKey = GlobalKey();
  final GlobalKey fulfillmentKey = GlobalKey();
  final GlobalKey brandKey = GlobalKey();
  final GlobalKey screenSizeKey = GlobalKey();
  final GlobalKey storageKey = GlobalKey();
  final GlobalKey processorKey = GlobalKey();
  final GlobalKey ramKey = GlobalKey();
  final GlobalKey warrantyKey = GlobalKey();
  final GlobalKey colorKey = GlobalKey();

  void scrollToField(GlobalKey key, {double? allignment}) {
    final context = key.currentContext;
    if (context != null) {
      print("Scrolling to field: ${key.toString()}");
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: allignment ?? 0,
      );
    }
  }

  RxList<String> selectedAddons = RxList<String>([]);
  RxBool isExtraValidationError = false.obs;

  RxBool isErrorColor = false.obs;
  // RxBool isRedColor = false.obs;
  RxBool isDropdownOpen = false.obs;

  // RxBool isSubmit = false.obs;

  // bool isCategoryValidation = false;

  // final RestaurantProductController restaurantProductController=Get.put(RestaurantProductController());
  final VendorDashboardController restaurantDashboardController =
      Get.put(VendorDashboardController());

  GlobalKey<FormState> publishButtonKey = GlobalKey<FormState>();
  GlobalKey<FormState> addOnButtonKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> indexedKey = [];

  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> skuController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> regularPriceController =
      TextEditingController().obs;
  Rx<TextEditingController> salePriceController = TextEditingController().obs;
  Rx<TextEditingController> preparationController = TextEditingController().obs;
  Rx<TextEditingController> promoController = TextEditingController().obs;
  Rx<TextEditingController> barcodeController = TextEditingController().obs;
  Rx<TextEditingController> stockController = TextEditingController().obs;
  Rx<TextEditingController> packageController = TextEditingController().obs;
  Rx<TextEditingController> fulfillmentController = TextEditingController().obs;
  Rx<TextEditingController> brandController = TextEditingController().obs;
  Rx<TextEditingController> screenSizeController = TextEditingController().obs;
  Rx<TextEditingController> storageController = TextEditingController().obs;
  Rx<TextEditingController> ramController = TextEditingController().obs;
  Rx<TextEditingController> processorController = TextEditingController().obs;
  Rx<TextEditingController> colorController = TextEditingController().obs;
  Rx<TextEditingController> warrantController = TextEditingController().obs;
  // Rx<TextEditingController> customAttrNameController  = TextEditingController().obs;
  // Rx<TextEditingController> customAttrValueController   = TextEditingController().obs;

  RxString selectedCategoryId = "".obs;

  Rx<Categories> attributeList = Rx<Categories>(Categories());
  RxBool isAddOn = false.obs;
  RxList<bool> isExtra = RxList<bool>([]);

  RxList<List<TextEditingController>> masterNameControllerList =
      RxList<List<TextEditingController>>([]);
  RxList<List<TextEditingController>> masterPriceControllerList =
      RxList<List<TextEditingController>>([]);

  RxList<List<GlobalKey>> masterNameKeyList = RxList<List<GlobalKey>>([]);
  RxList<List<GlobalKey>> masterPriceKeyList = RxList<List<GlobalKey>>([]);

  RxList<RxInt> increaseItemCount = RxList<RxInt>([]);

  // options
  RxList<int> selectedOptionIndexes = <int>[].obs;
  RxList<List<Map<String, dynamic>>> sizeConfigs =
      <List<Map<String, dynamic>>>[].obs;

  List<Map<String, dynamic>> getOptionsPayload() {
    final payload = <Map<String, dynamic>>[];
    final options = attributeList.value.options ?? [];

    for (var i = 0; i < options.length; i++) {
      if (!selectedOptionIndexes.contains(i)) continue;

      final option = options[i];
      final configs = sizeConfigs[i];

      final choices = configs.map((config) {
        return {
          "name": config["name"].text.trim(),
          "price": config["price"].text.trim(),
        };
      }).toList();

      payload.add({
        "option_id": option.id.toString(),
        "choices": choices,
      });
    }

    return payload;
  }

  // attrabutes
  RxList<String> selectedAttributeIds = <String>[].obs;

  void setSelectedAttributes(List<String> ids) {
    selectedAttributeIds.value = ids;
  }

  void printOptionsPayload() {
    final payload = getOptionsPayload();

    // Pretty print JSON
    final prettyJson = const JsonEncoder.withIndent('  ').convert(payload);
    print("======== OPTIONS PAYLOAD ========");
    print(prettyJson);
    print("=================================");
  }

  //-----------------------------------------------------addons
  RxList<Map<String, dynamic>> addOnFieldKeys = <Map<String, dynamic>>[].obs;

  RxList<Addons> filteredAddOns = <Addons>[].obs;
  // Tracks the add-on rows currently opened
  RxList<Addons> openedAddOnRows = <Addons>[].obs;

// Tracks selected add-on ids for duplicate prevention
  RxList<String> selectedAddOnIds = <String>[].obs;
  final GlobalKey<FormState> addOnFormKey = GlobalKey<FormState>();

// Tracks price controllers per row
  RxList<TextEditingController> addOnPriceControllers =
      <TextEditingController>[].obs;

// Call this when category changes
  void filterAddOnsByCategory(String categoryId) {
    // Find category by ID
    Categories? category = apiCategoryData.value.categories?.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Categories(), // return empty category if not found
    );

    // Update filtered add-ons for that category
    filteredAddOns.value = category?.addons ?? [];

    // 🔄 Reset all existing states
    for (var c in addOnPriceControllers) {
      c.dispose(); // dispose old controllers
    }
    addOnPriceControllers.clear();
    openedAddOnRows.clear();
    selectedAddOnIds.clear();

    // ❌ DO NOT auto-open any row here
    // We’ll only open one when user taps “Add Add-on” in the UI
  }

  void printAddOnPayload() {
    final List<Map<String, dynamic>> payload = [];

    for (int i = 0; i < selectedAddOnIds.length; i++) {
      final id = selectedAddOnIds[i];
      final priceController = addOnPriceControllers[i];

      if (id.isNotEmpty && priceController.text.trim().isNotEmpty) {
        payload.add({
          "id": id,
          "price": double.tryParse(priceController.text.trim()) ?? 0.0,
        });
      }
    }

    debugPrint("🧾 Add-on Payload: $payload");
  }

  List<Map<String, dynamic>> buildAddOnPayload() {
    final List<Map<String, dynamic>> payload = [];

    for (int i = 0; i < selectedAddOnIds.length; i++) {
      final id = selectedAddOnIds[i];
      final priceController = addOnPriceControllers[i];

      if (id.isNotEmpty && priceController.text.trim().isNotEmpty) {
        payload.add({
          "id": id,
          "price": priceController.text.trim(),
        });
      }
    }

    debugPrint("🧾 Add-on Payload: $payload");
    return payload;
  }

//----------------------------------------------------------------------------------------

  void printFullProductPayload() {
    final productPayload = {
      "productTitle": titleController.value.text,
      "categoryId": selectedCategoryId.value,
      "status": status.value,
      "regularPrice": regularPriceController.value.text,
      "salePrice": salePriceController.value.text,
      "description": descriptionController.value.text,
      "cuisineType": selectedCuisineType.value,
      "menuSection": selectedMenuSection.value,
      "preparationTime": preparationController.value.text,
      "mainImage": imageBase64.value.isEmpty ? "No image" : "Image Base64 string (length: ${imageBase64.value.length})",
      "image0": additionalImageBase64[0].value.isEmpty ? "No image" : "Additional Image 0 (length: ${additionalImageBase64[0].value.length})",
      "image1": additionalImageBase64[1].value.isEmpty ? "No image" : "Additional Image 1 (length: ${additionalImageBase64[1].value.length})",
      "image2": additionalImageBase64[2].value.isEmpty ? "No image" : "Additional Image 2 (length: ${additionalImageBase64[2].value.length})",
      "image3": additionalImageBase64[3].value.isEmpty ? "No image" : "Additional Image 3 (length: ${additionalImageBase64[3].value.length})",
    };

    // 🔹 Print clean formatted JSON
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    debugPrint("============== FULL PRODUCT PAYLOAD ==============");
    debugPrint(encoder.convert(productPayload));
    debugPrint("==================================================");
  }

  RxBool activeSalePriceValidation = false.obs;

  RxInt addOnItemCount = 0.obs;

  RxList<TextEditingController> addOnControllersList = RxList<TextEditingController>([]);
  RxList<GlobalKey> addOnControllersKeyList = RxList<GlobalKey>([]);
  RxList<GlobalKey> addOnDropdownKeyList = RxList<GlobalKey>([]);

  final ImagePicker _picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = "".obs;
  RxList<Rx<File?>> additionalImages =
      RxList<Rx<File?>>.generate(6, (index) => Rx<File?>(null));
  RxList<RxString> additionalImageBase64 =
      RxList<RxString>.generate(6, (index) => ''.obs);
  XFile? _pickedFile;

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

  Future<String> convertImageToBase64(RxString imageBase64, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      imageBase64.value = base64Encode(bytes);
      log(imageBase64.value, name: "Base64IMAGE");
      return imageBase64.value;
    } catch (e) {
      print("Error converting image to Base64: $e");
      return '';
    }
  }

  Future<void> pickImage(BuildContext context) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _pickedFile = pickedImage;
      cropImage(image, imageBase64);
      update();
    }
  }

  Future<void> pickMoreImage(int index) async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _pickedFile = pickedImage;
      cropImage(additionalImages[index], additionalImageBase64[index]);
      update();
    }
  }

  static Future<XFile> compressImage({required File imageFile, int quality = 25, CompressFormat format = CompressFormat.jpeg,}) async {
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

  Rx<TextEditingController> useController = TextEditingController().obs;
  Rx<TextEditingController> weightController = TextEditingController().obs;
  Rx<TextEditingController> dosageController = TextEditingController().obs;
  Rx<TextEditingController> overDoseController = TextEditingController().obs;
  Rx<TextEditingController> interactionController = TextEditingController().obs;
  Rx<TextEditingController> sideEffectsController = TextEditingController().obs;
  Rx<TextEditingController> adviceController = TextEditingController().obs;
  Rx<TextEditingController> notUseController = TextEditingController().obs;
  Rx<TextEditingController> otherDetailsController = TextEditingController().obs;
  Rx<TextEditingController> warningsController = TextEditingController().obs;
  Rx<TextEditingController> conditionController = TextEditingController().obs;
  Rx<TextEditingController> modelController = TextEditingController().obs;

  RxString status = "1".obs;
  // RxList<Map<String, dynamic>> extraListOfMap = RxList<Map<String, dynamic>>([]);
  // RxList<Map<String, dynamic>> addOnListOfMap = RxList<Map<String, dynamic>>([]);

  @override
  void onInit() {
    getCategoryApi();
    // getAddOnApi();
    getCuisineTypeApi();
    if (customAttributes.isEmpty) {
      customAttributes.add(AttributeModel());
    }
    super.onInit();
  }

  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final api = Repository();
  final apiData = CommonAddProductModel().obs;
  void setRxRequestStatus(ApiStatus value) => rxRequestStatus.value = value;
  void addProductSet(CommonAddProductModel value) => apiData.value = value;
  void setError(String value) => error.value = value;

  Future<void> restaurantAddProductApi({
    required String productTitle,
    // required String skuTitle,
    required String categoryId,
    required String status,
    required String regularPrice,
    required String salePrice,
    required String description,
    required String cuisineType,
    required String mainImage,
    required String image0,
    required String image1,
    required String image2,
    required String image3,
    required String image4,
    required String image5,
    // required List<Map<String, dynamic>> extraListOfMap,
    // required List<Map<String, dynamic>> addOnListOfMap,
  }) async {
    final addOns = buildAddOnPayload();
    final options = getOptionsPayload();

    var data = {
      "title": productTitle,
      "category_id": categoryId,
      "regular_price": regularPrice,
      "sale_price": salePrice,
      "description": description,
      "status": status,
      "cuisine_id": cuisineType,
      "menu_section": formatToSnakeCase(selectedMenuSection.value.toLowerCase()),
      "preparation_time": preparationController.value.text,
      if (addOns.isNotEmpty) "addons": addOns,
      if (options.isNotEmpty) "options": options,
      if (selectedAttributeIds.isNotEmpty)
        "product_attributes": selectedAttributeIds,
      "image": mainImage,
      "addimg1": image0,
      "addimg2": image1,
      "addimg3": image2,
      "addimg4": image3,
      "addimg5": image4,
      "addimg6": image5,
    };

    debugPrint("📦 API DATA BODY => ${jsonEncode(data)}");

    setRxRequestStatus(ApiStatus.LOADING);

    await api.restaurantAddProductApi(jsonEncode(data)).then((value) {
      addProductSet(value);
      if (apiData.value.status == true) {
        // restaurantProductController.productApi();
        restaurantDashboardController.dashboardApi();
        setRxRequestStatus(ApiStatus.COMPLETED);
        Get.back(result: true);

        Utils.showToast(apiData.value.message ?? "Something went wrong!");
      } else {
        setError(error.toString());
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(apiData.value.errors?.first ?? "Something went wrong!",
            bgColor: AppColors.red);
      }
    }).onError((error, stackError) {
      setError(error.toString());
      Utils.showToast(apiData.value.message.toString());
      log(error.toString(), name: "add product error");
      setRxRequestStatus(ApiStatus.ERROR);
    });
  }

  final rxRequestCategoryStatus = ApiStatus.COMPLETED.obs;
  RxString categoryError = ''.obs;
  final apiCategoryData = CommonGetCategoryModel().obs;
  void setRxRequestCategoryStatus(ApiStatus value) =>
      rxRequestCategoryStatus.value = value;
  void categorySetData(CommonGetCategoryModel value) =>
      apiCategoryData.value = value;
  void setCategoryError(String value) => categoryError.value = value;
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<get category api>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> getCategoryApi() async {
    setRxRequestCategoryStatus(ApiStatus.LOADING);
    api.commonGetCategoryApi().then((value) {
      categorySetData(value);
      if (apiCategoryData.value.status == true) {
        // apiCategoryData.value.categories?.insert(0, Categories(id: "",name: "Choose Category"));
        // selectedCategoryId.value = apiCategoryData.value.categories![0].id!;
        // attributeList.value = apiCategoryData.value.categories![0];
        attributeList.value = Categories();
        if (attributeList.value.options != null) {
          sizeConfigs.value = List.generate(
            attributeList.value.options!.length,
            (_) => [], // empty list of name/price pairs for each option
          );
          selectedOptionIndexes.clear();
        }
        setRxRequestCategoryStatus(ApiStatus.COMPLETED);
      } else {
        print(categoryError);
        setRxRequestCategoryStatus(ApiStatus.ERROR);
      }
    }).onError((error, stackError) {
      setCategoryError(error.toString());
      print(error);
      setRxRequestCategoryStatus(ApiStatus.ERROR);
    });
  }

  RxString selectedCuisineType = "".obs;
  RxString selectedBrandType = "".obs;
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
        // apiCuisineTypeData.value.cuisine?.insert(0, Cuisine(name: "Choose Cuisine", id: ""));
        // selectedCuisineType.value = apiCuisineTypeData.value.cuisine![0].id!;
        setRxRequestCuisineTypeStatus(ApiStatus.COMPLETED);
      } else {
        print(error);
        setRxRequestCuisineTypeStatus(ApiStatus.ERROR);
      }
    }).onError((error, stackError) {
      setCuisineTypeError(error.toString());
      print(error);
      setRxRequestCuisineTypeStatus(ApiStatus.ERROR);
    });
  }

  List<String> departmentList = [
    "Mobiles",
    "Laptops",
    "Tablets",
    "Television",
    "Headphones & Earbuds",
    "Speakers",
    "Cameras",
    "Smart Watches",
    "Accessories",
    "Gaming Consoles",
    "Computer Accessories",
    "Home Appliances",
  ];
}

class StatusDropdownItem {
  final String name;
  final String id;

  StatusDropdownItem({required this.name, required this.id});
}

// Change your items to a list of DropdownItem objects
final statusItems = [
  StatusDropdownItem(name: "Active", id: "1"),
  StatusDropdownItem(name: "Inactive", id: "0"),
];

class DepartmentDropdownItem {
  final String id;
  final String name;

  DepartmentDropdownItem({required this.id, required this.name});
}

final departmentItems = [
  DepartmentDropdownItem(name: "Mobiles", id: "1"),
  DepartmentDropdownItem(name: "Laptops", id: "2"),
  DepartmentDropdownItem(name: "Tablets", id: "3"),
  DepartmentDropdownItem(name: "Television", id: "4"),
  DepartmentDropdownItem(name: "Headphones & Earbuds", id: "5"),
  DepartmentDropdownItem(name: "Speakers", id: "6"),
  DepartmentDropdownItem(name: "Cameras", id: "7"),
  DepartmentDropdownItem(name: "Smart Watches", id: "8"),
  DepartmentDropdownItem(name: "Accessories", id: "9"),
  DepartmentDropdownItem(name: "Gaming Consoles", id: "10"),
  DepartmentDropdownItem(name: "Computer Accessories", id: "11"),
  DepartmentDropdownItem(name: "Home Appliances", id: "12"),
];

class VariantModel {
  RxBool isSelected = true.obs;

  Map<String, String> values;
  String sku;
  RxDouble price = 0.0.obs;
  RxInt stock = 0.obs;

  VariantModel({
    required this.values,
    required this.sku,
  });
}
class AttributeModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
}