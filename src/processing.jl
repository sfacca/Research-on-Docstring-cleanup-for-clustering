# this contains the functions we use to define the dfs => bag of words pipeline

function process_dfs(dfs, pre)
    process_docs([x.doc for x in dfs], pre)
end

function process_docs(docs, pre)
    bags = baggerize(docs, pre)
    unis = [unique(x) for x in bags]
    len = sum([length(x) for x in unis])
    lexi = Array{String,1}(undef, len)
    i=1
    for voc in unis        
        lexi[i:(i+length(voc)-1)] = voc
        i = (i+length(voc))
    end
    lexi = unique(lexi[1:(i-1)])

    dic = lexi_to_dict(lexi)

    mat = Int.(spzeros(length(lexi), length(docs)))

    for document in 1:length(bags)
        for word in bags[document]
            
            mat[dic[word],document] += 1
        end
    end

    mat, lexi
end

function baggerize(docs, pre)
    [apply(x, pre) for x in docs]
end

function apply(x::String, arr)
    for foo in arr
        x = foo(x)
    end
    x
end
function apply(dfsa::Array{doc_fun, 1}, arr)
    apply([x.doc for x in dfsa], arr)
end
function apply(dfs::Array{String, 1}, arr)
    res = []
    for str in dfs
        push!(res, apply(str, arr))
    end
    res
end

function lexi_to_dict(lexi)
    Dict([(lexi[i]=>i) for i in 1:length(lexi)])
end