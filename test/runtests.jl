using MemoizedSerialization

using Aqua
using Test

include("aqua.jl")

struct Struct
    a::Int
    b::Int

    function Struct(a::Integer, b::Integer)
        global calls += 1
        return new(a, b)
    end
end

function Base.:(==)(s1::Struct, s2::Struct)
    return s1.a == s2.a && s1.b == s2.b
end

function sum(a::Integer, b::Integer)
    global calls += 1
    return a + b
end

function vector(a::Integer)
    global calls += 1
    return [i for i in 1:a]
end

function test_memoized_serialization()
    global calls = 0
    @test 2 == @memoized_serialization "sum_1_1" sum(1, 1)
    @test 2 == @memoized_serialization "sum_1_1" sum(1, 1)
    @test 3 == @memoized_serialization "sum_1_2" sum(1, 2)
    @test 4 == @memoized_serialization "sum_1_3" sum(1, 3)
    @test 3 == @memoized_serialization "sum_1_2" sum(1, 2)
    @test 2 == @memoized_serialization "sum_1_1" sum(1, 1)
    @test 2 == @memoized_serialization "sum_1_1" sum(1, 1)
    @test calls == 3

    path = mktempdir()
    global calls = 0
    @test @memoized_serialization path "vector_4" vector(4) == [1, 2, 3, 4]
    @test @memoized_serialization path "vector_3" vector(3) == [1, 2, 3]
    @test @memoized_serialization path "vector_2" vector(2) == [1, 2]
    @test @memoized_serialization path "vector_1" vector(1) == [1]
    @test @memoized_serialization path "vector_2" vector(2) == [1, 2]
    @test @memoized_serialization path "vector_3" vector(3) == [1, 2, 3]
    @test @memoized_serialization path "vector_3" vector(4) == [1, 2, 3, 4]
    @test calls == 4

    struct11 = Struct(1, 1)
    struct12 = Struct(1, 2)
    struct13 = Struct(1, 3)

    global calls = 0
    @test struct11 == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test struct11 == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test struct12 == @memoized_serialization "struct_1_2" Struct(1, 2)
    @test struct13 == @memoized_serialization "struct_1_3" Struct(1, 3)
    @test struct12 == @memoized_serialization "struct_1_2" Struct(1, 2)
    @test struct11 == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test struct11 == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test calls == 3

    MemoizedSerialization.clean!()
    @test length(readdir(MemoizedSerialization.cache_path())) == 0

    return nothing
end

function test_all()
    @testset "Aqua.jl" begin
        test_aqua()
    end

    @testset "MemoizedSerialization.jl" begin
        test_memoized_serialization()
    end

    return nothing
end

test_all()
