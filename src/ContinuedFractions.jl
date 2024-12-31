"""
This module provides functionality for working with continued fractions.
"""
module ContinuedFractions

import Base: start, done, next, length, eltype, getindex

export ContinuedFraction, FiniteContinuedFraction, IrrationalContinuedFraction,
    ConvergentIterator, continuedfraction, convergents

abstract type ContinuedFraction{T<:Integer} end
eltype(::ContinuedFraction{T}) where {T<:Integer} = T

include("finite.jl")
include("irrational.jl")
include("convergents.jl")

end # module ContinuedFractions
