import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key, required this.filters});

  final Filters filters;

  @override
  FilterPageState createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  late Filters filters;
  late GlobalKey<FormState> formKey;
  double _startValue = 10;
  double _endValue = 100;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    filters = widget.filters;
    _startValue = filters.weightFrom.toDouble();
    _endValue = filters.weightTo.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey.shade700,
            size: 20,
          ),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'FILTERS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: 20,
              ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Weight",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " (in grams)",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_startValue.toInt()} g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${_endValue.toInt()} g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(_startValue, _endValue),
                min: 0,
                max: 200,
                divisions: 100,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                labels: RangeLabels(
                  _startValue.toInt().toString(),
                  _endValue.toInt().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _startValue = values.start;
                    _endValue = values.end;
                    filters = Filters(
                      weightFrom: values.start.toInt(),
                      weightTo: values.end.toInt(),
                      numberOfPieces: filters.numberOfPieces,
                    );
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                "No. of Pieces",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter number of pieces",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                initialValue: filters.numberOfPieces.toString(),
                keyboardType: TextInputType.number,
                onSaved: (newValue) {
                  setState(() {
                    filters =
                        filters.copyWith(numberOfPieces: int.parse(newValue!));
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    filters = Filters(
                      weightFrom: _startValue.toInt(),
                      weightTo: _endValue.toInt(),
                      numberOfPieces: filters.numberOfPieces,
                    );
                    Get.back(result: filters);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply Filters",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class Filters {
  final int weightFrom;
  final int weightTo;
  final int numberOfPieces;

  Filters({
    this.weightFrom = 10,
    this.weightTo = 100,
    this.numberOfPieces = 2,
  });

  //Copy With
  Filters copyWith({
    int? weightFrom,
    int? weightTo,
    int? numberOfPieces,
  }) {
    return Filters(
      weightFrom: weightFrom ?? this.weightFrom,
      weightTo: weightTo ?? this.weightTo,
      numberOfPieces: numberOfPieces ?? this.numberOfPieces,
    );
  }
}
