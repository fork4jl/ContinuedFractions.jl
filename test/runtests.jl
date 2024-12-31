using ContinuedFractions
using Test

include("OEIS.jl")
import .OEIS

@testset "ContinuedFraction" begin
    @testset "eltype" begin
        # FiniteContinuedFraction{T<:Integer}
        @test eltype(continuedfraction(1//42)) == Int
        @test eltype(continuedfraction(big"1"//42)) == BigInt
        # IrrationalContinuedFraction{T<:Integer, C}
        @test eltype(continuedfraction(pi, Int32)) == Int32
        @test eltype(continuedfraction(pi, BigInt)) == BigInt
    end
end

@testset "FiniteContinuedFraction" begin
    @test quotients(continuedfraction(1//42)) == [0, 42]
    
    @testset "continuedfraction" begin
        # continuedfraction(x::Real, y::Real, ::Type{T}=Int)
        @test quotients(continuedfraction(73, 71)) == [1,35,2]
        @test quotients(continuedfraction(100,1)) == [100]

        # continuedfraction(x::AbstractFloat, ::Type{T}=Int)
        @test quotients(continuedfraction(1.25)) == [1,4]

        # continuedfraction(x::Rational{T})
        @test quotients(continuedfraction(1/4)) == [0,4]
    end
end

@testset "IrrationalContinuedFraction" begin
    @testset "continuedfraction" begin
        # continuedfraction(c::AbstractIrrational, T； prec)
        @test isempty(quotients(continuedfraction(pi)))
        @test isempty(quotients(continuedfraction(pi, Int)))
        @test isempty(quotients(continuedfraction(pi, Int; prec=64)))
    end

    @testset "Iteration Interfaces" begin
        cf_pi = continuedfraction(pi)
        @test Base.IteratorSize(cf_pi) == Base.IsInfinite()
        @test length(cf_pi) == 0
        @test !Base.isdone(cf_pi)
        @test eltype(cf_pi) == Int
        # Calc
        @test cf_pi[1] == 3
        # [3  7  15  1  292  1  1  1  2  1]
        @test length(cf_pi[1:10]) == 10
        @test length(cf_pi) >= 10
        @test !Base.isdone(cf_pi)
    end
end

end

include("oeis_ref.jl")
