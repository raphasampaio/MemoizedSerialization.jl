module MemoizedSerialization

using Serialization

const CACHE_PATH = Ref{String}()

export @memoized_serialization

function __init__()
    CACHE_PATH[] = mktempdir(; cleanup = true)
    return nothing
end

function path()
    return CACHE_PATH[]
end

function clean!()
    if isdir(CACHE_PATH[])
        rm(CACHE_PATH[], force = true, recursive = true)
    end
    CACHE_PATH[] = mktempdir(; cleanup = true)
    return nothing
end

macro memoized_serialization(path, key, expr)
    return quote
        file = joinpath($(esc(path)), string($(esc(key)), ".tmp"))
        if isfile(file)
            Serialization.deserialize(file)
        else
            data = $(esc(expr))
            Serialization.serialize(file, data)
            data
        end
    end
end

macro memoized_serialization(key, expr)
    return :(@memoized_serialization(CACHE_PATH[], $(esc(key)), $(esc(expr))))
end


end
