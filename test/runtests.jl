using MemoizedSerialization

using Aqua
using Test

include("aqua.jl")

struct Struct
    a::Int
    b::Int
end

function Base.:(==)(s1::Struct, s2::Struct)
    return s1.a == s2.a && s1.b == s2.b
end

function sum(a::Integer, b::Integer)
    return a + b
end

function test_all()
    @testset "Aqua.jl" begin
        test_aqua()
    end

    for i in 1:3
        for a in 1:5
            for b in 1:10
                @test a + b == @serializer_cache "a=$a=$b" sum(a, b)

                @test Struct(a, b) == @serializer_cache "struct(a=$a=$b)" Struct(a, b)
            end
        end
    end

    return nothing
end

test_all()
