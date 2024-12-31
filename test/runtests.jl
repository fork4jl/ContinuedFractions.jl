using ContinuedFractions
using Test

@testset "ContinuedFractions.jl" begin
    cf = ContinuedFraction(sqrt(2))
    @test quotients(cf)[1] == 1
    for i in 2:15
        @test quotients(cf)[i] == 2
    end
    @test abs(collect(convergents(cf))[end] - sqrt(2)) < 10e-16
    
    cf = ContinuedFraction(sqrt(3))
    @test quotients(cf)[1] == 1
    for i in 2:15
        if mod(i, 2) == 0
            @test quotients(cf)[i] == 1
        else
            @test quotients(cf)[i] == 2
        end
    end
    @test abs(collect(convergents(cf))[end] - sqrt(3)) < 10e-16
    @test abs(collect(convergents(sqrt(3)))[end] - sqrt(3)) < 10e-16

    cf = ContinuedFraction(1ℯ)
    @test quotients(cf)[1] == 2
    for i in 2:15
        if mod(i, 3) == 0
            @test quotients(cf)[i] == fld(i, 3) * 2
        else
            @test quotients(cf)[i] == 1
        end
    end

    @test eltype(convergents(1//42)) === Rational{Int}
    @test eltype(convergents(big"1"/10)) === Rational{BigInt}

    # Rational
    @test collect(convergents(1//42))[end] == 1//42
    # BigFloat
    @test collect(convergents(big"1"/10))[end] == 1//10
    # AbstractFloat
    @test collect(convergents(3.14))[end] == 157//50
    # Integer
    @test collect(convergents(42))[end] == 42
end
