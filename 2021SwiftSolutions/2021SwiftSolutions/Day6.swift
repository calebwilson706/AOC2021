//
//  Day6.swift
//  2021SwiftSolutions
//
//  Created by Caleb Wilson on 06/12/2021.
//

import Foundation

class Day6 {
    let inputNumbers = [2,4,1,5,1,3,1,1,5,2,2,5,4,2,1,2,5,3,2,4,1,3,5,3,1,3,1,3,5,4,1,1,1,1,5,1,2,5,5,5,2,3,4,1,1,1,2,1,4,1,3,2,1,4,3,1,4,1,5,4,5,1,4,1,2,2,3,1,1,1,2,5,1,1,1,2,1,1,2,2,1,4,3,3,1,1,1,2,1,2,5,4,1,4,3,1,5,5,1,3,1,5,1,5,2,4,5,1,2,1,1,5,4,1,1,4,5,3,1,4,5,1,3,2,2,1,1,1,4,5,2,2,5,1,4,5,2,1,1,5,3,1,1,1,3,1,2,3,3,1,4,3,1,2,3,1,4,2,1,2,5,4,2,5,4,1,1,2,1,2,4,3,3,1,1,5,1,1,1,1,1,3,1,4,1,4,1,2,3,5,1,2,5,4,5,4,1,3,1,4,3,1,2,2,2,1,5,1,1,1,3,2,1,3,5,2,1,1,4,4,3,5,3,5,1,4,3,1,3,5,1,3,4,1,2,5,2,1,5,4,3,4,1,3,3,5,1,1,3,5,3,3,4,3,5,5,1,4,1,1,3,5,5,1,5,4,4,1,3,1,1,1,1,3,2,1,2,3,1,5,1,1,1,4,3,1,1,1,1,1,1,1,1,1,2,1,1,2,5,3]
    
    func part1() {
        solution(days: 80)
    }
    
    func part2() {
        solution(days: 256)
    }
    
    func solution(days: Int) {
        var fish = parseInput()
        
        for _ in 0 ..< days {
            fish = fish.keys.reduce([Int:Int]()) { acc, stage in
                acc.transitionFishAtStage(stage, original: fish)
            }
        }
        
        print(fish.values.reduce(0, +))
    }
    
    func parseInput() -> [Int : Int] {
        inputNumbers.reduce([Int : Int]()) { acc, num in
            acc.add(to: num, n: 1)
        }
    }
}

extension Dictionary where Key == Int, Value == Int {
    func transitionFishAtStage(_ stage: Int, original: [Int : Int]) -> [Int : Int] {
        var newFish = self
        let fishAtStage = original[stage]!
        let stagesToAddTo = stage == 0 ? [6, 8] : [stage - 1]
        
        stagesToAddTo.forEach {
            newFish = newFish.add(to: $0, n: fishAtStage)
        }
        
        return newFish
    }
}

extension Dictionary where Value == Int {
    func add(to: Key, n: Value) -> [Key : Value] {
        var copy = self
        let existingCount = self[to] ?? 0
        copy[to] = existingCount + n
        
        return copy
    }
}
