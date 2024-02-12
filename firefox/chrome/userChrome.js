// adapted from from https://gist.github.com/jscher2000/ad268422c3187dbcbc0d15216a3a8060

var ds = Cc["@mozilla.org/file/directory_service;1"].getService(
  Ci.nsIProperties,
);
var io = Cc["@mozilla.org/network/io-service;1"].getService(Ci.nsIIOService);
var ss = Cc["@mozilla.org/content/style-sheet-service;1"].getService(
  Ci.nsIStyleSheetService,
);

function chromePath(path) {
  var chromepath = ds.get("UChrm", Ci.nsIFile);
  chromepath.append(path);
  return chromepath;
}

function reloadStyle() {
  var chromepath = chromePath("style.css");
  var chromefile = io.newFileURI(chromepath);

  if (ss.sheetRegistered(chromefile, ss.USER_SHEET)) {
    ss.unregisterSheet(chromefile, ss.USER_SHEET);
  }
  ss.loadAndRegisterSheet(chromefile, ss.USER_SHEET);
}

function watchStyle() {
  reloadStyle();

  var chromepath = chromePath("style.css");

  var lastModified = chromepath.lastModifiedTime;

  function checkChanges() {
    var currentModified = chromepath.lastModifiedTime;
    if (currentModified > lastModified) {
      reloadStyle();
      lastModified = currentModified;
    }

    setTimeout(checkChanges, 500);
  }

  checkChanges();
}

function setupSpotbar() {
  let input = document.getElementById("urlbar-input");

  input.addEventListener("focus", function () {
    if (
      window.gBrowser.currentURI.asciiSpec.startsWith("about:") &&
      input.value === ""
    ) {
      return;
    }
    let browser = window.gBrowser
      .getPanel()
      .querySelector(".browserStack").firstChild;
    input.value = browser.documentURI.asciiSpec;
    setTimeout(() => {
      input.select();
    }, 50);
  });

  input.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      let browser = window.gBrowser
        .getPanel()
        .querySelector(".browserStack").firstChild;

      input.blur();
      setTimeout(() => {
        input.value = browser.documentURI.asciiSpec;
      }, 50);
      browser.focus();
    }
  });
}

if (gBrowserInit.delayedStartupFinished) {
  watchStyle();
} else {
  let delayedListener = (subject, topic) => {
    if (topic == "browser-delayed-startup-finished" && subject == window) {
      Services.obs.removeObserver(delayedListener, topic);
      setupSpotbar();
      watchStyle();
    }
  };
  Services.obs.addObserver(delayedListener, "browser-delayed-startup-finished");
}
