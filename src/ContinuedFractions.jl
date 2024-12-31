"""
This module provides functionality for working with continued fractions.
"""
module ContinuedFractions

import Base: IteratorSize, iterate, length, eltype, isdone, getindex

export ContinuedFraction, continuedfraction, quotients,
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

"""
    quotients(cf::ContinuedFraction) -> Vector{T}

Return the quotients of the given `ContinuedFraction` object `cf`.

# Returns
- A vector containing the quotients of the continued fraction.
"""
quotients(cf::ContinuedFraction)


include("finite.jl")
include("irrational.jl")
include("convergents.jl")

end # module ContinuedFractions
