import Flutter
import UIKit
import AppLovinSDK

class ALMAXBannerFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return ALMAXBannerView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class ALMAXBannerView: NSObject, FlutterPlatformView, MAAdViewAdDelegate {
    private var _view: UIView
    private var adView: MAAdView!
    private var _args: Any?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        _args = args

        super.init()
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView) {
         if let actualArgs = _args as? Dictionary<String, Any>, let unitId = actualArgs["UnitId"] as? String {
            adView = MAAdView(adUnitIdentifier: unitId)
            adView.delegate = self
        
            let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50
            let width: CGFloat = UIScreen.main.bounds.width
            adView.frame = CGRect(x: -(UIScreen.main.bounds.width / 2), y: 0, width: width, height: height)
        
            _view.addSubview(adView)
        
            adView.loadAd()

            adView.isHidden = false
            adView.startAutoRefresh()
         }
    }

    func didLoad(_ ad: MAAd){
        globalMethodChannel?.invokeMethod("AdLoaded", arguments: nil)
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {}

    func didClick(_ ad: MAAd) {
        globalMethodChannel?.invokeMethod("AdClicked", arguments: nil)
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {}

    func didExpand(_ ad: MAAd) {}

    func didCollapse(_ ad: MAAd) {}

    func didDisplay(_ ad: MAAd) {
        globalMethodChannel?.invokeMethod("AdDisplayed", arguments: nil)
    }
    
    func didHide(_ ad: MAAd) {
        globalMethodChannel?.invokeMethod("AdHidden", arguments: nil)
    }
}
