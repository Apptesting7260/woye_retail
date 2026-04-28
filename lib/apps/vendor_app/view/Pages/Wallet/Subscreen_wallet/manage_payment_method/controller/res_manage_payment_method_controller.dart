import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../Data/Repository/repository.dart';
import '../../../../../../../../Data/response/api_response.dart';
import '../../../../../../../../Utils/snack_bar.dart';
import '../../../../../../../../shared/widgets/vendor_widgets/print.dart';
import '../../../../../vendor_common/Models/common_response_model.dart';
import '../../../../Profile/Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';
import '../model/all_bank_list_model.dart';
import '../model/bank_details_model.dart';

class ResManagePaymentMethodController extends GetxController{

  final api = Repository();

  final formKey = GlobalKey<FormState>();
  final formKeyForMM = GlobalKey<FormState>();

  final List<String> categoryList = ['Bank Account','Mobile Money'];
  final List<String> accountType = ['Savings','Current','Personal'];
  final List<String> mobileMoneyProviderList = ['Mtn Mobile Money','Airtel Money','Vodafone Cash','Tigo Cash','Orange Money','M Pesa','GCash','Paymaya'];


  RxInt selectedTypeIndex = 0.obs;

  void updateSelectedType(int index){
    selectedTypeIndex.value = index;
  }

  final RxBool _isAgree = false.obs;
  RxBool get isAgree => _isAgree;
  updateAgree(bool status){
    _isAgree.value = status;
  }

  final RxBool _isAgreeForMobile = false.obs;
  RxBool get isAgreeForMobile => _isAgreeForMobile;
  updateAgreeForMobile(bool status){
    _isAgreeForMobile.value = status;
  }

  final RxString _error = "".obs;
  RxString get error => _error;
  addError(String status){
    _error.value = status;
  }

  final RxString _errorMM = "".obs;
  RxString get errorMM => _errorMM;
  addErrorMM(String status){
    _errorMM.value = status;
  }

  RxString selectedMobileMoneyProvider = "".obs;

  RxString selectedAccountType = "".obs;
  RxString selectedAccountCode = "".obs;
  RxString selectedBankName = "".obs;
  RxString selectedBankId = "".obs;
  RxString selectedBankIdApi = "".obs;
  RxString selectedMMId = "".obs;
  final accountHolderController = TextEditingController();
  final accountNumberController = TextEditingController();
  final confirmAccountNumberController = TextEditingController();

  final bankNameKey = GlobalKey();
  final accountTypeKey = GlobalKey();
  final bankCodeKey = GlobalKey();
  final accountHolderKey = GlobalKey();
  final accountNumberKey = GlobalKey();
  final confirmAccountNumberKey = GlobalKey();
  final moneyProviderKey = GlobalKey();
  final accountNameMMKey = GlobalKey();
  final merchantKey = GlobalKey();
  final phoneKey = GlobalKey();


  // scroll
  void scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }


  //mobileMoney
  RxString selectedIndex = "".obs;
  RxString paymentMethod = "".obs;
  String countryCode = "+91";
  void updateCountryCode(CountryCode countryCode) {
    selectedCountryCode.value = countryCode;
  }
  RxBool showError = true.obs;
  Rx<CountryCode> selectedCountryCode = CountryCode(dialCode: '+91', code: 'IN').obs;
 final accountNameControllerMobileM = TextEditingController();
 final merchantIdController = TextEditingController();
 final mobNoCon = TextEditingController().obs;

  @override
  Future<void> onInit()async {
    await getAllBankList();
    final args = Get.arguments ?? {};
    paymentMethod.value = args['payment_method'] ?? "";
    selectedIndex.value = args['selectedIndex'] ?? "";
    if(selectedIndex.value != ""){
      updateSelectedType(int.tryParse(selectedIndex.value) ?? 0);
    }
    if(paymentMethod.value != ""){
      if(paymentMethod.value == 'bank'){
        updateSelectedType(0);
      }else if(paymentMethod.value == "mobile_money"){
        updateSelectedType(1);
      }
     await getBankDetails();
    }
    super.onInit();
  }


  // get all bank list

  final Rx<ApiResponse<BankListModel>> _allBankData = Rx<ApiResponse<BankListModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<BankListModel>> get allBankData => _allBankData;
  setBankData(ApiResponse<BankListModel> response) => allBankData.value = response;

  Future<void> getAllBankList()async{
    setBankData(ApiResponse.loading());
    api.getAllBankListApi().then((value) {
      if(value.status == true){
        setBankData(ApiResponse.completed(value));
      }else{
        setBankData(ApiResponse.error(value.message ?? ""));
      }
    },).onError((error, s) {
      setBankData(ApiResponse.error(error.toString()));
      pt("get all bank list api>>> $error $s");
    },);
  }


  // Add Bank Account
  Rx<PayStackBank?> selectedBank = Rx<PayStackBank?>(null);
  final Rx<ApiResponse<CommonResponseModel>> _paymentMethodData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get paymentMethodData => _paymentMethodData;
  setAddBankApiData(ApiResponse<CommonResponseModel> response) => _paymentMethodData.value = response;

  Future<void> addPaymentMethod()async{

    setAddBankApiData(ApiResponse.loading());

    var data = {
      "type": "vendor",
      "bankname": selectedBankName.value,
      "ac_holder_name": accountHolderController.text,
      "ac_number":accountNumberController.text,
      "ac_type": selectedAccountType.value.toLowerCase(),
      "bank_code": selectedAccountCode.value,
      "i_agree": isAgree.value ? "1" : "0",
      "payment_method" : "bank"
    };

    pt("data send in body >> $data");

    var dataForMM = {
      "provider": selectedMobileMoneyProvider.value.replaceAll(" ", "_").toLowerCase(), // mtn_mobile_money,airtel_money,vodafone_cash,tigo_cash,orange_money,m_pesa,gcash,paymaya
      "phone_code": countryCode,
      "phone": mobNoCon.value.text,
      "ac_name": accountNameControllerMobileM.text,
      if(merchantIdController.text.isNotEmpty)
      "merchant_id":merchantIdController.text,
      "i_agree": "1",
      "payment_method" : "mobile_money"
    };

    pt("data send in dataForMM >> $dataForMM");


    api.addPaymentMethodApi(selectedTypeIndex.value == 0 ? data : dataForMM).then((value) {
      if(value.status == true){
        Utils.showToast(value.message ?? "");
        setAddBankApiData(ApiResponse.completed(value));
        Get.back(result: true);
      }else{
        Utils.showToast(value.message ?? "");
        setAddBankApiData(ApiResponse.error(value.message));
      }
    },).onError((error, stackTrace) {
      setAddBankApiData(ApiResponse.error(error.toString()));
      pt("error adding bank account $error $stackTrace");
    },);
  }


  //get all bank list
  final Rx<ApiResponse<BankDetailsModel>> _bankDetailsData = Rx<ApiResponse<BankDetailsModel>>(ApiResponse.loading());
  Rx<ApiResponse<BankDetailsModel>> get bankDetailsData => _bankDetailsData;
  setBankDetailsData(ApiResponse<BankDetailsModel> response)=> _bankDetailsData.value = response;

  Future<void> getBankDetails() async {
    setBankDetailsData(ApiResponse.loading());
    try {
      final res = await api.getBankDetailsApi(paymentM: paymentMethod.value == "mobile_money" ? "mobile" : "bank");
      if (res.status == true) {
        setBankDetailsData(ApiResponse.completed(res));
        if(res.data != null && res.data!.isNotEmpty) {
          final bankInfo = res.data!.first;
          if(paymentMethod.value == "mobile_money"){
            String normalize(String s) => s.toLowerCase().replaceAll(" ", "");
            final formatted = formatProviderFromApi(bankInfo.provider);
            final matchedProvider = mobileMoneyProviderList.firstWhere(
                  (e) => normalize(e) == normalize(formatted),
              orElse: () => "",
            );
            selectedMobileMoneyProvider.value =
            matchedProvider.isNotEmpty ? matchedProvider : "";

            countryCode = bankInfo.phoneCode ?? "+91";
            checkCountryLength.value = bankInfo.phone?.length ?? 10;
            mobNoCon.value.text = bankInfo.phone ?? "";
            accountNameControllerMobileM.text = bankInfo.acName ?? "";
            merchantIdController.text = bankInfo.merchantId ?? "";
            isAgreeForMobile.value = true;
            selectedMMId.value = bankInfo.id ?? "";

          }else {
            selectedAccountType.value = bankInfo.acType?.capitalizeFirst ?? "";
            accountHolderController.text = bankInfo.acHolder ?? "";
            accountNumberController.text = bankInfo.acNo ?? "";
            confirmAccountNumberController.text = bankInfo.acNo ?? "";
            selectedBankIdApi.value = bankInfo.id ?? "";

            selectedAccountCode.value = bankInfo.bankCode ?? "";
            selectedBankName.value = bankInfo.bankname ?? "";

            isAgree.value = true;
          }
        }
      } else {
        setBankDetailsData(ApiResponse.error(res.message ?? "Failed to load bank details"));
      }
    } catch (e, s) {
      setBankDetailsData(ApiResponse.error(e.toString()));
      pt("Error getting bank details: $e\n$s");
    }
  }

  String formatProviderFromApi(String? value) {
    if (value == null || value.isEmpty) return "";
    return value.replaceAll("_", " ").toLowerCase().split(" ").map((word) =>word.isNotEmpty? word[0].toUpperCase() + word.substring(1): "").join(" ");
  }


  //Update payment methods

  final Rx<ApiResponse<CommonResponseModel>> _updatedBankDetailsData = Rx<ApiResponse<CommonResponseModel>>(ApiResponse.completed(null));
  Rx<ApiResponse<CommonResponseModel>> get updatedBankDetailsData => _updatedBankDetailsData;
  setUpdateBankDetailsData(ApiResponse<CommonResponseModel> response)=> _updatedBankDetailsData.value = response;

  Future<void> updateBankDetails() async {
    setUpdateBankDetailsData(ApiResponse.loading());

    final data = {
      "id": selectedBankIdApi.value,
      "type": "vendor",
      "bankname":  selectedBankName.value,
      "ac_holder_name":  accountHolderController.text,
      "ac_number":  accountNumberController.text,
      "ac_type": selectedAccountType.value.toLowerCase(),
      "bank_code": selectedAccountCode.value,
      "i_agree": isAgree.value ? "1" : "0",
      "payment_method": paymentMethod.value,
    };
    pt("update bank details $data");

    var dataForMM = {
      "id": selectedMMId.value,
      "provider": selectedMobileMoneyProvider.value.replaceAll(" ", "_").toLowerCase(), // mtn_mobile_money,airtel_money,vodafone_cash,tigo_cash,orange_money,m_pesa,gcash,paymaya
      "phone_code": countryCode,
      "phone": mobNoCon.value.text,
      "ac_name": accountNameControllerMobileM.text,
      if(merchantIdController.text.isNotEmpty)
        "merchant_id":merchantIdController.text,
      "i_agree": "1",
      "payment_method" : "mobile_money"
    };

    try {
      final res = await api.updatePaymentMethodApi(paymentMethod.value == "bank" ? data : dataForMM);
      if (res.status == true) {
        setUpdateBankDetailsData(ApiResponse.completed(res));
        Utils.showToast(res.message ?? "");
        Get.back(result: true);
      } else {
        Utils.showToast(res.message ?? "");
        setUpdateBankDetailsData(ApiResponse.error(res.message ?? "Failed to update bank details"));
      }
    } catch (e, s) {
      setUpdateBankDetailsData(ApiResponse.error(e.toString()));
      pt("Error getting bank details: $e\n$s");
    }
  }

  RxInt checkCountryLength = 10.obs;
  final Map<String, int> countryPhoneDigits = {
    'AF': 9, // Afghanistan
    'AL': 9, // Albania
    'DZ': 9, // Algeria
    'AD': 6, // Andorra
    'AO': 9, // Angola
    'AG': 10, // Antigua and Barbuda
    'AR': 10, // Argentina
    'AM': 8, // Armenia
    'AU': 9, // Australia
    'AT': 10, // Austria
    'AZ': 9, // Azerbaijan
    'BS': 10, // Bahamas
    'BH': 8, // Bahrain
    'BD': 10, // Bangladesh
    'BB': 10, // Barbados
    'BY': 9, // Belarus
    'BE': 9, // Belgium
    'BZ': 7, // Belize
    'BJ': 8, // Benin
    'BT': 8, // Bhutan
    'BO': 8, // Bolivia
    'BA': 8, // Bosnia and Herzegovina
    'BW': 7, // Botswana
    'BR': 11, // Brazil
    'BN': 7, // Brunei
    'BG': 9, // Bulgaria
    'BF': 8, // Burkina Faso
    'BI': 8, // Burundi
    'CV': 7, // Cape Verde
    'KH': 9, // Cambodia
    'CM': 9, // Cameroon
    'CA': 10, // Canada
    'CF': 8, // Central African Republic
    'TD': 8, // Chad
    'CL': 9, // Chile
    'CN': 11, // China
    'CO': 10, // Colombia
    'KM': 7, // Comoros
    'CG': 9, // Congo
    'CR': 8, // Costa Rica
    'HR': 9, // Croatia
    'CU': 8, // Cuba
    'CY': 8, // Cyprus
    'CZ': 9, // Czech Republic
    'DK': 8, // Denmark
    'DJ': 8, // Djibouti
    'DM': 10, // Dominica
    'DO': 10, // Dominican Republic
    'EC': 9, // Ecuador
    'EG': 10, // Egypt
    'SV': 8, // El Salvador
    'GQ': 9, // Equatorial Guinea
    'ER': 7, // Eritrea
    'EE': 7, // Estonia
    'ET': 9, // Ethiopia
    'FJ': 7, // Fiji
    'FI': 10, // Finland
    'FR': 9, // France
    'GA': 7, // Gabon
    'GM': 7, // Gambia
    'GE': 9, // Georgia
    'DE': 10, // Germany
    'GH': 9, // Ghana
    'GR': 10, // Greece
    'GD': 10, // Grenada
    'GT': 8, // Guatemala
    'GN': 9, // Guinea
    'GW': 7, // Guinea-Bissau
    'GY': 7, // Guyana
    'HT': 8, // Haiti
    'HN': 8, // Honduras
    'HU': 9, // Hungary
    'IS': 7, // Iceland
    'IN': 10, // India
    'ID': 10, // Indonesia
    'IR': 10, // Iran
    'IQ': 10, // Iraq
    'IE': 9, // Ireland
    'IL': 9, // Israel
    'IT': 10, // Italy
    'JM': 10, // Jamaica
    'JP': 10, // Japan
    'JO': 9, // Jordan
    'KZ': 10, // Kazakhstan
    'KE': 10, // Kenya
    'KI': 8, // Kiribati
    'KP': 10, // North Korea
    'KR': 10, // South Korea
    'KW': 8, // Kuwait
    'KG': 9, // Kyrgyzstan
    'LA': 9, // Laos
    'LV': 8, // Latvia
    'LB': 8, // Lebanon
    'LS': 8, // Lesotho
    'LR': 7, // Liberia
    'LY': 10, // Libya
    'LI': 7, // Liechtenstein
    'LT': 8, // Lithuania
    'LU': 9, // Luxembourg
    'MG': 9, // Madagascar
    'MW': 9, // Malawi
    'MY': 10, // Malaysia
    'MV': 7, // Maldives
    'ML': 8, // Mali
    'MT': 8, // Malta
    'MH': 7, // Marshall Islands
    'MR': 8, // Mauritania
    'MU': 8, // Mauritius
    'MX': 10, // Mexico
    'FM': 7, // Micronesia
    'MD': 8, // Moldova
    'MC': 8, // Monaco
    'MN': 8, // Mongolia
    'ME': 8, // Montenegro
    'MA': 9, // Morocco
    'MZ': 9, // Mozambique
    'MM': 9, // Myanmar
    'NA': 9, // Namibia
    'NR': 7, // Nauru
    'NP': 10, // Nepal
    'NL': 9, // Netherlands
    'NZ': 9, // New Zealand
    'NI': 8, // Nicaragua
    'NE': 8, // Niger
    'NG': 10, // Nigeria
    'MK': 8, // North Macedonia
    'NO': 8, // Norway
    'OM': 8, // Oman
    'PK': 10, // Pakistan
    'PW': 7, // Palau
    'PA': 8, // Panama
    'PG': 8, // Papua New Guinea
    'PY': 9, // Paraguay
    'PE': 9, // Peru
    'PH': 10, // Philippines
    'PL': 9, // Poland
    'PT': 9, // Portugal
    'QA': 8, // Qatar
    'RO': 10, // Romania
    'RU': 10, // Russia
    'RW': 9, // Rwanda
    'KN': 10, // Saint Kitts and Nevis
    'LC': 10, // Saint Lucia
    'VC': 10, // Saint Vincent and the Grenadines
    'WS': 7, // Samoa
    'SM': 8, // San Marino
    'ST': 7, // Sao Tome and Principe
    'SA': 9, // Saudi Arabia
    'SN': 9, // Senegal
    'RS': 9, // Serbia
    'SC': 7, // Seychelles
    'SL': 8, // Sierra Leone
    'SG': 8, // Singapore
    'SK': 9, // Slovakia
    'SI': 9, // Slovenia
    'SB': 7, // Solomon Islands
    'SO': 8, // Somalia
    'ZA': 9, // South Africa
    'ES': 9, // Spain
    'LK': 10, // Sri Lanka
    'SD': 9, // Sudan
    'SR': 7, // Suriname
    'SE': 9, // Sweden
    'CH': 9, // Switzerland
    'SY': 9, // Syria
    'TW': 9, // Taiwan
    'TJ': 9, // Tajikistan
    'TZ': 9, // Tanzania
    'TH': 9, // Thailand
    'TG': 8, // Togo
    'TO': 7, // Tonga
    'TT': 10, // Trinidad and Tobago
    'TN': 8, // Tunisia
    'TR': 10, // Turkey
    'TM': 8, // Turkmenistan
    'TV': 7, // Tuvalu
    'UG': 9, // Uganda
    'UA': 9, // Ukraine
    'AE': 9, // United Arab Emirates
    'GB': 10, // United Kingdom
    'US': 10, // United States
    'UY': 9, // Uruguay
    'UZ': 9, // Uzbekistan
    'VU': 7, // Vanuatu
    'VA': 8, // Vatican City
    'VE': 10, // Venezuela
    'VN': 10, // Vietnam
    'YE': 9, // Yemen
    'ZM': 9, // Zambia
    'ZW': 9,
  };

}