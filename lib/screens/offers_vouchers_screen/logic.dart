import 'package:kol/map.dart';

import '../../core/models/voucher_model.dart';

List<VoucherModel> vouchers = [];

rebuildVouchers() {
  vouchers = [];
  for (var element in restaurantData.vouchers) {
    vouchers.add(element);
  }
}




