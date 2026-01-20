import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/myTextField.dart';
import 'package:kol/components/my_inkwell.dart';

import '../styles.dart';

class DropDownValueModel extends Equatable {
  final String name;
  final String phoneNumber;
  final String image;
  final String id;

  const DropDownValueModel({
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.id,
  });

  static const empty =
      DropDownValueModel(name: "", phoneNumber: "", image: "", id: "");

  @override
  List<Object> get props => [name, phoneNumber, id];
}

class SingleValueDropDownController extends ChangeNotifier {
  final ValueNotifier<DropDownValueModel> dropDownValue =
      ValueNotifier(DropDownValueModel.empty);

  SingleValueDropDownController({DropDownValueModel? data}) {
    if (data != null) {
      dropDownValue.value = data;
    }
  }

  setDropDown(DropDownValueModel? model) {
    dropDownValue.value = model ?? DropDownValueModel.empty;
    notifyListeners();
  }

  clearDropDown() {
    dropDownValue.value = DropDownValueModel.empty;
    notifyListeners();
  }
}

class DropDownTextField extends StatefulWidget {
  final List<DropDownValueModel> dropDownList;
  final SingleValueDropDownController? controller;
  final ValueSetter<DropDownValueModel>? onChanged;
  final String hintText;
  final double dropdownRadius;
  final Color? dropdownColor;

  const DropDownTextField({
    Key? key,
    required this.dropDownList,
    this.controller,
    this.onChanged,
    this.hintText = "اختار طيار",
    this.dropdownRadius = 20,
    this.dropdownColor,
  }) : super(key: key);

  @override
  State<DropDownTextField> createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;
  OverlayEntry? _barrierEntry;
  bool _isExpanded = false;
  late List<DropDownValueModel> _filteredList;
  late SingleValueDropDownController _effectiveController;

  @override
  void initState() {
    super.initState();
    _filteredList = widget.dropDownList;
    _effectiveController = widget.controller ?? SingleValueDropDownController();
    _effectiveController.addListener(_handleControllerUpdate);
  }

  void _handleControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(DropDownTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerUpdate);
      _effectiveController =
          widget.controller ?? SingleValueDropDownController();
      _effectiveController.addListener(_handleControllerUpdate);
    }
    if (widget.dropDownList != oldWidget.dropDownList) {
      _filteredList = widget.dropDownList;
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerUpdate);
    _hideOverlay(); // Move this before disposing search controller
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _searchController.dispose();
    });
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isExpanded) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _barrierEntry = _createBarrierEntry();
    Overlay.of(context).insert(_barrierEntry!);

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      _isExpanded = true;
    });
  }

  void _hideOverlay() {
    _barrierEntry?.remove();
    _barrierEntry = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isExpanded = false;
        _filteredList = widget.dropDownList;
        _searchController.clear();
      });
    }
  }

  OverlayEntry _createBarrierEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideOverlay,
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(widget.dropdownRadius.r),
            color: widget.dropdownColor ?? backGroundColor,
            child: Container(
              constraints: BoxConstraints(maxHeight: 0.4.sh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.dropdownRadius.r),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: MyTextField(
                      controller: _searchController,
                      hintText: "بحث...",
                      type: 'normal',
                      title: "",
                      error: "",
                      onChanged: (val) {
                        setState(() {
                          _filteredList = widget.dropDownList
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()))
                              .toList();
                        });
                        _overlayEntry?.markNeedsBuild();
                      },
                      isExpanding: false,
                      isValidatable: false,
                      maxLength: 10000,
                      descriptionTextField: false,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) {
                        final item = _filteredList[index];
                        return MyInkWell(
                          onTap: () {
                            _effectiveController.setDropDown(item);
                            if (widget.onChanged != null) {
                              widget.onChanged!(item);
                            }
                            _hideOverlay();
                          },
                          radius: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.sp, vertical: 12.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  item.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontSize: kIsWeb ? 22.sp : 36.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(width: 16.sp),
                                Container(
                                  height: kIsWeb ? 40.sp : 80.sp,
                                  width: kIsWeb ? 40.sp : 80.sp,
                                  child: CachedAvatar(
                                    imageUrl: item.image,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ValueListenableBuilder<DropDownValueModel>(
        valueListenable: _effectiveController.dropDownValue,
        builder: (context, selectedValue, child) {
          bool hasSelection = selectedValue.id.isNotEmpty;

          return GestureDetector(
            onTap: _toggleOverlay,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? 16.sp : 35.sp,
                vertical: kIsWeb ? 10.sp : 10.sp,
              ),
              decoration: BoxDecoration(
                color: warmColor,
                borderRadius: BorderRadius.circular(kIsWeb ? 12 : 30.r),
                border: Border.all(
                  color: _isExpanded ? primaryColor : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: primaryColor,
                    size: kIsWeb ? 24.sp : 40.sp,
                  ),
                  const Spacer(),
                  if (!hasSelection)
                    Text(
                      widget.hintText,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: kIsWeb ? 22.sp : 40.spMin,
                                color: primaryColor.withOpacity(0.3),
                              ),
                    )
                  else
                    Row(
                      children: [
                        Text(
                          selectedValue.name,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                fontSize: kIsWeb ? 20.sp : 36.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(width: 16.sp),
                        SizedBox(
                          height: kIsWeb ? 40.sp : 80.sp,
                          width: kIsWeb ? 40.sp : 80.sp,
                          child: CachedAvatar(
                            imageUrl: selectedValue.image,
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
