module MemoizedSerialization

using LRUCache
using Serialization

const CACHE_PATH = Ref{String}()

const SERIALIZED_CACHE = Set{String}()
const LRU_CACHE = LRU{String, Any}(maxsize = 10)

export @memoized_serialization

include("memoized.jl")

end
