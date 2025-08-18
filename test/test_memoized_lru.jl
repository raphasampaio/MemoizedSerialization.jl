module TestMemoizedLRU

using MemoizedSerialization
using Test

include("util.jl")

@testset "Memoized LRU" begin
    MemoizedSerialization.clean!(max_size = 10)

    global calls = 0
    @test 2 == @memoized_lru "sum_1_1" sum(1, 1)
    @test 2 == @memoized_lru "sum_1_1" sum(1, 1)
    @test 3 == @memoized_lru "sum_1_2" sum(1, 2)
    @test 4 == @memoized_lru "sum_1_3" sum(1, 3)
    @test 3 == @memoized_lru "sum_1_2" sum(1, 2)
    @test 2 == @memoized_lru "sum_1_1" sum(1, 1)
    @test 2 == @memoized_lru "sum_1_1" sum(1, 1)
    @test calls == 3

    global calls = 0
    @test @memoized_lru "vector_4" vector(4) == [1, 2, 3, 4]
    @test @memoized_lru "vector_3" vector(3) == [1, 2, 3]
    @test @memoized_lru "vector_2" vector(2) == [1, 2]
    @test @memoized_lru "vector_1" vector(1) == [1]
    @test @memoized_lru "vector_2" vector(2) == [1, 2]
    @test @memoized_lru "vector_3" vector(3) == [1, 2, 3]
    @test @memoized_lru "vector_3" vector(4) == [1, 2, 3, 4]
    @test calls == 4

    struct11 = Struct(1, 1)
    struct12 = Struct(1, 2)
    struct13 = Struct(1, 3)

    global calls = 0
    @test struct11 == @memoized_lru "struct_1_1" Struct(1, 1)
    @test struct11 == @memoized_lru "struct_1_1" Struct(1, 1)
    @test struct12 == @memoized_lru "struct_1_2" Struct(1, 2)
    @test struct13 == @memoized_lru "struct_1_3" Struct(1, 3)
    @test struct12 == @memoized_lru "struct_1_2" Struct(1, 2)
    @test struct11 == @memoized_lru "struct_1_1" Struct(1, 1)
    @test struct11 == @memoized_lru "struct_1_1" Struct(1, 1)
    @test calls == 3

    MemoizedSerialization.clean!()
    @test length(readdir(MemoizedSerialization.cache_path())) == 0
end

end
