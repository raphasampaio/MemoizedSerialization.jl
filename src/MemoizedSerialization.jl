module MemoizedSerialization

using LRUCache
using Serialization

const CACHE_PATH = Ref{String}()
const CACHE_SET = Set{String}()
const LRU_CACHE = LRU{String, Any}(maxsize = 10)

export @memoized_serialization, @memoized_lru

include("memoized.jl")

end
