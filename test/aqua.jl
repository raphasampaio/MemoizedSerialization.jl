function test_aqua()
    @testset "Ambiguities" begin
        Aqua.test_ambiguities(MemoizedSerialization, recursive = false)
    end
    Aqua.test_all(MemoizedSerialization, ambiguities = false)

    return nothing
end
