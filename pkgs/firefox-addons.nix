{ pkgs, ... }:

final: prev:
let
  addons = prev.nur.repos.rycee.firefox-addons;
in
{
  firefox-addons = addons // {
    graphql-inspector = addons.buildFirefoxXpiAddon {
      pname = "GraphQL Inspector";
      version = "2.19.0";
      addonId = "warrenjday@graphqlnetworkinspector.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4214326/graphql_network_inspector-2.19.0.xpi";
      sha256 = "sha256-a/m0w0XAXsfePVv+bUzfuvmtecTNvStx5X6rWq65g3E=";
      meta = {
        homepage = "https://addons.mozilla.org/en-US/firefox/addon/graphql-network-inspector/";
        description = "A platform agnostic network inspector specifically built for GraphQL. Clearly see individual GraphQL requests including support for query batching. Works with any client including Apollo and Relay.";
      };
    };

    libredirect = addons.buildFirefoxXpiAddon {
      pname = "LibRedirect";
      version = "3.2.0";
      addonId = "7esoorv3@alefvanoon.anonaddy.me";
      url = "https://addons.mozilla.org/firefox/downloads/file/4522826/libredirect-3.2.0.xpi";
      sha256 = "sha256-ukz4/pcnXXCC/qCFoJeWSBEihFRV3xr1JKchD/8+zzw=";
      meta = {
        homepage = "https://addons.mozilla.org/en-US/firefox/addon/libredirect/";
        description = "Redirects YouTube, Twitter, TikTok... requests to alternative privacy friendly frontends.";
      };
    };

    yet-another-smooth-scrolling = addons.buildFirefoxXpiAddon {
      pname = "yet-another-smooth-scrolling";
      version = "2.0.13";
      addonId = "yetanothersmoothscrollingwe@kataho";
      url = "https://addons.mozilla.org/firefox/downloads/file/4422568/yass_we-2.0.13.xpi";
      sha256 = "sha256-zaHurzJGVNtPM6TxtPZEMHdwGkDPjtvbPLSfc8ezKco=";
      meta = {
        homepage = "https://addons.mozilla.org/en-US/firefox/addon/yass-we/";
        description = "Customizable smooth scrolling for both mouse and keyboard.";
      };
    };
  };
}
