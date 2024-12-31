
struct ConvergentIterator{T<:Integer, CF<:ContinuedFraction{T}}
    cf::CF
end

ConvergentIterator(cf::ContinuedFraction{T}) where {T<:Integer} = ConvergentIterator{T,typeof(cf)}(cf)

convergents(x::Real) = ConvergentIterator(continuedfraction(x))

start(it::ConvergentIterator{T,CF}) where {T,CF} = start(it.cf), one(T)//zero(T), zero(T)//one(T)
done(it::ConvergentIterator, state) = done(it.cf, state[1])
length(it::ConvergentIterator) = length(it.cf)
function next(it::ConvergentIterator, state)
    i, r, r_p  = state
    q, i_n = next(it.cf, i)
    r_n = (q*r.num + r_p.num) // (q*r.den + r_p.den)
    return r_n, (i_n, r_n, r)
end

eltype(it::ConvergentIterator{T,CF}) where {T,CF} = Rational{T}
