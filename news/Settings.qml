import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  
  implicitWidth: mainColumn.implicitWidth
  implicitHeight: mainColumn.implicitHeight

  ColumnLayout {
    id: mainColumn
    anchors.fill: parent
    spacing: Style.marginL

    // Header
    NText {
      text: I18n.tr("news.settings.title", "News Settings")
      pointSize: Style.fontSizeXL
      font.weight: Style.fontWeightBold
      color: Color.mOnSurface
      Layout.fillWidth: true
    }

    NText {
      text: I18n.tr("news.settings.description", "Configure your news feed from NewsAPI.org")
      pointSize: Style.fontSizeS
      color: Color.mOnSurfaceVariant
      wrapMode: Text.Wrap
      Layout.fillWidth: true
    }

    // API Key Section
    NBox {
      Layout.fillWidth: true

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.marginM
        spacing: Style.marginM

        NText {
          text: I18n.tr("news.settings.api-key", "API Key")
          pointSize: Style.fontSizeM
          font.weight: Style.fontWeightMedium
          color: Color.mOnSurface
        }

        NText {
          text: I18n.tr("news.settings.api-key-desc", "Get your free API key from newsapi.org")
          pointSize: Style.fontSizeXS
          color: Color.mOnSurfaceVariant
          wrapMode: Text.Wrap
          Layout.fillWidth: true
        }

        NTextField {
          id: apiKeyField
          placeholderText: "YOUR_API_KEY_HERE"
          text: pluginApi?.pluginSettings?.apiKey ?? pluginApi?.manifest?.metadata?.defaultSettings?.apiKey ?? ""
          Layout.fillWidth: true
          
          onTextChanged: {
            if (pluginApi) {
              pluginApi.setSetting("apiKey", text)
            }
          }
        }

        NButton {
          text: I18n.tr("news.settings.get-api-key", "Get API Key")
          icon: "external-link"
          onClicked: Qt.openUrlExternally("https://newsapi.org/register")
        }
      }
    }

    // News Settings Section
    NBox {
      Layout.fillWidth: true

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.marginM
        spacing: Style.marginM

        NText {
          text: I18n.tr("news.settings.news-settings", "News Settings")
          pointSize: Style.fontSizeM
          font.weight: Style.fontWeightMedium
          color: Color.mOnSurface
        }

        // Country
        RowLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            text: I18n.tr("news.settings.country", "Country:")
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.preferredWidth: 120
          }

          NComboBox {
            id: countryCombo
            Layout.fillWidth: true
            model: [
              {value: "us", text: "United States"},
              {value: "gb", text: "United Kingdom"},
              {value: "ca", text: "Canada"},
              {value: "au", text: "Australia"},
              {value: "de", text: "Germany"},
              {value: "fr", text: "France"},
              {value: "it", text: "Italy"},
              {value: "jp", text: "Japan"},
              {value: "kr", text: "South Korea"},
              {value: "in", text: "India"}
            ]
            textRole: "text"
            
            Component.onCompleted: {
              var country = pluginApi?.pluginSettings?.country ?? pluginApi?.manifest?.metadata?.defaultSettings?.country ?? "us"
              currentIndex = model.findIndex(item => item.value === country)
            }
            
            onCurrentIndexChanged: {
              if (pluginApi && currentIndex >= 0) {
                pluginApi.setSetting("country", model[currentIndex].value)
              }
            }
          }
        }

        // Category
        RowLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            text: I18n.tr("news.settings.category", "Category:")
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.preferredWidth: 120
          }

          NComboBox {
            id: categoryCombo
            Layout.fillWidth: true
            model: [
              {value: "general", text: "General"},
              {value: "business", text: "Business"},
              {value: "entertainment", text: "Entertainment"},
              {value: "health", text: "Health"},
              {value: "science", text: "Science"},
              {value: "sports", text: "Sports"},
              {value: "technology", text: "Technology"}
            ]
            textRole: "text"
            
            Component.onCompleted: {
              var category = pluginApi?.pluginSettings?.category ?? pluginApi?.manifest?.metadata?.defaultSettings?.category ?? "general"
              currentIndex = model.findIndex(item => item.value === category)
            }
            
            onCurrentIndexChanged: {
              if (pluginApi && currentIndex >= 0) {
                pluginApi.setSetting("category", model[currentIndex].value)
              }
            }
          }
        }

        // Refresh Interval
        RowLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            text: I18n.tr("news.settings.refresh-interval", "Refresh Interval:")
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.preferredWidth: 120
          }

          NSpinBox {
            id: refreshIntervalSpinBox
            from: 5
            to: 1440
            value: pluginApi?.pluginSettings?.refreshInterval ?? pluginApi?.manifest?.metadata?.defaultSettings?.refreshInterval ?? 30
            stepSize: 5
            
            onValueChanged: {
              if (pluginApi) {
                pluginApi.setSetting("refreshInterval", value)
              }
            }
          }

          NText {
            text: I18n.tr("news.settings.minutes", "minutes")
            pointSize: Style.fontSizeXS
            color: Color.mOnSurfaceVariant
          }
        }

        // Max Headlines
        RowLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            text: I18n.tr("news.settings.max-headlines", "Max Headlines:")
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.preferredWidth: 120
          }

          NSpinBox {
            id: maxHeadlinesSpinBox
            from: 1
            to: 100
            value: pluginApi?.pluginSettings?.maxHeadlines ?? pluginApi?.manifest?.metadata?.defaultSettings?.maxHeadlines ?? 10
            
            onValueChanged: {
              if (pluginApi) {
                pluginApi.setSetting("maxHeadlines", value)
              }
            }
          }
        }

        // Widget Width
        RowLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            text: I18n.tr("news.settings.widget-width", "Widget Width:")
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.preferredWidth: 120
          }

          NSpinBox {
            id: widgetWidthSpinBox
            from: 100
            to: 1000
            value: pluginApi?.pluginSettings?.widgetWidth ?? pluginApi?.manifest?.metadata?.defaultSettings?.widgetWidth ?? 300
            stepSize: 10
            
            onValueChanged: {
              if (pluginApi) {
                pluginApi.setSetting("widgetWidth", value)
              }
            }
          }

          NText {
            text: "px"
            pointSize: Style.fontSizeXS
            color: Color.mOnSurfaceVariant
          }
        }

        // Rolling Speed
        RowLayout {
          Layout.fillWidth: true
          spacing: Style.marginM

          NText {
            text: I18n.tr("news.settings.rolling-speed", "Scroll Speed:")
            pointSize: Style.fontSizeS
            color: Color.mOnSurface
            Layout.preferredWidth: 120
          }

          NSpinBox {
            id: rollingSpeedSpinBox
            from: 10
            to: 200
            value: pluginApi?.pluginSettings?.rollingSpeed ?? pluginApi?.manifest?.metadata?.defaultSettings?.rollingSpeed ?? 50
            stepSize: 10
            
            onValueChanged: {
              if (pluginApi) {
                pluginApi.setSetting("rollingSpeed", value)
              }
            }
          }

          NText {
            text: I18n.tr("news.settings.ms-per-pixel", "ms/pixel")
            pointSize: Style.fontSizeXS
            color: Color.mOnSurfaceVariant
          }
        }
      }
    }

    // Info Section
    NBox {
      Layout.fillWidth: true

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.marginM
        spacing: Style.marginS

        RowLayout {
          spacing: Style.marginS

          NIcon {
            icon: "info"
            pointSize: Style.fontSizeM
            color: Color.mPrimary
          }

          NText {
            text: I18n.tr("news.settings.info", "About NewsAPI")
            pointSize: Style.fontSizeM
            font.weight: Style.fontWeightMedium
            color: Color.mOnSurface
          }
        }

        NText {
          text: I18n.tr("news.settings.info-text", 
            "NewsAPI provides news from over 80,000 sources worldwide. " +
            "The free tier allows 100 requests per day. " +
            "News updates automatically based on your refresh interval.")
          pointSize: Style.fontSizeXS
          color: Color.mOnSurfaceVariant
          wrapMode: Text.Wrap
          Layout.fillWidth: true
        }
      }
    }

    Item {
      Layout.fillHeight: true
    }
  }
}
