using StackViews, OffsetArrays
using Test
using Aqua, Documenter

@testset "Project meta quality checks" begin
    # Not checking compat section for test-only dependencies
    Aqua.test_all(StackViews; project_extras=true, deps_compat=true, stale_deps=true, project_toml_formatting=true)
    if VERSION >= v"1.2"
        doctest(StackViews, manual = false)
    end
end

@testset "StackViews.jl" begin
    A = reshape(collect(1:12), 3, 4)
    B = reshape(collect(13:24), 3, 4)

    sv = @inferred StackView([A, B])
    @test size(sv) == (3, 4, 2)
    @test collect(sv) == cat(A, B; dims=3)

    sv = @inferred StackView((A, B))
    @test size(sv) == (3, 4, 2)
    @test collect(sv) == cat(A, B; dims=3)

    sv = @inferred StackView([A, B], Val(3))
    @test size(sv) == (3, 4, 2)
    @test collect(sv) == cat(A, B; dims=3)

    sv = @inferred StackView([A, B], Val(1))
    @test size(sv) == (2, 3, 4)
    @test sv[1, :, :] == A
    @test sv[2, :, :] == B

    sv = @inferred StackView([A, B], Val(2))
    @test size(sv) == (3, 2, 4)
    @test sv[:, 1, :] == A
    @test sv[:, 2, :] == B

    sv = @inferred StackView([A, B], Val(3))
    @test size(sv) == (3, 4, 2)
    @test sv[:, :, 1] == A
    @test sv[:, :, 2] == B

    sv = @inferred StackView([A, B], Val(4))
    @test size(sv) == (3, 4, 1, 2)
    @test sv[:, :, 1, 1] == A
    @test sv[:, :, 1, 2] == B

    sv = @inferred StackView([A, B], Val(5))
    @test size(sv) == (3, 4, 1, 1, 2)
    @test sv[:, :, 1, 1, 1] == A
    @test sv[:, :, 1, 1, 2] == B

    @test StackView([A, B], 1) == StackView([A, B], Val(1))
    @test StackView(A) == StackView([A, ]) == StackView((A, ))

    @test_throws ArgumentError StackView([A, B[:]])
    @test_throws ArgumentError StackView([A, B], 0)
    @test_throws ArgumentError StackView([A, B], Val(0))

    @testset "axes" begin
        # axes are unified to 1-based
        A = OffsetArray(collect(reshape(1:8, 2, 4)), -1, 1)
        B = OffsetArray(collect(reshape(9:16, 2, 4)), 1, -1)
        @test axes(StackView([A, B], 1)) == (Base.OneTo(2), Base.OneTo(2), Base.OneTo(4))
    end

    @testset "setindex!" begin
        # setindex! modifies original arrays
        for dim in 1:3
            A = [0, 1, 2, 3]
            B = [4, 5, 6, 7]
            sv = StackView([A, B], dim)
            fill!(sv, -1)
            @test A == B == fill(-1, 4)
        end
    end
end
