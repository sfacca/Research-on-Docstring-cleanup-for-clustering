# generic application of tokenizers

function _tokenize(tokenizer)
    (x)->(tokenizer(x))
end

function n_gram_tokenize(n, tokenizer)
    (x)->(n_gram(n, String.(tokenizer(x))))
end

function n_gram(n::Int)
    (x)->(n_gram(n, x))
end

function n_gram(n::Int, words::Array{String,1})
    res = []
    for i in n:(length(words))
        push!(res, join(words[(i-n+1):i], " "))
    end
    res    
end




