//
//  Ranking.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 04/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import Foundation


struct Ranking: RankingManageLogic, RankingDataLogic{
    
    private(set) var division: DivisionType;
    private(set) var users: [User];
    
    func fetch(){}
    
    init(){
        users = []
        division = .Gerente
    }
    
    mutating func sortRankingByScore(){
        users.sort { (lhs, rhs) -> Bool in
            return lhs.score > rhs.score
        }
    }
    mutating func insertionSort() {
        for x in 1..<users.count {
            var y = x
            while y > 0 && users[y].score < users[y - 1].score {
                users.swapAt(y - 1, y)
                y -= 1
            }
        }
    }    
    mutating func selectionSort() {
        guard users.count > 1 else {return}
        for x in 0 ..< users.count - 1 {     // 3
            var lowest = x
            for y in x + 1 ..< users.count {   // 4
                if users[y].score < users[lowest].score {
                    lowest = y
                }
            }
            if x != lowest {               // 5
                users.swapAt(x, lowest)
            }
        }
    }
    mutating func quicksort() {
        guard users.count > 1 else {return}
        
        let pivot = users[users.count/2]
        let less = users.filter { $0 < pivot }
        let equal = users.filter { $0 == pivot }
        let greater = users.filter { $0 > pivot }
        
        // Pode fazer a funcao retornar o array ordenado -> Sujeito a alterações
        // Igual na array de baixo
        users.removeAll()
        users.append(contentsOf: less)
        users.append(contentsOf: equal)
        users.append(contentsOf: greater)
    }
    public func mergeSort(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }    // 1
        
        let middleIndex = array.count / 2              // 2
        
        let leftArray = mergeSort(Array(array[0..<middleIndex]))             // 3
        
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]))  // 4
        
        return merge(leftPile: leftArray, rightPile: rightArray)             // 5
    }    
    public func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
      // 1
      var leftIndex = 0
      var rightIndex = 0

      // 2
      var orderedPile = [Int]()
      orderedPile.reserveCapacity(leftPile.count + rightPile.count)

      // 3
      while leftIndex < leftPile.count && rightIndex < rightPile.count {
        if leftPile[leftIndex] < rightPile[rightIndex] {
          orderedPile.append(leftPile[leftIndex])
          leftIndex += 1
        } else if leftPile[leftIndex] > rightPile[rightIndex] {
          orderedPile.append(rightPile[rightIndex])
          rightIndex += 1
        } else {
          orderedPile.append(leftPile[leftIndex])
          leftIndex += 1
          orderedPile.append(rightPile[rightIndex])
          rightIndex += 1
        }
      }

      // 4
      while leftIndex < leftPile.count {
        orderedPile.append(leftPile[leftIndex])
        leftIndex += 1
      }

      while rightIndex < rightPile.count {
        orderedPile.append(rightPile[rightIndex])
        rightIndex += 1
      }

      return orderedPile
    }
    
    
    
    
    
}
