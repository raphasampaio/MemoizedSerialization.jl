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
