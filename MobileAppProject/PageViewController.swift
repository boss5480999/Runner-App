//
//  PageViewController.swift
//  MobileApp
//
//  Created by Nutchanon Anurakboonying on 11/29/2558 BE.
//  Copyright © 2558 Nutchanon Anurakboonying. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("page1")
        let page2: UIViewController! = storyboard?.instantiateViewControllerWithIdentifier("page2")
        
        pages.append(page1)
        pages.append(page2)
        
        setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.indexOf(viewController)!
        
        let previousIndex = abs((currentIndex - 1) % pages.count)
        
        return pages[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = pages.indexOf(viewController)!
        
        let nextIndex = abs((currentIndex + 1) % pages.count)
        
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
