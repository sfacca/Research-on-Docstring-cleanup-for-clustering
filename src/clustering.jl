function use_kmeans(mat, ks)
    res = []
    for k in ks
        println("running kmeans of k $k")
        push!(res, Clustering.kmeans(mat, k))
    end
    res
end