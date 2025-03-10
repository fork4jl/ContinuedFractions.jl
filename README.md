# ContinuedFractions.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://fork4jl.github.io/ContinuedFractions.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://fork4jl.github.io/ContinuedFractions.jl/dev/)
[![Build Status](https://github.com/fork4jl/ContinuedFractions.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/fork4jl/ContinuedFractions.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/fork4jl/ContinuedFractions.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/fork4jl/ContinuedFractions.jl)


## Usage

```julia
julia> using ContinuedFractions

julia> cf = ContinuedFraction(sqrt(2))
ContinuedFraction{Int64}([1, 2, 2, 2, 2, 2, 2, 2, 2, 2  …  2, 2, 2, 2, 2, 2, 2, 2, 2, 3])

julia> collect(convergents(cf))
21-element Vector{Rational{Int64}}:
         1
        3//2
        7//5
       17//12
       41//29
       99//70
      239//169
      577//408
     1393//985
     3363//2378
     8119//5741
    19601//13860
    47321//33461
   114243//80782
   275807//195025
   665857//470832
  1607521//1136689
  3880899//2744210
  9369319//6625109
 22619537//15994428
 77227930//54608393
```

For additional significant digits you can use BigInt / BigFloat.

```julia
julia> cf = ContinuedFraction(sqrt(big(2)))
ContinuedFraction{BigInt}(BigInt[1, 2, 2, 2, 2, 2, 2, 2, 2, 2  …  2, 2, 2, 2, 2, 2, 2, 2, 2, 2])

julia> collect(convergents(cf))
101-element Vector{Rational{BigInt}}:
                                        1
                                       3//2
                                       7//5
                                      17//12
                                      41//29
                                      99//70
                                     239//169
                                     577//408
                                    1393//985
                                    3363//2378
                                    8119//5741
                                   19601//13860
                                   47321//33461
                                  114243//80782
                                        ⋮
      2416742135893203745440147513823297//1708894752669345122781412283638152
      5834531641231893991002972081099601//4125636888562548868221559797461449
     14085805418356991727446091676022499//9960168529794442859224531878561050
     34006142477945877445895155433144599//24045973948151434586670623554583549
     82098090374248746619236402542311697//58052116426097312032565778987728148
    198202323226443370684367960517767993//140150206800346058651802181530039845
    478502736827135487987972323577847683//338352530026789429336170142047807838
   1155207796880714346660312607673463359//816855266853924917324142465625655521
   2788918330588564181308597538924774401//1972063063734639263984455073299118880
   6733044458057842709277507685523012161//4760981394323203445293052612223893281
  16255007246704249599863612909970798723//11494025852381046154570560297746905442
  39243058951466341909004733505464609607//27749033099085295754434173207717704165
  94741125149636933417873079920900017937//66992092050551637663438906713182313772
 228725309250740208744750893347264645481//161733217200188571081311986634082331709
```
