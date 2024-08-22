# MemoizedSerialization.jl

[![CI](https://github.com/raphasampaio/MemoizedSerialization.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/raphasampaio/MemoizedSerialization.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/raphasampaio/MemoizedSerialization.jl/graph/badge.svg?token=S81cIlIP4z)](https://codecov.io/gh/raphasampaio/MemoizedSerialization.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Introduction

MemoizedSerialization.jl is a Julia package that provides macros for memoizing the results of function calls using Serialization.jl. This is particularly useful for expensive computations with non-hashable arguments, as it allows the user to define custom keys for memoization. This package allows you to persist the results of function calls and retrieve them from disk if they have been previously computed, saving time for repeated evaluations.

## Features

- Memoize expensive computations with user-defined keys.
- Serialize and deserialize results using Serialization.jl.
- Flexibility to manage paths either implicitly or explicitly.

## Getting Started

### Installation

```julia
julia> ] add MemoizedSerialization
```

### Example 1: Using an Implicit Path

The following example demonstrates memoization where the path for serialization is implicitly managed:

```julia
using MemoizedSerialization

function sum(a, b)
    println("Computing sum($a, $b)")
    return a + b
end

# first call with (1, 2) - computation is performed and result is serialized
a, b = 1, 2
result = @memoized_serialization "sum-$a-$b" sum(a, b)

# second call with (2, 2) - computation is performed and result is serialized
a, b = 2, 2
result = @memoized_serialization "sum-$a-$b" sum(a, b)

# third call with (1, 2) - result is loaded from cache (deserialized)
a, b = 1, 2
result = @memoized_serialization "sum-$a-$b" sum(a, b)

```

### Example 2: Using an Explicit Path

You can also specify an explicit path to store the serialized results:

```julia
using MemoizedSerialization

function sum(a, b)
    println("Computing sum($a, $b)")
    return a + b
end

# define a directory for storage
path = mktempdir()

# first call with (1, 2) - computation is performed and result is serialized at the specified path
a, b = 1, 2
result = @memoized_serialization path "sum-$a-$b" sum(a, b)

# second call with (2, 2) - computation is performed and result is serialized at the specified path
a, b = 2, 2
result = @memoized_serialization path "sum-$a-$b" sum(a, b)

# third call with (1, 2) - result is loaded from cache (deserialized) from the specified path
a, b = 1, 2
result = @memoized_serialization path "sum-$a-$b" sum(a, b)
```

## Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to open an issue or submit a pull request.
