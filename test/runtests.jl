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

function test_all()
    @testset "Aqua.jl" begin
        test_aqua()
    end

    global calls = 0
    @test 2 == @memoized_serialization "1_1" sum(1, 1)
    @test 2 == @memoized_serialization "1_1" sum(1, 1)
    @test 3 == @memoized_serialization "1_2" sum(1, 2)
    @test 4 == @memoized_serialization "1_3" sum(1, 3)
    @test 3 == @memoized_serialization "1_2" sum(1, 2)
    @test 2 == @memoized_serialization "1_1" sum(1, 1)
    @test 2 == @memoized_serialization "1_1" sum(1, 1)
    @test calls == 3

    global calls = 0
    @test Struct(1, 1) == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test Struct(1, 1) == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test Struct(1, 2) == @memoized_serialization "struct_1_2" Struct(1, 2)
    @test Struct(1, 3) == @memoized_serialization "struct_1_3" Struct(1, 3)
    @test Struct(1, 2) == @memoized_serialization "struct_1_2" Struct(1, 2)
    @test Struct(1, 1) == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test Struct(1, 1) == @memoized_serialization "struct_1_1" Struct(1, 1)
    @test calls == 10

    return nothing
end

test_all()
