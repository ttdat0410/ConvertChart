
import UIKit

internal class LineDrawingLayer : ScrollableGraphViewDrawingLayer {
    
    private var currentLinePath = UIBezierPath()
    
    private var lineStyle: ScrollableGraphViewLineStyle
    private var shouldFill: Bool
    private var lineCurviness: CGFloat
    
    init(frame: CGRect, lineWidth: CGFloat, lineColor: UIColor, lineStyle: ScrollableGraphViewLineStyle, lineJoin: String, lineCap: String, shouldFill: Bool, lineCurviness: CGFloat) {
        
        self.lineStyle = lineStyle
        self.shouldFill = shouldFill
        self.lineCurviness = lineCurviness
        
        super.init(viewportWidth: frame.size.width, viewportHeight: frame.size.height)
        
        self.lineWidth = lineWidth
        self.strokeColor = lineColor.CGColor
        
        self.lineJoin = lineJoin
        self.lineCap = lineCap
        
        // Setup
        self.fillColor = UIColor.clearColor().CGColor // This is handled by the fill drawing layer.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func createLinePath() -> UIBezierPath {
        
        guard let owner = owner else {
            return UIBezierPath()
        }
        
        // Can't really do anything without the delegate.
        guard let delegate = self.owner?.graphViewDrawingDelegate else {
            return currentLinePath
        }
        
        currentLinePath.removeAllPoints()
        
        let pathSegmentAdder = lineStyle == .straight ? addStraightLineSegment : addCurvedLineSegment
        
        let activePointsInterval = delegate.intervalForActivePoints()
        
        let pointPadding = delegate.paddingForPoints()
        
        let min = delegate.rangeForActivePoints().min
        zeroYPosition = delegate.calculatePosition(atIndex: 0, value: min).y
        
        let viewport = delegate.currentViewport()
        let viewportWidth = viewport.width
        let viewportHeight = viewport.height
        
        // Connect the line to the starting edge if we are filling it.
        if(shouldFill) {
            // Add a line from the base of the graph to the first data point.
            let firstDataPoint = owner.graphPoint(forIndex: activePointsInterval.startIndex)
            
            let viewportLeftZero = CGPoint(x: firstDataPoint.location.x - (pointPadding.leftmostPointPadding), y: zeroYPosition)
            let leftFarEdgeTop = CGPoint(x: firstDataPoint.location.x - (pointPadding.leftmostPointPadding + viewportWidth), y: zeroYPosition)
            let leftFarEdgeBottom = CGPoint(x: firstDataPoint.location.x - (pointPadding.leftmostPointPadding + viewportWidth), y: viewportHeight)
            
            currentLinePath.moveToPoint(leftFarEdgeBottom)//move(to: leftFarEdgeBottom)
            pathSegmentAdder(leftFarEdgeBottom, endPoint: leftFarEdgeTop, inPath: currentLinePath)
            pathSegmentAdder(leftFarEdgeTop, endPoint: viewportLeftZero, inPath: currentLinePath)
            pathSegmentAdder(viewportLeftZero, endPoint: CGPoint(x: firstDataPoint.location.x, y: firstDataPoint.location.y), inPath: currentLinePath)
        }
        else {
            let firstDataPoint = owner.graphPoint(forIndex: activePointsInterval.startIndex)
            currentLinePath.moveToPoint(firstDataPoint.location)//move(to: firstDataPoint.location)
        }
        
        // Connect each point on the graph with a segment.
        for i in activePointsInterval.startIndex ..< activePointsInterval.endIndex - 1 {
            
            let startPoint = owner.graphPoint(forIndex: i).location
            let endPoint = owner.graphPoint(forIndex: i+1).location
            
//            pathSegmentAdder(startPoint, endPoint: endPoint, inPath: currentLinePath)
            pathSegmentAdder(startPoint, endPoint: endPoint, inPath: currentLinePath)
        }
        
        // Connect the line to the ending edge if we are filling it.
        if(shouldFill) {
            // Add a line from the last data point to the base of the graph.
            let lastDataPoint = owner.graphPoint(forIndex: activePointsInterval.endIndex - 1).location
            
            let viewportRightZero = CGPoint(x: lastDataPoint.x + (pointPadding.rightmostPointPadding), y: zeroYPosition)
            let rightFarEdgeTop = CGPoint(x: lastDataPoint.x + (pointPadding.rightmostPointPadding + viewportWidth), y: zeroYPosition)
            let rightFarEdgeBottom = CGPoint(x: lastDataPoint.x + (pointPadding.rightmostPointPadding + viewportWidth), y: viewportHeight)
            
            pathSegmentAdder(lastDataPoint, endPoint: viewportRightZero, inPath: currentLinePath)
            pathSegmentAdder(viewportRightZero, endPoint: rightFarEdgeTop, inPath: currentLinePath)
            pathSegmentAdder(rightFarEdgeTop, endPoint: rightFarEdgeBottom, inPath: currentLinePath)
        }
        
        return currentLinePath
    }
    
    private func addStraightLineSegment(startPoint: CGPoint, endPoint: CGPoint, inPath path: UIBezierPath) {
        path.addLineToPoint(endPoint)
    }
    
    private func addCurvedLineSegment(startPoint: CGPoint, endPoint: CGPoint, inPath path: UIBezierPath) {
        // calculate control points
        let difference = endPoint.x - startPoint.x
        
        var x = startPoint.x + (difference * lineCurviness)
        var y = startPoint.y
        let controlPointOne = CGPoint(x: x, y: y)
        
        x = endPoint.x - (difference * lineCurviness)
        y = endPoint.y
        let controlPointTwo = CGPoint(x: x, y: y)
        
        // add curve from start to end
        currentLinePath.addCurveToPoint(endPoint, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
//        currentLinePath.addCurve(to: endPoint, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
    }
    
    override func updatePath() {
        self.path = createLinePath().CGPath
    }
}
