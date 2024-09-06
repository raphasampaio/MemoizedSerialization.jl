module MemoizedSerialization

using Serialization

const CACHE_PATH = Ref{String}()
const CACHE_SET = Set{String}()

export @memoized_serialization

function __init__()
    CACHE_PATH[] = mktempdir(; cleanup = true)
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

function is_cached(key::AbstractString)
    return key in CACHE_SET
end

function cache_path()
    return CACHE_PATH[]
end

function build_cache_path(path::AbstractString, key::AbstractString)
    return joinpath(path, string(key, ".tmp"))
end

function load(path::AbstractString, key::AbstractString)
    file = build_cache_path(path, key)
    return Serialization.deserialize(file)
end

function save(path::AbstractString, key::AbstractString, data::Any)
    file = build_cache_path(path, key)
    push!(CACHE_SET, key)
    Serialization.serialize(file, data)
    return data
end

macro memoized_serialization(path, key, expr)
    return quote
        if is_cached($(esc(key)))
            load($(esc(path)), $(esc(key)))
        else
            save($(esc(path)), $(esc(key)), $(esc(expr)))
        end
    end
end

macro memoized_serialization(key, expr)
    return :(@memoized_serialization(CACHE_PATH[], $(esc(key)), $(esc(expr))))
end

end
