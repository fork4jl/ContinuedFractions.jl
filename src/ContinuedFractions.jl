"""
This module provides functionality for working with continued fractions.
"""
module ContinuedFractions

import Base: iterate, IteratorSize, IteratorEltype, HasLength, HasEltype,
length, eltype, collect

export ContinuedFraction, quotients, convergents, ConvergentIterator

"""
    struct ContinuedFraction{T}  where {T<:Integer} end

    ContinuedFraction(qs::Vector{T}) where {T<:Integer}
    ContinuedFraction(rat::Rational{T}) where {T<:Integer}
    ContinuedFraction(x::AbstractFloat)
    ContinuedFraction(x::Integer)

A type representing a continued fraction with integer quotients.

# Fields
The fields of a structure are *not* part of the public API.
Please use helper functions to access them, such as [`quotients`](@ref).

# Examples
```jldoctest
julia> ContinuedFraction([1])
ContinuedFraction{Int64}([1])

julia> ContinuedFraction(1)
ContinuedFraction{Int64}([1])

julia> ContinuedFraction(10)
ContinuedFraction{Int64}([10])

julia> ContinuedFraction(3.14)
ContinuedFraction{Int64}([3, 7, 7])

julia> ContinuedFraction(big"1"/10)
ContinuedFraction{BigInt}(BigInt[0, 10])
```
"""
struct ContinuedFraction{T}
	quotients::Vector{T}
	ContinuedFraction{T}(qs::Vector{T}) where {T<:Integer} = new{T}(qs)
end

eltype(it::ContinuedFraction{T}) where {T} = T


"""
    quotients(cf::ContinuedFraction) -> Vector{T}

Return the quotients of the given `ContinuedFraction` object `cf`.

# Returns
- A vector containing the quotients of the continued fraction.

# Examples
```jldoctest
julia> quotients(ContinuedFraction(10))
1-element Vector{Int64}:
 10

julia> quotients(ContinuedFraction(3.14))
3-element Vector{Int64}:
 3
 7
 7

julia> quotients(ContinuedFraction(big"1"/10))
2-element Vector{BigInt}:
  0
 10
```
"""
quotients(cf::ContinuedFraction) = cf.quotients

struct ConvergentIterator{T}
    qs::Vector{T}
	ConvergentIterator{T}(qs::Vector{T}) where {T<:Integer} = new{T}(qs)
end
ConvergentIterator(qs::Vector{T}) where {T<:Integer} = ConvergentIterator{T}(qs)

_done(it::ConvergentIterator, state::Int) = state > length(it.qs)
function Base.iterate(it::ConvergentIterator, state::Int = 1)
	_done(it, state) && return nothing
	convergent = Rational(ContinuedFraction(it.qs[1:state]))
    convergent, state + 1
end

IteratorSize(::Type{ConvergentIterator}) = HasLength()
IteratorEltype(::Type{ConvergentIterator}) = HasEltype()

length(it::ConvergentIterator) = length(it.qs)
eltype(::Type{ConvergentIterator{T}}) where {T} = Rational{T}
eltype(it::ConvergentIterator{T})     where {T} = Rational{T}
collect(it::ConvergentIterator{T})    where {T} = collect(Rational{T}, it)

"""
    convergents(cf::ContinuedFraction) -> ConvergentIterator
    convergents(qs::Vector{<:Integer}) -> ConvergentIterator
    convergents(x::Real) -> ConvergentIterator

Compute the convergents of a input.

# Returns
- `ConvergentIterator`: An iterator over the convergents of the continued fraction.

# Examples
```jldoctest
julia> convergents([0])
ConvergentIterator{Int64}([0])

julia> convergents(3)
ConvergentIterator{Int64}([3])

julia> convergents(22/7)
ConvergentIterator{Int64}([3, 7])

julia> convergents(355/113)
ConvergentIterator{Int64}([3, 7, 16])

julia> convergents(3.1415926)
ConvergentIterator{Int64}([3, 7, 15, 1, 243, 1, 1, 9, 1, 1, 4])
```
"""
convergents(cf::ContinuedFraction) = convergents(quotients(cf))
convergents(qs::Vector{<:Integer}) = ConvergentIterator(qs)
convergents(x::Real) = convergents(ContinuedFraction(x))

function Base.Rational(cf::ContinuedFraction)
    qs = quotients(cf)
    isempty(qs) && return 0 // 1
    length(qs) == 1 && return qs[1] // 1

    remainder = qs[2:end]
    rat = Rational(ContinuedFraction(remainder))
    (qs[1] * rat.num + rat.den) // rat.num
end

function ContinuedFraction(rat::Rational{T}) where {T<:Integer}
    a = div(rat.num, rat.den)
    a * rat.den == rat.num && return ContinuedFraction(T[a])  # Exact!

    cf = ContinuedFraction(rat.den//(rat.num - a*rat.den))
    pushfirst!(quotients(cf), a) # insert at index 1
    cf
end

# let rationalize handle conversion from floating point
ContinuedFraction(x::BigFloat) = ContinuedFraction(rationalize(BigInt, x))
ContinuedFraction(x::AbstractFloat) = ContinuedFraction(rationalize(x))

ContinuedFraction(x::Integer) = ContinuedFraction([x])
ContinuedFraction(qs::Vector{T}) where {T<:Integer} = ContinuedFraction{T}(qs)

end # module ContinuedFractions
