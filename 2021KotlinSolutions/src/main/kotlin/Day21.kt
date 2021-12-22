object Day21 {
    private const val p1Start = 10
    private const val p2Start = 9
    private val initialGame = GameState.startGame(p1Start, p2Start)

    fun part1() {
        var game = initialGame
        var round = 0

        while (!game.scores().any { it >= 1000 }) {
            game = game.carryOutTurn(round)
            round += 1
        }

        println((round * 3) * game.scores().minOrNull()!!)
    }

    fun part2() {
        val possible3Rolls = DiracDie.possible3Rolls()

        fun play(state: GameState, turn: Int = 0): Pair<Long, Long> {
            return possible3Rolls.map { (roll, probability) ->
                val newState = state.carryOutTurn(turn, roll)

                if (newState.scores().any { it >= 21 }) {
                    if (isPlayerOne(turn)) {
                        probability to 0L
                    } else {
                        0L to probability
                    }
                } else {
                    val nextResult = play(newState, turn + 1)
                    nextResult.first * probability to nextResult.second * probability
                }
            }.sum()
        }

        val result = play(initialGame)
        println(
            maxOf(result.first, result.second)
        )
    }

    fun isPlayerOne(turn: Int) = turn % 2 == 0

    object DeterministicDie {
        fun roll(turn: Int): List<Int> {
            val first = turn * 3 + 1

            return listOf(first, first + 1, first + 2)
        }
    }

    object DiracDie {
        fun possible3Rolls(): Map<Int, Long> {
            val possibleRolls = setOf(1, 2, 3)

            return cartesianProduct(possibleRolls, possibleRolls, possibleRolls).map {
                (it as List<Int>).sum()
            }.groupingBy { it }.eachCount().mapValues { it.value.toLong() }
        }
    }

    data class GameState(val player1: PlayerState, val player2: PlayerState) {
        companion object {
            fun startGame(player1Position: Int, player2Position: Int): GameState {
                return GameState(
                    PlayerState(player1Position, 0),
                    PlayerState(player2Position, 0)
                )
            }
        }

        fun carryOutTurn(turn: Int): GameState {
            return if (isPlayerOne(turn)) {
                GameState(
                    player1.takeTurn(turn),
                    player2
                )
            } else {
                GameState(
                    player1,
                    player2.takeTurn(turn)
                )
            }
        }

        fun carryOutTurn(turn: Int, roll: Int): GameState {
            return if (isPlayerOne(turn)) {
                GameState(
                    player1.applyRoll(roll),
                    player2
                )
            } else {
                GameState(
                    player1,
                    player2.applyRoll(roll)
                )
            }
        }

        fun scores() = listOf(player1.score, player2.score)
    }

    data class PlayerState(val position: Int, val score: Int) {
        fun takeTurn(turn: Int): PlayerState = applyRoll(
            DeterministicDie.roll(turn).sum()
        )

        fun applyRoll(roll: Int): PlayerState {
            val moved = move(roll)
            return PlayerState(moved.position, score + moved.position)
        }

        private fun move(by: Int): PlayerState {
            val newPosition = (position + by) % 10

            return PlayerState(
                if (newPosition == 0) 10 else newPosition,
                score
            )
        }
    }

    private fun List<Pair<Long, Long>>.sum() = reduce { acc, pair -> acc + pair }

    private operator fun Pair<Long, Long>.plus(other: Pair<Long, Long>): Pair<Long, Long> {
        return first + other.first to second + other.second
    }
}