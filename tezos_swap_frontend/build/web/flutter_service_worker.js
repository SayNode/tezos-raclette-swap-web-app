'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "93e286aa7e7dc68dfdcf6f5713d95152",
"assets/assets/data/contracts.json": "da8692e68c2c5d61e78aceef59eda1f2",
"assets/assets/data/token.json": "9f5c5405ac4f4cec94edfab938192c6e",
"assets/assets/image/BG%2520(0).jpg": "c4431049959227b889b535d95c8e21e3",
"assets/assets/image/BG%2520(1).jpg": "57a15be9991bfc77bbac61db384755b8",
"assets/assets/image/BG%2520(10).jpg": "5a41f3453bea23cff079ece2e61c29fe",
"assets/assets/image/BG%2520(11).jpg": "28fc0fa9ad114dab6bba14a2cf774a69",
"assets/assets/image/BG%2520(12).jpg": "961f6fe43083326687e4b73372d6d35c",
"assets/assets/image/BG%2520(13).jpg": "ead5a5cd897736bcf716ab37092e787c",
"assets/assets/image/BG%2520(2).jpg": "d4ee440d77c3669f9463410f69df2b10",
"assets/assets/image/BG%2520(3).jpg": "1c33801ea880d54f10ae6b54f0a30d20",
"assets/assets/image/BG%2520(4).jpg": "fecef67abc5c4cac6b8b209551550683",
"assets/assets/image/BG%2520(5).jpg": "b6e5954e39a4d79c5e16f64bacdab3cc",
"assets/assets/image/BG%2520(6).jpg": "714945aa60573c8f0e279092cfcc40e5",
"assets/assets/image/BG%2520(7).jpg": "167da6b5c0dda967a9bfcf6780c9b583",
"assets/assets/image/BG%2520(8).jpg": "489a735d3f291bc8e38a345a23f0fb17",
"assets/assets/image/BG%2520(9).jpg": "2b19b3e24b69e88c6820825463a0d908",
"assets/assets/image/bsc_logo.png": "072596a52321c716a03ed8f8c0889a0d",
"assets/assets/image/eth_logo.png": "d400b3be0533e6f038c273ceaba5ebd5",
"assets/assets/image/eth_logo_black.png": "3976d1fb52c83b5a643c801612fd6fe8",
"assets/assets/image/Logo.png": "b4a4a898190e6137448da75ab5e6eb16",
"assets/assets/image/logo_1.png": "a3e669267deacb1cdaaf9d6cba6fba3a",
"assets/assets/image/logo_medium.png": "2b3c6bc39956d51e0cee5ff70d5a08c1",
"assets/assets/image/logo_medium_1.png": "677a0490e47a6fbd0f553c0a81f35e22",
"assets/assets/image/Logo_w.png": "eccd640fa5a318a5681fc198c27c1ccf",
"assets/assets/translations/de.json": "6e23c7bd4b485627ba319067aeab249a",
"assets/assets/translations/en.json": "37b8e6058195a2296689d16da3b14a09",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "66a10adaae839298ce46b2256fdc8a1e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/easy_localization/i18n/ar-DZ.json": "acc0a8eebb2fcee312764600f7cc41ec",
"assets/packages/easy_localization/i18n/ar.json": "acc0a8eebb2fcee312764600f7cc41ec",
"assets/packages/easy_localization/i18n/en-US.json": "5f5fda8715e8bf5116f77f469c5cf493",
"assets/packages/easy_localization/i18n/en.json": "5f5fda8715e8bf5116f77f469c5cf493",
"assets/shaders/ink_sparkle.frag": "ca43c9112596ec461174ab1e74530b18",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "7c6902eb49b918ae6e387c2363f6ef7a",
"/": "7c6902eb49b918ae6e387c2363f6ef7a",
"main.dart.js": "1eb16f1e2ced1d0578e92bb826b55459",
"manifest.json": "e78302696d1b47a98d35c18570d45684",
"sodium.js": "4652c40c29e6140369a6deca42ebb770",
"version.json": "813a653185f1a7e92235b092db779f98"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
