//
//  Day14.swift
//  2021SwiftSolutions
//
//  Created by Caleb Wilson on 14/12/2021.
//

import Foundation
import PuzzleBox

class Day14: PuzzleClass {
    let initialPolymer: [Character] = ["O","O","V","S","K","S","P","K","P","P","P","N","N","F","F","B","C","N","O","V"]
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/Personal/AOC/AOC2021/Inputs/Day14Input.txt")
    }
    
    func part1() {
        let accumulator = LinkedList<Character>(from: initialPolymer, isSet: false)
        let insertions = parseInput()
        
        for _ in 0 ..< 10 {
            var currentNode = accumulator.first!
            
            while (currentNode.next != nil) {
                let pair = "\(currentNode.value)\(currentNode.next!.value)"
                
                if let insertion = insertions[pair] {
                    let newNode = LinkedListNode(value: insertion)
                    newNode.next = currentNode.next
                    currentNode.next = newNode
                    currentNode = newNode.next!
                }
            }
        }
        
        let result = accumulator.getFrequencyMap()
        
        print(result.valueRange())
    }
    
    func part2() {
        var pairCounts = buildInitialPairCounts()
        let insertions = parseInput()
        
        for _ in 0 ..< 40 {
            var newMap: [String : Int] = [:]
            
            pairCounts.forEach { (pair, count) in
                if let newChar = insertions[pair] {
                    newMap = newMap.add(to: "\(newChar)\(pair[1])", n: count)
                    newMap = newMap.add(to: "\(pair[0])\(newChar)", n: count)
                    pairCounts[pair] = 0
                }
            }
            
            pairCounts = newMap
        }
    
        var result = [Character : Int]()
        
        pairCounts.forEach { (pair, count) in
            result = result.add(to: pair[1], n: count)
        }
        
        print(result.valueRange())
    }
    
    func buildInitialPairCounts() -> [String : Int] {
        var result = [String : Int]()
        
        for index in (0 ..< initialPolymer.count - 1) {
            let pair = "\(initialPolymer[index])\(initialPolymer[index + 1])"
            result = result.add(to: pair, n: 1)
        }
        
        return result
    }
    
    func parseInput() -> [String : Character] {
        inputStringUnparsed!.lines.reduce([String : Character]()) { acc, line in
            let parts = line.components(separatedBy: " -> ")
            var working = acc
            working[parts.first!] = parts.last!.first
            return working
        }
    }
}

extension Dictionary where Value == Int {
    func valueRange() -> Int {
        isEmpty ? 0 : values.max()! - values.min()!
    }
}

extension LinkedList where T: Hashable {
    func getFrequencyMap() -> [T : Int] {
        var currentNode = first
        var result: [T : Int] = [:]
        
        while (currentNode != nil) {
            let value = currentNode!.value
            let existing = result[value] ?? 0
            result[value] = existing + 1
            currentNode = currentNode?.next
        }
        
        return result
    }
}
