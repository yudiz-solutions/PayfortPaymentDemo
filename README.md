#  Payfort Payment Gateway

This's a demonstration repo in order to make it easier for others to implement Payfort sdk in your project, all comments and pulls requests are appreciated.

** Bridging File **
```
#import <PayFortSDK/PayFortSDK.h>
#import <CommonCrypto/CommonHMAC.h>
```

** Keys **
```
var merchantId: String {
    switch self {
    case .development:
        return ""
    case .production:
        return ""
    }
}

var accessCode: String {
    switch self {
    case .development:
        return ""
    case .production:
        return ""
    }
}

var shaRequestPhrase: String {
    switch self {
    case .development:
        return ""
    case .production:
        return ""
    }
}
```

If you face an issue regarding like this:
```
Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UITextField setFloatingLabelActiveTextColor:]: unrecognized selector sent to instance 0x103026600'
```
Just Set **-ObjC** in the Other Linker Flags in the Target -> Build Settings Tab 
