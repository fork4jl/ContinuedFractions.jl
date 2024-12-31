using ContinuedFractions
using Test

# include("OEIS.jl")
# import .OEIS
# include("cmp_oeis.jl")

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
    @test isempty(quotients(continuedfraction(pi, Int)))
end
