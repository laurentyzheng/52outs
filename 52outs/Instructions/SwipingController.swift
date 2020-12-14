//
//  SwipingController.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-12-06.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

extension UIColor {
    static var mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
}

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages = [
        Page(imageName: "Method", headerText: "Join Our 52outs Facebook Support Group!", bodyText: "The effect: After asking the spectator for a freely thought of card, the magician makes a folded card appear on the phone. Opening it reveals that exact card.", headerHasURL: true),
        Page(imageName: "instruction2", headerText: "Choosing The Suit", bodyText: "The screen is divided by the four suits. Tapping either four sections decides the suit and allows the folded card to appear. \n Tilting the phone and keeping the card at a corner will initiate the specfied suit change. The phone will vibrate to confirm that the change has taken place.(The suit arrangement is customizable in Settings)", headerHasURL: false),
        Page(imageName: "instruction3", headerText: "The First Unfold", bodyText: "An octaldecimal system decides the value of the card. The first unfold sets a value between 0 and 7, this number is the right-most digit of our final card value. \n eg. Swiping from the upper-left corner to the lower-left corner sets up a value of 4. Swiping from the lower-right to the upper-right sets up a value of 7. etc.", headerHasURL: false),
        Page(imageName: "instruction4", headerText: "Example", bodyText: "Placing the finger in either corner moves the card to the corner. From there, swipe either horizontally(for a value between 0 and 3), or vertically(for a value between 4 and 7). \n If the named card has a value greater than 8, subtract it by 8 and that will give you a number between 0 and 7.", headerHasURL: false),
        Page(imageName: "instruction5", headerText: "The Second Unfold", bodyText: "The second unfold decides the next digit of our octaldecimal value(0 or 1, where 0 means we add 0 to our inital value, and 1 means we add 8). \n A clockwise system shows which section to swipe on. the first section of card in a clockwise direction inidicates a +0, and the second indicates a +8.", headerHasURL: false),
        Page(imageName: "instruction6", headerText: "Maping The Values", bodyText: "The two swipes gives us a total of 16 different options(0 to 15). \n For example, if the named card was a queen, which has a value of 12, we would swipe from the top-left to the bottom-left for an initial value of 4, then from the top-left to the top-right for a +8. (4+8 = 12)", headerHasURL: false),
        Page(imageName: "instruction7", headerText: "Ending The Trick", bodyText: "Pinching the card allows the card to dissappear. Alternatively, you could swipe the card off of the phone while holding a real card behind the phone. This will seems as if the card was pulled out of the phone. Once the card is no longer on screen, the trick resets.", headerHasURL: false),
        Page(imageName: "instruction1", headerText: "Exit", bodyText: "To exit, swipe down with three(or more) fingers once no card is on screen. The app exits automatically when the phone sleeps.\n Suggested set-up: If you choose to use the black screen as the background, simply turn off the phone to end clean. If you choose to use your own background, select \"Exit app when trick ends\" in Settings.", headerHasURL: false)
    ]

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton(frame: CGRect(x: vc.ScreenHalfW() * 1.7, y: vc.ScreenHalfH() * 0.1, width: vc.ScreenHalfW() * 0.1, height: vc.ScreenHalfW() * 0.1))
        button.setImage(UIImage(named: "x"), for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchDown)
        return button
    }()
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleDone() {
        self.modalTransitionStyle = .coverVertical
        self.dismiss(animated: true, completion: nil)
    }
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(exitButton)
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBottomControls()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == pages.count - 1 {
            nextButton.setTitle("DONE", for: .normal)
            nextButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        } else {
            nextButton.removeTarget(self, action: #selector(handleDone), for: .allEvents)
            nextButton.setTitle("NEXT", for: .normal)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
