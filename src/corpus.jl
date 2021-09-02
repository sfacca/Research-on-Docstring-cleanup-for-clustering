function random_indexes(docs, num)
    sample(1:length(docs), num, replace = false)
end