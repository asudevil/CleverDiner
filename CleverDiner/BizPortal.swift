//
//  BizPortal.swift
//  CleverDiner
//
//  Created by admin on 4/24/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerId = "HeaderId"

class BizPortal: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let tasks: [CellStruct] = {
        let task1 = CellStruct(title: "Create New Deal", imageName: "deal")
        let task5 = CellStruct(title: "Update Deals", imageName: "update")
        let task2 = CellStruct(title: "Update Info", imageName: "businessPortalUpdateButton")
        let task3 = CellStruct(title: "Promotions", imageName: "dealOfDay")
        let task4 = CellStruct(title: "Dashboard", imageName: "dashboard")
        let task6 = CellStruct(title: "Update Payment Info", imageName: "payment")
        
        return [task1,task2,task3,task4,task5,task6]
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(BizPortalCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(BizPortalHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)

        collectionView?.backgroundColor = .white
    
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tasks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BizPortalCell
        
        cell.bizTask = tasks[indexPath.row]
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Task: ", tasks[indexPath.row])
        
        selectTask(taskId: indexPath.row)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2.1, height: 125)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
         let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! BizPortalHeaderCell
        
        header.bizHeader = CellStruct(title: "Business Portal", imageName: "businessPortal")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
    func selectTask(taskId: Int) {
        
        switch taskId {
        case 0:
            print("Task 1 selected")
            let taskController = Task1VC()
            navigationController?.pushViewController(taskController, animated: true)

        case 1:
            print("Task 2 selected")
            let taskController = Task2VC()
            navigationController?.pushViewController(taskController, animated: true)

        default:
            //Temporarily using teask2 for everything!!
            print("Task 2 selected")
            let taskController = Task2VC()
            navigationController?.pushViewController(taskController, animated: true)
        }
    }
}
