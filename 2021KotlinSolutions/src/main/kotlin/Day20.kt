import java.awt.Point
import java.io.File

object Day20 {
    private val input = File("/Users/calebjw/Documents/Developer/AdventOfCode/2021/Inputs/Day20Input.txt").readText()
    private val parts = input.split("\n\n")
    private val algorithm = parts[0]
    private val inputImageLines = parts[1].lines()

    fun part1() {
        solution(2)
    }

    fun part2() {
        solution(50)
    }

    private fun solution(n: Int) {
        val algorithm = getAlgorithm()
        var image = getInitialImage()
        var range = PointRange.buildFromImage(image)

        (1..n).forEach {
            val newImage = mutableMapOf<Point, Boolean>()
            range = range.enlarge()

            range.forEach { point ->
                newImage[point] = point.isLight(image, algorithm, it % 2 == 0)
            }

            image = newImage
        }

        println(image.filter { it.value }.size)
    }

    private fun Point.isLight(
        image: Map<Point, Boolean>,
        algorithm: Set<Int>,
        borderValue: Boolean
    ): Boolean {
        var binary = ""

        loopThroughNeighbours {
            binary += if (
                image[it] ?: borderValue
            )  "1" else "0"
        }

        return algorithm.contains(
            binary.toInt(2)
        )
    }

    private fun getInitialImage(): Map<Point, Boolean> {
        val result = mutableMapOf<Point, Boolean>()

        inputImageLines.forEachIndexed { y, line ->
            line.forEachIndexed { x, value ->
                result[Point(x, -y)] = value.isLight()
            }
        }

        return result
    }

    private fun getAlgorithm(): Set<Int> {
        val result = mutableSetOf<Int>()

        algorithm.forEachIndexed { index, value ->
            if (value.isLight()) {
                result.add(index)
            }
        }

        return result
    }

    private fun Char.isLight() = this == '#'

    private fun Point.loopThroughNeighbours(callback: (Point) -> Unit) {
        (1 downTo -1).forEach { yOffset ->
            (-1 .. 1).forEach { xOffset ->
                callback(
                    Point(this.x + xOffset, this.y + yOffset)
                )
            }
        }
    }

    data class PointRange(val minX: Int, val maxX: Int, val minY: Int, val maxY: Int) {
        companion object {
            fun <T> buildFromImage(image: Map<Point, T>): PointRange {
                val points = image.keys

                return PointRange(
                    points.minOf { it.x },
                    points.maxOf { it.x  },
                    points.minOf { it.y },
                    points.maxOf { it.y }
                )
            }
        }

        fun forEach(callback: (Point) -> Unit) {
            (minX .. maxX).forEach { x ->
                (minY .. maxY).forEach { y ->
                    callback(
                        Point(x, y)
                    )
                }
            }
        }

        fun enlarge(): PointRange {
            return PointRange(minX - 1, maxX + 1, minY - 1, maxY + 1)
        }
    }
}


