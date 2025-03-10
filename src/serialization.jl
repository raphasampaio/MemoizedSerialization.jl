function initialize_serialization!()
    if isassigned(CACHE_PATH) && isdir(CACHE_PATH[])
        rm(CACHE_PATH[], force = true, recursive = true)
    end
    CACHE_PATH[] = mktempdir(; cleanup = true)
    return nothing
end

function clean_serialization!()
    initialize_serialization!()
    empty!(CACHE_SET)
    return nothing
end

function cache_path()
    return CACHE_PATH[]
end

function is_cached(key::AbstractString)
    return key in CACHE_SET
end

function build_cache_path(key::AbstractString)
    if !isassigned(CACHE_PATH)
        initialize_serialization!()
    end
    return joinpath(CACHE_PATH[], string(key, ".tmp"))
end

function deserialize(key::AbstractString)
    cache_path = build_cache_path(key)
    return Serialization.deserialize(cache_path)
end

function serialize(key::AbstractString, data::Any)
    push!(CACHE_SET, key)
    cache_path = build_cache_path(key)
    Serialization.serialize(cache_path, data)
    return data
end

macro memoized_serialization(key, expr)
    return quote
        if is_cached($(esc(key)))
            deserialize($(esc(key)))
        else
            serialize($(esc(key)), $(esc(expr)))
        end
    end
end
