/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import MapKit
import Commons

private let FuberHeadquartersCoordinate = CLLocationCoordinate2D(latitude: 37.775447, longitude: -122.418222)

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var containerBarButtonItem: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let region = MKCoordinateRegion(center: FuberHeadquartersCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    mapView.setRegion(region, animated: true)
    containerBarButtonItem.width = CGRectGetWidth(view.bounds)
    
  }
  
  
  @IBAction func riderSelectionDidFinishDraggingInsideSlider(sender: UISlider) {
    updateSlider(sender)
  }
  
  @IBAction func riderSelectionDidFinishDraggingOutside(sender: UISlider) {
    updateSlider(sender)
  }
  
  func updateSlider(slider: UISlider) {
    if slider.value >= 0.5 {
      slider.setValue(1.0, animated: true)
    } else {
      slider.setValue(0.0, animated: true)
    }
  }
  
  
}



