
import UIKit

class BarPlot : Plot {
    
    // Customisation
    // #############
    
    /// The width of an individual bar on the graph.
    var barWidth: CGFloat = 25;
    /// The actual colour of the bar.
    var barColor: UIColor = UIColor.grayColor()
    /// The width of the outline of the bar
    var barLineWidth: CGFloat = 1
    /// The colour of the bar outline
    var barLineColor: UIColor = UIColor.darkGrayColor()
    /// Whether the bars should be drawn with rounded corners
    var shouldRoundBarCorners: Bool = false
    
    // Private State
    // #############
    
    private var barLayer: BarDrawingLayer?
    
    init(identifier: String) {
        super.init()
        self.identifier = identifier
    }
    
    override func layers(forViewport viewport: CGRect) -> [ScrollableGraphViewDrawingLayer?] {
        createLayers(viewport)
        return [barLayer]
    }
    
    private func createLayers(viewport: CGRect) {
        barLayer = BarDrawingLayer(
            frame: viewport,
            barWidth: barWidth,
            barColor: barColor,
            barLineWidth: barLineWidth,
            barLineColor: barLineColor,
            shouldRoundCorners: shouldRoundBarCorners)

        barLayer?.owner = self
    }
}
