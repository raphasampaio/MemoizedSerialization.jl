module MemoizedSerialization

using LRUCache
using Serialization

const CACHE_PATH = Ref{String}()
const CACHE_SET = Set{String}()
const LRU_CACHE = LRU{String, Any}(maxsize = 10)

export @memoized_serialization, @memoized_lru

include("serialization.jl")
include("lru.jl")

function clean!(; max_size::Integer = 10)
    clean_serialization!()
    clean_lru!(max_size)
    return nothing
end

end
