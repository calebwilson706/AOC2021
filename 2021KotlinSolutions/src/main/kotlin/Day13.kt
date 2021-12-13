import java.awt.Point
import java.io.File

object Day13 {
    data class Fold(val axis: Char, val n: Int)

    val input = File("/Users/calebjw/Documents/Developer/Personal/AOC/AOC2021/Inputs/Day13Input.txt").readText()

    fun part1() {
        val (points, folds) = parseInput()

        println(
            points.applyFoldToItems(folds[0]).size
        )
    }

    fun part2() {
        val input = parseInput()
        var points = input.first

        input.second.forEach { fold ->
            points = points.applyFoldToItems(fold)
        }

        points.display()
    }

    private fun Set<Point>.applyFoldToItems(fold: Fold) = this.map {
        it.foldWith(fold)
    }.toSet()

    private fun Point.foldWith(fold: Fold) = if (fold.axis == 'x') foldXLeft(fold.n) else foldYUp(fold.n)

    private fun Point.foldYUp(y: Int): Point {
        return if (this.y <= y) {
            this
        } else {
            val difference = this.y - y
            Point(this.x, y - difference)
        }
    }

    private fun Point.foldXLeft(x: Int): Point {
        return if (this.x <= x) {
            this
        } else {
            val difference = this.x - x
            Point(x - difference, this.y)
        }
    }

    private fun Set<Point>.display() {
        val maxX = this.maxOf { it.x }
        val maxY = this.maxOf { it.y }

        (0 .. maxY).forEach { y ->
            (0 .. maxX).forEach { x ->
                print(
                    if (this.contains(Point(x, y))) "#" else " "
                )
            }
            println()
        }
    }

    private fun parseInput(): Pair<Set<Point>, List<Fold>> {
        val sections = input.split("\n\n").map(String::lines)

        val points = sections.first().map {
            val parts = it.split(",")
            Point(parts.first().toInt(), parts.last().toInt())
        }

        val folds = sections.last().map {
            val parts = it.split("=")
            Fold(parts.first().last(), parts.last().toInt())
        }

        return Pair(points.toSet(), folds)
    }

}