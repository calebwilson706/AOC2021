//
//  Day9.swift
//  2021SwiftSolutions
//
//  Created by Caleb Wilson on 09/12/2021.
//

import Foundation
import PuzzleBox

class Day9: PuzzleClass {
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/Personal/AOC/AOC2021/Inputs/Day9Input.txt")
    }
    
    func part1() {
        print(
            getLowPoints(in: parseInput()).reduce(0) { acc, next in
                acc + 1 + next.value
            }
        )
    }
    
    func part2() {
        let map = parseInput()
        let lowPoints = getLowPoints(in: map)
        
        let basins = lowPoints.keys.map {
            continueBasin(point: $0, basinPoints: Set(), map: map)
        }
        
        let basinsLengths = basins.map(\.count).sorted()
        
        print(basinsLengths.dropFirst(basinsLengths.count - 3).reduce(1, *))
    }
    
    func continueBasin(point: Point, basinPoints: Set<Point>, map: [Point : Int]) -> Set<Point> {
        let neighbours = point.neighbours
        var workingBasin = basinPoints
        workingBasin.insert(point)
        
        return neighbours.filter {
            !basinPoints.contains($0) && (map[$0] ?? Int.min) > map[point]! && map[$0] != 9
        }.reduce(workingBasin) { acc, next in
            continueBasin(point: next, basinPoints: acc, map: map)
        }
    }
    
    func getLowPoints(in map: [Point : Int]) -> [Point : Int] {
        map.filter { (point, height) in
            point.neighbours.allSatisfy { (map[$0] ?? Int.max) > height}
        }
    }
    
    func parseInput() -> [Point : Int] {
        let lines = inputStringUnparsed!.lines
        var result = [Point : Int]()
        
        for y in 0 ..< lines.count {
            for x in 0 ..< lines[y].count {
                result[Point(x: x, y: y)] = Int("\(lines[y][x])")
            }
        }
        
        return result
    }
}

extension Point {
    var neighbours: [Point] {
        [up(), down(), left(), right()]
    }
}
