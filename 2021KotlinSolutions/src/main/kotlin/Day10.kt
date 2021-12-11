import java.io.File
import java.util.*

object Day10 {
    val inputLines = File("/Users/calebjw/Documents/Developer/Personal/AOC/AOC2021/Inputs/Day10Input.txt").readLines()

    fun part1() {
        println(
            inputLines.mapNotNull { it.firstInvalidBracket() }.sumOf { penaltyPoints[it]!! }
        )
    }

    fun part2() {
        val incompleteLines = inputLines.filter { it.firstInvalidBracket() == null }
        val results = incompleteLines.map { it.getCompletionValues() }.sorted()

        println(results[results.size / 2])
    }

    private fun String.getCompletionValues(): Long {
        val openings = Stack<Char>()

        this.forEach { character ->
            if (character.isOpeningBracket()) {
                openings.push(character)
            } else {
                openings.pop()
            }
        }

        return openings.foldRight(0L) { next, acc ->
            (acc * 5) + completionPoints[next]!!
        }
    }

    private fun String.firstInvalidBracket(): Char? {
        val openings = Stack<Char>()

        for (character in this) {
            if (character.isOpeningBracket()) {
                openings.push(character)
            } else {
                val removed = openings.pop()

                if (brackets[removed] != character) return character
            }
        }

        return null
    }

    private fun Char.isOpeningBracket() = brackets[this] != null

    private val brackets = mapOf(
        '(' to ')',
        '{' to '}',
        '[' to ']',
        '<' to '>'
    )

    private val penaltyPoints = mapOf(
        ')' to 3,
        ']' to 57,
        '}' to 1197,
        '>' to 25137
    )

    private val completionPoints = mapOf<Char, Long>(
        '(' to 1,
        '[' to 2,
        '{' to 3,
        '<' to 4
    )
}