"""
This module provides functionality for working with continued fractions.
"""
module ContinuedFractions

import Base: start, done, next, length, eltype, getindex

export ContinuedFraction, continuedfraction, 
    FiniteContinuedFraction,
    IrrationalContinuedFraction,
    ConvergentIterator, convergents


"""
    ContinuedFraction{T<:Integer}

An abstract type representing a continued fraction with elements of type `T`, 
where `T` is a subtype of `Integer`.
This type serves as a base for defining specific types of continued fractions.
"""
abstract type ContinuedFraction{T<:Integer} end

eltype(::ContinuedFraction{T}) where {T<:Integer} = T

include("finite.jl")
include("irrational.jl")
include("convergents.jl")

end # module ContinuedFractions
