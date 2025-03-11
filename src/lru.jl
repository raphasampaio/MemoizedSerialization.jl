function clean_lru!(max_size::Integer)
    empty!(LRU_CACHE)
    resize!(LRU_CACHE; maxsize = max_size)
    return nothing
end

macro memoized_lru(key, expr)
    return quote
        get!(LRU_CACHE, $(esc(key))) do
            return deepcopy($(esc(expr)))
        end
    end
end