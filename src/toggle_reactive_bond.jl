### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 92fc726a-b68e-11ed-1080-474bdf47330c
begin
	using PlutoUI
	using HypertextLiteral
	import AbstractPlutoDingetjes.Bonds
end

# ╔═╡ 7727436c-37c1-48fb-89ac-db60336e7ae6
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	using PlutoExtras
end
  ╠═╡ =#

# ╔═╡ 063c10d6-71f0-4b04-b380-9517702277d9
#=╠═╡
ExtendedTableOfContents(;hide_preamble=false)
  ╠═╡ =#

# ╔═╡ 63014e61-9072-4879-a815-dcc61c9eacb1
md"""
# Structure
"""

# ╔═╡ 7942f2fd-4277-477f-b096-7c286ea776ab
begin
	Base.@kwdef struct ToggleReactiveBond
		element::Any
		description::Any
		secret_key::String=String(rand('a':'z', 10))
	end
	ToggleReactiveBond(element; description = "") = ToggleReactiveBond(;element, description)

	function Bonds.initial_value(r::ToggleReactiveBond)
		Bonds.initial_value(r.element)
	end
	function Bonds.validate_value(r::ToggleReactiveBond, from_js)
		Bonds.validate_value(r.element, from_js)
	end
	function Bonds.transform_value(r::ToggleReactiveBond, from_js)
		Bonds.transform_value(r.element, from_js)
	end
	function Bonds.possible_values(r::ToggleReactiveBond)
		Bonds.possible_values(r.element)
	end
end

# ╔═╡ 8fb09537-2a5e-4051-96f6-dfa6431eb7e4
export ToggleReactiveBond

# ╔═╡ b88012e8-62ac-4b2d-8b6d-5a6b4a26e63d
_style = @htl """
<style>
$(CSS_PARTS.togglereactive)
</style>
"""

# ╔═╡ 74ed3df0-b019-45ea-ace4-454036b842e0
md"""
## Show
"""

# ╔═╡ eab3736c-f200-480b-bed4-8f16571eaf51
_show(r::ToggleReactiveBond) = @htl("""
<togglereactive-container>
	<togglereactive-header>
		<span class='description'>$(r.description)</span>
		<input type='checkbox' class='toggle' checked>
	</togglereactive-header>
	$(r.element)
	<script id=$(r.secret_key)>
		const parent = currentScript.parentElement
		const el = currentScript.previousElementSibling
		const toggle = parent.querySelector('togglereactive-header .toggle')

		const set_input_value = setBoundElementValueLikePluto
		const get_input_value = getBoundElementValueLikePluto

		// We use clone to avoid pointing to the same array
		let public_value = _.cloneDeep(get_input_value(el))

		function dispatch() {
			public_value = _.cloneDeep(get_input_value(el))
			parent.dispatchEvent(new CustomEvent('input'))
		}

		const old_oninput = el.oninput ?? function(e) {}
		el.oninput = (e) => {
			old_oninput(e)
			if (toggle.checked) {dispatch()}
		}

		toggle.oninput = e => {
			if (toggle.checked && !_.isEqual(get_input_value(el), public_value)) {
				dispatch()
			}
			e.stopPropagation()
		}

		Object.defineProperty(parent, 'value', {
			get: () => public_value,
			set: (newval) => {
				public_value = newval
				
				set_input_value(el, newval)
				toggle.checked = true
			},
			configurable: true,
		});
	</script>
	$_style
</togglereactive-container>
""")

# ╔═╡ db4fb885-6cab-4bd2-9c98-c5eba7e55739
function Base.show(io::IO, mime::MIME"text/html", r::ToggleReactiveBond)
show(io, mime, _show(r))
end

# ╔═╡ 338b3e15-7989-4672-864b-4ff0e2b76e85
md"""
# Tests
"""

# ╔═╡ ec4d7190-8ea3-425d-aa0e-4013623b893c
# ╠═╡ skip_as_script = true
#=╠═╡
a = PlutoUI.combine() do x
	@htl """
	<ul>
	 <li>This is magic $(x("magic", Editable(1)))</li>
	 <li>This is Power $(x("power", Editable(1)))</li>
	</ul>	
	"""
end
  ╠═╡ =#

# ╔═╡ 9c8259f4-3b02-4cb3-98fa-7e77788c13ce
#=╠═╡
ToggleReactiveBond(a; description = "ASD") |> _show
  ╠═╡ =#

# ╔═╡ 1fcf0b4f-cfc4-47ae-abba-e39bbf53a03c
#=╠═╡
bohoh = @bind asdasd ToggleReactiveBond(a; description = "ASD")
  ╠═╡ =#

# ╔═╡ d6123bcb-5304-4092-bea9-086193a97df5
#=╠═╡
bohoh
  ╠═╡ =#

# ╔═╡ 236ccdf4-e1f3-4aaf-b961-887c814f6e12
#=╠═╡
let
	# sleep(.5)
	asdasd
end
  ╠═╡ =#

# ╔═╡ 55e8e027-d2e6-4ab5-899b-613188dd1648
# ╠═╡ skip_as_script = true
#=╠═╡
@bind gesu ToggleReactiveBond(Slider(1:10); description= "GESU")
  ╠═╡ =#

# ╔═╡ 58b460c4-867a-4b6a-8ccb-d3da1416d473
#=╠═╡
gesu
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoExtras = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
HypertextLiteral = "~0.9.4"
PlutoExtras = "~0.6.1"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-beta4"
manifest_format = "2.0"
project_hash = "bea7b2497eeb74421abbcb04d00817039c813344"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Random", "Requires"]
git-tree-sha1 = "fa04003441d7c80b4812bd7f9678f721498259e7"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.0"

[[deps.PlutoExtras]]
deps = ["AbstractPlutoDingetjes", "HypertextLiteral", "InteractiveUtils", "Markdown", "OrderedCollections", "PlutoDevMacros", "PlutoUI"]
git-tree-sha1 = "8ec757f56d593959708dcd0b2d99b3c18cef428c"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.6.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.4.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═92fc726a-b68e-11ed-1080-474bdf47330c
# ╠═7727436c-37c1-48fb-89ac-db60336e7ae6
# ╠═063c10d6-71f0-4b04-b380-9517702277d9
# ╠═8fb09537-2a5e-4051-96f6-dfa6431eb7e4
# ╟─63014e61-9072-4879-a815-dcc61c9eacb1
# ╠═7942f2fd-4277-477f-b096-7c286ea776ab
# ╠═b88012e8-62ac-4b2d-8b6d-5a6b4a26e63d
# ╟─74ed3df0-b019-45ea-ace4-454036b842e0
# ╠═eab3736c-f200-480b-bed4-8f16571eaf51
# ╠═db4fb885-6cab-4bd2-9c98-c5eba7e55739
# ╟─338b3e15-7989-4672-864b-4ff0e2b76e85
# ╠═ec4d7190-8ea3-425d-aa0e-4013623b893c
# ╠═9c8259f4-3b02-4cb3-98fa-7e77788c13ce
# ╠═1fcf0b4f-cfc4-47ae-abba-e39bbf53a03c
# ╠═d6123bcb-5304-4092-bea9-086193a97df5
# ╠═236ccdf4-e1f3-4aaf-b961-887c814f6e12
# ╠═55e8e027-d2e6-4ab5-899b-613188dd1648
# ╠═58b460c4-867a-4b6a-8ccb-d3da1416d473
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
