//
//  ViewController.swift
//  Project27
//
//  Created by Yakup Aybars Bal on 15.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerBoard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
          
        case 6:
            drawFace()
            
        case 7:
            drawTwin()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        imageView.image = img
    }
    
    //challenge1
    func drawFace() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
            let leftEye = CGRect(x: 155, y: 100, width: 60, height: 85)
            let rightEye = CGRect(x: 285, y: 100, width: 60, height: 85)
            let mouth = CGRect(x: 195, y: 275, width: 120, height: 150)
            
            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addEllipse(in: mouth)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    // challenge2
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 20, y: 100)
            ctx.cgContext.setLineCap(.round)
            ctx.cgContext.setLineWidth(5)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            //Draw T
            ctx.cgContext.move(to: CGPoint(x: 60, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 130, y: 5))
            ctx.cgContext.move(to: CGPoint(x: 95, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 95, y: 5))
            
            //Draw W
            ctx.cgContext.move(to: CGPoint(x: 145, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 162, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 162, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 177, y: 5))
            ctx.cgContext.move(to: CGPoint(x: 177, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 192, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 192, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 207, y: 5))
            
            //Draw I
            ctx.cgContext.move(to: CGPoint(x: 222, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 272, y: 5))
            ctx.cgContext.move(to: CGPoint(x: 247, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 247, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 222, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 272, y: 70))
            
            //Draw N
            ctx.cgContext.move(to: CGPoint(x: 287, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 287, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 287, y: 5))
            ctx.cgContext.addLine(to: CGPoint(x: 337, y: 70))
            ctx.cgContext.move(to: CGPoint(x: 337, y: 70))
            ctx.cgContext.addLine(to: CGPoint(x: 337, y: 5))
            
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
}

