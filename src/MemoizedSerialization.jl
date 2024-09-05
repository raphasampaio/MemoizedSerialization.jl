module MemoizedSerialization

using Serialization

const CACHE_PATH = Ref{String}()
const CACHE_SET = Set{String}()
const VERBOSE = Ref{Bool}(false)

export @memoized_serialization

function __init__()
    CACHE_PATH[] = mktempdir(; cleanup = true)
    return nothing
end

function path()
    return CACHE_PATH[]
end

function verbose(value::Bool)
    VERBOSE[] = value
    return nothing
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
            if VERBOSE[]
                println("Loading from cache: ", $(esc(key)))
            end
            Serialization.deserialize(file)
        else
            if VERBOSE[]
                println("Saving to cache: ", $(esc(key)))
            end
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
