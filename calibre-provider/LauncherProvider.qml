import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root

  // Plugin API provided by PluginService
  property var pluginApi: null

  // Provider metadata
  property string name: "Calibre"
  property var launcher: null
  property bool handleSearch: false
  property string supportedLayouts: "list"
  property bool supportsAutoPaste: true

  // Browsing state
  property string selectedCategory: "all"
  property bool isBrowsingMode: false

  // Database
  property var database: ({})
  property bool loaded: false
  property bool loading: false


  // Load database on init
  function init() {
    Logger.i("CalibreProvider", "init called, pluginDir:", pluginApi?.pluginDir);
  }

  // Return available commands when user types ">"
  function commands() {
    return [{
      "name": ">cb",
      "description": "Search for books in your Calibre library",
      "icon": "books",
      "isTablerIcon": true,
      "isImage": false,
      "onActivate": function() {
        launcher.setSearchText(">cb ");
      }
    }];
  }

  // Get search results
  function getResults(searchText) {
    if (!searchText.startsWith(">cb")) {
      return [];
    }

    if (loading) {
      return [{
        "name": "Loading...",
        "description": "Loading Calibre database...",
        "icon": "refresh",
        "isTablerIcon": true,
        "isImage": false,
        "onActivate": function() {}
      }];
    }

    if (!loaded) {
      return [{
        "name": "Database not loaded",
        "description": "Try reopening the launcher",
        "icon": "alert-circle",
        "isTablerIcon": true,
        "isImage": false,
        "onActivate": function() {
          root.init();
        }
      }];
    }

    var query = searchText.slice(8).trim().toLowerCase();
    var results = [];

    if (query === "") {
      // Browse mode - show kaomoji by category
      isBrowsingMode = true;
      var keys = Object.keys(database);

      if (selectedCategory === "all") {
        // Show first 100 kaomoji
        for (var i = 0; i < Math.min(keys.length, 100); i++) {
          results.push(formatKaomojiEntry(keys[i], database[keys[i]]));
        }
      } else {
        // Filter by category
        var count = 0;
        for (var j = 0; j < keys.length && count < 100; j++) {
          var entry = database[keys[j]];
          var tags = (entry.new_tags || []).concat(entry.original_tags || []);
          if (tags.indexOf(selectedCategory) !== -1) {
            results.push(formatKaomojiEntry(keys[j], entry));
            count++;
          }
        }
      }
    } else {
      // Search mode
      isBrowsingMode = false;
      var keys = Object.keys(database);
      var count = 0;

      for (var k = 0; k < keys.length && count < 50; k++) {
        var kaomoji = keys[k];
        var entry = database[kaomoji];
        var tags = (entry.new_tags || []).concat(entry.original_tags || []);
        var tagString = tags.join(" ").toLowerCase();

        if (tagString.indexOf(query) !== -1) {
          results.push(formatKaomojiEntry(kaomoji, entry));
          count++;
        }
      }
    }

    return results;
  }
}
