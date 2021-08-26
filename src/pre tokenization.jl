# pre processing to be done before docstrings are split into words
# every piece must return docstring to continue the pipe

function apply_stemmer(stemmer)
    (x)->(aux_app_stm(x, stemmer))
end

function aux_app_stm(x, stemmer)
    t = TextAnalysis.StringDocument(x)
    stem!(stemmer, t)
    t.text
end

function space_punctuation()
    remove_special(".,/\\")
end

function space_operators()
    remove_special("*=+/")
end

function remove_special(str)
    r = r"[a]"
    r.pattern = "[$str]"
    (x)->(replace(x, r=>" "))    
end

function rm_codeblocks()
    (x)->(aux_rm_codeblocks(x))
end

function aux_rm_codeblocks(x)
    s = split(x, "```")
    t = s[1]
    i=3
    while i < length(s)
        t = string(t," ", s[i])
        i+=2#skip evens
    end
    t
end

function _lowercase()
    (x)->(lowercase(x))
end