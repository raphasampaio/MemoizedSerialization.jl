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

function deserialize(path::AbstractString, key::AbstractString)
    cache_path = build_cache_path(path, key)
    return Serialization.deserialize(cache_path)
end

function serialize(path::AbstractString, key::AbstractString, data::Any)
    push!(CACHE_SET, key)
    cache_path = build_cache_path(path, key)
    Serialization.serialize(cache_path, data)
    return data
end

macro memoized_serialization(path, key, expr)
    return quote
        if is_cached($(esc(key)))
            deserialize($(esc(path)), $(esc(key)))
        else
            serialize($(esc(path)), $(esc(key)), $(esc(expr)))
        end
    end
end

macro memoized_serialization(key, expr)
    return :(@memoized_serialization(CACHE_PATH[], $(esc(key)), $(esc(expr))))
end
