import kotlin.reflect.KFunction

fun <T> getPairs(original: List<T>): Set<Pair<T, T>> {
    val result = mutableSetOf<Pair<T, T>>()

    original.forEach { first ->
        original.forEach { second ->
            if (first != second) {
                result.add(Pair(first, second))
            }
        }
    }

    return result
}

typealias CartesianProduct = Set<List<*>>

fun cartesianProduct(a: Set<*>, b: Set<*>, vararg sets: Set<*>): CartesianProduct =
    (listOf(a, b).plus(sets))
        .fold(listOf(listOf<Any?>())) { acc, set ->
            acc.flatMap { list -> set.map { element -> list + element } }
        }
        .toSet()

fun <T> CartesianProduct.map(transform: KFunction<T>) = map { transform.call(*it.toTypedArray()) }