'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "28eea87878cc609ae6c549c3999770fa",
"assets/AssetManifest.bin.json": "1a77229dbfcfd2b0ac8ffe20577cf36d",
"assets/assets/audio/1.mp3": "83d393f92e7b75e1bb238c2909dbd56a",
"assets/assets/audio/3alnaar.mp3": "fa16e84f490307e3dee2f6f6c0e49fb8",
"assets/assets/audio/3omda.mp3": "bda20f1f4e90dda490eb0d74f8ca6a57",
"assets/assets/audio/5allasoona.mp3": "4e8b9455b3feabed6a4654e966d6f010",
"assets/assets/audio/beeb.mp3": "ba84b4bd4746af41b05a1a9a14ec467c",
"assets/assets/audio/cancel.mp3": "f4ab315a536eecd135810f10d3dac8ad",
"assets/assets/audio/complete.mp3": "a0a9d16759988ce6ceb7ec5c1e1983f2",
"assets/assets/audio/ehdaa.mp3": "d589e19dc8611b651625dda35deeecc2",
"assets/assets/audio/kebda.mp3": "edfae588ea6b341173684e14e01c30c9",
"assets/assets/audio/mabrook.mp3": "282edafc9bb5b42c89f3931f84a52243",
"assets/assets/audio/order.mp3": "2217cfcf65f09e917cd484dcd725a211",
"assets/assets/images/1.jpg": "9b542967bd3dc7c270d4b4680c1d0834",
"assets/assets/images/2.jpg": "a96b28254aeb28a3b077864b27e09fc9",
"assets/assets/images/3.jpg": "f2568aabc4244faeaa6739dbff5b4abe",
"assets/assets/images/delivery.png": "81b764e8e41b82228322848a560c22c3",
"assets/assets/images/dessert/1.png": "d51e88fc6568221f4d162109afe5732b",
"assets/assets/images/dessert/10.png": "9b63c3cf6e38df5b587fdaf65dd9f512",
"assets/assets/images/dessert/11.png": "dcc81ae124a78573b1c8bae1586d4efe",
"assets/assets/images/dessert/12.png": "a1330ed8a58a3745028eb125654e6a8c",
"assets/assets/images/dessert/13.png": "c402a583ac88598398ea7717ab7029f0",
"assets/assets/images/dessert/14.png": "3068d46ac9108fe3b0564d74e938a4a9",
"assets/assets/images/dessert/2.png": "708a3d531134aa3ba605ba04692ce971",
"assets/assets/images/dessert/3.png": "93212b84fa64984bb741aefb081ba29f",
"assets/assets/images/dessert/4.png": "e85e603ef0039130cecc0e0f20131b10",
"assets/assets/images/dessert/5.png": "908d290321928b092628dad98cdd698e",
"assets/assets/images/dessert/6.png": "e27d6bf6648d48a873d309fb2ceef2b7",
"assets/assets/images/dessert/7.png": "8f178459da5f7208144b80ec1befca1a",
"assets/assets/images/dessert/8.png": "d5a162ba01432611e5d6ae41dff237a4",
"assets/assets/images/dessert/9.png": "4b30ba5c807d3785476fa4a13b15209c",
"assets/assets/images/drinks/1.png": "39c60aa0fc2e8735287a249029cd53cd",
"assets/assets/images/drinks/2.png": "b8b4e9142bd1b3df87c67159a7c1ab57",
"assets/assets/images/drinks/3.png": "da466c7f310a6c4b624ec34e74d48423",
"assets/assets/images/drinks/4.png": "d88f5c41cf97f2a83323c034f04479e2",
"assets/assets/images/drinks/5.png": "e29fc2e6673c5e0f710a46388415d7bc",
"assets/assets/images/drinks/6.png": "35fffae1df1ce0f2df544c342d82e80c",
"assets/assets/images/drinks/7.png": "958ba4f8af7b934061c1590ac5c7755d",
"assets/assets/images/drinks/8.png": "4fc5313f700c1fbb6ba9c2618fbd47b3",
"assets/assets/images/driver.png": "41f80fe807d4fc5c0dc9ef5de9eaf3e9",
"assets/assets/images/food/1.png": "38d7ca2435c43b4a8436d67b46456172",
"assets/assets/images/food/10.png": "bc0ad8243d5e0e4ff4ecbfdfb4d4e5e1",
"assets/assets/images/food/11.png": "417e1dc2543b4fc6c1aee52424e5f99f",
"assets/assets/images/food/12.png": "fb1eb529ab6b944aa99c98cf82a2752e",
"assets/assets/images/food/13.png": "97c95160fdd4295e3c30facf1de24709",
"assets/assets/images/food/14.png": "f30fd2ea905ddbcdf71c042d8768749a",
"assets/assets/images/food/15.png": "df9fed6d86c9b68ac90a1f6aec9d6d12",
"assets/assets/images/food/16.png": "24122f57e098053c834419d0e9ed8e6e",
"assets/assets/images/food/17.png": "265b4db6dc81cc0dfc0e64efde77cf04",
"assets/assets/images/food/18.png": "1a4fcf4bd8081969fab8d74d3538a451",
"assets/assets/images/food/19.png": "98c6b145cd4d2b1020c3bc2a3dda7612",
"assets/assets/images/food/2.png": "77c1aeafeeffc23f7b4efe1a63d82ac1",
"assets/assets/images/food/20.png": "f4ada551d9eeebcca343039eafce77e3",
"assets/assets/images/food/21.png": "3079fdac6bf00f4bed655e338fabe64a",
"assets/assets/images/food/22.png": "8ccd79ad6f2c0e82ace633df016417a2",
"assets/assets/images/food/23.png": "a87b159c137a89f7b51e3b3671727175",
"assets/assets/images/food/3.png": "e09aa24ec99c350d2a19adad5735d7cb",
"assets/assets/images/food/4.png": "cf9535e30c189856ed30ade8718340e5",
"assets/assets/images/food/5.png": "b98429b15ad90cc351bd4b9de324a702",
"assets/assets/images/food/6.png": "dcd70f77f17edef8187a32449bf4d92b",
"assets/assets/images/food/7.png": "361e4feb64a011807bfef0ae5f93bb8e",
"assets/assets/images/food/8.png": "59378cd32f7f683b05a7387d64d4990a",
"assets/assets/images/food/9.png": "bf241fce26e1630d8273d54e0c5b54b8",
"assets/assets/images/icons.png": "31c0180913a64d73dbaf0a163b47547a",
"assets/assets/images/icons2.png": "8bfef2c7554f3051f9a1bc8a55a2dd6c",
"assets/assets/images/logo.png": "1e3d1e6be724e8d46ee063e9d5d6b99f",
"assets/assets/images/nointernetavatar.png": "29d74ab4327073b5b379cdd1bb727891",
"assets/assets/images/restaurant.jpg": "9f06f5e536a4b4f86fa16ccb83d482ab",
"assets/assets/images/user.png": "14128e69a0b12653d8fa776c37e0b2ac",
"assets/assets/riv/dropdownmenu.riv": "6d082b2e727af3b124929e97592faaf4",
"assets/assets/riv/logo.riv": "08e12a6f7fa6f9d18bf3f2bf03c8937f",
"assets/FontManifest.json": "a24196b4273c82f0e08b4cd1e9338205",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "db6db726916fb6b026318e0684fbfd6a",
"assets/packages/arabic_font/assets/fonts/Amiri/Amiri-Bold.ttf": "2accfcd6b3faf83d349942a19b91e12b",
"assets/packages/arabic_font/assets/fonts/Amiri/Amiri-BoldItalic.ttf": "1f0cfd59bef4321ff35af3ea69415e55",
"assets/packages/arabic_font/assets/fonts/Amiri/Amiri-Italic.ttf": "ca54f2483d9429c0a47fba80249ceede",
"assets/packages/arabic_font/assets/fonts/Amiri/Amiri-Regular.ttf": "a61fbc4d3da365e17f68e1bba6415e47",
"assets/packages/arabic_font/assets/fonts/Aref_Ruqaa/ArefRuqaa-Bold.ttf": "7b87d843f32f71e0cf71766945d712e4",
"assets/packages/arabic_font/assets/fonts/Aref_Ruqaa/ArefRuqaa-Regular.ttf": "8ff92bc4b7f51b61d2d628220a08d2d3",
"assets/packages/arabic_font/assets/fonts/Avenir_Arabic/Avenir-Arabic-Black.ttf": "8da1b8bbca4fc2b131d4fbe89401ead7",
"assets/packages/arabic_font/assets/fonts/Avenir_Arabic/Avenir-Arabic-Book.ttf": "3ea540836144a296c99076a69a5191b1",
"assets/packages/arabic_font/assets/fonts/Avenir_Arabic/Avenir-Arabic-Heavy.ttf": "bae31091c8c902377f6459130fd3548e",
"assets/packages/arabic_font/assets/fonts/Avenir_Arabic/Avenir-Arabic-Medium.ttf": "9cfd6cd4923f712b864f4d891959d107",
"assets/packages/arabic_font/assets/fonts/Avenir_Arabic/Avenir-Arabic-Regular.ttf": "7368b0c6d9169b637e27948df6ff72f0",
"assets/packages/arabic_font/assets/fonts/Baloo_Bhaijaan/BalooBhaijaan-Regular.ttf": "28190ae5cd54e8bf270404320d5e0821",
"assets/packages/arabic_font/assets/fonts/Cairo/Cairo-Black.ttf": "41774c33b29f951d86110f0e8cd527bb",
"assets/packages/arabic_font/assets/fonts/Cairo/Cairo-Bold.ttf": "ca9036ba6a756880f334d959b1b5f549",
"assets/packages/arabic_font/assets/fonts/Cairo/Cairo-ExtraLight.ttf": "118c56fd3f0773d43bdcd16deb8370d0",
"assets/packages/arabic_font/assets/fonts/Cairo/Cairo-Light.ttf": "532ee41c709ac28455bed88dd839ddb8",
"assets/packages/arabic_font/assets/fonts/Cairo/Cairo-Regular.ttf": "8e62cfbb90ccadc00b59b977c93eb31a",
"assets/packages/arabic_font/assets/fonts/Cairo/Cairo-SemiBold.ttf": "984ec9c232c5936cadb14e87cf1283db",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-Bold.ttf": "919bffaf44e0410995355e7441435370",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-ExtraBold.ttf": "73fcacc8fd46a0eed3037a20982d2cc7",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-ExtraLight.ttf": "0eccd5677b2ef5b0342169564e571a05",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-Light.ttf": "e2f7d3402c1c52456c09db40a80228f0",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-Medium.ttf": "c3af486a73a7461b1122665df86a7733",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-Regular.ttf": "7a53368c4704181a547f440c6273159b",
"assets/packages/arabic_font/assets/fonts/Changa/Changa-SemiBold.ttf": "125489c0710514546290914ac822a720",
"assets/packages/arabic_font/assets/fonts/DinNextLTArabic/ArbFONTS-DINNextLTArabic-Black-3.ttf": "8929fabf224e33fc76110ff98651aa7b",
"assets/packages/arabic_font/assets/fonts/DinNextLTArabic/ArbFONTS-DINNextLTArabic-Bold-2.ttf": "24421421e9210a40c31dda3d7d47995a",
"assets/packages/arabic_font/assets/fonts/DinNextLTArabic/ArbFONTS-DINNextLTArabic-Heavy-1.ttf": "87b2169d28ef227898bfb5db66ef2ca8",
"assets/packages/arabic_font/assets/fonts/DinNextLTArabic/ArbFONTS-DINNEXTLTARABIC-LIGHT-1.ttf": "d78f5d2c76185fa07aaf8dd729eef33e",
"assets/packages/arabic_font/assets/fonts/DinNextLTArabic/ArbFONTS-DINNextLTArabic-Medium-2.ttf": "8bb0cc139f4ae9080896b1bbf8b126ec",
"assets/packages/arabic_font/assets/fonts/DinNextLTArabic/ArbFONTS-DINNextLTArabic-Regular-2.ttf": "61b1e04ff205cd324350749648fe16fc",
"assets/packages/arabic_font/assets/fonts/Dubai/Dubai-Bold.ttf": "8fbdda63d87a91c5600c512a12aec79a",
"assets/packages/arabic_font/assets/fonts/Dubai/Dubai-Light.ttf": "2f7c5bb9cf55f5b0cb2d06c57d5a8ae7",
"assets/packages/arabic_font/assets/fonts/Dubai/Dubai-Medium.ttf": "1b70cb9a589df286a5e4faf70e2a50d9",
"assets/packages/arabic_font/assets/fonts/Dubai/Dubai-Regular.ttf": "24ab51f6ae1804c808f822d28b9be18a",
"assets/packages/arabic_font/assets/fonts/El_Messiri/ElMessiri-Bold.ttf": "1a4d3ffd4a8a7017d2a57c22105dead4",
"assets/packages/arabic_font/assets/fonts/El_Messiri/ElMessiri-Medium.ttf": "a88b6e918867744f5a28a5f4646c712f",
"assets/packages/arabic_font/assets/fonts/El_Messiri/ElMessiri-Regular.ttf": "f987603b0ad311424b5c64c55e10d10c",
"assets/packages/arabic_font/assets/fonts/El_Messiri/ElMessiri-SemiBold.ttf": "a2fc08a54a46b0663a084ce4ba19cce2",
"assets/packages/arabic_font/assets/fonts/Harmattan/Harmattan-Regular.ttf": "bcd87a685fc9fa2f88ae49bf9662649c",
"assets/packages/arabic_font/assets/fonts/ibm/IBMPlexArabic-Text.ttf": "76b0d039397c1d22ed2e38e5d7af9ae7",
"assets/packages/arabic_font/assets/fonts/Jomhuria/Jomhuria-Regular.ttf": "7d6b466d0e08fd984705b6190e6554a6",
"assets/packages/arabic_font/assets/fonts/Katibeh/Katibeh-Regular.ttf": "b9a90c628ecd4066bc9a44f548b67ff9",
"assets/packages/arabic_font/assets/fonts/Lalezar/Lalezar-Regular.ttf": "c07a18bb821945af6ec7de632e877731",
"assets/packages/arabic_font/assets/fonts/Lateef/LateefRegOT.ttf": "f98cf82fba21f78b335a41f343c5f0c9",
"assets/packages/arabic_font/assets/fonts/Lemonada/Lemonada-Bold.ttf": "ec008f8a072ecd3d535f2cac97e9ba89",
"assets/packages/arabic_font/assets/fonts/Lemonada/Lemonada-Light.ttf": "f6dbfb6fa1cf1d1a3070c0f0ceb2d585",
"assets/packages/arabic_font/assets/fonts/Lemonada/Lemonada-Regular.ttf": "659eae40390059a683cc91faf4df4ca9",
"assets/packages/arabic_font/assets/fonts/Lemonada/Lemonada-SemiBold.ttf": "91d517aec1170078f0b2eab23b4eef26",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-Black.ttf": "77e982cb003544f8c4832af58f5a8051",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-Bold.ttf": "6087ba6d5c2ac2ad094c8a545839775e",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-ExtraLight.ttf": "b5043d5fc92c52c730e4faff41118815",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-Light.ttf": "7b3ad1c8f7d7dbc35890123434adae55",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-Medium.ttf": "e3d9e7676a26eae957fad1e69c33d5a7",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-Regular.ttf": "9b3ddca6af7328102938afab0d55bc9d",
"assets/packages/arabic_font/assets/fonts/Mada/Mada-SemiBold.ttf": "28191d02304034b2421f2bacb91b78aa",
"assets/packages/arabic_font/assets/fonts/Markazi_Text/MarkaziText-Regular.ttf": "367d77a763df54f70c6ebe345598f2fb",
"assets/packages/arabic_font/assets/fonts/Mirza/Mirza-Bold.ttf": "d3cc57b384c4ccfcab258d4ade64b7f5",
"assets/packages/arabic_font/assets/fonts/Mirza/Mirza-Medium.ttf": "3b667481a859085d1a27e221bf45f3a9",
"assets/packages/arabic_font/assets/fonts/Mirza/Mirza-Regular.ttf": "21fd4e3c1c6f103d8b00b8a30d211c49",
"assets/packages/arabic_font/assets/fonts/Mirza/Mirza-SemiBold.ttf": "27b1558b9550a3196031a61fc6e0687e",
"assets/packages/arabic_font/assets/fonts/Rakkas/Rakkas-Regular.ttf": "1197ba69414123d92777f819a43a7d27",
"assets/packages/arabic_font/assets/fonts/Reem_Kufi/ReemKufi-Regular.ttf": "1cbfee67b7f1e63e1334e8800d5450b6",
"assets/packages/arabic_font/assets/fonts/Scheherazade/Scheherazade-Bold.ttf": "b26c8ba6aae29ef98d54c0841398ef34",
"assets/packages/arabic_font/assets/fonts/Scheherazade/Scheherazade-Regular.ttf": "87ffd3a053cd6c09186452cb10d9a15a",
"assets/packages/arabic_font/assets/fonts/Tajawal/Tajawal-Black.ttf": "d8e4db47417985783913a2d64ca6e8cf",
"assets/packages/arabic_font/assets/fonts/Tajawal/Tajawal-Bold.ttf": "73222b42f57d11db8ed71c1752e121c0",
"assets/packages/arabic_font/assets/fonts/Tajawal/Tajawal-ExtraBold.ttf": "87a0f0773f0cdc28fd8dd3603bf34837",
"assets/packages/arabic_font/assets/fonts/Tajawal/Tajawal-ExtraLight.ttf": "4dba176f2d532f19d9c4c61502bca07b",
"assets/packages/arabic_font/assets/fonts/Tajawal/Tajawal-Light.ttf": "5c8f739351e568ec0c9fc0dc8a6994b4",
"assets/packages/arabic_font/assets/fonts/Tajawal/Tajawal-Medium.ttf": "1472d65abf09fa765956fd3d32dadf48",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/packages/elegant_notification/assets/icons/error.png": "2a84d22ca4a8d9123f1e3149121b0976",
"assets/packages/elegant_notification/assets/icons/info.png": "84b36b60ddacca6c063112fd636bdefb",
"assets/packages/elegant_notification/assets/icons/success.png": "a27784120d6634f48b24e12c4604f9d9",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/packages/getwidget/icons/dribble.png": "1e36936e4411f32b0e28fd8335495647",
"assets/packages/getwidget/icons/facebook.png": "293dc099a89c74ae34a028b1ecd2c1f0",
"assets/packages/getwidget/icons/google.png": "596c5544c21e9d6cb02b0768f60f589a",
"assets/packages/getwidget/icons/line.png": "da8d1b531d8189396d68dfcd8cb37a79",
"assets/packages/getwidget/icons/linkedin.png": "822742104a63a720313f6a14d3134f61",
"assets/packages/getwidget/icons/pinterest.png": "d52ccb1e2a8277e4c37b27b234c9f931",
"assets/packages/getwidget/icons/slack.png": "19155b848beeb39c1ffcf743608e2fde",
"assets/packages/getwidget/icons/twitter.png": "caee56343a870ebd76a090642d838139",
"assets/packages/getwidget/icons/wechat.png": "ba10e8b2421bde565e50dfabc202feb7",
"assets/packages/getwidget/icons/whatsapp.png": "30632e569686a4b84cc68169fb9ce2e1",
"assets/packages/getwidget/icons/youtube.png": "1bfda73ab724ad40eb8601f1e7dbc1b9",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "39aa8e359d5bc8d17dacb59d34a5b434",
"firebase-messaging-sw.js": "76d2fc6bdbde27cd443ac58ab1145320",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "f02d174148b699cefe834f31c7d937dc",
"icons/Icon-192.png": "a5ff65853927717a2cfdb24f74f2efd8",
"icons/Icon-512.png": "de0c52bbf3419d05dd4385dfd86651f8",
"icons/Icon-maskable-192.png": "a5ff65853927717a2cfdb24f74f2efd8",
"icons/Icon-maskable-512.png": "de0c52bbf3419d05dd4385dfd86651f8",
"index.html": "189a81f7dc84197cad75ea6e8bd6b31b",
"/": "189a81f7dc84197cad75ea6e8bd6b31b",
"main.dart.js": "2c0919949966047f72a8cedf431ae3c4",
"manifest.json": "0d1f61f055db02002201e800bcc83a61",
"version.json": "6e9fcc0f4a838c4bfe542279808ba336"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
