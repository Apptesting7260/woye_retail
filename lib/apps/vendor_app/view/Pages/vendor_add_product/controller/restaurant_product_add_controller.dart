import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/model/vendor_category_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Dashboard/controller/vendor_dashboard_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/view/vendor_menu_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/Models/vendor_product_attribute_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/Models/vendor_sub_categories_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/view/restaurant_add_product_screen.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/common_add_product_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/common_get_category_model.dart';
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
import '../../../../../../shared/widgets/vendor_widgets/print.dart';

class RestaurantProductAddController extends GetxController {
  final ScrollController scrollController = ScrollController();

  RxList<String> stockUnitSection = [
   "kg",
    "unit"
  ].obs;


  RxString selectedStockSection = "".obs;
  RxString selectedDepartment = "".obs;
  RxString department = ''.obs;
  RxString category = ''.obs;
  RxString subCategory = ''.obs;
  RxString selectedSubCategory = ''.obs;
  RxString selectedCategory = ''.obs;
  RxList<String> apiVariantAttributes = <String>[].obs;

  RxList<String> customVariantAttributes = <String>[].obs;


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
  RxString customAttrNameError = ''.obs;
  RxString customAttrValueError = ''.obs;
  RxList<String> selectedVariantAttributes = <String>[].obs;
  RxMap<String, String> attributeIdMap = <String, String>{}.obs; // attr name → attr id
  RxMap<String, RxList<String>> attributeValues = <String, RxList<String>>{}.obs;
  RxMap<String, TextEditingController> valueControllers = <String, TextEditingController>{}.obs;
  // ✅ Editable controllers for each saved value: attr → (oldValue → controller)
  RxMap<String, RxMap<String, TextEditingController>> savedValueControllers =
      <String, RxMap<String, TextEditingController>>{}.obs;
  TextEditingController customAttrNameController = TextEditingController();
  TextEditingController customAttrValueController = TextEditingController();
  RxMap<String, RxBool> showValueField = <String, RxBool>{}.obs;


  List<dynamic> get allVariantAttributes {
    return <dynamic>{
      ...apiVariantAttributes,
      ...customVariantAttributes,
    }.toList();
  }
  void toggleAttribute(String attr) {
    if (selectedVariantAttributes.contains(attr)) {
      selectedVariantAttributes.remove(attr);
      valueControllers.remove(attr);
      showValueField.remove(attr);
      attributeIdMap.remove(attr);
      return;
    }
    selectedVariantAttributes.add(attr);
    Attributes? apiAttr;
    try {
      apiAttr = attributeData.value.attributes?.firstWhere((e) => e.name == attr,
      );
    } catch (e) {
      apiAttr = null;
    }
    // ✅ Store the real attribute ID from API
    if (apiAttr?.id != null) {
      attributeIdMap[attr] = apiAttr!.id!;
    }
    final apiValues = apiAttr?.separateAttrValues ?? [];
    if (!attributeValues.containsKey(attr)) {
      attributeValues[attr] = apiValues.toSet().toList().obs;
    }
    // ✅ Initialize saved value controllers for existing values
    savedValueControllers.putIfAbsent(attr, () => <String, TextEditingController>{}.obs);
    for (var v in attributeValues[attr]!) {
      savedValueControllers[attr]!.putIfAbsent(v, () => TextEditingController(text: v));
    }
    valueControllers[attr] = TextEditingController();
    showValueField[attr] = false.obs;
    attributeValues.refresh();
  }

  void addAttributeValue(String attr) {
    String val = valueControllers[attr]?.text.trim() ?? "";
    if (val.isEmpty) return;

    if (attributeValues[attr]!.contains(val)) {
      Get.snackbar("Duplicate", "Value already exists");
      valueControllers[attr]!.clear();
      return;
    }
    attributeValues[attr]!.add(val);
    // ✅ Create editable controller for this saved value
    savedValueControllers.putIfAbsent(attr, () => <String, TextEditingController>{}.obs);
    savedValueControllers[attr]![val] = TextEditingController(text: val);
    valueControllers[attr]!.clear();
    // ⭐ Force refresh
    attributeValues.refresh();
    showValueField.refresh();
  }

  /// Update a saved value in-place
  void updateAttributeValue(String attr, String oldVal, String newVal) {
    final list = attributeValues[attr];
    if (list == null) return;
    final idx = list.indexOf(oldVal);
    if (idx == -1) return;
    list[idx] = newVal;
    // update controller key
    final ctrlMap = savedValueControllers[attr];
    if (ctrlMap != null) {
      final ctrl = ctrlMap.remove(oldVal);
      if (ctrl != null) ctrlMap[newVal] = ctrl;
    }
    attributeValues.refresh();
  }

  void removeAttributeValue(String attr, String value) {
    attributeValues[attr]?.remove(value);
    savedValueControllers[attr]?.remove(value);
    attributeValues.refresh();
  }
  TextEditingController basePriceController = TextEditingController();
  TextEditingController baseStockController = TextEditingController();


  void toggleValueField(String attr) {
    if (showValueField[attr]?.value == true) {
      String currentVal = valueControllers[attr]?.text.trim() ?? "";
      if (currentVal.isNotEmpty) {
        addAttributeValue(attr);
      }
      showValueField[attr]?.value = false;
      Future.delayed(Duration(milliseconds: 50), () {
        showValueField[attr]?.value = true;
      });
    } else {
      showValueField[attr]?.value = true;
    }
  }
  void addCustomAttribute() {
    final name = customAttrNameController.text.trim();
    final valuesText = customAttrValueController.text.trim();
    allVariantAttributes.any((e) => e.toLowerCase() == name.toLowerCase(),);
    customVariantAttributes.add(name);
    selectedVariantAttributes.add(name);

    // create empty list
    attributeValues[name] = <String>[].obs;

    // controller create
    valueControllers[name] = TextEditingController();

    // ⭐ YE LINE ADD KARO - BAHUT ZAROORI HAI ⭐
    showValueField[name] = false.obs;

    // ✅ savedValueControllers initialize
    savedValueControllers.putIfAbsent(name, () => <String, TextEditingController>{}.obs);

    // values add
    if (valuesText.isNotEmpty) {
      List<String> values = valuesText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      attributeValues[name]!.assignAll(values);
      // ✅ Create saved controllers for each value
      for (var v in values) {
        savedValueControllers[name]!.putIfAbsent(v, () => TextEditingController(text: v));
      }
    }

    // refresh
    selectedVariantAttributes.refresh();
    attributeValues.refresh();

    // clear
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
  void setAttributeData() {

    apiVariantAttributes.clear();

    final attrs = attributeData.value.attributes ?? [];

    for (var item in attrs) {

      if (item.name != null &&
          item.name!.trim().isNotEmpty) {

        apiVariantAttributes.add(item.name!.trim());
      }
    }
  }
  // ✅ Generate Variants — same logic as JS generateVariants
  void generateVariants() {
    variantList.clear();

    if (selectedVariantAttributes.isEmpty) return;

    // Step 1: Build ordered attribute list (deduplicated by name, same as JS uniqueAttributes Map)
    final List<Map<String, dynamic>> attributes = [];
    final Set<String> seenNames = {};
    for (var attr in selectedVariantAttributes) {
      final name = attr.trim();
      if (seenNames.contains(name)) continue;
      seenNames.add(name);
      final values = attributeValues[attr]?.toList() ?? [];
      if (values.isEmpty) continue;
      attributes.add({
        'id': attributeIdMap[attr] ?? '0',
        'name': name,
        'values': values,
      });
    }

    if (attributes.isEmpty) return;

    // Step 2: Cartesian product (same as JS getCartesianProduct)
    List<List<Map<String, String>>> combinations = [[]];
    for (var attr in attributes) {
      final List<String> vals = List<String>.from(attr['values']);
      final List<List<Map<String, String>>> newCombinations = [];
      for (var combo in combinations) {
        for (var val in vals) {
          newCombinations.add([
            ...combo,
            {
              'attribute_id': attr['id'] as String,
              'attribute_name': attr['name'] as String,
              'attribute_value': val,
            }
          ]);
        }
      }
      combinations = newCombinations;
    }

    // Step 3: Build each variant
    for (var combo in combinations) {
      final skuParts = combo.map((c) => c['attribute_value']!.trim().toUpperCase()).join('-');
      final sku = 'PRD-$skuParts';
      variantList.add(VariantModel(values: {
        for (var c in combo) c['attribute_name']!: c['attribute_value']!
      }, sku: sku));
    }
  }

  final GlobalKey titleKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey packageKey = GlobalKey();
  final GlobalKey weightKey = GlobalKey();
  final GlobalKey modelNoKey = GlobalKey();
  final GlobalKey categoryKey = GlobalKey();
  final GlobalKey regularKey = GlobalKey();
  final GlobalKey saleKey = GlobalKey();
  final GlobalKey cuisineKey = GlobalKey();
  final GlobalKey stockSectionKey = GlobalKey();
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
  final GlobalKey customAttributeFormKey = GlobalKey();
  final GlobalKey subCategoryKey = GlobalKey();
  final GlobalKey departmentKey = GlobalKey();
  final GlobalKey conditionKey = GlobalKey();

  void scrollToField(GlobalKey key, {double? alignment}) {
    BuildContext? context = key.currentContext;
    if (context != null) {
      print("Scrolling to field: ${key.toString()}");
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: alignment ?? 0,
      );
    }
  }

  void validateAndAddCustomAttribute() {
    customAttrNameError.value = '';
    customAttrValueError.value = '';
    final name = customAttrNameController.text.trim();
    final value = customAttrValueController.text.trim();
    bool hasError = false;
    if (name.isEmpty && value.isEmpty) {
      return;
    }
    if (name.isEmpty && value.isNotEmpty) {
      customAttrNameError.value = 'Enter attribute name first';
      hasError = true;
    }
    if (name.isNotEmpty && value.isEmpty) {
      customAttrValueError.value = 'Enter at least one value';
      hasError = true;
    }
    if (!hasError) {
      addCustomAttribute();
      customAttrNameController.clear();
      customAttrValueController.clear();
    }
  }

  RxList<String> selectedAddons = RxList<String>([]);
  RxBool isExtraValidationError = false.obs;

  RxBool isErrorColor = false.obs;

  // RxBool isRedColor = false.obs;
  RxBool isDropdownOpen = false.obs;

  final VendorDashboardController restaurantDashboardController = Get.put(
      VendorDashboardController());
  GlobalKey<FormState> publishButtonKey = GlobalKey<FormState>();
  GlobalKey<FormState> addOnButtonKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> indexedKey = [];

  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> skuController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> regularPriceController = TextEditingController().obs;
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
  RxString selectedDepartmentId = "".obs;
  RxString selectedAttributeId = "".obs;
  RxMap<String, TextEditingController> additionalControllers = <String, TextEditingController>{}.obs;

  Rx<VendorCategories> attributeList = Rx<VendorCategories>(VendorCategories());
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


  // attrabutes
  RxList<String> selectedAttributeIds = <String>[].obs;

  void setSelectedAttributes(List<String> ids) {
    selectedAttributeIds.value = ids;
  }

//----------------------------------------------------------------------------------------

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
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedImage != null) {
      _pickedFile = pickedImage;
      cropImage(additionalImages[index], additionalImageBase64[index]);
      update();
    }
  }

  static Future<XFile> compressImage(
      {required File imageFile, int quality = 25, CompressFormat format = CompressFormat
          .jpeg,}) async {
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
    getDepartmentApi();

    // getAddOnApi();
    getVendorCategoriesApi();
    // getVendorCategoriesApi(quer);
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
    required String categoryId,
    required String status,
    required String regularPrice,
    required String description,
    required String mainImage,
    required String stockQty,
    required String image0,
    required String image1,
    required String image2,
    required String image3,
    required String image4,
    required String image5,
  }) async {
    Map<String, dynamic> additionalDetails = {};
    attributeData.value.additionalDetails?.forEach((detail) {
      final key = detail.slug ?? "";
      final controller = additionalControllers[key];
      additionalDetails[key] = controller?.text.trim() ?? "";
    });

    Map<String, dynamic> data = {
      "title": productTitle,
      "description": description,
      "regular_price": regularPrice,
      "seller_sku": skuController.value.text,
      "department": selectedDepartmentId.value,
      "category": selectedCategoryId.value,
      "sub_category": selectedAttributeId.value,
      "quantity_in_stock": stockQty,
      "stock_unit": selectedStockSection.value.toLowerCase(),
      "bar_code": barcodeController.value.text,
      "conditions": conditionController.value.text,
      "package_dimension": packageController.value.text,
      "weight": weightController.value.text,
      "promo_price": promoController.value.text,
      "fullfillment_type": fulfillmentController.value.text,
      "order_preparation_time": preparationController.value.text,
      "status": status,
      "image": mainImage,
      "addimg1": image0,
      "addimg2": image1,
      "addimg3": image2,
      "addimg4": image3,
      "addimg5": image4,
      "addimg6": image5,
      "additional_details[modal_number]": additionalDetails["modal-number"] ?? "",
      "has_variants": hasVariants.value ? "1" : "0",
    };
    for (int i = 0; i < selectedVariantAttributes.length; i++) {
      data["variant_attribute[$i]"] = selectedVariantAttributes[i];
    }

    for (var attr in selectedVariantAttributes) {
      final values = attributeValues[attr] ?? [];
      for (int i = 0; i < values.length; i++) {
        data["value[$attr][$i]"] = values[i];
      }
    }
    for (int i = 0; i < variantList.length; i++) {
      final variant = variantList[i];
      data["variants[$i][enabled]"] = variant.isSelected.value ? "1" : "0";
      final cleanSku = variant.sku.replaceAll("PRD-", "");
      data["variants[$i][variant_name]"] = cleanSku;
      data["variants[$i][sku]"] = "PRD-$cleanSku";
      data["variants[$i][price]"] = (variant.price.value <= 0 ? 1 : variant.price.value).toString();
      data["variants[$i][stock]"] = (variant.stock.value <= 0 ? 1 : variant.stock.value).toString();
      int attrIndex = 0;
      variant.values.forEach((key, value) {
        // ✅ Use real attribute ID from map, fallback to "0" if custom attribute
        final attrId = attributeIdMap[key] ?? "0";
        data["variants[$i][attributes][$attrIndex][attribute_id]"] = attrId;
        data["variants[$i][attributes][$attrIndex][attribute_name]"] = key;
        data["variants[$i][attributes][$attrIndex][attribute_value]"] = value;
        attrIndex++;
      });
    }
    data.forEach((key, value) {
      pt("$key => $value");
    });
    try {
      setRxRequestStatus(ApiStatus.LOADING);
      final value = await api.restaurantAddProductApi(data);
      addProductSet(value);
      if (apiData.value.status == true) {
        restaurantDashboardController.dashboardApi();
        setRxRequestStatus(ApiStatus.COMPLETED);
        // Get.back(result: true);
        Get.offAll(() => VendorMenuScreen());
        Utils.showToast(apiData.value.message ?? "Product Added Successfully");
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(
          (apiData.value.errors != null && apiData.value.errors!.isNotEmpty) ?
          apiData.value.errors!.first : apiData.value.message ?? "Something went wrong",
        );
      }
    } catch (error, stackError) {
      pt("ERROR => $error");
      pt("STACK => $stackError");
      setRxRequestStatus(ApiStatus.ERROR);
      Utils.showToast(error.toString());
    }
  }
  final rxRequestCategoryStatus = ApiStatus.COMPLETED.obs;
  RxString categoryError = ''.obs;
  final apiCategoryData = GetDepartmentModel().obs;
  void setRxRequestCategoryStatus(ApiStatus value) => rxRequestCategoryStatus.value = value;
  void categorySetData(GetDepartmentModel value) => apiCategoryData.value = value;
  void setCategoryError(String value) => categoryError.value = value;
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<get category api>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> getDepartmentApi() async {
    setRxRequestCategoryStatus(ApiStatus.LOADING);
    api.commonGetDepartmentApi().then((value) {
      categorySetData(value);
      if (apiCategoryData.value.status == true) {
        setRxRequestCategoryStatus(ApiStatus.COMPLETED);
      } else {
        pt(">categoryError>>>>>>>>>>$categoryError");
        setRxRequestCategoryStatus(ApiStatus.ERROR);
      }
    }).onError((error, stackError) {
      setCategoryError(error.toString());
      pt("$error");
      setRxRequestCategoryStatus(ApiStatus.ERROR);
    });
  }


  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>getCategoriesApi>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  final rxRequestStatus1 = ApiStatus.COMPLETED.obs;

  void setRxRequestStatus1(ApiStatus value) => rxRequestStatus1.value = value;

  final categoriesData = CommonGetCategoryModel().obs;

  void categoriesSet(CommonGetCategoryModel value) =>
      categoriesData.value = value;

  getVendorCategoriesApi() async {
    pt("🔵 Department ID: ${selectedDepartmentId.value}");

    setRxRequestStatus1(ApiStatus.LOADING);
    api.getVendorCategoriesApi(
      queryParameters: {
        "id": selectedDepartmentId.value,
      },
    ).then((value) {
      categoriesSet(value);
      if (categoriesData.value.status == true) {
        setRxRequestStatus1(ApiStatus.COMPLETED);
      } else {
        setRxRequestStatus1(ApiStatus.ERROR);
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus1(ApiStatus.ERROR);
      print(error);
    });
  }

  final rxRequestStatus2 = ApiStatus.COMPLETED.obs;

  void setRxRequestStatus2(ApiStatus value) => rxRequestStatus2.value = value;

  final subCategoriesData = VendorSubCategoriesModel().obs;

  void subCategoriesSet(VendorSubCategoriesModel value) => subCategoriesData.value = value;

  getVendorSubCategoriesApi() async {
    pt("🔵 Category ID: ${selectedCategoryId.value}");

    setRxRequestStatus2(ApiStatus.LOADING);
    api.getVendorSubCategoriesApi(
      queryParameters: {
        "id": selectedCategoryId.value,
      },
    ).then((value) {
      subCategoriesSet(value);
      if (categoriesData.value.status == true) {
        setRxRequestStatus2(ApiStatus.COMPLETED);
      } else {
        setRxRequestStatus2(ApiStatus.ERROR);
      }
    }).onError((error, stackTrace) {
      setRxRequestStatus2(ApiStatus.ERROR);
      print(error);
    });
  }



final  rxRequestStatus3 = ApiStatus.COMPLETED.obs;
  void setRxRequestStatus3(ApiStatus value) => rxRequestStatus3.value = value;
  final attributeData = VendorProductAttributeModel().obs;
   void attributeSet (VendorProductAttributeModel value) => attributeData.value = value;
   getVendorProductAttributeApi() async {
     setRxRequestStatus3(ApiStatus.LOADING);
     api.getVendorProductAttributeApi(
       queryParameters: {
       "id": selectedAttributeId.value,
     },
     ).then((value){
       attributeSet(value);
       setAttributeData();
       if (categoriesData.value.status == true) {
         setRxRequestStatus3(ApiStatus.COMPLETED);
       } else {
         setRxRequestStatus3(ApiStatus.ERROR);
       }
     }).onError((error, stackTrace) {
       setRxRequestStatus3(ApiStatus.ERROR);
       pt("$error");
     }
     );
   }
  Map<String, GlobalKey> additionalFieldKeys = {};
  Rx<VendorProductAttributeModel> vendorProductAttributeModel =
      VendorProductAttributeModel().obs;
  Map<String, FocusNode> additionalFocusNodes = {};
  Future<bool> validateBeforeReview() async {

     bool isValid = publishButtonKey.currentState?.validate() ?? false;
    if (!isValid) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (titleController.value.text.trim().isEmpty) {
        scrollToField(titleKey);
        return false;
      }
      if (descriptionController.value.text.trim().isEmpty) {
        scrollToField(descriptionKey);
        return false;
      }
      if (regularPriceController.value.text.trim().isEmpty) {
        scrollToField(regularKey);
        return false;
      }
      if (stockController.value.text.trim().isEmpty) {
        scrollToField(stockKey);
        return false;
      }
      if (skuController.value.text.trim().isEmpty) {
        scrollToField(skuKey);
        return false;
      }
      if (barcodeController.value.text.trim().isEmpty) {
        scrollToField(barcodeKey);
        return false;
      }
      if (conditionController.value.text.trim().isEmpty) {
        scrollToField(conditionKey);
        return false;
      }
      if (packageController.value.text.trim().isEmpty) {
        scrollToField(packageKey);
        return false;
      }
      if (weightController.value.text.trim().isEmpty) {
        scrollToField(weightKey);
        return false;
      }
      if (fulfillmentController.value.text.trim().isEmpty) {
        scrollToField(fulfillmentKey);
        return false;
      }
      if (preparationController.value.text.trim().isEmpty) {
        scrollToField(preparationKey);
        return false;
      }
      return false;
    }
    if (imageBase64.value.isEmpty) {
      isErrorColor.value = true;
      scrollToTop(0);
      return false;
    }
    if (selectedStockSection.value.isEmpty) {
      scrollToField(stockSectionKey);
      return false;
    }
    if (department.value.isEmpty) {
      scrollToField(departmentKey);
      return false;
    }
    if (category.value.isEmpty) {
      scrollToField(categoryKey);
      return false;
    }
    if (subCategory.value.isEmpty) {
      scrollToField(subCategoryKey);
      return false;
    }
    if (selectedCategoryId.value.trim().isEmpty) {
      scrollToField(categoryKey);
      return false;
    }

     for (var item
     in vendorProductAttributeModel.value.additionalDetails ?? []) {

       String slug = item.slug ?? "";

       String value =
           additionalControllers[slug]?.text.trim() ?? "";

       if (value.isEmpty) {

         GlobalKey? fieldKey = additionalFieldKeys[slug];

         if (fieldKey != null) {

           await Future.delayed(
             const Duration(milliseconds: 100),
           );

           scrollToField(fieldKey);
         }

         return false;
       }
     }
    if (status.value.trim().isEmpty) {
      scrollToField(stockSectionKey);
      return false;
    }
    return true;
  }}

class StatusDropdownItem {
  final String name;
  final String id;

  StatusDropdownItem({required this.name, required this.id});
}

final statusItems = [
  StatusDropdownItem(name: "Active", id: "1"),
  StatusDropdownItem(name: "Inactive", id: "0"),
];

class DepartmentDropdownItem {
  final String id;
  final String name;

  DepartmentDropdownItem({required this.id, required this.name});
}

class VariantModel {
  RxBool isSelected = true.obs;

  Map<String, String> values;
  String sku;
  RxDouble price = 0.0.obs;
  RxInt stock = 0.obs;
  String variantId; // existing variant ID for edit mode

  VariantModel({
    required this.values,
    required this.sku,
    this.variantId = '',
  });
}
class AttributeModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
}