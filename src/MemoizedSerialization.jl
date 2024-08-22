module MemoizedSerialization

using Serialization

const CACHE_PATH = Ref{String}()

function __init__()
    CACHE_PATH[] = mktempdir(; cleanup = true)
    return nothing
end

export @memoized_serialization

include("macro.jl")

end
