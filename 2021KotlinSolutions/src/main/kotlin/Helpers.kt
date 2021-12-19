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