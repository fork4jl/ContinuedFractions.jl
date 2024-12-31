
"""
    FiniteContinuedFraction{T<:Integer}

A type of representation of **rational numbers** using
*finite* term connected fractions with Integer quotients.

# Fields
The fields of a structure are *not* part of the public API.
Please use helper functions to access them, such as [`quotients`](@ref).

# Examples
"""
struct FiniteContinuedFraction{T<:Integer} <: ContinuedFraction{T}
    quotients::Vector{T}
end

"""
    quotients(cf::FiniteContinuedFraction)
"""
quotients(cf::FiniteContinuedFraction) = cf.quotients


"""
    continuedfraction(x::Real, y::Real, ::Type{T}=Int)

Build continued fraction from the ratio of `x` and `y`.

# Examples
```jldoctest
julia> continuedfraction(3, 9)
FiniteContinuedFraction{Int64}([0, 3])

julia> continuedfraction(9, 3)
FiniteContinuedFraction{Int64}([3])

julia> continuedfraction(11, 9)
FiniteContinuedFraction{Int64}([1, 4, 2])
```
"""
function continuedfraction(x::Real, y::Real, ::Type{T}=Int) where {T<:Integer}
    qs = T[]
    r = y
    r_p = x

    while r != 0
        q, r_n = divrem(r_p, r)
        push!(qs, q)
        r, r_p = r_n, r
    end
    FiniteContinuedFraction(qs)
end

"""
    continuedfraction(x::AbstractFloat, ::Type{T}=Int)

Build continued fraction from float point number `x`.

# Examples
```jldoctest
julia> continuedfraction(0.0)
FiniteContinuedFraction{Int64}([0])

julia> continuedfraction(1.0)
FiniteContinuedFraction{Int64}([1])

julia> continuedfraction(0.5)
FiniteContinuedFraction{Int64}([0, 2])
```
"""
continuedfraction(x::AbstractFloat, ::Type{T}=Int) where {T<:Integer} =
    continuedfraction(x, one(x), T)

"""
    continuedfraction(x::Rational{T})

Build continued fraction from Rational number `x`.

# Examples
```jldoctest
julia> continuedfraction(0//1)
FiniteContinuedFraction{Int64}([0])
```
"""
continuedfraction(x::Rational{T}) where {T<:Integer} =
    continuedfraction(x.num, x.den, T)                 

start(cf::FiniteContinuedFraction) = start(cf.quotients)
done(cf::FiniteContinuedFraction) = done(cf.quotients)
next(cf::FiniteContinuedFraction, i) = next(cf.quotients,i)
getindex(cf::FiniteContinuedFraction, i) = getindex(cf.quotients, i)
length(cf::FiniteContinuedFraction) = length(cf.quotients)
