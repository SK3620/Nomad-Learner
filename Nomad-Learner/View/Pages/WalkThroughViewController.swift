//
//  WalkThroughViewController.swift
//  Nomad-Learner
//
//  Created by 鈴木 健太 on 2024/11/29.
//

import SnapKit
import Then
import RxSwift
import UIKit

class WalkThroughViewController: UIViewController {
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private lazy var pages: [UIViewController] = {
        return [
            FirstPageViewController(),
            SecondPageViewController(),
            ThirdPageViewController(),
            FourthPageViewController(),
            FifthPageViewController(),
            SixthPageViewController()
        ]
    }()
    
    private lazy var pageControl = UIPageControl().then {
        $0.numberOfPages = pages.count
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPageViewController()
    }
}

extension WalkThroughViewController {

    private func setupUI() {
        view.backgroundColor = .white
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        view.addSubview(pageControl)

        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
    }
}

extension WalkThroughViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
    }
}
