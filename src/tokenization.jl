# generic application of tokenizers

function tokenize(tokenizer)
    (x)->(tokenizer(x))
end

function n_gram(n::Int)
    (x)->(n_gram(n, x))
end

function n_gram(n::Int, words::Array{String,1})
    res = []
    for i in 1:length(words)
        if words >= n
            push!(res, join(words[(i-n+1):i], " "))
        end
    end
    res    
end




