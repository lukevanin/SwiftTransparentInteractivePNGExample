import UIKit

extension UIImageView {

    // See: http://stackoverflow.com/questions/27923232/how-to-know-that-if-the-only-visible-area-of-a-png-is-touched-in-xcode-swift-o?rq=1
    func alphaAtPoint(point: CGPoint) -> CGFloat {

        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let alphaInfo = CGImageAlphaInfo.PremultipliedLast.rawValue

        guard let context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, alphaInfo) else {
            return 0
        }

        CGContextTranslateCTM(context, -point.x, -point.y);

        layer.renderInContext(context)

        let floatAlpha = CGFloat(pixel[3])

        return floatAlpha
    }

}

class ViewController: UIViewController {

    @IBOutlet var images: [UIImageView]!

    @IBAction internal func tapGestureHandler(gesture: UITapGestureRecognizer) {

        let sorted = images.sort() { a, b in
            return a.layer.zPosition < b.layer.zPosition
        }

        for (i, image) in sorted.enumerate() {

            let location = gesture.locationInView(image)
            let alpha = image.alphaAtPoint(location)

            if alpha > 50.0 {

                print("selected image #\(i) \(image.layer.zPosition)")
                view.addSubview(image)
                
                return
            }
        }
    }
}