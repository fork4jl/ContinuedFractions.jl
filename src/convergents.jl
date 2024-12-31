
struct ConvergentIterator{T<:Integer, CF<:ContinuedFraction{T}}
    cf::CF
end

#= Iteration Interfaces =#
Base.length(it::ConvergentIterator) = length(it.cf)
Base.eltype(it::ConvergentIterator{T,CF}) where {T,CF} = Rational{T}
"""
(Int, Rational{T}, Rational{T})
"""
const ConvStateType{T} = Tuple{Int, Rational{T}, Rational{T}} where {T<:Integer}
Base.isdone(it::ConvergentIterator{T,CF}, state::ConvStateType{T}) where {T<:Integer,CF} =
    isdone(it.cf, state[1])
function Base.iterate(it::ConvergentIterator{T,CF}, state::ConvStateType{T}) where {T<:Integer,CF}
    i, r, r_prev  = state
    q, i_next = iterate(it.cf, i)
    r_next = (q*r.num + r_prev.num) // (q*r.den + r_prev.den)
    return r_next, (i_next, r_next, r)
end
Base.iterate(it::ConvergentIterator{T,CF}) where {T<:Integer,CF} =
    iterate(it, (1, one(T)//zero(T), zero(T)//one(T)))


"""
    convergents(x::Real) -> ConvergentIterator

Compute the convergents of a input.

# Returns
- `ConvergentIterator`: An iterator over the convergents of the continued fraction.

# Examples
```
```
"""
convergents(x::Real) = ConvergentIterator(continuedfraction(x))
