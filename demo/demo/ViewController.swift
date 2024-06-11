//
//  ViewController.swift
//  demo
//
//  Created by MAC on 06/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var sortView: UIImageView!
    
    
    var listViewModel =  ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortView.isUserInteractionEnabled = true
        self.setupTableView()
        self.reloadClosures()
        self.tapGestures()
        listViewModel.fetchDataFromGetAPI()
    }
    
    func setupTableView(){
        self.listTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.listTableView.delegate = self
        self.listTableView.dataSource = self        
    }
    
    func reloadClosures(){
        listViewModel.onUsersUpdated = { [weak self] in
 
            DispatchQueue.main.async{
                self?.listTableView.reloadData()
            }
        }
    }
    
    func tapGestures(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSort))
        self.sortView.addGestureRecognizer(tapGesture)
    }
    
    // Function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapSort(){
        self.listViewModel.sortFavListArray()
    
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listViewModel.listArray.count)
        return listViewModel.listArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let val = listViewModel.listArray[indexPath.row]
        cell.titleLbl.text = listViewModel.listArray[indexPath.row].name
        cell.subtileLbl.text = listViewModel.listArray[indexPath.row].email
        cell.imgView.image = listViewModel.listArray[indexPath.row].gender == "male" ? UIImage(named: "male") : UIImage(named: "female")
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(didTapFavBtn(sender:)), for: .touchUpInside)
        
        cell.favBtn.setImage(UIImage(named: val.isFav == false ? "unfav" : "fav"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func didTapFavBtn(sender: UIButton){
        
        if listViewModel.listArray[sender.tag].status == "active"{
            self.listViewModel.updateUserCoreData(id: listViewModel.listArray[sender.tag].id)
            self.listTableView.reloadData()
        }else{
            self.showAlert(message: "Inactive users can't add favourite")
        }
    }
}


