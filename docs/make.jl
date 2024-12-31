using ContinuedFractions
using Documenter

DocMeta.setdocmeta!(ContinuedFractions, :DocTestSetup, :(using ContinuedFractions); recursive=true)

makedocs(;
    modules=[ContinuedFractions],
    authors="John Myles White <jmw@johnmyleswhite.com> and contributors",
    sitename="ContinuedFractions.jl",
    format=Documenter.HTML(;
        canonical="https://fork4jl.github.io/ContinuedFractions.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/fork4jl/ContinuedFractions.jl",
    devbranch="main",
    push_preview = true,
)
