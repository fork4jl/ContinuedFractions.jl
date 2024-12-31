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

    @testset "Iteration Interfaces" begin
        cf_pi = continuedfraction(3.1415926)
        @test length(cf_pi) > 0
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

    @testset "getindex()" begin
        # Special cases
        # \euler ℯ = 2.7182818284590...
        @test continuedfraction(MathConstants.ℯ)[1:5] == [2, 1, 2, 1, 1]

        # golden (φ = 1.6180339887498...)
        for i in rand(1:1000, 5)
            @test continuedfraction(MathConstants.φ)[i] == 1
        end
    end
end

@testset "ConvergentIterator" begin
    # Rational: Finite
    finite_cf = convergents(3.14)
    # Irrational: infinite
    inf_cf = convergents(pi)
    @test Base.IteratorSize(finite_cf) == Base.HasLength()
    @test_broken Base.IteratorSize(inf_cf) == Base.IsInfinite()
    @test length(finite_cf) > 0
    @test length(inf_cf) == 0
    @test eltype(finite_cf) == Rational{Int}
    @test eltype(inf_cf) == Rational{Int}
    # @test !Base.isdone(finite_cf)
    # @test !Base.isdone(inf_cf)
    # Calc
    # @test finite_cf[1] == 3
    # @test inf_cf[1] == 3
end

include("oeis_ref.jl")
