//
//  ViewController.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import UIKit
import PromiseKit

final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  // MARK: - Button actions
  @IBAction func fetchUserButtonClicked(button: UIButton) {
    FetchUser().perform().then(execute: { user -> Void in
      print(user)
    }).catch(execute: { e in
      print(e)
    })
  }
  
  @IBAction func fetchUserShowingJSONButtonClicked(button: UIButton) {
    FetchUserShowingJSON().perform().then(execute: { user -> Void in
      print(user)
    }).catch(execute: { e in
      print(e)
    })
  }
  
  @IBAction func makeReqeustThenIgnoreButtonClicked(button: UIButton) {
    MakeRequestThenIgnoreResult().perform().then(execute: { () -> Void in
      print("Done")
    }).catch(execute: { e in
      print(e)
    })
  }
  
  @IBAction func fetch5UsersButtonClicked(button: UIButton) {
    Fetch5Users().perform().then(execute: { users -> Void in
      print(users)
    }).catch(execute: { e in
      print(e)
    })
  }
  
  @IBAction func pagingRequestClicked(button: UIButton) {
    PagingRequest().makeRequest(forPage: 1).then(execute: {(users, nextPage) -> Void in
      print("user count \(users.count)")
      print("next page \(nextPage)")
    }).catch(execute: { e in
      print(e)
    })
  }
  
  @IBAction func multipartClicked(button: UIButton) {
    MultipartUpload().perform().then(execute: { r -> Void in
      print(r)
    }).catch(execute: { e in
      print(e)
    })
  }

}

