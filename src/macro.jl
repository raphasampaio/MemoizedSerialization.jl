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
