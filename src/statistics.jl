#https://en.wikipedia.org/wiki/Tf%E2%80%93idf
function tf_idf(mat, safe=false)
    
    if safe && 0 in mat.nzval
        # zeros can break both tf and occurrence calculations
        mat = dropzeros(mat)
    end

    tf = spzeros(size(mat))

    for j in 1:mat.m
        sm = sum(mat.nzval[mat.colptr[j]:(mat.colptr[j+1]-1)])
        for i in mat.colptr[j]:(mat.colptr[j+1]-1)
            tf[mat.rowval[i],j] = mat.nzval[i]/sm
        end
    end

    idf = zeros(mat.n)
    for i in 1:length(mat.rowval)
        idf[mat.rowval[i]] += 1
    end

    idf = [log(mat.n/x) for x in idf]

    for i in 1:length(tf.rowval)
        tf.nzval[i] = tf.nzval[i]*(idf[tf.rowval[i]])
    end

    tf
end


function kres_silhouette(kres, dmat)
    mean(silhouettes(kres.assignments, kres.counts, dmat))
end

function calinski_harabasz(kres, mat)
    #=
    (sum(cluster.counts(sq dist(centroide cluster, centroide globale)))) / k-1
    /
    sum(sq dist(documento, centroide cluster))/num docs - k    
    =#
    c = global_centroid(mat)
    BGSS = 0
    for cluster in 1:length(kres.counts)
        BGGS += kres.counts[cluster]*SqEuclidean(kres.centers[:, cluster],c)
    end

    WGSS = 0
    for document in 1:mat.m
        WGSS += SqEuclidean(kres.centers[:, kres.assignments[document]], document)
    end

    (BGSS/(length(kres.counts)-1))*(WGGS/(mat.m - length(kres.counts)))
end
