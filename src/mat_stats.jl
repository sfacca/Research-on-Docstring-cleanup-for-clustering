function make_dmat(doc_mat::SparseMatrixCSC{T,Int64}) where {T}
    make_dmat(Matrix(doc_mat))
end


function make_dmat(doc_mat)
    convert(
        Array{T} where T <: Number, 
        pairwise(SqEuclidean(), doc_mat)
        )
end



function make_vec_array(doc_mat)
    [doc_mat[:,i] for i in 1:doc_mat.n]
end

function _my_pairwise(distance, spmat)
    res = zeros(calc_last(spmat))
    onepcg = length(res)/1000
    c=1
    i = 1
    for a in 1:spmat.n
        for b in (a+1):spmat.n
            if i >= c*onepcg
                println("$(c/10)%")
                c+=1
            end
            res[i] = evaluate(distance, spmat[:,a], spmat[:,b])
            i+=1
        end
    end
    res
end

function calc_last(mat)
    Int.((mat.m*mat.m)-mat.m)/2
end

function _my_pairwise_stopping(distance, spmat, stop)
    res = zeros(calc_last(spmat))
    onepcg = length(res)/100
    c=1
    i = 1
    for a in 1:stop
        for b in (a+1):spmat.n
            if i >= c*onepcg
                println("$c%")
                c+=1
            end
            res[i] = evaluate(distance, spmat[:,a], spmat[:,b])
            i+=1
        end
    end
    res
end

function array_of_rows(mat)
    vals = []
    for i in 1:mat.m 
        push!(vals, [])
    end

    for i in 2:length(mat.nzval)
        push!(vals[mat.rowval[i]], mat.nzval[i])
    end

    vals
end

function row_abundance(mat)
    [ length(x) for x in array_of_rows(mat) ]
end

function sum_rows(mat)
    [ sum(x) for x in array_of_rows(mat) ]
end

function find_low_abundance(mat)
    sortperm(row_abundance(mat))
end

function find_low_presence(mat)
    sortperm(sum_rows(mat))
end

function remove_empty_rows(data)
    data[sort(unique(data.rowval)),:]
end

function find_singletons(mat)
    sm = sum_rows(mat)
    singletons = findall((x)->(x==1), sm)
end

function remove_rows!(mat, rows)
    for row in rows
        println("removing row $row")
        asd = findall((x)->(x==row), mat.rowval)
        for i in asd
            mat.nzval[i] = 0
        end
    end
    dropzeros(mat)
end

function remove_rows(mat, rows)
    mat[findall((x)->!(x in rows) , unique(sort(collect(1:size(mat,1))))), :]
end

function global_centroid(mat)
    # mat is unweighted -> global centroid is vector of means
    # we dont care about columns so we can save time by just iterating over nzval/rowval
    res = zeros(mat.m)
    for i in 1:length(mat.nzval)
        res[mat.rowval[i]] += mat.nzval[i]
    end
    [x/mat.n for x in res]
end



