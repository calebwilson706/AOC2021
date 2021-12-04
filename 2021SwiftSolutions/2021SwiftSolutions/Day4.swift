//
//  Day4.swift
//  2021SwiftSolutions
//
//  Created by Caleb Wilson on 04/12/2021.
//

import Foundation
import PuzzleBox

class Day4: PuzzleClass {
    let numbersToCallOut  = [46,79,77,45,57,34,44,13,32,88,86,82,91,97,89,1,48,31,18,10,55,74,24,11,80,78,28,37,47,17,21,61,26,85,99,96,23,70,3,54,5,41,50,63,14,64,42,36,95,52,76,68,29,9,98,35,84,83,71,49,73,58,56,66,92,30,51,20,81,69,65,15,6,16,39,43,67,7,59,40,60,4,90,72,22,0,93,94,38,53,87,27,12,2,25,19,8,62,33,75]
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2021/Inputs/Day4Input.txt")
    }
    
    var cards: [BingoCard] {
        inputStringUnparsed!.components(separatedBy: "\n\n").map(BingoCard.init)
    }
    
    func part1() {
        var calledNumbers = Set([46, 79, 77, 45])
        var currentIndex = 3
        
        while !cardIsCompleted(calledNumbers: calledNumbers) {
            currentIndex += 1
            calledNumbers.insert(numbersToCallOut[currentIndex])
        }
        
        let card = completedCard(calledNumbers: calledNumbers)!
        let finalNumber = numbersToCallOut[currentIndex]
        
        print(card.allNumbers.subtracting(calledNumbers).reduce(0, +) * finalNumber)
    }
    
    func part2() {
        var calledNumbers = Set([46, 79, 77, 45])
        var currentIndex = 3
        var uncompletedCards = Set<BingoCard>(cards)
        var lastCompleted: BingoCard? = nil
    
        
        while !uncompletedCards.isEmpty {
            currentIndex += 1
            calledNumbers.insert(numbersToCallOut[currentIndex])
            
            uncompletedCards.forEach { card in
                if (card.isCompleted(calledNumbers: calledNumbers)) {
                    uncompletedCards.remove(card)
                    lastCompleted = card
                }
            }
        }
        
        
        let finalNumber = numbersToCallOut[currentIndex]
        
        print(lastCompleted!.allNumbers.subtracting(calledNumbers).reduce(0, +) * finalNumber)
    }
    
    func cardIsCompleted(calledNumbers: Set<Int>) -> Bool {
        completedCard(calledNumbers: calledNumbers) != nil
    }
    
    func completedCard(calledNumbers: Set<Int>) -> BingoCard? {
        cards.first {$0.isCompleted(calledNumbers: calledNumbers)}
    }
    
}


struct BingoCard: Hashable {
    let rows: [Set<Int>]
    let diagonals: [Set<Int>]
    let columns: [Set<Int>]

    init(cardString: String) {
        let rows = cardString.lines
        var rowsResult = [Set<Int>]()
        var columnsResult = [Set<Int>]()
        var diagonal1 = [Int]()
        var diagonal2 = [Int]()
        
        for (index, row) in rows.enumerated() {
            let numbers = row.components(separatedBy: .whitespaces).compactMap { Int($0) }
            
            for (column, number) in numbers.enumerated() {
                let new = Set([number])
                if let x = columnsResult[safe: column] {
                    columnsResult[column] = x.union(new)
                } else {
                    columnsResult.append(new)
                }
            }
            
            rowsResult.append(
                Set(numbers)
            )
            
            diagonal1.append(numbers[index])
            diagonal2.append(numbers[numbers.count - 1 - index])
        }
        
        
        
        self.rows = rowsResult
        self.diagonals = [Set(diagonal1), Set(diagonal2)]
        self.columns = columnsResult
    }
    
    var allNumbers: Set<Int> {
        rows.reduce(Set()){ acc, row in
            acc.union(row)
        }
    }
    
    var lines: [Set<Int>] {
        rows + diagonals + columns
    }
    
    func isCompleted(calledNumbers: Set<Int>) -> Bool {
        lines.contains {row in
            row.isSubset(of: calledNumbers)
        }
    }
}


extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
