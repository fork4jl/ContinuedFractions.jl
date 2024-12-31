import Base.MathConstants: e, φ

"""
    mutable IrrationalContinuedFraction{T<:Integer, C}

Represents a continued fraction for an irrational number.

# Fields
The fields of a structure are *not* part of the public API.
Please use helper functions to access them, such as [`quotients`](@ref).
"""
mutable struct IrrationalContinuedFraction{T<:Integer, C} <: ContinuedFraction{T}
    precision::Int
    quotients::Vector{T}
end

#= Helper functions for access internal fields =#
"""
    quotients(cf::IrrationalContinuedFraction)
"""
quotients(cf::IrrationalContinuedFraction) = cf.quotients

#= Helper functions for construct IrrationalContinuedFraction =#
"""
    continuedfraction(
        c::AbstractIrrational,
        ::Type{T}=Int
        ; prec::Int=precision(BigFloat)
    ) where {T<:Integer} -> IrrationalContinuedFraction{T,typeof(c)}

Constructs an `IrrationalContinuedFraction` for the given irrational number `c`.

# Arguments
- `c`: The irrational number for which the continued fraction is to be constructed.
- `T`: The type of the integers in the continued fraction.
    Defaults to `Int`.
- `prec`: The precision to be used for the continued fraction.
    Defaults to the precision of `BigFloat` (256).

# Examples
```jldoctest
julia> continuedfraction(pi)
IrrationalContinuedFraction{Int64, Irrational{:π}}(256, Int64[])

julia> continuedfraction(pi, BigInt)
IrrationalContinuedFraction{BigInt, Irrational{:π}}(256, BigInt[])

julia> continuedfraction(pi, BigInt; prec=1024)
IrrationalContinuedFraction{BigInt, Irrational{:π}}(1024, BigInt[])
```
"""
function continuedfraction(
        c::AbstractIrrational,
        ::Type{T}=Int
        ; prec::Int=precision(BigFloat)
    ) where {T<:Integer}
    IrrationalContinuedFraction{T,typeof(c)}(prec, T[])
end

#= Iteration Interfaces =#
Base.length(cf::IrrationalContinuedFraction) = length(quotients(cf))
# Never stop
Base.isdone(cf::IrrationalContinuedFraction, idx::Int=1) = false
Base.iterate(cf::IrrationalContinuedFraction, idx::Int=1) = (cf[idx], idx+1)
# getindex will lazily get the value with the specified precision.
function Base.getindex(cf::IrrationalContinuedFraction, i::Int)
    while i > length(cf)
        # keep doubling precision until sufficient accuracy obtained
        compute!(cf, cf.precision*2)
    end
    cf.quotients[i]
end
# Syntax like cf[1:end]
function getindex(cf::IrrationalContinuedFraction, r::AbstractVector)
    [cf[i] for i in r]
end

eps_error(c::AbstractIrrational) = 1<<20  # assume accurate to within 20 bits?

function compute!(cf::IrrationalContinuedFraction{T,C}, prec::Int) where {T<:Integer,C}
    setprecision(BigFloat, prec) do
        qs = T[]
        r = big(1.0)
        r_p = big(C())
        
        ϵ = big(0.0)
        ϵ_p = eps(r_p) * eps_error(C())

        while true
            a, r_n = divrem(r_p, r)
            ϵ_n = ϵ_p + a*ϵ
            if r_n < ϵ_n || r-r_n < ϵ_n
                break
            end
            push!(qs,a)
            r, r_p = r_n, r
            ϵ, ϵ_p = ϵ_n, ϵ
        end
        cf.precision = prec
        cf.quotients = qs
    end
    cf
end


#= Special cases with known patterns =#
function getindex(::IrrationalContinuedFraction{T,Irrational{:e}}, i::Int) where {T<:Integer}
    i >= 1 || throw(BoundsError())
    if i==1
        2
    elseif i % 3 == 0
        2*div(i,3)
    else
        1
    end
end

function getindex(::IrrationalContinuedFraction{T,Irrational{:φ}}, i::Int) where {T<:Integer}
    i >= 1 || throw(BoundsError())
    1
end
