using StackViews
using Documenter

DocMeta.setdocmeta!(StackViews, :DocTestSetup, :(using StackViews); recursive=true)

makedocs(;
    modules=[StackViews],
    authors="Johnny Chen <johnnychen94@hotmail.com>",
    repo="https://github.com/johnnychen94/StackViews.jl/blob/{commit}{path}#{line}",
    sitename="StackViews.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://johnnychen94.github.io/StackViews.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/johnnychen94/StackViews.jl",
)
