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
    
    private lazy var skipBarButtonItem = UIBarButtonItem(title: "スキップ", style: .plain, target: nil, action: nil).then {
        $0.tintColor = ColorCodes.primaryPurple.color()
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private lazy var pages: [UIViewController] = {
        return [
            AppOverviewPageController(),
            SelectLocationPageViewController(),
            ConfirmLocationInfoPageViewController(),
            DepartPageViewController(),
            StudyStartPageViewController(),
            StudyMidwayFinishPageController(),
            StudyFinishPageController(),
            AppStartPageController()
        ]
    }()
    
    private lazy var pageControl = UIPageControl().then {
        $0.numberOfPages = pages.count
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = ColorCodes.primaryPurple.color()
        $0.isEnabled = false
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = skipBarButtonItem

        setupUI()
        setupPageViewController()
        bind()
    }
}

extension WalkThroughViewController {
    
    private func setupUI() {
        view.backgroundColor = ColorCodes.primaryLightPurple.color()
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        view.addSubview(pageControl)
        
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
    }
    
    private func bind() {
        let appStartPageController = pages.last as! AppStartPageController
        Observable.merge(
            skipBarButtonItem.rx.tap.asObservable(),
            appStartPageController.startAppButton.rx.tap.asObservable()
        )
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            Router.dismissModal(vc: self)
        })
        .disposed(by: disposeBag)
    }
    
    // 最後のページはスキップボタンを非表示
    private func updateSkipButtonVisibility(for index: Int) {
        navigationItem.rightBarButtonItem?.isHidden = (index == pages.count - 1)
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
            updateSkipButtonVisibility(for: index)
        }
    }
}

extension WalkThroughViewController {
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

