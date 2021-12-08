//
//  Day8.swift
//  2021SwiftSolutions
//
//  Created by Caleb Wilson on 08/12/2021.
//

import Foundation
import PuzzleBox

let knownNumbers = [
    1 : 2,
    4 : 4,
    7 : 3,
    8 : 7
]

struct Line {
    let signals: [String]
    let outputs: [String]
    
    var signalsDecoded: [Set<Character> : Int] {
        var result = [Int : Set<Character>]()
        var workingList = signals.map(Set.init)
        
        func solve(n: Int, value: Set<Character>) {
            workingList.removeAll { $0 == value }
            result[n] = Set(value)
        }
        
        knownNumbers.forEach { (key, value) in
            let string = workingList.first { $0.count == value }!
            solve(n: key, value: Set(string))
        }
        
        let top = result[7]!.subtracting(result[1]!).first!
        
        let nine = workingList.first { $0.isSuperset(of: result[4]!) && $0.contains(top) }!
        
        solve(n: 9, value: nine)
        
        let bottomLeft = result[8]!.subtracting(nine).first!
        
        solve(n: 2, value: workingList.first { $0.count == 5 && $0.contains(bottomLeft) }!)
        
        solve(n: 3, value: workingList.first { $0.count == 5 && $0.isSuperset(of: result[1]!) }!)
        
        solve(n: 5, value: workingList.first { $0.count == 5 }!)
        
        solve(n: 0, value: workingList.first { $0.isSuperset(of: result[1]!) }!)
        
        solve(n: 6, value: workingList.first!)
        
        return result.reduce([Set<Character> : Int]()) { acc, entry in
            var working = acc
            working[entry.value] = entry.key
            return working
        }
    }
}

class Day8: PuzzleClass {
    
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2021/Inputs/Day8Input.txt")
    }
    
    func part1() {
        print(
            allOutputNumbers.filter {
                knownNumbers.values.contains($0.count)
            }.count
        )
    }
    
    func part2() {
        print (
            lines.reduce(0) { total, next in
                total + Int(next.outputs.reduce("") { acc, output in
                    acc + "\(next.signalsDecoded[Set(output)]!)"
                })!
            }
        )   
    }
    
    var lines: [Line] {
        inputStringUnparsed!.lines.map {
            let parts = $0.components(separatedBy: " | ").map { part in
                part.words
            }
            
            return Line(signals: parts[0], outputs: parts[1])
        }
    }
    
    var allOutputNumbers: [String] {
        outputNumbers.reduce([], +)
    }
 
    var outputNumbers: [[String]] {
        inputStringUnparsed!.lines.map {
            let outputs = $0.components(separatedBy: " | ")[1]
            return outputs.words
        }
    }
}

extension String {
    var words: [String] {
        self.components(separatedBy: " ")
    }
}
