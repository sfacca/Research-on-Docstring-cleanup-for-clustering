using FileIO, JLD2, TextAnalysis, CSTParser, WordTokenizers, StatsBase, SparseArrays, Clustering, Distances

include("docstring_extraction.jl")
include("mat_stats.jl")
include("post tokenization.jl")
include("pre tokenization.jl")
include("processing.jl")
include("statistics.jl")
include("tokenization.jl")
include("clustering.jl")
include("corpus.jl")
include("cluster_stats.jl")

load = FileIO.load

PRETOKENIZATION = [
    ("space_punctuation()", space_punctuation),
    ("apply_stemmer(stemmer)", apply_stemmer),
    ("_lowercase()", _lowercase),
    ("rm_codeblocks()", rm_codeblocks),
    ("remove_special(str)", remove_special),
    ("space_operators()", space_operators)
]

TOKENIZATION = [
    ("n_gram(n::Int)", n_gram),
    ("_tokenize(tokenizer)", _tokenize),
    ("n_gram_tokenize(n, tokenizer)", n_gram_tokenize)
]

POSTTOKENIZATION = [
    ("rm_graph()", rm_graph),
    ("rm_special(arr::String)", rm_special),
    ("is_not_numeric(word)", is_not_numeric),
    ("rm_numeric()", rm_numeric),
    ("rm_words(words)", rm_words)   
]

TOKENIZERS = [
    ("poormans_tokenize", poormans_tokenize),
    ("punctuation_space_tokenize", punctuation_space_tokenize),
    ("penn_tokenize", penn_tokenize),
    ("improved_penn_tokenize", improved_penn_tokenize),
    ("nltk_word_tokenize", nltk_word_tokenize)
]

function process_help()
    println("----- pre tokenization")
    for x in PRETOKENIZATION
        println(x[1])
    end    
    println("------")
    println("----- tokenization")    
    for x in TOKENIZATION
        println(x[1])
    end
    println("------")
    println("----- tokenizers")
    for x in TOKENIZERS
        println(x[1])
    end
    
    println("------")
    println("----- post tokenization")
    for x in POSTTOKENIZATION
        println(x[1])
    end    
    println("------")

end



function full_pipeline(dfs, pre, ks, name="sample", dmat=nothing)
    mkpath("$name")
    println("processing docs")
    if !isfile("$name/mat.jld2") && !isfile("$name/lexi.jld2")
        mat, lexi = process_dfs(dfs, pre)
        println("saving matrix and lexicon")
        save("$name/mat.jld2", Dict("mat"=>mat))
        save("$name/lexi.jld2", Dict("lexi"=>lexi))
    else
        mat = load("$name/mat.jld2")["mat"]
        lexi = load("$name/lexi.jld2")["lexi"]
    end

    println("k means clustering")
    kresses = use_kmeans(mat, ks)
    println("saving kres")
    if isfile("$name/kresults.jld2")
        kresses = vcat(kresses, load("$name/kresults.jld2")["kresults"])    
        save("$name/kresults.jld2", Dict("kresults"=>kresses))
    else        
        save("$name/kresults.jld2", Dict("kresults"=>kresses))
    end

    if isnothing(dmat)    
        if !isfile("$name/dmat.jld2")
            println("calculating distance matrix")
            dmat = make_dmat(mat)
            println("saving dmat")
            save("$name/dmat.jld2", Dict("dmat"=>dmat))
        else
            dmat = load("$name/dmat.jld2")["dmat"]
        end
    end

    println("calculating stats")
    stats =  cluster_stats(kresses, dmat, mat)
    println("saving stats")
    save("$name/stats.jld2", Dict("stats"=>stats))
    stats
end



