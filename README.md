# MemoizedSerialization.jl

[![CI](https://github.com/raphasampaio/MemoizedSerialization.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/raphasampaio/MemoizedSerialization.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/raphasampaio/MemoizedSerialization.jl/graph/badge.svg?token=S81cIlIP4z)](https://codecov.io/gh/raphasampaio/MemoizedSerialization.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Introduction

MemoizedSerialization.jl is a Julia package that provides a macro to memoize the result of a function call using Serialization.jl. This package is useful when the function is expensive to compute and the arguments are not hashable, since the key is provided by the user.

## Getting Started

### Installation

```julia
julia> ] add MemoizedSerialization
```

### Example

```julia
using MemoizedSerialization

function sum(a, b)
    println("Computing f($a, $b)")
    return a + b
end

a = 1
b = 2

result = @memoized_serialization "sum-$a-$b" sum(a, b)

result = @memoized_serialization "sum-$a-$b" sum(a, b)
```
