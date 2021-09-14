//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `localAnimation.gif`.
    static let localAnimationGif = Rswift.FileResource(bundle: R.hostingBundle, name: "localAnimation", pathExtension: "gif")
    /// Resource file `localVideo.mp4`.
    static let localVideoMp4 = Rswift.FileResource(bundle: R.hostingBundle, name: "localVideo", pathExtension: "mp4")

    /// `bundle.url(forResource: "localAnimation", withExtension: "gif")`
    static func localAnimationGif(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.localAnimationGif
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "localVideo", withExtension: "mp4")`
    static func localVideoMp4(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.localVideoMp4
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 14 images.
  struct image {
    /// Image `LaunchImage`.
    static let launchImage = Rswift.ImageResource(bundle: R.hostingBundle, name: "LaunchImage")
    /// Image `ad_mute`.
    static let ad_mute = Rswift.ImageResource(bundle: R.hostingBundle, name: "ad_mute")
    /// Image `ad_resource`.
    static let ad_resource = Rswift.ImageResource(bundle: R.hostingBundle, name: "ad_resource")
    /// Image `ad_restore`.
    static let ad_restore = Rswift.ImageResource(bundle: R.hostingBundle, name: "ad_restore")
    /// Image `localAnimation.gif`.
    static let localAnimationGif = Rswift.ImageResource(bundle: R.hostingBundle, name: "localAnimation.gif")
    /// Image `toast_fail`.
    static let toast_fail = Rswift.ImageResource(bundle: R.hostingBundle, name: "toast_fail")
    /// Image `toast_success`.
    static let toast_success = Rswift.ImageResource(bundle: R.hostingBundle, name: "toast_success")
    /// Image `user_guide01`.
    static let user_guide01 = Rswift.ImageResource(bundle: R.hostingBundle, name: "user_guide01")
    /// Image `user_guide02`.
    static let user_guide02 = Rswift.ImageResource(bundle: R.hostingBundle, name: "user_guide02")
    /// Image `user_guide03`.
    static let user_guide03 = Rswift.ImageResource(bundle: R.hostingBundle, name: "user_guide03")
    /// Image `user_guide04`.
    static let user_guide04 = Rswift.ImageResource(bundle: R.hostingBundle, name: "user_guide04")
    /// Image `vc_home`.
    static let vc_home = Rswift.ImageResource(bundle: R.hostingBundle, name: "vc_home")
    /// Image `vc_tab`.
    static let vc_tab = Rswift.ImageResource(bundle: R.hostingBundle, name: "vc_tab")
    /// Image `vc_user`.
    static let vc_user = Rswift.ImageResource(bundle: R.hostingBundle, name: "vc_user")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "LaunchImage", bundle: ..., traitCollection: ...)`
    static func launchImage(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launchImage, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ad_mute", bundle: ..., traitCollection: ...)`
    static func ad_mute(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ad_mute, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ad_resource", bundle: ..., traitCollection: ...)`
    static func ad_resource(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ad_resource, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ad_restore", bundle: ..., traitCollection: ...)`
    static func ad_restore(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.ad_restore, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "localAnimation.gif", bundle: ..., traitCollection: ...)`
    static func localAnimationGif(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.localAnimationGif, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "toast_fail", bundle: ..., traitCollection: ...)`
    static func toast_fail(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.toast_fail, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "toast_success", bundle: ..., traitCollection: ...)`
    static func toast_success(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.toast_success, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "user_guide01", bundle: ..., traitCollection: ...)`
    static func user_guide01(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.user_guide01, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "user_guide02", bundle: ..., traitCollection: ...)`
    static func user_guide02(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.user_guide02, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "user_guide03", bundle: ..., traitCollection: ...)`
    static func user_guide03(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.user_guide03, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "user_guide04", bundle: ..., traitCollection: ...)`
    static func user_guide04(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.user_guide04, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "vc_home", bundle: ..., traitCollection: ...)`
    static func vc_home(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.vc_home, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "vc_tab", bundle: ..., traitCollection: ...)`
    static func vc_tab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.vc_tab, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "vc_user", bundle: ..., traitCollection: ...)`
    static func vc_user(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.vc_user, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      // There are no resources to validate
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R {
  fileprivate init() {}
}
