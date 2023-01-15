// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
#endif

// MARK: - Asset Catalogs

internal typealias Colors = Asset.Colors
internal typealias Images = Asset.Images

internal enum Asset {
  internal enum Colors {
    internal static let mainColor = UIColor(named: "MainColor", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let secondColor = UIColor(named: "SecondColor", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let textColor = UIColor(named: "TextColor", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let clients = UIColor(named: "clients", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let lightGray = UIColor(named: "lightGray", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let people = UIColor(named: "people", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let projects = UIColor(named: "projects", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let releases = UIColor(named: "releases", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let timeline = UIColor(named: "timeline", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
  }
  internal enum Images {
    internal static let accentColor = UIColor(named: "AccentColor", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let defaultProfileImage = UIImage(named: "DefaultProfileImage", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let appleLogo = UIImage(named: "appleLogo", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let armWeight = UIImage(named: "armWeight", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let iconHome = UIImage(named: "icon-home", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let iconPeople = UIImage(named: "icon-people", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let iconSettings = UIImage(named: "icon-settings", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let iconSpeaker = UIImage(named: "icon-speaker", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let leg = UIImage(named: "leg", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let loading = NSDataAsset(name: "loading", bundle: Bundle(for: BundleToken.self))!.data
    internal static let logo = UIImage(named: "logo", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let profilePic = UIImage(named: "profile_pic", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let singleWeight = UIImage(named: "singleWeight", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let timer = UIImage(named: "timer", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let trophy1 = UIImage(named: "trophy1", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let trophy2 = UIImage(named: "trophy2", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
    internal static let trophy3 = UIImage(named: "trophy3", in: Bundle(for: BundleToken.self), compatibleWith: nil)!
  }
}

// MARK: - Implementation Details

private final class BundleToken {}
