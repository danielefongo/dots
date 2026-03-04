(function () {
  "use strict";

  const POLL_MS = 500;

  const io = Cc["@mozilla.org/network/io-service;1"].getService(
    Ci.nsIIOService,
  );
  const ss = Cc["@mozilla.org/content/style-sheet-service;1"].getService(
    Ci.nsIStyleSheetService,
  );
  const ds = Cc["@mozilla.org/file/directory_service;1"].getService(
    Ci.nsIProperties,
  );

  const cssFile = ds.get("UChrm", Ci.nsIFile);
  cssFile.append("sine-mods");
  cssFile.append("nix-custom-theme");
  cssFile.append("chrome.css");

  if (!cssFile.exists()) {
    console.warn("[HotReload]: chrome.css not found at", cssFile.path);
    return;
  }

  const cssPath = cssFile.path;
  let lastMtime = 0;
  let timer = null;
  let currentURI = null;

  function freshMtime() {
    const f = Cc["@mozilla.org/file/local;1"].createInstance(Ci.nsIFile);
    f.initWithPath(cssPath);
    return f.lastModifiedTime;
  }

  function reloadStyle() {
    if (currentURI && ss.sheetRegistered(currentURI, ss.USER_SHEET)) {
      ss.unregisterSheet(currentURI, ss.USER_SHEET);
    }
    const uri = io.newURI("file://" + cssPath + "?" + Date.now());
    ss.loadAndRegisterSheet(uri, ss.USER_SHEET);
    currentURI = uri;
  }

  function poll() {
    try {
      const mtime = freshMtime();
      if (mtime !== lastMtime) {
        lastMtime = mtime;
        reloadStyle();
        console.log("[HotReload]: CSS reloaded");
      }
    } catch (e) {
      console.warn("[HotReload]: Poll error:", e);
    }
  }

  try {
    lastMtime = freshMtime();
    reloadStyle();
    console.log("[HotReload]: Initial CSS loaded");
  } catch (e) {
    console.warn("[HotReload]: Initial load error:", e);
  }

  timer = setInterval(poll, POLL_MS);

  window.addEventListener(
    "unload",
    () => {
      if (timer) clearInterval(timer);
      if (currentURI && ss.sheetRegistered(currentURI, ss.USER_SHEET)) {
        ss.unregisterSheet(currentURI, ss.USER_SHEET);
      }
    },
    { once: true },
  );

  console.log("[HotReload]: Watching", cssPath);
})();
