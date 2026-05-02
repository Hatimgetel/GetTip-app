import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-consumable product ID — must match Google Play Console / App Store Connect.
const String kRemoveAdsProductId = 'remove_ads';

const String _prefsKeyRemoveAdsVerified = 'iap_remove_ads_verified';

/// Handles "Remove ads" IAP, persists verified state, and exposes [removeAds].
class AdRemovalIapService {
  AdRemovalIapService();

  final ValueNotifier<bool> removeAds = ValueNotifier<bool>(false);

  InAppPurchase? _iap;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  SharedPreferences? _prefs;

  /// True when purchase data passes local checks (see [_verifyRemoveAdsPurchase]).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    removeAds.value = _prefs!.getBool(_prefsKeyRemoveAdsVerified) ?? false;

    if (kIsWeb) {
      return;
    }

    final InAppPurchase iap = InAppPurchase.instance;
    _iap = iap;

    final bool available = await iap.isAvailable();
    if (!available) {
      return;
    }

    _purchaseSub = iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (Object e, StackTrace st) {
        debugPrint('IAP purchase stream error: $e');
      },
    );

    try {
      await iap.restorePurchases();
    } on Exception catch (e) {
      debugPrint('IAP restorePurchases: $e');
    }
  }

  /// Loads product details from the store (Play / App Store).
  Future<ProductDetailsResponse> queryRemoveAdsProduct() async {
    if (kIsWeb || _iap == null) {
      return ProductDetailsResponse(
        productDetails: <ProductDetails>[],
        notFoundIDs: <String>[kRemoveAdsProductId],
        error: IAPError(
          source: 'local',
          code: 'unavailable',
          message: 'In-app purchases are not available on this platform.',
        ),
      );
    }
    final ProductDetailsResponse response =
        await _iap!.queryProductDetails(<String>{kRemoveAdsProductId});
    return response;
  }

  Future<void> purchaseRemoveAds(ProductDetails product) async {
    if (kIsWeb || _iap == null) {
      return;
    }
    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _iap!.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    if (kIsWeb || _iap == null) {
      return;
    }
    try {
      await _iap!.restorePurchases();
    } on Exception catch (e) {
      debugPrint('IAP restorePurchases: $e');
    }
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      if (purchase.productID != kRemoveAdsProductId) {
        if (purchase.pendingCompletePurchase) {
          await _iap?.completePurchase(purchase);
        }
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.error:
          debugPrint('IAP error: ${purchase.error}');
          if (purchase.pendingCompletePurchase) {
            await _iap?.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (_verifyRemoveAdsPurchase(purchase)) {
            await _prefs?.setBool(_prefsKeyRemoveAdsVerified, true);
            removeAds.value = true;
          }
          if (purchase.pendingCompletePurchase) {
            await _iap?.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.canceled:
          if (purchase.pendingCompletePurchase) {
            await _iap?.completePurchase(purchase);
          }
          break;
      }
    }
  }

  /// Local verification before unlocking. For production, also verify
  /// [PurchaseDetails.verificationData] on your backend with Google Play
  /// Developer API / App Store server APIs.
  bool _verifyRemoveAdsPurchase(PurchaseDetails purchase) {
    if (purchase.productID != kRemoveAdsProductId) {
      return false;
    }
    if (purchase.status != PurchaseStatus.purchased &&
        purchase.status != PurchaseStatus.restored) {
      return false;
    }

    if (kIsWeb) {
      return false;
    }

    if (Platform.isAndroid) {
      final String data = purchase.verificationData.serverVerificationData;
      if (data.isEmpty) {
        debugPrint('IAP verification failed: empty serverVerificationData');
        return false;
      }
    } else if (Platform.isIOS) {
      final String local = purchase.verificationData.localVerificationData;
      if (local.isEmpty) {
        debugPrint('IAP verification failed: empty localVerificationData');
        return false;
      }
    }

    return true;
  }

  void dispose() {
    _purchaseSub?.cancel();
    _purchaseSub = null;
    removeAds.dispose();
  }
}
