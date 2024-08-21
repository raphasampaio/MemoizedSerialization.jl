module MemoizedSerialization

using Random
using Serialization

const PATH = joinpath(tempdir(), randstring(16))

include("initializer.jl")
include("finalizer.jl")
include("macro.jl")

export @serializer_cache

end
