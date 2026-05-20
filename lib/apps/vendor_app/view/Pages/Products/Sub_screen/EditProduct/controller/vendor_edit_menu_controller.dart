import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gyaawa/Data/Repository/repository.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/Products/controller/vendor_product_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/menu/controller/vendor_menu_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/Models/vendor_product_attribute_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/Models/vendor_sub_categories_model.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/vendor_add_product/controller/restaurant_product_add_controller.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/ChooseVendorCategories/model/vendor_category_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/common_add_product_model.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/Models/common_get_category_model.dart';
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
import '../Model/res_single_product_model.dart';

class VendorEditMenuController extends GetxController {
  final VendorProductController restaurantProductController = Get.put(VendorProductController());
  final VendorMenuController restaurantMenuController =
      Get.isRegistered<VendorMenuController>() ? Get.find<VendorMenuController>() : Get.put(VendorMenuController());

  final ScrollController scrollController = ScrollController();
  GlobalKey<FormState> publishButtonKey = GlobalKey<FormState>();

  // ─── GlobalKeys for scroll-to-field ──────────────────────────────────────
  final GlobalKey titleKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();
  final GlobalKey regularKey = GlobalKey();
  final GlobalKey promoKey = GlobalKey();
  final GlobalKey stockKey = GlobalKey();
  final GlobalKey stockSectionKey = GlobalKey();
  final GlobalKey skuKey = GlobalKey();
  final GlobalKey barcodeKey = GlobalKey();
  final GlobalKey conditionKey = GlobalKey();
  final GlobalKey packageKey = GlobalKey();
  final GlobalKey weightKey = GlobalKey();
  final GlobalKey fulfillmentKey = GlobalKey();
  final GlobalKey preparationKey = GlobalKey();
  final GlobalKey departmentKey = GlobalKey();
  final GlobalKey categoryKey = GlobalKey();
  final GlobalKey subCategoryKey = GlobalKey();

  void scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.02);
    }
  }

  // ─── TextEditingControllers (same as add product) ────────────────────────
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  Rx<TextEditingController> regularPriceController = TextEditingController().obs;
  Rx<TextEditingController> promoController = TextEditingController().obs;
  Rx<TextEditingController> stockController = TextEditingController().obs;
  Rx<TextEditingController> skuController = TextEditingController().obs;
  Rx<TextEditingController> barcodeController = TextEditingController().obs;
  Rx<TextEditingController> conditionController = TextEditingController().obs;
  Rx<TextEditingController> packageController = TextEditingController().obs;
  Rx<TextEditingController> weightController = TextEditingController().obs;
  Rx<TextEditingController> fulfillmentController = TextEditingController().obs;
  Rx<TextEditingController> preparationController = TextEditingController().obs;

  // ─── Department / Category / SubCategory (same as add product) ───────────
  RxString selectedDepartmentId = "".obs;
  RxString department = ''.obs;
  RxString selectedCategoryId = "".obs;
  RxString category = ''.obs;
  RxString selectedSubCategoryId = "".obs;
  RxString subCategory = ''.obs;

  RxList<String> stockUnitSection = ["kg", "unit"].obs;
  RxString selectedStockSection = "".obs;
  RxString status = "active".obs;
  RxBool isErrorColor = false.obs;
  RxBool activeSalePriceValidation = false.obs;

  // ─── Image ────────────────────────────────────────────────────────────────
  final ImagePicker _picker = ImagePicker();
  Rx<File?> image = Rx<File?>(null);
  RxString imageBase64 = "".obs;
  RxString mainUrlImage = "".obs;
  RxList<Rx<File?>> additionalImages = RxList<Rx<File?>>.generate(6, (i) => Rx<File?>(null));
  RxList<RxString> additionalImageBase64 = RxList<RxString>.generate(6, (i) => ''.obs);
  RxList<RxString> additionalImageFromApi = RxList<RxString>.generate(6, (i) => ''.obs);
  XFile? _pickedFile;

  // ─── Variant Section (identical to add product) ───────────────────────────
  RxBool hasVariants = false.obs;
  RxList<String> apiVariantAttributes = <String>[].obs;
  RxList<String> customVariantAttributes = <String>[].obs;
  RxList<String> selectedVariantAttributes = <String>[].obs;
  RxList<String> generatedTableAttributes = <String>[].obs;
  RxMap<String, String> attributeIdMap = <String, String>{}.obs;
  RxMap<String, RxList<String>> attributeValues = <String, RxList<String>>{}.obs;
  RxMap<String, TextEditingController> valueControllers = <String, TextEditingController>{}.obs;
  // ✅ Editable controllers for each saved value
  RxMap<String, RxMap<String, TextEditingController>> savedValueControllers =
      <String, RxMap<String, TextEditingController>>{}.obs;
  RxMap<String, RxBool> showValueField = <String, RxBool>{}.obs;
  RxList<VariantModel> variantList = <VariantModel>[].obs;
  TextEditingController customAttrNameController = TextEditingController();
  TextEditingController customAttrValueController = TextEditingController();
  RxString customAttrNameError = ''.obs;
  RxString customAttrValueError = ''.obs;
  final Rx<VendorProductAttributeModel> attributeData = VendorProductAttributeModel().obs;
  RxMap<String, TextEditingController> additionalControllers = <String, TextEditingController>{}.obs;

  List<dynamic> get allVariantAttributes => <dynamic>{
        ...apiVariantAttributes,
        ...customVariantAttributes,
      }.toList();

  // ─── API data ─────────────────────────────────────────────────────────────
  final api = Repository();
  RxString productId = ''.obs;
  final rxRequestStatus = ApiStatus.COMPLETED.obs;
  final rxRequestCategoryStatus = ApiStatus.COMPLETED.obs;
  final rxRequestStatus1 = ApiStatus.COMPLETED.obs;
  final rxRequestStatus2 = ApiStatus.COMPLETED.obs;
  final rxRequestStatus3 = ApiStatus.COMPLETED.obs;
  RxString error = ''.obs;
  final apiData = CommonAddProductModel().obs;
  final apiSingleProductData = ResSingleProductModel().obs;
  final apiCategoryData = GetDepartmentModel().obs;  // departments
  final categoriesData = CommonGetCategoryModel().obs;  // categories by dept
  final subCategoriesData = VendorSubCategoriesModel().obs;

  void setRxRequestStatus(ApiStatus v) => rxRequestStatus.value = v;
  void setRxRequestCategoryStatus(ApiStatus v) => rxRequestCategoryStatus.value = v;
  void setRxRequestStatus1(ApiStatus v) => rxRequestStatus1.value = v;
  void setRxRequestStatus2(ApiStatus v) => rxRequestStatus2.value = v;
  void setRxRequestStatus3(ApiStatus v) => rxRequestStatus3.value = v;

  // ─── onInit ───────────────────────────────────────────────────────────────
  @override
  void onInit() async {
    productId.value = Get.arguments ?? '';
    await getDepartmentApi();
    await getSingleProductApi(productId: productId.value);
    super.onInit();
  }

  // ─── Department API ───────────────────────────────────────────────────────
  Future<void> getDepartmentApi() async {
    setRxRequestCategoryStatus(ApiStatus.LOADING);
    api.commonGetDepartmentApi().then((value) {
      apiCategoryData.value = value;
      if (apiCategoryData.value.status == true) {
        setRxRequestCategoryStatus(ApiStatus.COMPLETED);
      } else {
        setRxRequestCategoryStatus(ApiStatus.ERROR);
      }
    }).onError((e, _) {
      error.value = e.toString();
      setRxRequestCategoryStatus(ApiStatus.ERROR);
    });
  }

  // ─── Categories by Department ─────────────────────────────────────────────
  Future<void> getVendorCategoriesApi() async {
    setRxRequestStatus1(ApiStatus.LOADING);
    api.getVendorCategoriesApi(queryParameters: {"id": selectedDepartmentId.value}).then((value) {
      categoriesData.value = value;
      setRxRequestStatus1(categoriesData.value.status == true ? ApiStatus.COMPLETED : ApiStatus.ERROR);
    }).onError((e, _) {
      setRxRequestStatus1(ApiStatus.ERROR);
      pt("$e");
    });
  }

  // ─── SubCategories by Category ────────────────────────────────────────────
  Future<void> getVendorSubCategoriesApi() async {
    setRxRequestStatus2(ApiStatus.LOADING);
    api.getVendorSubCategoriesApi(queryParameters: {"id": selectedCategoryId.value}).then((value) {
      subCategoriesData.value = value;
      setRxRequestStatus2(subCategoriesData.value.status == true ? ApiStatus.COMPLETED : ApiStatus.ERROR);
    }).onError((e, _) {
      setRxRequestStatus2(ApiStatus.ERROR);
      pt("$e");
    });
  }

  // ─── Attributes by SubCategory ────────────────────────────────────────────
  Future<void> getVendorProductAttributeApi() async {
    setRxRequestStatus3(ApiStatus.LOADING);
    api.getVendorProductAttributeApi(queryParameters: {"id": selectedSubCategoryId.value}).then((value) {
      attributeData.value = value;
      _setAttributeDataFromApi();
      setRxRequestStatus3(attributeData.value.status == true ? ApiStatus.COMPLETED : ApiStatus.ERROR);
    }).onError((e, _) {
      setRxRequestStatus3(ApiStatus.ERROR);
      pt("$e");
    });
  }

  void _setAttributeDataFromApi() {
    apiVariantAttributes.clear();
    for (var item in (attributeData.value.attributes ?? [])) {
      if (item.name != null && item.name!.trim().isNotEmpty) {
        apiVariantAttributes.add(item.name!.trim());
      }
    }
  }

  // ─── Get Single Product & Prefill ─────────────────────────────────────────
  Future<void> getSingleProductApi({required String productId}) async {
    setRxRequestCategoryStatus(ApiStatus.LOADING);
    api.getSingleProductsApi(productId: productId).then((value) async {
      apiSingleProductData.value = value;
      if (apiSingleProductData.value.status == true) {
        final p = apiSingleProductData.value.product!;

        // Basic fields
        titleController.value.text = p.title ?? "";
        descriptionController.value.text = p.description ?? "";
        regularPriceController.value.text = p.regularPrice ?? "";
        promoController.value.text = p.promoPrice ?? "";
        stockController.value.text = p.quantityInStock ?? "";
        skuController.value.text = p.sellerSku ?? "";
        barcodeController.value.text = p.barCode ?? "";
        conditionController.value.text = p.conditions ?? "";
        packageController.value.text = p.packageDimension ?? "";
        weightController.value.text = p.weight ?? "";
        fulfillmentController.value.text = p.fullfillmentType ?? "";
        preparationController.value.text = p.orderPreparationTime ?? "";
        status.value = p.status ?? "active";
        selectedStockSection.value = p.stockUnit ?? "";

        // Main image
        mainUrlImage.value = p.imageUrl ?? "";
        imageBase64.value = p.imageUrl ?? "";

        // Additional images
        final urls = p.addimgUrl ?? [];
        for (int i = 0; i < urls.length && i < 6; i++) {
          additionalImageFromApi[i].value = urls[i];
          additionalImageBase64[i].value = urls[i];
        }

        // Department → Category → SubCategory chain prefill
        selectedDepartmentId.value = p.department ?? "";
        selectedCategoryId.value = p.category ?? "";
        selectedSubCategoryId.value = p.subCategory ?? "";

        // Set display names from detail objects
        department.value = p.departmentDetail?.name ?? p.departmentName ?? "";
        category.value = p.categoryDetail?.name ?? p.categoryName ?? "";
        subCategory.value = p.subCategoryDetail?.name ?? p.subCategoryName ?? "";

        // Load categories chain for dropdowns
        if (selectedDepartmentId.value.isNotEmpty) {
          await getVendorCategoriesApi();
        }
        if (selectedCategoryId.value.isNotEmpty) {
          await getVendorSubCategoriesApi();
        }
        if (selectedSubCategoryId.value.isNotEmpty) {
          await getVendorProductAttributeApi();
          // Prefill additional details
          _prefillAdditionalDetails(p.additionalDetails);
        }

        // Variants — call after attribute API so apiVariantAttributes is populated
        _prefillVariants();

        setRxRequestCategoryStatus(ApiStatus.COMPLETED);
      }
    }).onError((e, _) {
      error.value = e.toString();
      pt("getSingleProductApi error: $e");
      setRxRequestCategoryStatus(ApiStatus.ERROR);
    });
  }

  void _prefillAdditionalDetails(String? additionalDetailsJson) {
    if (additionalDetailsJson == null || additionalDetailsJson.isEmpty) return;
    try {
      final Map<String, dynamic> parsed = jsonDecode(additionalDetailsJson);
      parsed.forEach((key, value) {
        additionalControllers.putIfAbsent(key, () => TextEditingController());
        additionalControllers[key]!.text = value?.toString() ?? "";
      });
    } catch (_) {}
  }

  // ─── Variant Prefill ──────────────────────────────────────────────────────
  void _prefillVariants() {
    final product = apiSingleProductData.value.product;
    hasVariants.value = product?.hasVariant == '1';
    if (!hasVariants.value) return;

    final variantItems = apiSingleProductData.value.getProductVariantsList;
    final detailVariants = product?.variants ?? [];

    // Build attrId → name map
    final Map<String, String> attrIdToName = {};
    for (var v in detailVariants) {
      for (var attr in (v.attributes ?? [])) {
        final id = attr.attributeId ?? '';
        if (attr.attribute?.name != null) attrIdToName[id] = attr.attribute!.name!;
      }
    }
    if (variantItems != null) {
      for (var v in variantItems) {
        for (var attr in (v.attributes ?? [])) {
          final id = attr.attributeId ?? '';
          final name = attr.attributeName ?? '';
          if (name.isNotEmpty && name != 'Unknown') attrIdToName[id] = name;
        }
      }
    }

    final sourceVariants = (variantItems != null && variantItems.isNotEmpty)
        ? variantItems.map((v) => _VariantProxy(
              id: v.id,
              sku: v.sku,
              price: v.price,
              stock: v.stock,
              isEnabled: v.isEnabled,
              attrs: (v.attributes ?? [])
                  .map((a) => _AttrProxy(a.attributeId, a.attributeName, a.attributeValue))
                  .toList(),
            )).toList()
        : detailVariants.map((v) => _VariantProxy(
              id: v.id,
              sku: v.sku,
              price: v.price,
              stock: v.stock,
              isEnabled: v.isEnabled,
              attrs: (v.attributes ?? [])
                  .map((a) => _AttrProxy(a.attributeId, a.attribute?.name, a.attributeValue))
                  .toList(),
            )).toList();

    if (sourceVariants.isEmpty) return;

    // Collect unique values per attrName
    final Map<String, Set<String>> attrNameToValues = {};
    for (var v in sourceVariants) {
      for (var attr in v.attrs) {
        final id = attr.id ?? '';
        final fallbackName = attr.name ?? '';
        final name = attrIdToName[id] ?? (fallbackName.isNotEmpty ? fallbackName : 'Attribute_$id');
        final val = attr.value ?? '';
        if (val.isNotEmpty && name.isNotEmpty) {
          attrNameToValues.putIfAbsent(name, () => <String>{});
          attrNameToValues[name]!.add(val);
          if (id.isNotEmpty && !attributeIdMap.containsKey(name)) {
            attributeIdMap[name] = id;
          }
        }
      }
    }

    // Build selectedVariantAttributes from first variant's attribute order
    selectedVariantAttributes.clear();
    attributeValues.clear();
    valueControllers.clear();
    showValueField.clear();

    for (var attr in sourceVariants.first.attrs) {
      final id = attr.id ?? '';
      final fallbackName = attr.name ?? '';
      final name = attrIdToName[id] ?? (fallbackName.isNotEmpty ? fallbackName : 'Attribute_$id');
      
      if (name.isNotEmpty && !selectedVariantAttributes.contains(name)) {
        selectedVariantAttributes.add(name);
        attributeValues[name] = (attrNameToValues[name]?.toList() ?? []).obs;
        valueControllers[name] = TextEditingController();
        showValueField[name] = false.obs;

        // ✅ Initialize savedValueControllers for prefilled values
        savedValueControllers.putIfAbsent(name, () => <String, TextEditingController>{}.obs);
        for (var v in attributeValues[name]!) {
          savedValueControllers[name]!.putIfAbsent(v, () => TextEditingController(text: v));
        }

        // Also add to apiVariantAttributes if not already there
        if (!apiVariantAttributes.contains(name)) {
          apiVariantAttributes.add(name);
        }
      }
    }

    // Build variantList
    variantList.clear();
    for (var sv in sourceVariants) {
      final Map<String, String> combo = {};
      for (var attr in sv.attrs) {
        final id = attr.id ?? '';
        final fallbackName = attr.name ?? '';
        final name = attrIdToName[id] ?? (fallbackName.isNotEmpty ? fallbackName : 'Attribute_$id');
        combo[name] = attr.value ?? '';
      }
      final vm = VariantModel(values: combo, sku: sv.sku ?? '', variantId: sv.id ?? '');
      vm.isSelected.value = sv.isEnabled ?? true;
      vm.price.value = double.tryParse(sv.price ?? '0') ?? 0;
      vm.stock.value = int.tryParse(sv.stock ?? '0') ?? 0;
      variantList.add(vm);
    }

    selectedVariantAttributes.refresh();
    generatedTableAttributes.value = List.from(selectedVariantAttributes);
    attributeValues.refresh();
    variantList.refresh();
    apiVariantAttributes.refresh();
  }

  // ─── Variant Methods (identical to add product) ───────────────────────────
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
      apiAttr = attributeData.value.attributes?.firstWhere((e) => e.name == attr);
    } catch (_) { apiAttr = null; }
    if (apiAttr?.id != null) attributeIdMap[attr] = apiAttr!.id!;
    final apiValues = apiAttr?.separateAttrValues ?? [];
    if (!attributeValues.containsKey(attr)) {
      attributeValues[attr] = apiValues.toSet().toList().obs;
    }
    // ✅ Initialize saved value controllers
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
    attributeValues.refresh();
    showValueField.refresh();
  }

  void updateAttributeValue(String attr, String oldVal, String newVal) {
    final list = attributeValues[attr];
    if (list == null) return;
    final idx = list.indexOf(oldVal);
    if (idx == -1) return;
    list[idx] = newVal;
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
  void removeAttribute(String attr) {
    attributeValues.remove(attr);
    savedValueControllers.remove(attr);
    showValueField.remove(attr);
    valueControllers.remove(attr);

    attributeValues.refresh();
  }
  void toggleValueField(String attr) {
    if (showValueField[attr]?.value == true) {
      String currentVal = valueControllers[attr]?.text.trim() ?? "";
      if (currentVal.isNotEmpty) addAttributeValue(attr);
      showValueField[attr]?.value = false;
      Future.delayed(const Duration(milliseconds: 50), () {
        showValueField[attr]?.value = true;
      });
    } else {
      showValueField[attr]?.value = true;
    }
  }

  void addCustomAttribute() {
    final name = customAttrNameController.text.trim();
    final valuesText = customAttrValueController.text.trim();
    customVariantAttributes.add(name);
    selectedVariantAttributes.add(name);
    attributeValues[name] = <String>[].obs;
    valueControllers[name] = TextEditingController();
    showValueField[name] = false.obs;
    if (valuesText.isNotEmpty) {
      attributeValues[name]!.assignAll(
          valuesText.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList());
    }
    selectedVariantAttributes.refresh();
    attributeValues.refresh();
    customAttrNameController.clear();
    customAttrValueController.clear();
  }

  void validateAndAddCustomAttribute() {
    customAttrNameError.value = '';
    customAttrValueError.value = '';
    final name = customAttrNameController.text.trim();
    final value = customAttrValueController.text.trim();
    if (name.isEmpty && value.isEmpty) return;
    bool hasError = false;
    if (name.isEmpty && value.isNotEmpty) { customAttrNameError.value = 'Enter attribute name first'; hasError = true; }
    if (name.isNotEmpty && value.isEmpty) { customAttrValueError.value = 'Enter at least one value'; hasError = true; }
    if (!hasError) addCustomAttribute();
  }

  void generateVariants() {
    // Save existing variants before clearing so user edits are not lost
    final List<VariantModel> existingVariants = List.from(variantList);
    
    variantList.clear();
    if (selectedVariantAttributes.isEmpty) return;
    
    generatedTableAttributes.value = List.from(selectedVariantAttributes);

    // Step 1: Build ordered attribute list (deduplicated by name)
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

    // Step 2: Cartesian product
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

    // Step 3: Build existing variant lookup maps
    final Map<String, dynamic> exactKeyMap = {};
    final Map<String, dynamic> baseKeyMap = {};

    // 3a. First load from API data (so we have backend variants for mapping original IDs)
    final variantItems = apiSingleProductData.value.getProductVariantsList ?? [];
    for (var v in variantItems) {
      final attrs = v.attributes ?? [];
      if (attrs.isEmpty) continue;
      final exactKey = attrs
          .map((a) => (a.attributeValue ?? '').trim().toUpperCase())
          .join('|');
      exactKeyMap[exactKey] = v;
      baseKeyMap[exactKey] = v;
      if (v.sku != null) {
        exactKeyMap[v.sku!.toUpperCase()] = v;
        baseKeyMap[v.sku!.replaceAll('PRD-', '')] = v;
      }
    }

    // 3b. Then override with any CURRENT values from the UI (so user edits aren't lost)
    for (var v in existingVariants) {
      if (v.values.isEmpty) continue;
      final exactKey = v.values.values
          .map((val) => val.trim().toUpperCase())
          .join('|');
          
      // Overwrite map with the VariantModel from the UI to preserve user typed prices/stock
      exactKeyMap[exactKey] = v;
      baseKeyMap[exactKey] = v;
      
      if (v.sku.isNotEmpty) {
        exactKeyMap[v.sku.toUpperCase()] = v;
        baseKeyMap[v.sku.replaceAll('PRD-', '')] = v;
      }
    }

    final Set<String> assignedBaseKeys = {};

    // Step 4: Build each variant row
    for (var combo in combinations) {
      final skuParts = combo.map((c) => c['attribute_value']!.trim().toUpperCase()).join('-');
      final sku = 'PRD-$skuParts';

      double price = 0.0;
      int stock = 0;
      bool enabled = true;
      String variantId = '';

      final exactKey = combo
          .map((c) => c['attribute_value']!.trim().toUpperCase())
          .join('|');

      if (exactKeyMap.containsKey(exactKey)) {
        // Exact match
        final ev = exactKeyMap[exactKey];
        if (ev is VariantModel) {
          price = ev.price.value;
          stock = ev.stock.value;
          enabled = ev.isSelected.value;
          variantId = ev.variantId;
        } else {
          // From API data
          price = double.tryParse(ev.price ?? '0') ?? 0;
          stock = int.tryParse(ev.stock ?? '0') ?? 0;
          enabled = ev.isEnabled ?? true;
          variantId = ev.id ?? '';
        }
      } else {
        // Subset/superset match
        dynamic bestMatch;
        int bestScore = 0;
        String? bestMatchKey;

        for (var entry in baseKeyMap.entries) {
          final storedValues = entry.key
              .split('|')
              .map((v) => v.trim().toUpperCase())
              .toList();
          final currentValues =
              combo.map((c) => c['attribute_value']!.trim().toUpperCase()).toList();

          final isSubset = currentValues.every((v) => storedValues.contains(v));
          final isSuperset = storedValues.every((v) => currentValues.contains(v));

          if (isSubset || isSuperset) {
            final matchCount =
                currentValues.where((v) => storedValues.contains(v)).length;
            if (matchCount > bestScore) {
              bestScore = matchCount;
              bestMatch = entry.value;
              bestMatchKey = entry.key;
            }
          }
        }

        if (bestMatch != null) {
          int currentAttrCount = combo.length;
          int matchAttrCount = 0;

          if (bestMatch is VariantModel) {
            price = bestMatch.price.value;
            stock = bestMatch.stock.value;
            enabled = bestMatch.isSelected.value;
            matchAttrCount = bestMatch.values.length;
            
            if (currentAttrCount < matchAttrCount) {
              variantId = bestMatch.variantId;
            } else if (currentAttrCount > matchAttrCount) {
              if (!assignedBaseKeys.contains(bestMatchKey)) {
                variantId = bestMatch.variantId;
                assignedBaseKeys.add(bestMatchKey!);
              }
            } else {
              variantId = bestMatch.variantId;
            }
          } else {
            price = double.tryParse(bestMatch.price ?? '0') ?? 0;
            stock = int.tryParse(bestMatch.stock ?? '0') ?? 0;
            enabled = bestMatch.isEnabled ?? true;
            matchAttrCount = (bestMatch.attributes ?? []).length;
            
            if (currentAttrCount < matchAttrCount) {
              variantId = bestMatch.id ?? '';
            } else if (currentAttrCount > matchAttrCount) {
              if (!assignedBaseKeys.contains(bestMatchKey)) {
                variantId = bestMatch.id ?? '';
                assignedBaseKeys.add(bestMatchKey!);
              }
            } else {
              variantId = bestMatch.id ?? '';
            }
          }
        }
      }

      final vm = VariantModel(
        values: {for (var c in combo) c['attribute_name']!: c['attribute_value']!},
        sku: sku,
        variantId: variantId,
      );
      vm.isSelected.value = enabled;
      vm.price.value = price;
      vm.stock.value = stock;
      variantList.add(vm);
    }
  }

  // ─── Image Methods ────────────────────────────────────────────────────────
  Future<void> cropImage(Rx<File?> imgRx, RxString imgBase64) async {
    if (_pickedFile == null) return;
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
        IOSUiSettings(title: 'Cropper', aspectRatioPresets: [CropAspectRatioPresetCustom2x2()]),
        WebUiSettings(context: Get.context!, presentStyle: WebPresentStyle.dialog),
      ],
    );
    if (croppedFile != null) {
      imgRx.value = File(croppedFile.path);
      final compressed = await compressImage(imageFile: imgRx.value!);
      final base64Str = await _convertToBase64(imgBase64, File(compressed.path));
      if (base64Str.isNotEmpty) imgBase64.value = base64Str;
    }
  }

  Future<String> _convertToBase64(RxString imgBase64, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      imgBase64.value = base64Encode(bytes);
      return imgBase64.value;
    } catch (e) { return ''; }
  }

  static Future<XFile> compressImage({required File imageFile, int quality = 25}) async {
    final String targetPath = p.join(Directory.systemTemp.path, 'temp.jpeg');
    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
        imageFile.path, targetPath, quality: quality);
    if (compressed == null) throw ("Failed to compress image");
    return compressed;
  }

  Future<void> pickImage(BuildContext context) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) { _pickedFile = picked; cropImage(image, imageBase64); update(); }
  }

  // Future<void> pickMoreImage(int index) async {
  //   final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) { _pickedFile = picked; cropImage(additionalImages[index], additionalImageBase64[index]); update(); }
  // }
  // Future<void> pickMoreImage(int index) async {
  //   final XFile? pickedImage = await _picker.pickImage(
  //       source: ImageSource.gallery);
  //
  //   if (pickedImage != null) {
  //     _pickedFile = pickedImage;
  //     cropImage(additionalImages[index], additionalImageBase64[index]);
  //     update();
  //   }
  // }

  Future<void> pickMoreImage(int index) async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {

      // ✅ OLD API IMAGE CLEAR
      additionalImageFromApi[index].value = '';

      _pickedFile = pickedImage;

      await cropImage(
        additionalImages[index],
        additionalImageBase64[index],
      );

      update();
    }
  }
  // ─── Validate before update (same flow as add product) ──────────────────
  Future<bool> validateBeforeUpdate() async {
    // 1. Image check
    if (imageBase64.value.isEmpty && mainUrlImage.value.isEmpty) {
      isErrorColor.value = true;
      scrollToTop();
      return false;
    }

    // 2. Form validation (triggers all field validators)
    bool isFormValid = publishButtonKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      await Future.delayed(const Duration(milliseconds: 100));
      // Scroll to first invalid field
      if (titleController.value.text.trim().isEmpty) {
        scrollToField(titleKey); return false;
      }
      if (descriptionController.value.text.trim().isEmpty) {
        scrollToField(descriptionKey); return false;
      }
      if (regularPriceController.value.text.trim().isEmpty) {
        scrollToField(regularKey); return false;
      }
      if (stockController.value.text.trim().isEmpty) {
        scrollToField(stockKey); return false;
      }
      if (skuController.value.text.trim().isEmpty) {
        scrollToField(skuKey); return false;
      }
      if (barcodeController.value.text.trim().isEmpty) {
        scrollToField(barcodeKey); return false;
      }
      if (conditionController.value.text.trim().isEmpty) {
        scrollToField(conditionKey); return false;
      }
      if (packageController.value.text.trim().isEmpty) {
        scrollToField(packageKey); return false;
      }
      if (weightController.value.text.trim().isEmpty) {
        scrollToField(weightKey); return false;
      }
      if (fulfillmentController.value.text.trim().isEmpty) {
        scrollToField(fulfillmentKey); return false;
      }
      if (preparationController.value.text.trim().isEmpty) {
        scrollToField(preparationKey); return false;
      }
      return false;
    }

    // 3. Stock unit
    if (selectedStockSection.value.isEmpty) {
      scrollToField(stockSectionKey); return false;
    }

    // 4. Status
    if (status.value.trim().isEmpty) {
      scrollToField(stockSectionKey); return false;
    }

    // 5. Department / Category / SubCategory
    if (department.value.isEmpty) {
      scrollToField(departmentKey); return false;
    }
    if (selectedCategoryId.value.isEmpty) {
      scrollToField(categoryKey); return false;
    }
    if (subCategory.value.isEmpty) {
      scrollToField(subCategoryKey); return false;
    }

    return true;
  }

    Future<void> editProductApi() async {

      Map<String, dynamic> data = {
        "product_id": productId.value,
        "title": titleController.value.text,
        "description": descriptionController.value.text,
        "regular_price": regularPriceController.value.text,
        "promo_price": promoController.value.text,
        "seller_sku": skuController.value.text,
        "department": selectedDepartmentId.value,
        "category": selectedCategoryId.value,
        "sub_category": selectedSubCategoryId.value,
        "quantity_in_stock": stockController.value.text,
        "stock_unit": selectedStockSection.value.toLowerCase(),
        "bar_code": barcodeController.value.text,
        "conditions": conditionController.value.text,
        "package_dimension": packageController.value.text,
        "weight": weightController.value.text,
        "fullfillment_type": fulfillmentController.value.text,
        "order_preparation_time": preparationController.value.text,
        "status": status.value,
        "has_variants": hasVariants.value ? "1" : "0",
      };

      // Additional details
      attributeData.value.additionalDetails?.forEach((detail) {
        final key = detail.slug ?? "";
        data["additional_details[$key]"] = additionalControllers[key]?.text.trim() ?? "";
      });

      if (image.value != null) {
        data["image"] = imageBase64.value;
      }
      for (int i = 0; i < additionalImageBase64.length; i++) {

        final base64Val = additionalImageBase64[i].value;
        final apiUrl = additionalImageFromApi[i].value;
        if (base64Val.isNotEmpty && !base64Val.startsWith("http")) {

          data["addimg${i + 1}"] = base64Val;

          print("✅ New Image => addimg${i + 1}");
        }
        else if (apiUrl.isNotEmpty) {
          final fileName = ImageUrlFormater.extractFilename(apiUrl);
          data["existing_addimg[${i + 1}]"] = fileName;
          print("✅ Existing Image => existing_addimg[${i + 1}]");
        }
      }

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
      // ✅ Send variant_id for existing variants
      data["variants[$i][variant_id]"] = variant.variantId;
      int attrIndex = 0;
      variant.values.forEach((key, value) {
        final attrId = attributeIdMap[key] ?? "0";
        data["variants[$i][attributes][$attrIndex][attribute_id]"] = attrId;
        data["variants[$i][attributes][$attrIndex][attribute_name]"] = key;
        data["variants[$i][attributes][$attrIndex][attribute_value]"] = value;
        attrIndex++;
      });
    }

    data.forEach((key, value) => pt("$key => $value"));

    setRxRequestStatus(ApiStatus.LOADING);
    api.editProductsApi(data).then((value) {
      apiData.value = value;
      if (value.status == true) {
        setRxRequestStatus(ApiStatus.COMPLETED);
        restaurantMenuController.getProductListApi(isShowLoading: true);
        Get.back(result: true);
        Utils.showToast(apiData.value.message ?? "Product Updated Successfully");
      } else {
        setRxRequestStatus(ApiStatus.ERROR);
        Utils.showToast(
          (apiData.value.errors != null && apiData.value.errors!.isNotEmpty)
              ? apiData.value.errors!.first
              : apiData.value.message ?? "Something went wrong",
          bgColor: AppColors.red,
        );
      }
    }).onError((e, _) {
      setRxRequestStatus(ApiStatus.ERROR);
      Utils.showToast(e.toString());
      log(e.toString(), name: "Edit product error");
    });
  }
}

// ─── Status dropdown items ────────────────────────────────────────────────────
class StatusDropdownItem {
  final String name;
  final String id;
  StatusDropdownItem({required this.name, required this.id});
}

final statusItems = [
  StatusDropdownItem(name: "Active", id: "active"),
  StatusDropdownItem(name: "Inactive", id: "inactive"),
];

// ─── Internal proxy classes for variant prefill ───────────────────────────────
class _VariantProxy {
  final String? id;
  final String? sku;
  final String? price;
  final String? stock;
  final bool? isEnabled;
  final List<_AttrProxy> attrs;
  _VariantProxy({this.id, this.sku, this.price, this.stock, this.isEnabled, required this.attrs});
}

class _AttrProxy {
  final String? id;
  final String? name;
  final String? value;
  _AttrProxy(this.id, this.name, this.value);
}
