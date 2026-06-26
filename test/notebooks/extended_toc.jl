### A Pluto.jl notebook ###
# v1.0.1

#> custom_attrs = ["enable_hidden", "hide-enabled"]

using Markdown
using InteractiveUtils

# ╔═╡ 464fc674-5ed7-11ed-0aff-939456ebc5a8
begin
	using HypertextLiteral
	using PlutoUI
	using PlutoDevMacros
end

# ╔═╡ e1d8a572-21ec-4db9-a640-f3521a16cb1f
@frompackage "../.." begin
	using ^.ExtendedToc: *
end

# ╔═╡ d05d4e8c-bf50-4343-b6b5-9b77caa646cd
ExtendedTableOfContents()

# ╔═╡ 48540378-5b63-4c20-986b-75c08ceb24b7
md"""
# Tests
"""

# ╔═╡ 7dce5ffb-48ad-4ef4-9e13-f7a34794170a
md"""
The weird looking 3 below is inside a hidden cell that has been tagged with `show_output_when_hidden`
"""

# ╔═╡ 091dbcb6-c5f6-469b-889a-e4b23197d2ad
md"""
## very very very very very very very very very long
"""

# ╔═╡ c9bcf4b9-6769-4d5a-bbc0-a14675e11523
md"""
### Short
"""

# ╔═╡ 4373ab10-d4e7-4e25-b7a8-da1fcf3dcb0c
# ╠═╡ custom_attrs = ["toc-hidden"]
md"""
## Hidden Heading
"""

# ╔═╡ 77e467b9-c86c-4f13-a259-c38dfd80a3aa
2 # This will be completely hidden

# ╔═╡ f6e74270-bd75-4367-a0b2-1e10e1336b6c
# ╠═╡ skip_as_script = true
#=╠═╡
3 |> show_output_when_hidden # This will keep showing
  ╠═╡ =#

# ╔═╡ 6ddee4cb-7d76-483e-aed5-bde46280cc5b
md"""
## Random JS Tests
"""

# ╔═╡ 239b3956-69d7-43dc-80b8-92f43b84aada
@htl """
<div class='parent'>
	<span class='child first'></span>
	<span class='child second'></span>
	<span class='child third'></span>
</div>
<style>
	div.parent {
		position: fixed;
		top: 30px;
		left: 30px;
		background: lightblue;
		display: flex;
		height: 30px;
	}
	span.child {
		align-self: stretch;
		width: 20px;
		display: inline-block;
		background: green;
		margin: 5px 0px;
	}
</style>
""";

# ╔═╡ c4490c71-5994-4849-914b-ec1a88ec7881
# ╠═╡ custom_attrs = ["toc-collapsed"]
md"""
# Fillers
"""

# ╔═╡ fd6772f5-085a-4ffa-bf55-dfeb8e93d32b
md"""
## More Fillers
"""

# ╔═╡ 863e6721-98f1-4311-8b9e-fa921030f7d7
md"""
## More Fillers
"""

# ╔═╡ 515b7fc0-1c03-4c82-819b-4bf70baf8f14
md"""
## More Fillers
"""

# ╔═╡ e4a29e2e-c2ec-463b-afb2-1681c849780b
md"""
## More Fillers
"""

# ╔═╡ eb559060-5da1-4a9e-af51-9007392885eb
md"""
## More Fillers
"""

# ╔═╡ 1aabb7b3-692f-4a27-bb34-672f8fdb0753
md"""
## More Fillers
"""

# ╔═╡ ac541f37-7af5-49c8-99f8-c5d6df1a6881
md"""
## More Fillers
"""

# ╔═╡ fdf482d1-f8fa-4628-9417-2816de367e94
md"""
## More Fillers
"""

# ╔═╡ 6de511d2-ad79-4f0e-95ff-ce7531f3f0c8
md"""
## More Fillers
"""

# ╔═╡ a8bcd2cc-ae01-4db7-822f-217c1f6bbc8f
md"""
## More Fillers
"""

# ╔═╡ 9ddc7a20-c1c9-4af3-98cc-3b803ca181b5
md"""
## More Fillers
"""

# ╔═╡ 6dd2c458-e02c-4850-a933-fe9fb9dcdf39
md"""
## More Fillers
"""

# ╔═╡ Cell order:
# ╠═464fc674-5ed7-11ed-0aff-939456ebc5a8
# ╠═e1d8a572-21ec-4db9-a640-f3521a16cb1f
# ╠═d05d4e8c-bf50-4343-b6b5-9b77caa646cd
# ╠═48540378-5b63-4c20-986b-75c08ceb24b7
# ╟─7dce5ffb-48ad-4ef4-9e13-f7a34794170a
# ╠═091dbcb6-c5f6-469b-889a-e4b23197d2ad
# ╠═c9bcf4b9-6769-4d5a-bbc0-a14675e11523
# ╟─4373ab10-d4e7-4e25-b7a8-da1fcf3dcb0c
# ╠═77e467b9-c86c-4f13-a259-c38dfd80a3aa
# ╠═f6e74270-bd75-4367-a0b2-1e10e1336b6c
# ╟─6ddee4cb-7d76-483e-aed5-bde46280cc5b
# ╠═239b3956-69d7-43dc-80b8-92f43b84aada
# ╠═c4490c71-5994-4849-914b-ec1a88ec7881
# ╠═fd6772f5-085a-4ffa-bf55-dfeb8e93d32b
# ╠═863e6721-98f1-4311-8b9e-fa921030f7d7
# ╠═515b7fc0-1c03-4c82-819b-4bf70baf8f14
# ╠═e4a29e2e-c2ec-463b-afb2-1681c849780b
# ╠═eb559060-5da1-4a9e-af51-9007392885eb
# ╠═1aabb7b3-692f-4a27-bb34-672f8fdb0753
# ╠═ac541f37-7af5-49c8-99f8-c5d6df1a6881
# ╠═fdf482d1-f8fa-4628-9417-2816de367e94
# ╠═6de511d2-ad79-4f0e-95ff-ce7531f3f0c8
# ╠═a8bcd2cc-ae01-4db7-822f-217c1f6bbc8f
# ╠═9ddc7a20-c1c9-4af3-98cc-3b803ca181b5
# ╠═6dd2c458-e02c-4850-a933-fe9fb9dcdf39
