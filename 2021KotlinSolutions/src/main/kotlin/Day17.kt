import java.awt.Point
import kotlin.math.absoluteValue

object Day17 {
    val xs = 138..184
    val ys = -125..-71

    fun part1() {
        println(
            Probe(
                getValidVelocities().maxByOrNull { it.y }!!
            ).getHighestYPosition()
        )
    }

    fun part2() {
        println(
            getValidVelocities().size
        )
    }

    private fun getValidVelocities(): List<Point> {
        val basket = getTargetZone()
        val result = mutableListOf<Point>()

        for (y in ys.first() .. ys.first().absoluteValue) {
            for (x in 1 .. xs.last) {
                val velocity = Point(x, y)
                if (Probe(velocity).checkIfLandsInBasket(basket)) {
                    result.add(velocity)
                }
            }
        }

        return result
    }

    private fun getTargetZone(): Set<Point> {
        val result  = mutableSetOf<Point>()

        (xs).forEach { x ->
            (ys).forEach { y ->
                result.add(Point(x, y))
            }
        }

        return result
    }

    data class Probe(val velocity: Point, val position: Point = Point(0, 0)) {

        fun getHighestYPosition(): Int {
            var probe = this
            var previous = position.y

            while (previous <= probe.position.y) {
                previous = probe.position.y
                probe = probe.step()
            }

            return previous
        }

        fun checkIfLandsInBasket(targetZone: Set<Point>): Boolean {
            var current = this

            while (true) {
                if (targetZone.contains(current.position)) {
                    return true
                }

                if (current.position.x > xs.last || current.position.y < ys.first) {
                    return false
                }

                current = current.step()
            }
        }

        private fun step(): Probe {
            val newPosition = Point(position.x + velocity.x, position.y + velocity.y)
            val newXVelocity = if (velocity.x == 0) 0 else velocity.x - 1
            val newYVelocity = velocity.y - 1

            return Probe(Point(newXVelocity, newYVelocity), newPosition)
        }
    }
}