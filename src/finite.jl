# rationals have finite continued fractions
struct FiniteContinuedFraction{T<:Integer} <: ContinuedFraction{T}
    quotients::Vector{T}
end

# continued fraction for the ratio of x and y
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

continuedfraction(x::AbstractFloat, ::Type{T}=Int) where {T<:Integer} =
    continuedfraction(x, one(x), T)

continuedfraction(x::Rational{T}) where {T<:Integer} =
    continuedfraction(x.num, x.den, T)                 

start(cf::FiniteContinuedFraction) = start(cf.quotients)
done(cf::FiniteContinuedFraction) = done(cf.quotients)
next(cf::FiniteContinuedFraction, i) = next(cf.quotients,i)
getindex(cf::FiniteContinuedFraction, i) = getindex(cf.quotients, i)
length(cf::FiniteContinuedFraction) = length(cf.quotients)
