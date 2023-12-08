import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rent/core/enums/filter_type.dart';
import 'package:smart_rent/core/enums/gender.dart';
import 'package:smart_rent/core/enums/room_type.dart';
import 'package:smart_rent/core/enums/sort.dart';
import 'package:smart_rent/core/enums/utilities.dart';
import 'package:smart_rent/core/model/filter/capacity_filter.dart';
import 'package:smart_rent/core/model/filter/filter.dart';
import 'package:smart_rent/core/model/filter/price_filter.dart';
import 'package:smart_rent/core/model/filter/room_type_filter.dart';
import 'package:smart_rent/core/model/filter/sort_filter.dart';
import 'package:smart_rent/core/model/filter/util_filter.dart';
import 'package:smart_rent/core/model/room/room.dart';
import 'package:smart_rent/core/model/room/util_item.dart';
import 'package:smart_rent/core/values/KEY_VALUE.dart';
import 'package:tiengviet/tiengviet.dart';

class FilterController extends GetxController {
  late String location;
  var results = Rx<List<Room>>([]);
  RxBool isLoaded = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var filter = const Filter().obs;
  var filterStringList = RxList<String>([]);
  RxInt itemFilterCount = 0.obs;
  var selectedFilter = Rx<FilterType?>(FilterType.PRICE);

  RxList<UtilItem> utilList = const [
    UtilItem(utility: Utilities.WC, isChecked: false),
    UtilItem(utility: Utilities.WINDOW, isChecked: false),
    UtilItem(utility: Utilities.WIFI, isChecked: false),
    UtilItem(utility: Utilities.KITCHEN, isChecked: false),
    UtilItem(utility: Utilities.LAUNDRY, isChecked: false),
    UtilItem(utility: Utilities.FRIDGE, isChecked: false),
    UtilItem(utility: Utilities.PARKING, isChecked: false),
    UtilItem(utility: Utilities.SECURITY, isChecked: false),
    UtilItem(utility: Utilities.FLEXIBLE_HOURS, isChecked: false),
    UtilItem(utility: Utilities.PRIVATE, isChecked: false),
    UtilItem(utility: Utilities.LOFT, isChecked: false),
    UtilItem(utility: Utilities.PET, isChecked: false),
    UtilItem(utility: Utilities.BED, isChecked: false),
    UtilItem(utility: Utilities.WARDROBE, isChecked: false),
    UtilItem(utility: Utilities.AIR_CONDITIONER, isChecked: false)
  ].obs;

  List<FilterType> filterType = [
    FilterType.PRICE,
    FilterType.UTIL,
    FilterType.ROOM_TYPE,
    FilterType.CAPACITY,
    FilterType.SORT,
  ];

  Rx<RangeValues> currentRangeValues = const RangeValues(0, 100000000).obs;
  var fromPriceTextController = TextEditingController();
  var toPriceTextController = TextEditingController();
  var quantity = 0.obs;
  var genderIdx = 0.obs;

  void setLocation(String location) {
    this.location = location;
    queryRoomByLocation();
  }

  void setPrice(RangeValues values) {
    currentRangeValues.value = values;
    int startValue = currentRangeValues.value.start.round();
    int endValue = currentRangeValues.value.end.round();
    fromPriceTextController.text = startValue.toString();
    toPriceTextController.text = endValue.toString();
    filter.value = filter.value.copyWith(
        priceFilter: PriceFilter(fromPrice: startValue, toPrice: endValue));
    convertFilterToListString();
  }

  void setUtil() {
    filter.value = filter.value.copyWith(
      utilFilter: UtilFilter(
          listUtils: utilList
              .where((util) => util.isChecked)
              .map((util) => util.utility)
              .toList()),
    );
    convertFilterToListString();
  }

  void setRoomType(RoomType value) {
    filter.value =
        filter.value.copyWith(roomTypeFilter: RoomTypeFilter(roomType: value));
    convertFilterToListString();
  }

  void setCapacity() {
    Gender selectedGender;
    switch (genderIdx.value) {
      case 0:
        selectedGender = Gender.FEMALE;
        break;
      case 1:
        selectedGender = Gender.MALE;
        break;
      case 2:
        selectedGender = Gender.ALL;
        break;
      default:
        selectedGender = Gender.FEMALE;
        break;
    }
    filter.value = filter.value.copyWith(
        capacityFilter:
            CapacityFilter(capacity: quantity.value, gender: selectedGender));
    convertFilterToListString();
  }

  void setSort(Sort value) {
    filter.value = filter.value.copyWith(sortFilter: SortFilter(sort: value));
    convertFilterToListString();
  }

  void convertFilterToListString() {
    filterStringList.clear();
    if (filter.value.priceFilter != null) {
      filterStringList.add(
          "${filter.value.priceFilter!.fromPrice.toString()} - ${filter.value.priceFilter!.toPrice.toString()}");
    }
    if (filter.value.utilFilter != null) {
      for (var item in filter.value.utilFilter!.listUtils) {
        filterStringList.add(item.getNameUtil());
      }
    }
    if (filter.value.roomTypeFilter != null) {
      filterStringList
          .add(filter.value.roomTypeFilter!.roomType.getNameRoomType());
    }
    if (filter.value.capacityFilter != null) {
      if (filter.value.capacityFilter!.gender == Gender.ALL) {
        filterStringList.add("${filter.value.capacityFilter!.capacity} Nam/Nữ");
      } else {
        filterStringList.add(
            "${filter.value.capacityFilter!.capacity} ${filter.value.capacityFilter!.gender.getNameGender()}");
      }
    }
    if (filter.value.sortFilter != null) {
      filterStringList.add(filter.value.sortFilter!.sort.getNameSort());
    }
    itemFilterCount.value = filterStringList.length;
  }

  void queryRoomByLocation() async {
    try {
      final querySnapshot =
          await firestore.collection(KeyValue.KEY_COLLECTION_ROOM).get();
      results.value = querySnapshot.docs
          .map(
            (e) => Room.fromJson(
              e.data(),
            ),
          )
          .where((element) => TiengViet.parse(element.location.toLowerCase())
              .contains(TiengViet.parse(location.toLowerCase())))
          .toList();
      isLoaded.value = true;
      print(results.value.length);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void applyFilter() {
    if (filter.value.priceFilter != null) {
      results.value = results.value
          .where((element) =>
              element.price >= filter.value.priceFilter!.fromPrice &&
              element.price <= filter.value.priceFilter!.toPrice)
          .toList();
    }
    if (filter.value.utilFilter != null) {
      results.value = results.value.where((element) {
        for (var i in filter.value.utilFilter!.listUtils) {
          if (element.utilities.any((filter) => filter == i)) {
          } else {
            return false;
          }
        }
        return true;
      }).toList();
    }
    if (filter.value.roomTypeFilter != null) {
      results.value = results.value
          .where((element) =>
              element.roomType == filter.value.roomTypeFilter!.roomType)
          .toList();
    }
    if (filter.value.capacityFilter != null) {
      results.value = results.value
          .where((element) =>
              element.capacity == filter.value.capacityFilter!.capacity &&
              element.gender == filter.value.capacityFilter!.gender)
          .toList();
    }
    if (filter.value.sortFilter != null) {
      switch (filter.value.sortFilter!.sort) {
        case Sort.MOST_RELATED:
          break;
        case Sort.LATEST:
          results.value.sort((a, b) {
            DateTime aDate = DateTime.parse(a.dateTime);
            DateTime bDate = DateTime.parse(b.dateTime);
            return aDate.compareTo(bDate);
          });
          break;
        case Sort.HIGHEST_TO_LOWEST:
          results.value.sort((a, b) => b.price.compareTo(a.price));
          break;
        case Sort.LOWEST_TO_HIGHEST:
          results.value.sort((a, b) => a.price.compareTo(b.price));
          break;
        default:
          break;
      }
    }
  }
}
