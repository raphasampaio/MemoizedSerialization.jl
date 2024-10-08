module MemoizedSerialization

using Serialization

const CACHE_PATH = Ref{String}()
const CACHE_SET = Set{String}()

export @memoized_serialization

include("memoized.jl")

end
