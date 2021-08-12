struct doc_fun
    doc::Union{String, Nothing}
    fun::String
    doc_fun(a::String, b::String) = a=="" ? new(nothing, b) : new(a,b)
end

function dfbs_to_dfs(dir)
	i = 0
	count = 0
	fails = []

    for (root, dirs, files) in walkdir(dir)
		for file in files
			count += 1
		end
	end
    preall = count*10 #preallocate expecting every file to have an average of 10 doc fun blocks
    dfs = Array{doc_fun,1}(undef, preall)
    pnt = 1

	for (root, dirs, files) in walkdir(dir)
		for file in files
            t = load(joinpath(root, file))[splitext(file)[1]]
            for dfb in t
                dfs[pnt] = doc_fun(dfb.doc, dfb.fun)
                pnt+=1
                if pnt > preall
                    # reallocate
                    preall += count*10
                    tmp = Array{doc_fun,1}(undef, preall)
                    tmp[1:(pnt-1)] = dfs
                    dfs = tmp
                    tmp = nothing
                end
            end
        end
	end
    dfs[1:(pnt-1)]
end


function dfb_to_df(dfb)
    doc_fun(dfb.doc, dfb.fun)
end


function get_nonempty_docs(dfs::Array{doc_fun,1})
    idx = findall((x)->(x.doc != nothing) ,dfs)   
    dfs[idx] , idx
end