module TestAqua

using Aqua
using MemoizedSerialization
using Test

@testset "Aqua" begin
    Aqua.test_ambiguities(MemoizedSerialization, recursive = false)
    Aqua.test_all(MemoizedSerialization, ambiguities = false)
    return nothing
end

end
