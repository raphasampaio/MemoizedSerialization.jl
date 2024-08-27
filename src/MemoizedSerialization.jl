module MemoizedSerialization

using Serialization

const CACHE_PATH = Ref{String}()
const CACHE_SET = Set{String}()

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
    empty!(CACHE_SET)
    return nothing
end

macro memoized_serialization(path, key, expr)
    return quote
        file = joinpath($(esc(path)), string($(esc(key)), ".tmp"))

        if $(esc(key)) in CACHE_SET
            Serialization.deserialize(file)
        else
            push!(CACHE_SET, $(esc(key)))
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
