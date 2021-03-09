//
//  ViewController.swift
//
//
//  Created by Sébastien Pécoul on 08/03/2021.
//

import UIKit

enum ScrollDirection {
  case left
  case right
}

/// Possible implementation of infinite scroll
class ViewController: UIViewController {
  
  var squares = [UIView]()
  let itemCount: Int = 10
  
  
  let itemMargin: CGFloat = 16.0
  let itemWidth: CGFloat = 240
  let itemHeight: CGFloat = 200
  
  var scrollDirection: ScrollDirection = .right
  var scrollView: FocusableScrollView!
  var lastScrollPosition: CGPoint = .zero {
    willSet {
      scrollDirection = newValue.x >= lastScrollPosition.x ? .right : .left
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    setupLayout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // place scrollView at middle to allow user to scroll in both direction directly
    scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width * 0.5, y: 0)
    generateFrames()
  }
  
  override var preferredFocusEnvironments: [UIFocusEnvironment] {
    return [squares.first!]
  }
  
  
  // MARK: Layout
  
  private func setupLayout() {
    
    view.backgroundColor = .white
    
    scrollView = FocusableScrollView()
    scrollView.backgroundColor = .gray
    scrollView.delegate = self
    view.addSubview(scrollView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 240.0).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 240.0).isActive = true
    scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200.0).isActive = true
    scrollView.heightAnchor.constraint(equalToConstant: itemHeight + 32.0).isActive = true
    
    
    let contentView = UIView()
    scrollView.addSubview(contentView)
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
 
    // huge value (i found no other solution :() to simulat an infinite scroll
    // unlike collectionView with huge amount of element this huge value doesn't have an impact on performance
    contentView.widthAnchor.constraint(equalToConstant: 999_999).isActive = true
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    
    
    for i in 0..<itemCount {
      let square = makeSquareView(with: .blue)
      contentView.addSubview(square)
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight))
      label.text = "\(i + 1)"
      square.addSubview(label)
     
   
      squares.append(square)
    }
    
    generateFrames()
  }
  
  private func generateFrames() {
    for i in 0..<itemCount {
      let offset = i == 0 ? scrollView.contentOffset.x + itemMargin : squares[i - 1].center.x
      let center = i == 0 ? offset + itemWidth * 0.5 : offset + itemWidth + itemMargin
      squares[i].center = CGPoint(x: center, y: 25)
    }
  }
  
  private func makeSquareView(with color: UIColor) -> FocusableView {
    let squareView = FocusableView()
    squareView.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemHeight)
    squareView.backgroundColor = color
    return squareView
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    squares.forEach { $0.backgroundColor = .blue }
    (context.nextFocusedItem as? UIView)?.backgroundColor = .black
  }
  
}

extension ViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    
    debugPrint("Scroll Direction :\(scrollView.contentOffset)")
    
    if scrollView.contentOffset.y < 0 { return }
    lastScrollPosition = scrollView.contentOffset
    
    guard !squares.isEmpty else { return }
    
    switch scrollDirection {
    case .left:
     handleScrollLeft(scrollView: scrollView)
    case .right:
      handleScrollRight(scrollView: scrollView)
    }
  }
  
  /// When scrolling left
  /// if needed place square before the previous item to already have visible square when scrolling to left
  func handleScrollLeft(scrollView: UIScrollView) {
    let treshold: CGFloat = 400
    for i in 0..<itemCount {
      if abs(squares[i].center.x - scrollView.bounds.origin.x) < treshold  {
        let previousSquare = squares[i == 0 ? itemCount - 1 : i - 1]
        previousSquare.center = CGPoint(x: squares[i].center.x - itemWidth - itemMargin, y: 25)
      }
    }
  }
  
  /// When scrolling right
  /// if needed place square after the previous item to already have visible square when scrolling to right
  func handleScrollRight(scrollView: UIScrollView) {
    for i in 0..<itemCount {
      if !(squares[i].frame.intersects(scrollView.bounds) && squares[i].center.x <= squares[i < itemCount - 1 ? i + 1 : 0].center.x) {
        squares[i].center = CGPoint(x: squares[(i == 0 ? itemCount - 1: i - 1)].center.x + itemWidth + itemMargin, y: 25)
      }
    }
  }
  
}


/// Override to enable focus
class FocusableScrollView: UIScrollView {
  override var canBecomeFocused: Bool { false }
}

/// Override to enable focus
class FocusableView: UIView {
  override var canBecomeFocused: Bool { true }
}
