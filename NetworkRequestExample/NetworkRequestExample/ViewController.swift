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
    FetchUser().perform().done({ user -> Void in
      print(user)
    }).catch({ e in
      print(e)
    })
  }

  @IBAction func fetchUserShowingJSONButtonClicked(button: UIButton) {
    FetchUserShowingJSON().perform().done({ user -> Void in
      print(user)
    }).catch({ e in
      print(e)
    })
  }

  @IBAction func makeReqeustThenIgnoreButtonClicked(button: UIButton) {
    MakeRequestThenIgnoreResult().perform().done({ () -> Void in
      print("Done")
    }).catch({ e in
      print(e)
    })
  }

  @IBAction func fetch5UsersButtonClicked(button: UIButton) {
    Fetch5Users().perform().done({ users -> Void in
      print(users)
    }).catch({ e in
      print(e)
    })
  }

  @IBAction func pagingRequestClicked(button: UIButton) {
    PagingRequest().makeRequest(forPage: 1).done({(users, nextPage) -> Void in
      print("user count \(users.count)")
      print("next page \(nextPage)")
    }).catch({ e in
      print(e)
    })
  }

  @IBAction func multipartClicked(button: UIButton) {
    MultipartUpload().perform().done({ r -> Void in
      print(r)
    }).catch({ e in
      print(e)
    })
  }

  @IBAction func codableExmapleButtonClicked(button: UIButton) {
    FetchEmployee().perform().done({ r -> Void in
      print(r)
    }).catch({ e in
      print(e)
    })
  }

}

