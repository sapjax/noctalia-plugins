import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  // Plugin API (injected by the settings dialog system)
  property var pluginApi: null

  // Local state for editing
  property string editDbPath: pluginApi?.pluginSettings?.dbPath || Quickshell.env("HOME")

  spacing: Style.marginM

  // Calibre db
  ColumnLayout {
      NLabel {
          enabled: root.active
          label: pluginApi?.tr("settings.calibre_db") || "Calibre Database Location"
          description: pluginApi?.tr("settings.calibre_db_description") || "The metadata.db file at the root of your Calibre library"
      }

      RowLayout {
          NTextInput {
              enabled: root.active
              Layout.fillWidth: true
              placeholderText: pluginApi?.tr("settings.input_placeholder") || "/path/to/calibre/metadata.db"
              text: root.editDbPath
              onTextChanged: root.editDbPath = text
          }

          NIconButton {
              enabled: root.active
              icon: "file-database"
              tooltipText: pluginApi?.tr("settings.icon_tooltip") || "Select database file"
              onClicked: wallpapersFolderPicker.openFilePicker()
          }

          NFilePicker {
              id: wallpapersFolderPicker
              title: pluginApi?.tr("settings.file_picker_title") || "Choose database file"
              initialPath: root.editDbPath
              selectionMode: "files"
              nameFilters: ["metadata.db"]

              onAccepted: paths => {
                  if (paths.length > 0) {
                      Logger.d("CalibreProvider", "Selected the following calibre database file:", paths[0]);
                      root.editDbPath = paths[0];
                  }
              }
          }
      }
  }


  // Required: Save function called by the dialog
  function saveSettings() {
    pluginApi.pluginSettings.dbPath = root.editDbPath
    pluginApi.saveSettings()
  }
}
