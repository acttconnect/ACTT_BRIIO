import 'package:briio_application/utils/globel_veriable.dart';
import 'package:briio_application/widgets/buttom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'package:briio_application/utils/api_endpoints.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextControllers for user input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  // Update Profile function
  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      String userId = GlobalK.userId.toString();
      String name = _nameController.text;
      String address = _addressController.text;
      String email = _emailController.text;
      String companyName = _companyController.text;
      String gstNumber = _gstController.text;
      String phone = _phoneController.text;
      String? city = selectedCity;
      String? state = selectedState;
      String pincode = _pincodeController.text;

      var request = http.Request(
        'POST',
        Uri.parse(
          '${ApiEndpoints.updateProfile}?user_id=$userId&name=$name&address=$address&email=$email&company_name=$companyName&gst_number=$gstNumber&phone=$phone&city=$city&state=$state&pincode=$pincode',
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        print(data);
        
        // Update GlobalK values with new data
        GlobalK.userFName = name;
        GlobalK.address = address;
        GlobalK.userEmail = email;
        GlobalK.companyName = companyName;
        GlobalK.gst = gstNumber;
        GlobalK.phone = phone;
        GlobalK.city = city;
        GlobalK.state = state;
        GlobalK.pincode = pincode;

        Get.snackbar('Success', 'Profile updated successfully');
        
        // Navigate back to PersonProfile and replace the current screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage5()));
      }
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

  List<String> getCitiesForState(String? state) {
    if (state == null) return [];
    final stateData = statesData.firstWhere((data) => data["state"] == state);
    return List<String>.from(stateData["districts"]);
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill the text controllers with existing user data
    _nameController.text = GlobalK.userFName ?? '';
    _addressController.text = GlobalK.address ?? '';
    _emailController.text = GlobalK.userEmail ?? '';
    _companyController.text = GlobalK.companyName ?? '';
    _gstController.text = GlobalK.gst ?? '';
    _phoneController.text = GlobalK.phone ?? '';
    _pincodeController.text = GlobalK.pincode ?? '';
    
    // Set initial state and city
    selectedState = GlobalK.state;
    if (selectedState != null) {
      cities = getCitiesForState(selectedState);
      selectedCity = GlobalK.city;
    }
  }

  @override 
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _gstController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityField= DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'Select City *',
        border: OutlineInputBorder(),
      ),
      initialValue: selectedCity,
      onChanged: (String? newCity) {
        setState(() {
          selectedCity = newCity;
        });
      },
      items: cities
          .map((city) => DropdownMenuItem<String>(
        value: city,
        child: Text(city),
      ))
          .toList(),
    );

    final stateField = DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: 'Select State *',
        border: OutlineInputBorder(),
      ),
      initialValue: selectedState,
      onChanged: (String? newState) {
        setState(() {
          selectedState = newState;
          selectedCity = null; // Reset city selection
          cities = getCitiesForState(newState); // Update city list based on selected state
        });
      },
      items: statesData
          .map((stateData) => stateData["state"])
          .map((state) {
        return DropdownMenuItem<String>(
          value: state,
          child: Text(state),
        );
      }).toList(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new,size: 18,color: Colors.grey.shade700,)),
        title:  Text('UPDATE PROFILE',
          style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Full Name', Icons.person),
              _buildTextField(_addressController, 'Address', Icons.location_on),
              _buildTextField(_emailController, 'Email', Icons.email),
              _buildTextField(
                  _companyController, 'Company Name', Icons.business),
              _buildTextField(_gstController, 'GST Number', Icons.store),
              _buildTextField(_phoneController, 'Phone', Icons.phone),
              stateField,
              SizedBox(height: 10,),
              cityField,
              _buildTextField(_pincodeController, 'Pincode', Icons.pin),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'Update Profile',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build input fields
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }
}

