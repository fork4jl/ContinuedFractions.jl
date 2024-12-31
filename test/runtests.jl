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

