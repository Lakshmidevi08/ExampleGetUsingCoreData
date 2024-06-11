//
//  ListViewModel.swift
//  demo
//
//  Created by MAC on 06/06/24.
//

import Foundation
import CoreData


class ListViewModel{
    var listArray : [ListModel] = []
    var onUsersUpdated: (() -> ())?
    
    func getContext () -> NSManagedObjectContext {
        return AppDelegate.sharedInstance.persistentContainer.viewContext
    }
    
    func fetchDataFromGetAPI(){
        let apiUrl = "https://gorest.co.in/public/v2/users" // Replace with your actual API URL
        
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check for response and data
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            // Parse the response data
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] {
                    //                    self?.listArray = json.map { userDict in
                    //                        return ListModel(id: userDict["id"] as? Int64 ?? 0,
                    //                                    name: userDict["name"] as? String ?? "",
                    //                                    email: userDict["email"] as? String ?? "",
                    //                                    gender: userDict["gender"] as? String ?? "",
                    //                                    status: userDict["status"] as? String ?? "")
                    //                    }
                    
                    //self?.onUsersUpdated?()
                    self?.saveUsersToCoreData(userDictionaries: json)
                    
                    let decoder = JSONDecoder()
                    let des = try decoder.decode([ListModell].self, from: data)
                    print(des)
                   
                }
            } catch let parseError {
                print("JSON Parsing Error: \(parseError.localizedDescription)")
            }
        }
        // Start the task
        task.resume()
    }
   
    func saveCoreDatabase(data: [ListModell]){
        let context = getContext()
        //let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        for dict in data{
            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
                fatalError("Failed to find entity description for User")
            }
            let user = NSManagedObject(entity: entity, insertInto: context)
         
            user.setValue(dict.id, forKey: "id")
            user.setValue(dict.name, forKey: "name")
            user.setValue(dict.email, forKey: "email")
            user.setValue(dict.gender, forKey: "gender")
            user.setValue(dict.status, forKey: "status")
            user.setValue(false, forKey: "isFav")
        }
        do {
            try context.save()
            fetchUsersFromCoreData()
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }
    
    func fetchCoreDatabase(){
        let context = getContext()
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        
    }
    /*
     func fetchUsers() -> [ListModel] {
         let context = getContext()
         let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
         
         do {
             let results = try context.fetch(fetchRequest)
             return results.map { ListModel(id: Int($0.id), name: $0.name ?? "") }
         } catch {
             print("Failed to fetch users: \(error.localizedDescription)")
             return []
         }
     }

     */
    
    func saveUsersToCoreData(userDictionaries: [NSDictionary]) {
        let context = getContext()
        
        // Clear existing data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete existing users: \(error.localizedDescription)")
        }
        
        for dict in userDictionaries {
            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
                fatalError("Failed to find entity description for User")
            }
            
            let user = NSManagedObject(entity: entity, insertInto: context)
            
            user.setValue(dict["id"], forKey: "id")
            user.setValue(dict["name"], forKey: "name")
            user.setValue(dict["email"], forKey: "email")
            user.setValue(dict["gender"], forKey: "gender")
            user.setValue(dict["status"], forKey: "status")
            user.setValue(false, forKey: "isFav")
        }
        
        do {
            try context.save()
            fetchUsersFromCoreData()
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }
    
    func fetchUsersFromCoreData() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let fetchedUsers = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            //using for loop
            //            for data in fetchedUsers as? [NSManagedObject] ?? []{
            //                if let id = data.value(forKey: "id") as? Int64,
            //                   let name = data.value(forKey: "name") as? String,
            //                   let email = data.value(forKey: "email") as? String,
            //                   let gender = data.value(forKey: "gender") as? String,
            //                   let status = data.value(forKey: "status") as? String{
            //                    let data = ListModel(id: id, name: name, email: email, gender: gender,status: status)
            //                    listArray.append(data)
            //                }
            //            }
            
            //using map
            self.listArray = fetchedUsers.map({ fetchedArr in
                return ListModel(id: fetchedArr.value(forKey: "id") as? Int64 ?? 0,
                                 name: fetchedArr.value(forKey: "name") as? String ?? "",
                                 email: fetchedArr.value(forKey: "email") as? String ?? "",
                                 gender: fetchedArr.value(forKey: "gender") as? String ?? "",
                                 status: fetchedArr.value(forKey: "status") as? String ?? "",
                                 isFav: fetchedArr.value(forKey: "isFav") as? Bool ?? false)
            })
            onUsersUpdated?()
            
        } catch {
            print("Failed to fetch users from Core Data: \(error.localizedDescription)")
        }
    }
    
    func updateUserCoreData(id: Int64? = nil){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        if let idValue = id{
            fetchRequest.predicate = NSPredicate(format: "id = %lld", idValue)
        }
        
        do{
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.count > 0 {
                let objectUpdate = fetchResult[0] as! NSManagedObject
                let currentValue = objectUpdate.value(forKey: "isFav") as? Bool ?? false
                objectUpdate.setValue(!currentValue, forKey: "isFav")
            }
            do{
                try context.save()
                fetchUsersFromCoreData()
            }
            catch{
                print(error)
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func sortFavListArray(){
        listArray = listArray.filter({ $0.isFav ?? false
        })
        self.onUsersUpdated?()
    }
}


