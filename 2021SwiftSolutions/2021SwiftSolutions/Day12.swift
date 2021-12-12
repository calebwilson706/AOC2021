//
//  Day12.swift
//  2021SwiftSolutions
//
//  Created by Caleb Wilson on 12/12/2021.
//

import Foundation
import PuzzleBox

class Day12: PuzzleClass {
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/Personal/AOC/AOC2021/Inputs/Day12Input.txt")
    }
    
    func part1() {
        print(countPathsToEnd())
    }
    
    func part2() {
        print(countPathsToEndPart2())
    }
    
    func countPathsToEnd() -> Int {
        var pathsCount = 0
        let neighbours = adjacencyList
        
        func continuePath(currentNode: String, cavesVisited: Set<String>) {
            neighbours[currentNode]?.filter { !cavesVisited.contains($0) || $0.isLargeCave }.forEach {
                if ($0 == "end") {
                    pathsCount += 1
                } else {
                    continuePath(
                        currentNode: $0,
                        cavesVisited: cavesVisited.unionWithOne(element: $0)
                    )
                }
            }
        }
        
        continuePath(currentNode: "start", cavesVisited: Set(["start"]))
        return pathsCount
    }
    
    func countPathsToEndPart2() -> Int {
        var pathsCount = 0
        let neighbours = adjacencyList
        
        func continuePath(currentNode: String, cavesVisited: Set<String>, smallCaveVisitedTwice: String?) {
            neighbours[currentNode]?.forEach {
                if ($0 == "end") {
                    pathsCount += 1
                } else if ($0.isSmallCave && cavesVisited.contains($0)) {
                    if (smallCaveVisitedTwice == nil && !["start", "end"].contains($0)) {
                        continuePath(
                            currentNode: $0,
                            cavesVisited: cavesVisited,
                            smallCaveVisitedTwice: $0
                        )
                    }
                } else {
                    continuePath(
                        currentNode: $0,
                        cavesVisited: cavesVisited.unionWithOne(element: $0),
                        smallCaveVisitedTwice: smallCaveVisitedTwice
                    )
                }
            }
        }
        
        continuePath(currentNode: "start", cavesVisited: Set(["start"]), smallCaveVisitedTwice: nil)
        return pathsCount
    }
    
    var adjacencyList: [String : Set<String>] {
        var result = [String : Set<String>]()
        
        inputStringUnparsed!.lines.forEach {
            let parts = $0.components(separatedBy: "-")
            let start = parts[0]
            let end = parts[1]
            
            result[start] = (result[start] ?? Set()).unionWithOne(element: end)
            result[end] = (result[end] ?? Set()).unionWithOne(element: start)
        }
        
        return result
    }
}

extension String {
    var isSmallCave: Bool {
        first!.isLowercase
    }
    
    var isLargeCave: Bool {
        !isSmallCave
    }
}

extension Set {
    func unionWithOne(element: Element) -> Set<Element> {
        union(Set([element]))
    }
}
