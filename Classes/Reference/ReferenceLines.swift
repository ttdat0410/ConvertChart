
import UIKit

// Currently just a simple data structure to hold the settings for the reference lines.
class ReferenceLines {
    
    // Reference Lines
    // ###############
    
    /// Whether or not to show the y-axis reference lines and labels.
    var shouldShowReferenceLines: Bool = true
    /// The colour for the reference lines.
    var referenceLineColor: UIColor = UIColor.blackColor()
    /// The thickness of the reference lines.
    var referenceLineThickness: CGFloat = 0.5
    
    @IBInspectable var referenceLinePosition_: Int {
        get { return referenceLinePosition.rawValue }
        set {
            if let enumValue = ScrollableGraphViewReferenceLinePosition(rawValue: newValue) {
                referenceLinePosition = enumValue
            }
        }
    }
    /// Where the labels should be displayed on the reference lines.
    var referenceLinePosition = ScrollableGraphViewReferenceLinePosition.left
    
    var positionType = ReferenceLinePositioningType.relative
    var relativePositions: [Double] = [0.25, 0.5, 0.75]
    var absolutePositions: [Double] = [25, 50, 75]
    var includeMinMax: Bool = true
    
    /// Whether or not to add labels to the intermediate reference lines.
    var shouldAddLabelsToIntermediateReferenceLines: Bool = true
    /// Whether or not to add units specified by the referenceLineUnits variable to the labels on the intermediate reference lines.
    var shouldAddUnitsToIntermediateReferenceLineLabels: Bool = false
    
    // Reference Line Labels
    // #####################
    
    /// The font to be used for the reference line labels.
    var referenceLineLabelFont = UIFont.systemFontOfSize(8)//systemFont(ofSize: 8)
    /// The colour of the reference line labels.
    var referenceLineLabelColor: UIColor = UIColor.blackColor()
    
    /// Whether or not to show the units on the reference lines.
    var shouldShowReferenceLineUnits: Bool = true
    /// The units that the y-axis is in. This string is used for labels on the reference lines.
    var referenceLineUnits: String?
    /// The number of decimal places that should be shown on the reference line labels.
    var referenceLineNumberOfDecimalPlaces: Int = 0
    /// The NSNumberFormatterStyle that reference lines should use to display
    var referenceLineNumberStyle: NSNumberFormatterStyle = NSNumberFormatterStyle.NoStyle
    
    // Data Point Labels // TODO: Refactor these into their own settings and allow for more label options (positioning)
    // ################################################################################################################
    
    /// Whether or not to show the labels on the x-axis for each point.
    var shouldShowLabels: Bool = true
    /// How far from the "minimum" reference line the data point labels should be rendered.
    var dataPointLabelTopMargin: CGFloat = 10
    /// How far from the bottom of the view the data point labels should be rendered.
    var dataPointLabelBottomMargin: CGFloat = 0
    /// The font for the data point labels.
    var dataPointLabelColor: UIColor = UIColor.blackColor()
    /// The colour for the data point labels.
    var dataPointLabelFont: UIFont? = UIFont.systemFontOfSize(10)//systemFont(ofSize: 10)
    /// Used to force the graph to show every n-th dataPoint label
    var dataPointLabelsSparsity: Int = 1
    
    init() {
        // Need this for external frameworks.
    }
}


@objc public enum ScrollableGraphViewReferenceLinePosition : Int {
    case left
    case right
    case both
}

@objc public enum ReferenceLinePositioningType : Int {
    case relative
    case absolute
}

@objc public enum ScrollableGraphViewReferenceLineType : Int {
    case cover
}
