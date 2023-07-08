### A Pluto.jl notebook ###
# v0.19.26

#> custom_attrs = ["hide-enabled"]

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 2c10fde6-1ce6-11ee-1f38-ef9446c08803
begin
	using PlutoDevMacros
	using PlutoDevMacros.Script
end

# ╔═╡ e9c919e6-92d1-4e63-8d05-eee7db825968
@fromparent begin
	using >.HypertextLiteral
	using >.PlutoUI
	import >.AbstractPlutoDingetjes.Bonds
	import ^: ExtendedTableOfContents
	using *
end

# ╔═╡ 480dcb48-c075-418e-b4ef-4e4069d08842
# ╠═╡ skip_as_script = true
#=╠═╡
ExtendedTableOfContents()
  ╠═╡ =#

# ╔═╡ d88782bf-c584-40cd-b214-384c487eec6e
md"""
# Notebook Local Variables
"""

# ╔═╡ f08e8305-3f65-4dd7-8904-d17b1975091a
@only_in_nb begin
	"""
Magical Structure
"""
Base.@kwdef struct ASD
	"magical *field* ``\\alpha``"
	α::Int
	"Normal field `b`"
	b::Int
end
@addmethod fieldbond(::Type{ASD}, ::Val{:α}) = Scrubbable(1:10)
@addmethod fieldbond(::Type{ASD}, ::Val{:b}) = Slider(1:10)
@addmethod fielddescription(::Type{ASD}, ::Val{:b}) = md"``\alpha``"
end

# ╔═╡ 197f3a30-36ba-405a-b670-c396f40c36f4
md"""
# Load inner modules
"""

# ╔═╡ 4027d2a5-d61c-43fa-908b-3202b3bc69aa
md"""
# StructBond Definition
"""

# ╔═╡ b203525d-6d1a-4526-b513-4f9fcc344b35
begin
"""
	StructBond(T;description = typedescription(T))
Create an HTML widget to be used with `@bind` from Pluto that allows to define the custom type `T` by assigning a widget to each of its fields. 
The widget will automatically use the docstring of each field as its description if present, or the fieldname otherwise.

When used with `@bind`, it automatically generates a instance of `T` by using the various fields as keyword arguments. *This means that the the structure `T` has to support a keyword-only contruction, such as those generated with `Base.@kwdef` or `Parameters.@with_kw`.

In order to work, the widget (and optionally the description) to associate to eachfield of type `T` has to be provided using the convenience macro `@fielddata`. 

The optional `description` kwarg default to the Type name but can be overridden with anything showable as `MIME"text/html"` 

See also: [`BondTable`](@ref), [`@NTBond`](@ref), [`@BondsList`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fielddata`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
	Base.@kwdef struct StructBond{T}
		widget::Any
		description::Any
		secret_key::String=String(rand('a':'z', 10))
	end
	StructBond(::Type{T}; description = typedescription(T)) where T = StructBond{T}(;widget = typehtml(T), description)
end

# ╔═╡ 7f36e8ae-934d-4537-83c9-7c628b21f0d7
md"""
## structbondtype
"""

# ╔═╡ 9d1de1e3-9275-4a10-b2a6-0ab01dfa9c58
structbondtype(::StructBond{T}) where T = T

# ╔═╡ 862ebfcd-72d8-449e-9795-130f23597c64
structbondtype(::Type{StructBond{T}}) where T = T

# ╔═╡ a51e8156-610e-456e-95de-6dbbabda0c54
md"""
## Show
"""

# ╔═╡ 2299e5e1-6bee-45b6-b8a3-501c0b87b052
_basics_script = HTLScript(@htl("""
<script>
	const parent = currentScript.parentElement
	const widget = currentScript.previousElementSibling

	// Overwrite the description
	const desc = widget.querySelector('.description')
	desc.innerHTML = 

	// Set-Get bond

	const set_input_value = setBoundElementValueLikePluto
	const get_input_value = getBoundElementValueLikePluto

	Object.defineProperty(parent, 'value', {
		get: () => get_input_value(widget),
		set: (newval) => {
			set_input_value(widget, newval)
		},
		configurable: true,
	});

	const old_oninput = widget.oninput ?? function(e) {}
	widget.oninput = (e) => {
		old_oninput(e)
		e.stopPropagation()
		parent.dispatchEvent(new CustomEvent('input'))
	}
</script>
"""));

# ╔═╡ 93aacc1a-9ad5-41e7-90ad-ffb6f2a109f2
_show(t::StructBond{T}) where T = @htl("""
<struct-bond class='$T'>
	$(t.widget)
	<script id = $(t.secret_key)>
		
		const parent = currentScript.parentElement
		const widget = currentScript.previousElementSibling
	
		// Overwrite the description
		const desc = widget.querySelector('.description')
		desc.innerHTML = $(t.description)
	
		// Set-Get bond
	
		const set_input_value = setBoundElementValueLikePluto
		const get_input_value = getBoundElementValueLikePluto
	
		Object.defineProperty(parent, 'value', {
			get: () => get_input_value(widget),
			set: (newval) => {
				set_input_value(widget, newval)
			},
			configurable: true,
		});
	
		const old_oninput = widget.oninput ?? function(e) {}
		widget.oninput = (e) => {
			old_oninput(e)
			e.stopPropagation()
			parent.dispatchEvent(new CustomEvent('input'))
		}
	</script>
	<style>
		/* The flex below is needed in some weird cases where the bond is display flex and the child becomes small. */
		struct-bond {
  			flex: 1;
		}
	</style>
	</struct-bond>
""")

# ╔═╡ cc5f8c55-e40e-4421-85b0-9c268b623d1b
# ╠═╡ skip_as_script = true
#=╠═╡
@bind asdfasdf (StructBond(ASD) |> _show)
  ╠═╡ =#

# ╔═╡ 62614bf2-5661-4454-86f0-b5166cba448d
#=╠═╡
asdfasdf
  ╠═╡ =#

# ╔═╡ 68dd13c3-4799-4d18-bb13-93bf5f8283bf
Base.show(io::IO, mime::MIME"text/html", t::StructBond) = show(io, mime, _show(t))

# ╔═╡ e243f802-5f69-4f45-83eb-de993e0c95f5
begin
	function Bonds.initial_value(t::StructBond{T}) where T
		transformed = Bonds.initial_value(t.widget)
		typeconstructor(T)(transformed)
	end
	function Bonds.transform_value(t::StructBond{T}, from_js) where T
		transformed = Bonds.transform_value(t.widget, from_js)
		typeconstructor(T)(transformed)
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"

[compat]
PlutoDevMacros = "~0.5.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "826daeda7b954256c3315394d715e1379bcb080a"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

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

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

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
version = "2.28.2+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "44b59480bdd690eb31b32f4ba3418e0731145cea"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

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
# ╠═2c10fde6-1ce6-11ee-1f38-ef9446c08803
# ╠═480dcb48-c075-418e-b4ef-4e4069d08842
# ╠═d88782bf-c584-40cd-b214-384c487eec6e
# ╠═f08e8305-3f65-4dd7-8904-d17b1975091a
# ╟─197f3a30-36ba-405a-b670-c396f40c36f4
# ╠═e9c919e6-92d1-4e63-8d05-eee7db825968
# ╟─4027d2a5-d61c-43fa-908b-3202b3bc69aa
# ╠═b203525d-6d1a-4526-b513-4f9fcc344b35
# ╟─7f36e8ae-934d-4537-83c9-7c628b21f0d7
# ╠═9d1de1e3-9275-4a10-b2a6-0ab01dfa9c58
# ╠═862ebfcd-72d8-449e-9795-130f23597c64
# ╠═a51e8156-610e-456e-95de-6dbbabda0c54
# ╠═2299e5e1-6bee-45b6-b8a3-501c0b87b052
# ╠═93aacc1a-9ad5-41e7-90ad-ffb6f2a109f2
# ╠═cc5f8c55-e40e-4421-85b0-9c268b623d1b
# ╠═62614bf2-5661-4454-86f0-b5166cba448d
# ╠═68dd13c3-4799-4d18-bb13-93bf5f8283bf
# ╠═e243f802-5f69-4f45-83eb-de993e0c95f5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
