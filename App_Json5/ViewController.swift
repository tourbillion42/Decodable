//
//  ViewController.swift
//  App_Json5
//
//  Created by Hwang on 21/04/2019.
//  Copyright © 2019 Hwang. All rights reserved.
//

import UIKit

struct Course : Decodable {
    
    let id : Int
    let name : String
    let imageUrl : String
    let number_of_lessons : Int
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCouresJSON { (res) in
            
            switch res {
            case .success(let courses):
                courses.forEach({ (course) in
                    print(course.name)
                    print(course.id)
                })
            case .failure(let err):
                print("Failed to fetch course:",err)
            }
        }
    }
    
    fileprivate func fetchCouresJSON(completion : @escaping (Result<[Course], Error>) -> ()) {
        
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
        
        guard let url = URL(string: urlString)  else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {(data, resp, err) in
            
            if let err = err {
                completion(.failure(err))
                return
            }
            
            // successful
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(.success(courses))
                
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }

}

