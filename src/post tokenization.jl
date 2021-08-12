# steps to run after docstring has been tokenized (split into words)

function rm_words(words)
    (x)->(filter((word)->(!(word in words)), x))
end

function rm_numeric()
    (x)->(filter((word)->(is_not_numeric(word)), x))
end

function is_not_numeric(word)
    return tryparse(Float64, word) == nothing
end