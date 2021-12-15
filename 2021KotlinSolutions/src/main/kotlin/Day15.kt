import java.awt.Point
import java.io.File
import java.util.*

object Day15 {
    val inputLines = File("/Users/calebjw/Documents/Developer/Personal/AOC/AOC2021/Inputs/Day15Input.txt").readLines()
    val tileWidth = inputLines.size

    fun part1() {
        solution(::parseInput)
    }

    fun part2() {
        solution(::part2LargerMap)
    }

    fun solution(mapGenerator: () -> Map<Point, Int>) {
        println(
            optimalPaths(
                mapGenerator()
            ).values.last()
        )
    }

    fun optimalPaths(map: Map<Point, Int>): Map<Point, Int> {
        val origin = Point(0, 0)
        val pointsToVisit: Queue<Point> = LinkedList(listOf(origin))
        val shortestDistance = mutableMapOf<Point, Int>(
            origin to 0
        )

        while (pointsToVisit.isNotEmpty()) {
            val current = pointsToVisit.remove()
            val amountToCurrent = shortestDistance[current]!!

            current.neighbours().filter { map[it] != null }.sortedBy { map[it] }.forEach {
                val new = amountToCurrent + map[it]!!

                if (shortestDistance[it] == null || shortestDistance[it]!! > new) {
                    shortestDistance[it] = new
                    pointsToVisit.add(it)
                }
            }
        }

        return shortestDistance
    }

    fun part2LargerMap(): Map<Point, Int> {
        val result = mutableMapOf<Point, Int>()

        inputLines.forEachIndexed { y, line ->
            line.forEachIndexed { x, n ->
                val initialValue = n.toString().toInt()

                (0 until 5).forEach { tileX ->
                    (0 until 5).forEach { tileY ->
                        result[Point(x + tileX*tileWidth, y + tileY*tileWidth)] = (initialValue + tileX + tileY).risk()
                    }
                }
            }
        }

        return result
    }

    fun Int.risk(): Int = if (this > 9) (this % 9) else this

    fun parseInput(): Map<Point, Int> {
        val result = mutableMapOf<Point, Int>()

        inputLines.forEachIndexed { y, line ->
            line.forEachIndexed { x, n ->
                result[Point(x, y)] = n.toString().toInt()
            }
        }

        return result
    }

    private fun Point.neighbours(): List<Point> = listOf(
        Point(x, y + 1),
        Point(x, y - 1),
        Point(x + 1, y),
        Point(x - 1, y)
    )
}