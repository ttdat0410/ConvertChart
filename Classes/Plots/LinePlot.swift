
import UIKit

class LinePlot : Plot {
    
    // Public settings for the LinePlot
    // ################################
    
    /// Specifies how thick the graph of the line is. In points.
    var lineWidth: CGFloat = 2
    
    /// The color of the graph line. UIColor.
    var lineColor: UIColor = UIColor.blackColor()
    
    /// Whether the line is straight or curved.
    var lineStyle_: Int {
        get { return lineStyle.rawValue }
        set {
            if let enumValue = ScrollableGraphViewLineStyle(rawValue: newValue) {
                lineStyle = enumValue
            }
        }
    }
    
    /// Whether or not the line should be rendered using bezier curves are straight lines.
    var lineStyle = ScrollableGraphViewLineStyle.straight
    
    /// How each segment in the line should connect. Takes any of the Core Animation LineJoin values.
    var lineJoin: String = kCALineJoinRound
    
    /// The line caps. Takes any of the Core Animation LineCap values.
    var lineCap: String = kCALineCapRound
    var lineCurviness: CGFloat = 0.5
    
    
    // Fill Settings
    // #############
    
    /// Specifies whether or not the plotted graph should be filled with a colour or gradient.
    var shouldFill: Bool = false
    
    var fillType_: Int {
        get { return fillType.rawValue }
        set {
            if let enumValue = ScrollableGraphViewFillType(rawValue: newValue) {
                fillType = enumValue
            }
        }
    }
    
    /// Specifies whether to fill the graph with a solid colour or gradient.
    var fillType = ScrollableGraphViewFillType.solid
    
    /// If fillType is set to .Solid then this colour will be used to fill the graph.
    var fillColor: UIColor = UIColor.blackColor()
    
    /// If fillType is set to .Gradient then this will be the starting colour for the gradient.
    var fillGradientStartColor: UIColor = UIColor.whiteColor()
    
    /// If fillType is set to .Gradient, then this will be the ending colour for the gradient.
    var fillGradientEndColor: UIColor = UIColor.blackColor()
    
    var fillGradientType_: Int {
        get { return fillGradientType.rawValue }
        set {
            if let enumValue = ScrollableGraphViewGradientType(rawValue: newValue) {
                fillGradientType = enumValue
            }
        }
    }
    
    /// If fillType is set to .Gradient, then this defines whether the gradient is rendered as a linear gradient or radial gradient.
    var fillGradientType = ScrollableGraphViewGradientType.linear
    
    // Private State
    // #############
    
    private var lineLayer: LineDrawingLayer?
    private var fillLayer: FillDrawingLayer?
    private var gradientLayer: GradientDrawingLayer?
    
    init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    override func layers(forViewport viewport: CGRect) -> [ScrollableGraphViewDrawingLayer?] {
        createLayers(viewport)
        return [lineLayer, fillLayer, gradientLayer]
    }
    
    private func createLayers(viewport: CGRect) {
        
        // Create the line drawing layer.
        lineLayer = LineDrawingLayer(frame: viewport, lineWidth: lineWidth, lineColor: lineColor, lineStyle: lineStyle, lineJoin: lineJoin, lineCap: lineCap, shouldFill: shouldFill, lineCurviness: lineCurviness)
        
        // Depending on whether we want to fill with solid or gradient, create the layer accordingly.
        
        // Gradient and Fills
        switch (self.fillType) {
            
        case .solid:
            if(shouldFill) {
                // Setup fill
                fillLayer = FillDrawingLayer(frame: viewport, fillColor: fillColor, lineDrawingLayer: lineLayer!)
            }
            
        case .gradient:
            if(shouldFill) {
                gradientLayer = GradientDrawingLayer(frame: viewport, startColor: fillGradientStartColor, endColor: fillGradientEndColor, gradientType: fillGradientType, lineDrawingLayer: lineLayer!)
            }
        }
        
        lineLayer?.owner = self
        fillLayer?.owner = self
        gradientLayer?.owner = self
    }
}

@objc public enum ScrollableGraphViewLineStyle : Int {
    case straight
    case smooth
}

@objc public enum ScrollableGraphViewFillType : Int {
    case solid
    case gradient
}

@objc public enum ScrollableGraphViewGradientType : Int {
    case linear
    case radial
}
