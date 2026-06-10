// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:convert';
import 'package:briio_application/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:briio_application/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/const.dart';
import '../../widgets/auth_button.dart';
import '../pages/savedaddress.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? _companyLogo;

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _companyLogo = File(pickedFile.path);
      });
    }
  }
  List<Map<String, dynamic>> statesData = [
    {
      "state": "Andhra Pradesh",
      "districts": [
        "Anantapur",
        "Chittoor",
        "East Godavari",
        "Guntur",
        "Krishna",
        "Kurnool",
        "Nellore",
        "Prakasam",
        "Srikakulam",
        "Visakhapatnam",
        "Vizianagaram",
        "West Godavari",
        "YSR Kadapa"
      ]
    },
    {
      "state": "Arunachal Pradesh",
      "districts": [
        "Tawang",
        "West Kameng",
        "East Kameng",
        "Papum Pare",
        "Kurung Kumey",
        "Kra Daadi",
        "Lower Subansiri",
        "Upper Subansiri",
        "West Siang",
        "East Siang",
        "Siang",
        "Upper Siang",
        "Lower Siang",
        "Lower Dibang Valley",
        "Dibang Valley",
        "Anjaw",
        "Lohit",
        "Namsai",
        "Changlang",
        "Tirap",
        "Longding"
      ]
    },
    {
      "state": "Assam",
      "districts": [
        "Baksa",
        "Barpeta",
        "Biswanath",
        "Bongaigaon",
        "Cachar",
        "Charaideo",
        "Chirang",
        "Darrang",
        "Dhemaji",
        "Dibrugarh",
        "Goalpara",
        "Golaghat",
        "Hailakandi",
        "Jorhat",
        "Kamrup",
        "Kamrup Metropolitan",
        "Karbi Anglong",
        "Karimganj",
        "Kokrajhar",
        "Lakhimpur",
        "Majuli",
        "Morigaon",
        "Nagaon",
        "Nalbari",
        "Sivasagar",
        "Sonitpur",
        "South Salmara",
        "Tinsukia",
        "Udalguri"
      ]
    },
    {
      "state": "Bihar",
      "districts": [
        "Araria",
        "Arwal",
        "Aurangabad",
        "Banka",
        "Begusarai",
        "Bhagalpur",
        "Bhojpur",
        "Buxar",
        "Darbhanga",
        "East Champaran",
        "Gaya",
        "Gopalganj",
        "Jamui",
        "Jehanabad",
        "Kaimur",
        "Katihar",
        "Khagaria",
        "Kishanganj",
        "Lakhisarai",
        "Madhepura",
        "Madhubani",
        "Munger",
        "Muzaffarpur",
        "Nalanda",
        "Nawada",
        "Purnia",
        "Rohtas",
        "Saharsa",
        "Samastipur",
        "Saran",
        "Sheikhpura",
        "Sheohar",
        "Sitamarhi",
        "Siwan",
        "Supaul",
        "Vaishali",
        "West Champaran"
      ]
    },
    {
      "state": "Chhattisgarh",
      "districts": [
        "Balod",
        "Baloda Bazar",
        "Balrampur",
        "Bastar",
        "Bemetara",
        "Bijapur",
        "Bilaspur",
        "Dantewada",
        "Dhamtari",
        "Durg",
        "Gariaband",
        "Janjgir-Champa",
        "Jashpur",
        "Kabirdham",
        "Kanker",
        "Korba",
        "Kondagaon",
        "Mahasamund",
        "Mungeli",
        "Narayanpur",
        "Raigarh",
        "Raipur",
        "Rajnandgaon",
        "Surajpur",
        "Surguja"
      ]
    },
    {
      "state": "Goa",
      "districts": ["North Goa", "South Goa"]
    },
    {
      "state": "Gujarat",
      "districts": [
        "Ahmadabad",
        "Amreli",
        "Anand",
        "Banaskantha",
        "Bharuch",
        "Bhavnagar",
        "Botad",
        "Chhota Udepur",
        "Dahod",
        "Dang",
        "Gir Somnath",
        "Jamnagar",
        "Junagadh",
        "Kachchh",
        "Kheda",
        "Mahisagar",
        "Mehsana",
        "Narmada",
        "Navsari",
        "Panchmahal",
        "Patan",
        "Porbandar",
        "Rajkot",
        "Sabarkantha",
        "Surat",
        "Surendranagar",
        "Tapi",
        "Vadodara",
        "Valsad"
      ]
    },
    {
      "state": "Haryana",
      "districts": [
        "Ambala",
        "Bhiwani",
        "Charkhi Dadri",
        "Faridabad",
        "Fatehabad",
        "Gurugram",
        "Hisar",
        "Jhajjar",
        "Jind",
        "Kaithal",
        "Karnal",
        "Kurukshetra",
        "Mahendragarh",
        "Mewat",
        "Palwal",
        "Panchkula",
        "Panipat",
        "Rewari",
        "Rohtak",
        "Sirsa",
        "Sonipat",
        "Yamunanagar"
      ]
    },
    {
      "state": "Himachal Pradesh",
      "districts": [
        "Bilaspur",
        "Chamba",
        "Hamirpur",
        "Kangra",
        "Kullu",
        "Mandi",
        "Shimla",
        "Sirmaur",
        "Solan",
        "Una"
      ]
    },
    {
      "state": "Jammu & Kashmir",
      "districts": [
        "Anantnag",
        "Bandipora",
        "Baramulla",
        "Budgam",
        "Doda",
        "Ganderbal",
        "Jammu",
        "Kathua",
        "Kishtwar",
        "Kulgam",
        "Kupwara",
        "Poonch",
        "Pulwama",
        "Rajouri",
        "Ramban",
        "Reasi",
        "Samba",
        "Shopian",
        "Srinagar",
        "Udhampur"
      ]
    },
    {
      "state": "Jharkhand",
      "districts": [
        "Bokaro",
        "Chatra",
        "Deoghar",
        "Dhanbad",
        "Dumka",
        "Garhwa",
        "Giridih",
        "Godda",
        "Gumla",
        "Hazaribagh",
        "Jamtara",
        "Khunti",
        "Koderma",
        "Latehar",
        "Lohardaga",
        "Pakur",
        "Palamu",
        "Ramgarh",
        "Ranchi",
        "Sahibganj",
        "Seraikela-Kharsawan",
        "Simdega",
        "West Singhbhum"
      ]
    },
    {
      "state": "Karnataka",
      "districts": [
        "Bagalkot",
        "Bangalore Rural",
        "Bangalore Urban",
        "Belagavi",
        "Ballari",
        "Bidar",
        "Chamarajanagar",
        "Chikkamagaluru",
        "Chikkaballapur",
        "Chitradurga",
        "Dakshina Kannada",
        "Davanagere",
        "Dharwad",
        "Gadag",
        "Hassan",
        "Haveri",
        "Kodagu",
        "Kolar",
        "Koppal",
        "Mandya",
        "Mysuru",
        "Raichur",
        "Ramanagara",
        "Shivamogga",
        "Tumakuru",
        "Udupi",
        "Uttara Kannada",
        "Vijayapura",
        "Yadgir"
      ]
    },
    {
      "state": "Kerala",
      "districts": [
        "Alappuzha",
        "Ernakulam",
        "Idukki",
        "Kottayam",
        "Kozhikode",
        "Malappuram",
        "Palakkad",
        "Pathanamthitta",
        "Thiruvananthapuram",
        "Thrissur",
        "Wayanad"
      ]
    },
    {
      "state": "Madhya Pradesh",
      "districts": [
        "Agar Malwa",
        "Alirajpur",
        "Anuppur",
        "Ashoknagar",
        "Balaghat",
        "Barwani",
        "Betul",
        "Bhind",
        "Bhopal",
        "Burhanpur",
        "Chhatarpur",
        "Chhindwara",
        "Damoh",
        "Datia",
        "Dewas",
        "Dhar",
        "Dindori",
        "Guna",
        "Gwalior",
        "Harda",
        "Hoshangabad",
        "Indore",
        "Jabalpur",
        "Jhabua",
        "Katni",
        "Khandwa",
        "Khargone",
        "Mandla",
        "Mandsaur",
        "Morena",
        "Narsinghpur",
        "Neemuch",
        "Panna",
        "Raisen",
        "Rajgarh",
        "Ratlam",
        "Rewa",
        "Sagar",
        "Satna",
        "Sehore",
        "Seoni",
        "Shahdol",
        "Shajapur",
        "Sheopur",
        "Shivpuri",
        "Sidhi",
        "Singrauli",
        "Tikamgarh",
        "Ujjain",
        "Umaria",
        "Vidisha"
      ]
    },
    {
      "state": "Maharashtra",
      "districts": [
        "Ahmednagar",
        "Akola",
        "Amravati",
        "Aurangabad",
        "Beed",
        "Bhandara",
        "Buldhana",
        "Chandrapur",
        "Dhule",
        "Gadchiroli",
        "Gondia",
        "Hingoli",
        "Jalgaon",
        "Jalna",
        "Kolhapur",
        "Latur",
        "Mumbai City",
        "Mumbai Suburban",
        "Nandurbar",
        "Nashik",
        "Nagpur",
        "Nanded",
        "Nandurbar",
        "Osmanabad",
        "Palghar",
        "Parbhani",
        "Pune",
        "Raigad",
        "Ratnagiri",
        "Sindhudurg",
        "Solapur",
        "Thane",
        "Wardha",
        "Washim",
        "Yavatmal"
      ]
    },
    {
      "state": "Manipur",
      "districts": [
        "Bishnupur",
        "Chandel",
        "Churachandpur",
        "Imphal East",
        "Imphal West",
        "Jiribam",
        "Kakching",
        "Kamjong",
        "Kangpokpi",
        "Noney",
        "Pherzawl",
        "Senapati",
        "Tengnoupal",
        "Thoubal",
        "Ukhrul"
      ]
    },
    {
      "state": "Meghalaya",
      "districts": [
        "East Garo Hills",
        "East Khasi Hills",
        "Jaintia Hills",
        "Ri-Bhoi",
        "South Garo Hills",
        "South Khasi Hills",
        "West Garo Hills",
        "West Khasi Hills"
      ]
    },
    {
      "state": "Mizoram",
      "districts": [
        "Aizawl",
        "Champhai",
        "Kolasib",
        "Lawngtlai",
        "Lunglei",
        "Mamit",
        "Siaha",
        "Serchhip"
      ]
    },
    {
      "state": "Nagaland",
      "districts": [
        "Dimapur",
        "Kohima",
        "Mokokchung",
        "Mon",
        "Peren",
        "Phek",
        "Tuensang",
        "Wokha",
        "Zunheboto"
      ]
    },
    {
      "state": "Odisha",
      "districts": [
        "Angul",
        "Boudh",
        "Cuttack",
        "Deogarh",
        "Dhenkanal",
        "Ganjam",
        "Gajapati",
        "Jagatsinghpur",
        "Jajpur",
        "Jharsuguda",
        "Kalahandi",
        "Kandhamal",
        "Kendrapara",
        "Kendujhar",
        "Khordha",
        "Koraput",
        "Malkangiri",
        "Mayurbhanj",
        "Nabarangpur",
        "Nayagarh",
        "Nuapada",
        "Puri",
        "Rayagada",
        "Sambalpur",
        "Subarnapur",
        "Sundargarh"
      ]
    },
    {
      "state": "Rajasthan",
      "districts": [
        "Ajmer",
        "Alwar",
        "Banswara",
        "Baran",
        "Barmer",
        "Bhilwara",
        "Bikaner",
        "Bundi",
        "Chittorgarh",
        "Churu",
        "Dausa",
        "Dholpur",
        "Dungarpur",
        "Hanumangarh",
        "Jaipur",
        "Jaisalmer",
        "Jalore",
        "Jhalawar",
        "Jhunjhunu",
        "Jodhpur",
        "Karauli",
        "Kota",
        "Nagaur",
        "Pali",
        "Pratapgarh",
        "Rajsamand",
        "Sawai Madhopur",
        "Sikar",
        "Sirohi",
        "Tonk",
        "Udaipur"
      ]
    },
    {
      "state": "Sikkim",
      "districts": [
        "East Sikkim",
        "North Sikkim",
        "South Sikkim",
        "West Sikkim"
      ]
    },
    {
      "state": "Tamil Nadu",
      "districts": [
        "Ariyalur",
        "Chengalpattu",
        "Chennai",
        "Coimbatore",
        "Cuddalore",
        "Dharmapuri",
        "Dindigul",
        "Erode",
        "Kancheepuram",
        "Kanyakumari",
        "Karur",
        "Krishnagiri",
        "Madurai",
        "Nagapattinam",
        "Namakkal",
        "Perambalur",
        "Pudukkottai",
        "Ramanathapuram",
        "Salem",
        "Sivagangai",
        "Tiruchirappalli",
        "Tirunelveli",
        "Tiruppur",
        "Vellore",
        "Viluppuram",
        "Virudhunagar"
      ]
    },
    {
      "state": "Telangana",
      "districts": [
        "Adilabad",
        "Hyderabad",
        "Jagitial",
        "Jangaon",
        "Jayashankar",
        "Jogulamba",
        "Kamareddy",
        "Karimnagar",
        "Khammam",
        "Mahabubnagar",
        "Mancherial",
        "Medak",
        "Medchal",
        "Mahabubabad",
        "Nalgonda",
        "Nirmal",
        "Nizamabad",
        "Peddapalli",
        "Sangareddy",
        "Sircilla",
        "Warangal",
        "Yadadri"
      ]
    },
    {
      "state": "Tripura",
      "districts": [
        "Dhalai",
        "Khowai",
        "North Tripura",
        "Sepahijala",
        "South Tripura",
        "Unakoti",
        "West Tripura"
      ]
    },
    {
      "state": "Uttarakhand",
      "districts": [
        "Almora",
        "Bageshwar",
        "Chamoli",
        "Champawat",
        "Dehradun",
        "Haridwar",
        "Nainital",
        "Pauri Garhwal",
        "Pithoragarh",
        "Rudraprayag",
        "Tehri Garhwal",
        "Udham Singh Nagar",
        "Uttarkashi"
      ]
    },
    {
      "state": "Uttar Pradesh",
      "districts": [
        "Agra",
        "Aligarh",
        "Allahabad",
        "Ambedkar Nagar",
        "Amethi",
        "Amroha",
        "Auraiya",
        "Azamgarh",
        "Badaun",
        "Baghpat",
        "Bahraich",
        "Ballia",
        "Balrampur",
        "Banda",
        "Barabanki",
        "Bareilly",
        "Basti",
        "Bijnor",
        "Budaun",
        "Bulandshahr",
        "Chandauli",
        "Chitrakoot",
        "Deoria",
        "Etah",
        "Etawah",
        "Farrukhabad",
        "Fatehpur",
        "Firozabad",
        "Gautam Buddha Nagar",
        "Ghaziabad",
        "Gonda",
        "Gorakhpur",
        "Hamirpur",
        "Hapur",
        "Hardoi",
        "Hathras",
        "Jalaun",
        "Jaunpur",
        "Jhansi",
        "Jind",
        "Kushinagar",
        "Lakhimpur Kheri",
        "Lalitpur",
        "Lucknow",
        "Mau",
        "Meerut",
        "Mirzapur",
        "Moradabad",
        "Muzaffarnagar",
        "Raebareli",
        "Rampur",
        "Saharanpur",
        "Shahjahanpur",
        "Shravasti",
        "Siddharthnagar",
        "Sitapur",
        "Sonbhadra",
        "Sultanpur",
        "Unnao",
        "Varanasi"
      ]
    },
    {
      "state": "West Bengal",
      "districts": [
        "Alipurduar",
        "Bankura",
        "Birbhum",
        "Cooch Behar",
        "Dakshin Dinajpur",
        "Hooghly",
        "Howrah",
        "Jalpaiguri",
        "Jhargram",
        "Kalimpong",
        "Kolkata",
        "Malda",
        "Murshidabad",
        "Nadia",
        "North 24 Parganas",
        "Paschim Medinipur",
        "Purba Medinipur",
        "Purulia",
        "South 24 Parganas",
        "Uttar Dinajpur"
      ]
    }
  ];
  // Variables for dropdown selection
  String? selectedState;
  String? selectedCity;
  List<String> cities = [];
  bool _isChecked = false;

  List<String> getCitiesForState(String? state) {
    if (state == null) return [];
    final stateData = statesData.firstWhere((data) => data["state"] == state);
    return List<String>.from(stateData["districts"]);
  }

  InputDecoration _buildDecoration(String hint, IconData? icon) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade700) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final companyNameEditingController = TextEditingController();
  final gstEditingController = TextEditingController();
  final hallmarksController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final companyField = TextFormField(
      autofocus: false,
      controller: companyNameEditingController,
      inputFormatters: [FirstLetterUpperCaseFormatter()],
      validator: (value) => value!.isEmpty ? "Company Name cannot be Empty" : null,
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("Company Name *", Icons.account_circle),
    );
    final fullNameField = TextFormField(
      cursorColor: Colors.black,
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      inputFormatters: [FirstLetterUpperCaseFormatter()],
      validator: (value) {
        if (value!.isEmpty) return "Name cannot be Empty";
        if (!RegExp(r'^.{3,}$').hasMatch(value)) return "Enter Valid name (Min. 3 Character)";
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("User Name *", Icons.account_circle),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) return "Please Enter Your Email";
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) return "Please Enter a valid email";
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("Email Address *", Icons.mail),
    );
    final numberField = TextFormField(
      autofocus: false,
      controller: phoneController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) return "number cannot be Empty";
        if (!RegExp(r'^.{9,}$').hasMatch(value)) return "Enter the valid contact number";
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("Mobile No *", Icons.call),
    );
    final stateField = DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: _buildDecoration("Select State *", null),
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
      initialValue: selectedState,
      onChanged: (String? newState) {
        setState(() {
          selectedState = newState;
          selectedCity = null;
          cities = getCitiesForState(newState);
        });
      },
      items: statesData.map((stateData) => stateData["state"]).map((state) {
        return DropdownMenuItem<String>(
          value: state as String,
          child: Text(state as String),
        );
      }).toList(),
    );
    final cityField = DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: _buildDecoration("Select City *", null),
      icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
      initialValue: selectedCity,
      onChanged: (String? newCity) {
        setState(() {
          selectedCity = newCity;
        });
      },
      items: cities.map((city) => DropdownMenuItem<String>(
        value: city,
        child: Text(city),
      )).toList(),
    );
    final addressField = TextFormField(
      autofocus: false,
      controller: addressController,
      validator: (value) => value!.isEmpty ? "Address cannot be Empty" : null,
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("Shop Address *", Icons.location_on),
    );
    final pinCodeField = TextFormField(
      autofocus: false,
      controller: pinCodeController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) return "Pincode cannot be Empty";
        if (!RegExp(r'^.{5,}$').hasMatch(value)) return "Enter the valid Pin Code ";
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("Pin-Code *", Icons.scatter_plot),
    );
    final gstnumberField = TextFormField(
      autofocus: false,
      controller: gstEditingController,
      keyboardType: TextInputType.text,
      validator: (value) => value!.isEmpty ? "GST cannot be Empty" : null,
      textInputAction: TextInputAction.next,
      decoration: _buildDecoration("GST No *", Icons.menu_book_outlined),
      inputFormatters: [UpperCaseTextFormatter()],
    );

    final uploadLogoBox = GestureDetector(
      onTap: _pickLogo,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _companyLogo == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  Text(
                    "Upload Company Logo",
                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_companyLogo!, fit: BoxFit.contain),
              ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 45),
                    Image.asset(
                      'assets/blg.png',
                      width: 150,
                      height: 30,
                    ),
                    const SizedBox(height: 25),
                    companyField,
                    const SizedBox(height: 12),
                    fullNameField,
                    const SizedBox(height: 12),
                    emailField,
                    const SizedBox(height: 12),
                    numberField,
                    const SizedBox(height: 12),
                    stateField,
                    const SizedBox(height: 12),
                    cityField,
                    const SizedBox(height: 12),
                    addressField,
                    const SizedBox(height: 12),
                    pinCodeField,
                    const SizedBox(height: 12),
                    gstnumberField,
                    const SizedBox(height: 12),
                    uploadLogoBox,
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            activeColor: const Color(0xFF4A4138),
                            side: BorderSide(color: Colors.grey.shade700, width: 2),
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _showTermsAndConditions,
                          child: Text(
                            "I agree to the terms and conditions",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.grey.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (!_isChecked) {
                              Fluttertoast.showToast(msg: "Please agree to terms and conditions");
                              return;
                            }
                            signUp(
                                name: nameController.text,
                                email: emailController.text,
                                address: addressController.text,
                                pass: "",
                                companyName: companyNameEditingController.text,
                                gst: gstEditingController.text,
                                city: selectedCity ?? "",
                                state: selectedState ?? "",
                                pinCode: pinCodeController.text,
                                holeMarks: hallmarksController.text,
                                phone: phoneController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A4138),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "SUBSCRIBE",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(
      {required String name,
      required String email,
      required String address,
      required String pass,
      required String companyName,
      required String gst,
      required String city,
      required String state,
      required String pinCode,
      required String holeMarks,
      required String phone}) async {
    String url =
        '${apiUrl}Register?name=$name&email=$email&address=$address&password=$pass&company_name=$companyName&gst_number=$gst&city=$city&state=$state&pincode=$pinCode&holemarks_license=$holeMarks&phone=$phone';
    try {
      var response = await post(Uri.parse(url));
      if (response.statusCode == 200||response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        if (data['error'] == false) {
          Fluttertoast.showToast(msg: 'Successfully created account');
          await saveAddressFromApi(
            id: data['data']['id'],
            name: name,
            mobile: phone,
            address: address,
            city: city,
            state: state,
            pincode: pinCode,
            landmark: 'NA',
          );
          Get.offAll(() => const SignIn());
        } else {
          Fluttertoast.showToast(msg: 'Email-Id already exist');
        }
      } else {
        Fluttertoast.showToast(
            msg: '${response.reasonPhrase} ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    color: AppColors.titleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          'Introduction',
                          'This page contains the terms & conditions. Please read these terms & conditions carefully before ordering any products from us. By purchasing any items from our official application, you agree to be bound by these terms & conditions.\n\nBy placing any order at "BRIIO", you warrant that you are 18 years or above and accept these terms & conditions which shall apply to all orders placed or to be placed at Brij Ornaments Pvt Ltd for the sale and supply of any products.',
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Personal Information',
                          'All personal information you provide us with or that we obtain will be handled by Brij Ornaments Pvt Ltd as responsible for the personal information. The personal information you provide will be used to ensure delivery to you, the credit assessment, to provide offers and information on our catalog to you. The information you provide is only available to Brij Ornaments Pvt Ltd and will not be shared with other third parties.',
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Force Majeure',
                          'Events outside Brij Ornaments Pvt Ltd\'s control, which are not reasonably foreseeable, shall be considered force majeure. Examples of such events are government action or omission, new or amended legislation, conflict, embargo, fire or flood, sabotage, accident, war, natural disasters, strikes or lack of delivery from suppliers.',
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Cookies',
                          '"BRIIO" uses cookies according to the new Electronic Communications Act, which came into force on 25 July 2003. A cookie is a small text file stored on your computer that contains information that helps the website to identify and track the visitor.\n\nThe first type of cookie commonly used is "Session Cookies". During the time you visit the website, our web server assigns your browser a unique identifier string so as not to confuse you with other visitors.',
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Additional Information',
                          'Brij Ornaments Pvt Ltd reserves the right to amend any information, including but not limited to technical specifications, terms of purchase and product offerings without prior notice. At the event of when a product is sold out, Brij Ornaments Pvt Ltd has the right to cancel the order.',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: AppColors.titleColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'I Understand',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Container(
        height: 1,
        color: Colors.grey[200],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toUpperCase(); // Convert input to uppercase
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class FirstLetterUpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    
    // Capitalize first letter of each word
    String newText = newValue.text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
