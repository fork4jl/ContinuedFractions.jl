import Base.MathConstants: e, φ

struct IrrationalContinuedFraction{T<:Integer, C} <: ContinuedFraction{T}
    precision::Int
    quotients::Vector{T}
end

eps_error(c::AbstractIrrational) = 1<<20 # assume accurate to within 20 bits?

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

function continuedfraction(c::AbstractIrrational, ::Type{T}=Int) where {T<:Integer}
    cf = IrrationalContinuedFraction{T,typeof(c)}(precision(BigFloat),T[])
end

start(cf::IrrationalContinuedFraction) = 1
done(cf::IrrationalContinuedFraction, i::Int) = false
next(cf::IrrationalContinuedFraction, i::Int) = cf[i], i+1

function getindex(cf::IrrationalContinuedFraction, i::Integer)    
    while i > length(cf.quotients)
        # keep doubling precision until sufficient accuracy obtained
        compute!(cf, cf.precision*2)
    end
    cf.quotients[i]
end

function getindex(cf::IrrationalContinuedFraction, r::AbstractVector)
    [cf[i] for i in r]
end


# cases with known patterns
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
