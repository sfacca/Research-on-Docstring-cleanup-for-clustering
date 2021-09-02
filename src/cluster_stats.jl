function cluster_stats(res, dmat, mat)

    stats = []
    i = 1
    l = length(res)
    for kres in res
        println("calculating stats for kres $i of $l")
        push!(stats, (kres_silhouette(kres, dmat), calinski_harabasz(kres, mat), cluster_mean_distortion(kres, mat)))
        i+=1
    end
    println("result are tuples (silhouette scores , calinski harabasz, distortion)")
    stats
end



