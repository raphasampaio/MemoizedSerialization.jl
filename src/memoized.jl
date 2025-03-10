function create_cache_directory!()
    if isassigned(CACHE_PATH) && isdir(CACHE_PATH[])
        rm(CACHE_PATH[], force = true, recursive = true)
    end
    CACHE_PATH[] = mktempdir(; cleanup = true)
    return nothing
end

function clean!(; max_size::Integer = 10)
    create_cache_directory!()
    empty!(CACHE_SET)
    empty!(LRU_CACHE)
    resize!(LRU_CACHE; maxsize = max_size)
    return nothing
end

function cache_path()
    return CACHE_PATH[]
end

function is_cache_directory_initialized()
    return isassigned(CACHE_PATH)
end

function is_in_cache_set(key::AbstractString)
    return key in CACHE_SET
end

function build_cache_path(key::AbstractString)
    if !is_cache_directory_initialized()
        create_cache_directory!()
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
        if is_in_cache_set($(esc(key)))
            deserialize($(esc(key)))
        else
            serialize($(esc(key)), $(esc(expr)))
        end
    end
end

macro memoized_lru(key, expr)
    return quote
        get!(LRU_CACHE, $(esc(key))) do
            $(esc(expr))
        end
    end
end